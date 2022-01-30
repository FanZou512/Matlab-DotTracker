% this script calculates the mean/var of the selected data
% use output data of DotTracker
load('C:\Users\18143\Documents\data\arrest\210409_ARS\ARS423Control-1hr\output\CurveData.mat')
x=Curve.Dist;
p=Curve.DistIndex(1,:);
N=max(p(1,:));
stat_x=NaN(N,5); % arrange in [mean dist, dist std, num of data, num of colocal, fraction of co-local]
for k=1:N
    d1=x(1,p==k);
    d2=d1<0.4 & d1>=0; % 0.4um as threshold of co-localization
    n=sum(d1>=0);
    stat_x(k,:)=[nanmean(d1),nanstd(d1), n, sum(d2), sum(d2)/n];
end
% based on statistics of x, calculate the variance of fraction among replica
meanx=nanmean(stat_x(:,[1,5]),1);
stderror=nanstd(stat_x(:,[1,5]),0,1)/sqrt(N);
outputdata=[meanx(2),stderror(2),N];
all_dist=[p',x'];
all_dist(isnan(x),:)=[];