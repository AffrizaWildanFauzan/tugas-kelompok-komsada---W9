# Regresi Logistik Biner — Penjelasan Rumus Manual

Dokumen ini menjelaskan rumus matematis yang digunakan pada file `04_Regresi_Logistik_Biner.R` untuk menganalisis data `walmart_cleaning.csv`. Target analisis adalah memprediksi probabilitas sebuah minggu termasuk minggu liburan (`IsHoliday_Num = 1`) berdasarkan beberapa variabel ekonomi dan penjualan.

---

## 1. Model Probabilitas (Fungsi Sigmoid)

Regresi logistik biner tidak memodelkan $Y$ secara langsung, melainkan **probabilitas** bahwa $Y = 1$ dengan fungsi sigmoid:

$$
\pi_i = P(Y_i = 1 \mid \mathbf{x}_i) = \frac{1}{1 + e^{-\mathbf{x}_i^T \boldsymbol{\beta}}} = \frac{e^{\mathbf{x}_i^T \boldsymbol{\beta}}}{1 + e^{\mathbf{x}_i^T \boldsymbol{\beta}}}
$$

dengan:

- $x_i = (1, x_{i1}, x_{i2}, \ldots, x_{ik})^T$ adalah vektor prediktor observasi ke-$i$ (elemen pertama 1 untuk intercept),
- $\boldsymbol{\beta} = (\beta_0, \beta_1, \ldots, \beta_k)^T$ adalah vektor koefisien,
- $\pi_i \in (0, 1)$.

Dalam dataset Walmart, $\mathbf{x}_i$ berisi: `Intercept`, `Weekly_Sales`, `Temperature`, `Fuel_Price`, `CPI`, `Unemployment` (semua prediktor distandardisasi agar skala seragam).

---

## 2. Odds dan Log-Odds (Logit)

**Odds** adalah perbandingan probabilitas kejadian terjadi dengan tidak terjadi:

$$
\text{Odds}_i = \frac{\pi_i}{1 - \pi_i} = e^{\mathbf{x}_i^T \boldsymbol{\beta}}
$$

**Log-odds** (logit) linear terhadap prediktor:

$$
\text{logit}(\pi_i) = \log\!\left(\frac{\pi_i}{1 - \pi_i}\right) = \mathbf{x}_i^T \boldsymbol{\beta} = \beta_0 + \beta_1 x_{i1} + \cdots + \beta_k x_{ik}
$$

**Odds Ratio** untuk variabel $j$ adalah $e^{\beta_j}$. Interpretasinya: setiap kenaikan satu satuan $x_j$ (dalam kasus kita: satu standar deviasi karena sudah distandardisasi), odds $Y=1$ **dikalikan** $e^{\beta_j}$.

---

## 3. Fungsi Log-Likelihood

Karena $Y_i \sim \text{Bernoulli}(\pi_i)$, likelihood satu observasi adalah $\pi_i^{y_i}(1-\pi_i)^{1-y_i}$. Untuk $n$ observasi yang independen, log-likelihood totalnya:

$$
\ell(\boldsymbol{\beta}) = \sum_{i=1}^{n} \Big[\, y_i \log(\pi_i) + (1 - y_i)\log(1 - \pi_i) \,\Big]
$$

Setelah substitusi $\pi_i = \frac{1}{1 + e^{-\mathbf{x}_i^T \boldsymbol{\beta}}}$, fungsi ini dapat disederhanakan menjadi:

$$
\ell(\boldsymbol{\beta}) = \sum_{i=1}^{n} \Big[\, y_i \, \mathbf{x}_i^T \boldsymbol{\beta} - \log(1 + e^{\mathbf{x}_i^T \boldsymbol{\beta}}) \,\Big]
$$

Tujuan estimasi: cari $\boldsymbol{\beta}$ yang **memaksimalkan** $\ell(\boldsymbol{\beta})$. Tidak seperti regresi linier, tidak ada solusi analitik tertutup — kita harus iterasi numerik.

---

## 4. Vektor Gradien (Score Vector)

Turunan pertama log-likelihood terhadap $\boldsymbol{\beta}$:

$$
\mathbf{U}(\boldsymbol{\beta}) = \frac{\partial \ell}{\partial \boldsymbol{\beta}} = \sum_{i=1}^{n} \mathbf{x}_i (y_i - \pi_i) = \mathbf{X}^T (\mathbf{y} - \boldsymbol{\pi})
$$

dengan:

- $\mathbf{X}$ = matriks desain berukuran $n \times (k+1)$,
- $\mathbf{y}$ = vektor respons berukuran $n \times 1$,
- $\boldsymbol{\pi}$ = vektor probabilitas prediksi berukuran $n \times 1$.

Pada titik maksimum $\ell$, berlaku $\mathbf{U}(\boldsymbol{\beta}) = \mathbf{0}$.

---

## 5. Matriks Hessian

Turunan kedua log-likelihood:

$$
\mathbf{H}(\boldsymbol{\beta}) = \frac{\partial^2 \ell}{\partial \boldsymbol{\beta} \, \partial \boldsymbol{\beta}^T} = -\sum_{i=1}^{n} \mathbf{x}_i \mathbf{x}_i^T \, \pi_i(1 - \pi_i)
$$

Definisikan matriks diagonal $\mathbf{W}$ berukuran $n \times n$ dengan elemen diagonal $w_{ii} = \pi_i(1-\pi_i)$. Maka:

$$
\mathbf{H}(\boldsymbol{\beta}) = -\mathbf{X}^T \mathbf{W} \mathbf{X}
$$

Karena semua $w_{ii} > 0$, matriks $\mathbf{H}$ bersifat **negatif definit** → log-likelihood $\ell$ adalah fungsi **cekung**, sehingga titik kritis yang ditemukan pasti maksimum global.

---

## 6. Metode Newton-Raphson

Newton-Raphson mencari solusi $\mathbf{U}(\boldsymbol{\beta}) = \mathbf{0}$ dengan aproksimasi linier di sekitar $\boldsymbol{\beta}^{(t)}$:

$$
\boldsymbol{\beta}^{(t+1)} = \boldsymbol{\beta}^{(t)} - \big[\mathbf{H}(\boldsymbol{\beta}^{(t)})\big]^{-1} \mathbf{U}(\boldsymbol{\beta}^{(t)})
$$

Substitusi $\mathbf{H} = -\mathbf{X}^T \mathbf{W} \mathbf{X}$ dan $\mathbf{U} = \mathbf{X}^T(\mathbf{y} - \boldsymbol{\pi})$ menghasilkan bentuk kerja:

$$
\boxed{\;\boldsymbol{\beta}^{(t+1)} = \boldsymbol{\beta}^{(t)} + \big(\mathbf{X}^T \mathbf{W} \mathbf{X}\big)^{-1} \mathbf{X}^T (\mathbf{y} - \boldsymbol{\pi})\;}
$$

### Algoritma

1. **Inisialisasi** $\boldsymbol{\beta}^{(0)} = \mathbf{0}$.
2. **Iterasi** untuk $t = 0, 1, 2, \ldots$:
   - Hitung $\pi_i^{(t)} = 1 / (1 + e^{-\mathbf{x}_i^T \boldsymbol{\beta}^{(t)}})$.
   - Hitung $w_i^{(t)} = \pi_i^{(t)}(1 - \pi_i^{(t)})$.
   - Update $\boldsymbol{\beta}^{(t+1)}$ menggunakan rumus di atas.
3. **Kriteria berhenti**: $\max_j \lvert \beta_j^{(t+1)} - \beta_j^{(t)} \rvert < \varepsilon$ (dipakai $\varepsilon = 10^{-6}$).

### Catatan implementasi efisien

Secara matematis $\mathbf{W}$ adalah matriks diagonal $n \times n$. Untuk $n$ besar, menyimpan matriks padat $n \times n$ sangat boros memori. Pada kode digunakan trik aljabar:

$$
\mathbf{X}^T \mathbf{W} \mathbf{X} = \mathbf{X}^T (\mathbf{w} \odot \mathbf{X})
$$

dengan $\mathbf{w}$ = vektor elemen diagonal dan $\odot$ = perkalian broadcast per baris. Hasil numeriknya identik dengan `t(X) %*% diag(w) %*% X` tetapi jauh lebih efisien.

---

## 7. Metode IRLS (Iteratively Reweighted Least Squares)

IRLS memandang setiap iterasi sebagai **regresi linier berbobot** (WLS) terhadap sebuah respons yang dilinearisasi.

### Working Response

Definisikan *working response* $\mathbf{z}$:

$$
\mathbf{z} = \mathbf{X}\boldsymbol{\beta} + \mathbf{W}^{-1}(\mathbf{y} - \boldsymbol{\pi})
$$

Karena $\mathbf{W}$ diagonal, $\mathbf{W}^{-1}$ juga diagonal dengan elemen $1/w_i$, sehingga secara per-elemen:

$$
z_i = \mathbf{x}_i^T \boldsymbol{\beta} + \frac{y_i - \pi_i}{\pi_i(1-\pi_i)}
$$

Intuisi: $\mathbf{z}$ adalah nilai linear predictor plus residual yang dinormalisasi oleh varians — aproksimasi linier dari link logit.

### Update dengan Rumus WLS

$$
\boxed{\;\boldsymbol{\beta}^{(t+1)} = \big(\mathbf{X}^T \mathbf{W} \mathbf{X}\big)^{-1} \mathbf{X}^T \mathbf{W} \mathbf{z}\;}
$$

### Algoritma

1. Inisialisasi $\boldsymbol{\beta}^{(0)} = \mathbf{0}$.
2. Iterasi $t = 0, 1, 2, \ldots$:
   - Hitung $\pi_i^{(t)}$ dan $w_i^{(t)} = \pi_i^{(t)}(1 - \pi_i^{(t)})$.
   - Hitung *working response* $\mathbf{z}^{(t)}$.
   - Update $\boldsymbol{\beta}^{(t+1)} = (\mathbf{X}^T \mathbf{W}^{(t)} \mathbf{X})^{-1} \mathbf{X}^T \mathbf{W}^{(t)} \mathbf{z}^{(t)}$.
3. Berhenti jika $\max_j \lvert \beta_j^{(t+1)} - \beta_j^{(t)} \rvert < \varepsilon$.

---

## 8. Ekuivalensi Newton-Raphson dan IRLS

Dengan substitusi definisi $\mathbf{z}$ ke dalam rumus update IRLS:

$$
\begin{aligned}
\boldsymbol{\beta}^{(t+1)}
&= (\mathbf{X}^T \mathbf{W} \mathbf{X})^{-1} \mathbf{X}^T \mathbf{W} \big[ \mathbf{X}\boldsymbol{\beta}^{(t)} + \mathbf{W}^{-1}(\mathbf{y} - \boldsymbol{\pi}) \big] \\
&= (\mathbf{X}^T \mathbf{W} \mathbf{X})^{-1} \mathbf{X}^T \mathbf{W} \mathbf{X}\boldsymbol{\beta}^{(t)} + (\mathbf{X}^T \mathbf{W} \mathbf{X})^{-1} \mathbf{X}^T (\mathbf{y} - \boldsymbol{\pi}) \\
&= \boldsymbol{\beta}^{(t)} + (\mathbf{X}^T \mathbf{W} \mathbf{X})^{-1} \mathbf{X}^T (\mathbf{y} - \boldsymbol{\pi})
\end{aligned}
$$

Hasil akhir **identik** dengan rumus update Newton-Raphson. Kedua metode ini secara aljabar adalah metode yang sama, hanya berbeda cara memandangnya:

| Aspek | Newton-Raphson | IRLS |
|---|---|---|
| Perspektif | Optimasi fungsi $\ell(\boldsymbol{\beta})$ | Regresi WLS berulang pada $\mathbf{z}$ |
| Objek sentral | Gradien $\mathbf{U}$ & Hessian $\mathbf{H}$ | Matriks bobot $\mathbf{W}$ & respons $\mathbf{z}$ |
| Hasil numerik | Sama persis | Sama persis |

Hasil eksekusi file `04_Regresi_Logistik_Biner.R` pada data Walmart mengkonfirmasi hal ini: selisih koefisien antara Newton-Raphson dan IRLS hanya ~$10^{-15}$ (batas presisi mesin).

---

## 9. Evaluasi: Confusion Matrix

Setelah $\hat{\boldsymbol{\beta}}$ didapat, probabilitas prediksi $\hat{\pi}_i$ dihitung, lalu dikonversi ke kelas dengan threshold $\tau$ (dipakai $\tau = 0{,}5$):

$$
\hat{y}_i = \begin{cases} 1 & \hat{\pi}_i \geq \tau \\ 0 & \hat{\pi}_i < \tau \end{cases}
$$

Dari tabel konfusi dihitung metrik:

$$
\text{Akurasi} = \frac{TP + TN}{TP + TN + FP + FN} \qquad
\text{Presisi} = \frac{TP}{TP + FP}
$$

$$
\text{Recall} = \frac{TP}{TP + FN} \qquad
\text{Spesifitas} = \frac{TN}{TN + FP}
$$

Pada data Walmart, kelas `IsHoliday = 1` hanya sekitar 7% dari total data. Akibatnya, threshold 0,5 cenderung menghasilkan recall rendah pada kelas minoritas — akurasi tinggi dapat menyesatkan karena model bisa saja hanya memprediksi kelas mayoritas. Untuk analisis lebih lanjut, threshold dapat diturunkan atau digunakan metrik seperti ROC-AUC.
