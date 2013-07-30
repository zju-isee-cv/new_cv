% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation, version 2.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software Foundation,
% Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Levenberg-Marquardt algorithm          %
%                                             %
%   Created : 2005                            %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Xk,error,k]=levenbergMarquardtcmei(gx,Xinput,X0,Xoutput)

if nargin~=4
  disp('Lauching test...')
  test;
  return
end

fx=@(Xinput,X0) (diffG(gx,Xinput,X0,Xoutput));

%Iteration maximum
kmax=40;
%Threshold of the conditioning of the matrix
cond_thresh=1e-30;
warning('off','MATLAB:nearlySingularMatrix')

%Error approximation
emax1=1e-8;
emax2=1e-10;
taux=0.01;

nbParam=size(X0,1);

%Start Levenberg-Marquardt method
k=0;
nu=2;
Xk=X0;
Xkp1=X0;
[sfx,Jx]=fx(Xinput,X0);

A=Jx'*Jx;     
g=Jx'*sfx;

found=(max(abs(g))<emax1);
mu=taux*max(max(A));

while not(found) && (k<kmax)
  k=k+1;
  [Xk,sfx,A,g,mu,nu,found]=mainIteration(fx,Xinput,Xk,sfx,A,g,emax1,emax2,cond_thresh,mu,nu,nbParam);
end
error=norm(fx(Xinput,Xk));

function test
SOL=[-1;-2;1;-1];
fprintf('Looking for eq : %2.2f*exp(%2.2f*x)+%2.2f*exp(%2.2f*x)\n',SOL(3),SOL(1),SOL(4),SOL(2));

X0=[-0.2;-2.6;0.2;-1.5];
fprintf('Starting from X0=[%2.2f,%2.2f,%2.2f,%2.2f]\n',X0(3),X0(1),X0(4),X0(2));
Xoutput=cal(SOL);
Xinput=Xoutput(:,1);
Xoutput=Xoutput(:,2);


t=Xinput;
y=Xoutput;
%plot(t,y,'x');

[X0,error,k]=levenbergMarquardt(@fitexp,Xinput,X0,Xoutput);

fprintf('Found X=[%2.2f,%2.2f,%2.2f,%2.2f]\n',X0(3),X0(1),X0(4), ...
	X0(2));
fprintf('Error=1e%s\n',slog10(error));
fprintf('Nb iterations=%d\n',k);

function ty=cal(X)
ty=[linspace(0,3,50)',zeros(50,1)];

for i=1:50
  ty(i,2)=(X(3)*exp(X(1)*ty(i,1))+X(4)*exp(X(2)*ty(i,1)));
end

function [f,J]=fitexp(Xinput, Xk)
E=exp(Xinput*[Xk(1),Xk(2)]);
f=E*[Xk(3);Xk(4)];
J=[Xk(3)*Xinput.*E(:,1),Xk(4)*Xinput.*E(:,2),E];

function [sfx,Jx]=diffG(gx,Xinput,X0,Xoutput)
[sfx,Jx]=gx(Xinput,X0);
sfx=sfx-Xoutput;
[nlines,ncols]=size(sfx);
if nlines>ncols
  sfx=sfx';
  [nlines,ncols]=size(sfx);
end
if ncols~=1
  sfx=reshape(sfx,ncols*nlines,1);
end

function value=gain(hlm,mu,g)
value=1/2*hlm'*(mu*hlm-g);

function s=slog10(val)
s=num2str(floor(log10(val)));

function [Xk,sfx,A,g,mu,nu,found]=mainIteration(fx,Xinput,Xk,sfx,A,g,emax1,emax2,cond_thresh,mu,nu,nbParam)
Inv=A+mu*eye(nbParam);

if rcond(Inv)<cond_thresh
  disp('Matrix badly conditionned, stopping...')
  found=1;
  return
end
hlm=-inv(Inv)*g;

if 0%norm(hlm)<=emax2*(norm(Xk)+emax2)
  found=1;
  display('out!')
  Xkp1=Xk;
else
  Xkp1=Xk+hlm;
  sfxp1=fx(Xinput, Xkp1);
  sFx=norm(sfx)^2;
  sFxp1=norm(sfxp1)^2;
  
  quote=(sFx-sFxp1)/gain(hlm,mu,g);

  if quote>0
    Xk=Xkp1;
    sfx=sfxp1;
    [sfx,Jx]=fx(Xinput,Xk);
    A=Jx'*Jx;
    g=Jx'*sfx;
    found=max(abs(g))<emax1;
    mu=mu*max(1/3,1-(2*quote-1)^3);
    nu=2;  
  else
    mu=mu*nu;
    nu=2*nu;
    found=0;
  end
end
