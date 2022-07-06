function [ch3combine,dotxyz,intRecord,dotIntensity] = morphImgsFISH_SC_max(ch3,threshold,dotSize,B,maxN,autoFluo,rect)
% **************** single cell version ****************
% these are all "initial guess of the dot size" not accurate
% intRecord: [net, bkg, total, peak intensity, free protein]
% dotxyz: [cell_id, x, y, z stack]
% dotIntensity: original fluo over stacks for each dot, arrange in colums
% rect: a given region for dot searching
length_ch3=numel(ch3);
ch3combine = ch3{1};
for i=2:length_ch3
    ch3combine = ch3combine + ch3{i};
end
%ch3combine=double(ch3combine);
dotxyz=[];intRecord=[];dotIntensity=[];
CellNum=numel(B);
for k=1:CellNum
    cellBound = B{k};
    if ~isempty(cellBound)
        chcombsub=imcrop(ch3combine,rect);% region of single cell
        [dotxyzt,intRecordt,dotIntensityt]=morphImgsFISH_core(ch3,chcombsub,threshold,dotSize,rect);
        [dotxyzt,intRecordt,dotIntensityt]=linkDotToCell_SC(cellBound,dotxyzt,intRecordt,dotIntensityt,maxN,autoFluo);
        dotxyz=[dotxyz;k*ones(size(dotxyzt,1),1),dotxyzt];
        intRecord=[intRecord;intRecordt];
        dotIntensity=[dotIntensity;dotIntensityt'];
        disp(['Cell ',num2str(k),' contains ',num2str(size(dotxyzt,1)),' dots'])
    end
end
end

function [dotxyz,intRecord,dotIntensity]=morphImgsFISH_core(ch3,chcombsub0,threshold,dotSize,rect)
[r,c]=size(chcombsub0);r=floor(min(r,c)*0.17*4);
dSize=min(3,r); % estimated size of the dot, avoid error in small pic
bSize2=min(9,r*4); % backgroud ring
bSize1=min(7,bSize2-2);
% find the center of dots use the cropped image
T=double(quantile(chcombsub0(:),threshold))/65535;
chcombsub=im2bw(chcombsub0,T);
ch3dots = bwareaopen(chcombsub,5,4); % Remove small objects from binary image, use 4-connection
[~,L3,~,~] = bwboundaries(ch3dots);% trace region boundaries in binary image
dots = regionprops(L3,chcombsub0-T*65535,'WeightedCentroid');
centers = cat(1,dots.WeightedCentroid);
if ~isempty(centers)
    centers(isnan(centers(:,1)),:)=[];
end
if ~isempty(centers)
    dotx = centers(:,2);
    doty = centers(:,1);
else % if dot is not detected from image morphology operation, find the max pixel instead
    [c,dotx]=max(chcombsub0);
    [~,doty]=max(c);dotx=dotx(doty);
end
dotx=dotx+rect(2)-1;doty=doty+rect(1)-1; % transform back to the coordinates of the original image

% calculate dotIntensity
N_st=numel(ch3);
dotIntensity = zeros(N_st,length(dotx));bkgIntensity=dotIntensity;
dotTotal =zeros(N_st,length(dotx));

for k=1:N_st
    currentImg = ch3{k};    
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
    origImg = ch3{dotz(k)};
    lowBound1 = max(int32(doty(k)-2.5*dotSize),1);
    highBound1 = min(int32(doty(k)+2.5*dotSize),size(origImg,2));
    lowBound2 = max(int32(dotx(k)-2.5*dotSize),1);
    highBound2 = min(int32(dotx(k)+2.5*dotSize),size(origImg,1));
    origImgSub = origImg(lowBound2:highBound2,lowBound1:highBound1);
    [dotMax(k), bkg(k), peakIntensity(k), ~] = dotBkgSub(origImgSub,double(2.5*dotSize),double(2.5*dotSize),double(dotSize));
    netIntensity(k) = dotMax(k) /pi/dotSize^2; % mean intensity of the pixels inside dot
end
%intRecord = [netIntensity',bkg',dotMax',peakIntensity',tempN'];
intRecord = [netIntensity(:),background(:),dotMax(:),peakIntensity(:)];
dotxyz=[dotx,doty,dotz(:)];
end