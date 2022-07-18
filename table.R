# I made this code while messing around with the Motivate table 1.
# Keeping it around in case it's helpful for developing tabler.
# Delete once you have a working version of tabler.


library(dplyr)
library(readr)
library(flextable)
library(officer)

table_ft <- read_rds("/Users/bradcannell/Desktop/table_ft.rds")

# Widen columns
table_ft <- table_ft %>% width(width = rep(1.57, 4))

# Merge cells
# table_ft <- table_ft %>%
#   merge_at(1, 2:4)

doc <- read_docx() %>% body_add_flextable(table_ft)

print(doc, "/Users/bradcannell/Desktop/table_ft.docx")


# All categories in one row
# Space between categories
test <- tribble(
  ~var, ~formatted_stats, ~Control,
  "Sex\n  Female\n  Male", "\n10 (20%)\n40 (80%)", "\n5 (21%)\n19 (79%)",
  "Married\n  No\n  Yes", "\n21 (42%)\n29 (58%)", "\n12 (50%)\n4 (50%)"
)

test_ft <- flextable(test) %>% autofit()
test_ft <- padding(test_ft, padding.top = 0, padding.bottom = 0, part = "body")
test_ft <- padding(test_ft, padding.bottom = 10, part = "body")

# Center column headings
test_ft <- align(test_ft, align = "center", part = "header")
# Center body text
test_ft <- align(test_ft, j = 2:3, align = "center", part = "body")

doc <- read_docx() %>% body_add_flextable(test_ft)
print(doc, "/Users/bradcannell/Desktop/test_ft.docx")



# Pasting together categories
test <- tribble(
  ~var,       ~formatted_stats, ~Control,
  "Sex",      NA,               NA,
  "  Female", "10 (20%)",       "5 (21%)",
  "  Male",   "40 (80%)",       "19 (79%)"
  # "Married",  NA,               NA,
  # "  No",     "21 (42%)",       "12 (50%)",
  # "  Yes",    "29 (58%)",       "12 (50%)"
)

# So, I need to get the columns above to look like the columns in the first version of test
# Maybe with paste
# test$var
# paste(test$var, collapse = "\n")

test <- test %>%
  mutate(
    across(
      everything(),
      function(x) {
        x <- paste(x, collapse = "\n")
        # Remove leading NA
        x <- stringr::str_remove(x, "^NA")
        x
      }
    )
  ) %>%
  slice(1)

test_ft <- flextable(test) %>% autofit()
test_ft <- padding(test_ft, padding.top = 0, padding.bottom = 0, part = "body")
test_ft <- padding(test_ft, padding.bottom = 10, part = "body")

# Center column headings
test_ft <- align(test_ft, align = "center", part = "header")
# Center body text
test_ft <- align(test_ft, j = 2:3, align = "center", part = "body")

doc <- read_docx() %>% body_add_flextable(test_ft)
print(doc, "/Users/bradcannell/Desktop/test_ft.docx")


# Trying again with the Motivate data
table <- read_rds("/Users/bradcannell/Desktop/table.rds")
test_ft <- flextable(table) %>% autofit()
test_ft <- padding(test_ft, padding.top = 0, padding.bottom = 0, part = "body")
test_ft <- padding(test_ft, padding.bottom = 10, part = "body")

# Center column headings
test_ft <- align(test_ft, align = "center", part = "header")
# Center body text
test_ft <- align(test_ft, j = 2:3, align = "center", part = "body")

doc <- read_docx() %>% body_add_flextable(test_ft)
print(doc, "/Users/bradcannell/Desktop/test_ft.docx")
