function cnet=subsasgn(cnet,index,val)
%SUBSASGN Assign fields of a neural network.

if(length(index)==1)
    switch (index.subs)
        case 'numLayers'
           cnet.numLayers = val;
        case 'numSLayers'
           cnet.numSLayers = val;
        case 'numCLayers'
            cnet.numCLayers = val;
        case 'numFLayers'
            cnet.numFLayers = val;
        case 'numInputs'
            cnet.numInputs = val;
        case 'InputWidth'
            cnet.InputWidth = val;
        case 'InputHeight'
            cnet.InputHeight = val;
        case 'numOutputs'
            cnet.numOutputs = val;
        case 'Perf'
            cnet.Perf = val;
        case 'teta'
            cnet.teta = val;
        case 'mu'
            cnet.mu = val;            
        case 'mu_dec'
            cnet.mu_dec = val;
        case 'mu_inc';
            cnet.mu_inc = val;            
        case 'mu_max';
            cnet.mu_max = val;            
        case 'epochs';
            cnet.epochs = val;            
        case 'goal';
            cnet.goal = val; 
        case 'teta_dec';
            cnet.teta_dec = val; 
        case 'HcalcMode';
            cnet.HcalcMode = val;
        case 'Hrecalc';
            cnet.Hrecalc = val; 
        case 'HrecalcSamplesNum';
            cnet.HrecalcSamplesNum = val; %Number of samples for Hessian recalculation
            
        otherwise
            error('Unknown 1st level field');
    end
end

if(length(index)==2)
    disp 'Wrong indexing'
end

if(length(index)==3)
    switch (index(1,1).subs)
        case 'SLayer'
            switch (index(1,3).subs) 
                case 'SRate'
                    cnet.SLayer{index(1,2).subs{1}}.SRate = val;
                case 'TransfFunc'
                    cnet.SLayer{index(1,2).subs{1}}.TransfFunc = val;
                case 'numFMaps'
                    cnet.SLayer{index(1,2).subs{1}}.numFMaps = val;    
                case 'FMapWidth'
                    cnet.SLayer{index(1,2).subs{1}}.FMapWidth = val; 
                case 'FMapHeight'
                    cnet.SLayer{index(1,2).subs{1}}.FMapHeight = val;
                case 'teta'
                    cnet.SLayer{index(1,2).subs{1}}.teta = val;
                case 'mu'
                    cnet.SLayer{index(1,2).subs{1}}.mu = val;

                otherwise
                    error('Unknown 2nd level field');

            end
        case 'CLayer'
            switch (index(1,3).subs) 
                case 'numKernels'
                    cnet.CLayer{index(1,2).subs{1}}.numKernels = val;
                case 'KernWidth'
                    cnet.CLayer{index(1,2).subs{1}}.KernWidth = val;
                case 'KernHeight'
                    cnet.CLayer{index(1,2).subs{1}}.KernHeight = val;                    
                case 'numFMaps'
                    cnet.CLayer{index(1,2).subs{1}}.numFMaps = val;    
                case 'FMapWidth'
                    cnet.CLayer{index(1,2).subs{1}}.FMapWidth = val; 
                case 'FMapHeight'
                    cnet.CLayer{index(1,2).subs{1}}.FMapHeight = val;
                case 'teta'
                    cnet.CLayer{index(1,2).subs{1}}.teta = val; 
                case 'mu'
                    cnet.CLayer{index(1,2).subs{1}}.mu = val;    
                case 'ConMap'
                    cnet.CLayer{index(1,2).subs{1}}.ConMap = val;  
                    %Update everything that depends on this map
                    cnet = init(cnet);
                otherwise
                    error('Unknown 2nd level field');

            end

        case 'FLayer'
            switch (index(1,3).subs) 
                case 'numNeurons'
                    cnet.FLayer{index(1,2).subs{1}}.numNeurons = val;
                case 'TransfFunc'
                    cnet.FLayer{index(1,2).subs{1}}.TransfFunc = val;
                case 'W'
                    cnet.FLayer{index(1,2).subs{1}}.W = val;    
                case 'B'
                    cnet.FLayer{index(1,2).subs{1}}.B = val; 
                case 'X'
                    cnet.FLayer{index(1,2).subs{1}}.X = val;                     
                case 'Y'
                    cnet.FLayer{index(1,2).subs{1}}.Y = val;  
                case 'teta'
                    cnet.FLayer{index(1,2).subs{1}}.teta = val; 
                case 'mu'
                    cnet.FLayer{index(1,2).subs{1}}.mu = val;                     
                otherwise
                    error('Unknown 2nd level field');
            end
            
    end
end


if(length(index)==4)
    switch (index(1,1).subs)
        case 'SLayer'
            switch (index(1,3).subs) 
                case 'WS'
                    cnet.SLayer{index(1,2).subs{1}}.WS{index(1,4).subs{1}} = val;
                case 'BS'
                    cnet.SLayer{index(1,2).subs{1}}.BS{index(1,4).subs{1}} = val;
                case 'XS'
                    cnet.SLayer{index(1,2).subs{1}}.XS{index(1,4).subs{1}} = val;
                case 'YS'
                    cnet.SLayer{index(1,2).subs{1}}.YS{index(1,4).subs{1}} = val;
                case 'SS'
                    cnet.SLayer{index(1,2).subs{1}}.SS{index(1,4).subs{1}} = val;

                case 'dEdX'
                    cnet.SLayer{index(1,2).subs{1}}.dEdX{index(1,4).subs{1}} = val;
                case 'dEdY'
                    cnet.SLayer{index(1,2).subs{1}}.dEdY{index(1,4).subs{1}} = val;
                case 'dXdY'
                    cnet.SLayer{index(1,2).subs{1}}.dXdY{index(1,4).subs{1}} = val;
                case 'dEdW'
                    cnet.SLayer{index(1,2).subs{1}}.dEdW{index(1,4).subs{1}} = val;
                case 'dEdB'
                    cnet.SLayer{index(1,2).subs{1}}.dEdB{index(1,4).subs{1}} = val;
                case 'dEdX_last'
                    cnet.SLayer{index(1,2).subs{1}}.dEdX_last{index(1,4).subs{1}} = val;  
                case 'H'
                    cnet.SLayer{index(1,2).subs{1}}.H{index(1,4).subs{1}} = val;                     
                otherwise
                    error('Unknown 3rd level field');

            end
        case 'CLayer'
            switch (index(1,3).subs) 
                case 'WC'
                    cnet.CLayer{index(1,2).subs{1}}.WC{index(1,4).subs{1}} = val;
                case 'BC'
                    cnet.CLayer{index(1,2).subs{1}}.BC{index(1,4).subs{1}} = val;
                case 'XC'
                    cnet.CLayer{index(1,2).subs{1}}.XC{index(1,4).subs{1}} = val;
                case 'YC'
                    cnet.CLayer{index(1,2).subs{1}}.YC{index(1,4).subs{1}} = val;
                case 'dEdX'
                    cnet.CLayer{index(1,2).subs{1}}.dEdX{index(1,4).subs{1}} = val;
                case 'dEdY'
                    cnet.CLayer{index(1,2).subs{1}}.dEdY{index(1,4).subs{1}} = val;
                case 'dXdY'
                    cnet.CLayer{index(1,2).subs{1}}.dXdY{index(1,4).subs{1}} = val;
                case 'dEdW'
                    cnet.CLayer{index(1,2).subs{1}}.dEdW{index(1,4).subs{1}} = val;
                case 'dEdB'
                    cnet.CLayer{index(1,2).subs{1}}.dEdB{index(1,4).subs{1}} = val;
                case 'dEdX_last'
                    cnet.CLayer{index(1,2).subs{1}}.dEdX_last{index(1,4).subs{1}} = val;  
                case 'H'
                    cnet.CLayer{index(1,2).subs{1}}.H{index(1,4).subs{1}} = val;                            
                otherwise
                    error('Unknown 3rd level field');

            end

        case 'FLayer'
            switch (index(1,3).subs) 
                case 'W'
                    cnet.FLayer{index(1,2).subs{1}}.WS{index(1,4).subs{1}} = val;
                case 'B'
                    cnet.FLayer{index(1,2).subs{1}}.BS{index(1,4).subs{1}} = val;
                case 'X'
                    cnet.FLayer{index(1,2).subs{1}}.X{index(1,4).subs{1}} = val;
                case 'Y'
                    cnet.FLayer{index(1,2).subs{1}}.Y{index(1,4).subs{1}} = val;
                case 'dEdX'
                    cnet.FLayer{index(1,2).subs{1}}.dEdX{index(1,4).subs{1}} = val;
                case 'dEdY'
                    cnet.FLayer{index(1,2).subs{1}}.dEdY{index(1,4).subs{1}} = val;
                case 'dXdY'
                    cnet.FLayer{index(1,2).subs{1}}.dXdY{index(1,4).subs{1}} = val;
                case 'dEdW'
                    cnet.FLayer{index(1,2).subs{1}}.dEdW{index(1,4).subs{1}} = val;
                case 'dEdB'
                    cnet.FLayer{index(1,2).subs{1}}.dEdB{index(1,4).subs{1}} = val;
                case 'dEdX_last'
                    cnet.FLayer{index(1,2).subs{1}}.dEdX_last{index(1,4).subs{1}} = val;  
                case 'H'
                    cnet.FLayer{index(1,2).subs{1}}.H{index(1,4).subs{1}} = val;                         
                otherwise
                    error('Unknown 3rd level field');

            end
            
    end
end

if(length(index)>4) error('Index too big');
 end

