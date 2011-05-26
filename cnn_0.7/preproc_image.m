function pi = preproc_image(id)
%Preprocess single image

%    ind = find(~isnan(id(:,:,1)));
%    Inorm = zeros(size(id(:,:,1)));
%    Inorm(ind) = 255;
%    Inorm = Inorm';
   ind = find(isnan(id(:,:,1)));
   Inorm = id(:,:,1);
   Inorm(ind) = 1;
   Inorm = abs(id(:,:,1)-1)';
   randd = zeros(32,32);
   randd(3:30,3:30)=Inorm;

    

   pi = reshape(mapstd(reshape(randd,1,[])),32,32);

end