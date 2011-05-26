function [out, cnet] = sim(cnet,inp)

%SIM simulate convolutional neural network 
%
%  Syntax
%  
%    [out, sinet] = sim(cnet,inp)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%    inp - input image
%   Output:
%    cnet - Convolutional neural network with unchanged weignts and biases
%    but with saved layers outputs 
%    out - simulated neural network output
%
%(c) Sirotenko Mikhail, 2009

%Supposed that input image is preprocessed to zero mean and 1 deviation
%Subsampling
cnet.SLayer{1}.SS{1} = subsample(inp,cnet.SLayer{1}.SRate);
cnet.SLayer{1}.YS{1} = cnet.SLayer{1}.SS{1}.*cnet.SLayer{1}.WS{1}+cnet.SLayer{1}.BS{1} ;    
%Transfer (activation,sqashing) function 
cnet.SLayer{1}.XS{1} = feval(cnet.SLayer{1}.TransfFunc,cnet.SLayer{1}.YS{1});

%Main layer loop
for k=2:(cnet.numLayers-cnet.numFLayers) %(First layer is dummy, skip it)
    if(rem(k,2)) %Parity check
    %S-layer
        for l=1:cnet.CLayer{k-1}.numFMaps %For all feature maps from previous layer
            %Subsampling
            %Reshape output matrix to 1-D vector
            XC = reshape(cnet.CLayer{k-1}.XC,1,[]);
            cnet.SLayer{k}.SS{l} = subsample(XC{l},cnet.SLayer{k}.SRate);
            cnet.SLayer{k}.YS{l} = cnet.SLayer{k}.SS{l}*cnet.SLayer{k}.WS{l}+cnet.SLayer{k}.BS{l} ;    
            %Apply transfer function
            cnet.SLayer{k}.XS{l} = feval(cnet.SLayer{k}.TransfFunc,cnet.SLayer{k}.YS{l});
        end

    else
    %C-layer      
    YC = num2cell(zeros(cnet.CLayer{k}.numKernels,1));
            for l=1:cnet.CLayer{k}.numKernels %For all convolutional kernels
                for m=find(cnet.CLayer{k}.ConMap(l,:)) %For all feature maps of previous layer and according to connection map
                    %Convolute and accumulate
                     YC{l} = YC{l}+fastFilter2(cnet.CLayer{k}.WC{l},cnet.SLayer{k-1}.XS{m},'valid')+cnet.CLayer{k}.BC{l};            
                end
            end
     cnet.CLayer{k}.YC = YC;            
     cnet.CLayer{k}.XC=cnet.CLayer{k}.YC; %For C-Layers transfer function is linear

    end
end


%Important assumption is made that after last C-Layer all feature maps are
%become 1x1 size, so the output is not a matrix but a vector
%This should be considered while synthesizing the neural network structure
%Convert the cell array of single values to a vector
XC = cell2mat(cnet.CLayer{k}.XC)';
for k=(cnet.numLayers-cnet.numFLayers+1):cnet.numLayers
    %If the previous layer was C-Layer
    if (k == cnet.numCLayers+cnet.numSLayers+1)
        cnet.FLayer{k}.Y = XC*cnet.FLayer{k}.W+cnet.FLayer{k}.B;
        cnet.FLayer{k}.X = feval(cnet.FLayer{k}.TransfFunc,cnet.FLayer{k}.Y);
    else
        cnet.FLayer{k}.Y = cnet.FLayer{k-1}.X*cnet.FLayer{k}.W+cnet.FLayer{k}.B;
        cnet.FLayer{k}.X = feval(cnet.FLayer{k}.TransfFunc,cnet.FLayer{k}.Y);
    end
end

out = cnet.FLayer{k}.X;
