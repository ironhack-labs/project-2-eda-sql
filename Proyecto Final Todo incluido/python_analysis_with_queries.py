
import pandas as pd
import mysql.connector

# Database connection configuration
config = {
    'user': 'your_username',
    'password': 'your_password',
    'host': 'localhost',
    'database': 'f1_database'
}

# Function to connect to the database
def connect_to_database():
    return mysql.connector.connect(**config)

# Function to load a CSV file into a MySQL table
def load_csv_to_mysql(file_path, table_name):
    connection = connect_to_database()
    cursor = connection.cursor()

    # Read the CSV file
    df = pd.read_csv(file_path)

    # Iterate through the rows and insert into the table
    for _, row in df.iterrows():
        columns = ', '.join(row.index)
        values = ', '.join([f'"{str(value)}"' if pd.notna(value) else 'NULL' for value in row])
        query = f"INSERT INTO {table_name} ({columns}) VALUES ({values})"
        cursor.execute(query)

    connection.commit()
    cursor.close()
    connection.close()
    print(f"Data loaded into {table_name} successfully.")

# Function to run a query and fetch results
def run_query(query):
    connection = connect_to_database()
    cursor = connection.cursor()

    cursor.execute(query)
    results = cursor.fetchall()

    # Print the results
    for row in results:
        print(row)

    cursor.close()
    connection.close()
    return results

# Queries to answer the 10 business questions

# 1. Top 10 Drivers with the Most Race Wins
query_1 = """
SELECT d.forename, d.surname, COUNT(*) AS total_wins
FROM results r
JOIN drivers d ON r.driverId = d.driverId
WHERE r.position = 1
GROUP BY r.driverId, d.forename, d.surname
ORDER BY total_wins DESC
LIMIT 10;
"""

# 2. Constructor with the Most Race Wins
query_2 = """
SELECT c.name AS constructor_name, COUNT(*) AS total_wins
FROM results r
JOIN constructors c ON r.constructorId = c.constructorId
WHERE r.position = 1
GROUP BY r.constructorId, c.name
ORDER BY total_wins DESC
LIMIT 10;
"""

# 3. Top 5 Circuits with the Most Races
query_3 = """
SELECT ci.name AS circuit_name, COUNT(*) AS race_count
FROM races r
JOIN circuits ci ON r.circuitId = ci.circuitId
GROUP BY r.circuitId, ci.name
ORDER BY race_count DESC
LIMIT 5;
"""

# 4. Number of Races Per Year Over Time
query_4 = """
SELECT year, COUNT(*) AS total_races
FROM races
GROUP BY year
ORDER BY year ASC;
"""

# 5. Youngest Drivers to Win a Race
query_5 = """
SELECT d.forename, d.surname, r.year, (YEAR(r.date) - YEAR(d.dob)) AS age_at_win
FROM results re
JOIN drivers d ON re.driverId = d.driverId
JOIN races r ON re.raceId = r.raceId
WHERE re.position = 1
ORDER BY age_at_win ASC
LIMIT 5;
"""

# 6. Fastest Lap Times in Sprint Races
query_6 = """
SELECT d.forename, d.surname, c.name AS constructor_name, sr.fastestLapTime
FROM sprint_results sr
JOIN drivers d ON sr.driverId = d.driverId
JOIN constructors c ON sr.constructorId = c.constructorId
WHERE sr.fastestLapTime IS NOT NULL
ORDER BY sr.fastestLapTime ASC
LIMIT 10;
"""

# 7. Driver with the Most Race Participations
query_7 = """
SELECT d.forename, d.surname, COUNT(DISTINCT r.raceId) AS total_races
FROM results r
JOIN drivers d ON r.driverId = d.driverId
GROUP BY r.driverId, d.forename, d.surname
ORDER BY total_races DESC
LIMIT 1;
"""

# 8. Constructors with the Most Championship Wins
query_8 = """
SELECT c.name AS constructor_name, COUNT(*) AS total_championships
FROM constructor_standings cs
JOIN constructors c ON cs.constructorId = c.constructorId
WHERE cs.position = 1
GROUP BY cs.constructorId, c.name
ORDER BY total_championships DESC
LIMIT 10;
"""

# 9. Average Number of Laps Completed Per Race Across Circuits
query_9 = """
SELECT ci.name AS circuit_name, AVG(re.laps) AS avg_laps
FROM results re
JOIN races r ON re.raceId = r.raceId
JOIN circuits ci ON r.circuitId = ci.circuitId
GROUP BY ci.circuitId, ci.name
ORDER BY avg_laps DESC;
"""

# 10. Drivers with the Most Pole Positions
query_10 = """
SELECT d.forename, d.surname, COUNT(*) AS pole_positions
FROM qualifying q
JOIN drivers d ON q.driverId = d.driverId
WHERE q.position = 1
GROUP BY q.driverId, d.forename, d.surname
ORDER BY pole_positions DESC
LIMIT 10;
"""

# Run and print results for each query
queries = [query_1, query_2, query_3, query_4, query_5, query_6, query_7, query_8, query_9, query_10]
query_titles = [
    "Top 10 Drivers with the Most Race Wins",
    "Constructor with the Most Race Wins",
    "Top 5 Circuits with the Most Races",
    "Number of Races Per Year Over Time",
    "Youngest Drivers to Win a Race",
    "Fastest Lap Times in Sprint Races",
    "Driver with the Most Race Participations",
    "Constructors with the Most Championship Wins",
    "Average Number of Laps Completed Per Race Across Circuits",
    "Drivers with the Most Pole Positions"
]

for title, query in zip(query_titles, queries):
    print(f"\n{title}:")
    run_query(query)
