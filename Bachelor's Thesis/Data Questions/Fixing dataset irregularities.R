library(readxl)
library(dplyr)
library(lubridate)
library(ggplot2)
library(scales)

# dataset is the table before any changes.
dataset <- read_excel("fake_Initial_DB_Promotionen.xlsx")
View(dataset)

# anon_ds is the table after erasing the Vorname and Nachname columns.
anon_ds <- dataset %>% select(-Name, -Vorname)

table(dataset$'m/w', useNA = "ifany")

# Fixing typo and deleting N/A rows under column "m/w"
anon_ds$`m/w`[anon_ds$`m/w` == "nm"] <- "m"
anon_ds <- anon_ds[!is.na(anon_ds$`m/w`), ]
table(anon_ds$`m/w`, useNA = "ifany")

# Formatting the dates from excel format to date format
# date_ds is the table that is anon. and the dates are fixed.
date_ds <- anon_ds
date_ds$year <- year(date_ds$`Datum Aussprache`)

# year_ds is the table that is anon. and only the year is to be found. 
# (Instead of "Datum Aussprache" there is the column "year")
year_ds <- date_ds %>% select(-`Datum Aussprache`)
year_ds <- year_ds %>%
  filter(!is.na(year))

# year_counts is necessary for plotting the overall student amount change over the years.
year_counts <- year_ds %>%
  group_by(year) %>%
  summarise(total_students = n(), .groups ="drop")
print(year_counts, n = Inf)

# Plotting the graph of number of graduates per year
ggplot(year_counts, aes(x = year, y = total_students)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = "pink",
    linewidth = 1.2
  ) +
  scale_x_continuous(
    breaks = seq(
      min(year_counts$year),
      max(year_counts$year),
      5
    )
  ) +
  labs(
    title = "Number of PhD graduates per year",
    x = "Year",
    y = "Number of graduates"
  ) +
  theme_bw()

# Gender amount change through the years:
# year_gender is the table with just the year of finishing and the gender of the students.
year_gender <- year_ds %>%
  group_by(year, `m/w`) %>%
  summarise(count = n(), .groups = "drop")
year_gender <- year_gender %>%
  group_by(year) %>%
  mutate(share = count / sum(count)) %>%
  ungroup()
year_gender <- year_gender %>%
  mutate(`m/w` = recode(`m/w`,
                        "m" = "Male",
                        "w" = "Female"))

# Plotting the gender distribution of graduates over time
ggplot(
  year_gender,
  aes(x = year, y = share, color = `m/w`)
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linetype = "dashed",
    linewidth = 1
  ) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1)
  ) +
  scale_x_continuous(
    breaks = seq(
      min(year_gender$year),
      max(year_gender$year),
      5
    )
  ) +
  labs(
    title = "Gender distribution of PhD graduates over time",
    x = "Year",
    y = "Percentage of graduates",
    color = "Gender"
  ) +
  theme_bw(base_size = 13) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  )

# Plotting the number of PhD graduates over time by gender
ggplot(
  year_gender,
  aes(x = year, y = count, color = `m/w`)
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linetype = "dashed",
    linewidth = 1
  ) +
  scale_x_continuous(
    breaks = seq(
      min(year_gender$year),
      max(year_gender$year),
      5
    )
  ) +
  labs(
    title = "Number of male and female PhD graduates over time",
    x = "Year",
    y = "Number of graduates",
    color = "Gender"
  ) +
  theme_bw(base_size = 13) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  )

# nationality_gender_year is the same table as year_ds but added for plotting different graph
nationality_gender_year <- year_ds
unique(year_ds$`dt/Ausl.`)

# Gender - German / foreigner per year rise
table(year_ds$`dt/Ausl.`, useNA = "ifany")
year_ds$`dt/Ausl.` <- trimws(year_ds$`dt/Ausl.`)

year_ds$`dt/Ausl.` <- recode(
  year_ds$`dt/Ausl.`,
  
  "d" = "D",
  "d." = "D",
  "dt" = "D",
  "dt." = "D",
  "Dt." = "D",
  "dt:" = "D",
  "De" = "D",
  "dt-" = "D",
  
  "A" = "A",
  "Ausl" = "A",
  "Ausl." = "A"
)

clean_year_ds <- year_ds %>%
  filter(
    !is.na(`dt/Ausl.`),
    !`dt/Ausl.` %in% c("?", "dt./A", "dt/A")
  )

gender_nationality_year <- clean_year_ds %>%
  group_by(year, `m/w`, `dt/Ausl.`) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(
    group = paste(`m/w`, `dt/Ausl.`)
  )
table(gender_nationality_year$group)

gender_nationality_year <- gender_nationality_year %>%
  filter(
    !is.na(`dt/Ausl.`),
    `dt/Ausl.` != "?"
  )

# Plotting the graph with the number of PhD graduates by nationality and gender
ggplot(
  gender_nationality_year,
  aes(x = year, y = count, color = group)
) +
# Actual numbers
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
# Linear regression for each group
  geom_smooth(
    method = "lm",
    se = FALSE,
    linetype = "dashed",
    linewidth = 1
  ) +
  scale_x_continuous(
    breaks = seq(
      min(gender_nationality_year$year),
      max(gender_nationality_year$year),
      5
    )
  ) +
  labs(
    title = "PhD graduates by nationality and gender",
    x = "Year",
    y = "Number of graduates",
    color = "Group"
  ) +
  theme_bw(base_size = 13) +
  theme(
    legend.position = "right",
    axis.text.x = element_text(angle = 45, hjust = 1),
    
# Percentage of each nationality-gender group per year
    gender_nationality_share <- gender_nationality_year %>%
      group_by(year) %>%
      mutate(
        share = count / sum(count)
      ) %>%
      ungroup()
  )

# Plotting percentage of PhD graduates by nationality and gender
ggplot(
  gender_nationality_share,
  aes(
    x = year,
    y = share,
    color = group
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  
  geom_smooth(
    method = "lm",
    se = FALSE,
    linetype = "dashed",
    linewidth = 1
  ) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1)
  ) +
  scale_x_continuous(
    breaks = seq(
      min(gender_nationality_share$year),
      max(gender_nationality_share$year),
      5
    )
  ) +
  labs(
    title = "Percentage of PhD graduates by nationality and gender",
    x = "Year",
    y = "Percentage of graduates",
    color = "Group"
  ) +
  theme_bw(base_size = 13) +
  theme(
    legend.position = "right",
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )

group_totals <- gender_nationality_year %>%
  group_by(group) %>%
  summarise(total = sum(count), .groups = "drop")

print(group_totals)

table(gender_nationality_year$`dt/Ausl.`, useNA = "ifany")

# FINAL STUFF FOR THE RESEARCH QUESTION. !!!!!!
research_ds <- year_ds %>% select(-`Nr.`, -Erstberichter, -Zweitberichter, -Drittberichter, -Fünftberichter, -Sechstberichter)
research_ds 


library(writexl)
write_xlsx(research_ds, "fake_research_ds.xlsx")



