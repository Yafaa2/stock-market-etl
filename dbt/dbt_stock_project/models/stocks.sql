{{ config(
    materialized='table'
) }}

WITH combined AS (
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM `stock-market-elt.stock_data.airbnb_stock_data_results`
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM `stock-market-elt.stock_data.booking_stock_data_results`
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM `stock-market-elt.stock_data.expedia_stock_data_results`
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM `stock-market-elt.stock_data.trip_com_stock_data_results`
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM `stock-market-elt.stock_data.tripadvisor_stock_data_results`
)

SELECT * FROM combined 
ORDER BY symbol, date