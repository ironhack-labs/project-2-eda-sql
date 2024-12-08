CREATE DATABASE IF NOT EXISTS CSV_CLEAN_DATA;

USE CSV_CLEAN_DATA;

-- 1. How many Room Nights each hotel as, in each reservation status
SELECT hotel, reservation_status, SUM(rn_sum) as Total_RN
FROM clean_hotel_data
GROUP BY hotel, reservation_status;

-- 2 . What is the average daily rate (ADR) for each hotel, only "active" Reservations
SELECT hotel, ROUND(AVG(adr), 2) as ADR_€
FROM clean_hotel_data
WHERE is_canceled = 0
GROUP BY Hotel;

--  3.  For each Hotel how many nights were sold by Distribution Channel
SELECT Distribution_channel, Hotel, ROUND(SUM(rn_sum)) as T_RN
FROM clean_hotel_data
GROUP BY Distribution_channel, Hotel;

--  4. For each Hotel how many Meal Plans were sold
SELECT meal, hotel, count(meal) as Qty_Meal_Plan
FROM clean_hotel_data
GROUP BY meal, hotel;

--  5. For each Hotel how much Revenue was generate by years
SELECT hotel, arrival_date_year, ROUND(sum(revenue_total), 0) as T_Rev_€
FROM clean_hotel_data
WHERE is_canceled = 0
GROUP BY Hotel, arrival_date_year;

--  6. For each Hotel how much Revenue was generate by Distribution Channel
SELECT hotel, distribution_channel, ROUND(sum(revenue_total), 0) as T_Rev_€
FROM clean_hotel_data
WHERE is_canceled = 0
GROUP BY Hotel, distribution_channel;