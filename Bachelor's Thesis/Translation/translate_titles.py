# Translating thesis titles into English:
# Sources: https://deepwiki.com/nidhaloff/deep-translator/4.1-basic-translation
# https://deep-translator.readthedocs.io/en/stable/README.html#quick-start

import pandas as pd
from deep_translator import GoogleTranslator, ChatGptTranslator
import time

# Loading data:
df = pd.read_excel("German_fake_ds.xlsx")
# translator = GoogleTranslator(source="auto", target="en")
translated = ChatGptTranslator(api_key='removed', target='english') # Please use your own API key.

# Translate titles
def translate(text):
    for attempt in range(3):
        try:
            return translated.translate(str(text))
        except Exception:
            time.sleep(1.5 * (attempt + 1))

    return None

# Applying translation:
df["English_titles"] = df["Titel der Dissertation"].apply(translate)

# Saving translated dataset:
df.to_excel("fake_translated_ds.xlsx", index=False)
