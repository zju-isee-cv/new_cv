% Modified version of 'analyse_error' from JYB
%
% The errors in X and Y of the pixel projections are plotted
% to identify incorrect extractions.
%
% Using arrays and no longer X_i, x_i, ... values
%

function analyse_error(images,gridInfo,paramEst)

biased_calib = 1;

if ~isfield(paramEst,'gammac')
  fprintf(1,'You should start by calibrating the sensor.');
  return
end

n_ima = images.n_ima;
ex = paramEst.ex;
y = paramEst.y;
active_images = images.active_images;

if n_ima ~=0,
  if biased_calib
    if ~exist('ex')
      fprintf(1,['Need to calibrate before analysing reprojection' ...
		 ' error or load a Calib_Results.mat file.\n']);
      return
    end
  else
    if ~exist('ex_sphere_pix_'),
      fprintf(1,['Need to calibrate before analysing reprojection' ...
		 ' error or load a Calib_Results.mat file.\n']);
      return
    end
  end
end


if ~exist('no_grid'),
  no_grid = 0;
end

colors = 'brgkcm';


figure(5);

for kk = 1:n_ima,
  if exist('y')& active_images(kk) &~isempty(y{kk})
    if active_images(kk) & ~isnan(y{kk}(1,1)),
      
      if ~no_grid,
	XX_kk = gridInfo.X{kk};
	N_kk = size(XX_kk,2);
	
	if ~isempty(gridInfo.n_sq_x{kk})
	  no_grid = 1;
	end
	
	if ~no_grid
	  n_sq_x = gridInfo.n_sq_x{kk};
	  n_sq_y = gridInfo.n_sq_y{kk};
	  if (N_kk ~= ((n_sq_x+1)*(n_sq_y+1))),
	    no_grid = 1;
	  end
	end
      end
      
      if biased_calib
	plot(ex{kk}(1,:)',ex{kk}(2,:)',[colors(rem(kk-1,6)+1) '+']);
      else
	plot(exsphere_pix{kk}(1,:)',exsphere_pix{kk}(2,:)', ...
	     [colors(rem(kk-1,6)+1) '+']);
      end
      
      hold on;
    end
  end
end

hold off;
axis('equal');
if 1, %~no_grid,
  title('Reprojection error (in pixel) - To exit: right button');
else
  title('Reprojection error (in pixel)');   
end
xlabel('x');
ylabel('y');

set(5,'color',[1 1 1]);
set(5,'Name','error','NumberTitle','off');

ex_mat = cell2mat(ex);

if n_ima == 0,  
  text(.5,.5,'No image data available','fontsize',24,'horizontalalignment' ,'center');
else
  if biased_calib
    err_std = std(ex_mat')';
    fprintf(1,'Pixel error:          err = [ %3.5f  ] (all active images)\n\n',err_std); 
  else
    err_std_sphere_pix = std(ex_sphere_pix')';
    fprintf(1,'Pixel error:          err = [ %3.5f  ] (all active images)\n\n',err_std_sphere_pix); 
  end
  
  b = 1;

  while b==1,
    
    [xp,yp,b] = ginput3(1);
    
    if b==1,
      if biased_calib
        ddd = (ex_mat(1,:)-xp).^2 + (ex_mat(2,:)-yp).^2;
      else
        ddd = (ex_sphere_pix(1,:)-xp).^2 + (ex_sphere_pix(2,:)-yp).^2;
      end
        
      [mind,indmin] = min(ddd);
        
        
        done = 0;
        kk_ima = 1;
        while (~done)&(kk_ima<=n_ima),
	  %fprintf(1,'%d...',kk_ima);
	  
	  if biased_calib
	    ex_kk = ex{kk_ima};
	    sol_kk = find((ex_kk(1,:) == ex_mat(1,indmin))&(ex_kk(2,:) == ex_mat(2,indmin)));
	  else
	    ex_kk = exsphere_pix{kk_ima};
	    sol_kk = find((ex_kk(1,:) == exsphere_pix(1,indmin))&(ex_kk(2,:) == exsphere_pix(2,indmin)));
	  end
	  
	  if isempty(sol_kk),
	    kk_ima = kk_ima + 1;
	  else
	    done = 1;
	  end
        end
        
        xkk = gridInfo.x{kk_ima};
        xpt = xkk(:,sol_kk);
        
        if ~no_grid
            
	  n_sq_x = gridInfo.n_sq_x{kk_ima};
	  n_sq_y = gridInfo.n_sq_y{kk_ima};
	  
	  Nx = n_sq_x+1;
	  Ny = n_sq_y+1;
            
	  y1 = floor((sol_kk-1)./Nx);
	  x1 = sol_kk - 1 - Nx*y1; %rem(sol_kk-1,Nx);
            
	  y1 = (n_sq_y+1) - y1;
	  x1 = x1 + 1;
            
	  fprintf(1,'\n');
	  fprintf(1,'Selected image: %d\n',kk_ima);
	  fprintf(1,'Selected point index: %d\n',sol_kk);
	  fprintf(1,'Pattern coordinates (in units of (dX,dY)): (X,Y)=(%d,%d)\n',[x1-1 y1-1]);
	  fprintf(1,['Image coordinates (in pixel): (%3.2f,' ...
		     ' %3.2f)\n'],[xpt']); 
	  if biased_calib
	    fprintf(1,'Pixel error = (%3.5f,%3.5f)\n',[ex_mat(1,indmin) ex_mat(2,indmin)]);
	  else
	    fprintf(1,'Pixel error = (%3.5f,%3.5f)\n', ...
		    [ex_sphere_pix(1,indmin) ex_sphere_pix(2,indmin)]);
	  end
        else
	  
	  fprintf(1,'\n');
	  fprintf(1,'Selected image: %d\n',kk_ima);
	  fprintf(1,'Selected point index: %d\n',sol_kk);
	  fprintf(1,'Image coordinates (in pixel): (%3.2f,%3.2f)\n',[xpt']);
	  
	  if biased_calib
	    fprintf(1,'Pixel error = (%3.5f,%3.5f)\n',[ex_mat(1,indmin) ex_mat(2,indmin)]);
	  else
	    fprintf(1,'Pixel error = (%3.5f,%3.5f)\n',[ex_sphere_pix(1,indmin) ex_sphere_pix(2,indmin)]);
	  end
        end
        
        
        if isfield(gridInfo,'wintx')&~isempty(gridInfo.wintx{kk_ima})&~isnan(gridInfo.wintx{kk_ima})
	  
	  wintx = gridInfo.wintx{kk_ima};
	  winty = gridInfo.winty{kk_ima};
            
	  fprintf(1,'Window size: (wintx,winty) = (%d,%d)\n',[wintx winty]);
        end
	
    end
    
end

disp('done');

end

