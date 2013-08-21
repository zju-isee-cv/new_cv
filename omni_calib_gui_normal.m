function omni_calib_gui_normal

missing = 1;

cell_list = {};

%-------- Begin editable region -------------%
%-------- Begin editable region -------------%
if(~exist('paramEst3D', 'var'))
    paramEst3D = [];
end

fig_number = 1;
title_figure = 'Non-central Catadioptric Camera Calibration Toolbox - Improved Version by ISEE ZJU';

cell_list{1,1} = {'Mirror type','paramEst3D = mirror_type();'};
cell_list{1,2} = {'Load images','images = data_calib();'};
cell_list{1,3} = {'Estimate camera intri.',['check_border_estimate;'... ...
		    'if ~missing '...
		    '[gen_KK_est,borderInfo] =' ...
		    ' border_estimate(images,paramEst3D);'...
		    'end' ]};

cell_list{1,4} = {'Extract grid corners manually',['check_click_calib;'...
		    'if ~missing '...
		    '[gridInfo,paramEst3D]  ='...
		    'extract_grid_corners(images,gen_KK_est,gridInfo,paramEst3D);'...
		    'end']};

cell_list{2,1} = {'Initialize and assign RT',['check_click_calib;'...
		    'if ~missing '...
		    'paramEst3D  ='...
		    'est_RT(gridInfo, gen_KK_est, paramEst3D);'...
		    'end']};
cell_list{2,2} = {'Calibration with new methods',['check_calib_optim;biased_calib=1;' ...
		    'if ~missing '...
		    '[images, paramEst3D] = go_omni_calib_optim_iter3D(minInfo,images,gen_KK_est,gridInfo,paramEst3D);'...
		    'end']};
cell_list{2,3} = {'Calib new RT',['check_calib_optim;biased_calib=1;' ...
		    'if ~missing '...
		    '[gridInfo, paramEst3D] = calib_new_RT(images, gen_KK_est, gridInfo, paramEst3D);'...
		    'end']};
cell_list{2,4} = {'Rm Calibration',['check_calib_optim;'...
		    'if ~missing '...
		    'paramEst3D = rm_calib(paramEst3D);'...
		    'end']};
                
cell_list{3,1} = {'Draw Grid Estimate',['check_click_calib;'...
		  'if ~missing '...
		  'drawImageWithPoints(images,gen_KK_est,gridInfo,paramEst3D);'...
		  'end']};
cell_list{3,2} = {'Analyse error',['check_calib_optim;'...
		    'if ~missing '...
		    'analyse_error(images,gridInfo,paramEst3D);'...
		    'end']};
 cell_list{3,3} = {'Analysis_angle',['check_click_calib;'...
		    'if ~missing '...
		    'data_analysis( paramEst3D);'...
		    'end']};
 cell_list{3,4} = {'Show calib results','show_calib_results(images,gen_KK_est,gridInfo, paramEst3D);'};
             
 cell_list{4,1} = {'Save','save_omni_calib(minInfo,borderInfo,images,gen_KK_est,gridInfo,paramEst3D);'};
 cell_list{4,2} = {'Load','load_omni_calib;'};
 cell_list{4,3} = {'Exit',['disp(''Bye. To run again, type omni_calib_gui.''); close(' num2str(fig_number) ');']}; %{'Exit','calib_gui;'};
show_window(cell_list,fig_number,title_figure);


%-------- End editable region -------------%
%-------- End editable region -------------%




%------- DO NOT EDIT ANYTHING BELOW THIS LINE -----------%

function show_window(cell_list,fig_number,title_figure,x_size,y_size,gap_x,font_name,font_size)


if ~exist('cell_list'),
    error('No description of the functions');
end;

if ~exist('fig_number'),
    fig_number = 1;
end;
if ~exist('title_figure'),
    title_figure = '';
end;
if ~exist('x_size'),
    x_size = 125;
end;
if ~exist('y_size'),
    y_size = 16;
end;
if ~exist('gap_x'),
    gap_x = 0;
end;
if ~exist('font_name'),
    font_name = 'clean';
end;
if ~exist('font_size'),
    font_size = 8;
end;

figure(fig_number); clf;
pos = get(fig_number,'Position');

[n_row,n_col] = size(cell_list);

fig_size_x = x_size*n_col+(n_col+1)*gap_x;
fig_size_y = y_size*n_row+(n_row+1)*gap_x;

set(fig_number,'Units','points', ...
	       'BackingStore','off', ...
	       'Color',[0.8 0.8 0.8], ...
	       'MenuBar','none', ...
	       'Resize','off', ...
	       'Name',title_figure, ...
	       'Position',[pos(1) pos(2) fig_size_x fig_size_y], ...
	       'NumberTitle','off'); %,'WindowButtonMotionFcn',['figure(' num2str(fig_number) ');']);

h_mat = zeros(n_row,n_col);

posx = zeros(n_row,n_col);
posy = zeros(n_row,n_col);

for i=n_row:-1:1,
  for j = n_col:-1:1,
    posx(i,j) = gap_x+(j-1)*(x_size+gap_x);
    posy(i,j) = fig_size_y - i*(gap_x+y_size);
  end;
end;

%disp('ok');

for i=n_row:-1:1,
    for j = n_col:-1:1,
        if ~isempty(cell_list{i,j}),
            if ~isempty(cell_list{i,j}{1}) & ~isempty(cell_list{i,j}{2}),
                h_mat(i,j) = uicontrol('Parent',fig_number, ...
                    'Units','points', ...
                    'Callback',cell_list{i,j}{2}, ...
                    'ListboxTop',0, ...
                    'Position',[posx(i,j)  posy(i,j)  x_size   y_size], ...
                    'String',cell_list{i,j}{1}, ...
                    'fontsize',font_size,...
                    'fontname',font_name,...
                    'Tag','Pushbutton1');
            end;
        end;
    end;
end;

%------ END PROTECTED REGION ----------------%
