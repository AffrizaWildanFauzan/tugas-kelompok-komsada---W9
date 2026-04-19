# Time Series
## Content:
- Moving Average
- Exponential Smoothing (Single Exponential Smoothing, Double Exponential Smoothing, Holt Winters Exponential Smoothing)
- ACF & PACF
- ARIMA
- Diagnostic Checking

## Quick Overview Time Series Data:
#### 4 Tipe Data Time Series:
- Stasioner: data tidak bergerak terlalu jauh dari averagenya sepanjang waktu
- Trend: data cenderung naik atau turun sepanjang waktu
- Seasonal: data menunjukan adanya lonjakan pada waktu tertentu yang berulang (periode yang sama)
- Cyclic: terjadi waktu fluktuasi naik turun tapi durasi dan periode terjadinya tidak tetap
## Moving Average
$$SMA_t = \frac{1}{k} \sum_{i=0}^{k-1} Y_{t-i}$$

Moving average biasanya digunakan untuk menghaluskan data ketika ada fluktuasi jangka pendek untuk memperjelas tren jangka panjang. Metode ini menghaluskan dengan mengambil rata-rata (jumlah k data) untuk data selanjutnya.
## Exponential Smoothing
Metode ini memberikan bobot yang menurun secara eksponensial terhadap data yang lebih lama sehingga data terbaru yang paling berpengaruh terhadap forecasting.
- Single Exponential Smoothing: Digunakan untuk data yang tidak memiliki komponen tren maupun seasonal (lebih ke arah stasioner)

$$F_{t+1} = \alpha Y_t + (1 - \alpha) F_t$$
- Double Exponential Smoothing: Digunakan untuk data yang memiliki pola tren tapi tidak ada pola seasonal

  
Level: $$L_t = \alpha Y_t + (1 - \alpha)(L_{t-1} + T_{t-1})$$

Trend: $$T_t = \beta(L_t - L_{t-1}) + (1 - \beta)T_{t-1}$$

Forecast: $$F_{t+m} = L_t + mT_t$$
- Holt Winters Exponential Smoothing: Digunakan untuk data dengan adanya tren dan musiman, menangkap semua sifat data time series.

Level: $$L_t = \alpha(Y_t - S_{t-L}) + (1 - \alpha)(L_{t-1} + T_{t-1})$$

Trend: $$T_t = \beta(L_t - L_{t-1}) + (1 - \beta)T_{t-1}$$

Seasonal: $$S_t = \gamma(Y_t - L_t) + (1 - \gamma)S_{t-L}$$

Forecast: $$F_{t+m} = L_t + mT_t + S_{t-L+m}$$

## ACF (Autocorrelation Function)
$$\rho_k = \frac{\sum_{t=k+1}^{n} (Y_t - \bar{Y})(Y_{t-k} - \bar{Y})}{\sum_{t=1}^{n} (Y_t - \bar{Y})^2}$$

ACF digunakan untuk mengukur hubungan antara data sekarang dengan data masa lalu pada berbagai lag. Dalam konteks pemodelan time series, ini digunakan untuk menentukan orde moving average (q) pada model ARIMA. Jika terjadi cut off pada lag ke-q, maka kemungkinan model yang terbaik adalah ARIMA(0,0,1)

## PACF (Partial Autocorrelation Function)
$$Y_t = \beta_0 + \phi_{k1}Y_{t-1} + \phi_{k2}Y_{t-2} + \dots + \phi_{kk}Y_{t-k} + \epsilon_t$$

PACF digunakan untuk mengukur hubungan antara dua titik waktu dengan menghilangkan pengaruh dari lag di antaranya. Ini digunakan untuk menentukan orde Autoregressive(p). Jika PACF cut off pada lag ke-p, maka modelnya adalah ARIMA(1,0,0)

Note: Jika ACF dan PACF cut off, maka kita menggunakan salah satu model. Jika keduanya dies down, maka kita bisa menggunakan model ARMA
## ARIMA (AutoRegressive Integrated Moving Average)
Arima merupakan salah satu model statistik yang menggabungkan tiga komponen untuk meramalkan data time series:
- AR: menggunakan hubungan antar observasi saat ini dengan sebelumnya
- I (Integrated): proses differencing  untuk membuat data stasioner
- MA: menggunakan hubungan antar observasi saat ini dengan error dari observasi sebelumnya

Notasi: ARIMA(p,d,q)

Syarat untuk menggunakan model ARIMA:
Data harus stasioner terhadap mean dan varians
- Stasioneritas terhadap mean: menggunakan uji Augmented Dickey Fuller
  
$H_0$: Data Tidak Stasioner.

$H_1$: Data Stasioner.

Reject $H_0$ jika p-value < 0,05

Jika semisal gagal reject, maka kita melakukan differencing hingga data stasioner terhadap mean dan parameter d pada ARIMA mengikuti berapa kali kita melakukan differencing terhadap data awal.

- Stasioneritas terhadap mean: menggunakan uji BoxCox
  
Jika lambda mendekati 1, maka data sudah stasioner terhadap varians

Jika belum maka perlu dilakukan transformasi

| Nilai Lambda | Jenis Transformasi |
| :---: | :--- |
| -1 | $$\frac{1}{Y_t}$$ |
| -0.5 | $$\frac{1}{\sqrt{Y_t}}$$ |
| 0 | $$\ln(Y_t)$$ |
| 0.5 | $$\sqrt{Y_t}$$ |
| 1 | $$Y_t$$ (tidak ada transformasi) |

Dengan adanya berbagai pilihan model, kita memilih model yang terbaik dengan melihat skor AIC yang paling kecil.

AIC melihat dua hal yaitu Goodness of Fit (seberapa bisanya model menjelaskan data) dan Simplicity (seberapa kompleks model) jadi model dengan parameter yang lebih banyak akan dikenakan penalti.

## Diagnostic Checking
$$Q = n(n+2) \sum_{k=1}^{h} \frac{\hat{\rho}_k^2}{n-k}$$

Model sudah layak digunakan ketika residual dari model tersebut tidak memiliki pola (white noise). Oleh karena itu, kita menggunakan uji Ljung Box untuk mengetahui apakah residual sudah white noise atau belum.

$H_0$: Tidak ada korelasi pada residual hingga lag ke k (residual white noise).

$H_1$: Ada korelasi pada residual hingga lag ke k (residual tidak white noise).

Jika p-value > 0,05,  maka kita gagal tolak $H_0$ sehingga model sudah layak digunakan. Jika belum maka, kita harus meninjau kembali data ataupun mencoba menggunakan model lain.
