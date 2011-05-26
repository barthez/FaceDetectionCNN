function sz = cnn_size(cnet)
%cnn_size Calculate the total number of all trainable parameters
%
%  Syntax
%  
%    sz = cnn_size(cnet)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%   Output:
%    sz - number of all trainable parameters 
%
%(c) Sirotenko Mikhail, 2009


sz = 0;
%Loop through the fully-connected layers
for k=cnet.numLayers:-1:(cnet.numLayers-cnet.numFLayers+1)
    sz = sz + numel(cnet.FLayer{k}.W)+numel(cnet.FLayer{k}.B);
end


%All other layers
for k=(cnet.numLayers-cnet.numFLayers):-1:2 %first layer is dummy
    if(rem(k,2)) %Parity check
        %Subsampling layer
        sz = sz + numel(cnet.SLayer{k}.WS)*numel(cnet.SLayer{k}.WS{1})+numel(cnet.SLayer{k}.BS)*numel(cnet.SLayer{k}.BS{1});
    else
        %Convolutional layer
        sz = sz + numel(cnet.CLayer{k}.WC)*numel(cnet.CLayer{k}.WC{1})+numel(cnet.CLayer{k}.BC)*numel(cnet.CLayer{k}.BC{1});
    end
end

end

