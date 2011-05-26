function out = rand_std(w, h, numinp) 
%rand_std train convolutional neural network using stochastic Levenberg-Marquardt  
%
%  Syntax
%  
%    [cnet, perf_plot] = train(cnet,Ip,labels)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%    Ip - cell array, containing preprocessed images of handwriten digits
%    labels - cell array of labels, corresponding to images
%   Output:
%    cnet - trained convolutional neural network
%    perf_plot - performance data
%
%(c) Sirotenko Mikhail, 2009
%Генерирует матрицу случайных чисел в диапазоне от -1 до 1
%numinp - количество входов в нейрон. Используется для выполнения правила
%sigma=m^-1/2, где сигма - среднеквадратич. отклонение, а m - количество
%весов входящих в нейрон
  sigma = numinp^(-1/2);
  out = (rand(w,h) - ones(w,h)/2);

  if(w*h>1)
    outstd = mean(std(reshape(out,1,[])));      

  else
      outstd=1;
  end
  out = out*sigma/outstd;
