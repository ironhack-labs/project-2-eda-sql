-- Calculates Number of Overall Transactions per Day
SELECT
    transaction_date,
    COUNT(transaction_id) AS transaction_count
FROM
    maven2.transactions
GROUP BY
    transaction_date
ORDER BY
    transaction_date;

-- Transactions per day, per store
SELECT
    transaction_date,
    store_id,
    COUNT(transaction_id) AS transaction_count
FROM
    maven2.transactions
GROUP BY
    transaction_date, store_id
ORDER BY
    transaction_date;

-- Average transactions per day
SELECT
    transaction_date,
    AVG(transaction_id) AS mean_transactions
FROM
    maven2.transactions
GROUP BY
    transaction_date
ORDER BY
    transaction_date;

-- Average transactions per day per store
SELECT
    transaction_date,
    store_id,
    AVG(transaction_id) AS mean_transactions_store
FROM
    maven2.transactions
GROUP BY
    transaction_date, store_id
ORDER BY
    transaction_date;

-- Average transactions per month (overall)
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    AVG(transaction_count) AS avg_transactions
FROM (
    SELECT
        transaction_date,
        COUNT(transaction_id) AS transaction_count
    FROM
        maven2.transactions
    GROUP BY
        transaction_date
) daily_transactions
GROUP BY
    transaction_month
ORDER BY
    transaction_month;

-- Average transactions per month per store
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    store_id,
    AVG(transaction_count) AS avg_transactions
FROM (
    SELECT
        transaction_date,
        store_id,
        COUNT(transaction_id) AS transaction_count
    FROM
        maven2.transactions
    GROUP BY
        transaction_date, store_id
) daily_transactions
GROUP BY
    transaction_month, store_id
ORDER BY
    transaction_month;

-- Average transactions per month (overall)
SELECT
    AVG(transaction_count) AS avg_transactions_per_month
FROM (
    SELECT
        transaction_date,
        COUNT(transaction_id) AS transaction_count
    FROM
        maven2.transactions
    GROUP BY
        transaction_date
) daily_transactions;

-- Average daily transactions per store
SELECT
    store_id,
    AVG(transaction_count) AS avg_daily_transactions_per_store
FROM (
    SELECT
        store_id,
        transaction_date,
        COUNT(transaction_id) AS transaction_count
    FROM
        maven2.transactions
    GROUP BY
        store_id, transaction_date
) daily_store_transactions
GROUP BY
    store_id;

-- Store with the highest transactions
SELECT
    store_id
FROM
    maven2.transactions
GROUP BY
    store_id
ORDER BY
    COUNT(transaction_id) DESC
LIMIT 1;

-- Best-selling product
SELECT
    product_id
FROM
    maven2.transactions
GROUP BY
    product_id
ORDER BY
    COUNT(transaction_id) DESC
LIMIT 1;

-- Best-selling product category
SELECT
    product_category
FROM
    maven2.transactions AS t
JOIN
    maven2.products AS p
ON
    t.product_id = p.prod_id
GROUP BY
    product_category
ORDER BY
    COUNT(transaction_id) DESC
LIMIT 1;