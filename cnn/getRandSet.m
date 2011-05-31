function [ Out ] = getRandSet( set, num )
%GETRANDSET Summary of this function goes here
%   Detailed explanation goes here
    Out = cell(1, num);
    for k=1:num
        rand_num = ceil(rand(1,1)*length(set));
        Out{k} = set{rand_num};
    end

end

