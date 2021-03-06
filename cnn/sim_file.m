[x,y]=meshgrid(1:480,1:640);
z=2*x +3*y;
z=z/max(max(z));
test = reshape(mapstd(reshape(double(imread('../twarze_test/test4.bmp')),1,[])),480,640);
%test = reshape(mapstd(reshape(double(imread('../faces_test/test0.bmp')),1,[])),480,640);

debug = 1;  %0 - aby nie wyswietlac obrazow posrednich, 1-aby wyswietlac
[out,cnet] = sim(cnet, test, debug);

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
