def read_file(file_name):
    input_data_file = open(file_name, 'r')
    input_data = ''.join(input_data_file.readlines())
    input_data_file.close()
    return input_data #returns input data
    
    
inputfile = ['train_model.txt', 'test_model.txt']
outputfile = ['train.txt', 'test.txt']
for k in range(len(inputfile)):
    lines = read_file(inputfile[k]).split('\n')
    features = lines[0].split()
    f = open(outputfile[k],'w')        
    for i in range(1,len(lines)-1): 
        parts=lines[i].split()
        string = str(parts[0])+" '"+str(parts[1])+' | '
        for j in range(2,len(parts)): 
            string = string+str(features[j])+' : '+parts[j]+' '
        string = string+'\n'
        f.write(string)



