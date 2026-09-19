# North Atlantic MOC Time Series Analysis

## Overview

This project analyses quarterly **Meridional Overturning Circulation (MOC)** strength in the North Atlantic using time-series modelling and forecasting in R.

The analysis covers quarterly aggregation, ACF/PACF analysis, ARMA/ARIMA modelling, stationarity testing, model selection, residual diagnostics, accuracy evaluation, and forecasting.

## Objectives

- Convert the underlying MOC observations into a quarterly time series.
- Examine temporal dependence using ACF and PACF.
- Investigate ARMA model orders using AIC and BIC.
- Assess stationarity using the Augmented Dickey-Fuller (ADF) test.
- Apply differencing where required.
- Fit ARMA and ARIMA models.
- Compare fitted-model accuracy.
- Use `auto.arima()` as an additional modelling approach.
- Produce forecasts for the specified future periods.

## Data

The project uses the `rapid` dataset containing **3,991 observations**:

| Variable | Description |
|---|---|
| `JD` | Date-related Julian value |
| `YY` | Year |
| `MM` | Month |
| `DD` | Day |
| `moc` | MOC strength measurement |
| `Quarter` | Quarter number |
| `qyyyy` | Year-quarter identifier |

Two versions of the source data are included:

- `data/rapid.csv` — accessible tabular version of the `rapid` dataset.
- `data/mocdata.RData` — original R data file.

## Methodology

### 1. Quarterly aggregation
Observations are grouped into quarters and quarterly mean MOC values are calculated.

### 2. Time-series construction
The quarterly means are converted into an R time-series object with quarterly frequency.

### 3. ACF and PACF
Autocorrelation and partial autocorrelation plots are used to examine temporal structure and inform candidate ARMA orders.

### 4. ARMA model selection
Candidate models are evaluated using Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC).

### 5. Residual diagnostics
Fitted models are assessed using residual diagnostics and Q-Q plots.

### 6. Stationarity testing
The Augmented Dickey-Fuller test is used to assess stationarity. First differencing is investigated where required.

### 7. ARIMA modelling
An ARIMA model is fitted to the series, alongside an automatically selected model using `auto.arima()`.

### 8. Forecasting
The fitted model is used to generate forecasts for the specified future periods.

## Technologies

- R
- `tseries`
- `forecast`
- ARMA / ARIMA
- ACF / PACF
- AIC / BIC
- Augmented Dickey-Fuller testing
- Statistical forecasting

## Repository Structure

```text
north-atlantic-moc-time-series/
├── README.md
├── R/
│   └── moc_time_series_analysis.R
├── data/
│   ├── mocdata.RData
│   └── rapid.csv
├── figures/
└── report/
```

## How to Run

1. Install R and RStudio.
2. Install the required packages:

```r
install.packages(c("tseries", "forecast"))
```

3. Open `R/moc_time_series_analysis.R`.
4. Set the working directory to the repository root.
5. Run the script.

The portfolio version of the script uses:

```text
data/rapid.csv
```

## Outputs

The analysis produces time-series plots, ACF/PACF diagnostics, model-selection results, residual diagnostics, fitted-model accuracy measures, and forecasts.

The accompanying project report contains additional visualisations, results, and discussion.

## Key Skills Demonstrated

- Statistical time-series analysis
- Data preparation and aggregation
- ARMA and ARIMA modelling
- Model selection using AIC/BIC
- Stationarity testing
- Residual diagnostics
- Forecasting
- Statistical model evaluation
- R programming

## Author

**Mujeeb Sonibare**

Data Science | Data Analytics | Business Intelligence

GitHub: **MUJEEBSONIBARE**
