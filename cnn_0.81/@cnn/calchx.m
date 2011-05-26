function [cnet,hx] = calchx(cnet)
%CALCHX calculate diagonal approximation of Hessian
%
%  Syntax
%  
%    [cnet,hx] = calchx(cnet)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%   Output:
%    cnet - trained convolutional neural network
%    perf_plot - performance data
%
%   IMPORTANT! It is assumed that all calcgx was called before this, so the
%   first derrivatives (dEdW, dEdX, dEdY) of each layer contains the actual data
%
%(c) Sirotenko Mikhail, 2009


%========== Process all fully-connected layers first

k = cnet.numLayers;
%Determine wich is the previous layer
if(cnet.numFLayers~=1)
    outp = cnet.FLayer{cnet.numLayers-1}.X;
else
    outp = cnet.CLayer{cnet.numLayers-1}.XC;        
end

%Backpropogating Hessian diagonal approximation
%Second derrivative of MSE is 1
cnet.FLayer{k}.d2Ed2X{1} = 1;
cnet.FLayer{k}.d2Ed2Y{1} = cnet.FLayer{k}.d2Ed2X{1}.*(cnet.FLayer{k}.dXdY{1}.^2);
%Calculating Hessian diagonal approximation
cnet.FLayer{k}.d2Ed2W{1} = kron(cnet.FLayer{k}.d2Ed2Y{1},outp.^2)';  
cnet.FLayer{k}.d2Ed2B{1} = cnet.FLayer{k}.d2Ed2Y{1}';

%Reshape data into single-column vector
hx=cnet.FLayer{k}.d2Ed2W{1};
hx=[hx;cnet.FLayer{k}.d2Ed2B{1}];

if (cnet.numFLayers>1) %if there're more than one F-layer
    for k=cnet.numLayers-1:cnet.numLayers-cnet.numFLayers+1
        %Backpropogating Hessian diagonal approximation
        cnet.FLayer{k}.d2Ed2X{1} = (cnet.FLayer{k+1}.W.^2)*cnet.FLayer{k+1}.d2Ed2Y{1}';
        cnet.FLayer{k}.d2Ed2Y{1} = cnet.FLayer{k}.d2Ed2X{1}.*((cnet.FLayer{k}.dXdY{1}).^2);
        %Determine wich is the previous layer
        if(cnet.numLayers-cnet.numFLayers+1==k)
             outp = cell2mat(cnet.CLayer{k-1}.XC);                
        else
             outp = cnet.FLayer{k-1}.X;
        end
        %Calculating Hessian diagonal approximation
        cnet.FLayer{k}.d2Ed2W{1} = kron(cnet.FLayer{k}.d2Ed2Y{1},outp.^2);  
        cnet.FLayer{k}.d2Ed2B{1} = cnet.FLayer{k}.d2Ed2Y{1};    
        %Reshape data into single-column vector
        hx=[hx;cnet.FLayer{k}.d2Ed2W{1}];
        hx=[hx;cnet.FLayer{k}.d2Ed2B{1}];
    
    end
end

k = cnet.numLayers-cnet.numFLayers;

%Backpropogating Hessian diagonal approximation
d2Ed2X = ((cnet.FLayer{k+1}.W).^2)*cnet.FLayer{k+1}.d2Ed2Y{1};
%Converting to cell array
cnet.CLayer{k}.d2Ed2X = num2cell(d2Ed2X);

%========== Convolutional and subsampling layers ===================
for k=(cnet.numLayers-cnet.numFLayers):-1:2 %first layer is dummy
    if(rem(k,2)) %Check the parity
    %S-layer
        d2Ed2X = num2cell(zeros(cnet.SLayer{k}.numFMaps,1));
        for l=1:cnet.SLayer{k}.numFMaps %For all feature maps
            %Calculating Hessian diagonal approximation
            cnet.SLayer{k}.d2Ed2Y{l} = cnet.SLayer{k}.d2Ed2X{l}.*(cnet.SLayer{k}.dXdY{l}.^2);
            cnet.SLayer{k}.d2Ed2W{l} = sum(sum(cnet.SLayer{k}.d2Ed2Y{l}*(cnet.SLayer{k}.SS{l}.^2)));  
            cnet.SLayer{k}.d2Ed2B{l}=sum(sum(cnet.SLayer{k}.d2Ed2Y{l}));        
            
            %Backpropogating Hessian diagonal approximation
            d2Ed2X{l} = back_subsample(cnet.SLayer{k}.d2Ed2Y{l}.*(cnet.SLayer{k}.WS{l}^2),cnet.SLayer{k}.SRate);
        end

        
    cnet.CLayer{k-1}.d2Ed2X = reshape(d2Ed2X,size(cnet.CLayer{k-1}.XC,1),size(cnet.CLayer{k-1}.XC,2));

    %Reshape data into single-column vector
    hx=[hx;cell2mat(cnet.SLayer{k}.d2Ed2W')];
    hx=[hx;cell2mat(cnet.SLayer{k}.d2Ed2B')];
    
%---------------------------------------------------------------------------------------------    
    else
    %C-layer      

     %As far as dXdY.^2 = 1, then
     cnet.CLayer{k}.d2Ed2Y = cnet.CLayer{k}.d2Ed2X;
     %Temporary variables for accumulation
     d2Ed2X = num2cell(zeros(1,cnet.SLayer{k-1}.numFMaps));    
     d2Ed2W = num2cell(zeros(1,cnet.CLayer{k}.numKernels)); 
     d2Ed2B = num2cell(zeros(1,cnet.CLayer{k}.numKernels));      
     
     for l=1:cnet.CLayer{k}.numKernels %For all convolutional kernels
            for m=find(cnet.CLayer{k}.ConMap(l,:)) %For all feature maps of previous layer connected with current kernel
                %Calculating Hessian diagonal approximation
                d2Ed2W{l} = d2Ed2W{l}+...
                       back_conv2(cnet.SLayer{k-1}.XS{m}.^2,cnet.CLayer{k}.d2Ed2Y{l},cnet.CLayer{k}.WC{l},'gx');  

                d2Ed2B{l} = d2Ed2B{l}+sum(sum(cnet.CLayer{k}.d2Ed2Y{l}));  
                   
                %Backpropogating Hessian diagonal approximation
                d2Ed2X{m} = d2Ed2X{m}+...
                       back_conv2(cnet.SLayer{k-1}.XS{m}, cnet.CLayer{k}.d2Ed2Y{l},cnet.CLayer{k}.WC{l}.^2,'err');                  
                

            end
     end
     cnet.CLayer{k}.d2Ed2W = d2Ed2W;
     cnet.CLayer{k}.d2Ed2B = d2Ed2B;
     cnet.SLayer{k-1}.d2Ed2X = d2Ed2X;
     %Reshape data into single-column vector
     hx=[hx;reshape(cell2mat(cnet.CLayer{k}.d2Ed2W),[],1)];
     hx=[hx;cell2mat(cnet.CLayer{k}.d2Ed2B)'];
        
    end
end



end
