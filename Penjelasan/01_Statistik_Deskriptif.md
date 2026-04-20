![Statistika](StatDesk.png)

# Rumus Statistika Deskriptif

## 1. Ukuran Pemusatan

### Mean (Rata-rata)
Rata-rata hitung dari seluruh nilai data.

$$\bar{x} = \frac{\sum_{i=1}^{n} x_i}{n}$$

### Median (Nilai Tengah)
Nilai yang membagi data terurut menjadi dua bagian sama besar.

**Jika n ganjil:**

$$Median = X_{\frac{n+1}{2}}$$

**Jika n genap:**

$$Median = \frac{X_{\frac{n}{2}} + X_{\frac{n}{2}+1}}{2}$$

### Modus (Nilai Terbanyak Muncul)

a. Data Tunggal

Tidak ada rumus khusus:

Modus = nilai dengan frekuensi terbanyak

Catatan:

Bisa tidak ada modus (semua frekuensi sama)
Bisa lebih dari satu modus (bimodal/multimodal)

b. Data Berkelompok

$$Mo = L + \left( \frac{d_1}{d_1 + d_2} \right) \times c$$
- L = tepi bawah kelas modus  
- d_1 = selisih frekuensi kelas modus dengan kelas sebelumnya  
- d_2 = selisih frekuensi kelas modus dengan kelas sesudahnya  
- c = panjang kelas

## 2. Ukuran Posisi (Kuartil)

### Kuartil 3 (Q₃)
Nilai yang membagi data sehingga 75% data berada di bawahnya.

Untuk data tunggal:

$$Q_3 = X_{k_3}$$
dengan:
$$k_3 = \frac{3(n+1)}{4}$$

Jika $k_3$ tidak bulat, gunakan interpolasi:

$$Q_3 = x_l + (k_3 - l)(x_u - x_l)$$

- $l = \lfloor k_3 \rfloor$ (pembulatan ke bawah / lantai)
- $u = \lceil k_3 \rceil$ (pembulatan ke atas / langit-langit)

### Kuartil 1 (Q₁) — pelengkap

$$k_1 = \frac{n+1}{4}$$
$$Q_1 = x_l + (k_1 - l)(x_u - x_l)$$

## 3. Ukuran Penyebaran

### IQR (Interquartile Range)
Jangkauan antarkuartil, mengukur sebaran 50% data tengah.

$$IQR = Q_3 - Q_1$$

### Range (Jangkauan)
$$Range = Maksimum - Minimum$$

### Minimum & Maksimum
- **Min** = nilai terkecil dalam data
- **Maks** = nilai terbesar dalam data

### Varians ($s^2$)

$$s^2 = \frac{\sum_{i=1}^{n} (x_i - \bar{x})^2}{n-1}$$

### Standar Deviasi ($s$)
Akar kuadrat dari varians.

$$s = \sqrt{s^2} = \sqrt{\frac{\sum_{i=1}^{n} (x_i - \bar{x})^2}{n-1}}$$

## 4. Ukuran Bentuk Distribusi

### Skewness (Kemiringan)
Mengukur simetri distribusi data.

**Rumus (Pearson's moment coefficient):**

$$Skewness = \frac{\frac{1}{n}\sum_{i=1}^{n} (x_i - \bar{x})^3}{\left(\sqrt{\frac{1}{n}\sum_{i=1}^{n} (x_i - \bar{x})^2}\right)^3}$$

Atau dengan koreksi sampel (biasa digunakan):

$$Skewness = \frac{n}{(n-1)(n-2)} \cdot \frac{\sum (x_i - \bar{x})^3}{s^3}$$

### Kurtosis (Keruncingan)
Mengukur "ketajaman" puncak distribusi.

**Rumus (excess kurtosis sering digunakan):**

$$Kurtosis = \frac{\frac{1}{n}\sum_{i=1}^{n} (x_i - \bar{x})^4}{\left(\frac{1}{n}\sum_{i=1}^{n} (x_i - \bar{x})^2\right)^2} - 3$$

Atau tanpa koreksi (moment kurtosis):

$$Kurtosis = \frac{\sum (x_i - \bar{x})^4}{n \cdot s^4}$$

## 5. Ukuran Hubungan Antar Variabel

### Kovarians

Mengukur arah hubungan linear antara dua variabel.

$$
\text{Cov}(X,Y) = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{n - 1}
$$

**Interpretasi:**
- Cov > 0 → hubungan searah  
- Cov < 0 → hubungan berlawanan arah  
- Cov ≈ 0 → tidak ada hubungan linear  

---

### Korelasi Pearson

Mengukur kekuatan dan arah hubungan linear.
<p align="center">
$r=\frac{\text{Cov}(X,Y)}{s_X \cdot s_Y}$
</p>

---

## Ringkasan formula

| Komponen        | Formula |
|----------------|--------|
| Median ganjil  | $X_{\left(\frac{n+1}{2}\right)}$ |
| Median genap   | $\frac{X_{\left(\frac{n}{2}\right)} + X_{\left(\frac{n}{2}+1\right)}}{2}$ |
| Skewness       | $\frac{\frac{1}{n}\sum (x_i - \bar{x})^3}{\left(\frac{1}{n}\sum (x_i - \bar{x})^2\right)^{3/2}}$ |
| Kurtosis       | $\frac{\frac{1}{n}\sum (x_i - \bar{x})^4}{\left(\frac{1}{n}\sum (x_i - \bar{x})^2\right)^2}$ |
| Kovarians      | $\frac{\sum (x_i - \bar{x})(y_i - \bar{y})}{n - 1}$ |
| Korelasi       | $\frac{\text{Cov}(X,Y)}{s_X \cdot s_Y}$ |
