close all;
clc;

cnet = cnn(6, 10);

cnet = setLayer(cnet, ...
                1, ... % NUmer Warstwy
                'c', ... % typ warstwy c/s/n
                5, ...  % Wysokoœæ wejœcia
                5, ... % Szerokoœæ wejscia
                'purelin', ... % Funkcja przejœcia
                4, ... % Iloœæ feature maps-ów
                [ 1 ; 1 ; 1 ; 1]); % Mapa po³¹czeñ 
            

cnet = setLayer(cnet, ...
                2, ... % NUmer Warstwy
                's', ... % typ warstwy c/s/n
                2, ...  % Wysokoœæ wejœcia
                2, ... % Szerokoœæ wejscia
                'tansig', ... % Funkcja przejœcia
                4, ... % Iloœæ feature maps-ów
                eye(4) ); % Mapa po³¹czeñ
            
            
            

cnet = setLayer(cnet, ...
                3, ... % NUmer Warstwy
                'c', ... % typ warstwy c/s/n
                3, ...  % Wysokoœæ wejœcia
                3, ... % Szerokoœæ wejscia
                'purelin', ... % Funkcja przejœcia
                14, ... % Iloœæ feature maps-ów
                [ 1 0 0 0; ...
                  1 0 0 0; ...
                  0 1 0 0; ...
                  0 1 0 0; ...
                  0 0 1 0; ...
                  0 0 1 0; ...
                  0 0 0 1; ...
                  0 0 0 1; ...
                  0 0 1 1; ...
                  0 1 1 0; ...
                  1 1 0 0; ...
                  1 0 0 1; ...                  
                  0 1 0 1; ...
                  1 0 1 0 ]); % Mapa po³¹czeñ
              
cnet = setLayer(cnet, ...
                4, ... % Numer Warstwy
                's', ... % typ warstwy c/s/n
                2, ...  % Wysokoœæ wejœcia
                2, ... % Szerokoœæ wejscia
                'tansig', ... % Funkcja przejœcia
                14, ... % Iloœæ feature maps-ów
                eye(14) ); % Mapa po³¹czeñ
            
cnet = setLayer(cnet, ...
                5, ... % NUmer Warstwy
                'n', ... % typ warstwy c/s/n
                7, ...  % Wysokoœæ wejœcia
                6, ... % Szerokoœæ wejscia
                'tansig', ... % Funkcja przejœcia
                14, ... % Iloœæ feature maps-ów
                eye(14) ); % Mapa po³¹czeñ

cnet = setLayer(cnet, ...
                6, ... % NUmer Warstwy
                'n', ... % typ warstwy c/s/n
                1, ...  % Wysokoœæ wejœcia
                1, ... % Szerokoœæ wejscia
                'tansig', ... % Funkcja przejœcia
                1, ... % Iloœæ feature maps-ów
                ones(1, 14) ); % Mapa po³¹czeñ

cnet = init(cnet);

%[out, cnet] = sim(cnet, double(imread('face001.jpg')));
%fprintf('out = %.3f\n', out);

%cnet = adapt(cnet, out -1);

%[out, cnet] = sim(cnet, double(imread('face001.jpg')));
%fprintf('out = %.3f\n', out);

%imshow(out);

IpG = loadImages('../faces/face_%04d.bmp', 59 ); %'../faces/face_%04d.bmp' %'../cyfry/%02d.bmp'
IpB{1} = double(zeros(36,32));

[error,cnet] = train(cnet, IpG, IpB);

plot(error);
