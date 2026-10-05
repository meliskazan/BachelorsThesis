# Chat GPT API method:
# Sources:
# https://www.geeksforgeeks.org/blogs/what-is-chatgpt-api/
# https://www.geeksforgeeks.org/artificial-intelligence/openai-python-api/
# https://www.geeksforgeeks.org/python/how-to-use-chatgpt-api-in-python/

from openai import OpenAI
import pandas as pd

# Creating OpenAI client
client = OpenAI(api_key = "removed") # Please use your own api_key.

# Reading the data:
df = pd.read_excel("fake_dataset.xlsx")

PROMPT = """
Classify the following PhD thesis title as either 'people' or 'thing'.

- Reply 'people' if the title focuses on or written in a way of
  people, human behaviour, health, psychology, society, cognition, user experience, or human interaction.

- Reply 'thing' if the title focuses on or written in a way of
  a method, algorithm, model, system, technology, process, network, software, or other non-human topic.

Examples:

People:
- The Role of Psychological Reactance in Human-Computer Interaction
- Motivation of Workers on Microtask Crowdsourcing Platforms
- User Experience with Mobile Security and Privacy Mechanisms
- Multi-Factor Authentication Based on Movement and Gesture
- On Improving Privacy and Security Through User-Informed Design
- User Acceptance of Mobile Notifications
- Modeling Cognitive Flexibility in Alcohol Dependence
- Less Bureaucratic Burdens Through Distributed Integration Architecture
- Understanding Benefits of Different Vantage Points in Today's Internet

Thing:
- Improving the efficiencies of the FDTD method for the analysis of coplanar MMICs
- Automatic casting defect detection from digital X-ray image sequences
- Investigation and optimization of NPT trench IGBTs using 2D simulation

Reply with only one word:
people
or
thing.
"""

labels = []

# Sending thesis titles into gpt-4o-mini model:
for title in df["English_titles"]:
    response = client.chat.completions.create(
        model = "gpt-4o-mini",
        messages = [
            {"role": "system", "content": PROMPT},
            {"role": "user", "content": str(title)},
        ],
    )

    label = response.choices[0].message.content.strip().lower()
    labels.append(label)

df["label"] = labels
df.to_excel("fake_thesis_titles_labeled.xlsx", index=False)