#' @title Combine Calculated Statistics and Symbols for Publication and Dissemination
#'
#' @description The stat_format function is intended to make it quick and easy to
#'   format calculated statistics returned by R statistical functions and
#'   combine them with symbols so that they may more easily
#'   be inserted into tables intended for publication. For example, a proportion,
#'   a lower confidence limit, and an upper confidence limit spread across three
#'   columns could be formatted to two decimal places and combined with
#'   spaces, parentheses, and a hyphen as "24.00 (21.00 - 27.00)."
#'
#' @param .data A data frame of calculated statistics.
#'
#' @param .recipe A recipe used to create a new column of formatted statistics
#'   (optionally combined with symbols) from existing columns of statistical
#'   results. The recipe must be in the form of a quoted string. It may contain
#'   any combination of column names, spaces, and characters. For example:
#'   "n (percent)" or "percent (lcl - ucl)".
#'
#' @param .name An optional name to assign to the column created by the recipe.
#'   The default name is "formatted_stats"
#'
#' @param .digits The number of decimal places to display.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' library(dplyr)
#' library(tabler)
#'
#' data(study)
#'
#' results <- study %>%
#'   filter(!is.na(sex)) %>%
#'   count(sex) %>%
#'   mutate(percent = n / sum(n) * 100)
#'
#' print(results)
#'
#' # A tibble: 2 × 3
#'   sex        n percent
#'   <fct>  <int>   <dbl>
#' 1 Female    57    57.6
#' 2 Male      42    42.4
#'
#' results %>%
#'   stat_format("n (percent%)")
#'
#' # A tibble: 2 × 4
#'   sex        n percent formatted_stats
#'   <fct>  <int>   <dbl> <chr>
#' 1 Female    57    57.6 57 (57.5757575757576%)
#' 2 Male      42    42.4 42 (42.4242424242424%)
#'
#' results %>%
#'   stat_format("n (percent%)", .digits = 2)
#'
#' # A tibble: 2 × 4
#'   sex        n percent formatted_stats
#'   <fct>  <int>   <dbl> <chr>
#' 1 Female    57    57.6 57 (57.58%)
#' 2 Male      42    42.4 42 (42.42%)
#'
#' result %>%
#'   stat_format("n (percent%)", .name = "New Column Name", .digits = 2)
#'
#' # A tibble: 2 × 4
#'   sex        n percent `New Column Name`
#'   <fct>  <int>   <dbl> <chr>
#' 1 Female    57    57.6 57 (57.58%)
#' 2 Male      42    42.4 42 (42.42%)
#'
#'
stat_format <- function(.data, .recipe, .name = NA, .digits = NA) {

  # ===========================================================================
  # Prevents R CMD check: "no visible binding for global variable ‘.’"
  # ===========================================================================
  # .name = .recipe = ingredients = stat = NULL

  # ===========================================================================
  # Check function arguments
  # ===========================================================================
  # If no name given, default to formatted_stats
  if(is.na(.name)) {
    .name <- "formatted_stats"
  }

  # Break up the recipe into its component pieces
  # [1] "" "n" " (" "percent" ")"
  recipe <- stringr::str_split(.recipe, "\\b")
  # First component is always an empty string. Drop it.
  recipe <- unlist(recipe)[-1]

  # Loop over each row of the freq_table
  for(i in seq(nrow(.data))) {
    # Empty vector to hold the stats and symbols that will make up the new
    # variable in that row. The ingredients for the recipe.
    ingredients <- c()
    # Loop over each component of the recipe
    # [1] "n" " (" "percent" ")"
    for(j in seq_along(recipe)) {
      # If that the component is a column in the data frame then grab the value
      # for that column in that row and add it to the ingredients.
      if(recipe[j] %in% names(.data)){
        # Get the stat (e.g., n or percent)
        stat <- .data[[recipe[j]]][i]
        # Round the stat if an argument is supplied to the .digits argument
        if(!is.na(.digits)) {
          # But don't add trailing zeros to integers
          if(!is.integer(stat)) {
            stat <- round(stat, .digits)
            stat <- format(stat, nsmall = .digits, big.mark = ",")
            stat <- trimws(stat)
          }
        }
        ingredients <- c(ingredients, stat)
        # If that component is not a column in .data then add it to the
        # ingredients vector as a character.
      } else {
        ingredients <- c(ingredients, recipe[j])
      }
    }
    # Add the new variable to the .data
    .data[i, .name] <- paste(ingredients, collapse = "")
  }

  # Return .data with the new variable
  .data
}


# For testing
# library(dplyr)
# devtools::load_all()
# data(study)
# study %>% filter(!is.na(sex)) %>% count(sex) %>% mutate(percent = n / sum(n) * 100) %>% stat_format("n (percent%)", .digits = 2)
# study %>% count(sex) %>% mutate(percent = n / sum(n) * 100) %>% stat_format("n (percent%)", .name = "New Column Name")
