# ============================================================
# ANALISIS TABEL KONTINGENSI
# ============================================================

# ------------------------------------------------------------
# 1. LOAD DATA
# ------------------------------------------------------------
data <- read.csv("walmart_cleaning.csv", stringsAsFactors = FALSE)

cat("Dimensi data :", nrow(data), "baris x", ncol(data), "kolom\n\n")
cat("Nama kolom :\n")
print(colnames(data))

# ------------------------------------------------------------
# 2. EKSPLORASI DATA
# ------------------------------------------------------------

# 2.1 Tipe data dan jumlah nilai unik tiap kolom
cat("\n=== TIPE DATA & JUMLAH NILAI UNIK TIAP KOLOM ===\n\n")
for (col in colnames(data)) {
  tipe  <- class(data[[col]])
  nuniq <- length(unique(data[[col]]))
  cat(" ", col, "| Tipe:", tipe, "| Nilai Unik:", nuniq, "\n")
}

# 2.2 Evaluasi kelayakan tiap kolom untuk tabel kontingensi
cat("\n=== EVALUASI KELAYAKAN KOLOM UNTUK TABEL KONTINGENSI ===\n\n")
for (col in colnames(data)) {
  tipe  <- class(data[[col]])
  nuniq <- length(unique(data[[col]]))
  
  if (tipe %in% c("character", "logical") && nuniq <= 10) {
    status <- "LAYAK     - kategorik, jumlah kategori sedikit"
  } else if (tipe %in% c("character", "logical") && nuniq > 10) {
    status <- "TIDAK     - kategorik tapi terlalu banyak kategori"
  } else if (tipe %in% c("integer", "numeric") && nuniq <= 5) {
    status <- "PERLU CEK - numerik tapi nilai unik sangat sedikit"
  } else {
    status <- "TIDAK     - numerik kontinu, bukan kategorik"
  }
  
  cat(" ", col, "|", status, "\n")
}

# 2.3 Distribusi variabel yang layak
cat("\n=== DISTRIBUSI IsHoliday ===\n")
kat_holiday <- sort(unique(data$IsHoliday))
for (k in kat_holiday) {
  n_k <- sum(data$IsHoliday == k)
  cat(" ", k, ":", n_k, "(", round(n_k / nrow(data) * 100, 2), "%)\n")
}

cat("\n=== DISTRIBUSI Type ===\n")
kat_type <- sort(unique(data$Type))
for (k in kat_type) {
  n_k <- sum(data$Type == k)
  cat(" ", k, ":", n_k, "(", round(n_k / nrow(data) * 100, 2), "%)\n")
}

# 2.4 Kesimpulan eksplorasi
cat("\n=== KESIMPULAN EKSPLORASI ===\n")
cat("Variabel yang dipilih untuk tabel kontingensi:\n")
cat("  >> IsHoliday (FALSE/TRUE) x Type (A/B/C)\n")

# ------------------------------------------------------------
# 3. TABEL KONTINGENSI
# ------------------------------------------------------------
A <- as.character(data$IsHoliday)
B <- as.character(data$Type)

kat_A <- sort(unique(A))
kat_B <- sort(unique(B))
r     <- length(kat_A)
c     <- length(kat_B)
n     <- length(A)

# Hitung frekuensi observasi
O <- matrix(0, nrow = r, ncol = c,
            dimnames = list(kat_A, kat_B))

for (k in 1:n) {
  i <- which(kat_A == A[k])
  j <- which(kat_B == B[k])
  O[i, j] <- O[i, j] + 1
}

# Tampilkan dengan marginal
O_tampil <- cbind(O, "| Total" = rowSums(O))
O_tampil <- rbind(O_tampil, "Total" = c(colSums(O), sum(O)))

cat("\n=== TABEL KONTINGENSI: IsHoliday vs Type ===\n")
cat("(Frekuensi Observasi)\n\n")
print(O_tampil)

# ------------------------------------------------------------
# 4. FREKUENSI HARAPAN
# ------------------------------------------------------------
total_baris <- rowSums(O)
total_kolom <- colSums(O)

E <- matrix(0, nrow = r, ncol = c, dimnames = list(kat_A, kat_B))
for (i in 1:r) {
  for (j in 1:c) {
    E[i, j] <- (total_baris[i] * total_kolom[j]) / n
  }
}

cat("\n=== FREKUENSI HARAPAN (E_ij) ===\n\n")
print(round(E, 4))

cat("\n>>> Cek asumsi: semua E_ij >= 5\n")
cat("    Nilai E_ij minimum :", round(min(E), 4), "\n")
if (min(E) >= 5) {
  cat("    Asumsi terpenuhi, uji Chi-Square valid.\n")
} else {
  cat("    Asumsi TIDAK terpenuhi.\n")
}

# ------------------------------------------------------------
# 5. KONTRIBUSI TIAP SEL
# ------------------------------------------------------------
kontribusi <- matrix(0, nrow = r, ncol = c, dimnames = list(kat_A, kat_B))
for (i in 1:r) {
  for (j in 1:c) {
    kontribusi[i, j] <- (O[i, j] - E[i, j])^2 / E[i, j]
  }
}

cat("\n=== KONTRIBUSI TIAP SEL: (O_ij - E_ij)^2 / E_ij ===\n\n")
print(round(kontribusi, 4))
cat("\nTotal Chi-Square :", round(sum(kontribusi), 4), "\n")

# ------------------------------------------------------------
# 6. UJI CHI-SQUARE
# ------------------------------------------------------------
alpha       <- 0.05
df          <- (r - 1) * (c - 1)
chi2_hitung <- sum(kontribusi)
chi2_tabel  <- qchisq(1 - alpha, df)
p_value     <- 1 - pchisq(chi2_hitung, df)

if (chi2_hitung > chi2_tabel) {
  tanda      <- ">"
  keputusan  <- "Tolak H0"
  kesimpulan <- "Terdapat hubungan yang signifikan antara IsHoliday dan Type."
} else {
  tanda      <- "<"
  keputusan  <- "Gagal Tolak H0"
  kesimpulan <- "Tidak terdapat hubungan yang signifikan (kedua variabel independen)."
}

cat("\n=== UJI CHI-SQUARE INDEPENDENSI ===\n\n")
cat("H0 : IsHoliday dan Type saling independen\n")
cat("H1 : IsHoliday dan Type tidak independen\n")
cat("Alpha (α) =", alpha, "\n")
cat("\n----------------------------------------------------\n")
cat("  Chi-Square Hitung (χ²) :", round(chi2_hitung, 6), "\n")
cat("  Chi-Square Tabel       :", round(chi2_tabel, 6), "\n")
cat("  Derajat Bebas (df)     :", df, "\n")
cat("  p-value                :", round(p_value, 6), "\n")
cat("----------------------------------------------------\n\n")
cat("Karena χ² Hitung", round(chi2_hitung, 4), tanda, "χ² Tabel", round(chi2_tabel, 4), "\n")
cat("Keputusan  :", keputusan, "\n")
cat("Kesimpulan :", kesimpulan, "\n")

# ------------------------------------------------------------
# 7. CRAMER'S V
# ------------------------------------------------------------
V <- sqrt(chi2_hitung / (n * min(r - 1, c - 1)))

if (V < 0.10) {
  interp <- "Asosiasi sangat lemah"
} else if (V < 0.30) {
  interp <- "Asosiasi lemah"
} else if (V < 0.50) {
  interp <- "Asosiasi sedang"
} else {
  interp <- "Asosiasi kuat"
}

cat("\n=== CRAMER'S V ===\n\n")
cat("  V = sqrt(", round(chi2_hitung, 4), "/", n, "x", min(r-1, c-1), ")\n")
cat("  V =", round(V, 6), "\n")
cat("  Interpretasi :", interp, "\n")

# ------------------------------------------------------------
# 8. PROPORSI
# ------------------------------------------------------------

# Proporsi terhadap grand total
prop_total <- matrix(0, nrow = r, ncol = c, dimnames = list(kat_A, kat_B))
for (i in 1:r) for (j in 1:c) prop_total[i, j] <- O[i, j] / n

cat("\n=== PROPORSI TERHADAP GRAND TOTAL (%) ===\n\n")
print(round(prop_total * 100, 2))

# Proporsi per baris
prop_baris <- matrix(0, nrow = r, ncol = c, dimnames = list(kat_A, kat_B))
for (i in 1:r) for (j in 1:c) prop_baris[i, j] <- O[i, j] / total_baris[i]

cat("\n=== PROPORSI PER BARIS / Row Proportion (%) ===\n")
print(round(prop_baris * 100, 2))

# Proporsi per kolom
prop_kolom <- matrix(0, nrow = r, ncol = c, dimnames = list(kat_A, kat_B))
for (i in 1:r) for (j in 1:c) prop_kolom[i, j] <- O[i, j] / total_kolom[j]

cat("\n=== PROPORSI PER KOLOM / Column Proportion (%) ===\n")
print(round(prop_kolom * 100, 2))

# ------------------------------------------------------------
# 9. RINGKASAN AKHIR
# ------------------------------------------------------------
cat("\n=== RINGKASAN ANALISIS TABEL KONTINGENSI ===\n\n")
cat("Variabel 1   :", "IsHoliday (FALSE / TRUE)\n")
cat("Variabel 2   :", "Type (A / B / C)\n")
cat("Ukuran Tabel :", r, "x", c, "\n")
cat("Total Data   :", n, "\n")
cat("\n")
cat("Chi-Square Hitung :", chi2_hitung, "\n")
cat("Chi-Square Tabel  :", chi2_tabel, "\n")
cat("df                :", df, "\n")
cat("p-value           :", p_value, "\n")
cat("Cramer's V        :", V, "\n")
cat("Interpretasi      :", interp, "\n")
cat("\n")
cat("Keputusan  :", keputusan, "\n")
cat("Kesimpulan :", kesimpulan, "\n")
