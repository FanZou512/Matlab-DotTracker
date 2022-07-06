function [ch3combine,dotxyz,intRecord,dotIntensity] = morphImgsFISH_SC(ch3,threshold,dotSize,B,maxN,autoFluo)
% **************** single cell version ****************
% these are all "initial guess of the dot size" not accurate
% intRecord: [net, bkg, total, peak intensity, free protein]
% dotxyz: [cell_id, x, y, z stack]
% dotIntensity: original fluo over stacks for each dot, arrange in colums
length_ch3=numel(ch3);
ch3combine = ch3{1};
%[r1_img,r2_img]=size(ch3combine);
for i=2:length_ch3
    ch3combine = max(ch3combine, ch3{i}); % ch3combine+ch3{i} % add method % max() % max method
end
%ch3combine=double(ch3combine);
dotxyz=[];intRecord=[];dotIntensity=[];
CellNum=numel(B);
T0=double(quantile(ch3combine(:),1-(1-threshold)*max(CellNum/200,1)))/65535; % global threshold
disp(['global threshold ',num2str(T0)])
for k=1:CellNum
    cellBound = B{k};
    if ~isempty(cellBound)
        x=max(floor(min(cellBound)),[1,1]);
        rect=[x,ceil(max(cellBound))-x];
        chcombsub=imcrop(ch3combine,rect);% region of single cell
        if ~isempty(chcombsub) & size(chcombsub,1)>=dotSize & size(chcombsub,2)>=dotSize
        [dotxyzt,intRecordt,dotIntensityt,T]=morphImgsFISH_core(ch3,chcombsub,threshold,dotSize,rect,T0);
        if ~isempty(dotxyzt)
            [dotxyzt,intRecordt,dotIntensityt]=linkDotToCell_SC(cellBound,dotxyzt,intRecordt,dotIntensityt,maxN,autoFluo);
            bo=mean(cellBound);
            dist=sqrt(sum((dotxyzt(:,[2,1])-repmat(bo,[size(dotxyzt,1),1])).^2,2));
            x=(max(rect(3:4))/2-dist)>=2;
            dotxyzt=dotxyzt(x,:);intRecordt=intRecordt(x,:);dotIntensityt=dotIntensityt(:,x);
            if size(dotxyzt,1)>1
                [~,x]=max(intRecordt(:,1));
                dotxyzt=dotxyzt(x,:);intRecordt=intRecordt(x,:);dotIntensityt=dotIntensityt(:,x);
            end
        end
        end
        dotxyz=[dotxyz;k*ones(size(dotxyzt,1),1),dotxyzt]; 
        intRecord=[intRecord;intRecordt];
        dotIntensity=[dotIntensity;dotIntensityt'];
        %disp(['Cell ',num2str(k),' threshold ',num2str(T),' contains ',num2str(size(dotxyzt,1)),' dots'])
    end
end
end

function [dotxyz,intRecord,dotIntensity,T]=morphImgsFISH_core(ch3,chcombsub0,threshold,dotSize,rect,T0)
[r,c]=size(chcombsub0);r=floor(min(r,c)*0.17);
dSize=min(3,r); % estimated size of the dot, avoid error in small pic
bSize2=min(9,r*4); % backgroud ring
bSize1=min(7,bSize2-2);
% find the center of dots
T=double(quantile(chcombsub0(:),max(threshold,dotSize/r/c)))/65535;
% modify T, determine T is too low or high based on global T0
%if true || T<T0
    %T=T0;
%end
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
%else % if dot is not detected from image morphology operation, find the max pixel instead
    %[c,dotx]=max(chcombsub0);
    %[~,doty]=max(c);dotx=dotx(doty);
%end
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
else
    dotxyz=[];intRecord=[];dotIntensity=[];
end
end