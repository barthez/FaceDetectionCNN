function mcr = cucalcMCR(I_testp,labels, idxs)
%calcMCR Calculate missclassification rate
%
%  Syntax
%  
%    mcr = calcMCR(cnet,It,labels, idxs)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%    It - cell array, containing preprocessed images of handwriten digits
%    labels - cell array of labels, corresponding to images
%    idxs - vector of indeces of elements to use for testing
%   Output:
%    mcr - missclassification rate
%
%(c) Sirotenko Mikhail, 2009
correct=0;
for i=idxs
    out = cudacnn('sim',single(I_testp{i}));    
    if(find(out==max(out))==(labels(i)+1))
        correct=correct+1;
    end
end
mcr = 1-correct/length(idxs);