![Statistika](Statdesk.png)

# Rumus Statistika Deskriptif (Lengkap & Terkoreksi)

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

> Koreksi: Pada file Anda tertulis `X(n + 1/5/2)` — itu tidak tepat. Rumus di atas adalah yang benar.

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

> Koreksi: File Anda menulis `Skewness = Σ(xi - x̄)³ / n?` — itu tidak lengkap. Rumus di atas adalah bentuk baku.

### Kurtosis (Keruncingan)
Mengukur "ketajaman" puncak distribusi.

**Rumus (excess kurtosis sering digunakan):**

$$Kurtosis = \frac{\frac{1}{n}\sum_{i=1}^{n} (x_i - \bar{x})^4}{\left(\frac{1}{n}\sum_{i=1}^{n} (x_i - \bar{x})^2\right)^2} - 3$$

Atau tanpa koreksi (moment kurtosis):

$$Kurtosis = \frac{\sum (x_i - \bar{x})^4}{n \cdot s^4}$$

> Koreksi: File Anda menulis `Kurtosis = Σ(xi - x̄)⁴ / n/` — penyebutnya kurang tepat. Rumus di atas adalah yang benar.

---

## Ringkasan Koreksi dari File Anda

| Komponen | Dalam file Anda | Versi Benar |
|----------|----------------|---------------|
| Median ganjil | $X(n + 1/5/2)$ | $X_{(n+1)/2}$ |
| Median genap | $((X_n) + X_{n/2} + 1))/2$ | $(X_{n/2} + X_{n/2+1})/2$ |
| Skewness | $\frac{\sum (x_i - \bar{x})^3}{n?}$ | Dibagi $n \cdot s^3$ (dengan standarisasi) |
| Kurtosis | $\frac{\sum (x_i - \bar{x})^4}{n/}$ | Dibagi $n \cdot s^4$ (bisa dikurangi 3 untuk excess) |
