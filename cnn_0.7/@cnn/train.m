function [cnet, perf_plot] = train(cnet,Ip,labels)
%TRAIN train convolutional neural network using stochastic Levenberg-Marquardt  
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

tic;    %Fix the start time
perf_plot = []; %Array for storing performance data
%Coefficient, determining the running estimation of diagonal 
%Hessian approximation leak
gamma = 0.1;  

%Number of training patterns
numPats = length(Ip);
%Calculate the size of network
net_size = cnn_size(cnet);

ii = sparse(1:net_size,1:net_size,ones(1,net_size));    

%For all epochs
for t=1:cnet.epochs

    jj = sparse(0);
    %For all patterns
    for n=1:numPats
        %Setting the right output to 1, others to -1
        d = -ones(1,10);
        d(labels(n)+1) = 1;
        %Simulating
        [out, cnet] = sim(cnet,Ip{n});    
        %Calculate the error
        e = out-d;
        %Calculate Jacobian times error, or in other words calculate
        %gradient
        [cnet,je] = calcje(cnet,e); 
        %Calculate Hessian diagonal approximation
        [cnet,hx] = calchx(cnet);         
        %Calculate the running estimate of Hessian diagonal approximation
        jj = gamma*diag(sparse(hx))+sparse((1-gamma)*jj);

        %The following is usefull for debugging. 
%===========DEBUG
%        tmp(1)=check_finit_dif(cnet,1,Ip{n},d,1);
%===========DEBUG

        perf(n) = mse(e); %Store the error

        %Uncoment this if you want a gradient descent
%        dW = cnet.teta*je;
        %Actually Levenberg-Marquardt
        dW = (jj+cnet.mu*ii)\(cnet.teta*je);    
        %Apply calculated weight updates
        cnet = adapt_dw(cnet,dW);

        %Plot mean of performance for every 10 patterns
         if(n>10)         
             if(~mod(n,10))
                perf_plot = [perf_plot,mean(perf(n-10:n))];         
                plot(perf_plot);
             end
         end;
%It looks smoother, but not suit to large datasets
%            perf_plot = [perf_plot,mean(perf)];         
%            plot(perf_plot);

        grid on;    
        drawnow;
    end
    cnet.teta = cnet.teta*cnet.teta_dec;
end
display('Train is finished');
display('Time was ');
toc
display('Perfomance is ');
mean(perf)

