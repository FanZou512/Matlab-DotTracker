function [ch3combine,intRecord,dotIntensity] = morphImgsFISH4(ch3,dotx,doty,dotz,dotSize)

% these are all "initial guess of the dot size" not accurate
dSize = 6; % estimated size of the dot
bSize1 = 14; 
bSize2 = 16; % backgroud ring

length_ch3=numel(ch3);

ch3combine = ch3{1} + ch3{2};
for i=3:length(ch3)
    ch3combine = ch3combine + ch3{i};
end
ch3combine=double(ch3combine);
ch3combine=(ch3combine-min(ch3combine(:)))/max(ch3combine(:));
% calculate dotIntensity

dotIntensity = zeros(length(ch3),length(dotx));
dotTotal = zeros(length(ch3),length(dotx));

for k=1:length(ch3)
    currentImg = ch3{k};    
    for j=1:length(dotx)  
       [dotIntensity(k,j),dotTotal(k,j)] = pointsInRing(currentImg,0,dSize,round(dotx(j)),round(doty(j))); % dot intensity within a circle
       [bkgIntensity(k,j)] = pointsInRing(currentImg,bSize1,bSize2,round(dotx(j)),round(doty(j))); % background intensity
    end
end
% note: this dotIntensity is only used to find at which z the dot intensity
% reaches max; this is NOT the final dot intensity in the output.
% However, the bkgIntensity is used in the output
%[maxIntensity,dotz] = max(dotIntensity);
bkg = []; peakIntensity = []; netIntensity=[];  background=[]; dotMax=[];

for i=1:length(dotz)
    background(i) = bkgIntensity(dotz(i),i);
    %dotMax(i) = (maxIntensity(i)-background(i))*pi*dSize^2;
    origImg = ch3{dotz(i)};
    lowBound1 = max(int32(doty(i)-2.5*dotSize),1);
    highBound1 = min(int32(doty(i)+2.5*dotSize),size(origImg,2));
    lowBound2 = max(int32(dotx(i)-2.5*dotSize),1);
    highBound2 = min(int32(dotx(i)+2.5*dotSize),size(origImg,1));
    origImgSub = origImg([lowBound2:highBound2],[lowBound1:highBound1]);
    [dotMax(i), bkg(i), peakIntensity(i), bkgImg] = dotBkgSub(origImgSub,double(2.5*dotSize),double(2.5*dotSize),double(dotSize));
    netIntensity(i) = dotMax(i) /pi/dotSize^2; % mean intensity of the pixels inside dot
end
%intRecord = [netIntensity',bkg',dotMax',peakIntensity',dotz'];
intRecord = [netIntensity',background',dotMax',peakIntensity'];
end