# tabler <- function(.data, .row_vars, .fns_list, .keep_na = FALSE) {
#
#   # ------------------------------------------------------------------
#   # Prevents R CMD check: "no visible binding for global variable ‘.’"
#   # ------------------------------------------------------------------
#   n = NULL
#
#   # ===========================================================================
#   # Checks
#   # ===========================================================================
#   # Check to make sure df is a data frame
#   if ( !("data.frame" %in% class(.data)) ) {
#     stop("Expecting .data to be of class data.frame. Instead it was ", class(.data))
#   }
#
#   # ===========================================================================
#   # Enquo arguments
#   # enquo/quo_name/UQ the ci_type and output argument so that I don't have to
#   # use quotation marks around the argument being passed.
#   # ===========================================================================
#   ci_type_arg <- rlang::enquo(ci_type) %>% rlang::quo_name()
#
#
# }
#
#
# # For testing
# devtools::load_all()
# study %>%
#   group_by(outcome) %>%
#   tabler(
#     .row_vars = c(
#       "Exposure, row percent (95% CI)"     = exposure,
#       "Age, mean (95% CI)"                 = age
#     ),
#     .fns_list = list(
#       cont_stats_fn = c(age),
#       cat_stats_fn  = c(exposure)
#     )
#   )
