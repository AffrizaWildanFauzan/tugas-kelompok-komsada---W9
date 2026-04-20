#load data
data <- read.csv("dataset_walmart.csv")
head(data)

#DATA CLEANING
#cek NA, duplikat baris, dan outlier
colSums(is.na(data)) 
sum(duplicated(data)) 
summary(data$Weekly_Sales) 

#cleaning
#hapus baris duplikat
data <- data[!duplicated(data), ]

#buang sales minus (retur)
data <- data[data$Weekly_Sales >= 0, ]

#isi NA diskon pake 0
data$MarkDown1[is.na(data$MarkDown1)] <- 0
data$MarkDown2[is.na(data$MarkDown2)] <- 0
data$MarkDown3[is.na(data$MarkDown3)] <- 0
data$MarkDown4[is.na(data$MarkDown4)] <- 0
data$MarkDown5[is.na(data$MarkDown5)] <- 0

#DATA TRANSFORMATION
#cek tipe & skala data
str(data) 
summary(data[c("Weekly_Sales", "Temperature", "CPI")])

#transformasi
#ubah character ke date
data$Date <- as.Date(data$Date, format = "%Y-%m-%d")
#ubah character ke factor
data$Type <- as.factor(data$Type)

#DATA REDUCTION
#cek apakah isi kolom IsHoliday.x dan y sama
all(data$IsHoliday.x == data$IsHoliday.y)

#reduksi
#buang kolom sisa merge
data$IsHoliday.y <- NULL
#benerin nama
names(data)[names(data) == "IsHoliday.x"] <- "IsHoliday"

#ENCODING
#Encode IsHoliday 
data$IsHoliday_Num <- as.numeric(data$IsHoliday)

#Dummy Encoding kolom Type
dummies <- model.matrix(~Type-1, data=data)

#Gabungkan dengan dataset 
data <- cbind(data, dummies[, c("TypeA", "TypeB")])

# save hasil akhir
write.csv(data, "walmart_cleaning.csv", row.names = FALSE)

