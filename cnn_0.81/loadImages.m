function [ I, labels ] = loadImages( wektor )
%LOADFORTRAIN Summary of this function goes here
%   Detailed explanation goes here
    labels = ones(1, 1000);
    I = cell(1, 1000);
    
    for it = wektor
        it
        tmp = imread(sprintf('../faces/face_%04d.png', it));
        I{2*it -1} = reshape(mapstd(reshape(double(tmp),1,[])),36,32);
        tmp = imread(sprintf('../fake_faces/face_%04d.bmp', it));
        I{2*it } = reshape(mapstd(reshape(double(rgb2gray(tmp)),1,[])),36,32);
        labels(2*it) = 0;
    end;
end

