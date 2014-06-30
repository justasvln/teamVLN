train_test_vw<-function(train_model, test_model){
	#removing offer column 
	train_model[,offer:=NULL]
	test_model[,offer:=NULL]

	#writing tables into the files
	write.table(train_model, file="train_model.txt", sep = " ", row.names = F, quote = F)
	write.table(test_model, file="test_model.txt", sep = " ", row.names = F, quote = F)

	#using vw.py script to convert train_model and test_model files into the format that is suatable fro vw 
	#output is two files train.txt and test.txt 
	system("python vw.py")

	#Starting vw training with train.txt file, output is model.vw and this test test.txt file. The output is probs.txt file with probabilities for test 		repeater column. 
	system("vw train.txt -c -k --passes 40 -l 0.85 -f model.vw --loss_function quantile --quantile_tau 0.6", ignore.stderr = T, ignore.stdout = T)
	system("vw test.txt -t -i model.vw -p probs.txt", ignore.stderr = T, ignore.stdout = T)

	#reading probabilities
	probs<-data.table(read.table("probs.txt", sep= " ", col.names = c("repeatProbability", "id")))
	setkey(probs,id)


	probs<-probs[,list(id,repeatProbability)]
	write.table(probs, file="submit.csv", sep=",", row.names=F, quote = F)

	#calculating auc
	auc = roc.area(test_model[,repeater],probs[,repeatProbability])
	
	
	#returning auc 
	return(auc)
	}





