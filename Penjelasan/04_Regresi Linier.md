# Regresi Linier

## Content:

-   Regresi Linier Sederhana
-   Regresi Linier Berganda
-   Konsep Dasar
-   Estimasi Parameter
-   Nilai Prediksi
-   Jumlah Kuadrat
-   Koefisien Determinasi
-   Uji F
-   Uji t
-   Confidence Interval

## Quick Overview Regresi Linier:

Regresi linier adalah metode statistik yang digunakan untuk melihat hubungan antara variabel bebas dengan variabel terikat, lalu membentuk persamaan yang bisa dipakai untuk menjelaskan pengaruh dan membuat prediksi.

#### Istilah Dasar:

-   Variabel bebas (X): variabel yang mempengaruhi
-   Variabel terikat (Y): variabel yang dipengaruhi
-   Intercept $(\beta_0)$: nilai Y saat X = 0
-   Koefisien regresi $(\beta_1, \beta_2, \dots, \beta_p)$: besar perubahan Y akibat perubahan X
-   Error $(\varepsilon)$: selisih antara nilai asli dan nilai prediksi

------------------------------------------------------------------------

## Regresi Linier Sederhana

Regresi linier sederhana digunakan saat hanya ada **1 variabel bebas** yang mempengaruhi **1 variabel terikat**.

### Bentuk Model

$$Y_i = \beta_0 + \beta_1 X_i + \varepsilon_i$$

Keterangan: - $Y_i$: nilai variabel terikat ke-i - $X_i$: nilai variabel bebas ke-i - $\beta_0$: intercept - $\beta_1$: slope / koefisien regresi - $\varepsilon_i$: error

### Rata-rata Data

$$\bar{X} = \frac{1}{n}\sum_{i=1}^{n} X_i$$

$$\bar{Y} = \frac{1}{n}\sum_{i=1}^{n} Y_i$$

Rata-rata dipakai untuk mencari pusat data dan membantu menghitung koefisien regresi.

### Estimasi Koefisien Regresi

Koefisien slope:

$$\hat{\beta}_1 = \frac{\sum_{i=1}^{n}(X_i-\bar{X})(Y_i-\bar{Y})}{\sum_{i=1}^{n}(X_i-\bar{X})^2}$$

Intercept:

$$\hat{\beta}_0 = \bar{Y} - \hat{\beta}_1\bar{X}$$

Makna: - Jika $\hat{\beta}_1 > 0$, maka hubungan X dan Y searah - Jika $\hat{\beta}_1 < 0$, maka hubungan X dan Y berlawanan arah

### Persamaan Regresi

Setelah koefisien didapat, persamaan regresinya menjadi:

$$\hat{Y}_i = \hat{\beta}_0 + \hat{\beta}_1 X_i$$

Persamaan ini dipakai untuk menghitung nilai prediksi Y.

### Nilai Prediksi

$$\hat{Y}_i = \hat{\beta}_0 + \hat{\beta}_1 X_i$$

### Error / Residual

$$e_i = Y_i - \hat{Y}_i$$

Residual menunjukkan selisih antara nilai asli dan nilai hasil prediksi model.

### Jumlah Kuadrat (Sum of Squares)

#### Total Sum of Squares (SST)

$$SST = \sum_{i=1}^{n}(Y_i - \bar{Y})^2$$

SST menunjukkan total variasi data Y terhadap rata-ratanya.

#### Regression Sum of Squares (SSR)

$$SSR = \sum_{i=1}^{n}(\hat{Y}_i - \bar{Y})^2$$

SSR menunjukkan variasi Y yang bisa dijelaskan oleh model regresi.

#### Error Sum of Squares (SSE)

$$SSE = \sum_{i=1}^{n}(Y_i - \hat{Y}_i)^2$$

SSE menunjukkan variasi yang tidak bisa dijelaskan oleh model.

Hubungan ketiganya: $$SST = SSR + SSE$$

### Derajat Bebas

-   Regresi: $$df_{reg} = 1$$
-   Error: $$df_{err} = n - 2$$
-   Total: $$df_{tot} = n - 1$$

### Mean Square

Mean square didapat dari jumlah kuadrat dibagi derajat bebas.

$$MSR = \frac{SSR}{df_{reg}}$$

$$MSE = \frac{SSE}{df_{err}}$$

### Uji F (Uji Serentak)

Uji F dipakai untuk melihat apakah model regresi secara keseluruhan signifikan atau tidak.

Hipotesis: - $$H_0 : \beta_1 = 0$$ - $$H_1 : \beta_1 \ne 0$$

Statistik uji: $$F_{hitung} = \frac{MSR}{MSE}$$

Keputusan: - Tolak $$H_0$$ jika $$F_{hitung} > F_{tabel}$$ - Atau tolak $$H_0$$ jika p-value \< 0,05

Makna: - Jika $$H_0$$ ditolak, berarti variabel X berpengaruh terhadap Y

### Koefisien Determinasi

Koefisien determinasi menunjukkan seberapa besar model mampu menjelaskan variasi data.

$$R^2 = \frac{SSR}{SST}$$

Nilai $R^2$: - Mendekati 1 → model semakin baik - Mendekati 0 → model kurang mampu menjelaskan data

### Adjusted R²

Adjusted $R^2$ dipakai sebagai penyesuaian agar hasil penilaian model lebih adil.

$$R^2_{adj} = 1 - \frac{SSE/(n-2)}{SST/(n-1)}$$

### Uji t (Uji Parsial)

Uji t dipakai untuk melihat apakah masing-masing koefisien signifikan atau tidak.

Hipotesis: - $$H_0 : \beta_i = 0$$ - $$H_1 : \beta_i \ne 0$$

#### Standard Error Koefisien

Untuk slope: $$SE(\hat{\beta}_1) = \sqrt{\frac{MSE}{\sum_{i=1}^{n}(X_i-\bar{X})^2}}$$

Untuk intercept: $$SE(\hat{\beta}_0) = \sqrt{MSE \cdot \frac{\sum_{i=1}^{n}X_i^2}{n\sum_{i=1}^{n}(X_i-\bar{X})^2}}$$

#### Statistik Uji t

$$t_{hitung} = \frac{\hat{\beta}_i}{SE(\hat{\beta}_i)}$$

Keputusan: - Tolak $$H_0$$ jika $$|t_{hitung}| > t_{tabel}$$ - Atau tolak $$H_0$$ jika p-value \< 0,05

### Confidence Interval

Interval kepercayaan dipakai untuk menunjukkan rentang nilai parameter yang mungkin.

$$CI(\beta_i) = \hat{\beta}_i \pm t_{\alpha/2, df} \times SE(\hat{\beta}_i)$$

Makna: - Semakin sempit intervalnya, biasanya estimasi makin stabil - Jika interval tidak memuat nol, biasanya koefisien cenderung signifikan

------------------------------------------------------------------------

## Regresi Linier Berganda

Regresi linier berganda digunakan saat ada **lebih dari 1 variabel bebas** yang mempengaruhi **1 variabel terikat**.

### Bentuk Model

$$Y_i = \beta_0 + \beta_1 X_{1i} + \beta_2 X_{2i} + \dots + \beta_p X_{pi} + \varepsilon_i$$

Keterangan: - $X_{1i}, X_{2i}, \dots, X_{pi}$: variabel bebas - $\beta_1, \beta_2, \dots, \beta_p$: koefisien masing-masing variabel - $p$: banyaknya variabel bebas

### Bentuk Matriks

Model regresi berganda bisa ditulis lebih ringkas dalam bentuk matriks:

$$\mathbf{Y} = \mathbf{X}\boldsymbol{\beta} + \boldsymbol{\varepsilon}$$

Keterangan: - $\mathbf{Y}$: vektor data respon - $\mathbf{X}$: matriks variabel bebas - $\boldsymbol{\beta}$: vektor parameter - $\boldsymbol{\varepsilon}$: vektor error

### Estimasi Koefisien Regresi

Koefisien regresi berganda dicari dengan metode matriks:

$$\hat{\boldsymbol{\beta}} = (X^T X)^{-1} X^T Y$$

Rumus ini sesuai dengan perhitungan pada kode R yang memakai: - transpose matriks - perkalian matriks - invers matriks

### Nilai Prediksi

Setelah koefisien diperoleh, nilai prediksi dihitung dengan:

$$\hat{Y} = X\hat{\beta}$$

### Rata-rata Respon

$$\bar{Y} = \frac{1}{n}\sum_{i=1}^{n} Y_i$$

### Jumlah Kuadrat

#### Regression Sum of Squares (SSR)

$$SSR = \sum_{i=1}^{n}(\hat{Y}_i - \bar{Y})^2$$

#### Error Sum of Squares (SSE)

$$SSE = \sum_{i=1}^{n}(Y_i - \hat{Y}_i)^2$$

#### Total Sum of Squares (SST)

$$SST = SSR + SSE$$

### Derajat Bebas

-   Regresi: $$df_{reg} = p$$
-   Error: $$df_{err} = n - p - 1$$
-   Total: $$df_{tot} = n - 1$$

### Mean Square

$$MSR = \frac{SSR}{p}$$

$$MSE = \frac{SSE}{n - p - 1}$$

### Uji F (Uji Serentak)

Uji F pada regresi berganda dipakai untuk melihat apakah semua variabel bebas secara bersama-sama berpengaruh terhadap Y.

Hipotesis: - $$H_0 : \beta_1 = \beta_2 = \dots = \beta_p = 0$$ - $$H_1 :$$ minimal ada satu $\beta_i \ne 0$

Statistik uji: $$F_{hitung} = \frac{MSR}{MSE}$$

Keputusan: - Tolak $$H_0$$ jika p-value \< 0,05 - Atau tolak $$H_0$$ jika $$F_{hitung} > F_{tabel}$$

Makna: - Jika signifikan, berarti model berganda layak dipakai

### Varians Koefisien

Pada regresi berganda, varians koefisien dihitung dengan:

$$Var(\hat{\beta}) = MSE(X^T X)^{-1}$$

### Standard Error Koefisien

Standard error tiap koefisien didapat dari akar diagonal matriks varians:

$$SE(\hat{\beta}) = \sqrt{diag\left(Var(\hat{\beta})\right)}$$

### Uji t (Parsial)

Setiap koefisien diuji satu per satu untuk melihat apakah variabel tersebut berpengaruh secara individual.

Hipotesis: - $$H_0 : \beta_i = 0$$ - $$H_1 : \beta_i \ne 0$$

Statistik uji: $$t_{hitung} = \frac{\hat{\beta}_i}{SE(\hat{\beta}_i)}$$

Keputusan: - Tolak $$H_0$$ jika p-value \< 0,05

Makna: - Variabel yang signifikan berarti punya pengaruh nyata terhadap Y saat variabel lain dianggap tetap

### p-value Uji F

$$p\text{-value}_F = 1 - PF(F_{hitung}, df_{reg}, df_{err})$$

### p-value Uji t

$$p\text{-value}_t = 2\left(1 - PT(|t_{hitung}|, df_{err})\right)$$

------------------------------------------------------------------------

## Ringkasan Perbedaan

### Regresi Linier Sederhana

-   Hanya punya 1 variabel bebas
-   Bentuk model: $$Y = \beta_0 + \beta_1 X$$

### Regresi Linier Berganda

-   Punya lebih dari 1 variabel bebas
-   Bentuk model: $$Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \dots + \beta_p X_p$$

------------------------------------------------------------------------
