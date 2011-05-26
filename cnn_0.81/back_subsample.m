 function out = back_subsample(e, ratio) 
 %back_subsample backpropagate error through subsample layers 
%
%  Syntax
%  
%    out = back_subsample(e, ratio)
%    
%  Description
%   Input:
%    e - error map
%    ratio - expansion ratio
%
%   Output:
%    out - backpropagated error map with size ratio*size(e)
%
%(c) Sirotenko Mikhail, 2009
        switch ratio
            case 4
                out = 0;
                for k=1:4
                    for l=1:4
                        out(1+(k-1):4:size(e,1)*4,1+(l-1):4:size(e,2)*4) = e;
                    end
                end
              %  out = out.*0.0625;


            case 2
                out(1:2:size(e,1)*2,1:2:size(e,2)*2)=e;
                out(1:2:size(e,1)*2,2:2:size(e,2)*2)=e;
                out(2:2:size(e,1)*2,1:2:size(e,2)*2)=e;
                out(2:2:size(e,1)*2,2:2:size(e,2)*2)=e;
               % out=out.*0.25;
            case 1
                out = e;
            otherwise disp('Unsupported ratio');
        end

   
    end