function cnet = cnn( Layers )
%CNN Summary of this function goes here
%   Detailed explanation goes here
    cnet.LayersNum = Layers;
    for it = 1:cnet.LayersNum
       cnet.Layer{it}.type = 's';
        
       cnet.Layer{it}.teta = 0.2;
       
       cnet.Layer{it}.InputHeight = 2;
       cnet.Layer{it}.InputWidth = 2;
       cnet.Layer{it}.TransferFunction = 'purelin';
       
       cnet.Layer{it}.FMapNum = 1;
       cnet.Layer{it}.ConMap = 1;
       
       cnet.Layer{it}.W = 1;
       cnet.Layer{it}.B = 0;
       
       cnet.Layer{it}.Y = 0;
       cnet.Layer{it}.X = 0;
       
    end
    
    cnet = class(cnet, 'cnn');
end

