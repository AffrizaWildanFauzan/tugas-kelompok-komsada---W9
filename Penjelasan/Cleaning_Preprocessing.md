# Cleaning & Pre-processing Dataset Walmart

---



## 1. Pendahuluan

Data cleaning dan pre-processing adalah tahap paling krusial dalam workflow Sains Data. Pre-processing adalah tahapan krusial dalam siklus sains data di mana data mentah tersebut dibersihkan, diubah, dan dipersiapkan agar menjadi data yang matang (*clean data*).



**Tujuan Utama Data Preprocessing:**
1. **Meningkatkan Akurasi Model:** Algoritma *Machine Learning* bekerja berdasarkan prinsip *"Garbage In, Garbage Out"*. Jika data yang dimasukkan buruk, hasil prediksinya pasti buruk. Data yang bersih memastikan model belajar dari pola yang benar.
2. **Menyesuaikan Format:** Algoritma matematis dan statistik tidak bisa membaca teks sembarangan. Preprocessing memastikan semua data diubah ke dalam format dan skala yang bisa diolah oleh mesin.
3. **Efisiensi Komputasi:** Mengurangi ukuran data atau membuang variabel yang tidak penting agar proses pelatihan (*training*) model berjalan lebih cepat dan tidak membebani memori komputasi.



## 📚 Tahapan Utama dalam Data Preprocessing
Secara umum, proses persiapan data ini dibagi menjadi 3 pilar utama, yaitu:

## 📚 1. Data Cleaning (Pembersihan Data)
Tahap ini adalah proses membersihkan "kotoran" dari dataset. Fokus utamanya adalah mendeteksi dan menangani ketidaksempurnaan data agar tidak menghasilkan model yang bias atau *error*.

### A. Menangani Missing Value (Data Kosong)
Data kosong (NA/Null) sangat sering terjadi akibat sensor rusak, responden tidak menjawab, atau *error* saat ekstraksi. Mesin tidak bisa memproses data yang kosong. Berikut metode penanganannya:
* **Penghapusan Baris (Listwise Deletion):** Membuang seluruh baris data yang memiliki sel kosong. Metode ini hanya disarankan jika jumlah *missing value* sangat sedikit (< 5% dari total data).
* **Imputasi Mean (Rata-rata):** Mengisi nilai yang kosong dengan nilai rata-rata kolom tersebut. Sangat cocok untuk data numerik yang berdistribusi normal (tidak memiliki outlier ekstrim).
  * Rumus Mean: $$\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_i$$
* **Imputasi Median (Nilai Tengah):** Mengisi nilai kosong dengan nilai tengah. Cocok untuk data numerik yang distribusinya menceng (*skewed*) atau memiliki banyak outlier, karena median lebih kebal terhadap outlier dibandingkan *mean*.
* **Imputasi Modus (Nilai yang Sering Muncul):** Digunakan khusus untuk mengisi data kosong pada variabel kategorik (non-numerik).
* **Imputasi Konstanta (Nilai Default):** Mengisi dengan angka spesifik berdasarkan logika bisnis (misalnya: mengisi kolom diskon yang kosong dengan angka 0).

### B. Menghapus Data Duplikat
Data duplikat adalah baris observasi yang terekam lebih dari satu kali secara identik. Kehadiran data duplikat akan membuat model *Machine Learning* melakukan "pembelajaran berulang" pada kasus yang sama, sehingga model menjadi *overfitting* (bias). Solusinya adalah mendeteksi baris yang 100% identik dan menghapus salinannya.

### C. Menangani Outlier (Pencilan)
Outlier adalah nilai observasi yang sangat menyimpang atau berbeda jauh dari mayoritas kumpulan data lainnya. Outlier bisa terjadi karena kesalahan alat ukur (harus dihapus) atau memang fenomena alami (bisa dipertahankan). Ada dua metode utama untuk mendeteksi outlier:

**1. Metode IQR (Interquartile Range) / Boxplot**
Metode ini paling umum digunakan karena tidak mengharuskan data berdistribusi normal. 
* Rumus IQR: $$IQR = Q_3 - Q_1$$
* Titik data dianggap outlier jika nilainya kurang dari Batas Bawah (*Lower Bound*) atau lebih dari Batas Atas (*Upper Bound*):
  * Batas Bawah: $$Lower = Q_1 - 1.5 \times IQR$$
  * Batas Atas: $$Upper = Q_3 + 1.5 \times IQR$$

**2. Metode Z-Score (Standardisasi)**
Metode ini mengukur seberapa jauh sebuah nilai dari rata-rata dalam satuan standar deviasi. Cocok untuk data yang terdistribusi normal.
* Rumus Z-Score: $$z = \frac{x - \mu}{\sigma}$$
* Aturan umum: Titik data dianggap outlier jika nilai absolut $z$ lebih dari 3 ($|z| > 3$).

### D. Memperbaiki Inkonsistensi Data
Inkonsistensi terjadi akibat kesalahan input manusia (*typo*) atau format yang tidak seragam. Solusi yang umum dilakukan:
* *Case Folding / Lowercasing:* Mengubah seluruh teks menjadi huruf kecil (misal: "Setosa", "SETOSA", "setosa" diseragamkan menjadi "setosa").
* *Trimming:* Menghapus spasi berlebih di awal atau akhir kata (misal: `" Jakarta "` menjadi `"Jakarta"`).




## 🔄 2. Data Transformation (Transformasi Data)
Setelah data bersih dari "kotoran" (seperti NA dan data duplikat), tahap selanjutnya adalah Data Transformation. Tahap ini bertujuan untuk mengubah format, struktur, atau nilai data agar sesuai dengan syarat matematis yang dibutuhkan oleh algoritma *Machine Learning*.

### A. Penyesuaian Tipe Data (Formatting)
Banyak algoritma akan mengalami *error* jika tipe data tidak sesuai dengan isinya. Misalnya:
* **Format Waktu/Tanggal:** Data tanggal yang dibaca sebagai teks biasa (`character`) tidak bisa dihitung selisih harinya. Harus diubah ke dalam format khusus seperti `Date` atau `Datetime`.
* **Format Kategori:** Data berupa teks (seperti "A", "B", "C") seringkali perlu diubah menjadi `Factor` agar R (atau bahasa pemrograman lain) memahaminya sebagai sebuah kelompok/kelas, bukan sekadar huruf abjad.

### B. Encoding (Kategorik ke Numerik)
Mayoritas algoritma *Machine Learning* (seperti Regresi Linier dan *Neural Network*) beroperasi menggunakan perhitungan matriks matematika. Karena mesin tidak bisa mengalikan atau menjumlahkan teks, kita harus mengubah variabel kategorik menjadi angka (*numerik*).
* **Label Encoding:** Mengubah setiap kategori menjadi angka integer berurutan (misal: Rendah = 0, Sedang = 1, Tinggi = 2). Cocok untuk data yang memiliki tingkatan (*ordinal*).
* **One-Hot Encoding (Dummy Variables):** Memecah satu kolom kategori menjadi beberapa kolom baru yang hanya berisi nilai 1 (Ya) dan 0 (Tidak). Cocok untuk data nominal (tidak memiliki tingkatan).
  * ⚠️ **Dummy Variable Trap:** Saat membuat *dummy variables*, kita harus menghapus satu kolom hasil pecahan tersebut untuk menghindari *Multikolinearitas* sempurna (jebakan variabel dummy). Misalnya, jika ada kategori A, B, dan C, kita cukup membuat kolom `Type_A` dan `Type_B`. Jika sebuah data bernilai 0 di `Type_A` dan 0 di `Type_B`, model regresi akan secara otomatis mendeduksi bahwa data tersebut pasti adalah tipe C.

### C. Scaling (Standarisasi Skala)
*Scaling* digunakan untuk menyetarakan rentang nilai antar variabel numerik. Jika kita tidak melakukan *scaling*, variabel dengan nilai yang besar (seperti Gaji dalam jutaan) akan mendominasi dan mengalahkan variabel dengan nilai kecil (seperti Umur dalam puluhan), sehingga model menjadi bias.

**1. Standardization (Z-Score)**
Mengubah data sehingga memiliki nilai rata-rata ($\mu$) = 0 dan standar deviasi ($\sigma$) = 1. Sangat cocok untuk algoritma yang mengasumsikan data berdistribusi normal seperti Regresi Linier dan Regresi Logistik.
* Rumus Z-Score: $$z = \frac{x - \mu}{\sigma}$$

**2. Normalization (Min-Max Scaling)**
Menekan seluruh nilai data agar berada dalam rentang skala yang pasti, biasanya antara 0 hingga 1. Sangat penting untuk algoritma berbasis jarak seperti KNN (*K-Nearest Neighbors*) atau *Neural Network*.
* Rumus Min-Max: $$x' = \frac{x - x_{min}}{x_{max} - x_{min}}$$

---

## 🚀 Implementasi Data Transformation (Case Study: Walmart)
Berdasarkan diskusi dan kebutuhan pemodelan kelompok kami (Regresi Linier, Regresi Logistik, dan *Time Series*), berikut adalah perlakuan transformasi yang kami terapkan pada dataset Walmart:

1. **Transformasi Format Tanggal:** Mengubah kolom `Date` yang aslinya bertipe *character* menjadi tipe `Date` dengan format `"%Y-%m-%d"`. Ini sangat krusial bagi tim *Time Series* untuk melakukan peramalan (*forecasting*) berdasarkan urutan waktu.
2. **Penyesuaian Tipe Faktor:** Mengubah kolom `Type` (tipe toko) menjadi `Factor` agar siap dilakukan visualisasi atau agregasi.
3. **Eksekusi Encoding (Berdasarkan Request Tim Regresi):**
   * Mengubah tipe *boolean* pada kolom `IsHoliday` (TRUE/FALSE) menjadi bentuk numerik biner (1 dan 0).
   * Menerapkan *One-Hot Encoding* secara manual pada kolom `Type` (A, B, C) menjadi variabel dummy. Sesuai dengan prinsip penghindaran *Dummy Variable Trap*, kami hanya membuat kolom `Type_A` dan `Type_B`.
4. **Keputusan Absennya Scaling (No Scaling):**
   * Secara sadar, tim Preprocessing **TIDAK** melakukan *Scaling* (baik Z-score maupun Min-Max) pada dataset *output* (file CSV). 
   * **Alasan Bisnis & Teknis:** Jika variabel dependen (`Weekly_Sales`) diubah bentuknya melalui *scaling*, tim *Time Series* akan kesulitan menginterpretasikan hasil prediksi ke dalam nominal mata uang asli (Dollar). Oleh karena itu, *dataset* dibiarkan dalam skala aslinya, dan proses *scaling* didelegasikan kepada *script* masing-masing tim pemodelan (misalnya tim Regresi Linier) sesuai dengan algoritma mereka.




## 📉 3. Data Reduction (Reduksi Data)
Tahap terakhir dalam pra-pemrosesan data adalah Data Reduction atau reduksi data. Tahap ini bisa diibaratkan sebagai "diet memori". Tujuannya adalah mengurangi ukuran dataset (baik jumlah baris maupun jumlah kolom/variabel) sedemikian rupa sehingga proses komputasi menjadi lebih cepat dan risiko *overfitting* berkurang, tanpa menghilangkan esensi atau informasi penting dari data tersebut.

Metode Data Reduction umumnya dibagi menjadi beberapa teknik:

### A. Menghapus Kolom Redundan
Langkah paling dasar adalah menghapus kolom yang tidak memberikan nilai informasi tambahan. Contohnya adalah kolom ID (yang hanya berisi nomor urut), kolom yang isinya hanya satu nilai konstan (nol variansi), atau kolom duplikat yang muncul akibat proses penggabungan (*merging*) beberapa tabel data.

### B. Feature Selection (Seleksi Fitur)
Teknik ini digunakan untuk memilih variabel (kolom) mana saja yang paling relevan untuk memprediksi variabel target, dan membuang variabel yang tidak berguna. 
* **Metode Korelasi:** Mengecek hubungan antar variabel numerik (misal menggunakan Pearson Correlation). Jika ada dua variabel independen yang sangat kuat korelasinya (misal > 0.9), salah satunya bisa dihapus karena dianggap memberikan informasi yang tumpang tindih (*Multikolinearitas*).

### C. Dimensionality Reduction (Reduksi Dimensi)
Berbeda dengan *feature selection* yang hanya "memilih" kolom, reduksi dimensi bekerja secara matematis untuk "merangkum" puluhan kolom menjadi beberapa kolom baru yang lebih sedikit, namun tetap mewakili karakteristik data asli.
* **PCA (Principal Component Analysis):** Teknik aljabar linear yang mengubah variabel-variabel asal yang saling berkorelasi menjadi sekumpulan variabel baru yang tidak saling berkorelasi (disebut *Principal Components*). Sangat berguna jika kita memiliki dataset dengan ratusan kolom.

### D. Discretization (Diskritisasi / Binning)
Mengubah variabel numerik kontinu menjadi variabel kategorik (interval). Tujuannya untuk menyederhanakan data yang terlalu bervariasi atau meredam efek *outlier*.
* Contoh: Mengubah kolom "Umur" yang berisi angka 1 hingga 100 menjadi tiga kategori sederhana: "Muda" (1-25), "Dewasa" (26-50), dan "Tua" (>50).

---

## 🚀 Implementasi Data Reduction (Case Study: Walmart)
Pada proyek prediksi penjualan Walmart ini, kami menerapkan teknik reduksi data dasar untuk mengoptimalkan memori dan mencegah kebingungan pada algoritma *Machine Learning* akibat adanya data yang berulang. Berikut adalah eksekusinya:

1. **Pengecekan Identitas Kolom:** Pada tahap awal *load* data, kami menemukan kejanggalan di mana terdapat dua kolom status libur, yakni `IsHoliday.x` dan `IsHoliday.y`. Ini adalah efek samping (sisaan) dari proses *merging* dataset sebelumnya. Kami melakukan validasi matematis untuk mengecek apakah isi kedua kolom tersebut sama persis pada semua baris.
2. **Penghapusan Kolom Redundan:** Setelah tervalidasi bahwa isinya 100% identik, kami menghapus kolom `IsHoliday.y` karena kolom tersebut redundan, memakan memori komputasi, dan berpotensi menyebabkan *Multikolinearitas* jika dimasukkan ke dalam model regresi. Pada R *Base*, penghapusan ini dilakukan dengan cara memberikan nilai `NULL` pada kolom tersebut.
3. **Standarisasi Nama Kolom:** Agar bersih dan rapi, kolom `IsHoliday.x` yang dipertahankan kami ubah kembali namanya menjadi `IsHoliday`.

Dengan selesainya tahap reduksi ini, dataset Walmart telah sepenuhnya bersih, terstandarisasi, dan optimal (*Model-Ready Dataset*) untuk diproses lebih lanjut oleh tim pemodelan (Regresi Linier, Regresi Logistik, dan *Time Series*).




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
