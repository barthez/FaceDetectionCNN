function cnet = cnn(numLayers,numFLayers,numInputs,InputWidth,InputHeight,numOutputs)
%CNN convolutional neural network class constructor  
%
%  Syntax
%  
%    cnet =
%    cnn(numLayers,numFLayers,numInputs,InputWidth,InputHeight,numOutputs)
%    
%  Description
%   Input:
%    numLayers - total number of layers
%    numFLayers - number of fully connected layers
%    numInputs - number of input images (currently only 1 supported)
%    InputWidth - input image width
%    InputHeight - input image heigth
%    numOutputs - number of outputs
%   Output:
%    cnet - convolutional neural network class object
%
%   Semantic is quite simple: subsampling and convolutional layers are
%   follows in pairs and called SLayers and CLayers. Thus all S-layers are
%   odd and all C-layers are even. After last CLayer follows FLayer wich is
%   fully connected layer. The same way named weights and biases.
%   Example of accessing weights: 
%   cnn.CLayer{2}.WC
%   cnn.SLayer{3}.BS
%   If it necessary to create network with first CLayer make the SLayer{1}
%   linear
%(c) Sirotenko Mikhail, 2009

%Create empty network
%----User defined parameters 
    
if(nargin<6) %If no parameters are defined set it to defaults
    if((nargin==1)&&(isstruct(numLayers)))
        cnet = class(numLayers,'cnn');
        return;
    else

        cnet.numLayers = 3; %Total layers number
        cnet.numSLayers = 1; %Number of S-layers
        cnet.numCLayers = 1; %Number of C-layers
        cnet.numFLayers = 1; %Number of F-lauers
        cnet.numInputs = 1; %Number of input images
        cnet.InputWidth = 30; %Input weight
        cnet.InputHeight = 30; %Inout height
        cnet.numOutputs = 1; %Outputs number 
    end
else 
    cnet.numLayers = numLayers;
    cnet.numSLayers = ceil((numLayers-numFLayers)/2); 
    cnet.numCLayers = numLayers-numFLayers-cnet.numSLayers; 
    cnet.numFLayers = numFLayers; 
    cnet.numInputs = numInputs; 
    cnet.InputWidth = InputWidth; 
    cnet.InputHeight = InputHeight; 
    cnet.numOutputs = numOutputs; 
end
%Default parameters wich typically redefined later
cnet.Perf = 'mse'; %Performance function
cnet.mu = 0.01; %Mu coefficient for stochastic Levenberg-Marqwardt
cnet.mu_dec = 0.1; %Mu per epoch decrease rate
cnet.mu_inc = 10;   %Mu per epoch increase rate
cnet.mu_max = 1.0000e+010;  %Maximum mu
cnet.epochs = 50;   %Number of epochs
cnet.goal = 0.00001;    %Goal RMSE value
cnet.teta = 0.2;
cnet.teta_dec = 0.3; %Teta per epoch decrease rate

%The way Hessian diagonal approximation is computed
%0 - Hessian running estimate is calculated every iteration
%1 - Hessian approximation is recalculated every cnet.Hrecomp iterations
%2 - No Hessian calculations are made. Pure stochastic gradient
cnet.HcalcMode = 0;
cnet.Hrecalc = 1000; %Number of iterations to passs for Hessian recalculation
cnet.HrecalcSamplesNum = 100; %Number of samples for Hessian recalculation
%Train plot properties
cnet.MCRrecalc = 200; %How often to recalculate missclassification rate
cnet.MCRsamples = 70; %How much test samples to use for MCR calculation
cnet.RMSErecalc = 10; %How often to recalculate RMSE

%SLayer contains information about subsampling layers
%Constructor only set default values for all variables
%All these variables has to be set and then Init method called
for k=1:cnet.numSLayers
    
    m=2*k-1; %Use m to consider layer parity
    %----User defined parameters
    cnet.SLayer{m}.teta = 0.2; %Layer train coefficient
    cnet.SLayer{m}.SRate = 2; %Subsampling rate
    cnet.SLayer{m}.TransfFunc = 'tansig_mod'; %Activation function
    %----Feature maps, calculating while simulation of network
    cnet.SLayer{m}.YS{1} = 0; %Weighted inputs (before activation function)
    cnet.SLayer{m}.XS{1} = 0; %Outputs (after activation)
    cnet.SLayer{m}.SS{1} = 0; %Subsampled feature map
    %----Parameters initialized by Init method
    cnet.SLayer{m}.WS{1} = 0; %Weights
    cnet.SLayer{m}.BS{1} = 0; %Biases
    cnet.SLayer{m}.numFMaps = 1; %Number of output feature maps
    cnet.SLayer{m}.FMapWidth = 10;   %Feature maps dimensions
    cnet.SLayer{m}.FMapHeight = 10;
    cnet.SLayer{m}.ln = m; %Layer number
    %----Variables calculated while training
    cnet.SLayer{m}.dEdW{1} = 0; %Partial derivative of error by weights
    cnet.SLayer{m}.dEdB{1} = 0; %Partial derivative of error by biases
    cnet.SLayer{m}.dEdX{1} = 0; %Partial derivative of error by outputs
    cnet.SLayer{m}.dXdY{1} = 0; %Partial derivative of outputs by weighted inputs
    cnet.SLayer{m}.dYdW{1} = 0; %Partial derivative of weighted inputs by weights
    cnet.SLayer{m}.dYdB{1} = 0; %Partial derivative of weighted inputs by biases
    cnet.SLayer{m}.H{1} = 0;    %Hessian approximation
    cnet.SLayer{m}.mu = 0;      %Regularisation factor. 
    cnet.SLayer{m}.dEdX_last{1} = 0; 
end
%CLayer - convolutional layer
for k=1:cnet.numCLayers
    m=k*2;
    %----User defined parameters
    cnet.CLayer{m}.teta = 0.2; %Коэффициент обучения для слоя
    cnet.CLayer{m}.numKernels = 1; %Количество ядер свертки (то же, что lenght(WC))
    cnet.CLayer{m}.KernWidth = 3; %Размерность ядра свертки
    cnet.CLayer{m}.KernHeight = 3 ;
    %----Feature maps, calculating while simulation of network
    cnet.CLayer{m}.YC = cell(1); 
    cnet.CLayer{m}.XC = cell(1); 
    %----Parameters initialized by Init method
    cnet.CLayer{m}.WC{1} = 0; 
    cnet.CLayer{m}.BC{1} = 0; 
    cnet.CLayer{m}.numFMaps = 1; 
    cnet.CLayer{m}.FMapWidth = 10; 
    cnet.CLayer{m}.FMapHeight = 10;
    cnet.CLayer{m}.ln = m; 
    %----Variables calculated while training
    cnet.CLayer{m}.dEdW{1} = 0; 
    cnet.CLayer{m}.dEdB{1} = 0; 
    cnet.CLayer{m}.dEdX{1} = 0; 
    cnet.CLayer{m}.dXdY{1} = 0; 
    cnet.CLayer{m}.dYdW{1} = 0; 
    cnet.CLayer{m}.dYdB{1} = 0; 
    cnet.CLayer{m}.H{1} = 0;    
    cnet.CLayer{m}.mu = 0;      
    cnet.CLayer{m}.dEdX_last{1} = 0;
    %Connection map - row number corresponds to output, column number
    %corresponds to input. Necessary for network assymetry
    cnet.CLayer{m}.ConMap = 0;
end

%FLayer - fully-connected layer
for k=cnet.numCLayers+cnet.numSLayers+1:cnet.numLayers
    %----User defined parameters
    cnet.FLayer{k}.teta = 0.2; 
    if k==cnet.numLayers
       cnet.FLayer{k}.numNeurons = cnet.numOutputs; %If the layer is output
    else
       cnet.FLayer{k}.numNeurons = 10; %Default number of neurons in layer
    end
    cnet.FLayer{k}.W = 0; 
    cnet.FLayer{k}.B = 0; 
    %----Feature maps, calculating while simulation of network
    cnet.FLayer{k}.Y = 0; 
    cnet.FLayer{k}.X = 0; 
    cnet.FLayer{k}.ln = k;
    cnet.FLayer{k}.TransfFunc = 'tansig_mod'; 
    %----Variables calculated while training
    cnet.FLayer{k}.dEdW{1} = 0; 
    cnet.FLayer{k}.dEdB{1} = 0; 
    cnet.FLayer{k}.dEdX{1} = 0; 
    cnet.FLayer{k}.dXdY{1} = 0; 
    cnet.FLayer{k}.dYdW{1} = 0; 
    cnet.FLayer{k}.dYdB{1} = 0; 
    cnet.FLayer{k}.H{1} = 0;    
    cnet.FLayer{k}.mu = 0;      
    cnet.FLayer{k}.dEdX_last{1} = 0;
end
cnet = class(cnet,'cnn');


