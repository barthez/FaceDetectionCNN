function [ cnet ] = fromStruct( cnet_struct )
%FROMSTRUCT Summary of this function goes here
%   Detailed explanation goes here
cnet = class(cnet_struct, 'cnn');

end

