function [dist] = PairwiseDist(xyz,chn)
% xyz=[x,y,z], calculate the distance between each pair of positions
% sort the dot distance
% Old camera at 1024*1344 resolution, the conversion is 0.06um, but fluo used 512*672
% PVCam new camera pixel size is 11um, at 1000*1000, it is 0.06*11/6.45=0.1023um
N=size(xyz,1);
dist=NaN(N*(N-1)/2,1);
k=1;
if nargin<2
    chn=1:N;
end
for k1=1:N-1
    for k2=k1+1:N
        if chn(k1)~=chn(k2)
            dist(k)=sqrt(sum((xyz(k1,:)-xyz(k2,:)).^2))*0.129;
            k=k+1;
        end
    end
end
dist=sort(dist);
end
