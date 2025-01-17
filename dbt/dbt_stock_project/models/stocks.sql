

-- This code combines stock data from multiple sources into a single table
WITH combined AS (
    
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM {{ source('stock_market_data', 'airbnb_stock_data_results') }}
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM {{source('stock_market_data', 'booking_stock_data_results')}}
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM {{source('stock_market_data', 'expedia_stock_data_results')}}
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM {{source('stock_market_data', 'trip_com_stock_data_results')}}
    UNION ALL
    SELECT T AS symbol, TIMESTAMP_SECONDS(CAST(t_1 / 1000 AS INT64)) AS date, o AS open, c AS close, h AS high, l AS low, CAST(v AS int) AS volume, vw AS volume_average, CAST(n AS int) AS number_of_transactions
    FROM {{source('stock_market_data', 'tripadvisor_stock_data_results')}}
)

SELECT DISTINCT * FROM combined 
{% if is_incremental() %}
WHERE date >= (SELECT MAX(date) FROM {{ this }})
{%endif%}
ORDER BY symbol, date