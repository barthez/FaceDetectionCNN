function [ I ] = loadImages( folder, num )
%LoadImages Za³aduj obrazki do treningu
%   folder - pattern nazwy pliku zawieraj¹ce jedno podstawienie '%d' 
%   w miejscu gdzie ma byæ numer obrazka
%   num - iloœc obrazków do wczytania
    
    I = cell(1, num);
    for it = 1:num
        tmp = imread(sprintf(folder, it));
        I{it} = reshape(mapstd(reshape(double((tmp)),1,[])),36,32);
        %I{it} = double((tmp));
    end;
end

