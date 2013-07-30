function D=fullSphereDistance(V,X,x,mirror_p,mirror_d,mirror_type)

D=[];

for i=1:size(X,2)
  D = [D; ...
       sphericalDistanceProjection(-X{i},x{i},...
				   [V(10+7*(i-1)+1 : 10+7*(i-1)+7);V(1:10)],...
				   mirror_p, mirror_d, mirror_type)'.^2];
end

D=mean(D);
