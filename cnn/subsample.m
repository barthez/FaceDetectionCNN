 function out = subsample(in, height, width)
    out = zeros( floor(size(in,1)/height), floor(size(in,2)/width));
    for x = 1:height
       for y = 1:width
           a = in((1+x-1):height:size(in,1),(1+y-1):width:size(in,2));
           out = out + a(1:size(out,1),1:size(out,2) );
       end
    end
 end