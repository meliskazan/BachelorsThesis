# BERTopic method:

# Sources: 
# Using the BERTopic embedding model: https://huggingface.co/docs/hub/bertopic
# Creating the hierarchical clustering dendrogram: https://maartengr.github.io/BERTopic/getting_started/hierarchicaltopics/hierarchicaltopics.html#linkage-functions 

import pandas as pd
from bertopic import BERTopic
from sentence_transformers import SentenceTransformer
from sklearn.feature_extraction.text import CountVectorizer

# Loading data:
df = pd.read_excel("fake_dataset.xlsx") 
titles = df["English_titles"].fillna("").astype(str).tolist()

# Loading BERTopic:
embedding_model = SentenceTransformer("all-mpnet-base-v2")

# Disallowing stop words:
vectorizer_model = CountVectorizer(
    stop_words = "english", 
    ngram_range = (1, 2),
    # min_df = 2 Line removed for fake dataset with 10 rows.
)

topic_model = BERTopic(
    embedding_model = embedding_model,
    vectorizer_model= vectorizer_model,
    language = "english",
    calculate_probabilities = False,
    verbose = True,
    min_topic_size = 2 # Added for the fake dataset with 10 rows.
)

# Running BERTopic:
topics, _ = topic_model.fit_transform(titles)

# Adding topic_id to the dataset:
df["Topic_ID"] = topics 

# Getting the keywords:
topic_keywords = {} 

for topic_id in set(topics):
    keywords = [
        word
        for word, score
        in topic_model.get_topic(topic_id)[:5]
    ]

    topic_keywords[topic_id] = ", ".join(keywords)

# Adding the topic keywords to the dataset:
df["Topic_Keywords"] = df["Topic_ID"].map(topic_keywords)

# Creating the hierarchical clustering dendrogram:
hierarchical_topics = topic_model.hierarchical_topics(titles)
figure = topic_model.visualize_hierarchy(hierarchical_topics=hierarchical_topics)

# Saving results:
figure.write_image("fake_Hierarchical_Dendrogram.png")

output_file = "fake_thesis_topics.xlsx" 
df.to_excel(output_file, index=False)

topic_info = topic_model.get_topic_info()
topic_info.to_excel("fake_topic_summary.xlsx", index=False)