library("tseries")
library(forecast)
#Load the data to R
load("mocdata.RData")
View(rapid)
# Now take quarterly means (the dlm code does not work for the whole dataset - too many points)

rapid$Quarter<-floor(rapid$MM/4)+2
rapid$qyyyy <- paste(rapid$YY,rapid$Quarter, sep='-')
rapidmean <- tapply(rapid$moc,rapid$qyyyy,mean)

# Now convert it to a time series object. This is the data you should work with
rapidmean.ts <- ts(as.vector(rapidmean),start=c(2017,2),frequency = 4)
plot(rapidmean.ts)
rapidmean.ts

#Plot ACF and PACF for the timeseries data.
par(mfrow=c(1,2))
acf(rapidmean.ts,lag.max=30)
pacf(rapidmean.ts,lag.max=30)

#use the AIC/BIC criterion to determine the order of the ARMA process
P_order_values <- 1:3  # AutoRegressive order
Q_order_values <- 1:3  # Moving Average order

Akaike_Criterion_values <- matrix(NA, nrow = length(P_order_values), ncol = length(Q_order_values))
Bayesian_Criterion_Values <- matrix(NA, nrow = length(P_order_values), ncol = length(Q_order_values))

for (p in P_order_values) {
     for (q in Q_order_values) {
    fit <- arima(rapidmean.ts, order = c(p, 0, q))
       Akaike_Criterion_values [p , q ] <- AIC(fit)  
    Bayesian_Criterion_Values [p , q ] <- BIC(fit)
  }
}


print("AIC values for models with different values of p and q :")
print(Akaike_Criterion_values)
print("AIC values for models with different values of p and q :")
print(Bayesian_Criterion_Values)

best_aic <- which(Akaike_Criterion_values == min(Akaike_Criterion_values), arr.ind = TRUE)
best_bic <- which(Bayesian_Criterion_Values == min(Bayesian_Criterion_Values), arr.ind = TRUE)

cat("Best ARMA model using Akaike Information Criteria: AR(", best_aic[1] , "), MA(", best_aic[2], ")\n", sep="")
cat("Best ARMA model using Bayesian Information Criteria:: AR(", best_bic[1], "), MA(", best_bic[2], ")\n", sep="")


#fit arma model on the data using the best found order for AR and MA
fit_arima <- arima(rapidmean.ts, order = c(1, 0, 3))

#carry out residuals diagnostics for the ARMA model
checkresiduals(fit_arima)
# Q-Q plot for the residual of the ARMA model
residuals<-residuals(fit_arima)
qqnorm(residuals, main = "Q-Q Plot of ARMA Residuals")
qqline(residuals, col = "red", lwd = 2)

#store the fitted values of the ARMA model, calculate accuracy Metrics 
#for the model
fitted_Arima <- fitted(fit_arima)
accuracy_fitted_Arima <- accuracy(fitted_Arima, rapidmean.ts)
View(accuracy_fitted_Arima)

#check for stationarity

adf.test(rapidmean.ts, alternative = "stationary")

#carry out Differencing since the data is non-stationary
Diff1rapidmean.ts<-diff(rapidmean.ts, differences=1)
plot(Diff1rapidmean.ts)

#check if differenced data is now stationary
adf.test(Diff1rapidmean.ts, alternative = "stationary")

#Now estimate the best order using the differenced data
P_order_values <- 1:3  # AutoRegressive order
Q_order_values <- 1:3  # Moving Average order

Akaike_Criterion_values <- matrix(NA, nrow = length(P_order_values), ncol = length(Q_order_values))
Bayesian_Criterion_Values <- matrix(NA, nrow = length(P_order_values), ncol = length(Q_order_values))

for (p in P_order_values) {
  for (q in Q_order_values) {
    fit <- arima(Diff1rapidmean.ts, order = c(p, 0, q))  
    
    
    Akaike_Criterion_values [p , q ] <- AIC(fit)  
    Bayesian_Criterion_Values [p , q ] <- BIC(fit)
  }
}

print("AIC values for models with different values of p and q :")
print(Akaike_Criterion_values)
print("AIC values for models with different values of p and q :")
print(Bayesian_Criterion_Values)

best_aic <- which(Akaike_Criterion_values == min(Akaike_Criterion_values), arr.ind = TRUE)
best_bic <- which(Bayesian_Criterion_Values == min(Bayesian_Criterion_Values), arr.ind = TRUE)

cat("Best ARMA model using Akaike Information Criteria: AR(", best_aic[1] , "), MA(", best_aic[2], ")\n", sep="")
cat("Best ARMA model using Bayesian Information Criteria:: AR(", best_bic[1], "), MA(", best_bic[2], ")\n", sep="")

#FIT ARIMA MODEL ON THE NON-STATIONARY DATA
fit_arima2 <- arima(rapidmean.ts, order = c(1, 1, 1))
residuals2<-residuals(fit_arima2)

#Perform Residual Diagnostics for the ARIMA model
checkresiduals(residuals2)
# Q-Q plot for residuals of the ARIMA MODEL
qqnorm(residuals2, main = "Q-Q Plot of ARIMA (1,1,1) Residuals")
qqline(residuals2, col = "red", lwd = 2)

#store the fitted values of the ARIMA model, calculate accuracy Metrics 
#for the model
fitted_Arima2<-fitted(fit_arima2)
accuracy_fitted_Arima2 <- accuracy(fitted_Arima2, rapidmean.ts)
View(accuracy_fitted_Arima2)

#Experiment with R's auto.arima function to fit a second ARIMA model
fit_arima3 <- auto.arima(rapidmean.ts)
residuals3<-residuals(fit_arima3)

#Perform Residual Diagnostics for the second ARIMA model
checkresiduals(residuals3)
# Q-Q plot for residuals of the second ARIMA model

qqnorm(residuals3, main = "Q-Q Plot of ARIMA (2,0,1) Residuals")
qqline(residuals3, col = "red", lwd = 2)

#store the fitted values of the second ARIMA model, calculate accuracy Metrics 
#for the model
fitted_Arima3<-fitted(fit_arima3)
accuracy_fitted_Arima3 <- accuracy(fitted_Arima3, rapidmean.ts)
View(accuracy_fitted_Arima3)

  
#produce predictions for the six quarters from January-2022 to April 2023
#using the ARMA model
#Get predictions for the first five quarters (January 2022 to March 2023)  #from the fitted values.
#From the given rapidmean.ts code, first quarter starts in April 
#and 4th quarter starts in January
historical_start <- c(2021, 4)  
historical_end <- c(2022, 4)    
historical_predictions <- window(fitted_Arima, start = historical_start, end = historical_end)
#forecast the value of the unseen quarter(quarter 1, starting in April)
future_forecast <- forecast(fit_arima, h = forecast_horizon)
FIT_ARIMA_predictions <- c(historical_predictions, future_forecast$mean)
    
#create a time series object with the predictions
predictions_ts <- ts(
FIT_ARIMA_predictions, start = start(historical_range), 
frequency = frequency(rapidmean.ts)
    )
    