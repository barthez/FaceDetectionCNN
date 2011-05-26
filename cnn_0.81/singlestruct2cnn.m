function cnet = singlestruct2cnn(single_cnet_in)
single_cnet = single_cnet_in;
%Convert all single matrices to double 
for k=1:(single_cnet.numLayers-single_cnet.numFLayers) 
    if(rem(k,2)) %Parity check
        %S-layer
        %Subsampling
        %Reshape output matrix to 1-D vector
        single_cnet.SLayer{k}.WS = cellfun(@double,single_cnet.SLayer{k}.WS,'UniformOutput',0);
        single_cnet.SLayer{k}.BS = cellfun(@double,single_cnet.SLayer{k}.BS,'UniformOutput',0);            
    else
    %C-layer      
        single_cnet.CLayer{k}.WC = cellfun(@double,single_cnet.CLayer{k}.WC,'UniformOutput',0);
        single_cnet.CLayer{k}.BC = cellfun(@double,single_cnet.CLayer{k}.BC,'UniformOutput',0);
        single_cnet.CLayer{k}.ConMap = double(single_cnet.CLayer{k}.ConMap);
    end
end

for k=(single_cnet.numLayers-single_cnet.numFLayers+1):single_cnet.numLayers
    single_cnet.FLayer{k}.W = double(single_cnet.FLayer{k}.W);
    single_cnet.FLayer{k}.B = double(single_cnet.FLayer{k}.B);                
end
cnet = cnn(single_cnet);