# Review Materi Komputasi Sains Data 2026 (First Half)

Proyek ini bertujuan untuk meringkas keseluruhan materi dari mata kuliah **Komputasi Sains Data** di Departemen Statistika ITS, Prodi Sains Data, untuk semester gasal tahun 2026.

## Kelompok 3:
1. Jason Alexander Widodo / 5052241001
2. Yafi Muhammad Faldin / 5052241026
3. Violita Karina Putri / 5052241009
4. Gilbert Emanuel Sambira / 5052241018
5. Affriza Wildan Fauzan / 5052241033
6. Aqila Ikhza / 5052241032
7. Azizah Adilah / 5052241027
8. Muhammad Naqib Bariq / 5052241013
9. Dimas
10. Constantine Calvin Gosal Jo/ 5052241010
11. Alief
12. Keira

## 📂 Struktur Repositori
Berikut adalah susunan file dalam repositori ini:
```text
├── scripts/            # Skrip utama analisis R
│   ├── statistik_deskriptif.R
├── Penjelasan/
│   ├── statistik deskriptif.md
│   ├── statistik deskriptif.pptx
└── README.md           # Dokumentasi proyek
```
## Materi
|Week|Topik|Deskripsi Singkat|
|----|------|----------------|
|1|Statistik Deskriptif|Ukuran pemusatan (mean, median, modus), visualisasi, dan ukuran persebaran (varians, standar deviasi, kuartil)|
|2|Teknik Pembersihan Data|Pembersihan data mentah (imputasi missing value, handling outlier)|
|3|Tabel Kontigensi|Membuat tabel kontigensi untuk melakukan analisis variabel kategorik|
|4|Regresi Linier Sederhana dan Berganda|Estimasi parameter dan uji signifikansi (ANOVA)|
|5|Regresi Logistik|Estimasi parameter dan uji signifikansi|
|6-7|Pemodelan Time Series|ACF, PACF, ARIMA, Exponential Smoothing, SARIMA|

## Kebutuhan Library
Library wajib untuk diinstall terlebih dahulu sebelum menjalankan script
|File|Library|Fungsi|
|----|-------|-----|
|statistik_deskriptif.R|ggplot2|Visualisasi|
|time_series.R|dplyr; lubridate; forecast; tseries|manipulasi dataframe; pengolahan tanggal waktu; uji forecast; uji ADF|
