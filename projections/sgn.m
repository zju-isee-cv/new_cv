% Signum function (for our purposes)
function s=sgn(x)
  s=sign(x);
  s=s+(s==0);
