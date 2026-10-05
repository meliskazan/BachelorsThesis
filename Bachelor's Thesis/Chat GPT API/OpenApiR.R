# Load packages
library(readxl)
library(dplyr)
library(ggplot2)

# Import Excel file
initial <- read_excel("fake_thesis_titles_labeled.xlsx")
# You can change the read_excel from fake_thesis_titles_labeled.xlsx to fake_balanced_data_1
# to see the graphs of that table.

# Rename gender labels
initial <- initial %>%
  mutate(`m/w` = recode(`m/w`,
                        "m" = "Male",
                        "w" = "Female"))

# View the data
View(initial)

# Calculate percentages
result <- initial %>%
  count(`m/w`, label) %>%
  group_by(`m/w`) %>%
  mutate(Percentage = n / sum(n) * 100)

# Calculate counts
count_result <- initial %>%
  count(`m/w`, label)

# Create grouped bar graph with numbers
ggplot(count_result, aes(x = `m/w`, y = n, fill = label)) +
  geom_col(position = "dodge") +

  labs(
    title = "Number of People and Things by Gender",
    x = "Gender",
    y = "Number of Theses",
    fill = "Category"
  ) +
  theme_minimal()

# Create grouped bar graph
ggplot(result, aes(x = `m/w`, y = Percentage, fill = label)) +
  geom_col(position = "dodge") +
  labs(
    title = "Percentage of People and Things by Gender",
    x = "Gender",
    y = "Percentage (%)",
    fill = "Category"
  ) +
  theme_minimal()