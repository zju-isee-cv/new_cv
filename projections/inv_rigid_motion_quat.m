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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = inv_rigid_motion_quat(Y,Q,T);
% rigid_motion_quat.m
%
% X = rigid_motion_quat(Y,Q,T)
%
% Computes X from Y,Q,T such that Y = R*X+T, where R = quat2mat(Q/norm(Q)).
% ie. X=R'*Y-R'*T
%
% INPUT: Y: 3D structure in the world coordinate frame (3xN matrix for N points)
%       (Q,T): Rigid motion parameters between two frames
%                 Q: rotation quaternion (4x1 vector); T: translation vector (3x1 vector)
%
% OUTPUT: X: 3D coordinates of the structure points in the new reference frame (3xN matrix for N points)
%         
% Definitions:
% Let P be a point in 3D of coordinates X in the world reference frame (stored in the matrix X)
% The coordinate vector of P in the camera reference frame is: Y = R*X + T
% where R is the rotation matrix corresponding to the quaternion Q : R = quat2mat(Q);
%
% Important function called within that program:
%
% quat2mat.m: Computes the rotation matrix corresponding to a quaternion
%

if nargin < 3,
  T = zeros(3,1);
  if nargin < 2,
    q = [1;zeros(3,1)];
    if nargin < 1,
      disp('Launching test...');
      test
      return;
    end;
  end;
end;

switch nargout
 case 0
  X=transform(Y,Q/norm(Q),T);
 case 1
  X=transform(Y,Q/norm(Q),T);
 otherwise
  disp('Too many output args.')
end

function test
X=randn(3,2);

error=1e-4;
disp(['Error : ' num2str(error)]);

Q = randn(4,1);

disp(['Estimate error (full test) normalising : ' num2str(errorY)]);

function X=transform(Y,Q,T)
R = quat2mat(Q);
n = size(Y,2);

X = R'*Y - R'*repmat(T,[1 n]);
