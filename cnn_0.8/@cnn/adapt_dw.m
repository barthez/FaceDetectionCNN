function cnet = adapt_dw(cnet,dW)
%ADAPT_DW apply calculated weights and biases gradient 
%
%  Syntax
%  
%    cnet = adapt_dw(cnet,dW)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%    dW - delta weights and biases as a single vector
%   Output:
%    cnet - convolutional neural network with updated weights and biases
%
%(c) Sirotenko Mikhail, 2009

%Weight pointer in reverse order (1 means the bias of the last neuron of last layer)
wPtr = 1;
%==========First all F-layers
for k=cnet.numLayers:-1:(cnet.numLayers-cnet.numFLayers+1)
    %Calculate total number of weights for the layer
    sz = numel(cnet.FLayer{k}.W);
    %Update weights
    cnet.FLayer{k}.W = cnet.FLayer{k}.W-reshape(dW(wPtr:(wPtr+sz-1)),size(cnet.FLayer{k}.W));
    %Increment pointer
    wPtr = wPtr+sz;

    %Calculate total number of biases for the layer
    sz = numel(cnet.FLayer{k}.B);
    %Update biases
    cnet.FLayer{k}.B = cnet.FLayer{k}.B-dW(wPtr:(wPtr+sz-1))';
    %Increment pointer
    wPtr = wPtr+sz;
end


%Main loop
for k=(cnet.numLayers-cnet.numFLayers):-1:2 %(all except first layer, its dummy) 
    if(rem(k,2)) %Parity check
        %S-Layer
        %Calculate total number of weights for the layer
        sz = numel(cnet.SLayer{k}.WS)*numel(cnet.SLayer{k}.WS{1});
        %Size of feature map
        mW = cnet.SLayer{k}.FMapWidth;
        mH = cnet.SLayer{k}.FMapHeight;        
        %Updating weights
        %Initialize dimension vectors to convert to cell array
        vVert=ones(cnet.SLayer{k}.numFMaps,1)*mH;
        vHoriz = mW;  
        %Convert cell to matrix and update weights
        Wnew = cell2mat(cnet.SLayer{k}.WS') - reshape(dW(wPtr:(wPtr+sz-1)),cnet.SLayer{k}.numFMaps,[]);        
        %Convert back to cell array
        cnet.SLayer{k}.WS = num2cell(Wnew)';        
        %Increment pointer
        wPtr = wPtr+sz;

        %Calculate total number of biases for the layer
        sz = numel(cnet.SLayer{k}.BS)*numel(cnet.SLayer{k}.BS{1});
        %Size of feature map
        mW = cnet.SLayer{k}.FMapWidth;
        mH = cnet.SLayer{k}.FMapHeight;        
        %Updating biases
        %Initialize dimension vectors to convert to cell array
        vVert=ones(cnet.SLayer{k}.numFMaps,1)*mH;
        vHoriz = mW;
        %Convert cell to matrix and update weights
        Bnew = cell2mat(cnet.SLayer{k}.BS') - reshape(dW(wPtr:(wPtr+sz-1)),cnet.SLayer{k}.numFMaps,[]);        
        %Convert back to cell array
        cnet.SLayer{k}.BS = num2cell(Bnew)';
        %Increment pointer
        wPtr = wPtr+sz;
    else
    %C-Layer
        %Calculate total number of weights for the layer
        sz = numel(cnet.CLayer{k}.WC)*numel(cnet.CLayer{k}.WC{1});
        %Size of convolution kernel
        mW = cnet.CLayer{k}.KernWidth;
        mH = cnet.CLayer{k}.KernHeight;        
        %Updating weights
        %Initialize dimension vectors to convert to cell array
        vVert=ones(cnet.CLayer{k}.numKernels,1)*mH;
        vHoriz = mW;
        %Convert cell to matrix and update weights
        Wnew = cell2mat(cnet.CLayer{k}.WC) - reshape(dW(wPtr:(wPtr+sz-1)),[],mW*cnet.CLayer{k}.numKernels);        
        %Convert back to cell array
        cnet.CLayer{k}.WC = mat2cell(Wnew,vHoriz,vVert);
        %Increment pointer
        wPtr = wPtr+sz;

        %Calculate total number of biases for the layer
        sz = numel(cnet.CLayer{k}.BC)*numel(cnet.CLayer{k}.BC{1});
        %Updating biases
        %Convert cell to matrix and update weights
        Bnew = cell2mat(cnet.CLayer{k}.BC) - dW(wPtr:(wPtr+sz-1))';        
        %Convert back to cell array
        cnet.CLayer{k}.BC = num2cell(Bnew);
        %Increment pointer
        wPtr = wPtr+sz;

    end
end


end

