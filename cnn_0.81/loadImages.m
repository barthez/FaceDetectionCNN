function [ I, labels ] = loadImages( wektor )
%LOADFORTRAIN Summary of this function goes here
%   Detailed explanation goes here
    labels = ones(1, length(wektor));
    I = cell(1, length(wektor));
    m = min(wektor) -1;
    
    
    for it = wektor
        tmp = imread(sprintf('../faces/face_%04d.bmp', it));
        I{2*(it-m) -1} = reshape(mapstd(reshape(double((tmp)),1,[])),36,32);
        tmp = imread(sprintf('../non_faces/img_%04d.bmp', it));
        I{2*(it-m) } = reshape(mapstd(reshape(double(tmp),1,[])),36,32);
        labels(2*(it-m)) = 0;
    end;
end

