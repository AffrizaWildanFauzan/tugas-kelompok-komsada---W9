# Cleaning & Pre-processing Dataset Walmart

---

## 1. Pendahuluan
Data cleaning dan pre-processing adalah tahapan krusial dalam siklus Sains Data di mana data mentah (*raw data*) dibersihkan, diubah, dan dipersiapkan agar menjadi data yang matang (*clean data*).

**Tujuan Utama Data Preprocessing:**
1. **Meningkatkan Akurasi Model:** Algoritma *Machine Learning* bekerja berdasarkan prinsip *"Garbage In, Garbage Out"*. Jika data yang dimasukkan buruk, hasil prediksinya pasti buruk. Data yang bersih memastikan model belajar dari pola yang benar.
2. **Menyesuaikan Format:** Algoritma matematis dan statistik tidak bisa membaca teks sembarangan. Preprocessing memastikan semua data diubah ke dalam format dan skala yang bisa diolah oleh mesin.
3. **Efisiensi Komputasi:** Mengurangi ukuran data atau membuang variabel yang tidak penting agar proses pelatihan (*training*) model berjalan lebih cepat dan tidak membebani memori komputasi.

Secara umum, proses persiapan data pada proyek ini dibagi menjadi 3 pilar utama, yaitu: Data Cleaning, Data Transformation, dan Data Reduction.

---

## 2. Landasan Teori Preprocessing

### 2.1 Data Cleaning (Pembersihan Data)
Tahap ini adalah proses membersihkan "kotoran" dari dataset. Fokus utamanya adalah mendeteksi dan menangani ketidaksempurnaan data agar tidak menghasilkan model yang bias atau *error*.

**A. Menangani Missing Value (Data Kosong)**
Data kosong (NA/Null) sangat sering terjadi akibat sensor rusak, responden tidak menjawab, atau *error* saat ekstraksi. Berikut metode penanganannya:
* **Penghapusan Baris (Listwise Deletion):** Membuang seluruh baris data yang memiliki sel kosong. Disarankan jika jumlah *missing value* sangat sedikit (< 5% dari total data).
* **Imputasi Mean (Rata-rata):** Mengisi nilai yang kosong dengan nilai rata-rata kolom. Cocok untuk data numerik berdistribusi normal.
  * Rumus Mean: $$\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_i$$
* **Imputasi Median (Nilai Tengah):** Cocok untuk data numerik yang distribusinya menceng (*skewed*) atau memiliki banyak outlier, karena median lebih kebal terhadap nilai ekstrim.
* **Imputasi Konstanta (Nilai Default):** Mengisi dengan angka spesifik berdasarkan logika bisnis (misal: mengisi kolom diskon yang kosong dengan angka 0).

**B. Menghapus Data Duplikat**
Data duplikat adalah baris observasi yang terekam lebih dari satu kali secara identik. Kehadirannya bisa membuat model mengalami *overfitting* (bias) karena "pembelajaran berulang" pada kasus yang sama.

**C. Menangani Outlier (Pencilan)**
Outlier adalah nilai observasi yang menyimpang jauh dari mayoritas data. Metode deteksinya meliputi:
* **Metode IQR (Interquartile Range) / Boxplot:**
  * Rumus IQR: $$IQR = Q_3 - Q_1$$
  * Batas Bawah: $$Lower = Q_1 - 1.5 \times IQR$$
  * Batas Atas: $$Upper = Q_3 + 1.5 \times IQR$$
* **Metode Z-Score (Standardisasi):** Mengukur seberapa jauh sebuah nilai dari rata-rata dalam satuan standar deviasi.
  * Rumus Z-Score: $$z = \frac{x - \mu}{\sigma}$$

**D. Memperbaiki Inkonsistensi Data**
Menyeragamkan format penulisan, seperti mengubah semua teks menjadi huruf kecil (*Lowercasing*) atau menghapus spasi berlebih (*Trimming*).

### 2.2 Data Transformation (Transformasi Data)
Tahap ini bertujuan mengubah format, struktur, atau nilai data agar sesuai dengan syarat matematis algoritma *Machine Learning*.
* **Penyesuaian Tipe Data:** Mengubah teks tanggal menjadi format kalender (`Date`), atau abjad menjadi kelompok/kelas (`Factor`).
* **Encoding (Kategorik ke Numerik):** * *Label Encoding:* Mengubah kategori menjadi angka berurutan.
  * *One-Hot Encoding:* Memecah kolom kategori menjadi kolom baru bernilai 1 (Ya) dan 0 (Tidak). 
  * ⚠️ **Dummy Variable Trap:** Saat membuat *dummy*, satu kolom pecahan harus dihapus untuk menghindari *Multikolinearitas* sempurna.
* **Scaling (Standarisasi Skala):** Menyetarakan rentang angka antar variabel numerik (Z-Score atau Min-Max) agar variabel berskala besar tidak mendominasi model.

### 2.3 Data Reduction (Reduksi Data)
Tahap "diet memori" untuk mengurangi ukuran dataset sedemikian rupa sehingga komputasi menjadi lebih cepat tanpa menghilangkan informasi penting.
* **Menghapus Kolom Redundan:** Membuang kolom ID, nilai konstan, atau kolom hasil *merging* yang isinya sama persis.
* **Feature Selection:** Memilih variabel yang berkorelasi kuat dengan target (Pearson Correlation).
* **Dimensionality Reduction & Discretization:** Menggunakan PCA untuk merangkum fitur, atau melakukan *binning* (mengubah numerik jadi kategori interval).

---

## 3. Implementasi Kode pada Dataset Walmart

Berdasarkan diskusi dan kebutuhan pemodelan kelompok (Regresi Linier, Regresi Logistik, dan Time Series), berikut adalah tahapan eksekusi manual (Base R) yang diterapkan pada `dataset_walmart.csv`:

### 3.1 Persiapan dan Pemuatan Data
Langkah pertama memuat dataset mentah untuk dilakukan inspeksi awal.

```r
# Load data
data <- read.csv("dataset_walmart.csv")
```

### 3.2 Identifikasi Masalah

Dilakukan pengecekan kualitas data

```r
# Cek NA dan Duplikat
colSums(is.na(data))
sum(duplicated(data))

# Cek anomali nilai pada penjualan (mencari nilai minus)
summary(data$Weekly_Sales)
```

### 3.3 Eksekusi Cleaning

Menggunakan teknik imputasi nol untuk diskon (MarkDown) dan filtering untuk menghapus penjualan negatif.

```r
# 1. Hapus baris duplikat
data <- data[!duplicated(data), ]

# 2. Buang sales minus (retur)
data <- data[data$Weekly_Sales >= 0, ]

# 3. Imputasi NA pada kolom diskon (MarkDown) dengan 0 (Asumsi tidak ada promo)
data$MarkDown1[is.na(data$MarkDown1)] <- 0
data$MarkDown2[is.na(data$MarkDown2)] <- 0
data$MarkDown3[is.na(data$MarkDown3)] <- 0
data$MarkDown4[is.na(data$MarkDown4)] <- 0
data$MarkDown5[is.na(data$MarkDown5)] <- 0
```

### 3.4 Transformasi Tipe Data

Melakukan pengecekan tipe dan skala data, kemudian mengubah format kolom agar sesuai dengan standar analisis.

```r
# Ubah character ke format Date (Penting untuk peramalan Time Series)
data$Date <- as.Date(data$Date, format = "%Y-%m-%d")

# Ubah character ke format Factor
data$Type <- as.factor(data$Type)
```

### 3.5 Data Reduction

Menghapus redundansi kolom yang muncul akibat proses penggabungan data (merge).

```r
# Validasi apakah isi kolom IsHoliday.x dan y sama identik
all(data$IsHoliday.x == data$IsHoliday.y)

# Reduksi (Buang kolom redundan sisa merge)
data$IsHoliday.y <- NULL

# Benerin nama kolom kembali ke awal
names(data)[names(data) == "IsHoliday.x"] <- "IsHoliday"
```

### 3.6 Data Encoding

Tahap ini mengubah data kategorikal menjadi angka agar dapat diolah oleh model matematika seperti Regresi Linear.

```r
# 1. Label Encoding untuk kolom IsHoliday (TRUE/FALSE jadi 1/0)
data$IsHoliday_Num <- as.numeric(data$IsHoliday)

# 2. Dummy Encoding untuk kolom Type (A, B, C) menggunakan model.matrix
dummies <- model.matrix(~Type-1, data=data)

# 3. Menggabungkan kolom Dummy ke dataset utama 
# (Hanya TypeA dan TypeB yang diambil untuk menghindari Dummy Variable Trap)
data <- cbind(data, dummies[, c("TypeA", "TypeB")])

# Menyimpan hasil akhir pembersihan yang sudah siap model
write.csv(data, "walmart_cleaning.csv", row.names = FALSE)
```

### 3.7 Catatan Tambahan Pemodelan
Sebagai catatan untuk tahapan *fitting* model selanjutnya:
* **Encoding:** Transformasi variabel kategorikal `Type` menjadi *dummy* (`TypeA` & `TypeB`) serta konversi biner `IsHoliday` telah tuntas dilakukan pada tahap ini.
* **Scaling:** Proses standarisasi sengaja **tidak dilakukan** pada tahap pre-processing. Hal ini untuk menjaga nilai target (`Weekly_Sales`) tetap dalam satuan asli demi kemudahan interpretasi peramalan *Time Series*. Tim pemodelan disarankan melakukan *scaling* secara mandiri pada variabel independen di *script* masing-masing.
