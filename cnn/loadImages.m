function [ I ] = loadImages( folder )
%LOADFORTRAIN Summary of this function goes here
%   Detailed explanation goes here
    
    I = cell(1, 550);
    for it = 1:550
        tmp = imread(sprintf([folder, '_%04d.bmp'], it));
        I{it} = reshape(mapstd(reshape(double((tmp)),1,[])),36,32);
    end;
end

