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
%   Builds the jacobian for the minimisation  %
%    of the reprojection error in the image   %
%                                             %
%   Created : 2005 (mod 13/03/06)             %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Input :
%
% Output :
%   sfx : fonction evaluation
%   ex3 : J'*sfx
%   JJ3 : J'J jacobian
%
function [sfx,ex3,JJ3, Jout] = buildJacobian(n_ima, gridInfo, param, ind_active)

makeSparse = 0;
Jout = [];
if makeSparse
  JJ3 = sparse([],[],[],11 + 7*n_ima, 11 + 7*n_ima,126*n_ima + 100);
else
  JJ3 = zeros(11+7*n_ima, 11+7*n_ima);
end

ex3 = zeros(11 + 7*n_ima,1);
sfx=[];
for kk = ind_active
  [xp,Jx] = omniCamProjection(gridInfo.X{kk},[param(11+7*(kk-1)+1 : 11+7*(kk-1)+7);param(1:11)]);
  
  
  exkk = xp-gridInfo.x{kk};
  [nlines,ncols] = size(exkk);
  exkk = reshape(exkk,ncols*nlines,1);
  
  sfx = [sfx;exkk];    
  A = Jx(:,8:18); %intrinsic
  B = Jx(:,1:7); %extrinsic
  JoutL = zeros((size(A,1)), 11+7*n_ima);
  JoutL(:,1:11) = A;
  JoutL(:,(11+7*(kk-1)+1:11+7*(kk-1)+7)) = B;
  Jout = [Jout;JoutL];
  
  
  if makeSparse
    JJ3(1:11,1:11) = JJ3(1:11,1:11) + sparse(A'*A);
    JJ3(11+7*(kk-1) + 1: 11+7*(kk-1) + 7,...
	11+7*(kk-1) + 1: 11+7*(kk-1) + 7) = sparse(B'*B);
    
    AB=sparse(A'*B);
  else
    JJ3(1:11,1:11) = JJ3(1:11,1:11) + A'*A;
    JJ3(11+7*(kk-1) + 1: 11+7*(kk-1) + 7,...
	11+7*(kk-1) + 1: 11+7*(kk-1) + 7) = B'*B;
    
    AB=A'*B;
  end
  JJ3(1:11, 11+7*(kk-1) + 1:11+7*(kk-1) + 7) = AB;
  JJ3(11+7*(kk-1) + 1:11+7*(kk-1) + 7, 1:11) = AB';
  
  ex3(1:11) = ex3(1:11) + A'*exkk;
  ex3(11+7*(kk-1) + 1:11+7*(kk-1) + 7) = B'*exkk;
end
