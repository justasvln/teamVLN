peeled_train<-train[,c('quantity', 'chain', 'market', 'offerdate', 'category', 'company', 'brand', 'n_buyers', 'n_buys', 'e_q', 'price', 'offervalue'):=NULL]
peeled_test<-test[,c('quantity', 'chain', 'market', 'offerdate', 'category', 'company', 'brand', 'n_buyers', 'n_buys', 'e_q', 'price', 'offervalue'):=NULL]

#all offers that are in training set
unique_offers<-unique(peeled_train[,offer])



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


#all offers that are in testing set
test_unique_offers<-unique(peeled_test[,offer])



#writing down probabilities that repeater = 1 for each offer 
x<-peeled_test[,list(offer, repeater)]
x[,index:=1]
test_offer_prob<-data.table(test_unique_offers)
for (i in test_unique_offers){test_offer_prob[ test_unique_offers==i,probability:=x[offer == i ,sum(index[repeater==1]) ]/x[offer == i ,sum(index) ]]
	test_offer_prob[ test_unique_offers==i,all_id:=x[offer == i ,sum(index) ]]
	test_offer_prob[ test_unique_offers==i,proportion:=x[offer == i ,sum(index) ]/x[,sum(index) ]]
	test_offer_prob[ test_unique_offers==i,proportion_pos:=x[offer == i ,sum(index[repeater==1]) ]/x[repeater==1,sum(index) ]]
	}
setkey(test_offer_prob, all_id, probability)


train_model<-peeled_train[offer %in% offer_prob[21:24, unique_offers]] 
test_model<-peeled_test[offer %in% test_offer_prob[26:29, test_unique_offers]] 
train_test_vw(train_model, test_model)

