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
%   Created : 2005                                   %
%    Author : Christopher Mei                        %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function write_params_to_file_ascii(fileName,KK, mirror_xi, ...
				    roi_min, roi_max)

fid = fopen(fileName,'w');

fprintf(fid,'%% Fixed Camera Parameters\n');
fprintf(fid,'%%\n');
fprintf(fid,['%% This script file can be directly executed under', ...
	     ' Matlab to recover the fixed parameters and the' ...
	     ' parameters of the corrected images.\n']);
fprintf(fid,'\n\n');
fprintf(fid,'%%-- Mirror parameters :\n');
fprintf(fid,'mirror_xi = %5.15f;\n',mirror_xi);
fprintf(fid,'%%-- Projection parameters :\n');
fprintf(fid,'f1 = %5.15f;\n',KK(1,1));
fprintf(fid,'f2 = %5.15f;\n',KK(2,2));
fprintf(fid,'cc1 = %5.15f;\n',KK(1,3));
fprintf(fid,'cc2 = %5.15f;\n',KK(2,3));
fprintf(fid,'%%-- Region Of Interest parameters :\n');
fprintf(fid,'roi_min = [%5.15f;%5.15f];\n',roi_min);
fprintf(fid,'roi_max = [%5.15f;%5.15f];\n',roi_max);


fclose(fid);

