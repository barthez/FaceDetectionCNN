 function out = subsample(in, height, width, f)
    if nargin < 4
        f = 1;
    end
    
    if f == 1
        out = zeros( floor(size(in,1)/height), floor(size(in,2)/width));
        for x = 1:height
           for y = 1:width
               a = in(x:height:size(in,1),y:width:size(in,2));
               out = out + a(1:size(out,1),1:size(out,2) );
           end
        end

        out = out/(height*width);
    else
        out = zeros( size(in,1)*height, size(in,2)*width );
        for x = 1:height
           for y = 1:width
               out(x:height:size(out,1), y:width:size(out,2)) = in;
           end
        end
    end
 end