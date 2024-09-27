import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns



# Load the data set
employee = pd.read_csv("dataset\employee.csv")



# 1. EXPLORATORY DATA ANALYSIS

# Display the first few rows
employee.head()

# Display basic info
employee.describe()
employee.shape
employee.info()
employee.columns = employee.columns.str.strip()



# Visualization

# Plotting 'Monthly Salary'

""" Salaries are relatively normally distributed, with a peak around $6500. """

plt.figure(figsize=(10, 6))
plt.hist(employee['Monthly_Salary'], bins=20, color='skyblue', edgecolor='black')
plt.title('Distribution of Monthly Salary')
plt.xlabel('Monthly Salary')
plt.ylabel('People')
plt.show()

# Plotting 'Years at company'

""" The majority of employees have been with the company for 6 to 10 years. """

bins = [0, 2, 5, 10, 20]
labels = ['0-2', '3-5', '6-10', '10+']
employee['Years_Range'] = pd.cut(employee['Years_At_Company'], bins=bins, labels=labels)
employee['Years_Range'].value_counts().plot.pie(autopct='%1.1f%%')
plt.title('Proportion of Employees by Years at Company')
plt.show()



# 2. DATA QUALITY ANALYSIS

# Searching for missing values in the Data Frame
missing_values = pd.isnull(employee)
missing_values

# Count missing values in each column
missing_counts = missing_values.sum()
print(f"Missing values in each column: {missing_counts}")

#Number of columns with missing values
columns_with_missing = missing_counts[missing_counts > 0].count()
print(f"Number of columns with missing values: {columns_with_missing}")

# Have all the columns values that are missing?
all_columns_missing = missing_counts.all()
print(f"All columns have missing values: {all_columns_missing}")

# Calculate the total number of missing values
total_missing_values = missing_counts.sum()
print(f"Total missing values in the Data Frame: {total_missing_values}")

# Clean DataFrame from duplicates
employee.drop_duplicates(inplace=True)



# 3. CREATE DATABASE AND UPLOAD TO MYSQL
!pip install pymysql
!pip install cryptography

# Step 1: Establish a connection to MySQL
import pymysql

cnx = pymysql.connect(user='root', password='Vidondo6699',
                      host='localhost')

if cnx.open:
    print("Connection open")
else:
    print("Connection is not successfully open")

# Step 2: Create a cursor object to execute SQL queries
cursor = cnx.cursor()

# Step 3: Create a new database
query = "CREATE DATABASE IF NOT EXISTS employee_productivity"
cursor.execute(query)

# Step 4: Confirm the database is created
cursor.execute("SHOW DATABASES")
for db in cursor:
    print(db)

# Step 5: Select to use the new database
query = "USE employee_productivity"
cursor.execute(query)

# Step 6: Write the SQL query to create a table
query = """CREATE TABLE IF NOT EXISTS employee (
        Employee_Id INT PRIMARY KEY,
        Gender VARCHAR(20),
        Age INT,
        Department VARCHAR(255),
        Job_Title VARCHAR(255),
        Hire_Date DATE,
        Years_At_Company INT,
        Education_Level VARCHAR(255)
        )"""

cursor.execute(query)

# Create another table
query = """CREATE TABLE IF NOT EXISTS seniority (
        Seniority_ID INT AUTO_INCREMENT PRIMARY KEY,
        Employee_ID INT,
        Performance_Score INT,
        Work_Hours_Per_Week INT,
        Overtime_Hours INT,
        Projects_Handled INT,
        Promotions INT,
        FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID)
        )"""

cursor.execute(query)

# Add a column to an existing table
query = """ALTER TABLE seniority
        ADD COLUMN Monthly_Salary DECIMAL(10, 2);
        """

cursor.execute(query)

# Create one more table
query = """CREATE TABLE IF NOT EXISTS satisfaction (
        Satisfaction_ID INT AUTO_INCREMENT PRIMARY KEY,
        Employee_ID INT,
        Employee_Satisfaction_Score DECIMAL(3, 2),
        Sick_Days INT,
        Remote_Work_Frequency INT,
        Team_Size INT,
        Training_Hours INT,
        Resigned BOOLEAN,
        FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID)
        )"""

cursor.execute(query)

# Step 7: Confirm the tables have been created
cursor.execute("SHOW TABLES")
for table in cursor:
    print(table)

# Step 8: Comit and close the connection
""" The Python Wrapper for MSQL has generated changes to the database which must now be committed. It's like "Saving" the changes made """
cnx.commit()

""" The cursor object has done it's job """
cursor.close()

""" and we now close the connection, you must always do this (good practice) or else the database might not be responsive to other connections. """
cnx.close() 
