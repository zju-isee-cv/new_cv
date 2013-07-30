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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
% This function writes into a matlab ascii file      %
% the focals and principal point coordinates of the  %
% KK projection matrix and the parameters of the     %
% mirror.                                            %
%                                                    %
%                                                    %
%   Created : 09/11/2005                             %
%    Author : Christopher Mei                        %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function write_params_to_file_matlab(fileName,KK, mirror_xi, ...
				     roi_min, roi_max)

f1 = KK(1,1);
f2 = KK(2,2);
cc1 = KK(1,3);
cc2 = KK(2,3);
string_save = ['save ' fileName ' mirror_xi ' ...
		 ' f1 f2 cc1 cc2 roi_min roi_max'];

eval(string_save);
