%Test convolutional network for classification quality
correct=0;
%Testing on 500 random test samples
numtest = 500;
[I_testp,labnew] = preproc_data(I_test,numtest,labels_test,0);
for t=1:numtest
    
    [out(t,:), sinet] = sim(sinet,I_testp{t});    
    if(find(out(t,:)==max(out(t,:)))==(labnew(t)+1))
        correct=correct+1;
    end
        


end
disp Number of correctly classified digits is 
correct/numtest