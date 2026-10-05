# Creating the 5 balanced datasets:

import pandas as pd

# Loading excel:
df = pd.read_excel("fake_thesis_titles_labeled_for_randomization.xlsx")

# Storing the randomly selected rows:
selected_rows = []

for year, group in df.groupby("year"):
    # Taking every women and #women amount of men randomly:
    females = group[group["m/w"] == "w"]
    males = group[group["m/w"] == "m"]

    x = len(females)
    selected_males = males.sample(n=x)

    selected_rows.append(females)
    selected_rows.append(selected_males)

# Making new dataset and saving it as excel file:
new_df = pd.concat(selected_rows, ignore_index=True)
new_df.to_excel("fake_balanced_data_1.xlsx", index=False)