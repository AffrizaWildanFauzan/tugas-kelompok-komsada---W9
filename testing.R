library(dplyr)

data(iris)
df<-iris
head(iris)

set.seed(1)

#membuat missing values
df$Sepal.Length[sample(1:nrow(df),5)]<-NA
df$Petal.Width[sample(1:nrow(df),3)]<-NA

#mengecek missing value
#colSums=menjumlahkan seluruh kelas yang ditarget
colSums(is.na(df))
df

#menghapus missing values sautu df
df_clean<-na.omit(df)
df_clean

#kalau missing values terlalu banyak, maka diimputasi
df$Sepal.Length[is.na(df$Sepal.Length)]<-mean(df$Sepal.Length,na.rm=TRUE)
df$Petal.Width[is.na(df$Petal.Width)]<-median(df$Petal.Width,na.rm=TRUE)

#data duplikat
df<-rbind(df,df[1:3,])
#sum duplikat
sum(duplicated(df))

#hapus duplikat
df<-df[!duplicated(df), ]
# atau
df<-distinct(df)

#visualisasi outlier
boxplot(df$Sepal.Length)

#deteksi outlier
Q1<-quantile(df$Sepal.Length,0.25)
Q3<-quantile(df$Sepal.Length,0.75)
IQR_value<-Q3-Q1
lower<-Q1-1.5*IQR_value
upper<-Q3+1.5*IQR_value
outlier<-df$Sepal.Length<lower|df$Sepal.Length>upper
sum(outlier)

#menghapus outlier
df<-df[!outlier,]

#inkosistensi data
df$Species<-as.character(df$Species)
df$Species[1]<-"setosa"
df$Species[2]<-"SETOSA"

#memperbaiki inkonsistensi data
df$Species<-tolower(df$Species)
#atau
df$Species<-as.factor(df$Species)

#scaling
#normalisasi
df_scaled<-df
df_scaled[,1:4]<-scale(df[,1:4])
head(df_scaled)
#min-max scalling
minmax<-function(x){
  (x-min(x))/ (max(x)-min(x))
}
df_minmax<-df
df_minmax[,1:4]<-apply(df[,1:4],2,minmax)

#menganggap sebagai numerik
df$Species_num<-as.numeric(df$Species)
head(df)
#one hot encoding
dummies<-model.matrix(~Species-1,data=df)
head(dummies)

#merge dataset
df_encoded<-cbind(df[,1:4],dummies)
head(df_encoded)

#korelasi
cor_matrix<-cor(df[,1:4])
print(cor_matrix)

#
library(corrplot)
corrplot::corrplot(cor_matrix)

#pca
pca_model<-prcomp(df[,1:4],scale=TRUE)
summary(pca_model)

#lihat principal component
pca_model$x[1:10,]

#visualisasi pca
plot(pca_model$x[,1],pca_model$x[,2],
     col=df$Species,
     pch=19,
     xlab="PC1",
     ylab="PC2")

#mengubah label numerik mjd kategorik
df$Sepal_Length_cat<-cut(
  df$Sepal.Length,
  breaks=3,
  labels=c("Low","Medium","High")
)
head(df)
df

library(usethis)
use_git_config(user.name = "affrizafauzan", user.email = "affriza05@gmail.com")

usethis::create_github_token()
gitcreds::gitcreds_set()
