function ch3combine=CombineImageSt(ch3,option)
if numel(ch3)>1 && iscell(ch3)
    ch3combine = ch3{1};
    for i=2:length(ch3)
        switch option
            case 2 % maximum pixel value over stacks
                ch3combine = max(ch3combine,ch3{i});
            case 3 % image fusion
                ch3combine = imfuse(ch3combine,ch3{i});
            otherwise % default, cumulative image
                ch3combine = imadd(ch3combine,ch3{i});
        end
    end
elseif numel(ch3)==1 && iscell(ch3)
    ch3combine = ch3{1};
elseif ~iscell(ch3)
    ch3combine = ch3;
end
ch3combine=ch3combine-min(ch3combine(:));
end