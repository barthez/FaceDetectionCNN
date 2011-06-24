function [ out, cnet ] = sim( cnet, input, debug )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3 
    debug = 0;
end

Ip{1} = input;
cnet.Ip{1} = input;

if debug == 1
    figure;
end

    for it = 1:cnet.LayersNum
        
       cnet.Layer{it}.Y = num2cell( zeros(1, cnet.Layer{it}.FMapNum) );
       cnet.Layer{it}.X = num2cell( zeros(1, cnet.Layer{it}.FMapNum) );
       
        for fm = 1:cnet.Layer{it}.FMapNum
            
            if cnet.Layer{it}.type == 's'
                SS = 0;
                for m=find(cnet.Layer{it}.ConMap(fm, :))
                   SS = SS + subsample(Ip{m}, cnet.Layer{it}.InputHeight, cnet.Layer{it}.InputWidth);
                end
                cnet.Layer{it}.Y{fm} = cnet.Layer{it}.W{fm} .* SS + cnet.Layer{it}.B{fm};
                cnet.Layer{it}.X{fm} = feval(cnet.Layer{it}.TransferFunction, cnet.Layer{it}.Y{fm});
            elseif cnet.Layer{it}.type == 'c'
                %rozmiar = size(cnet.Layer{it}.Y{fm})
                
                for m= find(cnet.Layer{it}.ConMap(fm, :));
                    %roz2 = size(conv2(Ip{m}, cnet.Layer{it}.W{fm}, 'valid'))
                    cnet.Layer{it}.Y{fm} = cnet.Layer{it}.Y{fm} + conv2(Ip{m}, cnet.Layer{it}.W{fm}(:,:,m), 'valid') ;
                end
                cnet.Layer{it}.Y{fm} = cnet.Layer{it}.Y{fm} + cnet.Layer{it}.B{fm};
                cnet.Layer{it}.X{fm} = feval(cnet.Layer{it}.TransferFunction, cnet.Layer{it}.Y{fm});
            elseif cnet.Layer{it}.type == 'n'
                for m= find(cnet.Layer{it}.ConMap(fm, :));
                    cnet.Layer{it}.Y{fm} = cnet.Layer{it}.Y{fm} + conv2(Ip{m}, cnet.Layer{it}.W{fm}(:,:,m), 'valid');
                end
                cnet.Layer{it}.Y{fm} = cnet.Layer{it}.Y{fm} + cnet.Layer{it}.B{fm};
                %fprintf('layer(%d).fmap(%d).Y = %.3f\n', it, fm, cnet.Layer{it}.Y{fm});
                cnet.Layer{it}.X{fm} = feval(cnet.Layer{it}.TransferFunction, cnet.Layer{it}.Y{fm});
                %fprintf('layer(%d).fmap(%d).X = %.3f\n', it, fm, cnet.Layer{it}.X{fm});
            end
            if debug == 1
                %fprintf(' - SIM: Layer %d, fMap %2d, Type %c #\n', it, fm, cnet.Layer{it}.type );
                subplot(6,cnet.Layer{it}.FMapNum, fm + (it-1)*cnet.Layer{it}.FMapNum);
                imshow(cnet.Layer{it}.X{fm},[]);
            end
        end
        Ip = cnet.Layer{it}.X;
    end
    
    out = cell2mat(Ip);

end

