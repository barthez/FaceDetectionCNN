 function y = fastFilter2(b,x,shape)
%The same as filter2 function, but without routine
 y = conv2(x,rot90(b,2),shape); 
 end