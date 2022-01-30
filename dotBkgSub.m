% take the image near the dot
% interpolate the background intensity
% calculate the total dot intensity

function [totalIntensity,bkg, peakIntensity,bkgImg] = dotBkgSub(origImg,dotx,doty,dotSize,option)

if nargin<5
    option = 0;
end

[lengthY,lengthX]=size(origImg);
fullGrid = [];
bkgGrid = [];
for i=1:lengthX
    for j=1:lengthY
        fullGrid = [fullGrid;[i,j]];
        disToDot = sqrt((i-dotx)^2+(j-doty)^2);
        if disToDot > dotSize
            bkgGrid = [bkgGrid;[i,j,origImg(j,i)]];
        end
    end
end

bkgGrid = double(bkgGrid);
Vq = griddata(bkgGrid(:,1),bkgGrid(:,2),bkgGrid(:,3),fullGrid(:,1),fullGrid(:,2),'v4');
bkgImg = reshape(Vq,lengthY,lengthX);
totalIntensity = sum(sum(origImg))-sum(sum(bkgImg));
peakIntensity = max(max(origImg)) - bkgImg(int32(doty),int32(dotx));
bkg = pointsInRing(origImg, 0,dotSize,dotx,doty);
%[intensity,total1] = pointsInRing(origImg,0,dotSize,dotx,doty);
%[intensity,total2] = pointsInRing(bkgImg,0,dotSize,dotx,doty);
%totalIntensity = total1-total2;

if option
    figure();
    subplot(1,2,1)
    imshow(origImg,[min(min(origImg)),max(max(origImg))]);
    subplot(1,2,2)
    imshow(bkgImg,[min(min(origImg)),max(max(origImg))]);
end