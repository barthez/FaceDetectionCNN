full_img=rgb2gray(imread('natura.jpg'));
%imshow(full_img);
width=32;
height=36;
r= size(full_img, 1);    % size(x, 1) is the number of rows in array x.
c= size(full_img, 2);    % size(x, 2) is the number of columns in array x.
cols=[];
for i=width:width:c,
    cols=[cols width];
end
if mod(c,width)~=0,
    cols=[cols mod(c,width)];
end
sum(cols)
rows=[];
for i=height:height:r,
    rows=[rows height];
end
if mod(r,height)~=0,
    rows=[rows mod(r,height)];
end
sum(rows)
slices=mat2cell(full_img,rows,cols);
mkdir('slices');
for i=1:size(slices,1),
   for j=1:size(slices,2),
    if size(slices{i,j})==[height,width], %sprawdzam czy slice jest ca³y
       %mean(mean( slices{i,j} ))
       if std2(slices{i,j} ) > 10
        imwrite(slices{i,j},sprintf('slices/slice%02dx%02d.bmp', i,j),'bmp');
       end
    end
   end
end