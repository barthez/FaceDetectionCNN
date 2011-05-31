function [ error, cnet ] = train( cnet, IpG, IpB)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

BoostIter = 0;
ThrFa = 0.8;
error= [];
while BoostIter < 6
    BIerror = [];
    for ep =1:cnet.epochs
        fprintf('epoka = %d\n', ep);
        PatNum = 30;
        
        GoodSet = getRandSet(IpG, PatNum);
        BadSet  = getRandSet(IpB, PatNum);
        EPerror = zeros(1, 2*PatNum);
        for p = 1:PatNum
            [out, cnet] = sim(cnet, GoodSet{p});
            d = out - 1;
            cnet = adapt(cnet, d);
            
            EPerror( 2*p ) = d;
            
            [out, cnet] = sim(cnet, BadSet{p});
            d = out - 1;
            cnet = adapt(cnet, d);
            EPerror( 2*p -1 ) = out + 1;
        end
        BIerror = [BIerror, EPerror];
    end
    error = [error, BIerror];
    
    BoostIter = BoostIter +1;
    if ThrFa >= 0.2
        ThrFa = ThrFa - 0.2;
    end
  
end


end

