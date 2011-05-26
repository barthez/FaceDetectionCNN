function [out_cnet] = cutrain(cnet,Ip,labels,I_testp, labels_test)

%======================== TODO ==========================
% 1.Включить сетку на графиках
% 2.Сбрасывать закраску прогресс бара при перевычислении Гессиана
% 3.Добавить новые параметры обучения, определяющие, через какие интервалы
% вычислять MCR и RMSE

%TRAIN train convolutional neural network using stochastic Levenberg-Marquardt  
%
%  Syntax
%  
%    [cnet, perf_plot] = train(cnet,Ip,labels,I_testp, labtst)
%    
%  Description
%   Input:
%    cnet - Convolutional neural network class object
%    Ip - cell array, containing preprocessed images of handwriten digits
%    labels - cell array of labels, corresponding to images
%    I_testp - cell array, containing preprocessed images of handwriten
%    digits of test set
%    labtst - cell array of labels, corresponding to images of test set
%   Output:
%    cnet - trained convolutional neural network
%    perf_plot - performance data
%
%(c) Sirotenko Mikhail, 2009

%Initialize GUI
h_gui = cnn_gui();
%Progress bars
h_HessPatch = findobj(h_gui,'Tag','HessPatch');
h_HessEdit = findobj(h_gui,'Tag','HessPrEdit');
h_TrainPatch = findobj(h_gui,'Tag','TrainPatch');
h_TrainEdit = findobj(h_gui,'Tag','TrainPrEdit');
%Axes
h_MCRaxes = findobj(h_gui,'Tag','MCRaxes');
h_RMSEaxes = findobj(h_gui,'Tag','RMSEaxes');
%Info textboxes
h_EpEdit = findobj(h_gui,'Tag','EpEdit');
h_ItEdit = findobj(h_gui,'Tag','ItEdit');
h_RMSEedit = findobj(h_gui,'Tag','RMSEedit');
h_MCRedit = findobj(h_gui,'Tag','MCRedit');
h_TetaEdit = findobj(h_gui,'Tag','TetaEdit');
%Buttons
h_AbortButton = findobj(h_gui,'Tag','AbortButton');

tic;    %Fix the start time
perf_plot = []; %Array for storing performance data

%Init the cuda cnn
singnet = cnn2singlestruct(cnet);
cudacnn('init',singnet);

%Initial MCR calculation
mcr(1)=cucalcMCR(I_testp, labels_test, 1:50);
plot(h_MCRaxes,mcr);
SetText(h_MCRedit,mcr(end));
numPats = length(Ip);

if(cnet.HcalcMode == 1) 
    for i=1:cnet.HrecalcSamplesNum
        %Setting the right output to 1, others to -1
        d = -ones(1,10);
        d(labels(i)+1) = 1;
        %Simulating
        [out, cnet] = sim(cnet,Ip{i});    
        %Calculate the error
        e = out-d;
        %Calculate Jacobian times error, or in other words calculate
        %gradient
        [cnet,je] = calcje(cnet,e); 
        [cnet,hx] = calchx(cnet);         
%        jj = jj+diag(sparse(hx));
        SetHessianProgress(h_HessPatch,h_HessEdit,i/cnet.HrecalcSamplesNum);
    end
%     %Averaging
%     jj = jj/cnet.HrecalcSamplesNum;
end
%For all epochs
for t=1:cnet.epochs
    SetText(h_EpEdit,t);
    SetTextHP(h_TetaEdit,cnet.teta);
    %For all patterns
    for n=1:numPats
        %Setting the right output to 1, others to -1
        d = -ones(1,10);
        d(labels(n)+1) = 1;
        %Simulating
        out = cudacnn('sim',single(Ip{n}))';    
        %Calculate the error
        e = out-d;
        %Calculate Jacobian times error, or in other words calculate
        %gradient

        cudacnn('adapt',single(e));
        
        %Calculate Hessian diagonal approximation
%         if(cnet.HcalcMode == 0)
%             [cnet,hx] = calchx(cnet);         
%             %Calculate the running estimate of Hessian diagonal approximation
%             jj = gamma*diag(sparse(hx))+sparse((1-gamma)*jj);     
%         else
%             if(mod(t*numPats+n,cnet.Hrecalc)==0) %If it is time to recalculate Hessian
%                 if(n+cnet.HrecalcSamplesNum>numPats)
%                     stInd = numPats-cnet.HrecalcSamplesNum;
%                 else
%                     stInd = n;
%                 end
%                 for i=stInd:stInd+cnet.HrecalcSamplesNum
%                     %Setting the right output to 1, others to -1
%                     d = -ones(1,10);
%                     d(labels(i)+1) = 1;
%                     %Simulating
%                     [out, cnet] = sim(cnet,Ip{i});    
%                     %Calculate the error
%                     e = out-d;
%                     %Calculate Jacobian times error, or in other words calculate
%                     %gradient
%                     [cnet,je] = calcje(cnet,e); 
%                     [cnet,hx] = calchx(cnet);         
%                     jj = jj+diag(sparse(hx));
%                     
%                     SetHessianProgress(h_HessPatch,h_HessEdit,(i-stInd)/cnet.HrecalcSamplesNum);
%                 end
%                 %Averaging
%                 jj = jj/cnet.HrecalcSamplesNum;
%             end
%         end


        %The following is usefull for debugging. 
%===========DEBUG
%        tmp(1)=check_finit_dif(cnet,1,Ip{n},d,1);
%===========DEBUG

        perf(n) = mse(double(e)); %Store the error

        %Uncoment this if you want a gradient descent
        %dW = cnet.teta(t)*je;
        %Actually Levenberg-Marquardt
        %dW = (jj+cnet.mu*ii)\(cnet.teta*je);    
        %Apply calculated weight updates
        %cnet = adapt_dw(cnet,dW);
        
        %Plot mean of performance for every 10 patterns
%         if(n>500)         
    if(n>1)
              if(~mod(n-1,400))
                  mcr = [mcr cucalcMCR(I_testp, labels_test, 1:200)];
                  plot(h_MCRaxes,mcr);
                  SetText(h_MCRedit,mcr(end));
              end
              if(~mod(n-1,10))
                  perf_plot = [perf_plot,mean(sqrt(perf(n-10:n)))];         
                  plot(h_RMSEaxes,perf_plot);
                  SetText(h_RMSEedit,perf_plot(end));
              end
    end
              
              %         end;
%It looks smoother, but not suit to large datasets
%            perf_plot = [perf_plot,mean(perf)];         
%            plot(perf_plot);

      %  grid on;    
        SetTrainingProgress(h_TrainPatch,h_TrainEdit,(n+(t-1)*numPats)/(numPats*cnet.epochs));
        SetText(h_ItEdit,n);
        drawnow;
        if(~isempty(get(h_AbortButton,'UserData')))
            fprintf('Training aborted \n');
            out_cnet = singlestruct2cnn(cudacnn('save',singnet));
            return;
        end
    end
    cnet.teta = cnet.teta*cnet.teta_dec;
    cudacnn('set_data',0,'teta',single(cnet.teta));
end
%display('Train is finished');
%display('Time was ');
toc
%display('Perfomance is ');
%mean(perf)
%Save new weights back to cnet
out_cnet = singlestruct2cnn(cudacnn('save',singnet));


%Sets Hessian progress
%hp - handle of patch
%hs - handle of editbox
%pr - value from 0 to 1
function SetHessianProgress(hp,hs,pr)
xpatch = [0 pr*100 pr*100 0];
set(hp,'XData',xpatch);
set(hs,'String',[num2str(pr*100,'%5.2f'),'%']);
drawnow;


%Sets Training progress
%hp - handle of patch
%hs - handle of editbox
%pr - value from 0 to 1
function SetTrainingProgress(hp,hs,pr)
xpatch = [0 pr*100 pr*100 0];
set(hp,'XData',xpatch);
set(hs,'String',[num2str(pr*100,'%5.2f'),'%']);

%Set numeric text in the specified edit box
%hs - handle of textbox
%num - number to convert and set
function SetText(hs,num)
set(hs,'String',num2str(num,'%5.2f'));

%Set numeric text in the specified edit box with high preceition
%hs - handle of textbox
%num - number to convert and set
function SetTextHP(hs,num)
set(hs,'String',num2str(num,'%5.3e'));