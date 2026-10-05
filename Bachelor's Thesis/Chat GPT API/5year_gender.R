library(readxl)
library(dplyr)
library(ggplot2)

# Load data
df <- read_excel("fake_thesis_titles_labeled_5_yearly.xlsx")
# For the code below to function, I put in the dataset 1 entry from every year. Except 
# 2025 has 3 entries.
# The plot will not look logical, because the data at hand is too little. 
# How the plot should actually look is in my thesis. (Fig. 14)
# The labels next to the thesis titles are also wrong. I copied and pasted
# the thesis titles multiple times under each other and changed their label for variation.

# Creating 5 year periods
df <- df %>%
  mutate(
    period_start = ifelse(
      year >= 2020,
      2020,
      floor(year / 5) * 5
    ),
    period = ifelse(
      year >= 2020,
      "2020-2025",
      paste0(
        floor(year / 5) * 5,
        "-",
        floor(year / 5) * 5 + 4
      )
    )
  )

# Counting by gender and period
frequency <- df %>%
  filter(
    label %in% c("people", "thing"),
    `m/w` %in% c("m", "w")
  ) %>%
  group_by(period_start, period, `m/w`, label) %>%
  summarise(
    count = n(),
    .groups = "drop"
  )


# Percentages
frequency <- frequency %>%
  group_by(period_start, period, `m/w`) %>%
  mutate(
    percentage = count / sum(count) * 100
  ) %>%
  ungroup() %>%
  arrange(period_start)


# Renaming for visual clarity
frequency <- frequency %>%
  mutate(
    gender_label = case_when(
      `m/w` == "m" & label == "people" ~ "Male people",
      `m/w` == "w" & label == "people" ~ "Female people",
      `m/w` == "m" & label == "thing"  ~ "Male thing",
      `m/w` == "w" & label == "thing"  ~ "Female thing"
    )
  )

# Linear regression
# Sources: 
# https://search.r-project.org/R/refmans/stats/html/lm.html
# https://stat.ethz.ch/R-manual/R-devel/library/stats/html/summary.lm.html
regression_results <- frequency %>%
  group_by(gender_label) %>%
  summarise(
    model = list(lm(percentage ~ period_start, data = cur_data())),
    .groups = "drop"
  )

# PLOOOT
ggplot(
  frequency,
  aes(
    x = period_start,
    y = percentage,
    color = gender_label,
    group = gender_label
  )
) +
  geom_line(linewidth = 1) +
    geom_point(size = 2) +
    geom_text(
    aes(
      label = paste0(round(percentage, 1), "%")
    ),
    vjust = -0.8,
    size = 2.8,
    show.legend = FALSE
  ) +
    geom_smooth(
    method = "lm",
    se = FALSE,
    linewidth = 0.8,
    linetype = "dashed"
  ) +
  labs(
    title = "People and Thing Frequency by Gender Over Time",
    x = "Five-year period",
    y = "Percentage (%)",
    color = "Gender / Label"
  ) +
  theme_minimal()