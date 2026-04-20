# ==============================================================================
# ANALISIS TIME SERIES: WALMART SALES (STORE 1, DEPT 1)
# ==============================================================================

library(dplyr)
library(lubridate)
library(forecast)
library(tseries)

# --- 1. IMPORT & PREPROCESSING ---
# Membaca data dan memfilter spesifik pada Store 1 dan Dept 1
df = read.csv("C:/Users/Jason/Downloads/walmart_cleaning.csv")


ts_data = df %>%
  filter(Store == 1, Dept == 1) %>%
  mutate(Date = as.Date(Date)) %>%
  arrange(Date)

# Membuat objek Time Series dengan frekuensi 52 (data mingguan)
ts_object = ts(ts_data$Weekly_Sales, frequency = 52)

# Visualisasi data asli untuk identifikasi tren dan musiman
plot(ts_object, col = "blue", type = 'l', lwd = 1, main = "Data Penjualan Mingguan")

# --- 2. FUNGSI HELPER VISUALISASI ---
# Fungsi untuk memplot perbandingan data asli dengan hasil smoothing/forecast
plot_smoothing = function(original_ts, forecast_values, method_name, line_color = "red"){
  forecast_ts = ts(forecast_values, 
                   start = start(original_ts), 
                   frequency = frequency(original_ts))
  y_limit = max(original_ts)*1.3
  
  plot(original_ts, col = "blue", type = "l", lwd = 2,
       main = paste("Smoothing: ", method_name, " vs Data Asli"),
       ylab = "Weekly Sales", xlab = "Time", ylim = c(0, y_limit))
  
  lines(forecast_ts, col = line_color, lwd = 2)
  legend("topleft", legend = c("Original", method_name),
         col = c("blue", line_color), lty = 1, lwd = 2)
}

# --- 3. METODE SMOOTHING MANUAL ---

# A. Moving Average (MA): Meratakan fluktuasi jangka pendek
moving_average = function(data, k){
  n = length(data)
  res = rep(NA, n)
  for(i in k:n){
    window = data[(i-k+1):i]
    res[i] = mean(window)
  }
  return(res)
}

hasil_ma = moving_average(ts_object, k = 4)
plot_smoothing(ts_object, hasil_ma, "Moving Average")

# B. Single Exponential Smoothing (SES): Bobot eksponensial untuk data level
single_es = function(data, alpha){
  n = length(data)
  f = rep(NA, n+1)
  f[1] = data[1] # Inisialisasi awal
  for(t in 1:n){
    f[t+1] = alpha*data[t] + (1-alpha)*f[t]
  }
  return(f)
}

hasil_single_es = single_es(ts_object, alpha = 0.3)
plot_smoothing(ts_object, hasil_single_es, "SES")

# C. Double Exponential Smoothing (Holt): Menangani data dengan Tren
double_es = function(data, alpha, beta){
  n = length(data)
  level = rep(NA, n); trend = rep(NA, n); forecast = rep(NA, n+1)
  level[1] = data[1]
  trend[1] = data[2]-data[1]
  forecast[2] = trend[1]+level[1]
  for(t in 2:n){
    level[t] = alpha*data[t] + (1-alpha) * (level[t-1] + trend[t-1])
    trend[t] = beta*(level[t]-level[t-1]) + (1-beta)*trend[t-1]
    forecast[t+1] = level[t] + trend[t]
  }
  return(forecast)
}

hasil_double_es = double_es(ts_object, alpha = 0.3, beta = 0.2)
plot_smoothing(ts_object, hasil_double_es, "Double ES")

# D. Holt-Winters (Triple ES): Menangani Level, Tren, dan Musiman (L=52)
triple_es = function(data, alpha, beta, gamma, L){
  n = length(data)
  level = rep(NA, n); trend = rep(NA, n); season = rep(NA, n); forecast = rep(NA, n+1)
  
  # Inisialisasi awal berbasis siklus musiman pertama (L)
  level[L] = mean(data[1:L])
  trend[L] = ((mean(data[(L+1):(2*L)])) - mean(data[1:L])) / L
  for(i in 1:L) { season[i] = data[i] - level[L] }
  
  for(t in (L+1):n){
    level[t] = alpha*(data[t] - season[t-L]) + (1-alpha) * (level[t-1] + trend[t-1])
    trend[t] = beta * (level[t]-level[t-1]) + (1-beta) * trend[t-1]
    season[t] = gamma * (data[t] - level[t]) + (1-gamma) * season[t-L]
    forecast[t+1] = level[t] + trend[t] + season[t-L+1]
  }
  return(forecast)
}

hasil_hw = triple_es(ts_object, alpha = 0.2, beta = 0.1, gamma = 0.3, L = 52)
plot_smoothing(ts_object, hasil_hw, "Holt Winters")

# --- 4. IDENTIFIKASI ARIMA (ACF & PACF MANUAL) ---

# Fungsi ACF Manual: Mengukur autokorelasi lag 0 sampai max_lag
acf_manual = function(data, max_lag){
  n = length(data); mu = mean(data); denom = sum((data-mu)^2)
  acf_values = rep(0, max_lag+1)
  for(k in 0:max_lag){
    y_t = data[(k+1):n]; y_lag = data[1:(n-k)]
    num = sum((y_t-mu)*(y_lag-mu))
    acf_values[k+1] = num/denom
  }
  return(acf_values)
}

plot_manual_acf = function(data, max_lag){
  acf_values = acf_manual(data, max_lag)
  n = length(data); ci = 1.96/sqrt(n)
  plot(0:max_lag, acf_values, type ="h", ylim = c(-1,1), main = "Manual ACF Plot",
       xlab = "Lag", ylab = "Autocorrelation", lwd = 2)
  abline(h = 0); abline(h = c(ci,-ci), col = "red", lty = 2)
}
plot_manual_acf(ts_object, 20)

# Fungsi PACF Manual: Menggunakan pendekatan OLS (Regresi Linear)
plot_manual_pacf = function(data, max_lag){
  n = length(data); pacf_values = numeric(max_lag); ci = 1.96 / sqrt(n)
  for(k in 1:max_lag){
    Y = data[(k+1):n]; n_rows = length(Y); X = matrix(NA, nrow = n_rows, ncol = k)
    for(i in 1:k){ X[,i] = data[(k+1-i):(n-i)] }
    model = lm(Y~X)
    pacf_values[k] = coef(model)[k+1]
  }
  lags_pacf = 1:max_lag
  plot(lags_pacf, pacf_values, type = "h", lwd = 2, col = "darkgreen",
       main = "Manual PACF Plot", xlab = "Lag", ylab = "Partial Autocorrelation", ylim = c(-1,1))
  abline(h = 0, col ="black"); abline(h = c(ci,-ci), col = "red", lty = 2)
}
plot_manual_pacf(ts_object, 20)
# --- 5. PEMODELAN ARIMA ---


# Cek Stasioneritas (ADF Test)
adf.test(ts_object)

# Estimasi Transformasi Box-Cox
lambda1 = BoxCox.lambda(ts_object)

# Fitting Model ARIMA berdasarkan observasi plot
model1 = arima(ts_object, order = c(2,0,0)) # Model AR(2)
model2 = arima(ts_object, order = c(0,0,1)) # Model MA(1)
AIC(model1, model2)

# --- 6. DIAGNOSTIK RESIDUAL (LJUNG-BOX MANUAL) ---
# Menguji apakah residual bersifat White Noise (p-value > 0.05)
ljung_box = function(data, lag){
  data_clean = na.omit(data)
  n = length(data_clean)
  acf_values = acf_manual(data_clean, lag)[-1] # Mengambil lag 1 ke atas
  Q = 0
  for(k in 1:lag){ Q = Q + (acf_values[k]^2/(n-k)) }
  Q = Q * n*(n+2)
  p_value = 1-pchisq(Q, df = lag)
  return(list(Q_stat= Q, p_value = p_value))
}

# Uji pada model terpilih
ljung_box(model1$residuals, 5)
