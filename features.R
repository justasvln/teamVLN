#loading function train_test_vw()
source("trainVW.R")

train_test_vw(train, test)


#all offers that are in training set
unique_offers<-unique(train[,offer])

#writing down probabilities that repeater = 1 for each offer 
x<-peeled_train[,list(offer, repeater)]
x[,index:=1]
offer_prob<-data.table(unique_offers)
for (i in unique_offers){offer_prob[ unique_offers==i,probability:=x[offer == i ,sum(index[repeater==1]) ]/x[offer == i ,sum(index) ]]
	offer_prob[ unique_offers==i,all_id:=x[offer == i ,sum(index) ]]
	offer_prob[ unique_offers==i,proportion:=x[offer == i ,sum(index) ]/x[,sum(index) ]]
	offer_prob[ unique_offers==i,proportion_pos:=x[offer == i ,sum(index[repeater==1]) ]/x[repeater==1,sum(index) ]]
	}
setkey(offer_prob, all_id, probability)


#TRAINING TABLE first 10 offers
#taking a subset of train table where the offers are the first 10 offers from unique_offers set



for (i in 1:1){
	a<-c(1:10)
	b<-sample(a,1)
	c<-c(1:20)
	train_offers<-sample(c,b)
	train_model<-peeled_train[offer %in% offer_prob[train_offers, unique_offers]] 


	#TESTING TABLE 11-14 offers 
	test_model<-peeled_train[offer %in% offer_prob[21:24, unique_offers]] 
    AUC<-train_test_vw(train_model, test_model)

	print(train_offers)
	print(AUC$A)
	test_model<-peeled_train[offer %in% offer_prob[1:24, unique_offers]] 
	AUC<-train_test_vw(train_model, test_model)
	print(AUC$A)
	print(i)
	}
	

