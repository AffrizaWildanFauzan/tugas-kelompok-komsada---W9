# ==============================================================================
# ANALISIS REGRESI LOGISTIK BINER
# Dataset: Walmart Sales (walmart_cleaning.csv)
# ==============================================================================
# Tujuan  : Memprediksi probabilitas sebuah minggu adalah minggu liburan
#           (IsHoliday = TRUE) berdasarkan variabel ekonomi & penjualan.
#
# Target  : IsHoliday_Num   (1 = Liburan, 0 = Non-Liburan)
# Prediktor:
#   - Weekly_Sales   (penjualan mingguan)
#   - Temperature    (suhu)
#   - Fuel_Price     (harga BBM)
#   - CPI            (indeks harga konsumen)
#   - Unemployment   (tingkat pengangguran)
#
# Teknik yang digunakan (mengikuti materi):
#   1. glm() sebagai baseline / pembanding
#   2. Newton-Raphson (dari nol, dengan turunan log-likelihood)
#   3. IRLS / Iteratively Reweighted Least Squares (dari nol)
# ==============================================================================

set.seed(42)

# ------------------------------------------------------------------------------
# 1. LOAD DATA
# ------------------------------------------------------------------------------
data <- read.csv("walmart_cleaning.csv", stringsAsFactors = FALSE)

cat("Dimensi data :", nrow(data), "baris x", ncol(data), "kolom\n")
cat("Distribusi IsHoliday_Num :\n")
print(table(data$IsHoliday_Num))

# ------------------------------------------------------------------------------
# 2. PERSIAPAN DATA
# ------------------------------------------------------------------------------
# Dataset asli berukuran ~420K baris. Newton-Raphson & IRLS membutuhkan
# operasi matriks W (n x n) pada setiap iterasi, yang mahal untuk n sebesar ini.
# Supaya iterasi manual tetap cepat tanpa mengubah rumus matematisnya,
# kita ambil sampel stratified sehingga proporsi IsHoliday = TRUE tetap terjaga.

n_sample <- 5000
idx_holiday    <- which(data$IsHoliday_Num == 1)
idx_nonholiday <- which(data$IsHoliday_Num == 0)

prop_holiday <- length(idx_holiday) / nrow(data)
n_holiday    <- round(n_sample * prop_holiday)
n_nonholiday <- n_sample - n_holiday

sampel_idx <- c(
  sample(idx_holiday,    n_holiday),
  sample(idx_nonholiday, n_nonholiday)
)
df <- data[sampel_idx, ]

cat("\nUkuran sampel :", nrow(df), "\n")
cat("Proporsi IsHoliday = 1 di sampel :",
    round(mean(df$IsHoliday_Num), 4), "\n")

# Standardisasi prediktor numerik (menghindari matriks Hessian near-singular
# akibat skala variabel yang sangat berbeda, mis. CPI ~170 vs Fuel_Price ~3)
vars_x <- c("Weekly_Sales", "Temperature", "Fuel_Price", "CPI", "Unemployment")
df_std <- df
for (v in vars_x) {
  df_std[[v]] <- (df[[v]] - mean(df[[v]])) / sd(df[[v]])
}

# Matriks desain X (tambahkan kolom 1 untuk intercept)
X <- as.matrix(cbind(
  Intercept    = 1,
  Weekly_Sales = df_std$Weekly_Sales,
  Temperature  = df_std$Temperature,
  Fuel_Price   = df_std$Fuel_Price,
  CPI          = df_std$CPI,
  Unemployment = df_std$Unemployment
))

# Vektor respons Y
Y <- as.matrix(df_std$IsHoliday_Num)

cat("\nDimensi X :", dim(X)[1], "x", dim(X)[2], "\n")
cat("Dimensi Y :", dim(Y)[1], "x", dim(Y)[2], "\n")

# ==============================================================================
# 3. METODE 1: glm() SEBAGAI BASELINE
# ==============================================================================
cat("\n==============================================================\n")
cat(" METODE 1: REGRESI LOGISTIK DENGAN glm() (BASELINE)\n")
cat("==============================================================\n")

rlb <- glm(IsHoliday_Num ~ Weekly_Sales + Temperature + Fuel_Price +
             CPI + Unemployment,
           data = df_std, family = binomial)

cat("\n--- Ringkasan Model glm ---\n")
print(summary(rlb))

beta_glm <- as.matrix(coef(rlb))
cat("\n--- Koefisien Beta (glm) ---\n")
print(round(beta_glm, 6))

# Contoh perhitungan probabilitas untuk 5 observasi pertama
cat("\n--- Contoh probabilitas pi(x) dari glm (5 obs pertama) ---\n")
pix_glm <- 1 / (1 + exp(-X %*% beta_glm))
print(round(pix_glm[1:5], 4))

# ==============================================================================
# 4. METODE 2: NEWTON-RAPHSON (DARI NOL)
# ==============================================================================
# Rumus matematis (sesuai materi):
#
#   pi_i    = 1 / (1 + exp(-X_i^T beta))
#   W       = diag( pi_i * (1 - pi_i) )
#   Gradien U   = X^T (Y - pi)
#   Hessian H   = -X^T W X
#
#   beta_(t+1) = beta_(t) - H^(-1) U
#              = beta_(t) + (X^T W X)^(-1) X^T (Y - pi)
#
# Catatan implementasi:
#   Matriks diagonal W berukuran n x n. Untuk efisiensi, kita simpan W hanya
#   sebagai VEKTOR w berisi elemen diagonalnya, lalu hitung X^T W X sebagai
#   t(X) %*% (w * X). Ini MATEMATIKANYA SAMA dengan diag(w), hanya
#   implementasinya yang lebih efisien.
# ==============================================================================
cat("\n==============================================================\n")
cat(" METODE 2: NEWTON-RAPHSON (DARI NOL)\n")
cat("==============================================================\n")

# ---- Inisialisasi ----
beta_nr   <- matrix(0, nrow = ncol(X), ncol = 1)  # tebakan awal: semua nol
toleransi <- 1e-6
maks_iter <- 50
selisih   <- 100
iterasi   <- 0

cat("\n--- Progress Iterasi ---\n")

# ---- Loop Newton-Raphson ----
while (selisih > toleransi && iterasi < maks_iter) {

  # (1) Vektor probabilitas pi_i = 1 / (1 + exp(-X beta))
  pi_i <- 1 / (1 + exp(-X %*% beta_nr))

  # (2) Elemen diagonal matriks W = pi_i * (1 - pi_i)
  w <- as.vector(pi_i * (1 - pi_i))

  # (3) Vektor Gradien U = X^T (Y - pi)
  U <- t(X) %*% (Y - pi_i)

  # (4) Matriks Hessian H = -X^T W X
  #     Implementasi efisien: t(X) %*% (w * X) ekuivalen t(X) %*% diag(w) %*% X
  H <- -t(X) %*% (w * X)

  # (5) Update parameter: beta_baru = beta_lama - H^(-1) U
  beta_baru <- beta_nr - solve(H) %*% U

  # (6) Cek konvergensi (max selisih absolut antar elemen beta)
  selisih <- max(abs(beta_baru - beta_nr))
  beta_nr <- beta_baru
  iterasi <- iterasi + 1

  cat(sprintf("  Iterasi %2d | Selisih: %.8f\n", iterasi, selisih))
}

if (selisih <= toleransi) {
  cat("\n>>> Konvergen dalam", iterasi, "iterasi.\n")
} else {
  cat("\n>>> Maksimum iterasi tercapai tanpa konvergen.\n")
}

cat("\n--- Koefisien Beta (Newton-Raphson) ---\n")
beta_nr_named <- beta_nr
rownames(beta_nr_named) <- colnames(X)
print(round(beta_nr_named, 6))

# ==============================================================================
# 5. METODE 3: IRLS / ITERATIVELY REWEIGHTED LEAST SQUARES (DARI NOL)
# ==============================================================================
# Rumus matematis (sesuai materi):
#
#   pi_i = 1 / (1 + exp(-X beta))
#   W    = diag( pi_i * (1 - pi_i) )
#
#   Working Response:
#     z = X beta + W^(-1) (Y - pi)
#
#   Update (rumus WLS):
#     beta_(t+1) = (X^T W X)^(-1) X^T W z
#
# Secara aljabar, rumus update IRLS dan Newton-Raphson untuk regresi logistik
# adalah IDENTIK, sehingga hasil keduanya harus sama.
# IRLS "membungkus" langkah update dalam bentuk regresi WLS terhadap
# working response z, yang lebih intuitif bagi orang yang familiar dengan OLS.
# ==============================================================================
cat("\n==============================================================\n")
cat(" METODE 3: IRLS (DARI NOL)\n")
cat("==============================================================\n")

# ---- Inisialisasi ----
beta_irls <- matrix(0, nrow = ncol(X), ncol = 1)
toleransi <- 1e-6
maks_iter <- 50
selisih   <- 100
iterasi   <- 0

cat("\n--- Progress Iterasi ---\n")

# ---- Loop IRLS ----
while (selisih > toleransi && iterasi < maks_iter) {

  # (1) Vektor probabilitas pi_i
  pi_i <- 1 / (1 + exp(-X %*% beta_irls))

  # (2) Elemen diagonal W
  w <- as.vector(pi_i * (1 - pi_i))

  # (3) Working Response: z = X beta + (Y - pi) / w
  #     (1/w adalah diagonal W^(-1), sehingga W^(-1)(Y-pi) = (Y-pi)/w)
  z <- X %*% beta_irls + (Y - pi_i) / w

  # (4) Update beta dengan rumus WLS:
  #     beta_baru = (X^T W X)^(-1) X^T W z
  XtWX <- t(X) %*% (w * X)
  XtWz <- t(X) %*% (w * z)
  beta_baru <- solve(XtWX) %*% XtWz

  # (5) Cek konvergensi
  selisih   <- max(abs(beta_baru - beta_irls))
  beta_irls <- beta_baru
  iterasi   <- iterasi + 1

  cat(sprintf("  Iterasi %2d | Selisih: %.8f\n", iterasi, selisih))
}

if (selisih <= toleransi) {
  cat("\n>>> Konvergen dalam", iterasi, "iterasi.\n")
} else {
  cat("\n>>> Maksimum iterasi tercapai tanpa konvergen.\n")
}

cat("\n--- Koefisien Beta (IRLS) ---\n")
beta_irls_named <- beta_irls
rownames(beta_irls_named) <- colnames(X)
print(round(beta_irls_named, 6))

# ==============================================================================
# 6. PERBANDINGAN KOEFISIEN KETIGA METODE
# ==============================================================================
cat("\n==============================================================\n")
cat(" PERBANDINGAN KOEFISIEN: glm vs Newton-Raphson vs IRLS\n")
cat("==============================================================\n")

banding <- data.frame(
  Variabel        = colnames(X),
  glm             = round(as.vector(beta_glm),  6),
  Newton_Raphson  = round(as.vector(beta_nr),   6),
  IRLS            = round(as.vector(beta_irls), 6)
)
print(banding)

# Selisih numerik antar metode
cat("\n--- Selisih Maksimum Antar Metode ---\n")
cat("  |glm - NR|    :", max(abs(beta_glm  - beta_nr)),   "\n")
cat("  |glm - IRLS|  :", max(abs(beta_glm  - beta_irls)), "\n")
cat("  |NR  - IRLS|  :", max(abs(beta_nr   - beta_irls)), "\n")

# ==============================================================================
# 7. INTERPRETASI: ODDS RATIO
# ==============================================================================
# Odds Ratio = exp(beta_j)
# - OR > 1  : kenaikan 1 satuan (std) variabel tsb meningkatkan odds IsHoliday
# - OR < 1  : kenaikan 1 satuan (std) variabel tsb menurunkan odds IsHoliday
# - OR = 1  : variabel tsb tidak mempengaruhi odds
#
# Karena prediktor distandardisasi, interpretasi per "1 standar deviasi",
# bukan per 1 satuan asli.
# ==============================================================================
cat("\n==============================================================\n")
cat(" INTERPRETASI: ODDS RATIO (berdasarkan beta IRLS)\n")
cat("==============================================================\n")

odds_ratio <- exp(beta_irls)
tabel_or <- data.frame(
  Variabel   = colnames(X),
  Beta       = round(as.vector(beta_irls), 6),
  Odds_Ratio = round(as.vector(odds_ratio), 6)
)
print(tabel_or)

# ==============================================================================
# 8. EVALUASI MODEL: CONFUSION MATRIX & AKURASI
# ==============================================================================
cat("\n==============================================================\n")
cat(" EVALUASI MODEL (threshold = 0.5, pakai beta IRLS)\n")
cat("==============================================================\n")

# Prediksi probabilitas pada data training
pi_pred   <- 1 / (1 + exp(-X %*% beta_irls))
pred_kelas <- ifelse(pi_pred >= 0.5, 1, 0)

# Confusion matrix manual
TP <- sum(pred_kelas == 1 & Y == 1)
TN <- sum(pred_kelas == 0 & Y == 0)
FP <- sum(pred_kelas == 1 & Y == 0)
FN <- sum(pred_kelas == 0 & Y == 1)

cm <- matrix(c(TN, FP, FN, TP), nrow = 2, byrow = TRUE,
             dimnames = list(
               "Aktual"    = c("0 (Non-Liburan)", "1 (Liburan)"),
               "Prediksi"  = c("0 (Non-Liburan)", "1 (Liburan)")
             ))
cat("\n--- Confusion Matrix ---\n")
print(cm)

akurasi    <- (TP + TN) / (TP + TN + FP + FN)
presisi    <- if ((TP + FP) > 0) TP / (TP + FP) else NA
recall     <- if ((TP + FN) > 0) TP / (TP + FN) else NA
spesifitas <- if ((TN + FP) > 0) TN / (TN + FP) else NA

cat("\n--- Metrik Evaluasi ---\n")
cat("  Akurasi    :", round(akurasi,    4), "\n")
cat("  Presisi    :", round(presisi,    4), "\n")
cat("  Recall     :", round(recall,     4), "\n")
cat("  Spesifitas :", round(spesifitas, 4), "\n")

cat("\nCatatan: data sangat tidak seimbang (", round(mean(Y)*100, 2),
    "% kelas 1),\nsehingga akurasi saja bisa menyesatkan, perhatikan recall & presisi.\n",
    sep = "")

# ==============================================================================
# 9. RINGKASAN AKHIR
# ==============================================================================
cat("\n==============================================================\n")
cat(" RINGKASAN ANALISIS REGRESI LOGISTIK BINER\n")
cat("==============================================================\n")
cat("Data         : walmart_cleaning.csv (sampel stratified n =", nrow(df), ")\n")
cat("Target (Y)   : IsHoliday_Num (1 = Liburan, 0 = Non-Liburan)\n")
cat("Prediktor    :", paste(vars_x, collapse = ", "), "\n")
cat("Metode       : glm | Newton-Raphson | IRLS\n")
cat("Iterasi NR   : konvergen dalam", iterasi, "iterasi\n")
cat("Akurasi      :", round(akurasi, 4), "\n")
cat("\nKetiga metode menghasilkan koefisien yang secara numerik identik,\n")
cat("mengkonfirmasi ekuivalensi matematis Newton-Raphson dan IRLS\n")
cat("pada regresi logistik biner.\n")
