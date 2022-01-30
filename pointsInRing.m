function [intensity,total,inIndex] = pointsInRing(A, innerR,outerR,centerX,centerY,plotoption)
% POINTSINRing Identify points lying inside a ring
% if innerR=0, then the points are in a circle
% A is the image data

if nargin< 6
    plotoption = 0;
end

[n,m]=size(A);
l=0;
if max(1,centerX-outerR)>=min(centerX+outerR,n) || max(1,centerY-outerR)>=min(centerY+outerR,m)  
    max(1,centerX-outerR),min(centerX+outerR,n)
    max(1,centerY-outerR),min(centerY+outerR,m)  
end
for x = max(1,centerX-outerR):min(centerX+outerR,n)
   for y = max(1,centerY-outerR):min(centerY+outerR,m)
    dist = sqrt((centerX - x)^2 + (centerY - y)^2); % distance calc.
    if dist>=innerR && dist<outerR
        l=l+1;
        inx(l) = x;
        iny(l) = y;
        temp(l)=A(int32(x),int32(y));
    end
   end
end

inIndex = [inx',iny'];
% Find points inside circle

intensity = mean(temp);
total = sum(temp);

if plotoption
    showRange = 30;
    A2 = A([int32(centerX-showRange):int32(centerX+showRange)],[int32(centerY-showRange):int32(centerY+showRange)]);
    for i=1:l
        A(inx(i),iny(i)) = 0;
    end
    A3 = A([centerX-showRange:centerX+showRange],[centerY-showRange:centerY+showRange]);
    figure();
    subplot(2,1,1);
    imshow(A2,[]);
    subplot(2,1,2);
    imshow(A3,[]);
end
    

