# 1. Load Data
set.seed(42)
df<-read.csv("~/Downloads/dataset_walmart.csv")
# 2. Cek Struktur & Data Awal
str(df)
head(df)
dim(df)
View(df)
# 3. Statistik Deskriptif Numerik
# summary dasar
summary(df)

colSums(is.na(df))
# fungsi statistik lengkap
mean<-function(x){
  sum=0
  n<-length(x)
  for(i in 1:n){
    sum=sum+x[i]
  }
  xbar=sum/n
  return(xbar)
}

stadev<-function(x){
  xbar<-mean(x)
  sum=0
  n<-length(x)
  for(i in 1:n){
    sum=sum+(x[i]-xbar)^2
  }
  std=sqrt(sum)/n
  return(std)
}

varians<-function(x){
  xbar<-mean(x)
  sum=0
  n<-length(x)
  for(i in 1:n){
    sum=sum+(x[i]-xbar)^2
  }
  var=sum/n
  return(var)
}

kovarians<-function(x,y){
  xbar<-mean(x)
  ybar<-mean(y)
  n<-length(x)
  sum=0
  for(i in 1:n){
    sum=sum+((x[i]-xbar)*(y[i]-ybar))
  }
  kov=sum/n
  return(kov)
}

korelasi<-function(x,y){
  xbar<-mean(x)
  ybar<-mean(y)
  n<-length(x)
  atas=0
  bawah_1=0
  bawah_2=0
  for(i in 1:n){
    atas=atas+((x[i]-xbar)*(y[i]-ybar))
    bawah_1=bawah_1+(x[i]-xbar)^2
    bawah_2=bawah_2+(y[i]-ybar)^2
  }
  bawah_1_final=sqrt(bawah_1)
  bawah_2_final=sqrt(bawah_2)
  kor=atas/(bawah_1_final*bawah_2_final)
  return(kor)
}

median<-function(x){
  n<-length(x)
  if(n%%2==0){
    med=x[n/2]+x[(n+2)/2]
  }
  if(n%%2!=0){
    med=x[(n+1)/2]
  }
  return(med)
}

modus<-function(x){
  uniq_val<-unique(x)
  uniq_val[which.max(tabulate(match(x,uniq_val)))]
}

med_x<-median(df$Weekly_Sales)
med_x

med_y<-median(df$Temperature)
med_y

std_x<-stadev(df$Weekly_Sales)
std_x

std_y<-stadev(df$Temperature)
std_y

var_x<-varians(df$Weekly_Sales)
var_x

var_y<-varians(df$Temperature)
var_y

kov_xy<-kovarians(df$Weekly_Sales,df$Temperature)
kov_xy

kor_xy<-korelasi(df$Weekly_Sales,df$Temperature)
kor_xy

mod_x<-modus(df$Weekly_Sales)
mod_x

mod_y<-modus(df$Temperature)
mod_y

hasil_statdes<-data.frame(
  varians_x=var_x,
  varians_y=var_y,
  kovarians=kov_xy,
  korelasi=kor_xy,
  standard_deviation_x=std_x,
  standard_deviation_y=std_y,
  median_x=med_x,
  median_y=med_y,
  modus_x=mod_x,
  modus_y=mod_y
)
hasil_statdes

