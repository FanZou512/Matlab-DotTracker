function varargout = DotTracker(varargin)
% DOTTRACKER MATLAB code for DotTracker.fig
%      DOTTRACKER, by itself, creates a new DOTTRACKER or raises the existing
%      singleton*.
%
%      H = DOTTRACKER returns the handle to a new DOTTRACKER or the handle to
%      the existing singleton*.
%
%      DOTTRACKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOTTRACKER.M with the given input arguments.
%
%      DOTTRACKER('Property','Value',...) creates a new DOTTRACKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DotTracker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DotTracker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DotTracker

% Last Modified by GUIDE v2.5 16-Jan-2022 09:07:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DotTracker_OpeningFcn, ...
    'gui_OutputFcn',  @DotTracker_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DotTracker is made visible.
function DotTracker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DotTracker (see VARARGIN)

% Choose default command line output for DotTracker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DotTracker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DotTracker_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Position.
function Position_Callback(hObject, eventdata, handles)
% hObject    handle to Position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Position contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Position
global AR
pos = get(handles.Position,'value');% pos = ismember(AR.PositionListBox.Items, pos);
AR.FileInfo.CurrentPos=pos;
AR.FileInfo.CurrentFrame=1;
AR.FileInfo.CurrentCell=1;
set(handles.Frame,'value',1);
set(handles.Cell,'value',1);
set(handles.Frame,'string',AR.DotInfo(pos).frames);
set(handles.Cell,'string',strsplit(num2str(1:AR.FileInfo.ObjectNum(pos))));
Frame_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function Position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Frame.
function Frame_Callback(hObject, eventdata, handles)
% hObject    handle to Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Frame contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Frame
global AR
kp=AR.FileInfo.CurrentPos;
kf=get(handles.Frame,'value');
AR.FileInfo.CurrentFrame=kf;
x=AR.DotInfo(kp).frames;
if iscell(x)
    y=AR.DotInfo(kp).frames{kf}(end);
elseif ischar(x)
    y=AR.DotInfo(kp).frames(end);
end
if y=='S'
    Preview_Callback(hObject, eventdata, handles);
    PlotDotMarker(handles);
    Cell_Callback(hObject, eventdata, handles);
else % end of the frame list, go to next cell
    set(handles.Frame,'value',1);
    AR.FileInfo.CurrentCell=AR.FileInfo.CurrentCell+1;
    if AR.FileInfo.CurrentCell>AR.FileInfo.ObjectNum(kp)
        if AR.FileInfo.CurrentPos<numel(AR.FileInfo.ObjectNum)
            AR.FileInfo.CurrentCell=1;
            set(handles.Cell,'value',1);
            AR.FileInfo.CurrentPos=AR.FileInfo.CurrentPos+1;
            set(handles.Position,'value',AR.FileInfo.CurrentPos);%AR.PositionListBox.Items{AR.FileInfo.CurrentPos};
            Position_Callback(hObject, eventdata, handles);
        end
    else
        set(handles.Cell,'value',AR.FileInfo.CurrentCell);%AR.CellListBox.Value=num2str(AR.FileInfo.CurrentCell);
        Frame_Callback(hObject, eventdata, handles);
    end
end

% --- Executes during object creation, after setting all properties.
function Frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Cell.
function Cell_Callback(hObject, eventdata, handles)
% hObject    handle to Cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Cell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Cell
global AR
global GUImode
ko=get(handles.Cell,'value');
RefreshOption=AR.FileInfo.CurrentCell~=ko;
AR.FileInfo.CurrentCell=ko;
kf=AR.FileInfo.CurrentFrame;
kp=AR.FileInfo.CurrentPos;
% initialize the contrast, each row is a channel, [bkg, contrast amplifier]
if ~isfield(AR.DotInfo(kp).object(ko).frame(kf),'AutoContrast') || size(AR.DotInfo(kp).object(ko).frame(kf).AutoContrast,1)<3
    AR.DotInfo(kp).object(ko).frame(kf).AutoContrast=NaN(AR.FileInfo.ChnNum,2);
end
pc=AR.FileInfo.PhaseChn;
AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(pc,1)=AR.Settings.Offset(pc);
AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(pc,2)=AR.Settings.Contrastx(pc);
% setup the dot list
set(handles.Dot,'string',{'-'});
if isfield(AR.DotInfo(kp).object(ko).frame(kf),'DotList')
    if ~isempty(AR.DotInfo(kp).object(ko).frame(kf).DotList)
        DotList=AR.DotInfo(kp).object(ko).frame(kf).DotList;
        DotList=strsplit(num2str(DotList));
        set(handles.Dot,'value',1);
        set(handles.Dot,'string',DotList);
        % use calculated dot to set the contrast
        % plot the curve
        if AR.FileInfo.PlotOption && (ko~=AR.FileInfo.CurveObject || kp~=AR.FileInfo.CurvePos)
            PlotCurve(handles,kp,ko);
        end
    end
end
cellBound_daughter =[];
    % graph current cell image
    x=AR.DotInfo(kp).object(ko).frame(kf).x;
    y=AR.DotInfo(kp).object(ko).frame(kf).y;
    cellBound = [x',y']./AR.FileInfo.reScale;
    % find the daughter cell if exist
    kod=[AR.DotInfo(kp).object.mother];
    kod=find(kod==ko);
    if ~isempty(kod)
        kod=kod(1);
        set(handles.WorkInfo,'String',['Daughter cell is #',num2str(kod)]);
        xd=AR.DotInfo(kp).object(kod).frame(kf).x;
        yd=AR.DotInfo(kp).object(kod).frame(kf).y;
        cellBound_daughter = [xd',yd']./AR.FileInfo.reScale;
    end
    Bound=cellBound;
    if GUImode.EnableDaughter
        Bound=[Bound;cellBound_daughter];
    end
if AR.FileInfo.EnableRect
    x=max(floor(min(Bound)),[1,1]); % correct for low bound
    y=min(floor(max(Bound)),[672,512]); % correct for up bound
    AR.FileInfo.rect=[x,y-x];
    if sum(AR.FileInfo.rect>0)<4
        AR.FileInfo.rect=[];
    end
end
if ~isempty(AR.FileInfo.rect)
    if AR.FileInfo.PlotOption && ~isempty(AR.FileInfo.rect)
        PlotSingleCell(handles,cellBound,cellBound_daughter,kp,kf,ko,kod);
    end
    if RefreshOption && GUImode.FixCellCheckBox && GUImode.FixFrameCheckBox
        DisplayMultiFrame(hObject, eventdata, handles,kp,ko);
    end
end

% --- Executes during object creation, after setting all properties.
function Cell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Dot.
function Dot_Callback(hObject, eventdata, handles)
% hObject    handle to Dot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Dot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dot


% --- Executes during object creation, after setting all properties.
function Dot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AutoThresh_Callback(hObject, eventdata, handles)
% hObject    handle to AutoThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AutoThresh as text
%        str2double(get(hObject,'String')) returns contents of AutoThresh as a double
% auto threshold use to determine the magnification and background
global AR
AR.Settings.AutoThresh=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function AutoThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AutoThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bkgr_Callback(hObject, eventdata, handles)
% hObject    handle to bkgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bkgr as text
%        str2double(get(hObject,'String')) returns contents of bkgr as a double

% --- Executes during object creation, after setting all properties.
function bkgr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bkgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bkgg_Callback(hObject, eventdata, handles)
% hObject    handle to bkgg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function bkgg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bkgg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function xred_Callback(hObject, eventdata, handles)
% hObject    handle to xred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function xred_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xgreen_Callback(hObject, eventdata, handles)
% hObject    handle to xgreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function xgreen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xgreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RefreshT.
function RefreshT_Callback(hObject, eventdata, handles)
% hObject    handle to RefreshT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
ko=AR.FileInfo.CurrentCell;
kf=AR.FileInfo.CurrentFrame;
kp=AR.FileInfo.CurrentPos;
AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(2:3,:)=NaN;
Cell_Callback(hObject, eventdata, handles);

% --- Executes on button press in ResetContrast.
function ResetContrast_Callback(hObject, eventdata, handles)
% hObject    handle to ResetContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global chncombined
global AR
ko=AR.FileInfo.CurrentCell;
kp=AR.FileInfo.CurrentPos;
kf=AR.FileInfo.CurrentFrame;
rect=AR.FileInfo.rect;
ImageCombine=uint16(repmat(zeros(rect(4)+1,rect(3)+1),[1,1,3]));
ch3=imcrop(chncombined{2},rect);
[T, contrast]=AutoContrast(ch3,AR.Settings.AutoThresh-0.5);
set(handles.bkgr,'String',round(double(T)));
set(handles.xred,'String',round(double(contrast)));
ch3=imcrop(chncombined{3},rect);
[T, contrast]=AutoContrast(ch3,AR.Settings.AutoThresh);
set(handles.bkgg,'String',round(double(T)));
set(handles.xgreen,'String',round(double(contrast)));
RefreshValue_Callback(hObject, eventdata, handles);

% --- Executes on button press in RefreshValue.
function RefreshValue_Callback(hObject, eventdata, handles)
% hObject    handle to RefreshValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
ko=AR.FileInfo.CurrentCell;
kf=AR.FileInfo.CurrentFrame;
kp=AR.FileInfo.CurrentPos;
AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(2,1)=str2double(get(handles.bkgr,'String'));
AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(3,1)=str2double(get(handles.bkgg,'String'));
AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(2,2)=str2double(get(handles.xred,'String'));
AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(3,2)=str2double(get(handles.xgreen,'String'));
Cell_Callback(hObject, eventdata, handles);

% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GUImode
global AR
if GUImode.FixCellCheckBox% fix cell, go next frame
    if AR.FileInfo.CurrentFrame<AR.FileInfo.FrameNum
        set(handles.Frame,'value',AR.FileInfo.CurrentFrame+1);
    else
        set(handles.Frame,'value',1); % AR.FileInfo.CurrentCell=AR.FileInfo.CurrentCell+1;
        set(handles.Cell,'value',AR.FileInfo.CurrentCell+1);
    end
    Frame_Callback(hObject, eventdata, handles);
end

% --- Executes on button press in Add.
function Add_Callback(hObject, eventdata, handles)
% hObject    handle to Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global chn
global AR
%figure(AR.FileInfo.fig),imshow(AR.CombineImage);AR.FileInfo.fig.WindowState='maximized';rect_sub = getrect(AR.FileInfo.fig);
rect_sub = getrect;
rect=AR.FileInfo.rect;
if rect_sub(3)>1 && rect_sub(4)>1
    kc=ceil((rect_sub(2)+rect_sub(4)/2)./(rect(4)+1))+1; % determine which channel is cropped, assume fluo channels are [phase, red, green]
    kf=AR.FileInfo.CurrentFrame;
    kp=AR.FileInfo.CurrentPos;
    ko=AR.FileInfo.CurrentCell;
    dotSize=AR.Settings.DotSize(kc);
    %extra=(dotSize*4-rect_sub(3:4))/2; % Size of cropped is smaller than needed
    % transfer back to the original figure coordinates
    rect_sub=[rect_sub(1)+rect(1)-1,max(rect_sub(2)-(kc-2)*(rect(4)+1),1)+rect(2)-1,rect_sub(3:4)];
    x=AR.DotInfo(kp).object(ko).frame(kf).x./AR.FileInfo.reScale;
    y=AR.DotInfo(kp).object(ko).frame(kf).y./AR.FileInfo.reScale;
    ox=AR.DotInfo(kp).object(ko).frame(kf).ox./AR.FileInfo.reScale;
    oy=AR.DotInfo(kp).object(ko).frame(kf).oy./AR.FileInfo.reScale;
    B{1} = [(x'-ox)*1.4+ox,(y'-oy)*1.4+oy];%B{1} = [x',y'];
    Threshold=max(1-(1-AR.Settings.Threshold)*sqrt(4*2000/rect_sub(3)/rect_sub(4)),0.5); % Modified threshold
    [~,dotxyz,intRecord,dotIntensity]=morphImgsFISH_SC_max(chn(:,kc),Threshold,dotSize,B,1,AR.FileInfo.AutoFluo,rect_sub);
    DotNum=size(dotxyz,1);
    if DotNum>0
        % add to the DotChn
        set(handles.WorkInfo,'String',['Search in crop region, ',num2str(DotNum),' dots are found in channel ',num2str(kc)]);
        AR.DotInfo(kp).DotChn(kf).dot_id=[AR.DotInfo(kp).DotChn(kf).dot_id;ko*ones(DotNum,1),dotxyz(:,2:end),kc*ones(DotNum,1)];
        AR.DotInfo(kp).DotChn(kf).intRecord=[AR.DotInfo(kp).DotChn(kf).intRecord;intRecord];
        AR.DotInfo(kp).DotChn(kf).dotIntensity=[AR.DotInfo(kp).DotChn(kf).dotIntensity;dotIntensity];
        % register in the corresponding cell
        exist_dot_num=AR.DotInfo(kp).DotCounts(kf);
        AR.DotInfo(kp).object(ko).frame(kf).DotList=[AR.DotInfo(kp).object(ko).frame(kf).DotList,(exist_dot_num+1):(exist_dot_num+DotNum)];
        AR.DotInfo(kp).DotCounts(kf)=exist_dot_num+DotNum;
    end
    % refresh the current cell
    Cell_Callback(hObject, eventdata, handles);
end

% --- Executes on button press in Delete.
function Delete_Callback(hObject, eventdata, handles)
% hObject    handle to Delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
kf=AR.FileInfo.CurrentFrame;
kp=AR.FileInfo.CurrentPos;
ko=AR.FileInfo.CurrentCell;
%st=AR.FileInfo.StackNum;
SelectDot = get(handles.Dot,'value');
t=get(handles.Dot,'string');
SelectDot0=str2num(t{SelectDot});
rect=AR.FileInfo.rect;
% plot a dark cross on the deleted dot
dotx=AR.DotInfo(kp).DotChn(kf).dot_id(SelectDot0,2);
doty=AR.DotInfo(kp).DotChn(kf).dot_id(SelectDot0,3);
dotchn=AR.DotInfo(kp).DotChn(kf).dot_id(SelectDot0,5);
if 0
    hold(handles.axes1, 'on');
    plot(handles.axes1,doty,dotx,'x','MarkerSize',AR.Settings.DotSize(dotchn)+4,'MarkerEdgeColor','black','LineWidth',1)
    text(doty,dotx,['  ',num2str(value)],'Color','black','FontSize',12);
    hold(handles.axes1, 'off');
end
axes(handles.axes2)
hold(handles.axes2, 'on');
dotx=dotx-rect(2)+1;
doty=doty-rect(1)+1;
dotx=[dotx;dotx+rect(4)+1];doty=[doty;doty];  % repeat dot in both channel
plot(handles.axes2,doty,dotx,'x','MarkerSize',18,'MarkerEdgeColor','white','LineWidth',2)
hold(handles.axes2, 'off');
%AR.DotInfo(kp).DotChn(kf).dot_id(SelectDot,:)=NaN;
%AR.DotInfo(kp).DotChn(kf).intRecord(SelectDote,:)=NaN;
%AR.DotInfo(kp).DotChn(kf).dotIntensity(:,SelectDot)=NaN;
%index=AR.DotInfo(kp).object(ko).frame(kf).DotList==SelectDot;
AR.DotInfo(kp).object(ko).frame(kf).DotList(SelectDot)=[];
AR.DotInfo(kp).DotChn(kf).DeleteNum=AR.DotInfo(kp).DotChn(kf).DeleteNum+1;
dotlistcontent=get(handles.Dot,'string');
if numel(dotlistcontent)==1
    dotlistcontent(1)={'-'};
else
    dotlistcontent(SelectDot)=[];
end
set(handles.Dot,'string',dotlistcontent);

% --- Executes on selection change in CurveOpt.
function CurveOpt_Callback(hObject, eventdata, handles)
% hObject    handle to CurveOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CurveOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CurveOpt
global AR
contents = cellstr(get(hObject,'String'));
value = contents{get(hObject,'Value')};
AR.FileInfo.CurveOption=value;
ko=AR.FileInfo.CurrentCell;
kp=AR.FileInfo.CurrentPos;
PlotCurve(handles,kp,ko);

% --- Executes during object creation, after setting all properties.
function CurveOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurveOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Open.
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resolution
global AR
global GUImode
resolution=[512,672];
[dname, folder]= uigetfile('C:\Users\18143\Documents\data\*.mat','Choose the timeLapse project');%Z:\Fan\CICI
set(handles.FileInfo,'String',folder);
% load the timeLapse / timeLapse_CICI file
load([folder,dname]);
%if exist('AR','var') % load analyzed CICI file
%AR.DotInfo=AR.DotInfo;AR.FileInfo=AR.FileInfo;AR.Settings=AR.Settings;AR.Annotation=AR.Annotation;
if ~exist('AR','var') || isempty(AR)
    if ~exist('timeLapse','var') % load annotated project file
        set(handles.Status,'String','No file');
        set(handles.Status,'ForegroundColor',[1 0.1 0.1]);
    else
        mkdir([folder,'output\']);
        AR.Annotation=[];
        AR.DotInfo=timeLapse.seg.pos;
        FilterCube=[timeLapse.list.filterCube];
        ColorSettings(FilterCube);
        AR.FileInfo.note={'intRecord: [netIntensity, background, dotMax, peakIntensity, tempN]';...
            'dot_id: [dot index, cell index, x-y-z positions]'};
        AR.FileInfo.TimeInterval=timeLapse.interval/60;
        AR.FileInfo.PosFolder=timeLapse.pathList.position;
        AR.FileInfo.ChnFolder=timeLapse.pathList.channels;
        AR.FileInfo.Names=timeLapse.pathList.names;
        AR.FileInfo.PosNum=numel(timeLapse.pathList.position);
        AR.FileInfo.ChnNum=numel(FilterCube);
        AR.FileInfo.PhaseChn=timeLapse.analysis.setPhaseChannel;
        AR.FileInfo.StackNum=[timeLapse.list.ZStackNumber];
        AR.FileInfo.FrameNum=numel(timeLapse.seg.pos(1).frames);%timeLapse.numberOfFrames;
        AR.FileInfo.reScale=2; % rescale the image size
        AR.FileInfo.AutoFluo=35; % AutoFluo set default to 35clear timeLapse
        AR.FileInfo.ObjectNum=zeros(AR.FileInfo.PosNum,1);
        AR.FileInfo.CurrentFrame=1;AR.FileInfo.CurrentPos=1;AR.FileInfo.CurrentCell=1;
        AR.Settings.AutoThresh=0.98;
        for kp=1:AR.FileInfo.PosNum % initializd dot list
            AR.FileInfo.ObjectNum(kp)=numel(AR.DotInfo(kp).object);
        end
        AR.FileInfo.ObjectNum=InitialRatioAnnotation(AR.FileInfo.PosNum,AR.FileInfo.ObjectNum);
        if isfield(AR.FileInfo,'SettingFile')
            %load('C:\Users\Fan\Documents\MATLAB\DotTracker\DotTracker3.0\Settings1.mat')
        else
            %load(SettingFile)
        end
        % load the setting file
        %AR.Settings.Contrastx=Contrastx;AR.Settings.Offset=Offset;AR.Settings.DotSize=DotSize;
        AR.Settings.Threshold=0.985;%This used to be Threshold, but seems good to be 0.99
        AR.Settings.AnalysisChn=[2,3];%AnalysisChn;
        AR.Settings.Contrastx=20*ones(AR.FileInfo.ChnNum,1);
        AR.Settings.Offset=50*ones(AR.FileInfo.ChnNum,1);
        AR.Settings.DotSize=6*ones(AR.FileInfo.ChnNum,1);
    end
end
AR.FileInfo.pos_selection=1:AR.FileInfo.PosNum;
AR.FileInfo.option_split_display=true;
AR.FileInfo.PlotOption=true;
GUImode.FixFrameCheckBox=false;
GUImode.FixCellCheckBox=false;
GUImode.EnableDaughter=false;
%AR.AutoTEditField.Value=AR.Settings.AutoThresh;
AR.FileInfo.MainFolder=folder;%timeLapse.realPath;
AR.FileInfo.SavingFile=[folder,'Analysis.mat'];
AR.FileInfo.CurveObject=0;
AR.FileInfo.CurvePos=0;
AR.FileInfo.EnableRect=true;
AR.FileInfo.CurveOption='Intensity';%AR.FileInfo.fig=figure();
AR.FileInfo.time=cputime;
set(handles.Position,'string',AR.FileInfo.PosFolder);
%AR.FrameListBox.ItemsData=1:AR.FileInfo.FrameNum;
%AR.ChannelDropDown.Items=strsplit(num2str(1:AR.FileInfo.ChnNum));
Position_Callback(hObject, eventdata, handles);


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
[file,path] = uiputfile([AR.FileInfo.MainFolder,'\*.mat'],'Save list as');
AR.FileInfo.SavingFile=[path,file];
AR.CombineImage=[];
save(AR.FileInfo.SavingFile,'AR');

% --- Executes on button press in Analysis.
function Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
global GUImode
set(handles.Status,'String','Busy');
set(handles.Status,'ForegroundColor',[1 0.1 0.1]);
pause(0.01)
if ~GUImode.FixFrameCheckBox  % Go through all images
    %AR.DotInfo=cell(max(AR.FileInfo.FrameNum(:,1)),AR.FileInfo.PosNum);
    for kp=AR.FileInfo.pos_selection
        AR.FileInfo.CurrentPos=kp;
        AR.FileInfo.ObjectNum(kp)=numel(AR.DotInfo(kp).object);
        for kf=1:AR.FileInfo.FrameNum
            set(handles.Frame,'value',kf);
            for ko=1:AR.FileInfo.ObjectNum(kp) % clear DotList memory
                AR.DotInfo(kp).object(ko).frame(kf).DotList=[];
                %AR.DotInfo(kp).object(ko).frame(kf).DotChn=[];
            end
            if AR.DotInfo(kp).frames{kf}(end)=='S' % if frame is annotated
                AR.FileInfo.CurrentFrame=kf;
                Preview_Callback(hObject, eventdata, handles)
                AnalyseSingleFrame(handles,kp,kf,[]);
                PlotDotMarker(handles);
                set(handles.Status,'String',[num2str(round((kf/AR.FileInfo.FrameNum+kp-1)*1000/AR.FileInfo.PosNum)/10),'%']);
            end
            pause(0.01);
        end
        save(AR.FileInfo.SavingFile,'AR');
    end
else % Apply to the current image
    kf=AR.FileInfo.CurrentFrame;
    kp=AR.FileInfo.CurrentPos;
    AR.FileInfo.ObjectNum(kp)=numel(AR.DotInfo(kp).object);
    for ko=1:AR.FileInfo.ObjectNum(kp) % clear DotList memory
        AR.DotInfo(kp).object(ko).frame(kf).DotList=[];
        %AR.DotInfo(kp).object(ko).frame(kf).DotChn=[];
    end
    Preview_Callback(hObject, eventdata, handles)
    AnalyseSingleFrame(handles,kp,kf,[]);
    PlotDotMarker(handles)
end
%set(AR.DotListBox,'Items',dotlistcontent);
set(handles.Status,'String','Ready');
set(handles.Status,'ForegroundColor',[0.1 1 0.1]);

% --- Executes on button press in Preview.
function Preview_Callback(hObject, eventdata, handles)
% hObject    handle to Preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resolution
global chn
global ImageCombine
global chncombined
global AR
global GUImode
chn=cell(max(max(AR.FileInfo.StackNum)),AR.FileInfo.ChnNum);
chncombined=cell(1,AR.FileInfo.ChnNum);
st=AR.FileInfo.StackNum;
kf=AR.FileInfo.CurrentFrame;kf=num2str(kf+10000);kf=kf(end-2:end);
pos=AR.FileInfo.CurrentPos;
ImageCombine=uint16(repmat(zeros(resolution),[1,1,3]));
for k=1:AR.FileInfo.ChnNum
    path=[AR.FileInfo.MainFolder,'\',AR.FileInfo.ChnFolder{pos,k},AR.FileInfo.Names{pos,k},'-',kf];
    if st(k)==1
        chn{1,k}=imread([path,'.jpg']);
        ch3=imresize(CombineImageSt(chn{1,k},1),resolution);
    else
        for p=1:st(k)
            chn{p,k}=imread([path,'-st',num2str(p),'.jpg']);
        end
        ch3=imresize(CombineImageSt(chn(1:st(k),k),2),resolution); % 1 add, 2 max
    end
    chncombined{k}=ch3;
    if k~=AR.FileInfo.PhaseChn
        [T, contrast]=AutoContrast(ch3,AR.Settings.AutoThresh);
        ch3=(ch3-T).*contrast; % T used to be: AR.Settings.Offset(k)
    elseif k>3
        [T, contrast]=AutoContrast(ch3,0.96);
        ch3=(ch3-T).*contrast; % T used to be: AR.Settings.Offset(k)
    else
        ch3=(ch3-AR.Settings.Offset(k)).*AR.Settings.Contrastx(k); % T used to be: AR.Settings.Offset(k)
    end
    ch3=repmat(ch3,[1,1,3]);
    ch3(:,:,1)=ch3(:,:,1).*AR.Settings.Color(k,1);
    ch3(:,:,2)=ch3(:,:,2).*AR.Settings.Color(k,2);
    ch3(:,:,3)=ch3(:,:,3).*AR.Settings.Color(k,3);
    ImageCombine=max(ImageCombine,uint16(ch3)); % imadd
end
if ~GUImode.FixCellCheckBox && ~GUImode.FixFrameCheckBox
    imshow(ImageCombine,'parent',handles.axes1)
end

% --- Executes on button press in AutoFlow.
function AutoFlow_Callback(hObject, eventdata, handles)
% hObject    handle to AutoFlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AutoFlow
global AR
value = get(hObject,'Value');
if value
    if get(handles.AnalysisCheck,'Value')
        Analysis_Callback(hObject, eventdata, handles);
    end
    if get(handles.CurveCheck,'Value')
        Dist_Callback(hObject, eventdata, handles);
        AR.FileInfo.CurveOption='Intensity';
        Curve_Callback(hObject, eventdata, handles);
        AR.FileInfo.CurveOption='TotalIntensity';
        Curve_Callback(hObject, eventdata, handles);
        AR.FileInfo.CurveOption='NetIntensity';
        Curve_Callback(hObject, eventdata, handles);
        AR.FileInfo.CurveOption='Position';
        Curve_Callback(hObject, eventdata, handles);
        AR.FileInfo.CurveOption='Background';
        Curve_Callback(hObject, eventdata, handles);
        AR.FileInfo.CurveOption='Distance';
        Curve_Callback(hObject, eventdata, handles);
        %AR.FileInfo.CurveOption='CellFluo';
        %Curve_Callback(hObject, eventdata, handles);
    end
    if get(handles.ImageCheck,'Value')
        ImageCom_Callback(hObject, eventdata, handles)
    end
    Save_Callback(hObject, eventdata, handles);
end

% --- Executes on button press in AnalysisCheck.
function AnalysisCheck_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalysisCheck


% --- Executes on button press in CurveCheck.
function CurveCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CurveCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CurveCheck


% --- Executes on button press in ImageCheck.
function ImageCheck_Callback(hObject, eventdata, handles)
% hObject    handle to ImageCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ImageCheck


% --- Executes on button press in FixCell.
function FixCell_Callback(hObject, eventdata, handles)
% hObject    handle to FixCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FixCell
global GUImode
GUImode.FixCellCheckBox=get(hObject,'Value');

% --- Executes on button press in FixFrame.
function FixFrame_Callback(hObject, eventdata, handles)
% hObject    handle to FixFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FixFrame
global GUImode
GUImode.FixFrameCheckBox=get(hObject,'Value');

% --- Executes on button press in Dist.
function Dist_Callback(hObject, eventdata, handles)
% hObject    handle to Dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
for kp=AR.FileInfo.pos_selection
    if ~isempty(AR.DotInfo(kp).DotChn)
        for kf=1:AR.FileInfo.FrameNum
            if numel(AR.DotInfo(kp).DotChn)>=kf
                dot_id=AR.DotInfo(kp).DotChn(kf).dot_id; % dot_id: [cell index, x-y-z coordinates, chn]
                for ko=1:AR.FileInfo.ObjectNum(kp)
                    dotlist=AR.DotInfo(kp).object(ko).frame(kf).DotList;
                    if isempty(dotlist)
                        AR.DotInfo(kp).object(ko).frame(kf).MinDis=NaN;
                    else
                        chn=dot_id(dotlist,end);
                        xyz=dot_id(dotlist,2:3); % 2D projection
                        pairs=min(sum(chn==2),sum(chn==3));
                        if pairs>0
                            dist = PairwiseDist(xyz,chn);
                            AR.DotInfo(kp).object(ko).frame(kf).MinDis=dist(1:pairs);
                        else
                            AR.DotInfo(kp).object(ko).frame(kf).MinDis=NaN;
                        end
                    end
                    %disp(['dot distance pos ',num2str(kp),' frame ',num2str(kf)]);
                end
            end
        end
    end
end
AR.FileInfo.CurveOption='Distance';
Curve_Callback(hObject, eventdata, handles);

% --- Executes on button press in Curve.
function Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
option=AR.FileInfo.CurveOption;
name=[AR.FileInfo.MainFolder,'output\CurveData.mat'];
index=[]; % [kp;ko]
curve=[];
for kp=AR.FileInfo.pos_selection
    if ~isempty(AR.DotInfo(kp).DotChn)
        AR.FileInfo.CurrentPos=kp;
        AR.FileInfo.ObjectNum(kp)=numel(AR.DotInfo(kp).object);
        for ko=1:AR.FileInfo.ObjectNum(kp)
            [~,y,indext]=PlotCurve(handles,kp,ko);
            curve=[curve,y];
            index=[index,indext];
        end
    end
end
%x=sum(~isnan(curve))==0;
%curve(:,x)=[];index(:,x)=[]; % delete empty traces
switch lower(option(1))
    case 'd' % min distance
        AR.FileInfo.Summary.Dist=curve;
        AR.FileInfo.Summary.DistIndex=index;
    case 'i' % intensity peak
        AR.FileInfo.Summary.PeakIntensity=curve;
        AR.FileInfo.Summary.PeakIndex=index;
    case 't' % total intensity
        AR.FileInfo.Summary.TotalIntensity=curve;
    case 'n' % net intensity
        AR.FileInfo.Summary.TotalIntensity=curve;
    case 'p' % position
        AR.FileInfo.Summary.Position_x=curve(:,1:2:end);
        AR.FileInfo.Summary.Position_y=curve(:,2:2:end);
        AR.FileInfo.Summary.PosIndex=index;
    case 'b' % background
        AR.FileInfo.Summary.Background=curve;
    case 'c' % cell fluo
        ExportFluo(hObject, eventdata, handles); % call a different
end
Curve=AR.FileInfo.Summary;
save(name,'Curve');

% --- Executes on button press in ImageCom.
function ImageCom_Callback(hObject, eventdata, handles)
% hObject    handle to ImageCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
global GUImode
set(handles.Status,'String','Busy');
set(handles.Status,'ForegroundColor',[1 0.1 0.1]);
pause(0.01)
if ~isfield(AR.FileInfo,'SaveList')
    AR.FileInfo.SaveList=cell(AR.FileInfo.PosNum,1);
end
if ~GUImode.FixCellCheckBox
    for kp=AR.FileInfo.pos_selection
        AR.FileInfo.CurrentPos=kp;
        set(handles.Position,'value',kp);
        Position_Callback(hObject, eventdata, handles);
        AR.FileInfo.ObjectNum(kp)=numel(AR.DotInfo(kp).object);
        ko_start=1;
        for ko=ko_start:AR.FileInfo.ObjectNum(kp)
            %AR.CellListBox.Value=num2str(ko);
            ExportImage(hObject, eventdata, handles,kp,ko);
            set(handles.Status,'String',[num2str(round(1000*(kp-1+ko/AR.FileInfo.ObjectNum(kp))/numel(AR.FileInfo.pos_selection))/10),'%']);
            pause(0.01);
        end
    end
else % export images for current cell
    ko=AR.FileInfo.CurrentCell;
    kp=AR.FileInfo.CurrentPos;
    ExportImage(hObject, eventdata, handles,kp,ko);
end
AR.FileInfo.EnableRect=true;
set(handles.Status,'String','Ready');
set(handles.Status,'ForegroundColor',[0.1 1 0.1]);

function PlotDotMarker(handles)
global AR
global GUImode
kf=AR.FileInfo.CurrentFrame;
kp=AR.FileInfo.CurrentPos;
if ~GUImode.FixCellCheckBox && ~GUImode.FixFrameCheckBox
    axes(handles.axes1)
    hold(handles.axes1, 'on')
    ChnNum=AR.FileInfo.ChnNum;
    for kc=1:ChnNum
        if kc==AR.FileInfo.PhaseChn % phase image channel
            color=AR.Settings.MarkerColorName{kc};
            reScale=AR.FileInfo.reScale;
            for ko=1:AR.FileInfo.ObjectNum(kp)
                if numel(AR.DotInfo(kp).object(ko).frame)>=kf && ~isempty(AR.DotInfo(kp).object(ko).frame(kf).x)
                    x=AR.DotInfo(kp).object(ko).frame(kf).x./reScale;
                    y=AR.DotInfo(kp).object(ko).frame(kf).y./reScale;
                    ox=AR.DotInfo(kp).object(ko).frame(kf).ox./reScale;
                    oy=AR.DotInfo(kp).object(ko).frame(kf).oy./reScale;
                    plot(handles.axes1,x,y,'Color',color,'LineWidth',1)
                    text(ox,oy,num2str(ko),'Color',color,'FontSize',12);
                end
            end
        end
        if 0 && ismember(kc,AR.Settings.AnalysisChn) % analyzed fluorescence channel
            if isfield(AR.DotInfo(kp),'DotChn') && ~isempty(AR.DotInfo(kp).DotChn) && isfield(AR.DotInfo(kp).DotChn(kf),'dot_id')
                color=AR.Settings.MarkerColorName{kc};
                x=AR.DotInfo(kp).DotChn(kf).dot_id(:,5)==kc;
                dotx=AR.DotInfo(kp).DotChn(kf).dot_id(x,2);
                doty=AR.DotInfo(kp).DotChn(kf).dot_id(x,3);
                %index=1:length(dotx);
                plot(handles.axes1,doty,dotx,'o','MarkerSize',AR.Settings.DotSize(kc)+6,'MarkerEdgeColor',color,'LineWidth',1)
                %for k=1:numel(dotx)
                %text(AR.axes1,doty(k),dotx(k),['  ',num2str(index(k))],'Color',color,'FontSize',12);
                %end
            end
        end
    end
    hold(handles.axes1, 'off');
end

function AnalyseSingleFrame(handles,kp,kf,kc_select)
global chn
global AR
if isempty(kc_select) % if not specify, use default, otherwise use the customized channel
    kc_select=AR.Settings.AnalysisChn;
end
reScale=AR.FileInfo.reScale; % phase image is 1024x1344, fluorescence image is 512x672, rescale is set to 2 normally
dotSize=AR.Settings.DotSize;
%threshold=AR.Settings.AutoThresh;% used to be AR.Settings.Threshold(kc) in line morphImgsFISH_SC
ObjectNum=AR.FileInfo.ObjectNum(kp);
B=cell(ObjectNum,1);%BO=B;
st=AR.FileInfo.StackNum;
for ko=1:ObjectNum % collect cell boundary information
    x=AR.DotInfo(kp).object(ko).frame(kf).x;
    y=AR.DotInfo(kp).object(ko).frame(kf).y;
    B{ko} = [x',y']./reScale;
    %ox=AR.DotInfo(kp).object(ko).frame(kf).ox;oy=AR.DotInfo(kp).object(ko).frame(kf).oy;BO{ko}=[ox,oy]./reScale;
end
AR.DotInfo(kp).DotCounts(kf)=0;
dot_id=[];intRecord=[];dotIntensity=[];
for kc=2:AR.FileInfo.ChnNum % apply to movies with 4th channel of CFP
    if ismember(kc,kc_select)
        if kc==2
            dotN=2;threshold=AR.Settings.AutoThresh; %-0.01
        else
            dotN=2;threshold=AR.Settings.AutoThresh;
        end
        [~,dotxyz,intRecordt,dotIntensityt]=morphImgsFISH_SC(chn(1:st(kc),kc),threshold,dotSize(kc),B,dotN,AR.FileInfo.AutoFluo);
        DotNum=size(dotxyz,1);
        if DotNum>0
            intRecord=[intRecord;intRecordt]; % [net, bkg, total, peak intensity, free protein]
            dotIntensity=[dotIntensity;dotIntensityt];
            dot_id=[dot_id;dotxyz,kc*ones(DotNum,1)];
            set(handles.WorkInfo,'String',{[AR.FileInfo.Names{kp,kc},' fr',num2str(kf),', ',num2str(DotNum),' dots are found']});
        end
    end
end
AR.DotInfo(kp).DotChn(kf).DeleteNum=0;
% dot_id: [cell index, x-y-z coordinates, chn],
AR.DotInfo(kp).DotChn(kf).dot_id=dot_id;
AR.DotInfo(kp).DotChn(kf).intRecord=intRecord;
AR.DotInfo(kp).DotChn(kf).dotIntensity=dotIntensity;
AR.DotInfo(kp).DotCounts(kf)=size(dot_id,1);
RegisterDot(kp,kf);

function ColorSettings(FilterCube)
global AR
N=numel(FilterCube);
AR.Settings.Color=zeros(N,3);
AR.Settings.ColorName=cell(N,1);
AR.Settings.MarkerColorName=cell(N,1);
for k=1:N
    switch FilterCube(k)
        case 1 % CFP filter
            AR.Settings.Color(k,:)=[0,1,1];AR.Settings.ColorName{k}='c';AR.Settings.MarkerColorName{k}='purple';
        case 2 % GFP filter
            AR.Settings.Color(k,:)=[0,1,0];AR.Settings.ColorName{k}='g';AR.Settings.MarkerColorName{k}='magenta';
        case 3 % venus filter
            AR.Settings.Color(k,:)=[1,1,0];AR.Settings.ColorName{k}='y';AR.Settings.MarkerColorName{k}='blue';
        case 4 % mCherry filter
            AR.Settings.Color(k,:)=[1,0,0];AR.Settings.ColorName{k}='r';AR.Settings.MarkerColorName{k}='cyan';
        case 5 % blank, for phase image
            AR.Settings.Color(k,:)=[1,1,1];AR.Settings.ColorName{k}='w';AR.Settings.MarkerColorName{k}='white';
    end
end

function RegisterDot(kp,kf)
global AR
% Add the dot list in the annotated cell
cell_id=AR.DotInfo(kp).DotChn(kf).dot_id(:,1);
cell_chn=AR.DotInfo(kp).DotChn(kf).dot_id(:,5);
for k=1:length(cell_id)
    ko=cell_id(k);
    x=AR.DotInfo(kp).object(ko).frame(kf).DotList;
    AR.DotInfo(kp).object(ko).frame(kf).DotList=[x,k];
    % calculate contrast and background
    AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(cell_chn(k),1)=AR.DotInfo(kp).DotChn(kf).intRecord(k,2);
    AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(cell_chn(k),2)=65535./AR.DotInfo(kp).DotChn(kf).intRecord(k,4);
end

function PlotSingleCell(handles,bound,bound_daughter,kp,kf,ko,kod)
global chncombined
global AR
global GUImode
rect=AR.FileInfo.rect;
ImageCombine=uint16(repmat(zeros(rect(4)+1,rect(3)+1),[1,1,3]));
for k=2:numel(chncombined) % skip ch1 as phase image not useful here
    ch3=imcrop(chncombined{k},rect);
    at=AR.Settings.AutoThresh+0*(k/100-0.03)-0.015; %5*(k/100-0.03)-0.15 single cell
    if false && ~isnan(AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(k,1))%false
        T=AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(k,1);
        contrast=AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(k,2);
    else
        [T, contrast]=AutoContrast(ch3,at);
        AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(k,1)=T;
        AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(k,2)=contrast;
    end
    ch3=(ch3-T).*contrast;
    ch3=repmat(ch3,[1,1,3]);
    ch3(:,:,1)=ch3(:,:,1).*AR.Settings.Color(k,1);
    ch3(:,:,2)=ch3(:,:,2).*AR.Settings.Color(k,2);
    ch3(:,:,3)=ch3(:,:,3).*AR.Settings.Color(k,3);
    ImageCombine=imadd(ImageCombine,uint16(ch3)); % max
end
% show the threshold used
set(handles.bkgr,'string',round(AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(2,1)));
set(handles.bkgg,'string',round(AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(3,1)));
set(handles.xred,'string',round(AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(2,2)));
set(handles.xgreen,'string',round(AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(3,2)));
AR.FileInfo.AutoContrast=[AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(2,1:2),AR.DotInfo(kp).object(ko).frame(kf).AutoContrast(3,1:2)];
% Show channels separately
x=bound(:,1)-rect(1)+1;y=bound(:,2)-rect(2)+1;
ID_dot4cell=AR.DotInfo(kp).object(ko).frame(kf).DotList;
dotx=[];chn_dot4cell=[];
if isfield(AR.DotInfo(kp),'DotChn')
    chn_dot4cell=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,5);
end
if ~isempty(ID_dot4cell)
    dotx=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,2)-rect(2)+1;
    doty=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,3)-rect(1)+1;
end
if AR.FileInfo.option_split_display
    ImageCombine_g=ImageCombine;
    ImageCombine_g(:,:,1)=0;
    ImageCombine_g(:,:,3)=0;
    ImageCombine(:,:,2)=0;
    ImageCombine(:,:,3)=0;
    ImageCombine=[ImageCombine;ImageCombine_g]; % show green and red channel separately
    x=[x,x];y=[y,y+rect(4)+1];
    dotx(chn_dot4cell==3)=dotx(chn_dot4cell==3)+rect(4)+1;  % shift dot in green channel
end
AR.CombineImage=ImageCombine;
axes(handles.axes2)
imshow(ImageCombine,'parent',handles.axes2)
hold(handles.axes2, 'on');
if ~isempty(dotx)
    for k=1:numel(dotx)
        color=AR.Settings.MarkerColorName{chn_dot4cell(k)};
        plot(handles.axes2,doty(k),dotx(k),'o','MarkerSize',24,'MarkerEdgeColor',color,'LineWidth',2)
        text(doty(k),dotx(k),['  ',num2str(ID_dot4cell(k))],'Color','white','FontSize',16); %handles.axes2,index(k)
    end
end
plot(handles.axes2,x,y,'Color','white','LineWidth',0.5)   % plot line in green section
xd=[];yd=[];
if ~isempty(bound_daughter) && GUImode.EnableDaughter
    xd=bound_daughter(:,1)-rect(1)+1;
    yd=bound_daughter(:,2)-rect(2)+1;
    ID_dot4cell=AR.DotInfo(kp).object(kod).frame(kf).DotList;
    dotx=[];chn_dot4cell=[];
    if isfield(AR.DotInfo(kp),'DotChn')
        chn_dot4cell=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,5);
    end
    if ~isempty(ID_dot4cell)
        dotx=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,2)-rect(2)+1;
        doty=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,3)-rect(1)+1;
    end
    if AR.FileInfo.option_split_display
        xd=[xd,xd];yd=[yd,yd+rect(4)+1];
        dotx(chn_dot4cell==3)=dotx(chn_dot4cell==3)+rect(4)+1;  % shift dot in green channel
    end
    if ~isempty(dotx)
        for k=1:numel(dotx)
            color=AR.Settings.MarkerColorName{chn_dot4cell(k)};
            plot(handles.axes2,doty(k),dotx(k),'o','MarkerSize',16,'MarkerEdgeColor',color,'LineWidth',2)
            text(doty(k),dotx(k),['  ',num2str(ID_dot4cell(k))],'Color','white','FontSize',16); %handles.axes2,index(k)
        end
    end
    plot(handles.axes2,xd,yd,'Color','white','LineWidth',0.5)   % plot line in green section
end
%AR.CombineImage= CleanOutsideCell(ImageCombine, x,y, xd,yd, 'or');
title(handles.axes2,['cell ',num2str(ko),' frame ',num2str(kf)],'FontSize',18); %cell # ',num2str(ko),' pos-',num2str(kp),'
hold(handles.axes2, 'off');

function [f,y,index]=PlotCurve(handles,kp,ko)
global AR
option=AR.FileInfo.CurveOption;
AR.FileInfo.CurveObject=ko;AR.FileInfo.CurvePos=kp;
FrameNum=AR.FileInfo.FrameNum;
f=(1:FrameNum)';
switch lower(option(1))
    case {'i','b','t','n'} % peak intensity
        y=NaN(FrameNum,AR.FileInfo.ChnNum-1);
        index=[repmat([kp;ko],[1,AR.FileInfo.ChnNum-1]);2:AR.FileInfo.ChnNum];
        y_label='Int / a.u.';
    case 'p' % position
        y=NaN(FrameNum,2*(AR.FileInfo.ChnNum-1));
        index=[repmat([kp;ko],[1,AR.FileInfo.ChnNum-1]);2:AR.FileInfo.ChnNum];
        index=[index,index];
        y_label='Relative Pos / um';%'Pos / pixel';
    case 'd'
        y=NaN(FrameNum,1);index=[kp;ko];y_label='Dis / um';
end
for kf=1:FrameNum
    if AR.DotInfo(kp).frames{kf}(end)=='S'% kf<=numel(AR.DotInfo(kp).DotChn)
        dotlist=AR.DotInfo(kp).object(ko).frame(kf).DotList;
        %disp(['dot distance pos ',num2str(kp),' frame ',num2str(kf)]);
        if ~isempty(dotlist)
            dotchn=AR.DotInfo(kp).DotChn(kf).dot_id(dotlist,5);
            switch lower(option(1))
                case 'd' % min distance
                    if isfield(AR.DotInfo(kp).object(ko).frame(kf),'MinDis') && ~isempty(AR.DotInfo(kp).object(ko).frame(kf).MinDis)
                        y(kf)=AR.DotInfo(kp).object(ko).frame(kf).MinDis(1);
                    end
                case {'i','t','p','b','n'}
                    for kc=1:AR.FileInfo.ChnNum-1 % ommit chn 1 phase contrast
                        x=dotlist(dotchn==(kc+1));
                        if ~isempty(x)
                            x=x(1);
                            switch lower(option(1))
                                case 'i'% peak intensity
                                    y(kf,kc)=AR.DotInfo(kp).DotChn(kf).intRecord(x,4);
                                case 't' % total intensity
                                    y(kf,kc)=AR.DotInfo(kp).DotChn(kf).intRecord(x,3);
                                case 'p' % position
                                    y(kf,2*kc-1)=AR.DotInfo(kp).DotChn(kf).dot_id(x,2);% x and y coordinates separate
                                    y(kf,2*kc)=AR.DotInfo(kp).DotChn(kf).dot_id(x,3);
                                case 'b' % background
                                    y(kf,kc)=AR.DotInfo(kp).DotChn(kf).intRecord(x,2); % [net, bkg, total, peak intensity, free protein]
                                case 'n' % net intensity
                                    y(kf,kc)=AR.DotInfo(kp).DotChn(kf).intRecord(x,1); % [net, bkg, total, peak intensity, free protein]
                            end
                        end
                    end
            end
        end
    end
end
if lower(option(1))=='p'
    y=(y-repmat(nanmean(y),size(y,1),1))*0.0645;
end
plot(handles.axes3,f,y,'o-');
hold(handles.axes3, 'on');
if lower(option(1))=='d'
    f=[0;f;max(f)+1];
    th=ones(size(f))*0.4;
    plot(handles.axes3,f,th,'-g');
    th=ones(size(f))*0.6;
    plot(handles.axes3,f,th,'-r');
end
title(handles.axes3,['pos-',num2str(kp),'-cell-',num2str(ko),'-',option]);
ylabel(handles.axes3,y_label);
hold(handles.axes3, 'off');

function previousFrame(hObject, eventdata, handles)
global AR
global GUImode
if GUImode.FixCellCheckBox% fix cell, go previous frame
    if AR.FileInfo.CurrentFrame>1
        AR.FileInfo.CurrentFrame=AR.FileInfo.CurrentFrame-1;
        set(handles.Frame,'value',AR.FileInfo.CurrentFrame);
    end
    Frame_Callback(hObject, eventdata, handles);
end

function [bg, contrast]=AutoContrast(image,threshold)
% calculate the background and magnification base on image
if nargin<2
    threshold=0.98;
end
bg=(quantile(image(:),threshold))-5; % background
contrast=min(1.1*ceil(65535/(max(image(:))-bg)),2000); % background

function [af,image_size,fm_crop,AllFrames,nh1,AllFrames2,nh2]=ExportImage(hObject, eventdata, handles,kp,ko)
global AR
AR.FileInfo.EnableRect=true;
AR.FileInfo.option_split_display=false;
AR.FileInfo.PlotOption=false;
fm=cell(1,AR.FileInfo.FrameNum);
fm_rect=zeros(AR.FileInfo.FrameNum,4);
fm_bkg=zeros(AR.FileInfo.FrameNum,4); % [bkg r, bkg g, amp r, amp g]
AR.FileInfo.CurrentPos=kp;
disp(['Export image - pos ',num2str(kp),' cell #',num2str(ko)]);
set(handles.Cell,'value',ko);
%kmax=0;
for kf=1:AR.FileInfo.FrameNum
    if AR.DotInfo(kp).frames{kf}(end)=='S'
        set(handles.Frame,'value',kf);
        AR.FileInfo.CurrentFrame=kf;
        Frame_Callback(hObject, eventdata, handles);
        %Cell_Callback(hObject, eventdata, handles);
        %fm{kf}=AR.CombineImage;
        if ~isempty(AR.FileInfo.rect)
            fm_rect(kf,:)=AR.FileInfo.rect;
            %fm_bkg(kf,:)=AR.FileInfo.AutoContrast;
        end
        %kmax=kf;
    end
end
image_size=ceil(max(fm_rect(:,3:4)+1,[],1)*1.05); % enlarge the region to fit in the largest cell
fm_crop=max(floor((fm_rect(:,1:2))-(repmat(image_size,[kf,1])-fm_rect(:,3:4)-1)/2),1);
fm_crop=[fm_crop,min(repmat(image_size-1,[kf,1]),repmat([672,512],[kf,1])-fm_crop(:,1:2))];
fm_crop=ceil(fm_crop);
AR.FileInfo.EnableRect=false;AR.FileInfo.PlotOption=true;af=[];
for kf=1:AR.FileInfo.FrameNum
    if AR.DotInfo(kp).frames{kf}(end)=='S' && (sum(fm_rect(kf,:)>0)==4)
        set(handles.Frame,'value',kf);
        AR.FileInfo.CurrentFrame=kf;
        AR.FileInfo.rect=fm_crop(kf,:);
        Frame_Callback(hObject, eventdata, handles);
        %Cell_Callback(hObject, eventdata, handles);
        fm{kf}=AR.CombineImage; % clean outside cell
        af=[af;kf];
    end
end
name=[AR.FileInfo.MainFolder,'output\pos-',num2str(kp),'-cell-',num2str(ko)];
% form one figure with overlay red/green
nh1=round(sqrt(length(af)*1.4)); % columns of pics
nv=ceil(length(af)/nh1); % rows of pics
AllFrames=zeros(image_size(2)*nv,image_size(1)*nh1,3);
for kt=0.5:(length(af)-0.5) % each image
    k=af(kt+0.5);
    kc=ceil([rem(kt,nh1),fix(kt/nh1)+1])-1;
    ok1=kc.*image_size+1;%ok2=(kc+1).*image_size;
    [tr,tc,~]=size(fm{k});
    AllFrames(ok1(2):ok1(2)+tr-1,ok1(1):ok1(1)+tc-1,:)=fm{k};
end
AllFrames=double(AllFrames)./65535;
imwrite(AllFrames,[name,'c.jpg'])
% form one figure with separate red/green
nh2=0;
if 0
    image_size(1)=image_size(1)*2; % vertical contain two separate channels
    nh2=round(sqrt(length(af)*2*1.5)); % columns of pics
    nv=ceil(length(af)/nh2); % rows of pics
    AllFrames2=zeros(image_size(1)*nv,image_size(2)*nh2,3);
    for kt=0.5:(length(af)-0.5) % each image
        k=af(kt+0.5);
        kc=ceil([fix(kt/nh2)+1,rem(kt,nh2)])-1;
        ok1=kc.*image_size+1;ok2=(kc+1).*image_size;
        a_r=fm{k};a_r(:,:,2)=0;a_g=fm{k};a_g(:,:,1)=0;
        a=[a_r;a_g];
        AllFrames2(ok1(1):ok2(1),ok1(2):ok2(2),:)=imresize(a,image_size);
    end
    AllFrames2=double(AllFrames2)./65535;
    imwrite(AllFrames2,[name,'s.jpg'])
end
save([name,'.mat'],'AllFrames','fm','fm_rect','fm_bkg','fm_crop','image_size','af','nh1','nh2');
AR.FileInfo.SaveList{kp}{ko}=['pos-',num2str(kp),'-cell-',num2str(ko)];

function [No]=InitialRatioAnnotation(Np,No)
global AR
% clear empty objects
for kp=1:Np
    n=max(numel(AR.DotInfo(kp).object(1).frame),1);
    d=0;
    for ko=No(kp):-1:1
        %disp(['pos ',num2str(kp),' cell',num2str(ko)]);
        if numel(AR.DotInfo(kp).object(ko).frame)<n
            AR.DotInfo(kp).object(ko)=[];
            d=d+1;
        end
    end
    No(kp)=No(kp)-d;
end
% initializd dot list
for kp=1:Np
    for ko=1:No(kp)
        AR.DotInfo(kp).object(ko).frame(1).DotList=[];
    end
end
% initializd annotation list
c=1;frames=[1,round(80/AR.FileInfo.TimeInterval)];
for kf=1:length(frames)
    for kp=1:Np
        [AR.Annotation(c:(c-1+No(kp))).pos]=deal(kp);
        [AR.Annotation(c:(c-1+No(kp))).frame]=deal(frames(kf));
        for ko=1:No(kp)
            AR.Annotation(c-1+ko).obj=ko;
        end
        c=c+No(kp);
    end
end

function DisplayMultiFrame(hObject, eventdata, handles,kp,ko)
global AR
global GUImode
% check for saving reminder
t=cputime;
if t-AR.FileInfo.time>900
    Save_Callback(hObject, eventdata, handles);
    AR.FileInfo.time=cputime;
end
% display the image
if isfield(AR.FileInfo,'SaveList')  && numel(AR.FileInfo.SaveList{kp})>=ko
    name=[AR.FileInfo.MainFolder,'output\',AR.FileInfo.SaveList{kp}{ko},'.mat'];
    load(name,'AllFrames','nh1','af','image_size','fm_crop');
else
    [af,image_size,fm_crop,AllFrames,nh1]=ExportImage(hObject, eventdata, handles,kp,ko);
end
%image_size(1)=image_size(1);
axes(handles.axes1)
imshow(AllFrames,'parent',handles.axes1);
hold(handles.axes1, 'on');
for k=0.5:(length(af)-0.5) % each image
    kf=af(k+0.5);
    kc=ceil([rem(k,nh1),fix(k/nh1)+1])-1;
    ok1=kc.*image_size+1;
    text(ok1(1)+5,ok1(2)+5,num2str(kf),'FontSize',16,'Color','w')
    x=AR.DotInfo(kp).object(ko).frame(kf).x./AR.FileInfo.reScale;
    y=AR.DotInfo(kp).object(ko).frame(kf).y./AR.FileInfo.reScale;
    x=x-fm_crop(k+0.5,1)+ok1(1);
    y=y-fm_crop(k+0.5,2)+ok1(2);
    plot(handles.axes1,x,y,'Color','white','LineWidth',0.5)
    ID_dot4cell=AR.DotInfo(kp).object(ko).frame(kf).DotList;
    if ~isempty(ID_dot4cell)
        dotx=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,2)-fm_crop(k+0.5,2)+ok1(2);
        doty=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,3)-fm_crop(k+0.5,1)+ok1(1);
        chn_dot4cell=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,5);
        for kd=1:numel(dotx)
            color=AR.Settings.MarkerColorName{chn_dot4cell(kd)};
            plot(handles.axes1,doty(kd),dotx(kd),'o','MarkerSize',16,'MarkerEdgeColor',color,'LineWidth',1)
        end
    end
end
kod=AR.DotInfo(kp).object(ko).daughterList;
if ~isempty(kod)
    kod=kod(1);
end
if GUImode.EnableDaughter && ~isempty(kod)
    for k=0.5:(length(af)-0.5) % each image
        kf=af(k+0.5);
        kc=ceil([rem(k,nh1),fix(k/nh1)+1])-1;
        ok1=kc.*image_size+1;
        x=AR.DotInfo(kp).object(kod).frame(kf).x./AR.FileInfo.reScale;
        y=AR.DotInfo(kp).object(kod).frame(kf).y./AR.FileInfo.reScale;
        x=x-fm_crop(k+0.5,1)+ok1(1);
        y=y-fm_crop(k+0.5,2)+ok1(2);
        plot(handles.axes1,x,y,'Color','white','LineWidth',0.5)
        ID_dot4cell=AR.DotInfo(kp).object(kod).frame(kf).DotList;
        if ~isempty(ID_dot4cell)
            dotx=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,2)-fm_crop(k+0.5,2)+ok1(2);
            doty=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,3)-fm_crop(k+0.5,1)+ok1(1);
            chn_dot4cell=AR.DotInfo(kp).DotChn(kf).dot_id(ID_dot4cell,5);
            for kd=1:numel(dotx)
                color=AR.Settings.MarkerColorName{chn_dot4cell(kd)};
                plot(handles.axes1,doty(kd),dotx(kd),'o','MarkerSize',16,'MarkerEdgeColor',color,'LineWidth',1)
            end
        end
    end
end
title(handles.axes1,AR.FileInfo.SaveList{kp}{ko},'FontSize',18)
hold(handles.axes1, 'off');
AR.FileInfo.option_split_display=true;

function ExportFluo(hObject, eventdata, handles)
% on a cell basis, export mean fluo
global AR
global chn
kc_select=AR.Settings.AnalysisChn;
AR.FileInfo.Summary.CellFluo=[];
AR.FileInfo.Summary.CellFluoIndex=[];
for kp=AR.FileInfo.pos_selection
    AR.FileInfo.CurrentPos=kp;
    fl=[]; % fluo of all cells
    %AR.FileInfo.ObjectNum(kp)=numel(AR.DotInfo(kp).object);
    for kf=1:AR.FileInfo.FrameNum
        set(handles.Frame,'value',kf); % ??? stop here
        for ko=1:AR.FileInfo.ObjectNum(kp) % clear Fluo memory
            AR.DotInfo(kp).object(ko).frame(kf).Fluo=[];
        end
        if AR.DotInfo(kp).frames{kf}(end)=='S' % if frame is annotated
            AR.FileInfo.CurrentFrame=kf;
            Preview_Callback(hObject, eventdata, handles)
            reScale=AR.FileInfo.reScale; % phase image 1024x1344, fluorescence image 512x672, rescale is 2
            ObjectNum=AR.FileInfo.ObjectNum(kp);
            B=cell(ObjectNum,1);
            %st=AR.FileInfo.StackNum;
            for ko=1:ObjectNum % collect cell boundary information
                x=AR.DotInfo(kp).object(ko).frame(kf).x;
                y=AR.DotInfo(kp).object(ko).frame(kf).y;
                B{ko} = [x',y']./reScale;
            end
            f= FluoInsideCell(chn,B,kc_select); % fluo of the current frame, [ch*obj elements]
            set(handles.WorkInfo,'String',{[AR.FileInfo.PosFolder{kp},' fr',num2str(kf),' export']});
            fi=repmat(1:ObjectNum,[length(kc_select),1]);% already return from function
            fi=[kp*ones(1,ObjectNum*length(kc_select));fi(:)';repmat(kc_select,[1,ObjectNum])];
            fl=[fl;f(:)']; % collection of fluo over the frame, row for frame
        end
    end
    AR.FileInfo.Summary.CellFluo=[AR.FileInfo.Summary.CellFluo,fl];
    AR.FileInfo.Summary.CellFluoIndex=[AR.FileInfo.Summary.CellFluoIndex,fi];
end

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
key = eventdata.Key;
global AR
switch lower(key)
    case 's' % save file
        Save_Callback(hObject, eventdata, handles);
    case 'a' % add dot
        Add_Callback(hObject, eventdata, handles);
    case 'd' % delete dot
        Delete_Callback(hObject, eventdata, handles);
    case 'x' % refresh by auto contrast
        RefreshT_Callback(hObject, eventdata, handles);
    case 'z' % refresh by value
        RefreshValue_Callback(hObject, eventdata, handles);
    case 'w' % next
        Next_Callback(hObject, eventdata, handles);
    case 'q' % next cell
        if AR.FileInfo.ObjectNum(AR.FileInfo.CurrentPos)>AR.FileInfo.CurrentCell
            set(handles.Frame,'value',1); % AR.FileInfo.CurrentCell=AR.FileInfo.CurrentCell+1;
            set(handles.Cell,'value',AR.FileInfo.CurrentCell+1);
            Frame_Callback(hObject, eventdata, handles);
            %Cell_Callback(hObject, eventdata, handles);
        end
    case 'e' % previous cell
        set(handles.Cell,'value',AR.FileInfo.CurrentCell-1);
        Frame_Callback(hObject, eventdata, handles);
        %Cell_Callback(hObject, eventdata, handles);
    case 'r' % previous
        previousFrame(hObject, eventdata, handles);
    case {'1','2','3','4','5'}
        select=min(str2num(key),numel(get(handles.Dot,'string')));
        set(handles.Dot,'value',select);%AR.DotListBox.Items{select}
        Delete_Callback(hObject, eventdata, handles);
    case 't' % 'Control+T' delete whole trace
        if eventdata.Modifier{1}(1)=='c'
            DeleteTrace_Callback(hObject, eventdata, handles);
        end
end


% --- Executes during object creation, after setting all properties.
function Status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in DeleteTrace.
function DeleteTrace_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
nf=AR.FileInfo.FrameNum;
kp=AR.FileInfo.CurrentPos;
ko=AR.FileInfo.CurrentCell;
CurrentFrame=get(handles.Frame,'value');
range=CurrentFrame:nf;
for kf=range
    AR.DotInfo(kp).object(ko).frame(kf).DotList=[];
    AR.DotInfo(kp).DotChn(kf).DeleteNum=AR.DotInfo(kp).DotChn(kf).DeleteNum+1;
end
dotlistcontent(1)={'-'};
set(handles.Dot,'string',dotlistcontent);
AR.FileInfo.CurrentCell=AR.FileInfo.CurrentCell-1;
Cell_Callback(hObject, eventdata, handles);


% --- Executes on button press in EnableDaughter.
function EnableDaughter_Callback(hObject, eventdata, handles)
% hObject    handle to EnableDaughter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GUImode
GUImode.EnableDaughter=get(hObject,'Value');

function SelectPos_Callback(hObject, eventdata, handles)
% hObject    handle to SelectPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AR
x=str2num(get(hObject,'String'));
x=x(x>0 & x<=AR.FileInfo.PosNum);
if ~isempty(x)
    AR.FileInfo.pos_selection=x;
end

% --- Executes during object creation, after setting all properties.
function SelectPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CellFluo.
function CellFluo_Callback(hObject, eventdata, handles)
% hObject    handle to CellFluo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ExportFluo(hObject, eventdata, handles);
