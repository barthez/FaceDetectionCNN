function [pd,labnew] = preproc_data(id,n,labels,rand_on)
%preproc_data MNIST handwriten image database preprocessing.
%
%  Syntax
%  
%    [pd,labnew] = preproc_data(id,n,labels,rand_on)
%    
%  Description
%   Input:
%    id - cell array of images 28x28 size
%    n - number of images to process
%    labels - cell array of labels, corresponding to images
%    rand_on - parameter, defining if it is necessary to randomly pick a
%    pairs of image/label
%   Output:
%    pd - cell array of processed images with 0 mean, 1 standard
%    deviation and increased size (from 28x28 to 32x32)
%    labnew - cell array of labels, corresponding to that images
%
%(c) Sirotenko Mikhail, 2009

for k=1:n

    if(rand_on==1)        
        rand_num = ceil(rand(1,1)*length(id));
    else
        rand_num = k;
    end
    labnew(k) = labels(rand_num);
    randd{k} = zeros(32,32);
    randd{k}(3:30,3:30)=double(id{rand_num});
    pd{k} = reshape(mapstd(reshape(randd{k},1,[])),32,32);
end

