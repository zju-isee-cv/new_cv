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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                             %
%   Removes the estimated parameters          %
%                                             %
%   Created : 2005 (mod 13/03/06)             %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Input : paramEst
%
% Output : paramEst
%
function paramEst = rm_calib(paramEst)

if isfield(paramEst,'kc')
  paramEst = rmfield(paramEst,'kc');
end

if isfield(paramEst,'alpha_c')
  paramEst = rmfield(paramEst,'alpha_c');
end

if isfield(paramEst,'gammac')
  paramEst = rmfield(paramEst,'gammac');
end

if isfield(paramEst,'cc')
  paramEst = rmfield(paramEst,'cc');
end
