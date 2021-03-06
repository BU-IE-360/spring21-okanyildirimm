install.packages("plotly")
library(ggplot2)
library(plotly)
library(lubridate)
library(forecast)
library(data.table)

data1 = read.csv("ProjectRawData.csv", header = TRUE)

head(data1)
head(data)
datanew <- data1[,c(3,1,2,4,5,7,6,8,12,9,13,10,11)]
head(datanew)
head(data)
class(datanew$event_date)
datanew$event_date <- as.Date(datanew$event_date)

data = data[order(data$event_date),]
data = tail(data, -270)


head(datanew)
head(datanew,50)
tail(datanew,5)

datanew = datanew[order(datanew$event_date),]
head(datanew)
tail(datanew,50)
datanew = rbind(datanew, data)

set.seed(0)
split_list = split(datanew, datanew$product_content_id)

data_y�ztemizleyici = split_list[[9]]
data_�slakmendil = split_list[[4]] 
data_kulakl�k = split_list[[6]]
data_s�p�rge = split_list[[7]]
data_tayt = split_list[[1]]
data_bikini2 = split_list[[8]]
data_f�r�a = split_list[[3]]
data_mont = split_list[[5]]
data_bikini1 = split_list[[2]]

## Y�Z TEM�ZLEY�C�

ggplotly(ggplot(data_y�ztemizleyici, aes(x=event_date,y=sold_count)) + geom_line())
data_y�ztemizleyici = data.table(data_y�ztemizleyici)

data_y�ztemizleyici = tail(data_y�ztemizleyici, -250)

data_y�ztemizleyici[,trend:=1:.N]


data_y�ztemizleyici[event_date=="2020-08-18" | event_date=="2020-08-19" | event_date=="2020-08-20", is_discount:= 1]
data_y�ztemizleyici[event_date=="2020-09-08" | event_date=="2020-09-09" | event_date=="2020-09-10", is_discount:= 1]
data_y�ztemizleyici[event_date=="2020-10-06" | event_date=="2020-10-07" | event_date=="2020-10-08", is_discount:= 1]
data_y�ztemizleyici[event_date=="2020-11-09" | event_date=="2020-11-10" | event_date=="2020-11-11" | event_date=="2020-11-12", is_discount:= 1]
data_y�ztemizleyici[event_date=="2020-11-25" | event_date=="2020-11-26" | event_date=="2020-11-27", is_discount:= 1]
data_y�ztemizleyici[event_date=="2020-12-21" | event_date=="2020-11-22" | event_date=="2020-11-23", is_discount:= 1]
data_y�ztemizleyici[event_date=="2021-01-12" | event_date=="2021-01-13" | event_date=="2021-01-14", is_discount:= 1]
data_y�ztemizleyici[event_date=="2021-02-02" | event_date=="2021-02-03" | event_date=="2021-02-04", is_discount:= 1]
data_y�ztemizleyici[event_date=="2021-03-09" | event_date=="2021-03-10" | event_date=="2021-03-11", is_discount:= 1]
data_y�ztemizleyici[event_date=="2021-04-05" | event_date=="2021-04-06" | event_date=="2021-04-07", is_discount:= 1]
data_y�ztemizleyici[event_date=="2021-04-27" | event_date=="2021-04-28" | event_date=="2021-04-29", is_discount:= 1]
data_y�ztemizleyici[event_date=="2021-05-07" | event_date=="2021-05-08" | event_date=="2021-05-09", is_discount:= 1]
data_y�ztemizleyici[event_date=="2021-05-13" | event_date=="2021-05-14" | event_date=="2021-05-15", is_discount:= 1]
data_y�ztemizleyici[is.na(is_discount)==T,is_discount:=0]


temizleyici_reg_discount = lm(sold_count~price+visit_count+basket_count+category_sold+category_visits+category_brand_sold+category_favored+as.factor(is_discount), data_y�ztemizleyici)
summary(temizleyici_reg_discount)
checkresiduals(temizleyici_reg_discount)

temizleyici_reg_discount2 = lm(sold_count~price+visit_count+basket_count+category_sold+category_visits+category_favored+as.factor(is_discount), data_y�ztemizleyici)
summary(temizleyici_reg_discount2)
checkresiduals(temizleyici_reg_discount2)


temizleyici_reg_discount3 = lm(sold_count~price+basket_count+as.factor(is_discount), data_y�ztemizleyici)
summary(temizleyici_reg_discount3)
checkresiduals(temizleyici_reg_discount3)


predictions1 = predict(temizleyici_reg_discount3,data_y�ztemizleyici)
data_y�ztemizleyici = data_y�ztemizleyici[, predictions:=predictions1]
ggplotly(ggplot(data_y�ztemizleyici ,aes(x=event_date)) +
  geom_line(aes(y=sold_count,color='real')) +
  geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions

nextday_y�ztemizleyici_price = mean(tail(data_y�ztemizleyici$price,5))
nextday_y�ztemizleyici_basket = mean(tail(data_y�ztemizleyici$basket_count,5))

data_y�ztemizleyici=rbind(data_y�ztemizleyici,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_y�ztemizleyici[event_date=="2021-06-25", is_discount:=0]
data_y�ztemizleyici[event_date=="2021-06-25", price := nextday_y�ztemizleyici_price]
data_y�ztemizleyici[event_date=="2021-06-25", basket_count:= nextday_y�ztemizleyici_basket]

predictions1 = predict(temizleyici_reg_discount3,data_y�ztemizleyici)
data_y�ztemizleyici = data_y�ztemizleyici[, predictions:=predictions1]
ggplotly(ggplot(data_y�ztemizleyici ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))
predictions1


## ISLAK MEND�L 

ggplotly(ggplot(data_�slakmendil, aes(x=event_date,y=sold_count)) + geom_line())
data_�slakmendil = data.table(data_�slakmendil)

data_�slakmendil = tail(data_�slakmendil, -250)

data_�slakmendil[event_date=="2020-08-18" | event_date=="2020-08-19" | event_date=="2020-08-20", is_discount:= 1]
data_�slakmendil[event_date=="2020-09-08" | event_date=="2020-09-09" | event_date=="2020-09-10", is_discount:= 1]
data_�slakmendil[event_date=="2020-10-06" | event_date=="2020-10-07" | event_date=="2020-10-08", is_discount:= 1]
data_�slakmendil[event_date=="2020-11-09" | event_date=="2020-11-10" | event_date=="2020-11-11" | event_date=="2020-11-12", is_discount:= 1]
data_�slakmendil[event_date=="2020-11-25" | event_date=="2020-11-26" | event_date=="2020-11-27", is_discount:= 1]
data_�slakmendil[event_date=="2020-12-21" | event_date=="2020-11-22" | event_date=="2020-11-23", is_discount:= 1]
data_�slakmendil[event_date=="2021-02-02" | event_date=="2021-02-03" | event_date=="2021-02-04", is_discount:= 1]
data_�slakmendil[event_date=="2021-03-09" | event_date=="2021-03-10" | event_date=="2021-03-11", is_discount:= 1]
data_�slakmendil[event_date=="2021-04-05" | event_date=="2021-04-06" | event_date=="2021-04-07", is_discount:= 1]
data_�slakmendil[event_date=="2021-04-27" | event_date=="2021-04-28" | event_date=="2021-04-29", is_discount:= 1]
data_�slakmendil[event_date=="2021-05-07" | event_date=="2021-05-08" | event_date=="2021-05-09", is_discount:= 1]
data_�slakmendil[is.na(is_discount)==T,is_discount:=0]

�slakmendil_lm = lm(sold_count~.,data_�slakmendil)
summary(�slakmendil_lm)

�slakmendil_lm2 = lm(sold_count~price+favored_count+basket_count+category_sold+category_visits+category_favored+as.factor(is_discount), data_�slakmendil)
summary(�slakmendil_lm2)

�slakmendil_lm3 = lm(sold_count~basket_count+category_sold+category_visits+category_favored+as.factor(is_discount), data_�slakmendil)
summary(�slakmendil_lm3)
checkresiduals(�slakmendil_lm3)

predictions2 = predict(�slakmendil_lm3,data_�slakmendil)
data_�slakmendil = data_�slakmendil[, predictions:=predictions2]
ggplotly(ggplot(data_�slakmendil ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions

nextday_�slakmendil_basket = mean(tail(data_�slakmendil$basket_count,5))
nextday_�slakmendil_catsold = mean(tail(data_�slakmendil$category_sold,5))
nextday_�slakmendil_catvis = mean(tail(data_�slakmendil$category_visits,5))
nextday_�slakmendil_catfav = mean(tail(data_�slakmendil$category_favored,5))


data_�slakmendil=rbind(data_�slakmendil,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_�slakmendil[event_date=="2021-06-25", is_discount:=0]
data_�slakmendil[event_date=="2021-06-25", basket_count := nextday_�slakmendil_basket]
data_�slakmendil[event_date=="2021-06-25", category_sold := nextday_�slakmendil_catsold]
data_�slakmendil[event_date=="2021-06-25", category_visits := nextday_�slakmendil_catvis]
data_�slakmendil[event_date=="2021-06-25", category_favored := nextday_�slakmendil_catfav]

predictions2 = predict(�slakmendil_lm3,data_�slakmendil)
data_�slakmendil = data_�slakmendil[, predictions:=predictions2]
ggplotly(ggplot(data_�slakmendil ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))


## KULAKLIK

ggplotly(ggplot(data_kulakl�k, aes(x=event_date,y=sold_count)) + geom_line())
data_kulakl�k = data.table(data_kulakl�k)

data_kulakl�k = tail(data_kulakl�k, -250)

data_kulakl�k[event_date=="2020-08-18" | event_date=="2020-08-19" | event_date=="2020-08-20", is_discount:= 1]
data_kulakl�k[event_date=="2020-09-08" | event_date=="2020-09-09" | event_date=="2020-09-10", is_discount:= 1]
data_kulakl�k[event_date=="2020-10-06" | event_date=="2020-10-07" | event_date=="2020-10-08", is_discount:= 1]
data_kulakl�k[event_date=="2020-11-09" | event_date=="2020-11-10" | event_date=="2020-11-11" | event_date=="2020-11-12", is_discount:= 1]
data_kulakl�k[event_date=="2020-11-25" | event_date=="2020-11-26" | event_date=="2020-11-27", is_discount:= 1]
data_kulakl�k[event_date=="2020-12-21" | event_date=="2020-11-22" | event_date=="2020-11-23", is_discount:= 1]
data_kulakl�k[event_date=="2021-01-12" | event_date=="2021-01-13" | event_date=="2021-01-14", is_discount:= 1]
data_kulakl�k[event_date=="2021-02-02" | event_date=="2021-02-03" | event_date=="2021-02-04", is_discount:= 1]
data_kulakl�k[event_date=="2021-03-09" | event_date=="2021-03-10" | event_date=="2021-03-11", is_discount:= 1]
data_kulakl�k[event_date=="2021-04-05" | event_date=="2021-04-06" | event_date=="2021-04-07", is_discount:= 1]
data_kulakl�k[event_date=="2021-04-27" | event_date=="2021-04-28" | event_date=="2021-04-29", is_discount:= 1]
data_kulakl�k[event_date=="2021-05-07" | event_date=="2021-05-08" | event_date=="2021-05-09", is_discount:= 1]
data_kulakl�k[event_date=="2021-05-13" | event_date=="2021-05-14" | event_date=="2021-05-15", is_discount:= 1]
data_kulakl�k[is.na(is_discount)==T,is_discount:=0]

kulakl�k_lm = lm(sold_count~., data_kulakl�k)
summary(kulakl�k_lm)

kulakl�k_lm2 = lm(sold_count~price+visit_count+basket_count+category_sold+category_visits+as.factor(is_discount), data_kulakl�k)
summary(kulakl�k_lm2)

kulakl�k_lm3 = lm(sold_count~visit_count+basket_count+category_sold+category_visits+as.factor(is_discount), data_kulakl�k)
summary(kulakl�k_lm3)

kulakl�k_nointercept = lm(sold_count~-1+visit_count+basket_count+category_sold+category_visits+as.factor(is_discount), data_kulakl�k)
summary(kulakl�k_nointercept)
checkresiduals(kulakl�k_nointercept)

predictions3 = predict(kulakl�k_nointercept,data_kulakl�k)
data_kulakl�k = data_kulakl�k[, predictions:=predictions3]
ggplotly(ggplot(data_kulakl�k ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions

nextday_kulakl�k_visit = mean(tail(data_kulakl�k$visit_count,5))
nextday_kulakl�k_basket = mean(tail(data_kulakl�k$basket_count,5))
nextday_kulakl�k_catsold = mean(tail(data_kulakl�k$category_sold,5))
nextday_kulakl�k_catvis = mean(tail(data_kulakl�k$category_visits,5))

data_kulakl�k=rbind(data_kulakl�k,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_kulakl�k[event_date=="2021-06-25", is_discount:=0]
data_kulakl�k[event_date=="2021-06-25", visit_count := nextday_kulakl�k_visit]
data_kulakl�k[event_date=="2021-06-25", basket_count := nextday_kulakl�k_basket]
data_kulakl�k[event_date=="2021-06-25", category_sold := nextday_kulakl�k_catsold]
data_kulakl�k[event_date=="2021-06-25", category_visits := nextday_kulakl�k_catvis]

predictions3 = predict(kulakl�k_nointercept,data_kulakl�k)
data_kulakl�k = data_kulakl�k[, predictions:=predictions3]
ggplotly(ggplot(data_kulakl�k ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))


## S�P�RGE

ggplotly(ggplot(data_s�p�rge, aes(x=event_date,y=sold_count)) + geom_line())
data_s�p�rge = data.table(data_s�p�rge)

data_s�p�rge = tail(data_s�p�rge, -250)

s�p�rge_lm = lm(sold_count~., data_s�p�rge)
summary(s�p�rge_lm)

s�p�rge_lm2 = lm(sold_count~favored_count+basket_count+category_sold+category_visits+ty_visits, data_s�p�rge)
summary(s�p�rge_lm2)
checkresiduals(s�p�rge_lm2)

s�p�rge_lm3 = lm(sold_count~-1+favored_count+basket_count+category_sold+category_visits+ty_visits, data_s�p�rge)
summary(s�p�rge_lm3)
checkresiduals(s�p�rge_lm3)

predictions4 = predict(s�p�rge_lm3,data_s�p�rge)
data_s�p�rge = data_s�p�rge[, predictions:=predictions4]
ggplotly(ggplot(data_s�p�rge ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions 

nextday_s�p�rge_favcount = mean(tail(data_s�p�rge$favored_count,5))
nextday_s�p�rge_basket = mean(tail(data_s�p�rge$basket_count,5))
nextday_s�p�rge_catsold = mean(tail(data_s�p�rge$category_sold,5))
nextday_s�p�rge_catvis = mean(tail(data_s�p�rge$category_visits,5))
nextday_s�p�rge_tyvis = mean(tail(data_s�p�rge$ty_visits,5))

data_s�p�rge=rbind(data_s�p�rge,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_s�p�rge[event_date=="2021-06-25", favored_count := nextday_s�p�rge_favcount]
data_s�p�rge[event_date=="2021-06-25", basket_count := nextday_s�p�rge_basket]
data_s�p�rge[event_date=="2021-06-25", category_sold := nextday_s�p�rge_catsold]
data_s�p�rge[event_date=="2021-06-25", category_visits := nextday_s�p�rge_catvis]
data_s�p�rge[event_date=="2021-06-25", ty_visits := nextday_s�p�rge_tyvis]

predictions4 = predict(s�p�rge_lm3,data_s�p�rge)
data_s�p�rge = data_s�p�rge[, predictions:=predictions4]
ggplotly(ggplot(data_s�p�rge ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

## TAYT

ggplotly(ggplot(data_tayt, aes(x=event_date,y=sold_count)) + geom_line())
data_tayt = data.table(data_tayt)

data_tayt = tail(data_tayt, -250)

data_tayt[event_date=="2021-02-02" | event_date=="2021-02-03" | event_date=="2021-02-04", is_discount:= 1]
data_tayt[event_date=="2021-03-09" | event_date=="2021-03-10" | event_date=="2021-03-11", is_discount:= 1]
data_tayt[event_date=="2021-04-05" | event_date=="2021-04-06" | event_date=="2021-04-07", is_discount:= 1]
data_tayt[event_date=="2021-04-27" | event_date=="2021-04-28" | event_date=="2021-04-29", is_discount:= 1]
data_tayt[is.na(is_discount)==T,is_discount:=0]

tayt_lm = lm(sold_count~.,data_tayt)
summary(tayt_lm)

tayt_lm2 = lm(sold_count~price+visit_count+basket_count+category_sold+category_visits+as.factor(is_discount), data_tayt)
summary(tayt_lm2)
checkresiduals(tayt_lm2)

predictions5 = predict(tayt_lm2,data_tayt)
data_tayt = data_tayt[, predictions:=predictions5]
ggplotly(ggplot(data_tayt ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions

nextday_tayt_price = mean(tail(data_tayt$price,5))
nextday_tayt_viscount = mean(tail(data_tayt$visit_count,5))
nextday_tayt_basket = mean(tail(data_tayt$basket_count,5))
nextday_tayt_catsold = mean(tail(data_tayt$category_sold,5))
nextday_tayt_catvis = mean(tail(data_tayt$category_visits,5))

data_tayt=rbind(data_tayt,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_tayt[event_date=="2021-06-25", is_discount:=0]
data_tayt[event_date=="2021-06-25", price := nextday_tayt_price]
data_tayt[event_date=="2021-06-25", visit_count := nextday_tayt_viscount]
data_tayt[event_date=="2021-06-25", basket_count := nextday_tayt_basket]
data_tayt[event_date=="2021-06-25", category_sold := nextday_tayt_catsold]
data_tayt[event_date=="2021-06-25", category_visits := nextday_tayt_catvis]

predictions5 = predict(tayt_lm2,data_tayt)
data_tayt = data_tayt[, predictions:=predictions5]
ggplotly(ggplot(data_tayt ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

## FIR�A 

ggplotly(ggplot(data_f�r�a, aes(x=event_date,y=sold_count)) + geom_line())
data_f�r�a = data.table(data_f�r�a)

data_f�r�a = tail(data_f�r�a, -250)

data_f�r�a[event_date=="2020-08-18" | event_date=="2020-08-19" | event_date=="2020-08-20", is_discount:= 1]
data_f�r�a[event_date=="2020-09-08" | event_date=="2020-09-09" | event_date=="2020-09-10", is_discount:= 1]
data_f�r�a[event_date=="2020-10-06" | event_date=="2020-10-07" | event_date=="2020-10-08", is_discount:= 1]
data_f�r�a[event_date=="2020-11-09" | event_date=="2020-11-10" | event_date=="2020-11-11" | event_date=="2020-11-12", is_discount:= 1]
data_f�r�a[event_date=="2020-11-25" | event_date=="2020-11-26" | event_date=="2020-11-27", is_discount:= 1]
data_f�r�a[event_date=="2020-12-21" | event_date=="2020-11-22" | event_date=="2020-11-23", is_discount:= 1]
data_f�r�a[event_date=="2021-01-12" | event_date=="2021-01-13" | event_date=="2021-01-14", is_discount:= 1]
data_f�r�a[event_date=="2021-02-02" | event_date=="2021-02-03" | event_date=="2021-02-04", is_discount:= 1]
data_f�r�a[event_date=="2021-03-09" | event_date=="2021-03-10" | event_date=="2021-03-11", is_discount:= 1]
data_f�r�a[event_date=="2021-04-05" | event_date=="2021-04-06" | event_date=="2021-04-07", is_discount:= 1]
data_f�r�a[event_date=="2021-04-27" | event_date=="2021-04-28" | event_date=="2021-04-29", is_discount:= 1]
data_f�r�a[event_date=="2021-05-07" | event_date=="2021-05-08" | event_date=="2021-05-09", is_discount:= 1]
data_f�r�a[event_date=="2021-05-13" | event_date=="2021-05-14" | event_date=="2021-05-15", is_discount:= 1]
data_f�r�a[is.na(is_discount)==T,is_discount:=0]

f�r�a_lm = lm(sold_count~., data_f�r�a)
summary(f�r�a_lm)

f�r�a_lm2 = lm(sold_count~price+visit_count+favored_count+basket_count+category_visits+ty_visits+as.factor(is_discount),data_f�r�a)
summary(f�r�a_lm2)

f�r�a_lm3 = lm(sold_count~price+visit_count+favored_count+basket_count+ty_visits+as.factor(is_discount),data_f�r�a)
summary(f�r�a_lm3)
checkresiduals(f�r�a_lm3)

predictions6 = predict(f�r�a_lm3,data_f�r�a)
data_f�r�a = data_f�r�a[, predictions:=predictions6]
ggplotly(ggplot(data_f�r�a ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions

nextday_f�r�a_price = mean(tail(data_f�r�a$price,5))
nextday_f�r�a_viscount = mean(tail(data_f�r�a$visit_count,5))
nextday_f�r�a_favcount = mean(tail(data_f�r�a$favored_count,5))
nextday_f�r�a_basket = mean(tail(data_f�r�a$basket_count,5))
nextday_f�r�a_tyvis = mean(tail(data_f�r�a$ty_visits,5))

data_f�r�a=rbind(data_f�r�a,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_f�r�a[event_date=="2021-06-25", is_discount:=0]
data_f�r�a[event_date=="2021-06-25", price := nextday_f�r�a_price]
data_f�r�a[event_date=="2021-06-25", visit_count := nextday_f�r�a_viscount]
data_f�r�a[event_date=="2021-06-25", favored_count := nextday_f�r�a_favcount]
data_f�r�a[event_date=="2021-06-25", basket_count := nextday_f�r�a_basket]
data_f�r�a[event_date=="2021-06-25", ty_visits := nextday_f�r�a_tyvis]

predictions6 = predict(f�r�a_lm3,data_f�r�a)
data_f�r�a = data_f�r�a[, predictions:=predictions6]
ggplotly(ggplot(data_f�r�a ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

## B�K�N� �ST� 1 

ggplotly(ggplot(data_bikini1, aes(x=event_date,y=sold_count)) + geom_line())
data_bikini1 = data.table(data_bikini1)

data_bikini1 = tail(data_bikini1, -271)

data_bikini1[event_date=="2021-03-09" | event_date=="2021-03-10" | event_date=="2021-03-11", is_discount:= 1]
data_bikini1[event_date=="2021-04-05" | event_date=="2021-04-06" | event_date=="2021-04-07", is_discount:= 1]
data_bikini1[event_date=="2021-04-27" | event_date=="2021-04-28" | event_date=="2021-04-29", is_discount:= 1]
data_bikini1[event_date=="2021-05-07" | event_date=="2021-05-08" | event_date=="2021-05-09", is_discount:= 1]
data_bikini1[event_date=="2021-05-13" | event_date=="2021-05-14" | event_date=="2021-05-15", is_discount:= 1]
data_bikini1[is.na(is_discount)==T,is_discount:=0]

bikini1_lm = lm(sold_count~., data_bikini1)
summary(bikini1_lm)

bikini1_lm2 = lm(sold_count~visit_count+basket_count+category_sold+as.factor(is_discount), data_bikini1)
summary(bikini1_lm2)

bikini1_lm3 = lm(sold_count~-1+basket_count+category_sold+as.factor(is_discount),data_bikini1)
summary(bikini1_lm3)
checkresiduals(bikini1_lm3)

predictions7 = predict(bikini1_lm3,data_bikini1)
data_bikini1 = data_bikini1[, predictions:=predictions7]
ggplotly(ggplot(data_bikini1 ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions 

nextday_bikini1_basket = mean(tail(data_bikini1$basket_count,5))
nextday_bikini1_catsold = mean(tail(data_bikini1$category_sold,5))

data_bikini1=rbind(data_bikini1,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_bikini1[event_date=="2021-06-25", is_discount:=0]
data_bikini1[event_date=="2021-06-25", basket_count := nextday_bikini1_basket]
data_bikini1[event_date=="2021-06-25", category_sold := nextday_bikini1_catsold]

predictions7 = predict(bikini1_lm3,data_bikini1)
data_bikini1 = data_bikini1[, predictions:=predictions7]
ggplotly(ggplot(data_bikini1 ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

## MONT 

ggplotly(ggplot(data_mont, aes(x=event_date,y=sold_count)) + geom_line())
data_mont = data.table(data_mont)

data_mont = tail(data_mont, -349)

data_mont = data_mont[is.na(price)==1, price:=299.990]

data_mont[event_date=="2021-05-07" | event_date=="2021-05-08" | event_date=="2021-05-09", is_discount:= 1]
data_mont[is.na(is_discount)==T,is_discount:=0]

mont_lm = lm(sold_count~.,data_mont)
summary(mont_lm)

mont_lm2 = lm(sold_count~favored_count+as.factor(is_discount),data_mont)
summary(mont_lm2)
checkresiduals(mont_lm2)

predictions8 = predict(mont_lm2,data_mont)
data_mont = data_mont[, predictions:=predictions8]
ggplotly(ggplot(data_mont ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

## Daily Predictions

nextday_mont_favcount = mean(tail(data_mont$favored_count,5))

data_mont=rbind(data_mont,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_mont[event_date=="2021-06-25", is_discount:=0]
data_mont[event_date=="2021-06-25", favored_count := nextday_mont_favcount]

predictions8 = predict(mont_lm2,data_mont)
data_mont = data_mont[, predictions:=predictions8]
ggplotly(ggplot(data_mont ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

## B�K�N� �ST� 2

ggplotly(ggplot(data_bikini2, aes(x=event_date,y=sold_count)) + geom_line())
data_bikini2 = data.table(data_bikini2)

data_bikini2 = tail(data_bikini2, -338)

data_bikini2[event_date=="2021-05-07" | event_date=="2021-05-08" | event_date=="2021-05-09", is_discount:= 1]
data_bikini2[event_date=="2021-05-13" | event_date=="2021-05-14" | event_date=="2021-05-15", is_discount:= 1]
data_bikini2[is.na(is_discount)==T,is_discount:=0]

bikini2_lm = lm(sold_count~.,data_bikini2)
summary(bikini2_lm)

bikini2_lm2 = lm(sold_count~basket_count+category_sold+as.factor(is_discount), data_bikini2)
summary(bikini2_lm2)

bikini2_lm3 = lm(sold_count~basket_count+as.factor(is_discount), data_bikini2)
summary(bikini2_lm3)
checkresiduals(bikini2_lm3)

predictions9 = predict(bikini2_lm3,data_bikini2)
data_bikini2 = data_bikini2[, predictions:=predictions9]
ggplotly(ggplot(data_bikini2 ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))

# Daily Predictions

nextday_bikini2_basket = mean(tail(data_bikini2$basket_count,5))
nextday_bikini2_catsold = mean(tail(data_bikini2$category_sold,5))

data_bikini2=rbind(data_bikini2,data.table(event_date=as.Date("2021-06-25")),fill=T)
data_bikini2[event_date=="2021-06-25", is_discount:=0]
data_bikini2[event_date=="2021-06-25", basket_count := nextday_bikini2_basket]
data_bikini2[event_date=="2021-06-25", category_sold := nextday_bikini2_catsold]

predictions9 = predict(bikini2_lm3,data_bikini2)
data_bikini2 = data_bikini2[, predictions:=predictions9]
ggplotly(ggplot(data_bikini2 ,aes(x=event_date)) +
           geom_line(aes(y=sold_count,color='real')) +
           geom_line(aes(y=predictions,color='predictions')))