function I = readMNIST_image(filepath,num)
%readMNIST_image MNIST handwriten image database reading. Reads only images
%without labels, with specified filename
%
%  Syntax
%  
%    I = readMNIST_image(filepath,num)
%    
%  Description
%   Input:
%    filepath - name of database file with path
%    n - number of images to process
%   Output:
%    I - cell array of training images 28x28 size
%
%(c) Sirotenko Mikhail, 2009
%===========Loading training set

fid = fopen(filepath,'r','b');  %big-endian
magicNum = fread(fid,1,'int32');    %Magic number
if(magicNum~=2051) 
    display('Error: cant find magic number');
    return;
end
imgNum = fread(fid,1,'int32');  %Number of images
rowSz = fread(fid,1,'int32');   %Image height
colSz = fread(fid,1,'int32');   %Image width

if(num<imgNum) 
    imgNum=num; 
end

for k=1:imgNum
    I{k} = uint8(fread(fid,[rowSz colSz],'uchar'));
end
fclose(fid);
