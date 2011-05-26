function difference = check_finit_dif(cnet,num,Ip,d,order) 
%check_finit_dif calulate gradient or Hessian using finite differences
%
%  Syntax
%  
%    difference = check_finit_dif(cnet,num,Ip,d,order) 
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%    num - number of parameter (weight or bias) in single-column weight
%    vector, which for gradient has to be calculated
%    Ip - cell array of input images
%    d - desired output
%    order - 1 means gradient, 2 - Hessian
%    
%   Output:
%    difference - gradient for a given parameter calculated using finite
%    difference
%   
%   Description:
%    This function is mostly used for debugging, because calculating
%    gradients such was is computationally expensive

%Epsilon determines the accuracy of this method
epsilon = 10^-8;        
switch(order)
    case 1
        %Create an empty array
        dW = sparse(zeros(20691,1));
        %Set the given parameter to epsilon
        dW(num) = epsilon;
        %Apply this to cnet
        cnet_minus_e = adapt_dw(cnet,dW);
        cnet_plus_e = adapt_dw(cnet,-dW);
        %Simulate it with different error values
        e1 = sim(cnet_plus_e,Ip)-d;
        e2 = sim(cnet_minus_e,Ip)-d;
        %Calculate finite difference
        dEdWi = (mse(e1)-mse(e2))/(2*epsilon);
        difference = dEdWi;
    case 2 % Not working proper yet
%         dW = sparse(zeros(20691,1));
%         dW(num) = 2*epsilon;
%         cnet_minus_e = adapt_dw(cnet,dW);
%         cnet_plus_e = adapt_dw(cnet,-dW);
%         e1 = sim(cnet_plus_e,Ip)-d;
%         e2 = sim(cnet_minus_e,Ip)-d;
%         e3 = sim(cnet,Ip)-d;
%         d2Ed2Wi = (mse(e1)+mse(e2)-2*mse(e3))/(4*epsilon^2);
%         difference = d2Ed2Wi;

%RECURSIVE
%         dW2 = sparse(zeros(20691,1));
%         dW2(num) = epsilon;
%         cnet_minus_e2 = adapt_dw(cnet,dW2);
%         cnet_plus_e2 = adapt_dw(cnet,-dW2);
%         je1 = check_finit_dif(cnet_plus_e2,num,Ip,d,1);
%         je2 = check_finit_dif(cnet_minus_e2,num,Ip,d,1);
%         d2Ed2Wi2 = (je1-je2)/(2*epsilon);
%         difference = d2Ed2Wi;

        
    otherwise
        error('Order should be 1 or 2');
end