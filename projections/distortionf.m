function P=distortionf(K,X,Xoutput)
P=reshape(distortion(X,K),size(Xoutput,1)*size(Xoutput,2),1)-Xoutput;
