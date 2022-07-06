function [dotxyz,intRecord,dotIntensity] = linkDotToCell_SC(cellBound,dotxyz,intRecord,dotIntensity,maxN,autoFluo)
% each column of intRecord represents:
% 1st column: the "net intensity" corresponds to dots in that cell
% 2nd column: the bkg intensity
% 3rd column: total intensity of the dot (integrated volume under the dot minus the bkg)
% 4th column: the peak intensity of the dot (with bkg substracted)
% 5th column: the free protein concentration
freeCon=[];
if ~isempty(cellBound)
    dotin = inpolygon(dotxyz(:,1),dotxyz(:,2),cellBound(:,2),cellBound(:,1));%finds the dots inside each cell
    intRecord=intRecord(dotin,:);
    dotxyz=dotxyz(dotin,:);%maxStack = maxSt(dotIndex); % stack at which the dot reaches max intensity
    dotIntensity=dotIntensity(:,dotin);
    % if too many dots are found in a cell, pick the brightest few
    if ~isempty(intRecord)
        netIntensity=intRecord(:,1);
        if size(intRecord,1)> maxN
            [~,indexSort] = sort(netIntensity, 'descend' );
            intRecord=intRecord(indexSort(1:maxN),:);
            dotxyz=dotxyz(indexSort(1:maxN),:);
            dotIntensity=dotIntensity(:,indexSort(1:maxN));
        end
        % fit all the intensity points inside a cellular boundary
        % and come up with the mean Intensity.
        % Note: this method is only suitable when the GFP has relatively
        % even distribution inside the cell.
        bkgIntensity=intRecord(:,2);
        freeCon = int_con_conversion2(bkgIntensity,autoFluo);
    end
else
    dotxyz=[];intRecord=[];dotIntensity=[];
end
intRecord=[intRecord,freeCon];
end