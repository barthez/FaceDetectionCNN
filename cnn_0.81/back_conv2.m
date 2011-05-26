function res = back_conv2(FM,e,K,type)
%back_conv2 back convolution. Function can be used in two cases - backpropagate error  
%   for lower layers and calculate gradient
%
%  Syntax
%  
%    res = back_conv2(FM,e,K,type)
%    
%  Description
%   Input:
%    FM - feature map
%    e - error map
%    K - shared weights (convolution kernel)
%    type - type of operation (gx - for gradient calculation, err - for error calculation)
%   Output:
%    res - result of computation
%
%(c) Sirotenko Mikhail, 2009

switch(type)
    case 'gx'   %Calculate gradient
          res = fastFilter2(e,FM,'valid'); 

    case 'err' %Error backpropagation
          res = conv2(e,K,'full');
end

end
    