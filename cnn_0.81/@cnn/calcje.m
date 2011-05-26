function [cnet,je] = calcje(cnet,e)
%CALCJE Calculation of gradient via backpropagation 
%
%  Syntax
%  
%    [cnet,je] = calcje(cnet,e)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%    e - error
%   Output:
%    cnet - convolutional neural network class object with computed
%    gradients
%    ge - gradient (or Jacobian times error)
%
%(c) Sirotenko Mikhail, 2009


%Last layer
k = cnet.numLayers;
%Calculate the performance function derrivative
cnet.FLayer{k}.dEdX{1} = feval(cnet.Perf, 'dy' , e, cnet.FLayer{k}.Y, cnet.FLayer{k}.X, cnet.Perf);
%Calculating the transfer function derrivative
cnet.FLayer{k}.dXdY{1} = feval(cnet.FLayer{k}.TransfFunc,'dn',cnet.FLayer{k}.Y,cnet.FLayer{k}.X); 
%Calculating dE/dY
cnet.FLayer{k}.dEdY{1} = cnet.FLayer{k}.dXdY{1}.*cnet.FLayer{cnet.numLayers}.dEdX{1};
%Check if the previous layer is convolutional or fully-connected
if(cnet.numFLayers~=1)
    outp = cnet.FLayer{cnet.numLayers-1}.X;
else
    outp = cnet.CLayer{cnet.numLayers-1}.XC;        
end
%Calculate gradients for weights and biases
cnet.FLayer{k}.dEdW{1} = kron(cnet.FLayer{k}.dEdY{1},outp)';
cnet.FLayer{k}.dEdB{1} = cnet.FLayer{k}.dEdY{1}';

%Reshape data into single-column vector
 je=cnet.FLayer{k}.dEdW{1};
 je=[je;cnet.FLayer{k}.dEdB{1}];

if (cnet.numFLayers>1) %If there are more than 1 fully-connected layers
    for k=cnet.numLayers-1:cnet.numLayers-cnet.numFLayers+1
        %Backpropagate error to outputs of this layer
        cnet.FLayer{k}.dEdX{1} = cnet.FLayer{k+1}.W*cnet.FLayer{k+1}.dEdY{1}';
        %Сalculating the transfer function derrivative
        cnet.FLayer{k}.dXdY{1} = feval(cnet.FLayer{k}.TransfFunc,'dn',cnet.FLayer{k}.Y,cnet.FLayer{k}.X)'; %Производная функции активации
        %Backpropagate error to transfer function inputs
        cnet.FLayer{k}.dEdY{1} = cnet.FLayer{k}.dXdY{1}.*cnet.FLayer{k}.dEdX{1};
        %Check if the previous layer is convolutional or fully-connected
        if(cnet.numLayers-cnet.numFLayers+1==k)
             outp = cell2mat(cnet.CLayer{k-1}.XC);                
        else
             outp = cnet.FLayer{k-1}.X;
        end
        %Calculate gradients for weights and biases        
        cnet.FLayer{k}.dEdW{1} = kron(cnet.FLayer{k}.dEdY{1},outp); 
        cnet.FLayer{k}.dEdB{1} = cnet.FLayer{k}.dEdY{1};     

       %Reshape data into single-column vector
         je=[je;cnet.FLayer{k}.dEdW{1}];
         je=[je;cnet.FLayer{k}.dEdB{1}];    
    end
end

k = cnet.numLayers-cnet.numFLayers;
%Backpropagating the error
cnet.CLayer{k}.dEdX = num2cell(cnet.FLayer{k+1}.W*cnet.FLayer{k+1}.dEdY{1});
%dE/dY = dE/dX because of linear transfer function for C-layer
cnet.CLayer{k}.dEdY = cnet.CLayer{k}.dEdX;

for k=(cnet.numLayers-cnet.numFLayers):-1:2 %Exclude first layer from loop (it's dummy)
    if(rem(k,2)) %Parity check
    %Subsampling layer
    %Initialize dE/dX for accumilating the error
    dEdX = num2cell(zeros(cnet.SLayer{k}.numFMaps,1));
        for l=1:cnet.SLayer{k}.numFMaps %For all feature maps
            %Сalculating the transfer function derrivative
            cnet.SLayer{k}.dXdY{l} = feval(cnet.SLayer{k}.TransfFunc,'dn',cnet.SLayer{k}.YS{l},cnet.SLayer{k}.XS{l}); 
            %Backpropagate error to transfer function inputs
            cnet.SLayer{k}.dEdY{l} = cnet.SLayer{k}.dXdY{l}.*cnet.SLayer{k}.dEdX{l};
            %Calculate the gradient for weights and biases
            cnet.SLayer{k}.dEdW{l} = sum(sum(cnet.SLayer{k}.dEdY{l}.*cnet.SLayer{k}.SS{l}));     
            cnet.SLayer{k}.dEdB{l}=sum(sum(cnet.SLayer{k}.dEdY{l}));    
            if(k>1) %Backpropagate the error if this is not the first layer
               dEdX{l} = back_subsample(cnet.SLayer{k}.dEdY{l}.*cnet.SLayer{k}.WS{l},cnet.SLayer{k}.SRate);
            end           
        end
       
    if(k>1) %Store the accumulated backpropagated error
        cnet.CLayer{k-1}.dEdX = reshape(dEdX,size(cnet.CLayer{k-1}.XC,1),size(cnet.CLayer{k-1}.XC,2),1);
    end
    %Reshape data into single-column vector
     je=[je;cell2mat(cnet.SLayer{k}.dEdW')];
     je=[je;cell2mat(cnet.SLayer{k}.dEdB')];
    
%---------------------------------------------------------------------------------------------    
    else
     %Convolutional layer
     %dE/dY = dE/dX because of linear transfer function for C-layer
     cnet.CLayer{k}.dEdY = cnet.CLayer{k}.dEdX;
     %Initialize temporary variables for accumilating the errors
     dEdX = num2cell(zeros(1,cnet.SLayer{k-1}.numFMaps));
     dEdW = num2cell(zeros(1,cnet.CLayer{k}.numKernels));
     dEdB = num2cell(zeros(1,cnet.CLayer{k}.numKernels));     
     for l=1:cnet.CLayer{k}.numKernels %Для всех ядер свертки
            cnet.CLayer{k}.dXdY{l} = ones(size(cnet.CLayer{k}.XC{1})); %Transfer function is linear
            %For all feature maps of next layer wich have connections to
            %this layer
            for m=find(cnet.CLayer{k}.ConMap(l,:)) 
                %Backpropagate and accumulate the error
                dEdX{m} = dEdX{m}+...
                       back_conv2(cnet.SLayer{k-1}.XS{m}, cnet.CLayer{k}.dEdY{l},cnet.CLayer{k}.WC{l},'err');
                %Calculate and accumulate the shared weights gradient
                dEdW{l} = dEdW{l}+...
                       back_conv2(cnet.SLayer{k-1}.XS{m}, cnet.CLayer{k}.dEdY{l},cnet.CLayer{k}.WC{l},'gx'); 

                %Calculating the shared biases gradient
                dEdB{l}=dEdB{l} + sum(sum(cnet.CLayer{k}.dEdY{l})); 

            end
     end
     %Storing everithing
     cnet.SLayer{k-1}.dEdX = dEdX;
     cnet.CLayer{k}.dEdW = dEdW;
     cnet.CLayer{k}.dEdB = dEdB;
     %Reshape data into single-column vector
     je=[je;reshape(cell2mat(cnet.CLayer{k}.dEdW),[],1)];
     je=[je;cell2mat(cnet.CLayer{k}.dEdB)'];
        
    end
end



end
