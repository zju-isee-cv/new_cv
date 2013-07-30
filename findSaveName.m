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
% Looks for a new name to avoid crushing old  %
%                 data                        %
%                                             %
%   Created : 2005                            %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cont_save = findSaveName(save_name)

if exist([ pwd '/' save_name '.mat'])==2,
  disp(['WARNING: File ',save_name,'.mat already exists']);

  if exist('copyfile')==2,
    base_save_name = save_name;
    pfn = -1;
    cont = 1;
    
    while cont,
      pfn = pfn + 1;
      postfix = ['_old_' num2str(pfn)];
      save_name = [ base_save_name postfix];
      cont = (exist([ save_name '.mat'])==2);
    end;
    
    copyfile([base_save_name '.mat'],[save_name '.mat']);
    
    disp(['Copying the current ' base_save_name '.mat file to ' save_name '.mat']);
    
    if exist([base_save_name '.m'])==2,
      copyfile([base_save_name '.m'],[save_name '.m']);
      disp(['Copying the current ' base_save_name '.m file to ' save_name '.m']);
    end;
    cont_save = 1;
    else
      disp(['The file ' save_name '.mat is about to be changed.']);
      cont_save = input('Do you want to continue? ([]=no,other=yes) ','s');
      cont_save = ~isempty(cont_save);
  end;
else
  cont_save = 1;
end
