
# 1. Load Data
data <- read.csv("C:/Users/Constantine Calvin/OneDrive/Constantine's Work/dataset_walmart.csv")

x <- data$Weekly_Sales

# 2. Hapus NA
x <- x[!is.na(x)]
n <- length(x)

# 3. Mean
total <- 0
for (i in 1:n) {
  total <- total + x[i]
}
mean <- total / n

# 4. Sorting (Bubble Sort)
x_sorted <- x
for (i in 1:(n-1)) {
  for (j in 1:(n-i)) {
    if (x_sorted[j] > x_sorted[j+1]) {
      temp <- x_sorted[j]
      x_sorted[j] <- x_sorted[j+1]
      x_sorted[j+1] <- temp
    }
  }
}

# 5. Median
if (n %% 2 == 1) {
  median <- x_sorted[(n+1)/2]
} else {
  median <- (x_sorted[n/2] + x_sorted[n/2 + 1]) / 2
}

# 6. Q1 dan Q3 (Linear Interpolation)
pos_q1 <- (n + 1) / 4
pos_q3 <- 3 * (n + 1) / 4

# Q1
lower <- floor(pos_q1)
upper <- ceiling(pos_q1)
if (lower == upper) {
  Q1 <- x_sorted[lower]
} else {
  Q1 <- x_sorted[lower] + (pos_q1 - lower) * (x_sorted[upper] - x_sorted[lower])
}

# Q3
lower <- floor(pos_q3)
upper <- ceiling(pos_q3)
if (lower == upper) {
  Q3 <- x_sorted[lower]
} else {
  Q3 <- x_sorted[lower] + (pos_q3 - lower) * (x_sorted[upper] - x_sorted[lower])
}

# 7. IQR
IQR <- Q3 - Q1

# 8. Variance
total_var <- 0
for (i in 1:n) {
  total_var <- total_var + (x[i] - mean)^2
}
variance <- total_var / (n - 1)

# 9. Standard Deviation
sd <- variance^(1/2)

# 10. Minimum
min <- x[1]
for (i in 2:n) {
  if (x[i] < min) {
    min <- x[i]
  }
}

# 11. Maximum
max <- x[1]
for (i in 2:n) {
  if (x[i] > max) {
    max <- x[i]
  }
}

# 12. Range
range <- max - min

# 13. Skewness
total_skew <- 0
for (i in 1:n) {
  total_skew <- total_skew + (x[i] - mean)^3
}
skewness <- (total_skew / n) / (sd^3)

# 14. Kurtosis
total_kurt <- 0
for (i in 1:n) {
  total_kurt <- total_kurt + (x[i] - mean)^4
}
kurtosis <- (total_kurt / n) / (sd^4)

# 15. Output
mean
median
Q1
Q3
IQR
variance
sd
min
max
range
skewness
kurtosis

