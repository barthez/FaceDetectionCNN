function [ error, cnet ] = train( cnet, IpG, IpB)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

%h_gui = cnn_gui();

%h_error = findobj(h_gui, 'Tag', 'ErrorLevel');

BoostIter = 0;
ThrFa = 0.8;
error= [];

TestSetG = getRandSet(IpG, 400);
TestSetB = getRandSet(IpB, 400);

VeryBad = cell(1,1);
VBit = 1;

%figure(1);

error = zeros(cnet.epochs*6, 1);

while BoostIter < 1%6
    PatNum = 100;
        
    GoodSet = getRandSet(IpG, PatNum);
    BadSet  = getRandSet(IpB, PatNum);
    for ep =1:cnet.epochs
        fprintf('BoostIter = %d, Epoka = %d\n', BoostIter, ep);
        
        
            
        for p = 1:PatNum
            [out, cnet] = sim(cnet, GoodSet{p});
            d = out - 1;
            cnet = adapt(cnet, d);
            error( (ep-1)*PatNum + 2*p -1 ) = d;
            
            [out, cnet] = sim(cnet, BadSet{p});
            %if out > ThrFa
            %   VeryBad{VBit} = BadSet{p};
            %   VBit = VBit + 1;
            %end
            d = out + 1;
            cnet = adapt(cnet, d);
            error( (ep-1)*PatNum + 2*p ) = d;
        end
        
        %fprintf('Testy...\n')
        %er = zeros(800, 1);
        %for it=1:400
        %   [out, cnet] = sim(cnet, TestSetG{it});
        %   er(it, 1) = d - 1;
        %   [out, cnet] = sim(cnet, TestSetB{it});
        %   er(400 + it, 1) = d + 1;
        %end
        %error(BoostIter*cnet.epochs + ep, 1) = mse(er);
        
        %plot(h_error, [ 1:(BoostIter*cnet.epochs + ep), error(1:(BoostIter*cnet.epochs + ep))' ] );
        
    end
    
    BoostIter = BoostIter +1;
    if ThrFa >= 0.2
        ThrFa = ThrFa - 0.2;
    end
    
    cnet.theta = cnet.theta * cnet.theta_dec;
end


end

