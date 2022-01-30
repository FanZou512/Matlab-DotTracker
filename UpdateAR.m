function AR=UpdateAR(AR,pos)
for kp=1:numel(pos)
    AR.DotInfo(kp).frames=pos(kp).frames;
    ObjNum=numel(pos(kp).object);
    AR.FileInfo.ObjectNum(kp)=ObjNum;
    for ko=1:ObjNum
        AR.DotInfo(kp).object(ko).budTime=pos(kp).object(ko).budTime;
        AR.DotInfo(kp).object(ko).divisionTime=pos(kp).object(ko).divisionTime;
        AR.DotInfo(kp).object(ko).birth=pos(kp).object(ko).birth;
        AR.DotInfo(kp).object(ko).mother=pos(kp).object(ko).mother;
        AR.DotInfo(kp).object(ko).daughterList=pos(kp).object(ko).daughterList;
        FrameNum=numel(pos(kp).object(ko).frame);
        if ~isfield(AR.DotInfo(kp).object(ko).frame,'DotList')
            AR.DotInfo(kp).object(ko).frame(1).DotList=[];
        end
        if ~isfield(AR.DotInfo(kp).object(ko).frame,'AutoContrast')
            AR.DotInfo(kp).object(ko).frame(1).AutoContrast=[];
        end
        if ~isfield(AR.DotInfo(kp).object(ko).frame,'MinDis')
            AR.DotInfo(kp).object(ko).frame(1).MinDis=[];
        end
        for kf=1:FrameNum
            AR.DotInfo(kp).object(ko).frame(kf).x=pos(kp).object(ko).frame(kf).x;
            AR.DotInfo(kp).object(ko).frame(kf).y=pos(kp).object(ko).frame(kf).y;
            AR.DotInfo(kp).object(ko).frame(kf).ox=pos(kp).object(ko).frame(kf).ox;
            AR.DotInfo(kp).object(ko).frame(kf).oy=pos(kp).object(ko).frame(kf).oy;
            AR.DotInfo(kp).object(ko).frame(kf).area=pos(kp).object(ko).frame(kf).area;
        end
    end
end
end