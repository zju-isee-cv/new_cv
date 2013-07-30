function P=part_omni_f( Xinput, Xoutput, V )
P = omniCamProjection(Xinput,V)-Xoutput;
P = reshape(P,size(P,2)*size(P,1),1);
