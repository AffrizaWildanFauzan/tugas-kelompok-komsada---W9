![Statistika](Statdesk.png)

# Statistika Deskriptif: Rumus dan Penjelasan

Statistika deskriptif adalah metode yang digunakan untuk menganalisis dan mendeskripsikan data yang telah dikumpulkan tanpa membuat kesimpulan yang lebih luas (generalisasi). Tujuannya adalah untuk memberikan gambaran yang jelas tentang karakteristik data, seperti pemusatan, penyebaran, dan hubungan antar variabel.

## 1. Ukuran Pemusatan

### a. Median (Nilai Tengah)
Median adalah nilai yang membagi data terurut menjadi dua bagian yang sama besar.

**Rumus untuk data tunggal:**
- **Jika n ganjil:**  
  $$Me = X_{\frac{n+1}{2}}$$
- **Jika n genap:**  
  $$Me = \frac{X_{\frac{n}{2}} + X_{\frac{n}{2} + 1}}{2}$$

### b. Modus (Nilai yang Paling Sering Muncul)
Modus adalah nilai yang memiliki frekuensi tertinggi dalam suatu kumpulan data.

**Rumus untuk data berkelompok:**

$$Mo = L + \left( \frac{d_1}{d_1 + d_2} \right) \times c$$
- \(L\) = tepi bawah kelas modus  
- \(d_1\) = selisih frekuensi kelas modus dengan kelas sebelumnya  
- \(d_2\) = selisih frekuensi kelas modus dengan kelas sesudahnya  
- \(c\) = panjang kelas

## 2. Ukuran Penyebaran

### a. Varians (\(s^2\))
Varians mengukur seberapa jauh setiap nilai dalam data menyimpang dari rata-rata.

**Rumus Varians (sampel):**
$$s^2 = \frac{\sum_{i=1}^{n} (x_i - \bar{x})^2}{n-1}$$

**Rumus Varians (populasi):**
$$\sigma^2 = \frac{\sum_{i=1}^{n} (x_i - \mu)^2}{n}$$

### b. Standar Deviasi (\(s\))
Standar deviasi adalah akar kuadrat dari varians. Menggambarkan dispersasi data dalam satuan yang sama dengan data asli.

**Rumus Standar Deviasi (sampel):**
$$s = \sqrt{\frac{\sum_{i=1}^{n} (x_i - \bar{x})^2}{n-1}}$$

**Rumus Standar Deviasi (populasi):**
$$\sigma = \sqrt{\frac{\sum_{i=1}^{n} (x_i - \mu)^2}{n}}$$

## 3. Ukuran Hubungan Antar Variabel

### a. Kovarians (\(Cov(X,Y)\))
Kovarians mengukur arah hubungan linier antara dua variabel. Nilai positif menunjukkan hubungan searah, negatif menunjukkan hubungan berlawanan arah.

**Rumus Kovarians (sampel):**
$$Cov(X,Y) = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{n-1}$$

**Rumus Kovarians (populasi):**
$$Cov(X,Y) = \frac{\sum_{i=1}^{n} (x_i - \mu_x)(y_i - \mu_y)}{n}$$

### b. Korelasi (\(r\))
Korelasi (Pearson) mengukur kekuatan dan arah hubungan linier antara dua variabel. Nilainya berkisar antara -1 hingga +1.

**Rumus Korelasi Pearson:**
$$r = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\sum_{i=1}^{n} (x_i - \bar{x})^2 \sum_{i=1}^{n} (y_i - \bar{y})^2}}$$

Atau dapat ditulis dalam bentuk kovarians dan standar deviasi:
$$r = \frac{Cov(X,Y)}{s_x \cdot s_y}$$

## Interpretasi Singkat

| Ukuran | Fungsi |
|--------|--------|
| Median | Pemusatan data yang tahan terhadap outlier |
| Modus | Frekuensi kemunculan tertinggi |
| Varians | Sebaran kuadrat deviasi dari rata-rata |
| Std Deviasi | Sebaran dalam satuan asli data |
| Kovarians | Arah hubungan linier (tanpa standarisasi) |
| Korelasi | Kekuatan & arah hubungan linier (-1 hingga 1) |

> **Catatan:** Penggunaan \(n-1\) pada sampel disebut **koreksi Bessel**, bertujuan agar varians sampel menjadi penduga tidak bias bagi varians populasi.
