
BIKE RENTAL DEMAND FORECASTING SQL ANALYSIS

QUERY 1 - OVERALL DEMAND KPIs

SELECT
    COUNT(*) AS total_hourly_records,
    ROUND(AVG(cnt), 2) AS average_hourly_demand,
    MIN(cnt) AS minimum_hourly_demand,
    MAX(cnt) AS maximum_hourly_demand,
    SUM(cnt) AS total_bike_rentals,
    ROUND(AVG(temp), 3) AS average_temperature,
    ROUND(AVG(hum), 3) AS average_humidity,
    ROUND(AVG(windspeed), 3) AS average_windspeed
FROM bike_demand_data;


QUERY 2 - DEMAND BY HOUR

SELECT
    hr AS hour_of_day,
    COUNT(*) AS total_records,
    ROUND(AVG(cnt), 2) AS average_demand,
    MIN(cnt) AS minimum_demand,
    MAX(cnt) AS maximum_demand,
    SUM(cnt) AS total_rentals
FROM bike_demand_data
GROUP BY hr
ORDER BY average_demand DESC;


QUERY 3 - DEMAND BY WEEKDAY

SELECT
    weekday,

    CASE weekday
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS weekday_name,

    COUNT(*) AS total_records,
    ROUND(AVG(cnt), 2) AS average_demand,
    SUM(cnt) AS total_rentals

FROM bike_demand_data

GROUP BY weekday

ORDER BY average_demand DESC;


QUERY 4 - DEMAND BY MONTH

SELECT
    mnth AS month_number,

    CASE mnth
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name,

    COUNT(*) AS total_records,
    ROUND(AVG(cnt), 2) AS average_demand,
    MAX(cnt) AS maximum_demand,
    SUM(cnt) AS total_rentals

FROM bike_demand_data

GROUP BY mnth

ORDER BY mnth;


QUERY 5 - DEMAND BY SEASON

SELECT
    season,

    CASE season
        WHEN 1 THEN 'Winter'
        WHEN 2 THEN 'Spring'
        WHEN 3 THEN 'Summer'
        WHEN 4 THEN 'Fall'
    END AS season_name,

    COUNT(*) AS total_records,
    ROUND(AVG(cnt), 2) AS average_demand,
    MAX(cnt) AS maximum_demand,
    SUM(cnt) AS total_rentals

FROM bike_demand_data

GROUP BY season

ORDER BY average_demand DESC;


QUERY 6 - DEMAND BY WEATHER

SELECT
    weathersit AS weather_code,

    CASE weathersit
        WHEN 1 THEN 'Clear or Partly Cloudy'
        WHEN 2 THEN 'Mist or Cloudy'
        WHEN 3 THEN 'Light Rain or Snow'
        WHEN 4 THEN 'Heavy Rain or Snow'
    END AS weather_condition,

    COUNT(*) AS total_records,
    ROUND(AVG(cnt), 2) AS average_demand,
    MIN(cnt) AS minimum_demand,
    MAX(cnt) AS maximum_demand,
    SUM(cnt) AS total_rentals

FROM bike_demand_data

GROUP BY weathersit

ORDER BY average_demand DESC;


QUERY 7 - WORKING DAY ANALYSIS

SELECT
    workingday,

    CASE workingday
        WHEN 1 THEN 'Working Day'
        WHEN 0 THEN 'Weekend or Holiday'
    END AS day_type,

    COUNT(*) AS total_records,
    ROUND(AVG(cnt), 2) AS average_demand,
    MAX(cnt) AS maximum_demand,
    SUM(cnt) AS total_rentals

FROM bike_demand_data

GROUP BY workingday

ORDER BY average_demand DESC;


QUERY 8 - YEARLY DEMAND GROWTH

WITH yearly_demand AS (
    SELECT
        yr,

        CASE yr
            WHEN 0 THEN 2011
            WHEN 1 THEN 2012
        END AS calendar_year,

        SUM(cnt) AS total_rentals,
        ROUND(AVG(cnt), 2) AS average_hourly_demand

    FROM bike_demand_data

    GROUP BY yr
),

yearly_comparison AS (
    SELECT
        calendar_year,
        total_rentals,
        average_hourly_demand,

        LAG(total_rentals) OVER (
            ORDER BY calendar_year
        ) AS previous_year_rentals

    FROM yearly_demand
)

SELECT
    calendar_year,
    total_rentals,
    average_hourly_demand,
    previous_year_rentals,

    ROUND(
        (
            total_rentals - previous_year_rentals
        ) * 100.0 /
        previous_year_rentals,
        2
    ) AS rental_growth_percentage

FROM yearly_comparison

ORDER BY calendar_year;


QUERY 9 - PEAK DEMAND COMBINATIONS

SELECT
    hr AS hour_of_day,

    CASE weekday
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS weekday_name,

    CASE weathersit
        WHEN 1 THEN 'Clear or Partly Cloudy'
        WHEN 2 THEN 'Mist or Cloudy'
        WHEN 3 THEN 'Light Rain or Snow'
        WHEN 4 THEN 'Heavy Rain or Snow'
    END AS weather_condition,

    COUNT(*) AS total_observations,
    ROUND(AVG(cnt), 2) AS average_demand,
    MAX(cnt) AS maximum_demand

FROM bike_demand_data

GROUP BY
    hr,
    weekday,
    weathersit

HAVING COUNT(*) >= 10

ORDER BY average_demand DESC

LIMIT 20;


QUERY 10 - DEMAND CATEGORY DISTRIBUTION

WITH demand_categories AS (
    SELECT
        cnt,

        CASE
            WHEN cnt < 50 THEN 'Very Low'
            WHEN cnt < 150 THEN 'Low'
            WHEN cnt < 300 THEN 'Medium'
            WHEN cnt < 500 THEN 'High'
            ELSE 'Very High'
        END AS demand_category

    FROM bike_demand_data
)

SELECT
    demand_category,
    COUNT(*) AS total_hours,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM demand_categories
        ),
        2
    ) AS percentage_of_hours,
    ROUND(AVG(cnt), 2) AS average_demand

FROM demand_categories

GROUP BY demand_category

ORDER BY
    CASE demand_category
        WHEN 'Very Low' THEN 1
        WHEN 'Low' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'High' THEN 4
        WHEN 'Very High' THEN 5
    END;


QUERY 11 - FORECAST PERFORMANCE

SELECT
    COUNT(*) AS total_predictions,

    ROUND(
        AVG(actual_demand),
        2
    ) AS average_actual_demand,

    ROUND(
        AVG(predicted_demand),
        2
    ) AS average_predicted_demand,

    ROUND(
        AVG(ABS(actual_demand - predicted_demand)),
        2
    ) AS mean_absolute_error,

    ROUND(
        AVG(
            (actual_demand - predicted_demand) *
            (actual_demand - predicted_demand)
        ),
        2
    ) AS mean_squared_error,

    ROUND(
        AVG(actual_demand - predicted_demand),
        2
    ) AS average_prediction_error

FROM bike_demand_predictions;


QUERY 12 - FORECAST ERROR BY HOUR

SELECT
    hour,

    COUNT(*) AS total_predictions,

    ROUND(
        AVG(actual_demand),
        2
    ) AS average_actual_demand,

    ROUND(
        AVG(predicted_demand),
        2
    ) AS average_predicted_demand,

    ROUND(
        AVG(absolute_error),
        2
    ) AS mean_absolute_error,

    ROUND(
        MAX(absolute_error),
        2
    ) AS maximum_absolute_error

FROM bike_demand_predictions

GROUP BY hour

ORDER BY mean_absolute_error DESC;


QUERY 13 - HIGHEST FORECAST ERRORS

SELECT
    datetime,
    hour,
    actual_demand,
    ROUND(predicted_demand, 2) AS predicted_demand,
    ROUND(prediction_error, 2) AS prediction_error,
    ROUND(absolute_error, 2) AS absolute_error

FROM bike_demand_predictions

ORDER BY absolute_error DESC

LIMIT 20;


QUERY 14 - HOURLY DEMAND RANKING

WITH hourly_summary AS (
    SELECT
        hr AS hour_of_day,
        ROUND(AVG(cnt), 2) AS average_demand,
        MAX(cnt) AS maximum_demand,
        SUM(cnt) AS total_rentals

    FROM bike_demand_data

    GROUP BY hr
)

SELECT
    hour_of_day,
    average_demand,
    maximum_demand,
    total_rentals,

    RANK() OVER (
        ORDER BY average_demand DESC
    ) AS demand_rank

FROM hourly_summary

ORDER BY demand_rank;


QUERY 15 - ENVIRONMENTAL ANALYSIS

WITH environmental_groups AS (
    SELECT
        cnt,

        CASE
            WHEN temp < 0.25 THEN 'Cold'
            WHEN temp < 0.50 THEN 'Moderate'
            WHEN temp < 0.75 THEN 'Warm'
            ELSE 'Hot'
        END AS temperature_group,

        CASE
            WHEN hum < 0.40 THEN 'Low Humidity'
            WHEN hum < 0.70 THEN 'Moderate Humidity'
            ELSE 'High Humidity'
        END AS humidity_group

    FROM bike_demand_data
)

SELECT
    temperature_group,
    humidity_group,
    COUNT(*) AS total_records,
    ROUND(AVG(cnt), 2) AS average_demand,
    MAX(cnt) AS maximum_demand

FROM environmental_groups

GROUP BY
    temperature_group,
    humidity_group

ORDER BY average_demand DESC;

