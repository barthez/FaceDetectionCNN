function out = rand_std(w, h, numinp) 

  sigma = numinp^(-1/2);
  out = (rand(w,h) - ones(w,h)/2);

  if(w*h>1)
    outstd = mean(std(reshape(out,1,[])));      

  else
      outstd=1;
  end
  out = out*sigma/outstd;
