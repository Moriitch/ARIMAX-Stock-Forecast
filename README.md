# ARIMAX-Stock-Forecast
Forecasting stock prices of PJSC "Magnit" using ARIMA and ARIMAX models in R.

# ARIMAX Stock Forecast for PJSC "Magnit"

This project presents a comparative analysis of time series forecasting models applied to the closing stock prices of PJSC "Magnit". 
The models include:

- ARIMA (AutoRegressive Integrated Moving Average)
- ARIMAX (ARIMA with eXogenous regressors)

The analysis is implemented in the R programming language using open-source libraries.

## Project Objectives

- Load and preprocess time series data from a CSV file
- Build and compare ARIMA and ARIMAX models
- Evaluate model accuracy using several statistical metrics
- Visualize forecasts and assess their predictive performance

## Features

- Data processing and cleaning using `dplyr` and `lubridate`
- Automatic model selection using `forecast::auto.arima()`
- Forecast accuracy evaluation on a test set (10% of the data)
- Visualization using `ggplot2` and `forecast` plotting functions

## Project Structure

ARIMAX-Stock-Forecast
├── data/
│ └── MGNT_140113_210924.csv # Stock price data 
├── R/
│ └── ARIMAX-Stock-Forecast.R # Main analysis script
├── results/
│ └── forecast_plots.png # Forecast plots
├── README.md # Project description

## How to Run

1. Install required R packages:

```R
install.packages(c("readr", "dplyr", "forecast", "ggplot2", "lubridate"))

```
2. Place the data file in the data/ directory.

3. Open and run the main script:

```
source("R/ARIMAX-Stock-Forecast.R")

```
### Dependencies

- **readr** — for reading CSV files

- **dplyr** — for data manipulation

- **lubridate** — for handling dates

- **forecast** — for ARIMA/ARIMAX modeling

- **ggplot2** — for visualizations

### Model Evaluation Metrics

The accuracy of forecasts is measured using the following metrics:

- **ME** (Mean Error)

- **RMSE** (Root Mean Squared Error)

- **MAE** (Mean Absolute Error)

- **MPE** (Mean Percentage Error)

- **MAPE** (Mean Absolute Percentage Error)

- **MASE** (Mean Absolute Scaled Error)

- **ACF1** (Autocorrelation of residuals at lag 1)

- **Theil’s U** — compares model quality to a naïve forecast

These metrics provide a comprehensive assessment of the model's predictive power and bias.

### Results Summary

The ARIMAX model, which incorporates exogenous variables (OPEN, HIGH, LOW, VOL), outperformed the pure ARIMA model across all accuracy metrics. This indicates that including additional market signals significantly improves forecast reliability.
