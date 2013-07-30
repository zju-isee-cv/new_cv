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

function plot_omni_error_rho(images,gen_KK_est,gridInfo,paramEst)

active_images = images.active_images;
ind_active = find(images.active_images);
nx = images.nx;
ny = images.ny;

ex = []; % Global error vector

if ~isfield(paramEst,'gammac')
  XI=[paramEst.xi;zeros(5,1);0;...
      gen_KK_est(1,1);gen_KK_est(2,2); ...
      gen_KK_est(1,3);gen_KK_est(2,3)];
  cc = gen_KK_est(1:2,3);
else
  XI=[paramEst.xi;paramEst.kc;paramEst.alpha_c;...
      paramEst.gammac(1);paramEst.gammac(2);...
      paramEst.cc(1);paramEst.cc(2)];
  cc = paramEst.cc;
end

RhoAbsError=[];
%RhoSphereError=[];

for kk = 1:length(ind_active)
  index = ind_active(kk);
  
  if active_images(kk) & (~isnan(paramEst.Qw{index}(1))),
    
    V = [paramEst.Qw{index};paramEst.Tw{index};XI];
    
    xp = omniCamProjection(gridInfo.X{index}, V);
    sphere_dist = sphericalDistanceFromImage(xp,gridInfo.x{index},XI);
    
    part_ex = xp-gridInfo.x{index};
    for i=1:size(gridInfo.x{index},2)
      rho = norm(gridInfo.x{index}(:,i)-cc);
      RhoAbsError = [RhoAbsError,[rho;norm(part_ex(:,i))]];
      %RhoSphereError = [RhoSphereError,[rho;sphere_dist(:,i)]];
    end
  end
end;

%avgRhoAbsError=zeros(2,100);
%avgRhoSphereError=zeros(2,100);


% $$$ for i=1:size(RhoAbsError,2)
% $$$   indexNorm=floor(RhoAbsError(1,i)/10);
% $$$   avgRhoAbsError(1,indexNorm)=avgRhoAbsError(1,indexNorm)+RhoAbsError(2,i);
% $$$   avgRhoAbsError(2,indexNorm)=avgRhoAbsError(2,indexNorm)+1;
% $$$   avgRhoSphereError(1,indexNorm)=avgRhoSphereError(1,indexNorm)+RhoSphereError(2,i);
% $$$   avgRhoSphereError(2,indexNorm)=avgRhoSphereError(2,indexNorm)+1;
% $$$ end

rhoMax = floor(max(nx,ny)/2);
window = 10;
medianRhoAbsError = zeros(1,ceil(rhoMax/window));
%medianRhoSphereError = zeros(1,ceil(rhoMax/window));

for rhos=0:window:(rhoMax-1)
  endrhos = rhos+window;
  ind = find((RhoAbsError(1,:)<endrhos)&(RhoAbsError(1,:)>=rhos));
  %if ~isempty(ind)
  medianRhoAbsError(floor(rhos/window)+1) = median(RhoAbsError(2,ind));
  %end
  
  %ind = find((RhoSphereError(1,:)<endrhos)&(RhoSphereError(1,:)>=rhos));
  %if ~isempty(ind)
  %medianRhoSphereError(floor(rhos/window)+1) = median(RhoSphereError(2,ind));
  %end
end

%avgRhoAbsError=avgRhoAbsError(1,:)./avgRhoAbsError(2,:);
%avgRhoSphereError=avgRhoSphereError(1,:)./avgRhoSphereError(2,:);
rhos=0:window:(rhoMax-1);

figure(4)
hold on
%title('Erreur euclidienne entre les points dans l''image')

plot(RhoAbsError(1,:),RhoAbsError(2,:),'mx')
%plot(rhos,avgRhoAbsError(1,:),'g')
plot(rhos,medianRhoAbsError,'b')
xlabel('\rho')
ylabel('Errors in pixels')
%axis([200, 650, 0, 1])
axis square
hold off


%figure(5)
%hold on
%title('Erreur sur la sphère entre les points dans l''image')
%plot(RhoSphereError(1,:),RhoSphereError(2,:),'rx')
%plot(rhos,avgRhoSphereError(1,:),'g')
%plot(rhos,medianRhoSphereError,'b')
%xlabel('\rho')
%ylabel('Errors in radians')
%axis([200, 650, 0, 3e-3])
%axis square
%hold off
