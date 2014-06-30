 setwd("/Users/justaskalpokas/HackatonTeamVLN/")
#clearing all elements from the memory
rm(list = ls())

#Loading libraries
library(data.table)
library(bit64)
library(verification)

#Loading tables 
#crafted data for training
train<-fread("train_features.csv")
test<-fread("test_features.csv")

#changing data type to date, since fread does not support date format
train[,offerdate:=as.Date(train[,offerdate])]
test[,offerdate:=as.Date(test[,offerdate])]

#changing data type 
train[,id:=as.numeric(train[,id])]
test[,id:=as.numeric(test[,id])]
#setting key
setkey(train, id)
setkey(test, id)

#Loading offers 
offers<-fread("offers.csv", colClasses = c("offer" = "integer", "category" = "integer", "quantity" = "integer", "company" = "numeric", "offervalue" = "numeric", "brand" = "integer"))
setkey(offers,offer)

#Loading training history tables
history<-fread("trainHistory.csv", colClasses=c("id"="numeric", "chain"="integer", "offer"="integer", "market"="integer", "repeattrips"="integer", "repeater"="character", "offerdate"="Date"))
history[,offerdate:=as.Date(offerdate)]
setkey(history, id)

#Loading testing history tables (this table does not have repeater and reppeattrips columns)
test_history<-fread("testHistory.csv", colClasses=c("id"="numeric", "chain"="integer", "offer"="integer", "market"="integer",  "offerdate"="Date"))
test_history[,offerdate:=as.Date(offerdate)]
setkey(test_history, id)




#adding offer column to train 
train<-merge(history[,list(id, offer)],train, by="id")

#rearanging train table (putting repeatre to the front)
col_idx <- grep("repeater", colnames(train))
setcolorder(train,c(col_idx, (1:ncol(train))[-col_idx]) )


#adding offer column to test table
test<-merge(test_history[,list(id, offer)],test, by="id")

#adding extra column repeater and rearanging the table
test[,repeater:=1]
test[(id %% 2) == 0,repeater:=0]
col_idx <- grep("repeater", colnames(test))
setcolorder(test,c(col_idx, (1:ncol(test))[-col_idx]) )




