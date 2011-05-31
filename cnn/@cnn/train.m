function [ error, cnet ] = train( cnet, IpG, IpB)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

BoostIter = 0;
ThrFa = 0.8;
while BoostIter < 6
    BIerror = zeros(1, cnet.epochs);
    for ep =1:cnet.epochs
        fprintf('epoka = %d\n', ep);
        PatNum = 60;
        
        GoodSet = getRandSet(IpG, PatNum);
        BadSet  = getRandSet(IpB, PatNum);
        EPerror = zeros(1, PatNum);
        for p = 1:PatNum
            [out, cnet] = sim(cnet, GoodSet{p});
            EPerror( p ) = out - 1;
            
            [out, cnet] = sim(cnet, BadSet{p});
            EPerror( p ) = out + 1;            
        end
        BIerror( ep ) = mse(EPerror);
    end
    error = [error, BIerror];
    
    BoostIter = BoostIter +1;
    if ThrFa >= 0.2
        ThrFa = ThrFa - 0.2;
    end
  
end


end

