# Bike Rental Demand Forecasting

## Project Overview

This project develops an advanced predictive analytics solution to forecast hourly bike-rental demand using historical, calendar, weather and environmental data.

The project combines exploratory data analysis, feature engineering, statistical modelling, machine learning, time-series validation, hyperparameter tuning, SQL analysis and forecast-error evaluation.

## Business Problem

Bike-sharing companies need accurate demand estimates to maintain bike availability and reduce shortages. This forecasting solution can support:

- Hourly demand planning
- Bike allocation
- Workforce management
- Maintenance scheduling
- Shortage reduction
- Better customer experience

## Dataset

The project uses the UCI Bike Sharing Dataset.

- Hourly records: approximately 17,000
- Historical period: 2011 to 2012
- Target variable: `cnt`
- Target meaning: total hourly bike rentals
- Dataset file: `hour.csv`

## Tools and Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- SQLite
- SQL
- Microsoft Excel
- Google Colab
- Joblib

## Project Workflow

1. Business-problem definition
2. Dataset validation
3. Exploratory data analysis
4. Data preprocessing
5. Time-based feature engineering
6. Data-leakage prevention
7. Chronological train-test split
8. Baseline forecasting
9. Machine-learning model training
10. Time-series cross-validation
11. Hyperparameter tuning
12. Model evaluation
13. Feature-importance analysis
14. Forecast-error analysis
15. SQL business analysis
16. Model saving

## Data-Leakage Prevention

The following relationship exists in the original dataset:

```text
casual + registered = cnt
```

Therefore, `casual` and `registered` were excluded from model predictors because they directly reveal the target.

All rolling-demand features were shifted before calculation so they only used past observations.

## Feature Engineering

The project created:

- Day of month
- Day of year
- Week of year
- Weekend indicator
- Time index
- Cyclical hour features
- Cyclical month features
- Previous-hour demand
- Previous-day demand
- Previous-week demand
- 24-hour rolling mean
- 24-hour rolling standard deviation
- 168-hour rolling mean

## Models Evaluated

- Naive Lag-24 Baseline
- Linear Regression
- Random Forest Regressor
- Histogram Gradient Boosting Regressor
- Tuned Histogram Gradient Boosting Regressor

## Evaluation Metrics

- Mean Absolute Error
- Root Mean Squared Error
- R-squared score
- Mean Absolute Percentage Error
- Time-series cross-validation score

## Validation Strategy

The dataset was divided chronologically:

- First 80%: Training data
- Latest 20%: Testing data

`TimeSeriesSplit` was used during hyperparameter tuning to maintain chronological order and avoid future-data leakage.

## SQL Analysis

Fifteen SQL queries were created to analyse:

- Overall demand KPIs
- Hourly demand
- Weekday demand
- Monthly demand
- Seasonal demand
- Weather impact
- Working-day patterns
- Year-over-year growth
- Peak-demand combinations
- Demand categories
- Forecast performance
- Forecast error by hour
- Highest prediction errors
- Demand ranking
- Environmental conditions

## Main Visualization

![Actual vs Predicted Demand](visualizations/06_actual_vs_predicted.png)

## Repository Structure

```text
bike-rental-demand-forecasting/
├── data/
├── models/
├── notebooks/
├── reports/
├── sql/
├── visualizations/
├── .gitignore
├── requirements.txt
└── README.md
```

## Limitations

- The dataset covers only 2011 and 2012.
- Future weather information would be required for operational forecasting.
- Lag-based forecasts require recent demand observations.
- Demand patterns may change over time.
- The model should be monitored and periodically retrained.

## Author

**Tanmay Pandey**

B.Tech Computer Science — Artificial Intelligence and Machine Learning  
Allenhouse Institute of Technology