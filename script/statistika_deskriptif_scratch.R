# 1. Load Data
set.seed(42)
df<-read.csv("~/Downloads/dataset_walmart.csv")

# STATISTIKA DESKRIPTIF (SCRATCH)

# 1. Mean
mean_scratch <- function(x) {
  n <- length(x)
  total <- 0
  for (i in 1:n) {
    total <- total + x[i]
  }
  return(total / n)
}

# 2. Median
median_scratch <- function(x) {
  n <- length(x)
  # sorting
  for (i in 1:(n-1)) {
    for (j in 1:(n-i)) {
      if (x[j] > x[j+1]) {
        temp <- x[j]
        x[j] <- x[j+1]
        x[j+1] <- temp
      }
    }
  }
  if (n %% 2 == 1) {
    return(x[(n+1)/2])
  } else {
    return((x[n/2] + x[n/2 + 1]) / 2)
  }
}
# 3. Variance
variance_scratch <- function(x) {
  n <- length(x)
  mean <- mean_scratch(x)
  total_var <- 0
  for (i in 1:n) {
    total_var <- total_var + (x[i] - mean)^2
  }
  return(total_var / (n - 1))
}
# 4. Standard Deviation
sd_scratch <- function(x) {
  return(sqrt(variance_scratch(x)))
}
# 5. Quartile (Q1, Median, Q3)
quartile_scratch <- function(x) {
  n <- length(x)
  # sorting
  for (i in 1:(n-1)) {
    for (j in 1:(n-i)) {
      if (x[j] > x[j+1]) {
        temp <- x[j]
        x[j] <- x[j+1]
        x[j+1] <- temp
      }
    }
  }
  pos_q1 <- (n + 1) / 4
  pos_q2 <- (n + 1) / 2
  pos_q3 <- 3 * (n + 1) / 4
  get_q <- function(pos) {
    lower <- floor(pos)
    upper <- ceiling(pos)
    if (lower == upper) {
      return(x[lower])
    } else {
      return(x[lower] + (pos - lower) * (x[upper] - x[lower]))
    }
  }
  return(list(
    Q1 = get_q(pos_q1),
    median = get_q(pos_q2),
    Q3 = get_q(pos_q3)
  ))
}
# 6. Mode
mode_scratch <- function(x) {
  n <- length(x)
  uniq <- c()
  freq <- c()
  for (i in 1:n) {
    found <- FALSE
    for (j in 1:length(uniq)) {
      if (x[i] == uniq[j]) {
        freq[j] <- freq[j] + 1
        found <- TRUE
        break
      }
    }
    if (!found) {
      uniq <- c(uniq, x[i])
      freq <- c(freq, 1)
    }
  }
  max_freq <- freq[1]
  mode <- uniq[1]
  for (i in 2:length(freq)) {
    if (freq[i] > max_freq) {
      max_freq <- freq[i]
      mode <- uniq[i]
    }
  }
  return(mode)
}
# 7. Min & Max
min_scratch <- function(x) {
  min_val <- x[1]
  for (i in 2:length(x)) {
    if (x[i] < min_val) {
      min_val <- x[i]
    }
  }
  return(min_val)
}

max_scratch <- function(x) {
  max_val <- x[1]
  for (i in 2:length(x)) {
    if (x[i] > max_val) {
      max_val <- x[i]
    }
  }
  
  return(max_val)
}

# CONTOH PEMAKAIAN

x <- data$Weekly_Sales

mean_x<-mean_scratch(x)
median_x<-median_scratch(x)
var_x<-variance_scratch(x)
std_x<-sd_scratch(x)
quart_x<-quartile_scratch(x)
mode_x<-mode_scratch(x)
min_x<-min_scratch(x)
max_x<-max_scratch(x)

hasil_df<-data.frame(
  mean<-mean_x,
  median<-median_x,
  var<-var_x,
  std<-std_x,
  quart<-quart_x,
  mode<-mode_x,
  min<-min_x,
  max<-max_x
)
print(hasil_df)
