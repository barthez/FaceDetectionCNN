min=2;
max=-2;
for i=1:550,
  x=sim(cnet,double((imread(sprintf('../faces/face_%04d.bmp', i)))));
  if x>max
      max=x;
      imax=i;
  end
  if x<min
      min=x;
      imin=i;
  end
end
min
imin
max
imax
fmin=2;
fmax=-2;
for i=1:550,
  x=sim(cnet,double((imread(sprintf('../non_faces/img_%04d.bmp', i)))));
  if x>fmax
      fmax=x;
      ifmax=i;
  end
  if x<fmin
      fmin=x;
      ifmin=i;
  end
end
fmin
ifmin
fmax
ifmax
