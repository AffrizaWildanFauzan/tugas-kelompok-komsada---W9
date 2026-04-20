data <- read.csv("walmart_cleaning.csv", stringsAsFactors = FALSE)

x <- data$Size
y <- data$Weekly_Sales
n <- length(x)

# =========================
# REGRESI LINIER SEDERHANA
# =========================
rata2 <- function(v) {
  total <- 0
  for (i in 1:length(v)) {
    total <- total + v[i]
  }
  return(total / length(v))
}

xbar <- rata2(x)
ybar <- rata2(y)

beta1 <- function(x, y) {
  a <- 0
  b <- 0
  
  for (i in 1:length(x)) {
    a <- a + (x[i] - xbar) * (y[i] - ybar)
    b <- b + (x[i] - xbar)^2
  }
  
  return(a / b)
}

b1 <- beta1(x, y)
b0 <- ybar - b1 * xbar


# NILAI PREDIKSI DAN JUMLAH KUADRAT
ytopi <- numeric(n)
ssr <- 0
sse <- 0
sst <- 0

for (i in 1:n) {
  ytopi[i] <- b0 + b1 * x[i]
  ssr <- ssr + (ytopi[i] - ybar)^2
  sse <- sse + (y[i] - ytopi[i])^2
  sst <- sst + (y[i] - ybar)^2
}


# DERAJAT BEBAS
dfr <- 1
dfe <- n - 2
dft <- n - 1

# MEAN SQUARE DAN UJI F
msr <- ssr / dfr
mse <- sse / dfe
fhit <- msr / mse

alpha <- 0.05
ftab <- qf(1 - alpha, dfr, dfe)
pvalf <- round(1 - pf(fhit, dfr, dfe), 7)

if (fhit > ftab) {
  tandaf <- ">"
  kepf <- "Tolak H0"
} else {
  tandaf <- "<="
  kepf <- "Gagal Tolak H0"
}


# KOEFISIEN DETERMINASI
rsq <- ssr / sst
radj <- 1 - ((sse / dfe) / (sst / dft))


# UJI PARSIAL (UJI t)
a <- 0
b <- 0

for (i in 1:n) {
  a <- a + x[i]^2
  b <- b + (x[i] - xbar)^2
}

seb0 <- sqrt(mse * a / (n * b))
seb1 <- sqrt(mse / b)

thit0 <- b0 / seb0
thit1 <- b1 / seb1

ttab <- qt(1 - alpha/2, dfe)

pval0 <- 2 * (1 - pt(abs(thit0), dfe))
pval1 <- 2 * (1 - pt(abs(thit1), dfe))

if (pval0 <= alpha) { 
  kept0 <- "Tolak H0"
} else {
  kept0 <- "Gagal Tolak H0"
}

if (pval1 <= alpha) {
  kept1 <- "Tolak H0"
} else {
  kept1 <- "Gagal Tolak H0"
}


# CONFIDENCE INTERVAL
ci0 <- ttab * seb0
ci1 <- ttab * seb1


# OUTPUT
cat("Dari pengujian regresi linear sederhana yang dilakukan, menghasilkan output sebagai berikut:\n")
cat("\n")

vari <- c("R²", "Adjusted R²", "Observations")
nilai <- c(rsq, radj, n)
regstat <- data.frame("Variabel" = vari, "Nilai" = nilai)
print(regstat)

cat("\n")
cat("\nDilakukan Uji Serentak\n")
cat("H0 : β1 = 0\n")
cat("H1 : β1 ≠ 0\n")
cat("\n")

source <- c("Regression", "Residual", "Total")
df <- c(dfr, dfe, dft)
SS <- c(ssr, sse, sst)
MS <- c(msr, mse, NA)
fh <- c(fhit, NA, NA)
ft <- c(ftab, NA, NA)
pvf <- c(pvalf, NA, NA)

serentak <- data.frame(
  "Source" = source,
  "df" = df,
  "SS" = SS,
  "MS" = MS,
  "F Hitung" = fh,
  "F Tabel" = ft,
  "p-value" = pvf
)
print(serentak)

cat("\n")
cat("\nKesimpulan : Karena nilai F Hitung", tandaf, "F Tabel")
cat(", maka keputusan", kepf, "\n")

cat("\nLalu dilakukan Uji Parsial\n")
cat("H0 : βi = 0, i = 0,1\n")
cat("H1 : βi ≠ 0\n")
cat("\n")

var <- c("Intercept", "Size")
coef <- c(b0, b1)
se <- c(seb0, seb1)
th <- c(thit0, thit1)
tab <- c(ttab, ttab)
pvt <- c(pval0, pval1)
kep <- c(kept0, kept1)

parsial <- data.frame(
  "Variabel" = var,
  "Coefficient" = coef,
  "Standard Error" = se,
  "T Hitung" = th,
  "T Tabel" = tab,
  "p-value" = pvt,
  "Keputusan" = kep
)
print(parsial)


cat("\nDengan CI dari masing-masing β:\n")
cat("β0 :\n")
cat("  (+)", b0 + ci0, "\n")
cat("  (-)", b0 - ci0, "\n")
cat("β1 :\n")
cat("  (+)", b1 + ci1, "\n")
cat("  (-)", b1 - ci1, "\n")

cat("\nPersamaan regresi:\n")
cat("Y =", b0, "+", b1, "X\n")



# =========================
# REGRESI LINIER BERGANDA
# =========================
data
X <- subset(data, select = -c(Type, Store, Dept, Date, Weekly_Sales, IsHoliday))
y <- data$Weekly_Sales

multiple_linear_regression <- function(x, y) {
  X <- cbind(1, as.matrix(x))
  Y <- as.matrix(y, ncol=1)
  
  p <- ncol(X) - 1
  n <- nrow(X)
  
  beta <- solve(t(X) %*% X) %*% t(X) %*% Y
  predicted <- X %*% beta
  
  y_bar <- mean(y)
  
  SSR <- sum((predicted - y_bar)^2)
  df_reg <- p
  
  SSE <- sum((y-predicted)^2)
  df_err <- n - p - 1
  
  SST <- SSR + SSE
  df_tot <- n - 1
  
  MSR <- SSR / p
  MSE <- SSE / (n - p - 1)
  
  f_val <- MSR / MSE
  p_val_f <- 1 - pf(f_val, df_reg, df_err)
  
  var_beta <- MSE * solve(t(X) %*% X)
  se_beta <- sqrt(diag(var_beta))
  
  t_val <- beta / se_beta
  p_val_t <- 2 * (1 - pt(abs(t_val), df_err))
  
  
  
  return (list(
    Beta = beta,
    SE = se_beta,
    t_value = t_val,
    p_value_t = p_val_t,
    SSR = SSR,
    SSE = SSE,
    SST = SST,
    MSR = MSR,
    MSE = MSE,
    F_val = f_val,
    p_value_f = p_val_f
  ))
}

multiple_linear_regression(X, y)

