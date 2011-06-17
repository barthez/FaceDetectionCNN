test = reshape(mapstd(reshape(double(imread('../cyfry_test/test3.bmp')),1,[])),480,640);
%test = double(imread('../cyfry_test/test1.bmp'));

[out,cnet] = sim(cnet, test);

t_out = ones(120,160) * min(min(out));
t_out(5:116,5:157) = out;
pos = im2bw(subsample(t_out,4,4,0), 0.9);

figure();
subplot(1,2,1);
imshow(pos, []);
subplot(1,2,2);
imshow(test, []);

rprops = regionprops(pos);

hold on;
for it=1:length(rprops)
    rectangle('Position', rprops(it).BoundingBox, 'EdgeColor', 'red');
end
hold off;