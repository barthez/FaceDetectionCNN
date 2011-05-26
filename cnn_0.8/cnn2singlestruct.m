function single_cnet = cnn2singlestruct(cnet)
single_cnet = struct(cnet);

%Convert all double matrices to single, double scalars will be converted in
%NN.cu
for k=1:(cnet.numLayers-cnet.numFLayers) 
    if(rem(k,2)) %Parity check
        %S-layer
        %Subsampling
        %Reshape output matrix to 1-D vector
        single_cnet.SLayer{k}.WS = cellfun(@single,cnet.SLayer{k}.WS,'UniformOutput',0);
        single_cnet.SLayer{k}.BS = cellfun(@single,cnet.SLayer{k}.BS,'UniformOutput',0);            
    else
    %C-layer      
        single_cnet.CLayer{k}.WC = cellfun(@single,cnet.CLayer{k}.WC,'UniformOutput',0);
        single_cnet.CLayer{k}.BC = cellfun(@single,cnet.CLayer{k}.BC,'UniformOutput',0);
        single_cnet.CLayer{k}.ConMap = single(cnet.CLayer{k}.ConMap);
    end
end

for k=(cnet.numLayers-cnet.numFLayers+1):cnet.numLayers
    single_cnet.FLayer{k}.W = single(cnet.FLayer{k}.W);
    single_cnet.FLayer{k}.B = single(cnet.FLayer{k}.B);                
end
