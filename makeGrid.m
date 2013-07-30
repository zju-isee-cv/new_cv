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

function pts=makeGrid(n_sq_x,n_sq_y,dX,dY)
x_l = dX*(0:n_sq_x)'*ones(1,n_sq_y+1); %the x coordinates
y_l = dY*ones(n_sq_x+1,1)*(0:n_sq_y); %the y coordinates
pts = [y_l(:) x_l(:) zeros((n_sq_x+1)*(n_sq_y+1),1)]';%return the points of the grid
