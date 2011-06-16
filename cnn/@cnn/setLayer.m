function cnet = setLayer( cnet, LNum, type, IH, IW, TF, FMs, CM )
%SETFUNCTION Summary of this function goes here
%   Detailed explanation goes here
        cnet.Layer{LNum}.type = type;
        cnet.Layer{LNum}.InputHeight = IH;
        cnet.Layer{LNum}.InputWidth = IW;
        cnet.Layer{LNum}.TransferFunction = TF;
        cnet.Layer{LNum}.FMapNum = FMs;
        cnet.Layer{LNum}.ConMap = CM;
end

