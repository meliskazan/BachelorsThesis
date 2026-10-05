# Computer Science Bachelor's Thesis
This repository contains the code used for my bachelor's thesis at the Technische Universität Berlin. The thesis investigates how a person's gender associates to their choice of PhD thesis topic in the Faculty IV of TU Berlin.

## Abstract
Gender has an impact on people’s wish to work with people or things, where women prefer to work more with people and men with things. <sup>[1]</sup> These preferences exist also in the early academic life in computer science. <sup>[2]</sup> This thesis explores whether or not these preferences also exist in PhD level at the Faculty IV of TU Berlin. The dataset used contains every PhD thesis of Faculty IV of TU Berlin from 2000 to 2025. With the methods used the goal was to see if the students choose systematically different research topics by observing their thesis titles through semantic similarities. The systematic difference was defined as the gender groups having a collective tendency to choose certain types of thesis. The possible types of thesis were people or thing-related. 

The first categorization try was done using SBERT and BERTopic. SBERT was used to transform the thesis titles into numerical embeddings and BERTopic to cluster them into groups of similar semantic meaning. The keywords of these clusters were inspected to see if they fit more into the people or thing description. They all fit in the thing description. The approach was given up. 

The second try was with Chat GPT, where it was prompted to create 20 meaningful cluster names as thesis topics. These topic names and the thesis titles were then embedded using SBERT. The cosine similarity of every topic and title was calculated. The topic and title with the highest confidence score was matched together. This process showed that the matchings were not detailed enough and again the clusters were mostly thing-related, even though some titles were people-related.

The last method used was the Chat GPT API, where it was prompted to categorize the thesis titles into people and thing-related. About a quarter of the labels were compared with manually created labels and the API categorization was deemed accurate. The results were then compared between the genders. This process revealed that 10% of the female students and 4,01% of the male students had people-related thesis titles. So even though more female students preferred a thesis in the thing-realm, the majority of both genders still had thing-related thesis titles. Over the years, for both genders the percentage of people-related titles slightly increased. The increase was steeper with the female students.


(1) _Richard Lippa. “Gender-related individual differences and the structure of vocational interests: The importance of the people–things dimension”. English. In: Journal of Personality and Social Psychology: Personality -Processes and Individual Differences 74.4 (Apr. 1998). Copyright - © 1998, American Psychological Association. All rights, including for text and data mining, AI training, and similar technologies, are reserved; Datum  Beendigung - 1997-05-19; Datum Erstellung - 1996-06-10; Datum Revision - 19980501; 20060710; Anzahl der Quellenangaben - 51, pp. 996–1009. url: https://www.proquest.com/scholarly- journals/genderrelated-individual-differencesstructure/docview/614360100/se-2._

(2) _Melissa Høegh Marcher et al. “Computing Educational Activities Involving People Rather Than Things Appeal More to Women (CS1 Appeal Perspective)”. In: Proceedings of the 17th ACM Conference on International Computing Education Research 44 1 (2021), p. 0. doi: 10.1145/3446871.3469761_


# How to navigate in the repository:
First information: 
In the folders you will find excel sheets with the names fake_*.xlsx. These sheets are created for uploading on GITHUB, so you can try the code. The entries are fake. Most of them have 10 entries.

## Bachelor's Thesis: 
Main folder, go inside.

## BERTopic:
Contains the code BERTOPIC.py used for the first method and a fake_dataset.xlsx.

## Chat GPT:
Contains the code bertopic_gpt.py used for the second method and a fake_dataset.xlsx.

## CHAT GPT API:
Contains the code openapi.py used for the last method, five_more_ds.py and the fake datasets fake_dataset.xlsx, fake_thesis_titles_labeled_5_yearly.xlsx and fake_thesis_titles_labeled_for_randomization.xlsx. It also contains the R files 5year_gender.R and OpenApiR.R.

five_more_ds.py creates 5 randomized datasets for contol.

5year_gender.R plots the "People and Thing Frequency by Gender Over Time" graph for every 5 years.
OpenApiR.R plots the "Number of People and Things by Gender" and "Percentage of People and Things by Gender" graphs.

The first excel sheet is used in openapi.py, the second one in 5year_gender.R and the third one in five_more_ds.py

## Data Quesions:
Contains fake_Initial_DB_Promotionen.xlsx and Fixing dataset irregularities.R.

The R file plots graphs answering data questions.

## Translation:
Contains the code translate_titles.py used to translate the thesis title names in the dataset from German to English and a fake dataset German_fake_ds.xlsx.























