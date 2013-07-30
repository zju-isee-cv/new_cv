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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%    This function uses the Levenberg-Marquardt               %
%          algorithm to calculate Qw, Tw,                     %
%             P=rigid_motion(X,K) knowing P and X.            %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input :
%   V : contains an estimate for Qw, Tw and 
%       (sxi,kc,alpha,gammac,cc)
%
function [Q,T, error,k] = fastOmniPnP(points3D, points2D, V)

if nargin==0
  disp('Launching test...');
  test;
  return
end

% $$$ if(VERS=='7')
% $$$   new_proj=@(Xinput, X0) (part_omni( Xinput,[X0;V(8:17)],p,d,type));
% $$$   [X,error,k]=levenbergMarquardt(new_proj,points3D,V(1:7), ...
% $$$ 				 points2D);
% $$$ else

% Nasty hack to avoid using Matlab 7 function_handlers...
expr_f = sprintf(['part_omni_f(Xinput,Xoutput,[X0;%d;%d;%d;%d;%d;' ...
		  ' %d;%d;%d;%d;%d;%d]);'],V(8:18));
new_proj_f = inline(expr_f,'Xinput','X0','Xoutput');
expr_j = sprintf('part_omni_j(Xinput,[X0;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d]);',V(8:18));
new_proj_j = inline(expr_j,'Xinput','X0');
[X,error,k] = levenbergMarquardt6(new_proj_f,new_proj_j,points3D,V(1:7),points2D);

Q = X(1:4);
T = X(5:7);

function [P,dPdV]=part_omni( Xinput, V )
[P,dPdV] = omniCamProjection(Xinput,V);
dPdV = dPdV(:,1:7);

function test

%%% Values %%%
X=10*randn(2,10)
X=[X;ones(1,10)];
Qw=randn(4,1);
Tw=randn(3,1);

Qw=Qw/norm(Qw);
Qw
Tw

kc=[0.001;0;0;0;0];
alpha_c=0;
fc=[10;11];
cc=[900;500];

p=16.7;
d=0;
type=1;
[xi,phi] = pd2xiphi(p,d,type);
eta = xi-phi;

gammac = fc*eta;

fixed_val=[xi;kc;alpha_c;gammac;cc];

P = omniCamProjection(X,[Qw;Tw;fixed_val]);
Qw0 = [1;0;0;0];
Tw0 = [0;0;0];
[Qw2,Tw2,error,k] = fastOmniPnP(X, P, [Qw0;Tw0;fixed_val]);
%error
Qw2 = Qw2/norm(Qw2)
Tw2

if error ~= 0
  disp(['Error : 1e' slog10(error)]);
else
  disp(['Error : 0']);
end

function s=slog10(val)
s=num2str(floor(log10(val)));
