function cnet = init(cnet)
%init initialize cnn object. It should be called after definition of all
%essential parameters of network, such as number of layers, convolution
%kernels, subsampling rates etc. The only thing, that should be initialized
%after calling init is connection matrix!
%
%  Syntax
%  
%    cnet = init(cnet)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%   Output:
%    cnet - initialized convolutional neural network ready for train
%
%(c) Sirotenko Mikhail, 2009

%First is a dummy layer by default. All it's weights are 1, all biases are
%0. 
    r = cnet.SLayer{1}.SRate;
    cnet.SLayer{1}.WS{1} = ones(floor(cnet.InputHeight/r),floor(cnet.InputWidth/r));
    cnet.SLayer{1}.BS{1} = zeros(floor(cnet.InputHeight/r),floor(cnet.InputWidth/r));
    cnet.SLayer{1}.FMapWidth = floor(cnet.InputWidth/r);
    cnet.SLayer{1}.FMapHeight = floor(cnet.InputHeight/r);
    
    %For now only single image input is valid
    cnet.SLayer{1}.numFMaps = 1; 
    
    %For all layers except output
for k=2:(cnet.numLayers-cnet.numFLayers)
    if(rem(k,2)) %Odd check
    %S-layer
        for l=1:cnet.CLayer{k-1}.numFMaps %For all feature maps
            %Make a shortcuts
            r = cnet.SLayer{k}.SRate;
            fmw = cnet.CLayer{k-1}.FMapWidth;
            fmh = cnet.CLayer{k-1}.FMapHeight;
            %Initialize all weights as 1 and biases randomly
            cnet.SLayer{k}.WS{l}= 1;
            cnet.SLayer{k}.BS{l} = rand_std(1, 1, 1);
            %Store layer properties
            cnet.SLayer{k}.FMapWidth = floor(fmw/r);
            cnet.SLayer{k}.FMapHeight = floor(fmh/r);            
        end
        %Subsaple layer dont change the number of feature maps
        cnet.SLayer{k}.numFMaps = cnet.CLayer{k-1}.numFMaps;
        cnet.SLayer{k}.dEdX=cell(1,cnet.SLayer{k}.numFMaps);
    else
    %C-Layer        
            for l=1:cnet.CLayer{k}.numKernels %For all convolution kernels
             %Set random weights
              kw = cnet.CLayer{k}.KernWidth;
              kh = cnet.CLayer{k}.KernHeight;
              %Neuron in next layer have the number of inputs equal to
              %number of weight times number of kernels
              cnet.CLayer{k}.WC{l} = rand_std(kh, kw, kh*kw*cnet.CLayer{k}.numKernels); 

              fmw = cnet.SLayer{k-1}.FMapWidth;
              fmh = cnet.SLayer{k-1}.FMapHeight;
            
              cnet.CLayer{k}.BC{l} = rand_std(1, 1, kh*kw*cnet.CLayer{k}.numKernels);
              %Feature map is cropped by 'valid' convolution
              cnet.CLayer{k}.FMapWidth = fmw-kw+1;
              cnet.CLayer{k}.FMapHeight = fmh-kh+1;   
            end
     %Initialize connection map: by default every feature mape connected to 
     %every convolution kernel. 
     if (~cnet.CLayer{k}.ConMap)
         cnet.CLayer{k}.ConMap = ones(cnet.CLayer{k}.numKernels, cnet.SLayer{k-1}.numFMaps);
     end
     cnet.CLayer{k}.numFMaps = cnet.CLayer{k}.numKernels;
     cnet.CLayer{k}.dEdX=cell(1,cnet.CLayer{k}.numFMaps);
    end
end

%Initializing fully connected layers
%It is supposed that outputs of last C-layer is cell vector with single 
%values 
for k=(cnet.numLayers-cnet.numFLayers+1):cnet.numLayers
    %Check if this layer is next after C-layer
    if (k == cnet.numCLayers+cnet.numSLayers+1)    
        cnet.FLayer{k}.W = rand_std(cnet.CLayer{k-1}.numFMaps,cnet.FLayer{k}.numNeurons,cnet.CLayer{k-1}.numFMaps+1);
        cnet.FLayer{k}.B = rand_std(1,cnet.FLayer{k}.numNeurons,cnet.CLayer{k-1}.numFMaps+1);
    else
        cnet.FLayer{k}.W = rand_std(cnet.FLayer{k-1}.numNeurons,cnet.FLayer{k}.numNeurons,cnet.FLayer{k-1}.numNeurons+1);
        cnet.FLayer{k}.B = rand_std(1,cnet.FLayer{k}.numNeurons,cnet.FLayer{k-1}.numNeurons+1);
    end
end
