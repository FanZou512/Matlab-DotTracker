function [ch3combine,dotxyz,intRecord,dotIntensity] = morphImgsFISH_Add(ch3,threshold,dotSize)
% single cell version
% these are all "initial guess of the dot size" not accurate
length_ch3=numel(ch3);
ch3combine = ch3{1};
for i=2:length_ch3
    ch3combine = ch3combine + ch3{i};
end
[dotxyz,intRecord,dotIntensity]=morphImgsFISH_core(ch3,ch3combine,threshold,dotSize);
end

function [dotxyz,intRecord,dotIntensity]=morphImgsFISH_core(ch3,chcombsub,threshold,dotSize)
dSize = 5; % estimated size of the dot
bSize1 = 14; 
bSize2 = 16; % backgroud ring
% find the center of dots
T=double(quantile(chcombsub(:),threshold))/65535;
chcombsub=imbinarize(chcombsub,T);
ch3dots = bwareaopen(chcombsub,5,4); %Remove small objects from binary image
[~,L3,~,~] = bwboundaries(ch3dots);%trace region boundaries in binary image
dots = regionprops(L3,'centroid');
centers = cat(1,dots.Centroid);
if ~isempty(centers)
    dotx = centers(:,2);
    doty = centers(:,1);
else % if dot is not detected from image morphology operation, find the max pixel instead
    [c,dotx]=max(chcombsub);
    [~,doty]=max(c);dotx=dotx(doty);
end

%finds the dots inside each cell
dotin = inpolygon(doty,dotx,cellBound(:,2),cellBound(:,1));
dotIndex = find(dotin);

% calculate dotIntensity
dotIntensity = zeros(length(ch3),length(dotx));bkgIntensity=dotIntensity;
dotTotal =zeros(length(ch3),length(dotx));
ch3IntensityImgs=ch3;% = {};

for k=1:length(ch3IntensityImgs)
    currentImg = ch3IntensityImgs{k};    
    for p=1:length(dotx) 
       [dotIntensity(k,p),dotTotal(k,p)] = pointsInRing(currentImg,0,dSize,round(dotx(p)),round(doty(p))); % dot intensity within a circle
       [bkgIntensity(k,p)] = pointsInRing(currentImg,bSize1,bSize2,round(dotx(p)),round(doty(p))); % background intensity
    end
end
% note: this dotIntensity is only used to find z where dot intensity reaches max, not the intensity in the output.
% However, the bkgIntensity is used in the output
[~,dotz] = max(dotIntensity);
background=zeros(length(dotz),1); dotMax=background; bkg =background; peakIntensity =background; netIntensity=background;

for k=1:length(dotz)
    background(k) = bkgIntensity(dotz(k),k);
    %dotMax(i) = (maxIntensity(i)-background(i))*pi*dSize^2;
    origImg = ch3IntensityImgs{dotz(k)};
    lowBound1 = max(int32(doty(k)-2.5*dotSize),1);
    highBound1 = min(int32(doty(k)+2.5*dotSize),size(origImg,2));
    lowBound2 = max(int32(dotx(k)-2.5*dotSize),1);
    highBound2 = min(int32(dotx(k)+2.5*dotSize),size(origImg,1));
    origImgSub = origImg(lowBound2:highBound2,lowBound1:highBound1);
    [dotMax(k), bkg(k), peakIntensity(k), ~] = dotBkgSub(origImgSub,double(2.5*dotSize),double(2.5*dotSize),double(dotSize));
    netIntensity(k) = dotMax(k) /pi/dotSize^2; % mean intensity of the pixels inside dot
end
%intRecord = [netIntensity',bkg',dotMax',peakIntensity',tempN'];
intRecord = [netIntensity',background',dotMax',peakIntensity'];
dotxyz=[dotx,doty,dotz(:)];
end