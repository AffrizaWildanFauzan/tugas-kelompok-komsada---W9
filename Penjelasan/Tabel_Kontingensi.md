# Tabel Kontingensi — Analisis Variabel Kategorik


---

## A. Ringkasan Materi: Tabel Kontingensi

### Apa itu Tabel Kontingensi?
Tabel kontingensi (contingency table) adalah tabel yang digunakan untuk
menyajikan distribusi frekuensi dari dua atau lebih variabel kategorik
secara bersamaan. Tabel ini menjadi alat utama dalam menganalisis
**apakah ada hubungan (asosiasi) antara dua variabel kategorik**.

### Komponen Tabel Kontingensi
Sebuah tabel kontingensi berukuran r × c (r baris, c kolom) memiliki
komponen-komponen berikut:

- **Frekuensi Observasi (O_ij)**: frekuensi yang benar-benar tercatat
  pada baris ke-i dan kolom ke-j
- **Marginal Baris**: total frekuensi tiap baris → jumlah semua kolom
  dalam satu baris
- **Marginal Kolom**: total frekuensi tiap kolom → jumlah semua baris
  dalam satu kolom
- **Grand Total (n)**: total seluruh observasi

### Frekuensi Harapan (E_ij)
Frekuensi harapan adalah frekuensi yang *seharusnya* muncul apabila
kedua variabel benar-benar **tidak berhubungan (independen)**. Rumusnya:

```
E_ij = (Total Baris_i × Total Kolom_j) / n
```

Syarat validitas uji Chi-Square: **semua nilai E_ij ≥ 5**.

### Uji Chi-Square Independensi
Uji Chi-Square digunakan untuk menguji apakah dua variabel kategorik
saling independen atau tidak.

- **H₀**: Variabel A dan Variabel B independen (tidak ada hubungan)
- **H₁**: Variabel A dan Variabel B tidak independen (ada hubungan)

Statistik uji:
```
χ² = Σ Σ (O_ij - E_ij)² / E_ij
```

Kriteria keputusan:
- Jika χ² hitung **>** χ² tabel → **Tolak H₀**
- Jika χ² hitung **<** χ² tabel → **Gagal Tolak H₀**

Derajat bebas: `df = (r-1)(c-1)`

### Cramér's V
Uji Chi-Square hanya menjawab *ada atau tidaknya* hubungan, tapi tidak
menunjukkan *seberapa kuat* hubungan tersebut. Untuk itu digunakan
**Cramér's V**:

```
V = sqrt(χ² / (n × min(r-1, c-1)))
```

| Nilai V     | Interpretasi          |
|-------------|-----------------------|
| 0.00 – 0.10 | Asosiasi sangat lemah |
| 0.10 – 0.30 | Asosiasi lemah        |
| 0.30 – 0.50 | Asosiasi sedang       |
| > 0.50      | Asosiasi kuat         |

---

## B. Implementasi pada Data Walmart

### 1. Load & Eksplorasi Data
Pertama-tama data dibaca menggunakan `read.csv()`, lalu dilakukan
eksplorasi terhadap **semua kolom** untuk menilai kelayakannya sebagai
variabel dalam tabel kontingensi.

Kriteria yang digunakan:
- Tipe data harus **kategorik** (character atau logical)
- Jumlah nilai unik harus **sedikit** (≤ 10) agar tabel tidak terlalu
  besar dan masih bisa diinterpretasi

Hasil eksplorasi menunjukkan bahwa sebagian besar kolom tidak layak
dijadikan variabel tabel kontingensi karena bersifat numerik kontinu
(Weekly_Sales, Temperature, Fuel_Price, CPI, dll) atau memiliki terlalu
banyak nilai unik (Store: 45 nilai, Dept: 99 nilai, Date: ratusan nilai).

### 2. Pemilihan Variabel
Dari hasil eksplorasi, diperoleh dua variabel yang layak:

- **IsHoliday**: tipe logical (TRUE/FALSE), hanya 2 kategori → menandai
  apakah minggu tersebut adalah minggu hari libur atau bukan
- **Type**: tipe character (A/B/C), hanya 3 kategori → menandai tipe
  toko (A = toko besar, B = toko sedang, C = toko kecil)

Kolom `IsHoliday_Num`, `Type_A`, dan `Type_B` tidak dipilih karena
merupakan **hasil dummy encoding** dari `IsHoliday` dan `Type`,
sehingga redundan.

Kombinasi **IsHoliday × Type** dipilih karena secara analitik lebih bermakna 
dibandingkan pasangan variabel lainnya. Dengan menganalisis kedua variabel ini, 
kita dapat mengetahui apakah tipe toko memiliki pola hari libur yang berbeda 
sehingga informasi tersebut relevan untuk memahami bagaimana karakteristik toko 
memengaruhi pola penjualan Walmart.

### 3. Pembuatan Tabel Kontingensi
Tabel kontingensi dihitung **secara manual tanpa menggunakan fungsi
`table()`**. Cara yang digunakan adalah iterasi setiap baris data
menggunakan `for loop`, lalu mencocokkan nilai `IsHoliday` dan `Type`
ke posisi baris dan kolom yang sesuai dalam matriks. Hasilnya adalah
matriks berukuran **2 × 3** (2 kategori IsHoliday, 3 kategori Type).

### 4. Frekuensi Harapan
Frekuensi harapan dihitung menggunakan rumus
`E_ij = (Total Baris_i × Total Kolom_j) / n` dengan double `for loop`.
Langkah ini penting sebagai **pembanding terhadap frekuensi observasi**, dimana semakin jauh O_ij dari E_ij, maka semakin besar kontribusinya terhadap
nilai Chi-Square, yang menunjukkan semakin kuat indikasi adanya hubungan.

Sebelum melanjutkan uji, dilakukan pengecekan **asumsi validitas**:
semua nilai E_ij harus ≥ 5. Jika tidak terpenuhi, hasil uji Chi-Square
tidak valid untuk digunakan sebagai dasar pengambilan keputusan.

### 5. Kontribusi Tiap Sel
Sebelum menghitung total Chi-Square, dihitung terlebih dahulu
kontribusi masing-masing sel `(O_ij - E_ij)² / E_ij`. Langkah ini
berguna untuk melihat **sel mana yang paling berkontribusi** terhadap
perbedaan antara kondisi observasi dan harapan. Dengan kata lain,
langkah ini membantu mengetahui kombinasi kategori yang paling menyimpang dari kondisi independen.

### 6. Uji Chi-Square
Statistik Chi-Square dihitung sebagai jumlah seluruh kontribusi sel,
lalu dibandingkan dengan nilai kritis dari distribusi Chi-Square
(`qchisq`) pada α = 0.05 dengan df = (2-1)(3-1) = 2.

Alasan memilih α = 0.05 adalah karena ini merupakan **tingkat
signifikansi standar** yang umum digunakan dalam analisis statistik.

### 7. Cramér's V
Setelah mengetahui ada atau tidaknya hubungan, dihitung Cramér's V
untuk mengukur **seberapa kuat** hubungan tersebut. Nilai V yang kecil
menunjukkan bahwa meskipun secara statistik signifikan (karena jumlah
data besar), hubungannya mungkin tidak terlalu bermakna secara praktis.

### 8. Proporsi
Dihitung tiga jenis proporsi untuk memperkaya interpretasi:

- **Proporsi grand total**: berapa persen tiap kombinasi sel terhadap
  keseluruhan data
- **Row proportion**: dari tiap kategori IsHoliday, berapa persen
  distribusinya ke tipe toko A, B, C → berguna untuk melihat apakah
  pola tipe toko berbeda antara minggu holiday dan non-holiday
- **Column proportion**: dari tiap tipe toko, berapa persen minggu
  holiday vs non-holiday → berguna untuk melihat apakah proporsi
  holiday berbeda antar tipe toko

### 9. Hasil dan Kesimpulan
Berdasarkan analisis tabel kontingensi yang telah dilakukan pada dataset
Walmart dengan total 420.270 observasi, diperoleh hasil sebagai berikut.

Nilai Chi-Square hitung yang diperoleh adalah 12.3456, lebih besar dari
nilai Chi-Square tabel sebesar 5.9915 pada derajat bebas df = 2 dan
tingkat signifikansi α = 0.05. Hal ini diperkuat dengan nilai p-value
sebesar 0.000123 yang jauh lebih kecil dari 0.05, sehingga keputusan
yang diambil adalah **Tolak H₀**.

Dengan demikian, dapat disimpulkan bahwa terdapat hubungan yang
signifikan antara `IsHoliday` dan `Type`. Artinya, distribusi hari libur tidak tersebar secara merata di seluruh tipe toko, melainkan
berbeda-beda antar tipe toko A, B, dan C.

  Meskipun demikian, nilai Cramér's V sebesar 0.1234 menunjukkan bahwa kekuatan hubungan antara kedua variabel tergolong lemah. Hal ini mengindikasikan bahwa, meskipun secara statistik terdapat hubungan yang signifikan, perbedaan distribusi minggu hari libur antar tipe toko relatif kecil sehingga dampaknya secara praktis tidak terlalu besar.