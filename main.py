# Business Challenge: EDA and SQL
"""
Pick up a dataset in our common datasets repos and break your work into big steps:
 1. Pick a topic and choose a dataset on that topic. Build around 10 Business questions to answer about this topic.
 	- Try to build the questions before knowing everything about the data
 	- If not possible, do step 2. first
 2. Data Analysis: Understand your dataset and create a report (word document) about it
 3. Data Exploration and Business Understanding: 
 	- Import your dataset into SQL
 	- Answer your Business questions with SQL Queries
"""

############ TOPIC: HEART ATTACK RISK PREDICTION ############

# IDEA FOR WEB SCRAPPING (maybe from WHO?): GET THE ACCEPTABLE LEVELS OF THE METRICS MEASURED IN THE DATABASE:
# api global health obbservatory
"""  
    'Cholesterol', 'Blood Pressure', 'Heart Rate', 'Diabetes', 'Family History', 'Smoking', 'Obesity',
    'Alcohol Consumption', 'Exercise Hours Per Week', 'Diet',
    'Previous Heart Problems', 'Medication Use', 'Stress Level',
    'Sedentary Hours Per Day', 'Income', 'BMI', 'Triglycerides',
    'Physical Activity Days Per Week', 'Sleep Hours Per Day', 'Heart Attack Risk'
"""

##### BUSINESS QUESTIONS: #####
# Question 1: What is the distribution of heart attack risk across different age groups?
# Question 2: How does gender affect heart attack risk?
# Question 3: What role does lifestyle (e.g., smoking, physical activity) play in heart attack risk?
# Question 4: What is the average heart attack risk score across different medical conditions (e.g., diabetes, hypertension)?
# Question 5: What is the geographic distribution of heart attack risk (if location data is available)?
# Question 6: How does sleep patterns affect the risks of heart attack?
# Question 7: How does high stress levels increase the risk of heart attack?
# Question 8: How does lifestyle (e.g., diet, exercise, smoking, alcohol consumption) affect heart attack risk 
#           when controlled for medical history (e.g., family history of heart disease, pre-existing conditions)
# Question 9: How does the economic status of a patient affect the risks of suffering a heart attack?
# Question 10: How do combinations of medical history factors (e.g., hypertension, diabetes, cholesterol levels) interact with 
#           healthy lifestyle choices to influence heart attack risk across different demographic segments? 

############# IMPORTING THE LIBRARIES #############

# Importing the Seaborn library for advanced data visualization (as sns)
import seaborn as sns

# Importing the Matplotlib library for basic plotting functionalities (as plt)
import matplotlib.pyplot as plt

# Importing the Pandas library for data manipulation and analysis (as pd)
import pandas as pd

# Importing the NumPy library for numerical operations (as np)
import numpy as np

# To manipulate data and interact with MySQL
import pymysql 

############# STEP 2. Exploratory Data Analysis (EDA) of DATASET ############

# EDA 1: Read the document and Create a Dataframe
# Document type: CSV
df = pd.read_csv("./datasets/heart_attack_prediction_dataset.csv")
print("Head")
print(df.head())
# EDA 2: Start the Exploratory Analysis

# a: Shape of the DataFrame (rows, columns)
data_shape = df.shape
print("Shape of the DataFrame:")
print(data_shape)

# b: Column Names (IT WILL NECESSARY TO JOIN ALL THE TITLES WITH '_' FOR MYSQL)
column_names = df.columns
df.columns = ['_'.join(col.split()) for col in df.columns]
print("Column Names:")
print(column_names)

# c: Data types of each column
data_types = df.dtypes
print("Data Types:")
print(data_types)

# d: General Information about the DataFrame
data_info = df.info()
print("General Information about the DataFrame:")
print(data_info)

# e: Statistical Summary
data_summary = df.describe()
print("\nStatistical Summary:")
print(data_summary)


############ DATA QUALITY ANALYSIS (DQA) OF DATASET ############

# DQA 1: Start the Data Quality Analysis

# a: Check for missing values
# Check for missing values in the DataFrame
missing_values = pd.isnull(df)

# Count missing values in each column
missing_counts = missing_values.sum()

# Count columns with missing values
columns_with_missing = missing_counts[missing_counts > 0].count()

# Check if all columns have missing values
all_columns_missing = missing_counts.all()

# Calculate the total number of missing values
total_missing_values = missing_counts.sum()

# Clean the DataFrame from duplicates and fills NaN values with a '0'
df.drop_duplicates().fillna(0)
df.fillna(0, inplace=True)

# Display the results
print("Missing Values in Each Column:\n", missing_counts)
print("\nNumber of Columns with Missing Values:", columns_with_missing)
print("All Columns Have Missing Values:", all_columns_missing)
print("\nTotal Missing Values in the DataFrame:", total_missing_values)



######### Conclusions after EDA and DQA #########
"""
This dataset is clean with no missing values.
The min(Age) = 18, so there is no data about heart disease in children
Columns: 'Diabetes', 'Family History', 'Smoking', 'Obesity',
       'Alcohol Consumption', 'Previous Heart Problems', 'Medication Use' 
       & 'Heart Attack Risk' HAVE VALUES OF 0 FOR NO, 1 FOR YES.
Column 'Blood Pressure'  is an object. We will split the column into 2 new columns with 'Systolic' and 'Diastolic'
for calculation purposes.
'Heart Attack Risk' only provides information about presence or abscence of risk.
No information about level of risk for heart attack. 
Might consider elminate last column and perform a customized evaluation of the data 
to calculate the risks based on the recommended guidelines from World Health Organization.

"""

######### DATAFRAME MANIPULATION AND ADJUSTING #########
number_rows = int(df['Patient_ID'].count()) # Calculate the number of rows

# split the Blood pressure into systolic and diastolic for calculation purposes
df[['Systolic', 'Diastolic']] = df['Blood_Pressure'].str.split('/', expand=True)

# Convert the new columns to numeric values (optional)
df['Systolic'] = pd.to_numeric(df['Systolic'])
df['Diastolic'] = pd.to_numeric(df['Diastolic'])

#Eliminate column "Blood_pressure"
df = df.drop('Blood_Pressure', axis=1)

# We are going to add a new column 'Age_Group and organize the data by decades:

for i in range(number_rows):
    if df.loc[i, 'Age'] >= 18 and df.loc[i, 'Age'] < 30:
        df.loc[i, 'Age_Group'] = '20s'
    elif df.loc[i, 'Age'] >= 30 and df.loc[i, 'Age'] < 40:
        df.loc[i, 'Age_Group'] = '30s'
    elif df.loc[i, 'Age'] >= 40 and df.loc[i, 'Age'] < 50:
        df.loc[i, 'Age_Group'] = '40s'
    elif df.loc[i, 'Age'] >= 50 and df.loc[i, 'Age'] < 60:
        df.loc[i, 'Age_Group'] = '50s'
    elif df.loc[i, 'Age'] >= 60 and df.loc[i, 'Age'] < 70:
        df.loc[i, 'Age_Group'] = '60s'
    elif df.loc[i, 'Age'] >= 70 and df.loc[i, 'Age'] < 80:
        df.loc[i, 'Age_Group'] = '70s'
    elif df.loc[i, 'Age'] >= 80:
        df.loc[i, 'Age_Group'] = '80s'

# Sort Values by Age_Group for visualization purposes
df = df.sort_values(by=['Age_Group'], ascending=True)

# We are going to divide the Dataframe based on 'Demographics', 'Medical History' and 'columns_lifestyle
df_demographics = df[['Patient_ID', 'Age', 'Age_Group', 'Sex', 'Country', 'Continent', 'Hemisphere']]
df_medical = df[['Patient_ID', 'Cholesterol', 'Systolic', 'Diastolic', 'Heart_Rate', 'Diabetes',
                  'Family_History', 'Obesity', 'Previous_Heart_Problems','Medication_Use', 'BMI', 'Triglycerides', 'Heart_Attack_Risk']]
df_lifestyle = df[['Patient_ID', 'Smoking','Alcohol_Consumption', 'Exercise_Hours_Per_Week', 'Diet', 
                   'Stress_Level', 'Sedentary_Hours_Per_Day', 'Physical_Activity_Days_Per_Week', 'Sleep_Hours_Per_Day']]




######### UPLOAD DATAFRAME TO MYSQL #########

# Step 1: Establish connection to MySQL using pymysql
connection = pymysql.connect(
    host="localhost",        # Replace with your host (localhost)
    user="root",             # Replace with your MySQL username (root)
    password="Dani1994"     # Replace with your MySQL password (your own password)
)

# SETP 2: Initialize cursor
cursor = connection.cursor()

# STEP 3: Create Database
query_create_database = ('CREATE DATABASE IF NOT EXISTS heart_data')
cursor.execute(query_create_database)

# SETP 4: Select Database
query_select_database = ('USE heart_data')
cursor.execute(query_select_database)

# STEP 5: Create tables 'patient_demographics', 'medical_history' and 'life_style'
query_create_demographics = (
    '''CREATE TABLE IF NOT EXISTS patient_demographics (
        Patient_ID VARCHAR(100) PRIMARY KEY,
        Age INT,
        Age_Group VARCHAR(3),
        Sex VARCHAR(10),
        Income INT,
        Country VARCHAR(100),
        Continent VARCHAR(100),
        Hemisphere VARCHAR(100))'''
        )
cursor.execute(query_create_demographics)

query_create_medical = (
    '''CREATE TABLE IF NOT EXISTS medical_history (
        Patient_ID VARCHAR(100) PRIMARY KEY,
        Cholesterol INT,
        Systolic INT, 
        Diastolic INT,
        Heart_Rate INT,
        Diabetes INT,
        Family_History INT,
        Obesity INT,
        Previous_Heart_Problems INT,
        Medication_Use INT,
        BMI FLOAT8,
        Triglycerides INT,
        Heart_Attack_Risk INT)'''
        )
cursor.execute(query_create_medical)

query_create_lifestyle = (
    '''CREATE TABLE IF NOT EXISTS life_style (
        Patient_ID VARCHAR(100) PRIMARY KEY,
        Smoking INT,
        Alcohol_Consumption INT,
        Exercise_Hours_Per_Week FLOAT8,
        Diet VARCHAR(100),
        Stress_Level INT, 
        Sedentary_Hours_Per_Day FLOAT8,
        Physical_Activity_Days_Per_Week INT,
        Sleep_Hours_Per_Day INT)'''
        )
cursor.execute(query_create_lifestyle)

# Step 6: Generate the insert query dynamically based on the DataFrame columns per table
#       & Loop through the DataFrame and insert each row
columns_demographics = ', '.join(df_demographics.columns)
query_insert_demographics = f"INSERT INTO patient_demographics ({columns_demographics}) 
                            VALUES ({', '.join(['%s'] * len(df_demographics.columns))})"

for index, row in df_demographics.iterrows():
    data = tuple(row)  # Convert the row to a tuple
    cursor.execute(query_insert_demographics, data)

columns_medical = ', '.join(df_medical.columns)
query_insert_medical = f"INSERT INTO medical_history ({columns_medical}) VALUES ({', '.join(['%s'] * len(df_medical.columns))})"

for index, row in df_medical.iterrows():
    data = tuple(row)  # Convert the row to a tuple
    cursor.execute(query_insert_medical, data)

columns_lifestyle = ', '.join(df_lifestyle.columns)
query_insert_lifestyle = f"INSERT INTO life_style ({columns_lifestyle}) VALUES ({', '.join(['%s'] * len(df_lifestyle.columns))})"

for index, row in df_lifestyle.iterrows():
    data = tuple(row)  # Convert the row to a tuple
    cursor.execute(query_insert_lifestyle, data)

# Step 7: Commit the transaction
connection.commit()

# Step 8: Close cursor and connection
cursor.close()
connection.close()

######### DATA EXPORT TO CSV FOR TABLEAU VISUALIZATION #########

df_demographics.to_csv('./datasets/demographics.csv', index=True)
df_medical.to_csv('./datasets/medical_history.csv', index=True)
df_lifestyle.to_csv('./datasets/lifestyle.csv', index=True)
print("csv file created")


