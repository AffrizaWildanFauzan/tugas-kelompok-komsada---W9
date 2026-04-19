# Cleaning & Pre-processing Dataset Walmart

**Mata Kuliah:** Komputasi Sains Data  

**Kelompok 3**



---



## 1. Pendahuluan

Data cleaning dan pre-processing adalah tahap paling krusial dalam workflow Sains Data. Data mentah (*raw data*) seringkali mengandung noise, nilai yang hilang, atau format yang tidak konsisten yang dapat menurunkan akurasi model machine learning (Regresi atau Time Series).



## 2. Teori Materi: Cleaning & Pre-processing



### A. Data Cleaning

Proses untuk mendeteksi dan memperbaiki (atau menghapus) catatan yang rusak atau tidak akurat dari kumpulan data.

* **Handling Missing Values:** Menangani data kosong (NA). Bisa dengan menghapus baris atau imputasi (mengisi dengan nilai tertentu seperti mean/median/nol).

* **Handling Duplicates:** Menghapus data yang terinput lebih dari satu kali agar tidak terjadi bias.

* **Handling Outliers:** Menangani nilai ekstrem yang tidak masuk akal (contoh: nilai penjualan negatif. Deteksi outlier secara statistik dapat menggunakan metode **IQR (Interquartile Range)**:
    $$IQR = Q_3 - Q_1$$
    Data dianggap outlier jika berada di luar rentang $[Q_1 - 1.5 \times IQR, Q_3 + 1.5 \times IQR]$. Pada kasus ini, kita melakukan filter spesifik pada `Weekly_Sales < 0` karena secara logika ekonomi penjualan tidak mungkin bernilai negatif.



### B. Data Transformation

Proses mengubah format data agar sesuai dengan kebutuhan komputasi.

* **Type Conversion:** Mengubah tipe data, misalnya string menjadi format `Date` atau `Factor`.

* **Encoding:** Mengubah data kategorikal (kata-kata) menjadi angka.

    * *One-Hot Encoding*: Membuat kolom baru untuk setiap kategori (0 dan 1).

    * *Label Encoding*: Memberikan urutan angka (1, 2, 3...).

* **Scaling (Standardization):** Menyamakan rentang nilai antar variabel (misal: menyamakan skala jutaan ke skala 0-1) agar model linear tidak berat sebelah.
*  Mengubah skala data agar memiliki rata-rata ($\mu$) = 0 dan standar deviasi ($\sigma$) = 1. Rumus **Z-Score** yang digunakan adalah:
    $$z = \frac{x - \mu}{\sigma}$$

### C. Data Reduction
* Proses efisiensi untuk mempercepat waktu komputasi tanpa mengurangi informasi. Pada dataset ini, dilakukan **Deduplikasi Kolom** hasil *merge* yang redundan.
---

## 3. Implementasi Kode (R)

Berikut adalah tahapan yang diterapkan pada `dataset_walmart.csv`:

### 3.1 Persiapan dan Pemuatan Data

Import library dplyr, langkah pertama adalah memuat dataset mentah untuk dilakukan inspeksi awal.

```r
library(dplyr)
# Load data
data <- read.csv("dataset_walmart.csv")
```

### 3.2 Identifikasi Masalah

Dilakukan pengecekan kualitas data

```r
# Cek NA dan Duplikat
colSums(is.na(data))
sum(duplicated(data))
# Cek anomali nilai pada penjualan
summary(data$Weekly_Sales)
```



### 3.3 Eksekusi Cleaning

Menggunakan teknik imputasi nol untuk diskon (MarkDown) dan filtering untuk menghapus penjualan negatif.

```r
data_bersih <- data %>%
  distinct() %>%                               # Hapus duplikat
  filter(Weekly_Sales >= 0) %>%                # Buang nilai negatif
  mutate(                                      # Imputasi NA ke 0
    MarkDown1 = ifelse(is.na(MarkDown1), 0, MarkDown1),
    MarkDown2 = ifelse(is.na(MarkDown2), 0, MarkDown2),
    MarkDown3 = ifelse(is.na(MarkDown3), 0, MarkDown3),
    MarkDown4 = ifelse(is.na(MarkDown4), 0, MarkDown4),
    MarkDown5 = ifelse(is.na(MarkDown5), 0, MarkDown5)
  )
```

### 3.4 Transformasi Tipe Data

Melakukan pengecekan tipe dan skala data, kemudian mengubah format kolom agar sesuai dengan standar analisis.

```r
# Cek tipe & skala data
str(data_bersih1)
summary(data_bersih1[c("Weekly_Sales", "Temperature", "CPI")])
# Eksekusi transformasi
data_bersih2 <- data_bersih1 %>%
  mutate(
    Date = as.Date(Date, format = "%Y-%m-%d"), # ubah character ke date
    Type = as.factor(Type)                      # ubah character ke factor
  )
# Note: Scaling (z-score dll) akan dilakukan oleh tim model sesuai kebutuhan
```

### 3.5 Data Reduction

Menghapus redundansi kolom yang muncul akibat proses penggabungan data (merge).

```r
# Cek apakah isi kolom IsHoliday.x dan y sama
all(data_bersih2$IsHoliday.x == data_bersih2$IsHoliday.y)

# Reduksi kolom redundan
data_final <- data_bersih2 %>%
  select(-IsHoliday.y) %>%               # buang kolom sisa merge
  rename(IsHoliday = IsHoliday.x)        # kembalikan nama kolom asli
```

### 3.6 Data Encoding

Tahap ini mengubah data kategorikal menjadi angka agar dapat diolah oleh model matematika seperti Regresi Linear.

```r
# 1. Label Encoding sederhana untuk kolom IsHoliday
data$IsHoliday_Num <- as.numeric(data$IsHoliday)

# 2. Dummy Encoding untuk kolom Type (A, B, C)
# Membuat matriks 0 dan 1 untuk merepresentasikan kategori Type
dummies <- model.matrix(~Type-1, data=data)

# 3. Menggabungkan kolom Dummy ke dataset utama (Type A dan B)
data <- cbind(data, dummies[, c("TypeA", "TypeB")])

# Menyimpan hasil akhir pembersihan untuk digunakan oleh anggota tim lain
write.csv(data, "walmart_cleaning_1.csv", row.names = FALSE)
```

## 4. Rencana Pengembangan

> Encoding: Akan dilakukan transformasi variabel kategorikal (Type) menjadi variabel dummy jika diperlukan untuk model Regresi Linear pada tahap berikutnya.

> Scaling: Tim model disarankan melakukan standarisasi pada variabel numerik sebelum tahap fitting model untuk menghindari bias akibat perbedaan skala antar fitur.
