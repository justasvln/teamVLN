teamVLN
=======

Kaggle competition http://www.kaggle.com/c/acquire-valued-shoppers-challenge

Description 

Predict which shoppers will become repeat buyers. 

Files 

loadData.R - from general data generates two data.tables having names train and test. 

features.R - from tables train and test removes features that are not necesary and calls function train_test_wp(train, test). 

trainVW.R - loads function train_test_vw(). This function remakes train and test tables in a format that is necesary for vowpal 
wabbit. Next it calls vw and generates an answer file submit.csv.

vw.py - converts tables train and test into the format necesary for vw. 

test.R - file that helps to try different feature sets without ruing above files. 


