#Load Library
library(ggplot2)

#Load Data mtcars dan ambil kolom mpg untuk analisis lebih lanjut yang tersedia pada R

data(mtcars)
mpg = mtcars$mpg

#Ukuran Pemusatan (Mean)

#function rata-rata
rata2 = function(data){
  total = 0 #define variabel total untuk menghitung sum secara iteratif
  n = length(data)
  for (i in 1:n){
    total = total+data[i]
  }
  return(total/n)
}

rata2(mpg)

#Ukuran Penyebaran (Varians)

varians = function(data){
  total = 0
  n = length(data)
  avg = rata2(data)
  for (i in 1:n){
    total  = total+(data[i] - avg)^2
  }
  return(total/(n-1))
}

varians(mpg)

#Visualisasi (Botplox)
#menggunakan function base R
boxplot(mpg,
        main ="Distribusi Miles per Gallon dengan Base R",
        ylab = "Miles per Gallon",
        col = "blue")
#menggunakan ggplot2(harus dalam bentuk dataframe)
df = as.data.frame(mpg)
ggplot(data = df, mapping = aes(y = mpg)) +
    geom_boxplot()+
    labs(title = "Visualisasi Distribusi Miles per Gallon dengan ggplot",
              y = "Miles per Gallon") +
    theme_minimal()
  