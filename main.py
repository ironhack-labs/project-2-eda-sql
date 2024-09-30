# IMPORTING LIBRARIES

import pandas as pd


# READING THE DATA

df = pd.read_csv('Top 100 Languages.csv')


# EXPLORATORY DATA ANALYSIS (EDA)

print(df.head())
print(df.info())
print(df.describe())


# CLEANING THE DATA

print(df.isnull().sum())
print(df.duplicated().sum())

df = df.drop_duplicates()
df = df.dropna()


# RENAMING COLUMNS FOR CONSISTENCY (REMOVE SPACES)

print(df.columns)
df.columns = df.columns.str.replace(' ', '_')


# SORTING THE DATA

df_sorted = df.sort_values(by='Total_Speakers', ascending=False)


# IMPORTING VISUALIZATION LIBRARIES

import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


# PLOTTING THE TOP 10 LANGUAGES BY TOTAL SPEAKERS

plt.figure(figsize=(10,6))
sns.barplot(x='Language', y='Total_Speakers', data=df_sorted.head(10))
plt.title('Top 5 Most Spoken Languages in the World')
plt.xticks(rotation=45)
plt.show()


# COMPARISON BETWEEN NATIVE AND TOTAL SPEAKERS FOR TOP 10 LANGUAGES

df_sorted = df.sort_values(by='Total_Speakers', ascending=False)

plt.figure(figsize=(10,6))
x = np.arange(len(df_sorted['Language'].head(10)))
width = 0.4
plt.bar(x - width/2, df_sorted['Native_Speakers'].head(10), width, label='Native Speakers', color='blue', alpha=0.6)
plt.bar(x + width/2, df_sorted['Total_Speakers'].head(10), width, label='Total Speakers', color='orange', alpha=0.6)
plt.title('Comparison of Native and Total Speakers - Top 5 Languages')
plt.xlabel('Language')
plt.ylabel('Number of Speakers')
plt.xticks(ticks=x, labels=df_sorted['Language'].head(10), rotation=45)
plt.legend()
plt.show()


# CORRELATION ANALYSIS BETWEEN NATIVE AND TOTAL SPEAKERS

correlation = df[['Native_Speakers', 'Total_Speakers']].corr()
print(correlation)


# HEATMAP OF CORRELATION MATRIX

sns.heatmap(correlation, annot=True)
plt.title('Correlation between Native and Total Speakers')
plt.show()


# CONNECTING TO A MYSQL DATABASE

import pandas as pd
from sqlalchemy import create_engine


# CREATING THE ENGINE TO CONNECT TO THE DATABASE

engine = create_engine('mysql+pymysql://root:Adrian021218@localhost/top_languages_db')


# CREATING A NEW DATAFRAME FOR DATABASE INSERTION

df = pd.DataFrame({
    'Language': ['English', 'Mandarin Chinese', 'Hindi', 'Spanish', 'French'],
    'Total Speakers': [1132366680, 1116596640, 615475540, 534335730, 279821930],
    'Native Speakers': [379007140, 917868640, 341208640, 460093030, 77177210],
    'Origin': ['Indo-European', 'Sino-Tibetan', 'Indo-European', 'Indo-European', 'Indo-European']
})


# UPLOADING THE DATA TO THE MYSQL DATABASE

df.to_sql('top_languages_db', con=engine, if_exists='replace', index=False)


# QUERYING DATA FROM THE MYSQL DATABASE

from sqlalchemy import text


# EXECUTING A QUERY TO RETRIEVE DATA

with engine.connect() as connection:
    result = connection.execute(text("SELECT * FROM top_languages"))
    for row in result:
        print(row)


# EXPORTING DATA BACK TO CSV (if needed)
# df.to_csv('top_languages_db.csv', index=False)