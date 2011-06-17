function [ cnet ] = adapt( cnet, d )
%ADAPT Summary of this function goes here
%   Detailed explanation goes here

n = cnet.LayersNum;


                %fprintf('size X = (%d, %d)\n', size() );
                
                
for it = n:-1:1
    for f = 1:cnet.Layer{it}.FMapNum
        %fprintf('--------------------- Layer %d, fMap %2d, Type %c ---------------------\n', it, f, cnet.Layer{it}.type );
        cnet.Layer{it}.dEdX{f} = 0.0;
        if n == it
            cnet.Layer{it}.dEdX{f} = mse('dy' , d, cnet.Layer{it}.Y{f}, cnet.Layer{it}.X{f}, 'mse');
            %cnet.Layer{it}.dEdX{f}
        else
            for c=find( cnet.Layer{it+1}.ConMap(:,f) )'
                if cnet.Layer{it+1}.type == 'n'
                    cnet.Layer{it}.dEdX{f} = cnet.Layer{it}.dEdX{f} + cnet.Layer{it+1}.W{c}(:,:,f) .* cnet.Layer{it+1}.dEdY{c}; 
                elseif cnet.Layer{it+1}.type == 's'
                    
                    cnet.Layer{it}.dEdX{f} = cnet.Layer{it}.dEdX{f} + ...
                        subsample( cnet.Layer{it+1}.W{c} .* cnet.Layer{it+1}.dEdY{c}, ...
                                   cnet.Layer{it+1}.InputHeight, ...
                                   cnet.Layer{it+1}.InputWidth, ...
                                   0);
                elseif cnet.Layer{it+1}.type == 'c'
                    cnet.Layer{it}.dEdX{f} = cnet.Layer{it}.dEdX{f} + ...
                        conv2(cnet.Layer{it+1}.dEdY{c}, ...
                              cnet.Layer{it+1}.W{c}(:,:,f), ...
                              'full');
                end
            end
            %fprintf('size X = (%d, %d)\n', size(cnet.Layer{it}.X{f}) );
            %fprintf('size dEdX = (%d, %d)\n', size(cnet.Layer{it}.dEdX{f}) );
        end

        cnet.Layer{it}.dXdY{f} = feval(cnet.Layer{it}.TransferFunction,'dn',cnet.Layer{it}.Y{f},cnet.Layer{it}.X{f});
            
        cnet.Layer{it}.dEdY{f} = cnet.Layer{it}.dXdY{f}.*cnet.Layer{it}.dEdX{f};
        
        if  size(cnet.Layer{it}.dEdY{f},1) == 0
            fprintf('Cos sie dzieje\n');
        end
        
        if cnet.Layer{it}.type == 'n' % Warstwa typu N
                     
            
            cnet.Layer{it}.dEdW{f} = zeros( size( cnet.Layer{it}.W{f} ) );
            %fprintf('*** L: %d\n', it);
            %size(cnet.Layer{it}.dEdW{f})
            for c=find( cnet.Layer{it}.ConMap(f,:) )
                %fprintf('---\n');
                %size(cnet.Layer{it}.dEdY{f})
                %size(cnet.Layer{it -1}.X{c})
                if size(cnet.Layer{it}.dEdY{f},1) > 0
                    cnet.Layer{it}.dEdW{f}(:,:,c) = cnet.Layer{it}.dEdY{f} .* cnet.Layer{it -1}.X{c}; 
                end
            end
            
            cnet.Layer{it}.dEdB{f} = cnet.Layer{it}.dEdY{f};
            
        elseif cnet.Layer{it}.type == 's'  % Warstwa subsamplingu

           
            
            cnet.Layer{it}.dEdW{f} = zeros( size( cnet.Layer{it}.W{f} ) );

            for c=find( cnet.Layer{it}.ConMap(f,:) )
                cnet.Layer{it}.dEdW{f} = cnet.Layer{it}.dEdY{f} .* subsample(cnet.Layer{it -1}.X{c}, cnet.Layer{it}.InputHeight, cnet.Layer{it}.InputWidth); 
            end
            cnet.Layer{it}.dEdW{f} = mean(mean(cnet.Layer{it}.dEdW{f}));
            cnet.Layer{it}.dEdB{f} = mean(mean(cnet.Layer{it}.dEdY{f}));
        elseif cnet.Layer{it}.type == 'c'% Warstwa typu konwolucyjnego
            
            cnet.Layer{it}.dEdW{f} = zeros( size( cnet.Layer{it}.W{f} ) );
            
            if it == 1
                XX = cnet.Ip;
            else
                XX = cnet.Layer{it -1}.X;
            end
            
            for c=find( cnet.Layer{it}.ConMap(f,:) )
                
                cnet.Layer{it}.dEdW{f}(:,:,c) = conv2(XX{c}, cnet.Layer{it}.dEdY{f}, 'valid' ); 
            end
            
            cnet.Layer{it}.dEdB{f} = mean(mean(cnet.Layer{it}.dEdY{f}));
        end
        %fprintf('D = %.5f\n', dd);
        %cnet.Layer{it}.W{f} = cnet.Layer{it}.W{f} + cnet.Layer{it}.teta * cnet.Layer{it}.d{f} * ones( size ( cnet.Layer{it}.W{f} ) );
    end
   
end

for it=1:n
    for f = 1:cnet.Layer{it}.FMapNum
        %fprintf(' - ADAPT: Layer %d, fMap %2d, Type %c #\n', it, f, cnet.Layer{it}.type );
       %fprintf('size X = (%d, %d)\n', size(cnet.Layer{it}.W{f} ) );
       %fprintf('size X = (%d, %d)\n', size(cnet.Layer{it}.dEdW{f} ) );
       cnet.Layer{it}.W{f} = cnet.Layer{it}.W{f} - cnet.theta .* cnet.Layer{it}.dEdW{f};
       cnet.Layer{it}.B{f} = cnet.Layer{it}.B{f} - cnet.theta .* cnet.Layer{it}.dEdB{f};
       
    end
end

end

