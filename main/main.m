function varargout = main(varargin)
% MAIN M-file for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 22-Apr-2020 11:47:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_OpeningFcn, ...
    'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
handles.Sources = [];
handles.Stations = [];
handles.Sensors = [];
handles.ParamHandles = [];
handles.Population = [];
handles.NEstimation = 1000;
handles.EarthQuakes = [];
handles.SourcesHistory = [];
handles.SourcesHistoryLength = 30;


a = get(handles.gapanel,'Position');
set(handles.pspanel,'Position',a);
set(handles.NLSQpanel,'Position',a);

set(handles.GAMEui,'KeyPressFcn',@myFunction);
% Update handles structure
guidata(hObject, handles);
GUI2GAparams(hObject,handles);
handles = guidata(hObject);
GUI2PSparams(hObject,handles);
handles = guidata(hObject);
GUI2Terrain(hObject,handles);
handles = guidata(hObject);

function myFunction(src,evnt)

%this function takes in two inputs by default

%src is the gui figure
%evnt is the keypress information

%this line brings the handles structures into the local workspace
%now we can use handles.cats in this subfunction!

handles = guidata(src);
hObject = handles.output;
switch evnt.Key
    case 'f1'
        if ~exist('tmp','dir')
            mkdir('tmp');
        end
        savegim(handles, './tmp', ['tmp',datestr(now,'yymmddHHMMSS'),'.gim']);
    case 'f10'
        if exist('tmp','dir')
            fd = dir('./tmp/*.gim');
            [~, idx] = sort([fd.datenum]);
            loadgim(hObject, [], handles, './tmp/',fd(idx(end)).name);
        end
    case 'f6'
        if get(handles.GAs,'Value')
            goinversion_Callback(handles.goinversion, [], handles);
        elseif get(handles.PS,'Value')
            PSearch_Callback(handles.PSearch, [], handles);
        elseif get(handles.NLSQ,'Value')
            invertnlsq_Callback(handles.invertnlsq, [], handles);
        end
        
    case 'f3'
        evaluatemodel_Callback(handles.evaluatemodel, [], handles);
        buildscene_Callback(handles.buildscene, [], handles);
     
end

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.GAMEui);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_1_Callback(hObject, eventdata, handles)
% hObject    handle to file_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in sourcelist.
function sourcelist_Callback(hObject, eventdata, handles)
% hObject    handle to sourcelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sourcelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sourcelist
displayParameters(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function sourcelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function SourceMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SourceMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.makepatches,'Visible','off');
set(handles.onfaulttookada,'Visible','off');

if ~isempty(get(handles.sourcelist,'String'))
    i = get(handles.sourcelist,'Value');
    if strcmp(handles.Sources(i).Type,'Okada')
        set(handles.makepatches,'Visible','on');
    end
    if strcmp(handles.Sources(i).Type,'OkadaOnFault')
        set(handles.onfaulttookada,'Visible','on');
    end
end


% --------------------------------------------------------------------
function newdavis_Callback(hObject, eventdata, handles)
% hObject    handle to newdavis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Sources = [newDavisSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'Davis'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function newokada_Callback(hObject, eventdata, handles)
% hObject    handle to newokada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newOkadaSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'Okada'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newmogi_Callback(hObject, eventdata, handles)
% hObject    handle to newmogi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newMogiSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'Mogi'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);

% --------------------------------------------------------------------
function deletesource_Callback(hObject, eventdata, handles)
% hObject    handle to deletesource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.sourcelist,'String'))
    i = get(handles.sourcelist,'Value');
    ss = get(handles.sourcelist,'String');
    ss(i) = [];
    handles.Sources(i) = [];
    set(handles.sourcelist,'String',ss);
    set(handles.sourcelist,'Value',1);
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);
end
% --------------------------------------------------------------------
function displayParameters(hObject, eventdata, handles)

for i=1:length(handles.ParamHandles)
    try
        delete(handles.ParamHandles(i));
    catch
    end
end
handles.ParamHandles = [];

isource = get(handles.sourcelist,'Value');



if (~isempty(get(handles.sourcelist,'String'))) && (~isempty(handles.Sources))
        
    if length(get(handles.sourcelist,'String')) ~= length(handles.Sources)
        
        for i=1:length(handles.Sources)
            listtype{i} = handles.Sources(i).Type;
        end
        set(handles.sourcelist,'String',listtype);
        set(handles.sourcelist,'Value',1);
        
        isource = 1;
    end

    if isempty(isource) ||  (isource<=0) 
        set(handles.sourcelist,'Value',1);
        isource = 1;
    end

    nparams = handles.Sources(isource).NParameters;
    
    k = 0;
    xleft = 3.0;
    xlength = 1.7;
    ydown = 1.3;
    ylength = 0.5;
    for i=1:handles.Sources(isource).NParameters
        k = k+1;
        handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','text',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+3*ylength,xlength,ylength],...
            'string',handles.Sources(isource).ParameterNames{i},...
            'interruptible','on');
    end
    
    for i=1:handles.Sources(isource).NParameters
        k = k+1;
        handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+2*ylength,xlength,ylength],...
            'string',num2str(handles.Sources(isource).UpBoundaries(i)),...
            'BackgroundColor',[1 0.7 0.7],...
            'tag',['U',num2str(i)],...
            'interruptible','on',...
            'callback','main(''MyCallback'',gcbo,[],guidata(gcbo))');
    end
    
    for i=1:handles.Sources(isource).NParameters
        k = k+1;
        handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+ylength,xlength,ylength],...
            'string',num2str(handles.Sources(isource).Parameters(i),'%7.3f'),...
            'BackgroundColor',[0.66 1 0.66],...
            'tag',['X',num2str(i)],...
            'HorizontalAlignment','left',...
            'interruptible','on',...
            'callback','main(''MyCallback'',gcbo,[],guidata(gcbo))');
    end
    
    for i=1:handles.Sources(isource).NParameters
        k = k+1;
        handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown,xlength,ylength],...
            'string',num2str(handles.Sources(isource).LowBoundaries(i)),...
            'BackgroundColor',[0.73 0.92 1],...
            'tag',['L',num2str(i)],...
            'interruptible','on',...
            'callback','main(''MyCallback'',gcbo,[],guidata(gcbo))');
    end
    
    for i=1:handles.Sources(isource).NParameters
        k = k+1;
        handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown-ylength,xlength,ylength],...
            'string',num2str(handles.Sources(isource).EParameters(i)),...
            'BackgroundColor',[0.75 0.75 0.75],...
            'tag',['E',num2str(i)],...
            'interruptible','on',...
            'callback','main(''MyCallback'',gcbo,[],guidata(gcbo))');
    end
    
    for i=1:handles.Sources(isource).NParameters
        k = k+1;
        handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','checkbox',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1)+xlength/3,ydown-2*ylength,0.4,0.4],...
            'string','',...
            'value',handles.Sources(isource).ActiveParameters(i),...
            'tag',['C',num2str(i)],...
            'interruptible','on',...
            'callback','main(''MyCallback'',gcbo,[],guidata(gcbo))');
    end
    
    
    k = k+1;
    handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','text',...
        'units','centimeters',...
        'position',[xleft+.1+xlength*handles.Sources(isource).NParameters,ydown+2*ylength-.06,xlength,ylength],...
        'string','Max',...
        'interruptible','on');
    k = k+1;
    handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','text',...
        'units','centimeters',...
        'position',[xleft+.1+xlength*handles.Sources(isource).NParameters,ydown+1*ylength-.06,xlength,ylength],...
        'string','Parameters',...
        'interruptible','on');
    k = k+1;
    handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','text',...
        'units','centimeters',...
        'position',[xleft+.1+xlength*handles.Sources(isource).NParameters,ydown+0*ylength-.06,xlength+0.05,ylength],...
        'string','Min',...
        'interruptible','on');
    k = k+1;
    handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','text',...
        'units','centimeters',...
        'position',[xleft+.1+xlength*handles.Sources(isource).NParameters,ydown-ylength-.06,xlength,ylength],...
        'string','Sigma',...
        'interruptible','on');
    k = k+1;
    handles.ParamHandles(k) = uicontrol(handles.uipaneltop,'style','checkbox',...
        'units','centimeters',...
        'position',[0.7,0.18,xlength,ylength],...
        'Value',handles.Sources(isource).IsActive,...
        'String','Active',...
        'tag',['A'],...
        'callback','main(''MyCallback'',gcbo,[],guidata(gcbo))');
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function addsourcefromfile_Callback(hObject, eventdata, handles)
% hObject    handle to addsourcefromfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function savesource_Callback(hObject, eventdata, handles)
% hObject    handle to savesource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function MyCallback(hObject, eventdata, handles)
% hObject    handle to savesource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

isource = get(handles.sourcelist,'Value');
xtag = get(hObject,'Tag');
xtype = xtag(1);
xtag(1) = [];
iparam = str2num(xtag);

if xtype == 'U'
    handles.Sources(isource).UpBoundaries(iparam) = str2num(get(hObject,'String'));
elseif xtype == 'X'
    handles.Sources(isource).Parameters(iparam) = str2num(get(hObject,'String'));
elseif xtype == 'E'
    handles.Sources(isource).EParameters(iparam) = str2num(get(hObject,'String'));
elseif xtype == 'L'
    handles.Sources(isource).LowBoundaries(iparam) = str2num(get(hObject,'String'));
elseif xtype == 'C'
    handles.Sources(isource).ActiveParameters(iparam) = get(hObject,'Value');
elseif xtype == 'A'
    handles.Sources(isource).IsActive = get(hObject,'Value');
end

guidata(hObject, handles);





% --- Executes on selection change in stationlist.
function stationlist_Callback(hObject, eventdata, handles)
% hObject    handle to stationlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns stationlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stationlist
displayMeasurements(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function stationlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stationlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function StationMenu_Callback(hObject, eventdata, handles)
% hObject    handle to StationMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function newdispacement_Callback(hObject, eventdata, handles)
% hObject    handle to newdispacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Station',1,{'noname'});
if ~isempty(answer)
    S = newDisplacementStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function deletestation_Callback(hObject, eventdata, handles)
% hObject    handle to deletestation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.stationlist,'String'))
    
    i = get(handles.stationlist,'Value');
    ss = get(handles.stationlist,'String');
    ss(i) = [];
    handles.Stations(i) = [];
    set(handles.stationlist,'Value',1);
    set(handles.stationlist,'String',ss);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end
% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function displayMeasurements(hObject, eventdata, handles)

try
    u = findobj(0, 'tag', 'mN');
    if ~isempty(u)
        delete(u);
    end
    u = findobj(0, 'tag', 'mE');
    if ~isempty(u)
        delete(u);
    end
    u = findobj(0, 'tag', 'mU');
    if ~isempty(u)
        delete(u);
    end
    u = findobj(0, 'tag', 'mW');
    if ~isempty(u)
        delete(u);
    end
    for i=1:6
        u = findobj(0, 'tag', ['mX',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
    for i=1:5
        u = findobj(0, 'tag', ['msM',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
    for i=1:5
        u = findobj(0, 'tag', ['mM',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
    for i=1:5
        u = findobj(0, 'tag', ['mE',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
catch
    fsdfgd=324;
end

istation = get(handles.stationlist,'Value');
if ~isempty(istation)
    istation = istation(1);
end

if ~isempty(get(handles.stationlist,'String'))
    nmeas = handles.Stations(istation).NMeasurements;
    
    xleft = 4.5;
    xlength = 1.7;
    ydown = 4;
    ylength = 0.5;
    

    uicontrol(handles.uipaneldown,'style','text',...
        'units','centimeters',...
        'position',[xleft+0*xlength,ydown+5*ylength+0.2,xlength+xlength/3,ylength],...
        'string','N',...
        'tag','mN',...
        'interruptible','on');

    uicontrol(handles.uipaneldown,'style','edit',...
        'units','centimeters',...
        'position',[xleft+0*xlength,ydown+4*ylength+0.2,xlength+xlength/3,ylength],...
        'string',num2str(handles.Stations(istation).Coordinates(1)),...
        'BackgroundColor',[0.2 0.8 0.2],...
        'tag','mX1',...
        'interruptible','on',...
        'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
    
    uicontrol(handles.uipaneldown,'style','text',...
        'units','centimeters',...
        'position',[xleft+1*(xlength+xlength/3),ydown+5*ylength+0.2,xlength+xlength/3,ylength],...
        'string','E',...
        'tag','mE',...
        'interruptible','on');

    uicontrol(handles.uipaneldown,'style','edit',...
        'units','centimeters',...
        'position',[xleft+1*(xlength+xlength/3),ydown+4*ylength+0.2,xlength+xlength/3,ylength],...
        'string',num2str(handles.Stations(istation).Coordinates(2)),...
        'BackgroundColor',[0.2 0.8 0.2],...
        'tag','mX2',...
        'interruptible','on',...
        'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
    

    uicontrol(handles.uipaneldown,'style','text',...
        'units','centimeters',...
        'position',[xleft+2*(xlength+xlength/3),ydown+5*ylength+0.2,xlength+xlength/3,ylength],...
        'string','U',...
        'tag','mU',...
        'interruptible','on');

    uicontrol(handles.uipaneldown,'style','edit',...
        'units','centimeters',...
        'position',[xleft+2*(xlength+xlength/3),ydown+4*ylength+0.2,xlength+xlength/3,ylength],...
        'string',num2str(handles.Stations(istation).Coordinates(3)),...
        'BackgroundColor',[0.2 0.8 0.2],...
        'tag','mX3',...
        'interruptible','on',...
        'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
    
    if strcmp (handles.Stations(istation).Type,'Baseline')
        

        uicontrol(handles.uipaneldown,'style','edit',...
            'units','centimeters',...
            'position',[xleft+0*xlength,ydown+3*ylength+0.2,xlength+xlength/3,ylength],...
            'string',num2str(handles.Stations(istation).Coordinates(4)),...
            'BackgroundColor',[0.2 0.8 0.2],...
            'tag','mX4',...
            'interruptible','on',...
            'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
        

        uicontrol(handles.uipaneldown,'style','edit',...
            'units','centimeters',...
            'position',[xleft+1*(xlength+xlength/3),ydown+3*ylength+0.2,xlength+xlength/3,ylength],...
            'string',num2str(handles.Stations(istation).Coordinates(5)),...
            'BackgroundColor',[0.2 0.8 0.2],...
            'tag','mX5',...
            'interruptible','on',...
            'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
        

        uicontrol(handles.uipaneldown,'style','edit',...
            'units','centimeters',...
            'position',[xleft+2*(xlength+xlength/3),ydown+3*ylength+0.2,xlength+xlength/3,ylength],...
            'string',num2str(handles.Stations(istation).Coordinates(6)),...
            'BackgroundColor',[0.2 0.8 0.2],...
            'tag','mX6',...
            'interruptible','on',...
            'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
    end
    
    for i=1:handles.Stations(istation).NMeasurements

        uicontrol(handles.uipaneldown,'style','text',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+2*ylength,xlength,ylength],...
            'string',handles.Stations(istation).NameMeasurements{i},...
             'tag',['msM',num2str(i)],...
            'interruptible','on');
    end
    
    for i=1:handles.Stations(istation).NMeasurements

        uicontrol(handles.uipaneldown,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+1*ylength,xlength,ylength],...
            'string',num2str(handles.Stations(istation).Measurements(i)),...
            'BackgroundColor',[1 1 1],...
            'tag',['mM',num2str(i)],...
            'interruptible','on',...
            'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
    end
    
    for i=1:handles.Stations(istation).NMeasurements

        uicontrol(handles.uipaneldown,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+0*ylength,xlength,ylength],...
            'string',num2str(handles.Stations(istation).Errors(i)),...
            'BackgroundColor',[0.8 0.5 0.4],...
            'tag',['mE',num2str(i)],...
            'interruptible','on',...
            'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
    end
    
    
    uicontrol(handles.uipaneldown,'style','edit',...
        'units','centimeters',...
        'position',[xleft,ydown-1,xlength/1.5,ylength],...
        'string',num2str(handles.Stations(istation).Weight),...
        'BackgroundColor',[1 1 1],...
        'tag','mW',...
        'callback','main(''MyMeasuresCallback'',gcbo,[],guidata(gcbo))');
    
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function displaySensors(hObject, eventdata, handles)

try
    u = findobj(0, 'tag', 'sN');
    if ~isempty(u)
        delete(u);
    end
    u = findobj(0, 'tag', 'sE');
    if ~isempty(u)
        delete(u);
    end
    u = findobj(0, 'tag', 'sU');
    if ~isempty(u)
        delete(u);
    end
    for i=1:6
        u = findobj(0, 'tag', ['sX',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
    for i=1:5
        u = findobj(0, 'tag', ['ssM',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
    for i=1:5
        u = findobj(0, 'tag', ['sM',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
    for i=1:5
        u = findobj(0, 'tag', ['sE',num2str(i)]);
        if ~isempty(u)
            delete(u);
        end
    end
catch
    fsdfgd=324;
end

isensor = get(handles.sensorlist,'Value');
if ~isempty(isensor)
    isensor = isensor(1);
end

if ~isempty(get(handles.sensorlist,'String'))
    nmeas = handles.Sensors(isensor).NMeasurements;
    

    xleft = 0.5;
    xlength = 1.7;
    ydown = 4;
    ylength = 0.5;
    

    uicontrol(handles.uidownright,'style','text',...
        'units','centimeters',...
        'position',[xleft+0*xlength,ydown+5*ylength+0.2,xlength+xlength/3,ylength],...
        'string','N',...
        'tag','sN',...
        'interruptible','on');

    uicontrol(handles.uidownright,'style','edit',...
        'units','centimeters',...
        'position',[xleft+0*xlength,ydown+4*ylength+0.2,xlength+xlength/3,ylength],...
        'string',num2str(handles.Sensors(isensor).Coordinates(1)),...
        'BackgroundColor',[0.2 0.8 0.2],...
        'tag','sX1',...
        'interruptible','on',...
        'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');
    

    uicontrol(handles.uidownright,'style','text',...
        'units','centimeters',...
        'position',[xleft+1*(xlength+xlength/3),ydown+5*ylength+0.2,xlength+xlength/3,ylength],...
        'string','E',...
        'tag','sE',...
        'interruptible','on');

    uicontrol(handles.uidownright,'style','edit',...
        'units','centimeters',...
        'position',[xleft+1*(xlength+xlength/3),ydown+4*ylength+0.2,xlength+xlength/3,ylength],...
        'string',num2str(handles.Sensors(isensor).Coordinates(2)),...
        'BackgroundColor',[0.2 0.8 0.2],...
        'tag','sX2',...
        'interruptible','on',...
        'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');
    

    uicontrol(handles.uidownright,'style','text',...
        'units','centimeters',...
        'position',[xleft+2*(xlength+xlength/3),ydown+5*ylength+0.2,xlength+xlength/3,ylength],...
        'string','U',...
        'tag','sU',...
        'interruptible','on');

    uicontrol(handles.uidownright,'style','edit',...
        'units','centimeters',...
        'position',[xleft+2*(xlength+xlength/3),ydown+4*ylength+0.2,xlength+xlength/3,ylength],...
        'string',num2str(handles.Sensors(isensor).Coordinates(3)),...
        'BackgroundColor',[0.2 0.8 0.2],...
        'tag','sX3',...
        'interruptible','on',...
        'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');
    
    
    if strcmp (handles.Sensors(isensor).Type,'Baseline')

        uicontrol(handles.uidownright,'style','edit',...
            'units','centimeters',...
            'position',[xleft+0*xlength,ydown+3*ylength+0.2,xlength+xlength/3,ylength],...
            'string',num2str(handles.Sensors(isensor).Coordinates(4)),...
            'BackgroundColor',[0.2 0.8 0.2],...
            'tag','sX4',...
            'interruptible','on',...
            'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');

        uicontrol(handles.uidownright,'style','edit',...
            'units','centimeters',...
            'position',[xleft+1*(xlength+xlength/3),ydown+3*ylength+0.2,xlength+xlength/3,ylength],...
            'string',num2str(handles.Sensors(isensor).Coordinates(5)),...
            'BackgroundColor',[0.2 0.8 0.2],...
            'tag','sX5',...
            'interruptible','on',...
            'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');

        uicontrol(handles.uidownright,'style','edit',...
            'units','centimeters',...
            'position',[xleft+2*(xlength+xlength/3),ydown+3*ylength+0.2,xlength+xlength/3,ylength],...
            'string',num2str(handles.Sensors(isensor).Coordinates(6)),...
            'BackgroundColor',[0.2 0.8 0.2],...
            'tag','sX6',...
            'interruptible','on',...
            'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');
    end
    
    
    for i=1:handles.Sensors(isensor).NMeasurements

        uicontrol(handles.uidownright,'style','text',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+2*ylength,xlength,ylength],...
            'string',handles.Sensors(isensor).NameMeasurements{i},...
             'tag',['ssM',num2str(i)],...
            'interruptible','on');
    end
    
    for i=1:handles.Sensors(isensor).NMeasurements

        uicontrol(handles.uidownright,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+1*ylength,xlength,ylength],...
            'string',num2str(handles.Sensors(isensor).Measurements(i)),...
            'BackgroundColor',[1 1 0.6],...
            'tag',['sM',num2str(i)],...
            'interruptible','on',...
            'HorizontalAlignment','left',...
            'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');
        %   'Enable','inactive',...
    end
    
    for i=1:handles.Sensors(isensor).NMeasurements

        uicontrol(handles.uidownright,'style','edit',...
            'units','centimeters',...
            'position',[xleft+xlength*(i-1),ydown+0*ylength,xlength,ylength],...
            'string',num2str(handles.Sensors(isensor).Errors(i)),...
            'BackgroundColor',[0.8 0.5 0.4],...
            'tag',['sE',num2str(i)],...
            'interruptible','on',...
            'Enable','inactive',...
            'callback','main(''MySensorsCallback'',gcbo,[],guidata(gcbo))');
    end
    
end
guidata(hObject, handles);

function MySensorsCallback(hObject, eventdata, handles)
% hObject    handle to savesource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

isensor = get(handles.sensorlist,'Value');

xtag = get(hObject,'Tag');
xtag(1) = [];
xtype = xtag(1);
xtag(1) = [];
i = str2num(xtag);

if xtype == 'X'
    handles.Sensors(isensor).Coordinates(i) = str2num(get(hObject,'String'));
elseif xtype == 'M'
    handles.Sensors(isensor).Measurements(i) = str2num(get(hObject,'String'));
    % elseif xtype == 'E'
    %     handles.Sensors(isensor).Errors(i) = str2num(get(hObject,'String'));
    % elseif xtype == 'W'
    %     handles.Sensors(isensor).Weight = str2num(get(hObject,'String'));
end

guidata(hObject, handles);

function MyMeasuresCallback(hObject, eventdata, handles)
% hObject    handle to savesource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

istation = get(handles.stationlist,'Value');

xtag = get(hObject,'Tag');
xtag(1) = [];
xtype = xtag(1);
xtag(1) = [];
i = str2num(xtag);

if xtype == 'X'
    handles.Stations(istation).Coordinates(i) = str2num(get(hObject,'String'));
elseif xtype == 'M'
    handles.Stations(istation).Measurements(i) = str2num(get(hObject,'String'));
elseif xtype == 'E'
    handles.Stations(istation).Errors(i) = str2num(get(hObject,'String'));
elseif xtype == 'W'
    handles.Stations(istation).Weight = str2num(get(hObject,'String'));
end

guidata(hObject, handles);

% --- Executes on button press in goinversion.
function goinversion_Callback(hObject, eventdata, handles)
% hObject    handle to goinversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if not(isempty(handles.Sources)) && not(isempty(handles.Stations))
    handles.SourcesHistory{end+1} = handles.Sources;
    if length(handles.SourcesHistory) > handles.SourcesHistoryLength
        handles.SourcesHistory(1) = [];
    end
    handles.Sources = solveGA(handles.Sources, handles.Stations, handles.GAparameters, handles.Terrain, get(handles.isconstrained,'Value'), handles.ObjFunction);
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);
end


% --- Executes on button press in savesources.
function savesources_Callback(hObject, eventdata, handles)
% hObject    handle to savesources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( ...
    {'*.srs','Sources files (*.srs)'}, ...
    'Save All Sources');

if isequal(filename,0) | isequal(pathname,0)
else
    fid = fopen(fullfile(pathname,filename),'w');
    fprintf(fid,'%d\n',length(handles.Sources));
    for i=1:length(handles.Sources)
        fid = writeSourceInFile(fid,handles.Sources(i));
    end
    fclose(fid);
end

% --



% --- Executes on button press in savemeasures.
function savemeasures_Callback(hObject, eventdata, handles)
% hObject    handle to savemeasures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uiputfile( ...
    {'*.sts','Stations files (*.sts)'; ...
    '*.txt','Text file (*.txt)'}, ...
    'Save All Stations');

if isequal(filename,0) | isequal(pathname,0)
else
    [pathstr, name, ext] = fileparts(filename);
    if strcmp(ext,'.sts')
    fid = fopen(fullfile(pathname,filename),'w');
    fprintf(fid,'%d\n',length(handles.Stations));
    for i=1:length(handles.Stations)
        fid = writeStationInFile(fid,handles.Stations(i));
    end
    fclose(fid);
    elseif strcmp(ext,'.txt')
        fid = fopen(fullfile(pathname,filename),'w');
        for i=1:length(handles.Stations) 
            if (strcmp(handles.Stations(i).Type,'Displacement'))
                fprintf(fid,'%s %f %f %f %f %f %f %f %f %f \r\n',handles.Stations(i).Name(1:min(4,length(handles.Stations(i).Name))), ...          
                handles.Stations(i).Coordinates(1),handles.Stations(i).Coordinates(2),handles.Stations(i).Coordinates(3),...
                handles.Stations(i).Measurements(1),handles.Stations(i).Measurements(2),handles.Stations(i).Measurements(3),...
                handles.Stations(i).Errors(1),handles.Stations(i).Errors(2),handles.Stations(i).Errors(3));
            elseif (strcmp(handles.Stations(i).Type,'Tiltmeter'))
                fprintf(fid,'%s %f %f %f %f %f %f %f \r\n', handles.Stations(i).Name(1:min(4,length(handles.Stations(i).Name))), ...
                    handles.Stations(i).Coordinates(1),handles.Stations(i).Coordinates(2),handles.Stations(i).Coordinates(3),...
                    handles.Stations(i).Measurements(1),handles.Stations(i).Measurements(2),...
                    handles.Stations(i).Errors(1),handles.Stations(i).Errors(2));
            elseif (strcmp(handles.Stations(i).Type,'Altimeter'))
               fprintf(fid,'%s %f %f %f %f %f \r\n',handles.Stations(i).Name(1:min(4,length(handles.Stations(i).Name))), ...
                    handles.Stations(i).Coordinates(1),handles.Stations(i).Coordinates(2),handles.Stations(i).Coordinates(3),...
                    handles.Stations(i).Measurements(1),...
                    handles.Stations(i).Errors(1));
            end
        end
        
        fclose(fid);
        
    end
end


% --- Executes on button press in loadsources.
function loadsources_Callback(hObject, eventdata, handles)
% hObject    handle to loadsources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.srs','Sources files (*.srs)'}, ...
    'Load All Sources');

if isequal(filename,0) | isequal(pathname,0)
else
    fid = fopen(fullfile(pathname,filename),'r');
    handles.Sources = [];
    NSource = str2num(fgets(fid));
    for i=1:NSource
        [fid Source] = readSourceFromFile(fid);
        handles.Sources = [Source, handles.Sources];
    end
    fclose(fid);
    
    for i=1:length(handles.Sources)
        listtype{i} = handles.Sources(i).Type;
    end
    set(handles.sourcelist,'String',listtype);
    set(handles.sourcelist,'Value',1);
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);
end



% --- Executes on button press in loadmeasures.
function loadmeasures_Callback(hObject, eventdata, handles)
% hObject    handle to loadmeasures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
    {'*.sts','Stations files (*.sts)'; ...
    '*.org','GlobK Comb (*.org)'; ...
    '*.txt','Text File (*.txt)'; ...
    '*.vel','Vel File (*.vel)'}, ...
    'Load All Stations');

if isequal(filename,0) || isequal(pathname,0)
else
    
    handles = importdatafromfile(handles, pathname, filename, 1);
    for i=1:length(handles.Stations)
        listtype{i} = handles.Stations(i).Name;
    end
    set(handles.stationlist,'String',listtype);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    displayMeasurements(hObject, eventdata, handles);
end

function handles = importdatafromfile(handles, pathname, filename, cleanlist)

[pathstr, name, ext] = fileparts(filename);
if strcmp(ext,'.sts')
    fid = fopen(fullfile(pathname,filename),'r');
            if cleanlist
                handles.Stations = [];
            end
    handles.Stations = [handles.Stations, readStations(fid, 'UTM-NEU')];
    fclose(fid);
elseif strcmp(ext,'.txt')
    stypes = {'3D Displacement', 'Baseline','Levelling','P-axes','Strain','Tilt'};
    indx = listdlg('PromptString','Type Sources:',...
        'SelectionMode','single','ListString',stypes);
    if ~isempty(indx)
        button = stypes{indx};
        if strcmp(button,'3D Displacement')
            fid = fopen(fullfile(pathname,filename),'r');
            C = textscan(fid,'%s %f %f %f %f %f %f %f %f %f','Delimiter',' ','MultipleDelimsAsOne',1);
            %             C = textscan(fid,'%f %f %f %f %f %f');
            if cleanlist
                handles.Stations = [];
            end
            fclose(fid);
            NStations = length(C{2});
            for i=1:NStations
                Station = newDisplacementStation();
                Station.Name = strtrim(C{1}{i});
                Station.Coordinates = [C{2}(i) C{3}(i) C{4}(i)];
                Station.Measurements = [C{5}(i) C{6}(i) C{7}(i)];
                Station.Errors = [C{8}(i) C{9}(i) C{10}(i)];
                %                 Station.Name = num2str(i); C{1}(i,:);
                %                 Station.Coordinates = [C{2}(i) C{1}(i) C{3}(i)];
                %                 Station.Measurements = [C{5}(i) C{4}(i) C{6}(i)];
                %                 Station.Errors = 1*[1 1 1]; %[C{8}(i) C{9}(i) C{10}(i)];
                if ~isempty(Station.Name)
                    handles.Stations = [handles.Stations, Station];
                end
            end
        elseif strcmp(button,'Levelling')
            fid = fopen(fullfile(pathname,filename),'r');
            C = textscan(fid,'%s %f %f %f %f %f','Delimiter',' ','MultipleDelimsAsOne',1);
            if cleanlist
                handles.Stations = [];
            end
            fclose(fid);
            NStations = length(C{2});
            for i=1:NStations
                Station = newLevellingStation();
                Station.Name = strtrim(C{1}{i});
                Station.Coordinates = [C{2}(i) C{3}(i) C{4}(i)];
                Station.Measurements = C{5}(i);
                Station.Errors = C{6}(i);
                if ~isempty(Station.Name)
                    handles.Stations = [handles.Stations, Station];
                end
            end
        elseif strcmp(button,'Baseline')
            fid = fopen(fullfile(pathname,filename),'r');
            C = textscan(fid,'%s %f %f %f %f %f %f %f %f','Delimiter',' ','MultipleDelimsAsOne',1);
            if cleanlist
                handles.Stations = [];
            end
            fclose(fid);
            NStations = length(C{2});
            for i=1:NStations
                Station = newBaselineStation();
                Station.Name = strtrim(C{1}{i});
                Station.Coordinates = [C{2}(i) C{3}(i) C{4}(i) C{5}(i) C{6}(i) C{7}(i)];
                Station.Measurements = C{8}(i);
                Station.Errors = C{9}(i);
                if ~isempty(Station.Name)
                    handles.Stations = [handles.Stations, Station];
                end
            end
            
            
        elseif strcmp(button,'Strain')
            fid = fopen(fullfile(pathname,filename),'r');
            C = textscan(fid,'%s %f %f %f %f %f','Delimiter',' ','MultipleDelimsAsOne',1);
            if cleanlist
                handles.Stations = [];
            end
            fclose(fid);
            NStations = length(C{2});
            for i=1:NStations
                Station = newStrainmeterStation();
                Station.Name = strtrim(C{1}{i});
                Station.Coordinates = [C{2}(i) C{3}(i) C{4}(i)];
                Station.Measurements = C{5}(i);
                Station.Errors = C{6}(i);
                if ~isempty(Station.Name)
                    handles.Stations = [handles.Stations, Station];
                end
            end
        elseif strcmp(button,'Tilt')
            fid = fopen(fullfile(pathname,filename),'r');
            C = textscan(fid,'%s %f %f %f %f %f %f %f','Delimiter',' ','MultipleDelimsAsOne',1);
            if cleanlist
                handles.Stations = [];
            end
            fclose(fid);
            NStations = length(C{2});
            for i=1:NStations
                Station = newTiltmeterStation();
                Station.Name = strtrim(C{1}{i});
                Station.Coordinates = [C{2}(i) C{3}(i) C{4}(i)];
                Station.Measurements = [C{5}(i), C{6}(i)];
                Station.Errors = [C{7}(i), C{8}(i)];
                if ~isempty(Station.Name)
                    handles.Stations = [handles.Stations, Station];
                end
            end
        elseif strcmp(button,'P-axes')
            fid = fopen(fullfile(pathname,filename),'r');
            C = textscan(fid,'%s %f %f %f %f %f %f %f','Delimiter',' ','MultipleDelimsAsOne',1);
            if cleanlist
                handles.Stations = [];
            end
            fclose(fid);
            Names = C{1};
            Long = C{3};
            Lat = C{2};
            H = -C{4}*1000;
            Azi = C{5};
            Dip = C{6};
            eAzi = C{7};
            eDip = C{8};
            if cleanlist
                handles.Stations = [];
            end
            NStations = length(C{3});
            for i=1:NStations
                [N,E]= ell2utm(Lat(i)*pi/180,Long(i)*pi/180,6378137,0.00669437999014);
                Station = newPaxesStation();
                Station.Name = strtrim(C{1}{i});
                Station.Coordinates = [N E H(i)];
                Station.Measurements = [Azi(i) Dip(i)];
                Station.Errors = [eAzi(i) eDip(i)];
                if ~isempty(Station.Name)
                    handles.Stations = [handles.Stations, Station];
                end
            end
        end
    end
elseif strcmp(ext,'.org')
    
    NETWORK = readORGfile(fullfile(pathname,filename));
    
    Long = NETWORK.StationPosLon;
    Lat = NETWORK.StationPosLat;
    vE = NETWORK.StationVelocityEast;
    vN = NETWORK.StationVelocityNorth;
    vU = NETWORK.StationVelocityUp;
    veE = NETWORK.StationErrorVelocityEast;
    veN = NETWORK.StationErrorVelocityNorth;
    veU = NETWORK.StationErrorVelocityUp;
    ndays = NETWORK.NumberOfConsideredDays;
    Names = char(NETWORK.StationName);
    
    answer = inputdlg('Time Span (days):','Velocity to Displacement',1,{num2str(ndays)});
    nyears = str2double(char(answer))/365;
    if cleanlist
        
        handles.Stations = [];
    end
    NStations = length(Long);
    for i=1:NStations
        [N,E]= ell2utm(Lat(i)*pi/180,Long(i)*pi/180,6378137,0.00669437999014);
        Station = newDisplacementStation();
        Station.Name = strtrim(Names(i,:)); Station.Name = Station.Name(1:4);
        Station.Coordinates = [N E 0];
        Station.Measurements = [vN(i) vE(i) vU(i)]*nyears/1000;
        Station.Errors = [veN(i) veE(i) veU(i)]*nyears/1000;
                handles.Stations = [handles.Stations, Station];
    end
elseif strcmp(ext,'.vel')
    
    NETWORK = readVELfile(fullfile(pathname,filename));
    
    Long = NETWORK.StationPosLon;
    Lat = NETWORK.StationPosLat;
    vE = NETWORK.StationVelocityEast;
    vN = NETWORK.StationVelocityNorth;
    vU = NETWORK.StationVelocityUp;
    veE = NETWORK.StationErrorVelocityEast;
    veN = NETWORK.StationErrorVelocityNorth;
    veU = NETWORK.StationErrorVelocityUp;
    Names = char(NETWORK.StationName);
    if cleanlist
        
        handles.Stations = [];
    end
    NStations = length(Long);
    for i=1:NStations
        [N,E]= ell2utm(Lat(i)*pi/180,Long(i)*pi/180,6378137,0.00669437999014);
        Station = newDisplacementStation();
        Station.Name = strtrim(Names(i,:)); Station.Name = Station.Name(1:4);
        Station.Coordinates = [N E 0];
        Station.Measurements = [vN(i) vE(i) vU(i)]/1000;
        Station.Errors = [veN(i) veE(i) veU(i)]/1000;
                handles.Stations = [handles.Stations, Station];
    end
    
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function loadall_Callback(hObject, eventdata, handles)
% hObject    handle to loadall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
    {'*.gim','Geodetic Inversion Model (*.gim)'}, ...
    'Load a model');

if isequal(filename,0) || isequal(pathname,0)
else
    loadgim(hObject, eventdata, handles, pathname,filename);
end

function loadgim(hObject, eventdata, handles, pathname,filename)

fid = fopen(fullfile(pathname,filename),'r');
handles.Sources = [];
handles.Stations = [];
handles.Sensors = [];

listtypesources = {};
listtypestations = {};
listtypesensors = {};
NSource = str2num(fgets(fid));
for i=1:NSource
    [fid Source] = readSourceFromFile(fid);
    handles.Sources = [Source, handles.Sources];
end
for i=1:length(handles.Sources)
    listtypesources{i} = handles.Sources(i).Type;
end
handles.Stations = readStations(fid, 'UTM-NEU');
%    NStations = str2num(fgets(fid));
%     for i=1:NStations
%         [fid Station] = readStationFromFile(fid);
%         handles.Stations = [Station, handles.Stations];
%     end
for i=1:length(handles.Stations)
    listtypestations{i} = handles.Stations(i).Name;
end
NSensors = str2num(fgets(fid));
for i=1:NSensors
    [fid Sensor] = readStationFromFile(fid);
    handles.Sensors = [Sensor, handles.Sensors];
end
for i=1:length(handles.Sensors)
    listtypesensors{i} = handles.Sensors(i).Name;
end

handles.GAparameters.Generations = str2num(fgets(fid));
handles.GAparameters.Crossover = str2num(fgets(fid));
handles.GAparameters.Elite = str2num(fgets(fid));
handles.GAparameters.PopulationSize = str2num(fgets(fid));
handles.GAparameters.Migration = str2num(fgets(fid));
handles.ObjFunction = fgets(fid);
handles.GAparameters.CrossType = strtrim(fgets(fid));
handles.GAparameters.CrossParam = str2num(fgets(fid));
handles.GAparameters.SelectionType = strtrim(fgets(fid));
handles.GAparameters.SelectionParam = str2num(fgets(fid));
handles.GAparameters.MutationType = strtrim(fgets(fid));
handles.GAparameters.MutationParam1 = str2num(fgets(fid));
handles.GAparameters.MutationParam2 = str2num(fgets(fid));
handles.GAparameters.NumIslands = str2num(fgets(fid));
handles.NEstimation = str2num(fgets(fid));
handles.GAparameters.MigrationInterval = str2num(fgets(fid));
handles.GAparameters.MigrationDirection = strtrim(fgets(fid));

handles.PSparameters.Poll = strtrim(fgets(fid));
handles.PSparameters.Search = strtrim(fgets(fid));
handles.PSparameters.CacheSize = str2num(fgets(fid));
handles.PSparameters.CacheOk = str2num(fgets(fid));
handles.PSparameters.Mesh  = str2num(fgets(fid));
handles.PSparameters.Contraction = str2num(fgets(fid));
handles.PSparameters.Expansion = str2num(fgets(fid));
handles.PSparameters.InitPenalty = str2num(fgets(fid));
handles.PSparameters.NumIter = str2num(fgets(fid));
handles.PSparameters.PenaltyFactor = str2num(fgets(fid));
handles.PSparameters.completepoll = str2num(fgets(fid));

fclose(fid);

set(handles.stationlist,'String',listtypestations);
set(handles.stationlist,'Value',1);
set(handles.sourcelist,'String',listtypesources);
set(handles.sourcelist,'Value',1);
set(handles.sensorlist,'String',listtypesensors);
set(handles.sensorlist,'Value',1);
guidata(hObject, handles);
displayMeasurements(hObject, eventdata, handles);
handles = guidata(hObject);
displayParameters(hObject, eventdata, handles);
handles = guidata(hObject);
displaySensors(hObject, eventdata, handles);
GAparams2GUI(handles);
PSparams2GUI(handles);
Terrain2GUI(handles);
set(gcf, 'Name', ['GAME ',fullfile(pathname,filename)]);



% --------------------------------------------------------------------
function saveall_Callback(hObject, eventdata, handles)
% hObject    handle to saveall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uiputfile( ...
    {'*.gim','Geodetic Inversion Model (*.gim)'}, ...
    'Save the model');

if isequal(filename,0) || isequal(pathname,0)
else
    savegim(handles, pathname, filename);
end

function savegim(handles, pathname, filename)
fid = fopen(fullfile(pathname,filename),'w');
fprintf(fid,'%d\n',length(handles.Sources));
for i=1:length(handles.Sources)
    fid = writeSourceInFile(fid,handles.Sources(i));
end
fprintf(fid,'%d\n',length(handles.Stations));
for i=1:length(handles.Stations)
    fid = writeStationInFile(fid,handles.Stations(i));
end
fprintf(fid,'%d\n',length(handles.Sensors));
for i=1:length(handles.Sensors)
    fid = writeStationInFile(fid,handles.Sensors(i));
end

fprintf(fid,'%f\n',handles.GAparameters.Generations);
fprintf(fid,'%f\n',handles.GAparameters.Crossover);
fprintf(fid,'%f\n',handles.GAparameters.Elite);
fprintf(fid,'%f\n',handles.GAparameters.PopulationSize);
fprintf(fid,'%f\n',handles.GAparameters.Migration);
fprintf(fid,'%s\n',strtrim(handles.ObjFunction));
fprintf(fid,'%s\n',strtrim(handles.GAparameters.CrossType));
fprintf(fid,'%f\n',handles.GAparameters.CrossParam);
fprintf(fid,'%s\n',strtrim(handles.GAparameters.SelectionType));
fprintf(fid,'%f\n',handles.GAparameters.SelectionParam);
fprintf(fid,'%s\n',strtrim(handles.GAparameters.MutationType));
fprintf(fid,'%f\n',handles.GAparameters.MutationParam1);
fprintf(fid,'%f\n',handles.GAparameters.MutationParam2);
fprintf(fid,'%i\n',handles.GAparameters.NumIslands);
fprintf(fid,'%f\n',handles.NEstimation);
fprintf(fid,'%f\n',handles.GAparameters.MigrationInterval);
fprintf(fid,'%s\n',strtrim(handles.GAparameters.MigrationDirection));


fprintf(fid,'%s\n',handles.PSparameters.Poll);
fprintf(fid,'%s\n',handles.PSparameters.Search);
fprintf(fid,'%f\n',handles.PSparameters.CacheSize);
fprintf(fid,'%f\n',handles.PSparameters.CacheOk);
fprintf(fid,'%f\n',handles.PSparameters.Mesh);
fprintf(fid,'%f\n',handles.PSparameters.Contraction);
fprintf(fid,'%f\n',handles.PSparameters.Expansion);
fprintf(fid,'%f\n',handles.PSparameters.InitPenalty);
fprintf(fid,'%f\n',handles.PSparameters.NumIter);
fprintf(fid,'%f\n',handles.PSparameters.PenaltyFactor);
fprintf(fid,'%f\n',handles.PSparameters.completepoll);

fclose(fid);
set(gcf, 'Name', ['GAME ',fullfile(pathname,filename)]);



function niterations_Callback(hObject, eventdata, handles)
% hObject    handle to niterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of niterations as text
%        str2double(get(hObject,'String')) returns contents of niterations as a double
handles.GAparameters.Generations = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function niterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to niterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function crossover_Callback(hObject, eventdata, handles)
% hObject    handle to crossover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of crossover as text
%        str2double(get(hObject,'String')) returns contents of crossover as a double
handles.GAparameters.Crossover = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function crossover_CreateFcn(hObject, eventdata, handles)
% hObject    handle to crossover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elitecount_Callback(hObject, eventdata, handles)
% hObject    handle to elitecount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elitecount as text
%        str2double(get(hObject,'String')) returns contents of elitecount as a double
handles.GAparameters.Elite = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function elitecount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elitecount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function populationsize_Callback(hObject, eventdata, handles)
% hObject    handle to populationsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of populationsize as text
%        str2double(get(hObject,'String')) returns contents of populationsize as a double
handles.GAparameters.PopulationSize = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function populationsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to populationsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function migration_Callback(hObject, eventdata, handles)
% hObject    handle to migration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of migration as text
%        str2double(get(hObject,'String')) returns contents of migration as a double
handles.GAparameters.Migration = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function migration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to migration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PSparams2GUI(handles)

set(handles.pscachesize,'String',num2str(handles.PSparameters.CacheSize));
set(handles.pscache,'Value',handles.PSparameters.CacheOk);
set(handles.psmeshsize,'String',num2str(handles.PSparameters.Mesh));
set(handles.pscontract,'String',num2str(handles.PSparameters.Contraction));
set(handles.psexpansion,'String',num2str(handles.PSparameters.Expansion));
set(handles.psinitpenalty,'String',num2str(handles.PSparameters.InitPenalty));
set(handles.psiter,'String',num2str(handles.PSparameters.NumIter));
set(handles.pspenaltyfact,'String',num2str(handles.PSparameters.PenaltyFactor));
set(handles.pscompletepoll,'Value',handles.PSparameters.completepoll);

s = get(handles.pssearch,'String');
for i=1:length(s)
    if strcmp(strtrim(handles.PSparameters.Search),strtrim(s{i}))
        set(handles.pssearch,'Value',i);
    end
end

s = get(handles.pspoll,'String');
for i=1:length(s)
    if strcmp(strtrim(handles.PSparameters.Poll),strtrim(s{i}))
        set(handles.pspoll,'Value',i);
    end
end



function GAparams2GUI(handles)

set(handles.niterations,'String',num2str(handles.GAparameters.Generations));
set(handles.crossover,'String',num2str(handles.GAparameters.Crossover));
set(handles.elitecount,'String',num2str(handles.GAparameters.Elite));
set(handles.populationsize,'String',num2str(handles.GAparameters.PopulationSize));
set(handles.migration,'String',num2str(handles.GAparameters.Migration));
lf = get(handles.typeobjective,'String');
for i=1:length(lf)
    if strcmp(strtrim(handles.ObjFunction),strtrim(lf{i}))
        break;
    end
end
set(handles.typeobjective,'Value',i);
set(handles.crossparam,'String',num2str(handles.GAparameters.CrossParam));
set(handles.selecparam,'String',num2str(handles.GAparameters.SelectionParam));
set(handles.mutaparam1,'String',num2str(handles.GAparameters.MutationParam1));
set(handles.mutaparam2,'String',num2str(handles.GAparameters.MutationParam2));
set(handles.nislands,'Value',handles.GAparameters.NumIslands);
set(handles.migratinterval,'String',num2str(handles.GAparameters.MigrationInterval));


s = get(handles.crosstype,'String');
for i=1:length(s)
    if strcmp(strtrim(handles.GAparameters.CrossType),strtrim(s{i}))
        set(handles.crosstype,'Value',i);
    end
end

s = get(handles.selectype,'String');
for i=1:length(s)
    if strcmp(strtrim(handles.GAparameters.SelectionType),strtrim(s{i}))
        set(handles.selectype,'Value',i);
    end
end

s = get(handles.mutatype,'String');
for i=1:length(s)
    if strcmp(strtrim(handles.GAparameters.MutationType),strtrim(s{i}))
        set(handles.mutatype,'Value',i);
    end
end

s = get(handles.migratdirection,'String');
for i=1:length(s)
    if strcmp(strtrim(handles.GAparameters.MigrationDirection),strtrim(s{i}))
        set(handles.migratdirection,'Value',i);
    end
end

%---------
function GUI2PSparams(hObject,handles)

i = get(handles.pspoll,'Value');
s = get(handles.pspoll,'String');
handles.PSparameters.Poll = s{i};

i = get(handles.pssearch,'Value');
s = get(handles.pssearch,'String');
handles.PSparameters.Search = s{i};

handles.PSparameters.CacheSize = str2double(get(handles.pscachesize,'String'));
handles.PSparameters.CacheOk = get(handles.pscache,'Value');
handles.PSparameters.completepoll = get(handles.pscompletepoll,'Value');

handles.PSparameters.Mesh = str2double(get(handles.psmeshsize,'String'));
handles.PSparameters.Contraction = str2double(get(handles.pscontract,'String'));
handles.PSparameters.Expansion = str2double(get(handles.psexpansion,'String'));
handles.PSparameters.InitPenalty = str2double(get(handles.psinitpenalty,'String'));
handles.PSparameters.NumIter = str2double(get(handles.psiter,'String'));
handles.PSparameters.PenaltyFactor = str2double(get(handles.pspenaltyfact,'String'));


guidata(hObject, handles);

%-----------

function GUI2GAparams(hObject,handles)

handles.GAparameters.Generations = str2double(get(handles.niterations,'String'));
handles.GAparameters.Crossover = str2double(get(handles.crossover,'String'));
handles.GAparameters.Elite = str2double(get(handles.elitecount,'String'));
handles.GAparameters.PopulationSize = str2double(get(handles.populationsize,'String'));
handles.GAparameters.Migration = str2double(get(handles.migration,'String'));
handles.GAparameters.CrossParam = str2double(get(handles.crossparam,'String'));
handles.GAparameters.SelectionParam = str2double(get(handles.selecparam,'String'));
handles.GAparameters.MutationParam1 = str2double(get(handles.mutaparam1,'String'));
handles.GAparameters.MutationParam2 = str2double(get(handles.mutaparam2,'String'));
handles.GAparameters.NumIslands = get(handles.nislands,'Value');
handles.GAparameters.MigrationInterval = str2double(get(handles.migratinterval,'String'));

i = get(handles.crosstype,'Value');
s = get(handles.crosstype,'String');
handles.GAparameters.CrossType = s{i};
i = get(handles.selectype,'Value');
s = get(handles.selectype,'String');
handles.GAparameters.SelectionType = s{i};
i = get(handles.mutatype,'Value');
s = get(handles.mutatype,'String');
handles.GAparameters.MutationType = s{i};
i = get(handles.migratdirection,'Value');
s = get(handles.migratdirection,'String');
handles.GAparameters.MigrationDirection = s{i};


guidata(hObject,handles);
typeobjective_Callback(hObject, [], handles);


function GUI2Terrain(hObject,handles)

handles.Terrain.Poisson = str2double(get(handles.poisson,'String'));
handles.Terrain.rmu = str2double(get(handles.rmu,'String'));
% handles.Terrain.Volume = str2double(get(handles.vol,'String'));
guidata(hObject,handles);

function Terrain2GUI(handles)

set(handles.poisson,'String',num2str(handles.Terrain.Poisson));
set(handles.rmu,'String',num2str(handles.Terrain.rmu));

% --- Executes on selection change in sensorlist.
function sensorlist_Callback(hObject, eventdata, handles)
% hObject    handle to sensorlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sensorlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sensorlist
displaySensors(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function sensorlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensorlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savesensors.
function savesensors_Callback(hObject, eventdata, handles)
% hObject    handle to savesensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( ...
    {'*.sts','Stations files (*.sts)';
    '*.gmt','GMT format (*.gmt)';
    '*.txt','Text file (*.txt)'}, ...
    'Save All Sensors');

if isequal(filename,0) || isequal(pathname,0)
else
    [pathstr, name, ext] = fileparts(filename);
    if strcmp(ext,'.sts')
        fid = fopen(fullfile(pathname,filename),'w');
        fprintf(fid,'%d\n',length(handles.Sensors));
        for i=1:length(handles.Sensors)
            fid = writeStationInFile(fid,handles.Sensors(i));
        end
        fclose(fid);
    elseif strcmp(ext,'.gmt')
        utmzone = char(inputdlg('UTM Zone','utm zone',1,{'33 T'}));
        if ~isempty(utmzone)
            answer = inputdlg({'Days'},'Time Span',1,{'365'});
            if ~isempty(answer)
                tspan = str2double(char(answer));
                
                fid = fopen(fullfile(pathname,filename),'w');
                for i=1:length(handles.Sensors)
                    [lat,lon] = utm2latlon(handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(1),utmzone);
                    fprintf(fid,' %g %g %f %f %f %f %g %g 0.0 %f %f %g %s\n',lon,lat,...
                        handles.Sensors(i).Measurements(2)*1000*365/tspan,handles.Sensors(i).Measurements(1)*1000*365/tspan,...
                        handles.Sensors(i).Measurements(2)*1000*365/tspan,handles.Sensors(i).Measurements(1)*1000*365/tspan,...
                        handles.Sensors(i).Errors(2)*1000*365/tspan,handles.Sensors(i).Errors(1)*1000*365/tspan,...
                        handles.Sensors(i).Measurements(3)*1000*365/tspan,handles.Sensors(i).Measurements(3)*1000*365/tspan,...
                        handles.Sensors(i).Errors(3)*1000*365/tspan,...
                        handles.Sensors(i).Name);
                end
                
                fclose(fid);
            end
        end
    elseif strcmp(ext,'.txt')
        fid = fopen(fullfile(pathname,filename),'w');
        for i=1:length(handles.Sensors) 
            if (strcmp(handles.Sensors(i).Type,'Displacement'))
                fprintf(fid,'%s %f %f %f %f %f %f %f %f %f \r\n',handles.Sensors(i).Name(1:min(4,length(handles.Sensors(i).Name))), ...          
                handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(3),...
                handles.Sensors(i).Measurements(1),handles.Sensors(i).Measurements(2),handles.Sensors(i).Measurements(3),...
                handles.Sensors(i).Errors(1),handles.Sensors(i).Errors(2),handles.Sensors(i).Errors(3));
            elseif (strcmp(handles.Sensors(i).Type,'Tiltmeter'))
                fprintf(fid,'%s %f %f %f %f %f %f %f \r\n', handles.Sensors(i).Name(1:min(4,length(handles.Sensors(i).Name))), ...
                    handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(3),...
                    handles.Sensors(i).Measurements(1),handles.Sensors(i).Measurements(2),...
                    handles.Sensors(i).Errors(1),handles.Sensors(i).Errors(2));
            elseif (strcmp(handles.Sensors(i).Type,'Altimeter'))
               fprintf(fid,'%s %f %f %f %f %f \r\n',handles.Sensors(i).Name(1:min(4,length(handles.Sensors(i).Name))), ...
                    handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(3),...
                    handles.Sensors(i).Measurements(1),...
                    handles.Sensors(i).Errors(1));
            elseif (strcmp(handles.Sensors(i).Type,'Strainmeter'))
               fprintf(fid,'%s %f %f %f %f %f \r\n',handles.Sensors(i).Name(1:min(4,length(handles.Sensors(i).Name))), ...
                    handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(3),...
                    handles.Sensors(i).Measurements(1),...
                    handles.Sensors(i).Errors(1));
            elseif (strcmp(handles.Sensors(i).Type,'Gravity'))
               fprintf(fid,'%s %f %f %f %f %f \r\n',handles.Sensors(i).Name(1:min(4,length(handles.Sensors(i).Name))), ...
                    handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(3),...
                    handles.Sensors(i).Measurements(1),...
                    handles.Sensors(i).Errors(1));
            end
        end
        
        fclose(fid);
        
    end
end

% --- Executes on button press in loadsensors.
function loadsensors_Callback(hObject, eventdata, handles)
% hObject    handle to loadsensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.sts','Stations files (*.sts)'}, ...
    'Load All Sensors');

if isequal(filename,0) || isequal(pathname,0)
else
    fid = fopen(fullfile(pathname,filename),'r');
    handles.Sensors = [];
    Sensor = readStations(fid, 'UTM-NEU');
    handles.Sensors = Sensor;
    [pathstr, name, ext] = fileparts(filename);
    
    %     NSensors = str2num(fgets(fid));
    %     for i=1:NSensors
    %         [fid Sensor] = readStationFromFile(fid);
    %         handles.Sensors = [Sensor, handles.Sensors];
    %     end
    fclose(fid);
    
    for i=1:length(handles.Sensors)
        listtype{i} = handles.Sensors(i).Name;
    end
    set(handles.sensorlist,'String',listtype);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    displaySensors(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function SensorMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SensorMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function newsensordispacement_Callback(hObject, eventdata, handles)
% hObject    handle to newsensordispacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Sensor',1,{'noname'});
if ~isempty(answer)
    
    S = newDisplacementStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function deletesensor_Callback(hObject, eventdata, handles)
% hObject    handle to deletesensor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.sensorlist,'String'))
    i = get(handles.sensorlist,'Value');
    ss = get(handles.sensorlist,'String');
    ss(i) = [];
    handles.Sensors(i) = [];
    set(handles.sensorlist,'Value',1);
    set(handles.sensorlist,'String',ss);
    guidata(hObject, handles);
    displaySensors(hObject, eventdata, handles);
end

% --- Executes on button press in addsources.
function addsources_Callback(hObject, eventdata, handles)
% hObject    handle to addsources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.srs','Sources files (*.srs)'}, ...
    'Load All Sources');

if isequal(filename,0) | isequal(pathname,0)
else
    fid = fopen(fullfile(pathname,filename),'r');
    NSource = str2num(fgets(fid));
    for i=1:NSource
        [fid Source] = readSourceFromFile(fid);
        handles.Sources = [Source, handles.Sources];
    end
    fclose(fid);
    for i=1:length(handles.Sources)
        listtype{i} = handles.Sources(i).Type;
    end
    set(handles.sourcelist,'String',listtype);
    set(handles.sourcelist,'Value',1);
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);
end




% --- Executes on button press in addstations.
function addstations_Callback(hObject, eventdata, handles)
% hObject    handle to addstations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.sts','Stations files (*.sts)'; ...
    '*.org','GlobK Comb (*.org)'; ...
    '*.txt','Text File (*.txt)'}, ...
    'Load All Stations');

if isequal(filename,0) || isequal(pathname,0)
else
    handles = importdatafromfile(handles, pathname, filename, 0);
    for i=1:length(handles.Stations)
        listtype{i} = handles.Stations(i).Name;
    end
    set(handles.stationlist,'String',listtype);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    displayMeasurements(hObject, eventdata, handles);
end



% --- Executes on button press in addsensors.
function addsensors_Callback(hObject, eventdata, handles)
% hObject    handle to addsensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
    {'*.sts','Sensors files (*.sts)'}, ...
    'Load All Sensors');

if isequal(filename,0) | isequal(pathname,0)
else
    fid = fopen(fullfile(pathname,filename),'r');
    NSensors = str2num(fgets(fid));
    for i=1:NSensors
        [fid Sensor] = readStationFromFile(fid);
        handles.Sensors = [Sensor, handles.Sensors];
    end
    fclose(fid);
    
    for i=1:length(handles.Sensors)
        listtype{i} = handles.Sensors(i).Name;
    end
    set(handles.sensorlist,'String',listtype);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    displaySensors(hObject, eventdata, handles);
end


% --- Executes on button press in stations2sensors.
function stations2sensors_Callback(hObject, eventdata, handles)
% hObject    handle to stations2sensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = get(handles.stationlist,'Value');
if ~isempty(I)
    for i=1:length(I)
        handles.Sensors = [handles.Sensors, handles.Stations(I(i))];
    end
end

for i=1:length(handles.Sensors)
    listtype{i} = handles.Sensors(i).Name;
end
if ~isempty(handles.Sensors)
    set(handles.sensorlist,'String',listtype);
    set(handles.sensorlist,'Value',1);
end
guidata(hObject, handles);
displaySensors(hObject, eventdata, handles);





function poisson_Callback(hObject, eventdata, handles)
% hObject    handle to poisson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of poisson as text
%        str2double(get(hObject,'String')) returns contents of poisson as a double
handles.Terrain.Poisson = str2double(get(handles.poisson,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function poisson_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poisson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmu_Callback(hObject, eventdata, handles)
% hObject    handle to rmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmu as text
%        str2double(get(hObject,'String')) returns contents of rmu as a double
handles.Terrain.rmu = str2double(get(handles.rmu,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function rmu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vol_Callback(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vol as text
%        str2double(get(hObject,'String')) returns contents of vol as a double

% --- Executes during object creation, after setting all properties.
function vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in evaluatemodel.
function evaluatemodel_Callback(hObject, eventdata, handles)
% hObject    handle to evaluatemodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles, err] = ForwardModel(handles);
guidata(hObject,handles);
if isempty(err)
    set(handles.errorresult,'String','');
else
    set(handles.errorresult,'String',num2str(err,'%10.5g'));
end
displaySensors(hObject, eventdata, handles);






function nestimation_Callback(hObject, eventdata, handles)
% hObject    handle to nestimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nestimation as text
%        str2double(get(hObject,'String')) returns contents of nestimation as a double


% --- Executes during object creation, after setting all properties.
function nestimation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nestimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in ploterrors.
function ploterrors_Callback(hObject, eventdata, handles)
% hObject    handle to ploterrors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Xlabels = [];
Xerrors = [];
for i=1:length(handles.Stations)
    k = 0;
    for j=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
            k = j;
        end
    end
    if k>0
        figure('Name',handles.Stations(i).Name,'NumberTitle','off');
        bar(1:handles.Stations(i).NMeasurements,abs(handles.Stations(i).Measurements - handles.Sensors(k).Measurements));
        title(handles.Stations(i).Name);
        set(gca,'XTick',1:handles.Stations(i).NMeasurements);
        set(gca,'XTickLabel',handles.Stations(i).NameMeasurements);
        Xerrors = [Xerrors, sqrt(sum((handles.Stations(i).Measurements - handles.Sensors(k).Measurements).^2))];
        Xlabels = [Xlabels, {handles.Stations(i).Name}];
    end
    
end

if ~isempty(Xerrors)
    figure('Name','Errors','NumberTitle','off');
    bar(1:length(Xerrors),Xerrors,'r');
    title('Errors');
    set(gca,'XTick',1:length(Xerrors));
    set(gca,'XTickLabel',Xlabels);
end



% --- Executes on button press in plotvectors.
function plotvectors_Callback(hObject, eventdata, handles)
% hObject    handle to plotvectors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x = []; y =[]; z = []; u = []; v = []; w =[];
for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Displacement')
        if all(isfinite(handles.Stations(i).Measurements))
            x = [x, handles.Stations(i).Coordinates(2)];
            y = [y, handles.Stations(i).Coordinates(1)];
            z = [z, handles.Stations(i).Coordinates(3)];
            
            u = [u, handles.Stations(i).Measurements(2)];
            v = [v, handles.Stations(i).Measurements(1)];
            w = [w, handles.Stations(i).Measurements(3)];
        end
    elseif strcmp(handles.Stations(i).Type,'HorizDisplacement')
        if all(isfinite(handles.Stations(i).Measurements))
            x = [x, handles.Stations(i).Coordinates(2)];
            y = [y, handles.Stations(i).Coordinates(1)];
            z = [z, 0];
            
            u = [u, handles.Stations(i).Measurements(2)];
            v = [v, handles.Stations(i).Measurements(1)];
            w = [w, 0];
        end
    end
end
figure
scala=0;
if (~isempty(handles.Stations)) && (~isempty(x))
    maxdist = max(pdist([x;y;z]'));
    maxleng = max(norm([u;v;w]'));
    scala = 0.5*maxdist/maxleng;
    quiver3(x,y,z,u*scala,v*scala,w*scala,0,'k','LineWidth',2,'MarkerSize',2);
    hold on;
end
x = []; y =[]; z = []; u = []; v = []; w =[];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Displacement')
        if all(isfinite(handles.Sensors(i).Measurements))
            x = [x, handles.Sensors(i).Coordinates(2)];
            y = [y, handles.Sensors(i).Coordinates(1)];
            z = [z, handles.Sensors(i).Coordinates(3)];
            
            u = [u, handles.Sensors(i).Measurements(2)];
            v = [v, handles.Sensors(i).Measurements(1)];
            w = [w, handles.Sensors(i).Measurements(3)];
        end
    elseif strcmp(handles.Sensors(i).Type,'HorizDisplacement')
        if all(isfinite(handles.Sensors(i).Measurements))
            x = [x, handles.Sensors(i).Coordinates(2)];
            y = [y, handles.Sensors(i).Coordinates(1)];
            z = [z, 0];
            
            u = [u, handles.Sensors(i).Measurements(2)];
            v = [v, handles.Sensors(i).Measurements(1)];
            w = [w, 0];
        end
    end
end
if ~isempty(handles.Sensors)
    if (scala==0) || (isinf(scala))
        maxdist = max(pdist([x;y;z]'));
        maxleng = max(norm([u;v;w]'));
        scala = 0.5*maxdist/maxleng;
    end
    if (~isempty(handles.Sensors)) && (~isempty(x))
        quiver3(x,y,z,u*scala,v*scala,w*scala,0,'r','LineWidth',2);
        ksens = 0;
        %     for i=1:length(handles.Sensors)
        %         if strcmp(handles.Sensors(i).Type,'Displacement')
        %             ksens = ksens+1;
        %             text(x(ksens),y(ksens),z(ksens),handles.Sensors(i).Name);
        %         elseif strcmp(handles.Sensors(i).Type,'HorizDisplacement')
        %             ksens = ksens+1;
        %             text(x(ksens),y(ksens),0,handles.Sensors(i).Name);
        %         end
        %     end
    end
end

x = []; y =[]; z = []; u = []; v = []; w =[];
for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Tiltmeter')
        if all(isfinite(handles.Stations(i).Measurements))
            x = [x, handles.Stations(i).Coordinates(2)];
            y = [y, handles.Stations(i).Coordinates(1)];
            z = [z, 0];
            
            u = [u, handles.Stations(i).Measurements(1)];
            v = [v, handles.Stations(i).Measurements(2)];
            w = [w, 0];
        end
    end
end
scala=0;
if (~isempty(handles.Stations)) && (~isempty(x))
    maxdist = max(pdist([x;y;z]'));
    maxleng = max(norm([u;v;w]'));
    scala = 0.5*maxdist/maxleng;
    quiver3(x,y,z,u*scala,v*scala,w*scala,0,'.b','LineWidth',2,'MarkerSize',2);
    hold on;
end
x = []; y =[]; z = []; u = []; v = []; w =[];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Tiltmeter')
        if all(isfinite(handles.Sensors(i).Measurements))
            x = [x, handles.Sensors(i).Coordinates(2)];
            y = [y, handles.Sensors(i).Coordinates(1)];
            z = [z, 0];
            
            u = [u, handles.Sensors(i).Measurements(1)];
            v = [v, handles.Sensors(i).Measurements(2)];
            w = [w, 0];
        end
    end
end
if ~isempty(handles.Sensors)
    if (scala==0) || (isinf(scala))
        maxdist = max(pdist([x;y;z]'));
        maxleng = max(norm([u;v;w]'));
        scala = 0.5*maxdist/maxleng;
    end
    if (~isempty(handles.Sensors)) && (~isempty(x))
        quiver3(x,y,z,u*scala,v*scala,w*scala,0,'.r','LineWidth',1);
        ksens = 0;
        for i=1:length(handles.Sensors)
            if strcmp(handles.Sensors(i).Type,'Tiltmeter')
                ksens = ksens+1;
                text(x(ksens),y(ksens),0,handles.Sensors(i).Name);
            end
        end
    end
end


hold off;
grid off;
xlabel('East');
ylabel('North');
zlabel('Up');
view(0,90);

% set(gca,'XTickLabel',' ');
% set(gca,'YTickLabel',' ');
% set(gca,'ZTickLabel',' ');
% colordef white
% set(gcf,'Color',[1,0.4,0.6])




% --------------------------------------------------------------------
function newokadastrikeslip_Callback(hObject, eventdata, handles)
% hObject    handle to newokadastrikeslip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function newokadadipslip_Callback(hObject, eventdata, handles)
% hObject    handle to newokadadipslip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function newokadatensile_Callback(hObject, eventdata, handles)
% hObject    handle to newokadatensile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in typeobjective.
function typeobjective_Callback(hObject, eventdata, handles)
% hObject    handle to typeobjective (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns typeobjective contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typeobjective
i = get(handles.typeobjective,'Value');
s = get(handles.typeobjective,'String');
handles.ObjFunction = strtrim(s{i});
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function typeobjective_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typeobjective (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function errorresult_Callback(hObject, eventdata, handles)
% hObject    handle to errorresult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of errorresult as text
%        str2double(get(hObject,'String')) returns contents of errorresult as a double


% --- Executes during object creation, after setting all properties.
function errorresult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorresult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function zeroparamserrors_Callback(hObject, eventdata, handles)
% hObject    handle to zeroparamserrors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


for i=1:length(handles.Sources)
    handles.Sources(i).EParameters = zeros(size(handles.Sources(i).EParameters));
end
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);


% --------------------------------------------------------------------
function cleanall_Callback(hObject, eventdata, handles)
% hObject    handle to cleanall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:length(handles.Sources)
    deletesource_Callback(handles.sourcelist, eventdata, handles);
    handles = guidata(hObject);
end

for i=1:length(handles.Stations)
    deletestation_Callback(handles.stationlist, eventdata, handles);
    handles = guidata(hObject);
end

for i=1:length(handles.Sensors)
    deletesensor_Callback(handles.sensorlist, eventdata, handles);
    handles = guidata(hObject);
end

guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);
handles = guidata(hObject);
displayMeasurements(hObject, eventdata, handles);
handles = guidata(hObject);
displaySensors(hObject, eventdata, handles);

set(gcf, 'Name', 'GAME');




% --- Executes during object creation, after setting all properties.
function text19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text19.
function text19_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web 'mailto:cannavo@ct.ingv.it'




% --- Executes on button press in plotsensitivity.
function plotsensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to plotsensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg({'N° Steps'},'Discretization',1,{'100'});

if isempty(answer)
else
    NSteps = str2double(answer);
    newhandles.Stations = handles.Stations;
    newhandles.Sensors = handles.Sensors;
    newhandles.Terrain = handles.Terrain;
    newhandles.Sources = handles.Sources;
    newhandles.NEstimation = handles.NEstimation;
    newhandles.estimerr = handles.estimerr;
    newhandles.ObjFunction = handles.ObjFunction;
    [tmphandles Err0] = ForwardModel(newhandles);
    
    for isource = 1:length(handles.Sources)
        fgs(isource) = figure('Name',handles.Sources(isource).Type,'NumberTitle','off');
        
        for ipar = 1:handles.Sources(isource).NParameters
            Errs = [];
            ovct = [];
            xvct = [];
            xzero = [];
            ozero = [];
            
            for istep = 1:NSteps
                newhandles.Sources = handles.Sources;
                newhandles.Sources(isource).Parameters(ipar) = newhandles.Sources(isource).LowBoundaries(ipar) + ((istep-1)/(NSteps-1))* (newhandles.Sources(isource).UpBoundaries(ipar)-newhandles.Sources(isource).LowBoundaries(ipar));
                xvct = [xvct;newhandles.Sources(isource).Parameters(ipar)];
                [tmphandles oerr] = ForwardModel(newhandles);
                ovct = [ovct; oerr];
            end
            %         for err = -5:0.2:5
            %             newhandles.Sources = handles.Sources;
            %             newhandles.Sources(isource).Parameters(ipar) = (1+err/100)*newhandles.Sources(isource).Parameters(ipar);
            %             xvct = [xvct;newhandles.Sources(isource).Parameters(ipar)];
            %             [tmphandles oerr] = ForwardModel(newhandles);
            %             if err ~= 0
            %                   Errs = [Errs; (oerr-Err0)*100/(err*Err0)];
            %             else
            %                 xzero = newhandles.Sources(isource).Parameters(ipar);
            %                 ozero = oerr;
            %             end
            %             ovct = [ovct; oerr];
            %         end
            hsplt(isource,ipar) = subplot(floor(handles.Sources(isource).NParameters/2+0.5),2,ipar);
            plot(xvct,ovct);
            hold on;
            plot(handles.Sources(isource).Parameters(ipar),Err0,'Or');
            hold off;
            
            icent = floor((handles.Sources(isource).Parameters(ipar) - newhandles.Sources(isource).LowBoundaries(ipar))/((newhandles.Sources(isource).UpBoundaries(ipar)-newhandles.Sources(isource).LowBoundaries(ipar))/(NSteps-1)));
            icent = min(icent + 1,length(ovct)-1);
            
            drvt = 0.5*((Err0-ovct(icent))/(handles.Sources(isource).Parameters(ipar) - xvct(icent)) + ...
                (ovct(icent+1)-Err0)/(xvct(icent+1)-handles.Sources(isource).Parameters(ipar)));
            
            bb = Err0 - drvt*handles.Sources(isource).Parameters(ipar);
            lntg = drvt*xvct + bb;
            
            Derivative(isource,ipar) = drvt;
            Sensitivity(isource,ipar) = drvt * handles.Sources(isource).Parameters(ipar)/Err0;
            
            hold on;
            plot(xvct,lntg,'g-');
            hold off;
            
            if (xvct(1)<xvct(end))
                set(gca,'xlim',[xvct(1) xvct(end)]);
            else
                set(gca,'xlim',[xvct(end) xvct(1)]);
            end
            title(handles.Sources(isource).ParameterNames{ipar});
            
            %         p = polyfit(xvct,ovct,1);
            %         Sensitivity(isource,ipar) =mean(Errs);% p(1);
            %         Derivative(isource,ipar) = p(1);
            exty(isource,ipar,:) = minmax(ovct(:)');
        end
    end
    
    miny = min(Err0,min(exty(:)))/2;
    maxy = prctile(exty(:),80);
    
    for isource = 1:length(handles.Sources)
        for ipar = 1:handles.Sources(isource).NParameters
            set(hsplt(isource,ipar),'ylim',[miny maxy]);
        end
    end
    
    figure
    bar3(Sensitivity');
    title('Sensitivity');
    figure
    bar3(Derivative');
    title('Derivative');
    
end


% --- Executes on button press in isconstrained.
function isconstrained_Callback(hObject, eventdata, handles)
% hObject    handle to isconstrained (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isconstrained




% --- Executes on button press in estimerr.
function estimerr_Callback(hObject, eventdata, handles)
% hObject    handle to estimerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of estimerr




% --- Executes on button press in defomap.
function defomap_Callback(hObject, eventdata, handles)
% hObject    handle to defomap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg({'N° Steps East','N° Steps North','N° Steps Up'},'Discretization',1,{'100','100','1'});

if isempty(answer)
else
    Esteps = str2num(answer{1});
    Nsteps = str2num(answer{2});
    Usteps = str2num(answer{3});
    
    [DE, X, DN, Y, DU, XU, DEFO] = getDefo2D(handles, Esteps, Nsteps, Usteps);
    
    for i=1:Usteps
        figure('Name','Displacement Map North','NumberTitle','off');
        surf(X,Y,DN(:,:,i),'EdgeColor','none','FaceColor','interp','FaceLighting','phong');
        %         set(gca,'DataAspectRatioMode','manual');
        %         set(gca,'DataAspectRatio',[1 1 1]);
        title('North');
        colorbar('location','southoutside');
        hold on
        mxh = max(max(DN(:,:,i)))+1;
        for is=1:length(handles.Sensors)
            plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
            text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
        end
        hold off
        shading interp
        axis xy; axis tight; colormap(jet); view(0,90);
        
        figure('Name','Displacement Map East','NumberTitle','off'); %subplot(1,3,2);
        surf(X,Y,DE(:,:,i),'EdgeColor','none','FaceColor','interp','FaceLighting','phong');
        %         set(gca,'DataAspectRatioMode','manual');
        %         set(gca,'DataAspectRatio',[1 1 1]);
        title('East');
        colorbar('location','southoutside');
        hold on
        mxh = max(max(DN(:,:,i)))+1;
        for is=1:length(handles.Sensors)
            plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
            text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
        end
        hold off
        shading interp
        axis xy; axis tight; colormap(jet); view(0,90);
        
        figure('Name','Displacement Map Up','NumberTitle','off');%subplot(1,3,3);
        surf(X,Y,DU(:,:,i),'EdgeColor','none','FaceColor','interp','FaceLighting','phong');
        %         set(gca,'DataAspectRatioMode','manual');
        %         set(gca,'DataAspectRatio',[1 1 1]);
        title('Up');
        colorbar('location','southoutside');
        hold on
        mxh = max(max(DN(:,:,i)))+1;
%         for is=1:length(handles.Sensors)
%             plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
%             text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
%         end

if get(handles.drawsources,'Value')
    for j=1:length(handles.Sources)
        
        [sX,sY,~] = getSourceGraph(handles.Sources(j));
        if strcmp(handles.Sources(j).Type,'Okada')
            
            p1 = surf(sX,sY,max(max(DN(:,:,i)))*ones(size(sX)),...
                'FaceColor','none','EdgeColor','k');
        elseif strcmp(handles.Sources(j).Type,'OkadaXS')
             p1 = surf(sX,sY,max(max(DN(:,:,i)))*ones(size(sX)),...
                'FaceColor','red','EdgeColor','k');          
        else
            p1 = surf(sX,sY,max(max(DN(:,:,i)))*ones(size(sX)),...
                'FaceColor','red','EdgeColor','none');
        end
    end
end


        hold off
        shading interp
        axis xy; axis tight; colormap(jet); view(0,90);
        
        figure('Name','Displacement Map','NumberTitle','off');%subplot(1,3,3);
        surf(X,Y,DEFO(:,:,i),'EdgeColor','none','FaceColor','interp','FaceLighting','phong');
        %         set(gca,'DataAspectRatioMode','manual');
        %         set(gca,'DataAspectRatio',[1 1 1]);
        title('Displacements');
        colorbar('location','southoutside');
        hold on
        mxh = max(max(DN(:,:,i)))+1;
        for is=1:length(handles.Sensors)
            plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
            text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
        end
        hold off
        shading interp
        axis xy; axis tight; colormap(jet); view(0,90);
        
        dx = (max(Y(:))-min(Y(:)))/50;
        dy = (max(X(:))-min(X(:)))/50;
        nXN = min(Y(:)) + (0:50)*dx;
        nXE = min(X(:)) + (0:50)*dy;
        [XI,YI] = meshgrid(nXE,nXN);
        
        figure('Name','Gradient North','NumberTitle','off');
        contour(X,Y,DN);
        hold on;
        ZI = interp2(X,Y,DN,XI,YI);
        [DX,DY] = gradient(ZI,dx,dy);
        quiver(XI,YI,DX,DY)
        colormap hsv
        for is=1:length(handles.Sensors)
            plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
            text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
        end
        hold off
        
        figure('Name','Gradient East','NumberTitle','off');
        contour(X,Y,DE);
        hold on;
        ZI = interp2(X,Y,DE,XI,YI);
        [DX,DY] = gradient(ZI,dx,dy);
        quiver(XI,YI,DX,DY)
        colormap hsv
        for is=1:length(handles.Sensors)
            plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
            text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
        end
        hold off
        
        figure('Name','Gradient Up','NumberTitle','off');
        contour(X,Y,DU);
        hold on;
        ZI = interp2(X,Y,DU,XI,YI);
        [DX,DY] = gradient(ZI,dx,dy);
        quiver(XI,YI,DX,DY)
        colormap hsv
        for is=1:length(handles.Sensors)
            plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
            text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
        end
        hold off
        
        figure('Name','Gradient Displacement','NumberTitle','off');
        contour(X,Y,DEFO);
        hold on;
        ZI = interp2(X,Y,DEFO,XI,YI);
        [DX,DY] = gradient(ZI,dx,dy);
        quiver(XI,YI,DX,DY)
        colormap hsv
        for is=1:length(handles.Sensors)
            plot3(handles.Sensors(is).Coordinates(2),handles.Sensors(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
            text(handles.Sensors(is).Coordinates(2)+20,handles.Sensors(is).Coordinates(1), mxh,handles.Sensors(is).Name);
        end
        hold off
        
    end
end


function [DE, X, DN, Y, DU, XU, DEFO] = getDefo2D(handles, Esteps, Nsteps, Usteps)

coords = [];

for i=1:length(handles.Sensors)
    coords = [coords; reshape(handles.Sensors(i).Coordinates,[],3)];
end

extr = minmax(coords');
extr(:,1) = extr(:,1) - (extr(:,2)-extr(:,1))/10;
extr(:,2) = extr(:,2) + (extr(:,2)-extr(:,1))/10;

Nstart = extr(1,1); Nstep = (extr(1,2)-extr(1,1))/max(1,(Nsteps-1));
Estart = extr(2,1); Estep = (extr(2,2)-extr(2,1))/max(1,(Esteps-1));
Ustart = extr(3,1); Ustep = (extr(3,2)-extr(3,1))/max(1,(Usteps-1));

XN = Nstart + (0:(Nsteps-1))*Nstep;
XE = Estart + (0:(Esteps-1))*Estep;
XU = Ustart + (0:(Usteps-1))*Ustep;

[X,Y] = meshgrid(XE,XN);


wh = waitbar(0,'calculating');

for iE= 1:Esteps
    for iN = 1:Nsteps
        for iU = 1:Usteps
            Coordinates = [Y(iE,iN), ...
                X(iE,iN), ...
                Ustart + (iU-1)*Ustep];
            O = 0;
            for i=1:length(handles.Sources)
                hand = mapModel(newDisplacementStation());
                o = hand(handles.Sources(i),Coordinates, handles.Terrain);
                O = O + o;
            end
            DN(iE,iN,iU) = O(1);
            DE(iE,iN,iU) = O(2);
            DU(iE,iN,iU) = O(3);
            DEFO(iE,iN,iU) = norm(O);
            waitbar(iE*iN*iU/(Esteps*Nsteps*Usteps),wh);
        end
    end
end
close(wh);



% --------------------------------------------------------------------
function TypeG2D_Callback(hObject, eventdata, handles)
% hObject    handle to TypeG2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function map2ddisplac_Callback(hObject, eventdata, handles)
% hObject    handle to map2ddisplac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function northmap2ddisplac_Callback(hObject, eventdata, handles)
% hObject    handle to northmap2ddisplac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in intermap.
function intermap_Callback(hObject, eventdata, handles)
% hObject    handle to intermap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg({'N° Steps East','N° Steps North','N° Steps Up'},'Discretization',1,{'100','100','1'});

if isempty(answer)
else
    Esteps = str2num(answer{1});
    Nsteps = str2num(answer{2});
    Usteps = str2num(answer{3});
    
    coords = [];
    for i=1:length(handles.Stations)
        coords = [coords; reshape(handles.Stations(i).Coordinates,[],3)];
    end
    extr = minmax(coords');
    extr(:,1) = extr(:,1) - (extr(:,2)-extr(:,1))/10;
    extr(:,2) = extr(:,2) + (extr(:,2)-extr(:,1))/10;
    
    xn = linspace(extr(1,1),extr(1,2),Nsteps);
    xe = linspace(extr(2,1),extr(2,2),Esteps);
    
    for is=1:length(handles.Stations)
        x(is) = handles.Stations(is).Coordinates(2);
        y(is) = handles.Stations(is).Coordinates(1);
        z(is) = norm(handles.Stations(is).Measurements);
    end
    [XE,XN] =  meshgrid(xe,xn);
    [IX,IY,IZ] = griddata(x,y,z,XE,XN,'cubic');
    
    figure('Name','Interpolation Displacement','NumberTitle','off');%subplot(1,3,3);
    surf(IX,IY,IZ,'EdgeColor','none','FaceColor','interp','FaceLighting','phong');
    %         set(gca,'DataAspectRatioMode','manual');
    %         set(gca,'DataAspectRatio',[1 1 1]);
    title('Interpolation Displacements');
    colorbar('location','southoutside');
    hold on
    mxh = max(max(IZ))+1;
    for is=1:length(handles.Stations)
        plot3(handles.Stations(is).Coordinates(2),handles.Stations(is).Coordinates(1), mxh, 'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','r')
        text(handles.Stations(is).Coordinates(2)+20,handles.Stations(is).Coordinates(1), mxh,handles.Stations(is).Name);
    end
    hold off
    shading interp
    axis xy; axis tight; colormap(jet); view(0,90);
    grid off
end


% --- Executes on button press in buildscene.
function buildscene_Callback(hObject, eventdata, handles)
% hObject    handle to buildscene (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scalaok = 0;
s = get(handles.demname,'String');
if iscell(s)
    is = get(handles.demname,'Value');
    dname = s{is};
else
    dname = s;
end
figure
hold on;

okadarange = [];
for i=1:length(handles.Sources)
    if strcmp(handles.Sources(i).Type,'Okada') || strcmp(handles.Sources(i).Type,'OkadaOnFault') || strcmp(handles.Sources(i).Type,'OkadaXS')
        okadarange = [okadarange, sum(abs(handles.Sources(i).Parameters([8 9 10])))];
    end
end
if ~isempty(okadarange)
    okadarange = minmax(okadarange).*[0.9 1.1];
end

Extr = [];
Nxtr = [];
if get(handles.drawsources,'Value')
    for i=1:length(handles.Sources)
        
        [X,Y,Z] = getSourceGraph(handles.Sources(i));
        if strcmp(handles.Sources(i).Type,'Okada')
            value = (sum(abs(handles.Sources(i).Parameters([8 9 10])))-okadarange(1))/diff(okadarange);
            if isnan(value)
                value = rand;
            end
            
            p1 = surf(X,Y,Z,...
                'FaceColor',[1 (1-value) (1-value)],'EdgeColor','none');
        elseif strcmp(handles.Sources(i).Type,'OkadaXS')
             p1 = surf(X,Y,Z,...
                'FaceColor','red','EdgeColor','k');          
        else
            p1 = surf(X,Y,Z,...
                'FaceColor','red','EdgeColor','none');
        end
        Extr(i,:) = minmax(X(:)');
        Nxtr(i,:) = minmax(Y(:)');
    end
end
for i=1:length(handles.Stations)
    Extr = [Extr; handles.Stations(i).Coordinates(2), handles.Stations(i).Coordinates(2)];
    Nxtr = [Nxtr; handles.Stations(i).Coordinates(1), handles.Stations(i).Coordinates(1)];
end

Eminmax = minmax(Extr(:)');
Nminmax = minmax(Nxtr(:)');

Eminmax = Eminmax + 0.15*[-1 1]*(Eminmax*[-1;1]);
Nminmax = Nminmax + 0.15*[-1 1]*(Nminmax*[-1;1]);

if length(dname)>2
    [X,Y,Z] = getDemMesh(strcat(upper(dname),'_dem'),Eminmax,Nminmax);
    if get(handles.contour,'Value')
        contour3(X,Y,Z,30);
    else
        %         Z = Z*3300;
        surf(X,Y,Z,...
            'EdgeColor','none');
        mymap = [0         0    1.0000
            0         0    1.0000
            0         0    1.0000
            repmat([0    1.0000    0.5000],21,1) + repmat(((0:20)'/20),1,3).*(repmat([0.9921    0.6200    0.3948],21,1)-repmat([0    1.0000    0.5000],21,1))
            repmat([0.9921    0.6200    0.3948],96,1) + repmat(((0:95)'/95),1,3).*(repmat([0.0198    0.0124    0.0079],96,1)-repmat([0.9921    0.6200    0.3948],96,1))
            ];
        
        %          0    1.0000    0.5000
        %          0.9921    0.6200    0.3948
        %          0.0198    0.0124    0.0079];
        %
        caxis(minmax(Z(:)'))
        colormap(mymap);
        material dull;
        alf = str2double(get(handles.opacity,'String'));
        if alf<100
            alpha(alf/100);
        end
    end
end

if get(handles.drawvectors,'Value')
    
    x=[];y=[];z=[];u=[];v=[];w=[];
    for i=1:length(handles.Stations)
        if strcmp(handles.Stations(i).Type,'Displacement')
            if all(isfinite(handles.Stations(i).Measurements))
                x = [x,handles.Stations(i).Coordinates(2)];
                y = [y,handles.Stations(i).Coordinates(1)];
                z = [z,handles.Stations(i).Coordinates(3)];
                
                u = [u,handles.Stations(i).Measurements(2)];
                v = [v,handles.Stations(i).Measurements(1)];
                w = [w,handles.Stations(i).Measurements(3)];
            end
        elseif strcmp(handles.Stations(i).Type,'HorizDisplacement')
            if all(isfinite(handles.Stations(i).Measurements))
                x = [x,handles.Stations(i).Coordinates(2)];
                y = [y,handles.Stations(i).Coordinates(1)];
                z = [z,handles.Stations(i).Coordinates(3)];
                
                u = [u,handles.Stations(i).Measurements(2)];
                v = [v,handles.Stations(i).Measurements(1)];
                w = [w,0];
            end
        end
    end
    scala = 0;
    if ~isempty(x)
        if length(x)==1
            if length(handles.Stations)==1
                scala = 10000;
            else
                xx=[];yy=[];zz=[];
                for ii=1:length(handles.Stations)
                    xx = [xx,handles.Stations(ii).Coordinates(2)];
                    yy = [yy,handles.Stations(ii).Coordinates(1)];
                    zz = [zz,handles.Stations(ii).Coordinates(3)];                    
                end
            maxdist = max(pdist([xx;yy;zz]'));
            maxleng = max(norm([u;v;w]'));
            scala =  0.2*maxdist/maxleng;
            end
        else
            maxdist = max(pdist([x;y;z]'));
            maxleng = max(norm([u;v;w]'));
            scala = 0.5*maxdist/maxleng;
        end
        scala = findascale(handles.Stations, handles.Sensors);
        
        if get(handles.scaleok,'Value')
            answer = inputdlg('Scale GPS','Scale',1,{num2str(scala,'%g')});
            if ~isempty(answer)
                scala = str2double(char(answer));
                scalaok = 1;
            end
        end
        
        if ~isempty(scala) && isfinite(scala) && scala>0
            quiver3(x,y,z,u*scala,v*scala,w*scala,0,'k','LineWidth',2,'MarkerSize',2,'ShowArrowHead','on');
        end
    end
    x=[];y=[];z=[];u=[];v=[];w=[];
    if ~isempty(handles.Sensors)
        for i=1:length(handles.Sensors)
            if strcmp(handles.Sensors(i).Type,'Displacement')
                if all(isfinite(handles.Sensors(i).Measurements))
                    x = [x,handles.Sensors(i).Coordinates(2)];
                    y = [y,handles.Sensors(i).Coordinates(1)];
                    z = [z,handles.Sensors(i).Coordinates(3)];
                    
                    u = [u,handles.Sensors(i).Measurements(2)];
                    v = [v,handles.Sensors(i).Measurements(1)];
                    w = [w,handles.Sensors(i).Measurements(3)];
                end
            elseif strcmp(handles.Sensors(i).Type,'HorizDisplacement')
                if all(isfinite(handles.Sensors(i).Measurements))
                    x = [x,handles.Sensors(i).Coordinates(2)];
                    y = [y,handles.Sensors(i).Coordinates(1)];
                    z = [z,handles.Sensors(i).Coordinates(3)];
                    
                    u = [u,handles.Sensors(i).Measurements(2)];
                    v = [v,handles.Sensors(i).Measurements(1)];
                    w = [w,0];
                end
            end
        end
        if ~isempty(scala) && ((scala==0) || (isinf(scala)))
            maxdist = max(pdist([x;y;z]'));
            maxleng = max(norm([u;v;w]'));
            scala = 0.5*maxdist/maxleng;
            if get(handles.scaleok,'Value') && ~scalaok
                answer = inputdlg('Scale GPS','Scale',1,{num2str(scala,'%g')});
                if ~isempty(answer)
                    scala = str2double(char(answer));
                end
            end
        end
        if ~isempty(scala) && ~isempty(x)
            quiver3(x,y,z,u*scala,v*scala,w*scala,0,'r','LineWidth',1);
            %             scala = 2.3544e+05;
            %             quiver3(x,y,z,u*scala,v*scala,w*scala,0,'r','LineWidth',1,'ShowArrowHead','off');
        end
    end
end

%----------------
scalaok = 0;
x = []; y =[]; z = []; u = []; v = []; w =[];
for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Tiltmeter')
        if all(isfinite(handles.Stations(i).Measurements))
            x = [x, handles.Stations(i).Coordinates(2)];
            y = [y, handles.Stations(i).Coordinates(1)];
            z = [z, 0];
            
            u = [u, handles.Stations(i).Measurements(1)];
            v = [v, handles.Stations(i).Measurements(2)];
            w = [w, 0];
        end
    end
end
scala=0;
if (~isempty(handles.Stations)) && (~isempty(x))
    maxdist = max(pdist([x;y;z]'));
    maxleng = max(norm([u;v;w]'));
    scala = 0.5*maxdist/maxleng;
    if (isempty(scala))
        scala = 1000;
    end
    
    if get(handles.scaleok,'Value')
        answer = inputdlg('Scale Tilt','Scale',1,{num2str(scala,'%g')});
        if ~isempty(answer)
            scala = str2double(char(answer));
            scalaok = 1;
        end
    end
    quiver3(x,y,z,u*scala,v*scala,w*scala,0,'.b','LineWidth',2,'MarkerSize',2);
    hold on;
end


%..........
for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Baseline')
        if all(isfinite(handles.Stations(i).Measurements))
            plot3([handles.Stations(i).Coordinates(2),handles.Stations(i).Coordinates(5)], ...
                [handles.Stations(i).Coordinates(1),handles.Stations(i).Coordinates(4)], ...
                [handles.Stations(i).Coordinates(3),handles.Stations(i).Coordinates(4)],'--k');
            plot3(handles.Stations(i).Coordinates(2),handles.Stations(i).Coordinates(1),handles.Stations(i).Coordinates(3)+10,'.b');
            if get(handles.showstationnames,'Value')
                h = text(mean(handles.Stations(i).Coordinates([2,5])),mean(handles.Stations(i).Coordinates([1,4])),handles.Stations(i).Coordinates(3)+100,handles.Stations(i).Name);
                angle = atan2d(diff(handles.Sensors(i).Coordinates([4 1])),diff(handles.Sensors(i).Coordinates([5 2])));
                set(h,'Rotation',angle);
            end
        end
    end
end
%..........
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Baseline')
        if all(isfinite(handles.Sensors(i).Measurements))
            plot3([handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(5)], ...
                [handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(4)], ...
                [handles.Sensors(i).Coordinates(3),handles.Sensors(i).Coordinates(4)],'--k');
            plot3(handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(3)+10,'.b');
            h = text(mean(handles.Sensors(i).Coordinates([2,5])),mean(handles.Sensors(i).Coordinates([1,4])),handles.Sensors(i).Coordinates(6)+100,handles.Sensors(i).Name);
            angle = atan2d(diff(handles.Sensors(i).Coordinates([4 1])),diff(handles.Sensors(i).Coordinates([5 2])));
            set(h,'Rotation',angle);
        end
    end
end

x = []; y =[]; z = []; u = []; v = []; w =[];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Tiltmeter')
        if all(isfinite(handles.Sensors(i).Measurements))
            x = [x, handles.Sensors(i).Coordinates(2)];
            y = [y, handles.Sensors(i).Coordinates(1)];
            z = [z, 0];
            
            u = [u, handles.Sensors(i).Measurements(1)];
            v = [v, handles.Sensors(i).Measurements(2)];
            w = [w, 0];
        end
    end
end
if ~isempty(handles.Sensors) && ~isempty(x)
    if (scala==0) || (isinf(scala)) || (isempty(scala))
        maxdist = max(pdist([x;y;z]'));
        maxleng = max(norm([u;v;w]'));
        scala = 0.5*maxdist/maxleng;
        if get(handles.scaleok,'Value') && ~scalaok
            answer = inputdlg('Scale Tilt','Scale',1,{num2str(scala,'%g')});
            if ~isempty(answer)
                scala = str2double(char(answer));
            end
        end
    end
    if (~isempty(handles.Sensors)) && (~isempty(x))
        if isempty(scala)
            scala = findascale(handles.Stations, handles.Sensors)/10;
        end
        quiver3(x,y,z,u*scala,v*scala,w*scala,0,'.r','LineWidth',1);
        ksens = 0;
        %     for i=1:length(handles.Sensors)
        %         if strcmp(handles.Sensors(i).Type,'Tiltmeter')
        %             ksens = ksens+1;
        %             text(x(ksens),y(ksens),0,handles.Sensors(i).Name);
        %         end
        %     end
    end
end
%----------------
scala = 0;

Cocord = [];
for i=1:length(handles.Stations)
    if length(handles.Stations(i).Coordinates)==6
        Cocord = [Cocord; handles.Stations(i).Coordinates([1 2 3; 4 5 6])];
    else
        Cocord = [Cocord; handles.Stations(i).Coordinates(:)'];
    end
end

for i=1:length(handles.Sensors)
    if length(handles.Sensors(i).Coordinates)==6
        Cocord = [Cocord; handles.Sensors(i).Coordinates([1 2 3; 4 5 6])];
    else
        Cocord = [Cocord; handles.Sensors(i).Coordinates(:)'];
    end
end

axis equal

if ~isempty(Cocord)
    medco = median(pdist(Cocord));
    scala = medco*50/700;
end


for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Paxes')
        if all(isfinite(handles.Stations(i).Measurements))
            
            x = handles.Stations(i).Coordinates(2);
            y = handles.Stations(i).Coordinates(1);
            z = handles.Stations(i).Coordinates(3);
            
            a = handles.Stations(i).Measurements(1);
            d = -handles.Stations(i).Measurements(2);
            ang = 90 - a;
            ROT = [cosd(ang) -sind(ang) 0
                sind(ang)  cosd(ang) 0
                0          0         1];
            ROTd = [cosd(d) 0 -sind(d)
                0         1   0
                sind(d) 0  cosd(d)];
            vett = ROT*ROTd*[1; 0; 0];
            plot3([x-0.5*vett(1)*scala, x+0.5*vett(1)*scala],[y-0.5*vett(2)*scala, y+0.5*vett(2)*scala],[z-0.5*vett(3)*scala, z+0.5*vett(3)*scala],'g','LineWidth',2);
            hold on;
        end
    end
end


for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Paxes')
        if all(isfinite(handles.Sensors(i).Measurements))
            
            x = handles.Sensors(i).Coordinates(2);
            y = handles.Sensors(i).Coordinates(1);
            z = handles.Sensors(i).Coordinates(3);
            
            a = handles.Sensors(i).Measurements(1);
            d = -handles.Sensors(i).Measurements(2);
            ang = 90 - a;
            ROT = [cosd(ang) -sind(ang) 0
                sind(ang)  cosd(ang) 0
                0          0         1];
            ROTd = [cosd(d) 0 -sind(d)
                0         1   0
                sind(d) 0  cosd(d)];
            vett = ROT*ROTd*[1; 0; 0];
            plot3([x-0.5*vett(1)*scala, x+0.5*vett(1)*scala],[y-0.5*vett(2)*scala, y+0.5*vett(2)*scala],[z-0.5*vett(3)*scala, z+0.5*vett(3)*scala],'r','LineWidth',2);
            hold on;
        end
    end
end
%----------------

if get(handles.showstationnames,'Value')
    for i=1:length(handles.Stations)
        if ~strcmp(handles.Stations(i).Type,'Baseline')
            plot3(handles.Stations(i).Coordinates(2),handles.Stations(i).Coordinates(1),handles.Stations(i).Coordinates(3)+10,'.b');
            text(handles.Stations(i).Coordinates(2),handles.Stations(i).Coordinates(1),handles.Stations(i).Coordinates(3)+100,handles.Stations(i).Name);   
        end
    end
end

for i=1:length(handles.Sensors)
    if ~strcmp(handles.Sensors(i).Type,'Baseline')
        plot3(handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(3)+10,'.b');
        text(handles.Sensors(i).Coordinates(2),handles.Sensors(i).Coordinates(1),handles.Sensors(i).Coordinates(3)+100,handles.Sensors(i).Name);
    end
end

if ~isempty(handles.EarthQuakes)
    plotEarthQuakes(handles.EarthQuakes, Eminmax, Nminmax);
end

hold off;
% axis tight
camlight; camlight(-80,-10);  lighting phong;
if get(handles.viewmode,'Value')== 1
    view(0,90);
elseif get(handles.viewmode,'Value')== 2
    view(0,0);
elseif get(handles.viewmode,'Value')== 3
    view(90,0);
elseif get(handles.viewmode,'Value')== 4
    view(3);
end

VecBaselines = [];
Baselinenames = [];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Baseline')
        Baselinenames{end+1} = handles.Sensors(i).Name;
        VecBaselines(1,end+1) = handles.Sensors(i).Measurements(1);
        VecBaselines(2,end) = NaN;
        for j=1:length(handles.Stations)
            if strcmp(handles.Stations(j).Type,'Baseline')
                if strcmp(handles.Sensors(i).Name,handles.Stations(j).Name)
                    VecBaselines(2,end) = handles.Stations(j).Measurements(1);
                end
            end
        end
    end
end

if ~isempty(VecBaselines)
    figure
    plot(VecBaselines(2,:),'k');
    hold on
    plot(VecBaselines(1,:),'r-.');
    set(gca,'XTick',1:size(VecBaselines,2));
    set(gca,'XTickLabel',Baselinenames);
    title('Baselines');
end


% --
VecStrain = [];
Strainnames = [];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Strainmeter')
        Strainnames{end+1} = handles.Sensors(i).Name;
        VecStrain(1,end+1) = handles.Sensors(i).Measurements(1);
        VecStrain(2,end) = NaN;
        for j=1:length(handles.Stations)
            if strcmp(handles.Stations(j).Type,'Strainmeter')
                if strcmp(handles.Sensors(i).Name,handles.Stations(j).Name)
                    VecStrain(2,end) = handles.Stations(j).Measurements(1);
                end
            end
        end
    end
end

if ~isempty(VecStrain)
    figure
    plot(VecStrain(2,:),'ok');
    hold on
    plot(VecStrain(1,:),'r*');
    set(gca,'XTick',1:size(VecStrain,2));
    set(gca,'XTickLabel',Strainnames);
    title('Strainmeters');
end

VecLevelling = [];
Levellingnames = [];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Altimeter')
        Levellingnames{end+1} = handles.Sensors(i).Name;
        VecLevelling(1,end+1) = handles.Sensors(i).Measurements(1);
        VecLevelling(2,end) = NaN;
        for j=1:length(handles.Stations)
            if strcmp(handles.Stations(j).Type,'Altimeter')
                if strcmp(handles.Sensors(i).Name,handles.Stations(j).Name)
                    VecLevelling(2,end) = handles.Stations(j).Measurements(1);
                end
            end
        end
    end
end

if ~isempty(VecLevelling)
    figure
    plot(VecLevelling(2,:),'k');
    hold on
    plot(VecLevelling(1,:),'b-.');
    set(gca,'XTick',1:size(VecLevelling,2));
    set(gca,'XTickLabel',Levellingnames);
    title('Levelling');
end


set(gcf,'renderer','Painters')


% --- Executes on selection change in demname.
function demname_Callback(hObject, eventdata, handles)
% hObject    handle to demname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns demname contents as cell array
%        contents{get(hObject,'Value')} returns selected item from demname


% --- Executes during object creation, after setting all properties.
function demname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to demname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in drawvectors.
function drawvectors_Callback(hObject, eventdata, handles)
% hObject    handle to drawvectors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawvectors



function opacity_Callback(hObject, eventdata, handles)
% hObject    handle to opacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opacity as text
%        str2double(get(hObject,'String')) returns contents of opacity as a double


% --- Executes during object creation, after setting all properties.
function opacity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in contour.
function contour_Callback(hObject, eventdata, handles)
% hObject    handle to contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of contour




% --- Executes on selection change in viewmode.
function viewmode_Callback(hObject, eventdata, handles)
% hObject    handle to viewmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns viewmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from viewmode


% --- Executes during object creation, after setting all properties.
function viewmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in crosstype.
function crosstype_Callback(hObject, eventdata, handles)
% hObject    handle to crosstype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns crosstype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from crosstype
i = get(handles.crosstype,'Value');
s = get(handles.crosstype,'String');

handles.GAparameters.CrossType = s{i};
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function crosstype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to crosstype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function crossparam_Callback(hObject, eventdata, handles)
% hObject    handle to crossparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of crossparam as text
%        str2double(get(hObject,'String')) returns contents of crossparam as a double
handles.GAparameters.CrossParam = str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function crossparam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to crossparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in selectype.
function selectype_Callback(hObject, eventdata, handles)
% hObject    handle to selectype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selectype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectype
i = get(handles.selectype,'Value');
s = get(handles.selectype,'String');

handles.GAparameters.SelectionType = s{i};
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function selectype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function selecparam_Callback(hObject, eventdata, handles)
% hObject    handle to selecparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selecparam as text
%        str2double(get(hObject,'String')) returns contents of selecparam as a double
handles.GAparameters.SelectionParam = str2double(get(handles.selecparam,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function selecparam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selecparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function mutaparam1_Callback(hObject, eventdata, handles)
% hObject    handle to mutaparam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mutaparam1 as text
%        str2double(get(hObject,'String')) returns contents of mutaparam1 as a double


% --- Executes during object creation, after setting all properties.
function mutaparam1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mutaparam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mutatype.
function mutatype_Callback(hObject, eventdata, handles)
% hObject    handle to mutatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mutatype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mutatype
i = get(handles.mutatype,'Value');
s = get(handles.mutatype,'String');

handles.GAparameters.MutationType = s{i};
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function mutatype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mutatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mutaparam2_Callback(hObject, eventdata, handles)
% hObject    handle to mutaparam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mutaparam2 as text
%        str2double(get(hObject,'String')) returns contents of mutaparam2 as a double


% --- Executes during object creation, after setting all properties.
function mutaparam2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mutaparam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in nislands.
function nislands_Callback(hObject, eventdata, handles)
% hObject    handle to nislands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns nislands contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nislands
i = get(handles.nislands,'Value');

handles.GAparameters.NumIslands = i;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function nislands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nislands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function migratinterval_Callback(hObject, eventdata, handles)
% hObject    handle to migratinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of migratinterval as text
%        str2double(get(hObject,'String')) returns contents of migratinterval as a double

handles.GAparameters.MigrationInterval = str2num(get(handles.migratinterval,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function migratinterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to migratinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in migratdirection.
function migratdirection_Callback(hObject, eventdata, handles)
% hObject    handle to migratdirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns migratdirection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from migratdirection
i = get(handles.migratdirection,'Value');
s = get(handles.migratdirection,'String');

handles.GAparameters.MigrationDirection = s{i};
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function migratdirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to migratdirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function neeew_Callback(hObject, eventdata, handles)
% hObject    handle to neeew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cleanall_Callback(hObject, eventdata, handles);




% --- Executes on button press in PSearch.
function PSearch_Callback(hObject, eventdata, handles)
% hObject    handle to PSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if not(isempty(handles.Sources)) && not(isempty(handles.Stations))
    handles.SourcesHistory{end+1} = handles.Sources;
    if length(handles.SourcesHistory) > handles.SourcesHistoryLength
        handles.SourcesHistory(1) = [];
    end
    handles.Sources = solvePS(handles.Sources, handles.Stations, handles.PSparameters, handles.Terrain, get(handles.isPSconstrained,'Value'), handles.ObjFunction);
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);
end


% --- Executes on button press in GAs.
function GAs_Callback(hObject, eventdata, handles)
% hObject    handle to GAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GAs
togglepanels(hObject, eventdata, handles);



% --- Executes on button press in PS.
function PS_Callback(hObject, eventdata, handles)
% hObject    handle to PS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PS
togglepanels(hObject, eventdata, handles);


% --- Executes on button press in pscache.
function pscache_Callback(hObject, eventdata, handles)
% hObject    handle to pscache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pscache
GUI2PSparams(hObject,handles);



function pscachesize_Callback(hObject, eventdata, handles)
% hObject    handle to pscachesize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pscachesize as text
%        str2double(get(hObject,'String')) returns contents of pscachesize as a double
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pscachesize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pscachesize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psmeshsize_Callback(hObject, eventdata, handles)
% hObject    handle to psmeshsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psmeshsize as text
%        str2double(get(hObject,'String')) returns contents of psmeshsize as a double
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function psmeshsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psmeshsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psinitpenalty_Callback(hObject, eventdata, handles)
% hObject    handle to psinitpenalty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psinitpenalty as text
%        str2double(get(hObject,'String')) returns contents of psinitpenalty as a double
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function psinitpenalty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psinitpenalty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psiter_Callback(hObject, eventdata, handles)
% hObject    handle to psiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psiter as text
%        str2double(get(hObject,'String')) returns contents of psiter as a double
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function psiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pscontract_Callback(hObject, eventdata, handles)
% hObject    handle to pscontract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pscontract as text
%        str2double(get(hObject,'String')) returns contents of pscontract as a double
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pscontract_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pscontract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psexpansion_Callback(hObject, eventdata, handles)
% hObject    handle to psexpansion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psexpansion as text
%        str2double(get(hObject,'String')) returns contents of psexpansion as a double
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function psexpansion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psexpansion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pspenaltyfact_Callback(hObject, eventdata, handles)
% hObject    handle to pspenaltyfact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pspenaltyfact as text
%        str2double(get(hObject,'String')) returns contents of pspenaltyfact as a double
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pspenaltyfact_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pspenaltyfact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pspoll.
function pspoll_Callback(hObject, eventdata, handles)
% hObject    handle to pspoll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pspoll contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pspoll
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pspoll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pspoll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pssearch.
function pssearch_Callback(hObject, eventdata, handles)
% hObject    handle to pssearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pssearch contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pssearch
GUI2PSparams(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pssearch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pssearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in psestimerr.
function psestimerr_Callback(hObject, eventdata, handles)
% hObject    handle to psestimerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
JacKnife(hObject, eventdata, handles, 'PS');


% --- Executes on button press in gaestimerr.
function gaestimerr_Callback(hObject, eventdata, handles)
% hObject    handle to gaestimerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
JacKnife(hObject, eventdata, handles, 'GA');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function JacKnife(hObject, eventdata, handles, whatalgorithm)

MySources = [];
ObjX = [];
n = 0;
howmany = length(handles.Stations);

[~, fval0] = ForwardModel(handles);
hwb = waitbar(0,'Residual Time Inf');
tic;
for i=1:length(handles.Stations)
    MyStation = handles.Stations;
    MySource = handles.Sources;
    for s=1:length(MySource)
        ranges = (MySource(s).UpBoundaries - MySource(s).LowBoundaries);
        randvals = ranges.*rand(1,MySource(s).NParameters) + MySource(s).LowBoundaries;
        MySource(s).Parameters = randvals;
        MySource(s).Parameters(not(MySource(s).ActiveParameters)) = handles.Sources(s).Parameters(not(MySource(s).ActiveParameters));
    end
    MyStation(i) = [];
    if strcmp(whatalgorithm,'GA')
        [os, fval]= solveGA(MySource, MyStation, handles.GAparameters, handles.Terrain, get(handles.isconstrained,'Value'), handles.ObjFunction);
    elseif strcmp(whatalgorithm,'PS')
        [os, fval]= solvePS(MySource, MyStation, handles.PSparameters, handles.Terrain, get(handles.isPSconstrained,'Value'), handles.ObjFunction);
    elseif strcmp(whatalgorithm,'NLSQ')
        [os, fval]= solveNLSQ(MySource, handles.Stations, handles.PSparameters, handles.Terrain, get(handles.isNLSconstrained,'Value'));
    end
    MySources{i} = os;
    ObjX(i) = fval;
    temp = toc;
    totaltemp = temp/(n+i);
    totaltemp = totaltemp*(howmany-n-i)/60;
    waitbar((n+i)/howmany,hwb,['Residual Time ',num2str(totaltemp,0),' minutes']);
end
p = 0;
close(hwb);

okdone = prctile(ObjX,99.8); %3-sigma
iok = find((ObjX<okdone) & (ObjX<fval0*1.5));

n = length(iok);
MySources = MySources(iok);

for i=1:length(handles.Sources)
    p = p + handles.Sources(i).NParameters;
end

% for i=1:length(handles.Sources)
%     for j=1:handles.Sources(i).NParameters
%         T = [];
%         for k=1:length(MySources)
%             T(k) = MySources{k}(i).Parameters(j);
%         end
%         handles.Sources(i).EParameters(j) = sqrt((n-1)/n)*iqr(T)/1.349; % fonte http://en.wikipedia.org/wiki/Interquartile_range
%     end
% end

for i=1:length(handles.Sources)
    for j=1:handles.Sources(i).NParameters
        T = [];
        for k=1:length(MySources)
            T(k) = abs(MySources{k}(i).Parameters(j)-MySource(i).Parameters(j));
        end
        handles.Sources(i).EParameters(j) = prctile(T,68);
    end
end

guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newlevelling_Callback(hObject, eventdata, handles)
% hObject    handle to newlevelling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg('Name','Station',1,{'noname'});
if ~isempty(answer)
    S = newLevellingStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end



% --------------------------------------------------------------------
function newsensorlevelling_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorlevelling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg('Name','Sensor',1,{'noname'});
if ~isempty(answer)
    
    S = newLevellingStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end




% --------------------------------------------------------------------
function newtiltmeter_Callback(hObject, eventdata, handles)
% hObject    handle to newtiltmeter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg('Name','Station',1,{'noname'});
if ~isempty(answer)
    S = newTiltmeterStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function newsensortiltmeter_Callback(hObject, eventdata, handles)
% hObject    handle to newsensortiltmeter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg('Name','Sensor',1,{'noname'});
if ~isempty(answer)
    
    S = newTiltmeterStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end



% --- Executes on button press in buildmesh.
function buildmesh_Callback(hObject, eventdata, handles)
% hObject    handle to buildmesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

liststats = {'Displacement','Levelling','Tiltmeter','HorizDisplacement',...
    'P axes','Earthquakes', 'Strainmeter' };
[Selection,ok] = listdlg('PromptString','Select the station type:',...
    'SelectionMode','single',...
    'ListString',liststats);
if ok
    answer=inputdlg({'North Center','East Center', 'North Step (m)', 'East Step (m)', 'Num Stat North', 'Num Stat East'},...
        'Meshing',1,{'4171500','507000','1000','1000','10','10'});
    
    switch liststats{Selection}
        case 'Displacement'
            newS = @newDisplacementStation;
        case 'Levelling'
            newS = @newLevellingStation;
        case 'Tiltmeter'
            newS = @newTiltmeterStation;
        case 'HorizDisplacement'
            newS = @newHorizDisplacementStation;
        case 'P axes'
            newS = @newPaxesStation;
        case 'Earthquakes'
            newS = @newEarthquakeStation;
        case 'Strainmeter'
            newS = @newStrainmeterStation;
    end
    
    if ~isempty(answer)
        ANSW = str2double(answer);
        N = ANSW(1) - 0.5*ANSW(3)*(ANSW(5)-1);
        E = ANSW(2) - 0.5*ANSW(4)*(ANSW(6)-1);
        
        Mesh = [];
        for i=1:ANSW(5)
            for j=1:ANSW(6)
                S = newS();
                S.Name = [num2str(i),'-',num2str(j)];
                S.Coordinates = [N + (i-1)*ANSW(3), E + (j-1)*ANSW(4), 0];
                Mesh = [Mesh, S];
            end
        end
        
        handles.Sensors = [Mesh, handles.Sensors];
        for i=1:length(handles.Sensors)
            listtype{i} = handles.Sensors(i).Name;
        end
        set(handles.sensorlist,'String',listtype);
        set(handles.sensorlist,'Value',1);
        guidata(hObject, handles);
        displaySensors(hObject, eventdata, handles);
        
    end
end

% --------------------------------------------------------------------
function HorizDisplacement_Callback(hObject, eventdata, handles)
% hObject    handle to HorizDisplacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Station',1,{'noname'});
if ~isempty(answer)
    S = newHorizDisplacementStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end




% --------------------------------------------------------------------
function newsensorHorizDisplacement_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorHorizDisplacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Sensor',1,{'noname'});
if ~isempty(answer)
    
    S = newHorizDisplacementStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end




% --------------------------------------------------------------------
function SSTS_Callback(hObject, eventdata, handles)
% hObject    handle to SSTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uiputfile( ...
    {'*.txt','Text files (*.txt)'}, ...
    'Save the Strain');

if isequal(filename,0) || isequal(pathname,0)
else
    [Coord, Tensor] = getRealStrain(handles);
    
    Dilatation = Tensor(:,1) + Tensor(:,4);
    nrows = length(find(Coord(:,1) == Coord(1,1)));
    X = reshape(Coord(:,2),[],nrows);
    Y = reshape(Coord(:,1),[],nrows);
    Z = reshape(Dilatation,[],nrows);
    figure('Name','Strain','NumberTitle','off');
    surf(X,Y,Z,'EdgeColor','none','FaceColor','interp','FaceLighting','phong');
    view(0,90);
    Coordin = [Coord(:,2), Coord(:,1), Coord(:,3)];
    dlmwrite(fullfile(pathname,filename),[Coordin, Tensor], 'delimiter', '\t', ...
        'precision', 10);
end


% --------------------------------------------------------------------
function poledelete_Callback(hObject, eventdata, handles)
% hObject    handle to poledelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button = questdlg('do you want to estimate the pole?','','Yes','No','No');

if ~isempty(button)
    utmzone = char(inputdlg('UTM Zone','utm zone',1,{'33 T'}));
    if ~isempty(utmzone)
        PLat = 0;
        PLon = 0;
        POmeg = 0;
        PoleCovariance = zeros(3);
        
        UTMNEU = [];
        UTMNEUVEL = [];
        UTMNEUERR = [];
        for i=1:length(handles.Stations)
            if (strcmp(handles.Stations(i).Type,'Displacement'))
                UTMNEU = [UTMNEU; handles.Stations(i).Coordinates];
                UTMNEUVEL = [UTMNEUVEL; handles.Stations(i).Coordinates + handles.Stations(i).Measurements];
                UTMNEUERR = [UTMNEUERR; handles.Stations(i).Coordinates + handles.Stations(i).Measurements + handles.Stations(i).Errors];
            end
        end
        
        ECEF = UTM2ECEF(UTMNEU,utmzone);
        ECEFVEL = UTM2ECEF(UTMNEUVEL,utmzone);
        ECEFERR = UTM2ECEF(UTMNEUERR,utmzone);
        ITRF.StationCoord = ECEF;
        ITRF.EStationCoord = zeros(size(ITRF.StationCoord));
        ITRF.StationVelocity = ECEFVEL - ECEF;
        ITRF.EStationVelocity = abs(ECEFERR-ECEF - ITRF.StationVelocity);
        
        if strcmp(button,'Yes')
            [PLat PLon POmeg PoleCovariance] = calculatePoleLSE(ITRF);
        end
        answer = inputdlg({'Pole Lat','Pole Lon','Omega (deg/My)'} ...
            ,'Pole',1,{num2str(PLat),num2str(PLon),num2str(POmeg)});
        if ~isempty(answer)
            PLat = str2num(answer{1});
            PLon = str2num(answer{2});
            POmeg = str2num(answer{3});
            
            answer = inputdlg({'Lat VAR','Lon VAR','Omega VAR', 'LatLon COVAR', 'LatOmega COVAR', 'LonOmega COVAR'} ...
                ,'Covariance Matrix',1,cellstr(num2str([diag(PoleCovariance);PoleCovariance(1,2);PoleCovariance(1,3);PoleCovariance(2,3)])));
            
            
            if ~isempty(answer)
                PoleCovariance(1,1)= str2num(answer{1});
                PoleCovariance(2,2)= str2num(answer{2});
                PoleCovariance(3,3)= str2num(answer{3});
                PoleCovariance(1,2)= str2num(answer{4});
                PoleCovariance(1,3)= str2num(answer{5});
                PoleCovariance(2,3)= str2num(answer{6});
                PoleCovariance(2,1)= PoleCovariance(1,2);
                PoleCovariance(3,1)= PoleCovariance(1,3);
                PoleCovariance(3,2)= PoleCovariance(2,3);
            else
                return;
            end
        else
            return;
        end
        
        ITRFNEW = calculateRotation(ITRF, PLat, PLon, POmeg,  PoleCovariance);
        
        %         ITRF.StationVelocity =  ITRFNEW.StationVelocity - ITRF.StationVelocity;
        %         ITRF.EStationVelocity = sqrt(ITRFNEW.EStationVelocity.^2 + ITRF.EStationVelocity.^2);
        
        answer = inputdlg({'Years'},'Time Span',1,{'1'});
        if ~isempty(answer)
            tspan = str2double(char(answer));
            ECEFVEL = ITRFNEW.StationVelocity*tspan + ECEF;
            ECEFERR = ECEFVEL + sqrt(ITRFNEW.EStationVelocity.^2 + ITRF.EStationVelocity.^2);
            %         ITRF.EStationVelocity = abs(ECEFERR-ECEF - ITRF.StationVelocity);
            
            UTMVEL = ECEF2UTM(ECEFVEL);
            UTMERR = ECEF2UTM(ECEFERR);
            for i=1:length(handles.Stations)
                if (strcmp(handles.Stations(i).Type,'Displacement'))
                    handles.Stations(i).Measurements = handles.Stations(i).Measurements - (UTMVEL(i,:) - handles.Stations(i).Coordinates);
                    handles.Stations(i).Errors = abs(UTMERR(i,:) - UTMVEL(i,:));
                end
            end
            displayMeasurements(hObject, eventdata, handles);
        end
    end
end


% --------------------------------------------------------------------
function addpoleonsensor_Callback(hObject, eventdata, handles)
% hObject    handle to addpoleonsensor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

utmzone = char(inputdlg('UTM Zone','utm zone',1,{'33 T'}));
if ~isempty(utmzone)
    PLat = 0;
    PLon = 0;
    POmeg = 0;
    PoleCovariance = zeros(3);
    
    UTMNEU = [];
    UTMNEUVEL = [];
    UTMNEUERR = [];
    for i=1:length(handles.Sensors)
        UTMNEU = [UTMNEU; handles.Sensors(i).Coordinates];
        UTMNEUVEL = [UTMNEUVEL; handles.Sensors(i).Coordinates + handles.Sensors(i).Measurements];
        UTMNEUERR = [UTMNEUERR; handles.Sensors(i).Coordinates + handles.Sensors(i).Measurements + + handles.Sensors(i).Errors];
    end
    
    ECEF = UTM2ECEF(UTMNEU,utmzone);
    ECEFVEL = UTM2ECEF(UTMNEUVEL,utmzone);
    ECEFERR = UTM2ECEF(UTMNEUERR,utmzone);
    ITRF.StationCoord = ECEF;
    ITRF.EStationCoord = zeros(size(ITRF.StationCoord));
    ITRF.StationVelocity = ECEFVEL - ECEF;
    ITRF.EStationVelocity = abs(ECEFERR-ECEF - ITRF.StationVelocity);
    
    answer = inputdlg({'Pole Lat','Pole Lon','Omega (deg/My)'} ...
        ,'Pole',1,{num2str(PLat),num2str(PLon),num2str(POmeg)});
    if ~isempty(answer)
        PLat = str2num(answer{1});
        PLon = str2num(answer{2});
        POmeg = str2num(answer{3});
        
        ITRFNEW = calculateRotation(ITRF, PLat, PLon, POmeg);
        
        %         ITRF.StationVelocity =  ITRFNEW.StationVelocity - ITRF.StationVelocity;
        %         ITRF.EStationVelocity = sqrt(ITRFNEW.EStationVelocity.^2 + ITRF.EStationVelocity.^2);
        
        answer = inputdlg({'Years'},'Time Span',1,{'1'});
        if ~isempty(answer)
            tspan = str2double(char(answer));
            ECEFVEL = ITRFNEW.StationVelocity*tspan + ECEF;
            %         ITRF.EStationVelocity = abs(ECEFERR-ECEF - ITRF.StationVelocity);
            
            UTMVEL = ECEF2UTM(ECEFVEL);
            for i=1:length(handles.Sensors)
                handles.Sensors(i).Measurements = handles.Sensors(i).Measurements + (UTMVEL(i,:) - handles.Sensors(i).Coordinates);
            end
            displaySensors(hObject, eventdata, handles);
        end
    end
end


% --------------------------------------------------------------------
function resetparams_Callback(hObject, eventdata, handles)
% hObject    handle to resetparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for s=1:length(handles.Sources)
    %             devs = (handles.Sources(s).UpBoundaries - handles.Sources(s).LowBoundaries)/10;
    %             devs = devs.*handles.Sources(s).ActiveParameters;
    iok = find(handles.Sources(s).ActiveParameters);
    devs = (handles.Sources(s).UpBoundaries(iok) - handles.Sources(s).LowBoundaries(iok));
    handles.Sources(s).Parameters(iok) = handles.Sources(s).LowBoundaries(iok) + rand(1,length(iok)).*devs;
end
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);




% --------------------------------------------------------------------
function exportstatsens_Callback(hObject, eventdata, handles)
% hObject    handle to exportstatsens (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uiputfile( ...
    {'*.csv','CSV file (*.csv)'}, ...
    'Save Stations & Sensors');

if isequal(filename,0) || isequal(pathname,0)
else
    fid = fopen(fullfile(pathname,filename),'w');
    for i=1:length(handles.Stations)
        fprintf(fid,'%s',handles.Stations(i).Name);
        for k=1:handles.Stations(i).NMeasurements
            fprintf(fid,';%f',handles.Stations(i).Measurements(k));
        end
        ij = 0;
        for j=1:length(handles.Sensors)
            if (strcmp(handles.Stations(i).Type,handles.Sensors(j).Type) && strcmp(handles.Stations(i).Name,handles.Sensors(j).Name))
                ij=j;
                break;
            end
        end
        for k=1:handles.Stations(i).NMeasurements
            if (ij>0)
                fprintf(fid,';%f',handles.Sensors(ij).Measurements(k));
            else
                fprintf(fid,';');
            end
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
end


% --------------------------------------------------------------------
function nerrestimation_Callback(hObject, eventdata, handles)
% hObject    handle to nerrestimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = char(inputdlg('N° Estimations','Parameter',1,{num2str(handles.NEstimation)}));
if isempty(answer)
else
    if str2num(answer)>0
        handles.NEstimation = str2num(answer);
        guidata(hObject, handles);
    end
end

% --- Executes on button press in DObaselines.
function DObaselines_Callback(hObject, eventdata, handles)
% hObject    handle to DObaselines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DObaselines



% --------------------------------------------------------------------
function newokadaonfault_Callback(hObject, eventdata, handles)
% hObject    handle to newokadaonfault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newOkadaOnFaultSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'OkadaOF'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);




% --------------------------------------------------------------------
function newyang_Callback(hObject, eventdata, handles)
% hObject    handle to newyang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newYangSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'Yang'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);




% --------------------------------------------------------------------
function Patches_Callback(hObject, eventdata, handles)
% hObject    handle to Patches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function makepatches_Callback(hObject, eventdata, handles)
% hObject    handle to makepatches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.sourcelist,'String'))
    i = get(handles.sourcelist,'Value');
    if strcmp(handles.Sources(i).Type,'Okada')
        
        gridd = inputdlg({'N Rows','M Columns'},'N° Patches',1,{'2','2'});
        if ~isempty(gridd)
            patchesfree = inputdlg({'dEast','dNorth','dDepth','dLen','dWid'},'Patches Freedom',1,{'0','0','0','0','0'});
            if ~isempty(patchesfree)
                nrows = str2num(gridd{1});
                ncols = str2num(gridd{2});
                ParamFree = str2num(char(cellstr(patchesfree)));
                ss = get(handles.sourcelist,'String');
                ss(i) = [];
                MainOkada = handles.Sources(i);
                handles.Sources(i) = [];
                
                len = (MainOkada.Parameters(6)/ncols);
                wid  = (MainOkada.Parameters(7)/nrows);
                X0 = MainOkada.Parameters(1);
                Y0 = MainOkada.Parameters(2);
                
                X1 = X0 + MainOkada.Parameters(7)*cosd(MainOkada.Parameters(5))*cosd(-MainOkada.Parameters(4));
                Y1 = Y0 + MainOkada.Parameters(7)*cosd(MainOkada.Parameters(5))*sind(-MainOkada.Parameters(4));
                
                XX = linspace(X0,X1,nrows+1); XX(end) = [];
                YY = linspace(Y0,Y1,nrows+1); YY(end) = [];
                
                for i=1:nrows
                    x0 = XX(i);
                    y0 = YY(i);
                    z0 = MainOkada.Parameters(3) - wid*(i-1)*sind(MainOkada.Parameters(5));
                    x1 = x0 + MainOkada.Parameters(6)*cosd(90 - MainOkada.Parameters(4))/2;
                    y1 = y0 + MainOkada.Parameters(6)*sind(90 - MainOkada.Parameters(4))/2;
                    
                    x2 = x0 - MainOkada.Parameters(6)*cosd(90 - MainOkada.Parameters(4))/2;
                    y2 = y0 - MainOkada.Parameters(6)*sind(90 - MainOkada.Parameters(4))/2;
                    
                    xx = linspace(x1,x2,2*ncols+1); xx = xx(2:2:end);
                    yy = linspace(y1,y2,2*ncols+1); yy = yy(2:2:end);
                    
                    for j=1:ncols
                        newsource = MainOkada;
                        newsource.Parameters(1) = xx(j);
                        newsource.Parameters(2) = yy(j);
                        newsource.Parameters(3) = z0;
                        newsource.Parameters(6) = len;
                        newsource.Parameters(7) = wid;
                        newsource.LowBoundaries(1) = newsource.Parameters(1) - ParamFree(1);
                        newsource.UpBoundaries(1) = newsource.Parameters(1) + ParamFree(1);
                        newsource.LowBoundaries(2) = newsource.Parameters(2) - ParamFree(2);
                        newsource.UpBoundaries(2) = newsource.Parameters(2) + ParamFree(2);
                        newsource.LowBoundaries(3) = newsource.Parameters(3) - ParamFree(3);
                        newsource.UpBoundaries(3) = newsource.Parameters(3) + ParamFree(3);
                        newsource.LowBoundaries(6) = newsource.Parameters(6) - ParamFree(4);
                        newsource.UpBoundaries(6) = newsource.Parameters(6) + ParamFree(4);
                        newsource.LowBoundaries(7) = newsource.Parameters(7) - ParamFree(5);
                        newsource.UpBoundaries(7) = newsource.Parameters(7) + ParamFree(5);
                        newsource.ActiveParameters(1) = ParamFree(1)>0;
                        newsource.ActiveParameters(2) = ParamFree(2)>0;
                        newsource.ActiveParameters(3) = ParamFree(3)>0;
                        newsource.ActiveParameters(6) = ParamFree(4)>0;
                        newsource.ActiveParameters(7) = ParamFree(5)>0;
                        
                        handles.Sources = [newsource, handles.Sources];
                        ss = [{['Okd',num2str(i),num2str(j)]};ss];
                        
                    end
                end
                set(handles.sourcelist,'String',ss);
                set(handles.sourcelist,'Value',1);
                guidata(hObject, handles);
                displayParameters(hObject, eventdata, handles);
                
            end
        end
    end
end


% --------------------------------------------------------------------
function onfaulttookada_Callback(hObject, eventdata, handles)
% hObject    handle to onfaulttookada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.sourcelist,'String'))
    i = get(handles.sourcelist,'Value');
    if strcmp(handles.Sources(i).Type,'OkadaOnFault')
        
        ss = get(handles.sourcelist,'String');
        ss(i) = [];
        OkadaOnFault = handles.Sources(i);
        handles.Sources(i) = [];
        
        
        
        
        x0 = OkadaOnFault.Parameters(1) + OkadaOnFault.Parameters(4)*cosd(90-OkadaOnFault.Parameters(3)) + OkadaOnFault.Parameters(5)*cosd(OkadaOnFault.Parameters(6))*cosd(-OkadaOnFault.Parameters(3));
        y0 = OkadaOnFault.Parameters(2) + OkadaOnFault.Parameters(4)*sind(90-OkadaOnFault.Parameters(3)) + OkadaOnFault.Parameters(5)*cosd(OkadaOnFault.Parameters(6))*sind(-OkadaOnFault.Parameters(3));
        z0 = OkadaOnFault.Parameters(5)*sind(OkadaOnFault.Parameters(6));
        
        newsource = newOkadaSource();
        
        newsource.Parameters = [x0 y0 z0 OkadaOnFault.Parameters(3) OkadaOnFault.Parameters(6:11) 0];
        newsource.Parameters = [x0 y0 z0 OkadaOnFault.Parameters(3) OkadaOnFault.Parameters(6:11) 0];
        newsource.Parameters = [x0 y0 z0 OkadaOnFault.Parameters(3) OkadaOnFault.Parameters(6:11) 0];
        
        handles.Sources = [newsource, handles.Sources];
        ss = [{'Okada'};ss];
        
        set(handles.sourcelist,'String',ss);
        set(handles.sourcelist,'Value',1);
        guidata(hObject, handles);
        displayParameters(hObject, eventdata, handles);
        
    end
end


% --------------------------------------------------------------------
function newpipe_Callback(hObject, eventdata, handles)
% hObject    handle to newpipe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newPipeSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'Pipe'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);



% --------------------------------------------------------------------
function newsillsun69_Callback(hObject, eventdata, handles)
% hObject    handle to newsillsun69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function newpennysource_Callback(hObject, eventdata, handles)
% hObject    handle to newpennysource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Sources = [newPennySource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'Penny'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);



% --------------------------------------------------------------------
function mogipressure_Callback(hObject, eventdata, handles)
% hObject    handle to mogipressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newMogiPressureSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'MogiPressure'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);




% --------------------------------------------------------------------
function newmctigue_Callback(hObject, eventdata, handles)
% hObject    handle to newmctigue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newMcTigueSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'McTigue'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);




% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function togglepanels(hObject, eventdata, handles)
if get(handles.GAs,'Value')
    set(handles.gapanel,'Visible','on');
else
    set(handles.gapanel,'Visible','off');
end

if get(handles.PS,'Value')
    set(handles.pspanel,'Visible','on');
else
    set(handles.pspanel,'Visible','off');
end

if get(handles.NLSQ,'Value')
    set(handles.NLSQpanel,'Visible','on');
else
    set(handles.NLSQpanel,'Visible','off');
end

% --------------------------------------------------------------------
function newopenpipe_Callback(hObject, eventdata, handles)
% hObject    handle to newopenpipe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newOpenPipeSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'OpenPipe'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);



% --- Executes on button press in invertnlsq.
function invertnlsq_Callback(hObject, eventdata, handles)
% hObject    handle to invertnlsq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if not(isempty(handles.Sources)) && not(isempty(handles.Stations))
    handles.SourcesHistory{end+1} = handles.Sources;
    if length(handles.SourcesHistory) > handles.SourcesHistoryLength
        handles.SourcesHistory(1) = [];
    end    
    handles.Sources = solveNLSQ(handles.Sources, handles.Stations, handles.PSparameters, handles.Terrain, get(handles.isNLSconstrained,'Value'));
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);
end


function edit55_Callback(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit55 as text
%        str2double(get(hObject,'String')) returns contents of edit55 as a double


% --- Executes during object creation, after setting all properties.
function edit55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit56_Callback(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit56 as text
%        str2double(get(hObject,'String')) returns contents of edit56 as a double


% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit57_Callback(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit57 as text
%        str2double(get(hObject,'String')) returns contents of edit57 as a double


% --- Executes during object creation, after setting all properties.
function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit58 as text
%        str2double(get(hObject,'String')) returns contents of edit58 as a double


% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
JacKnife(hObject, eventdata, handles, 'NLSQ');



function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double


% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NLSQ.
function NLSQ_Callback(hObject, eventdata, handles)
% hObject    handle to NLSQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NLSQ
togglepanels(hObject, eventdata, handles);




% --- Executes on button press in plotEQ.
function plotEQ_Callback(hObject, eventdata, handles)
% hObject    handle to plotEQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotEQ

if get(hObject,'Value')== 1
    res = EQgui;
    if ~isempty(res)
        handles.EarthQuakes = res;
        guidata(hObject, handles);
    end
else
    handles.EarthQuakes = [];
    guidata(hObject, handles);
end




% --------------------------------------------------------------------
function fisherI_Callback(hObject, eventdata, handles)
% hObject    handle to fisherI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[Measured Errors Weights] = mergedata(handles.Stations);

Params = [];
LB = [];
UB = [];

for i=1:length(handles.Sources)
    if (handles.Sources(i).IsActive)
        for k=1:handles.Sources(i).NParameters
            if handles.Sources(i).ActiveParameters(k)
                Params(end+1) = handles.Sources(i).Parameters(k);
                LB(end+1) = handles.Sources(i).LowBoundaries(k);
                UB(end+1) = handles.Sources(i).UpBoundaries(k);
            end
        end
    end
end

e = Information(Params, Measured, LB, UB, handles.Sources, handles.Stations, handles.Terrain, Errors, Weights);
msgbox(['Fisher Information: ',num2str(e,'%5.5g')],'Fisher Information');



% --------------------------------------------------------------------
function Untitled_14_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function residueanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to residueanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


for j=1:length(handles.Sensors)
    Sensors{j} = [];
end

err = [];

if get(handles.estimerr,'Value')
    NEstimation = handles.NEstimation;
else
    NEstimation = 1;
end
wh = waitbar(0, 'calculating');
for itrials = 1:NEstimation
    Sources = handles.Sources;
%     for i=1:length(handles.Sources)
%         if get(handles.estimerr,'Value')
%             Sources(i).Parameters = handles.Sources(i).Parameters + randn(size(handles.Sources(i).Parameters)).*handles.Sources(i).EParameters;
%         end
%     end
    for j=1:length(handles.Sensors)
        hand = mapModel(handles.Sensors(j));
        O = hand(Sources,handles.Sensors(j).Coordinates, handles.Terrain);
        Sensors{j} = [Sensors{j}; O];
    end
    waitbar(itrials/NEstimation,wh);
end

close(wh);
for j=1:length(handles.Sensors)
    if size(Sensors{j},1)>1
        handles.Sensors(j).Measurements = nanmean(Sensors{j});
        handles.Sensors(j).Errors = nanstd(Sensors{j});
    else
        handles.Sensors(j).Measurements = Sensors{j};
        handles.Sensors(j).Errors = zeros(size(handles.Sensors(j).Measurements));
    end
end

ModelsOut = [];
Measured = [];
Errors = [];


for i=1:length(handles.Stations)
    for j=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
            ModelsOut = [ModelsOut; handles.Sensors(j).Measurements(:)];
            Measured = [Measured; handles.Stations(i).Measurements(:)];
            Errors = [Errors; handles.Stations(i).Errors(:)];
        end
    end
end

Residues = (ModelsOut - Measured); %./Errors;

VarianceReduction = 1 - nansum( ((ModelsOut - Measured)./Measured).^2 );

[TestShapiroWilk, pValueSW] = swtest(Residues, 0.05, 0);

if TestShapiroWilk
    isnormal = 'Normal';
else
    isnormal = 'Rejected Normality';
end

Mean = nanmean(Residues);
Std = nanstd(Residues);
Skew = skewness(Residues);
Kurt = kurtosis(Residues);


figure,
hist(Residues,ceil(length(Residues)/3));
title({['Shapiro-Wilk at 95%: ',isnormal,' (pValue=',num2str(pValueSW,'%3.2f'),')'],...
    ['Mean: ',num2str(Mean,'%4.3f'),'  Std: ',num2str(Std,'%4.3f'),'   Skewness: ',num2str(Skew,'%4.3f'),'   Kurtosis: ',num2str(Kurt,'%4.3f')]});





% --------------------------------------------------------------------
function variancereduction_Callback(hObject, eventdata, handles)
% hObject    handle to variancereduction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



for j=1:length(handles.Sensors)
    Sensors{j} = [];
end

err = [];

if get(handles.estimerr,'Value')
    NEstimation = handles.NEstimation;
else
    NEstimation = 1;
end
wh = waitbar(0, 'calculating');
for itrials = 1:NEstimation
    Sources = handles.Sources;
    for i=1:length(Sources)
        if get(handles.estimerr,'Value')
            Sources(i).Parameters = handles.Sources(i).Parameters + randn(size(handles.Sources(i).Parameters)).*handles.Sources(i).EParameters;
        end
    end
    for j=1:length(handles.Sensors)
        hand = mapModel(handles.Sensors(j));
        O = hand(Sources,handles.Sensors(j).Coordinates, handles.Terrain);
        Sensors{j} = [Sensors{j}; O];
    end
    waitbar(itrials/NEstimation,wh);
end

close(wh);
for j=1:length(handles.Sensors)
    if size(Sensors{j},1)>1
        handles.Sensors(j).Measurements = nanmean(Sensors{j});
        handles.Sensors(j).Errors = nanstd(Sensors{j});
    else
        handles.Sensors(j).Measurements = Sensors{j};
        handles.Sensors(j).Errors = zeros(size(handles.Sensors(j).Measurements));
    end
end

ModelsOut = [];
Measured = [];


for i=1:length(handles.Stations)
    for j=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
            ModelsOut = [ModelsOut; handles.Sensors(j).Measurements(:)];
            Measured = [Measured; handles.Stations(i).Measurements(:)];
        end
    end
end

iok = Measured ~= 0;

VarianceReduction = 1 - nansum( ((ModelsOut(iok) - Measured(iok))./Measured(iok)).^2 );

msgbox(num2str(VarianceReduction,'%4.3f'),'Variance Reduction')


% --------------------------------------------------------------------
function chi2red_Callback(hObject, eventdata, handles)
% hObject    handle to chi2red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




for j=1:length(handles.Sensors)
    Sensors{j} = [];
end

Nparams = 0;
for i=1:length(handles.Sources)
    Nparams = Nparams + sum(handles.Sources(i).ActiveParameters ~= 0);
    SParameters{i} = handles.Sources(i).Parameters;
end

for j=1:length(handles.Sensors)
    hand = mapModel(handles.Sensors(j));
    O = hand(handles.Sources,handles.Sensors(j).Coordinates, handles.Terrain);
    Sensors{j} = [Sensors{j}; O];
end

for j=1:length(handles.Sensors)
    if size(Sensors{j},1)>1
        handles.Sensors(j).Measurements = nanmean(Sensors{j});
        handles.Sensors(j).Errors = nanstd(Sensors{j});
    else
        handles.Sensors(j).Measurements = Sensors{j};
        handles.Sensors(j).Errors = zeros(size(handles.Sensors(j).Measurements));
    end
end

ModelsOut = [];
Measured = [];
Errors =[];

for i=1:length(handles.Stations)
    for j=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
            ModelsOut = [ModelsOut; handles.Sensors(j).Measurements(:)];
            Measured = [Measured; handles.Stations(i).Measurements(:)];
            Errors = [Errors; handles.Stations(i).Errors(:)];
        end
    end
end

Nfree = length(Measured) - Nparams ;
Chi2red = sum(((ModelsOut - Measured)./Errors).^2) / Nfree;

msgbox(num2str(Chi2red,'%4.2f'),'Chi2 Reduced')



% --------------------------------------------------------------------
function pearschi2_Callback(hObject, eventdata, handles)
% hObject    handle to pearschi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



for j=1:length(handles.Sensors)
    Sensors{j} = [];
end

Nparams = 0;
for i=1:length(handles.Sources)
    Nparams = Nparams + sum(handles.Sources(i).ActiveParameters ~= 0);
    SParameters{i} = handles.Sources(i).Parameters;
end

for j=1:length(handles.Sensors)
    hand = mapModel(handles.Sensors(j));
    O = hand(handles.Sources,handles.Sensors(j).Coordinates, handles.Terrain);
    Sensors{j} = [Sensors{j}; O];
end

for j=1:length(handles.Sensors)
    if size(Sensors{j},1)>1
        handles.Sensors(j).Measurements = nanmean(Sensors{j});
        handles.Sensors(j).Errors = nanstd(Sensors{j});
    else
        handles.Sensors(j).Measurements = Sensors{j};
        handles.Sensors(j).Errors = zeros(size(handles.Sensors(j).Measurements));
    end
end

ModelsOut = [];
Measured = [];
Errors =[];

for i=1:length(handles.Stations)
    for j=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
            ModelsOut = [ModelsOut; handles.Sensors(j).Measurements(:)];
            Measured = [Measured; handles.Stations(i).Measurements(:)];
            Errors = [Errors; handles.Stations(i).Errors(:)];
        end
    end
end


if (length(Measured)<31)
    ModelsOut = [ModelsOut; ModelsOut];
    Measured = [Measured; Measured];
end

[h,p] = chi2gof(ModelsOut - Measured);

% nbins = min(max(floor(length(Measured)/5),10),80);
%
% x = linspace(min(Measured),max(Measured),nbins);
%
% nMeasured = hist(Measured,x);
% nModelsOut = hist(ModelsOut,xk);
%
%
% Nfree = length(Measured) - Nparams - 1;
% Chi2red = sum(((ModelsOut - Measured)./Errors).^2) / Nfree;

msgbox(['Normal Hp: ',num2str(h,'%d'),' p: ',num2str(p,'%4.2f')],'5% Pearson Chi2 Test')



% --------------------------------------------------------------------
function rcorrelation_Callback(hObject, eventdata, handles)
% hObject    handle to rcorrelation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[~, err, ModelsOut, OutErrors, Measured, MeasureErrors, Weight] = ForwardModel(handles);

figure,

plot(Measured,'k'); hold on
plot(ModelsOut,'b'); 

r = xcov(ModelsOut, Measured, 0, 'coeff');

title(['Xcoeff = ',num2str(r,'%g')]);




% --- Executes on button press in seterrors.
function seterrors_Callback(hObject, eventdata, handles)
% hObject    handle to seterrors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


is = get(handles.stationlist,'Value');

% answer = inputdlg({,'Set Errors',1,defAns)

namerr = [];
default = [];

for i=1:length(is)
    
    names = handles.Stations(is(i)).NameMeasurements;
    
    for j=1:length(names)
        found = 0;
        for k=1:length(namerr)
            if strcmp(namerr{k},names{j})
                found = 1;
                break;
            end
        end
        if ~found
            namerr{end+1} = names{j};
            default{end+1} = '0';
        end
    end
    
end

answer=inputdlg(namerr,'Set Errors',1,default);

if ~isempty(answer)
    for i=1:length(is)
        
        names = handles.Stations(is(i)).NameMeasurements;
        for j=1:length(names)
            found = 0;
            for k=1:length(namerr)
                if strcmp(namerr{k},names{j})
                    found = 1;
                    break;
                end
            end
            if found
                if str2num(answer{k})>=0
                    handles.Stations(is(i)).Errors(j) = str2num(answer{k});
                end
            end
        end
        
        
    end
    
    guidata(hObject, handles);
    displayMeasurements(hObject, eventdata, handles);
end


% --- Executes on button press in scaleok.
function scaleok_Callback(hObject, eventdata, handles)
% hObject    handle to scaleok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scaleok




% --------------------------------------------------------------------
function Paxes_Callback(hObject, eventdata, handles)
% hObject    handle to Paxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Station',1,{'Paxes'});
if ~isempty(answer)
    S = newPaxesStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function newsensorPaxes_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorPaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg('Name','Sensor',1,{'Paxes'});
if ~isempty(answer)
    
    S = newPaxesStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function exportPAxes_Callback(hObject, eventdata, handles)
% hObject    handle to exportPAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uiputfile( ...
    {'*.txt','P-Axes files (*.txt)'}, ...
    'Export P-Axes File');

if isequal(filename,0) | isequal(pathname,0)
else
    fid = fopen(fullfile(pathname,filename),'w');
    fprintf(fid,'Name Azim Dip ModelAzim ModelDip Angle \r\n');
    for i=1:length(handles.Stations)
        for j=1:length(handles.Sensors)
            if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
                if strcmp(handles.Sensors(j).Type,'Paxes')
                    ad = angleBetweenAxis(handles.Sensors(j).Measurements(1),handles.Sensors(j).Measurements(2), handles.Stations(i).Measurements(1),handles.Stations(i).Measurements(2));
                    fprintf(fid,'%s %5.1f %5.1f %5.1f %5.1f %5.1f\r\n',handles.Stations(i).Name,...
                        handles.Stations(i).Measurements(1), ...
                        handles.Stations(i).Measurements(2), ...
                        handles.Sensors(j).Measurements(1), ...
                        handles.Sensors(j).Measurements(2),...
                        ad);
                end
            end
        end
    end
    fclose(fid);
end





% --------------------------------------------------------------------
function addHeightsSS_Callback(hObject, eventdata, handles)
% hObject    handle to addHeightsSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Extr = [];
Nxtr = [];
h = msgbox('Please Wait ...','modal') ;

for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Baseline')
        Extr = [Extr; handles.Stations(i).Coordinates([2 5])', handles.Stations(i).Coordinates([2 5])'];
        Nxtr = [Nxtr; handles.Stations(i).Coordinates([1 4])', handles.Stations(i).Coordinates([1 4])'];
    else
        Extr = [Extr; handles.Stations(i).Coordinates(2), handles.Stations(i).Coordinates(2)];
        Nxtr = [Nxtr; handles.Stations(i).Coordinates(1), handles.Stations(i).Coordinates(1)];
    end
end

for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Baseline')
        Extr = [Extr; handles.Sensors(i).Coordinates([2 5])', handles.Sensors(i).Coordinates([2 5])'];
        Nxtr = [Nxtr; handles.Sensors(i).Coordinates([1 4])', handles.Sensors(i).Coordinates([1 4])'];
    else
        Extr = [Extr; handles.Sensors(i).Coordinates(2), handles.Sensors(i).Coordinates(2)];
        Nxtr = [Nxtr; handles.Sensors(i).Coordinates(1), handles.Sensors(i).Coordinates(1)];
    end
end

Eminmax = minmax(Extr(:)');
Nminmax = minmax(Nxtr(:)');

Eminmax = Eminmax + 0.15*[-1 1]*(Eminmax*[-1;1]);
Nminmax = Nminmax + 0.15*[-1 1]*(Nminmax*[-1;1]);


[X,Y,Z] = getDemMesh(strcat('ISOUTH_dem'),Eminmax,Nminmax);
Z = Z*3320;

xi = [];
yi = [];
for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Baseline')
        xi(end+1) = handles.Stations(i).Coordinates(2);
        yi(end+1) = handles.Stations(i).Coordinates(1);
        xi(end+1) = handles.Stations(i).Coordinates(5);
        yi(end+1) = handles.Stations(i).Coordinates(4);
    else
        xi(end+1) = handles.Stations(i).Coordinates(2);
        yi(end+1) = handles.Stations(i).Coordinates(1);
    end
end

if ~isempty(xi)
    zi = interp2(X',Y',Z',xi,yi);
    
    j = 1;
    for i=1:length(handles.Stations)
        if strcmp(handles.Stations(i).Type,'Baseline')
            handles.Stations(i).Coordinates(3) = zi(j); j=j+1;
            handles.Stations(i).Coordinates(6) = zi(j); j=j+1;
        else
            handles.Stations(i).Coordinates(3) = zi(j); j=j+1;
        end
    end
end

xi = [];
yi = [];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Baseline')
        xi(end+1) = handles.Sensors(i).Coordinates(2);
        yi(end+1) = handles.Sensors(i).Coordinates(1);
        xi(end+1) = handles.Sensors(i).Coordinates(5);
        yi(end+1) = handles.Sensors(i).Coordinates(4);
    else
        xi(i) = handles.Sensors(i).Coordinates(2);
        yi(i) = handles.Sensors(i).Coordinates(1);
    end
end

if ~isempty(xi)
    zi = interp2(X',Y',Z',xi,yi);
    
    j = 1;
    for i=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Type,'Baseline')
            handles.Sensors(i).Coordinates(3) = zi(j); j=j+1;
            handles.Sensors(i).Coordinates(6) = zi(j); j=j+1;
        else
            handles.Sensors(i).Coordinates(3) = zi(j); j=j+1;
        end
    end
end

close(h);
guidata(hObject, handles);
displayMeasurements(hObject, eventdata, handles);
displaySensors(hObject, eventdata, handles);





% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Parameter_Sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to Parameter_Sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MySources = [];
ObjX = [];
n = 0;
[gfdg BEST] = ForwardModel(handles);
hwb = waitbar(0,'Residual Time Inf');
howmany = 20;


THRESH = BEST*1.1;

tic;

for i=1:length(handles.Sources)
    pj = 0;
    for j=1:handles.Sources(i).NParameters
        if handles.Sources(i).ActiveParameters(j)
            pj = pj+1;
            Buoni(1,pj) = handles.Sources(i).Parameters(j);
        end
    end
end

Err = BEST;

while size(Buoni,1)< 20
    MyStation = handles.Stations;
    MySource = handles.Sources;
    for s=1:length(MySource)
        devs = (MySource(s).UpBoundaries - MySource(s).LowBoundaries)/10;
        devs = devs.*MySource(s).ActiveParameters;
        MySource(s).Parameters = handles.Sources(s).Parameters + randn(1,MySource(s).NParameters).*devs;
    end
    [~, ~,~, ~, population, scores]= solveGA(MySource, MyStation, handles.GAparameters, handles.Terrain, get(handles.isconstrained,'Value'), handles.ObjFunction);
    
    iok = find(scores<=THRESH);
    Buoni = [Buoni; population(iok,:)];
    Err = [Err; scores(iok)];
    
    temp = toc;
    totaltemp = temp/(n+size(Buoni,1));
    totaltemp = totaltemp*(howmany-n-size(Buoni,1))/60;
    waitbar(min((n+size(Buoni,1))/howmany,1),hwb,['Residual Time ',num2str(totaltemp,0),' minutes']);
end
close(hwb);
%
for i=1:length(handles.Sources)
    pj = 0;
    for j=1:handles.Sources(i).NParameters
        if handles.Sources(i).ActiveParameters(j)
            figure;
            pj = pj+1;
            plot(Buoni(:,pj),Err,'*');
            xlabel(handles.Sources(i).ParameterNames{j});
            ylabel('fitness');
        end
    end
end
%




% --------------------------------------------------------------------
function newmctigue3D_Callback(hObject, eventdata, handles)
% hObject    handle to newmctigue3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newMcTigue3DSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'McTigue3D'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);


% --------------------------------------------------------------------
function LocalReferenceSystem_Callback(hObject, eventdata, handles)
% hObject    handle to LocalReferenceSystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Easti = [];
Northi = [];
Upi = [];

for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Displacement')
        Easti = [Easti, handles.Stations(i).Measurements(2)];
        Northi = [Northi, handles.Stations(i).Measurements(1)];
        Upi = [Upi, handles.Stations(i).Measurements(3)];
    elseif strcmp(handles.Stations(i).Type,'HorizDisplacement')
        Easti = [Easti, handles.Stations(i).Measurements(2)];
        Northi = [Northi, handles.Stations(i).Measurements(1)];
        
    end
end

mE = median(Easti);
mN = median(Northi);
mU = median(Upi);

for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Displacement')
        handles.Stations(i).Measurements(2) = handles.Stations(i).Measurements(2) - mE;
        handles.Stations(i).Measurements(1) = handles.Stations(i).Measurements(1) - mN;
        handles.Stations(i).Measurements(3) = handles.Stations(i).Measurements(3) - mU;
    elseif strcmp(handles.Stations(i).Type,'HorizDisplacement')
        handles.Stations(i).Measurements(2) = handles.Stations(i).Measurements(2) - mE;
        handles.Stations(i).Measurements(1) = handles.Stations(i).Measurements(1) - mN;
    end
end
displayMeasurements(hObject, eventdata, handles);



% --------------------------------------------------------------------
function YangVolume_Callback(hObject, eventdata, handles)
% hObject    handle to YangVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newYangVolumeSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'YangVolume'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);


% --------------------------------------------------------------------
function addsill_Callback(hObject, eventdata, handles)
% hObject    handle to addsill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newSillSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'Sill'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);


% --------------------------------------------------------------------
function Earthquake_Callback(hObject, eventdata, handles)
% hObject    handle to Earthquake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Station',1,{'earthquake'});
if ~isempty(answer)
    S = newEarthquakeStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function newsensorEarthquake_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorEarthquake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg('Name','Sensor',1,{'earthquake'});
if ~isempty(answer)
    
    S = newEarthquakeStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function Strainmeter_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorStrainmeter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Station',1,{'strain'});
if ~isempty(answer)
    S = newStrainmeterStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function newsensorStrainmeter_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorStrainmeter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Sensor',1,{'strain'});
if ~isempty(answer)
    
    S = newStrainmeterStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end



% --------------------------------------------------------------------
function Baseline_Callback(hObject, eventdata, handles)
% hObject    handle to Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Station',1,{'baseline'});
if ~isempty(answer)
    S = newBaselineStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end



% --------------------------------------------------------------------
function newsensorBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorBaseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Sensor',1,{'baseline'});
if ~isempty(answer)
    
    S = newBaselineStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function doAICc_Callback(hObject, eventdata, handles)
% hObject    handle to doAICc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~, ~, ModelsOut, OutErrors, Measured, MeasureErrors, ~,Nfittedparameters] = ForwardModel(handles);

z = abs(ModelsOut-Measured)./sqrt(OutErrors.^2 + MeasureErrors.^2);

p = tpdf(z,1); % 1 dof because the measurement is just 1 sample, and we are testing if the measurement is compatible with the model output

L = prod(p);

n = length(Measured(:));
k = Nfittedparameters;
AICc = -n*log(L)+2*k +2*k*(k+1)/(n-k-1);
msgbox(['AICc: ',num2str(AICc,'%5.5g')],'AICc');





% --- Executes on button press in isPSconstrained.
function isPSconstrained_Callback(hObject, eventdata, handles)
% hObject    handle to isPSconstrained (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isPSconstrained


% --- Executes on button press in isNLSconstrained.
function isNLSconstrained_Callback(hObject, eventdata, handles)
% hObject    handle to isNLSconstrained (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isNLSconstrained


% --------------------------------------------------------------------
function setstartingsourceloc_Callback(hObject, eventdata, handles)
% hObject    handle to setstartingsourceloc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Easti = [];
Northi = [];

for i=1:length(handles.Stations)
    Easti = [Easti, handles.Stations(i).Coordinates(2)];
    Northi = [Northi, handles.Stations(i).Coordinates(1)];
    if strcmp(handles.Stations(i).Type,'Baseline')
        Easti = [Easti, handles.Stations(i).Coordinates(5)];
        Northi = [Northi, handles.Stations(i).Coordinates(4)];
    end
end

if ~isempty(handles.Stations)
    mE = median(Easti);
    mN = median(Northi);
    
    for i=1:length(handles.Sources)
        
    end
    
    for s=1:length(handles.Sources)
        handles.Sources(s).Parameters(1) = mE;
        handles.Sources(s).Parameters(2) = mN;
        
    end
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);
end



% --------------------------------------------------------------------
function setreferencelevel_Callback(hObject, eventdata, handles)
% hObject    handle to setreferencelevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Upi = [];

for i=1:length(handles.Stations)
        Upi = [Upi, handles.Stations(i).Coordinates(3)];
    if strcmp(handles.Stations(i).Type,'Baseline')
        Upi = [Upi, handles.Stations(i).Coordinates(6)];
    end
end

for i=1:length(handles.Sensors)
        Upi = [Upi, handles.Sensors(i).Coordinates(3)];
    if strcmp(handles.Sensors(i).Type,'Baseline')
        Upi = [Upi, handles.Sensors(i).Coordinates(6)];
    end
end

mU = mean(Upi);

for i=1:length(handles.Stations)
    handles.Stations(i).Coordinates(3) = mU;
    if strcmp(handles.Stations(i).Type,'Baseline')
        handles.Stations(i).Coordinates(6) = mU;
    end
end
for i=1:length(handles.Sensors)
    handles.Sensors(i).Coordinates(3) = mU;
    if strcmp(handles.Sensors(i).Type,'Baseline')
        handles.Sensors(i).Coordinates(6) = mU;
    end
end
displayMeasurements(hObject, eventdata, handles);
displaySensors(hObject, eventdata, handles);


% --------------------------------------------------------------------
function FASTsensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to FASTsensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = inputdlg('Number of integrals (M):',...
    'M', 1, {'50'});
if ~isempty(answer)
    M = str2double(answer);
    if get(handles.GAs,'Value')
        whatalgorithm = 'GA';
        OptParameters = handles.GAparameters;
        contrained = get(handles.isconstrained,'Value');
    elseif get(handles.PS,'Value')
        whatalgorithm = 'PS';
        OptParameters = handles.PSparameters;
        contrained = get(handles.isPSconstrained,'Value');
    elseif get(handles.NLSQ,'Value')
        whatalgorithm = 'NLSQ';
        OptParameters = handles.PSparameters;
        contrained = get(handles.isNLSconstrained,'Value');
    end
    
    Si = doInverseFAST(handles.Sources, handles.Stations, handles.Terrain, handles.ObjFunction, whatalgorithm, OptParameters, contrained, M);
    
    
end


% --- Executes on button press in pscompletepoll.
function pscompletepoll_Callback(hObject, eventdata, handles)
% hObject    handle to pscompletepoll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pscompletepoll
GUI2PSparams(hObject,handles);


% --------------------------------------------------------------------
function predictionscatterplot_Callback(hObject, eventdata, handles)
% hObject    handle to predictionscatterplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~, err, ModelsOut, OutErrors, Measured, MeasureErrors, Weight] = ForwardModel(handles);

ino = Measured == 0;

% Probability integral transform to make uniform distribution
[xCdf,xList]=ksdensity([Measured; ModelsOut],'npoints',5e3,'function','cdf');
measCdf=interp1(xList,xCdf,Measured);
modelCdf=interp1(xList,xCdf,ModelsOut);

p = polyfit(measCdf,modelCdf,1);

a = p(2);
b = p(1);

if (a>=0) && (a<=1)
    p1x = 0; p1y = a;
elseif a<0
    p1y = 0; p1x = -a/b;
elseif a>1
    p1y = 1; p1x = (1-a)/b;
end
if ((a+b)>=0) && ((a+b)<=1)
    p2x = 1; p2y = a+b;
elseif (a+b)<0
    p2y = 0; p2x = -a/b;
elseif (a+b)>1
    p2y = 1; p2x = (1-a)/b;
end


yfit =  p(1) * measCdf + p(2);
yresid = modelCdf - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(modelCdf)-1) * var(modelCdf);
rsq = 1 - SSresid/SStotal;

figure
plot([0;1],[0;1],':k', [p1x,p2x], [p1y,p2y],'k',measCdf, modelCdf,'r*');
xlabel('rescaled measurements');
ylabel('rescaled model predictions');
title(['R^2 = ',num2str(rsq,'%g')]);

% --------------------------------------------------------------------
function syncmeassensors_Callback(hObject, eventdata, handles)
% hObject    handle to syncmeassensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles = SortSyncStationSensors(handles);

for i=1:length(handles.Sensors)
    listtype{i} = handles.Sensors(i).Name;
end
set(handles.sensorlist,'String',listtype);
set(handles.sensorlist,'Value',1);

listtype = [];
for i=1:length(handles.Stations)
    listtype{i} = handles.Stations(i).Name;
end
set(handles.stationlist,'String',listtype);
set(handles.stationlist,'Value',1);

displaySensors(hObject, eventdata, handles);
displayMeasurements(hObject, eventdata, handles);


% --- Executes on button press in drawsources.
function drawsources_Callback(hObject, eventdata, handles)
% hObject    handle to drawsources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawsources


% --------------------------------------------------------------------
function createbaselines_Callback(hObject, eventdata, handles)
% hObject    handle to createbaselines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ss = get(handles.stationlist,'String');
istation = get(handles.stationlist,'Value');
if ~isempty(istation)
    if length(istation)<2
        msgbox('At least 2 displacement stations must be selected','modal')
    else
        for i=1:(length(istation)-1)
            for j=(i+1):length(istation)
                if (strcmp(handles.Stations(istation(i)).Type,'Displacement')) && (strcmp(handles.Stations(istation(j)).Type,'Displacement'))
                    A = handles.Stations(istation(i)).Coordinates;
                    B = handles.Stations(istation(j)).Coordinates;
                    d = norm(A-B);
                    
                    Am = handles.Stations(istation(i)).Coordinates + handles.Stations(istation(i)).Measurements;
                    Bm = handles.Stations(istation(j)).Coordinates + handles.Stations(istation(j)).Measurements;
                    
                    dm = norm(Am-Bm);
                    e = sqrt(sum(handles.Stations(istation(i)).Errors.^2) + sum(handles.Stations(istation(j)).Errors.^2));
                    
                    delta = dm-d;
                    
                    S = newBaselineStation();
                    S.Name = char([handles.Stations(istation(i)).Name,'-',handles.Stations(istation(j)).Name]);
                    S.Coordinates = [handles.Stations(istation(i)).Coordinates, handles.Stations(istation(j)).Coordinates];
                    S.Measurements = delta;
                    S.Errors = e;
                    
                    handles.Stations = [S, handles.Stations];
                    ss = [{S.Name};ss];
                end
            end
        end
        set(handles.stationlist,'String',ss);
        set(handles.stationlist,'Value',1);
        guidata(hObject, handles);
        
        displayMeasurements(hObject, eventdata, handles);
    end
end



% --- Executes on button press in showstationnames.
function showstationnames_Callback(hObject, eventdata, handles)
% hObject    handle to showstationnames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showstationnames


% --------------------------------------------------------------------
function copysourceparams_Callback(hObject, eventdata, handles)
% hObject    handle to copysourceparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.sourcelist,'String'))
    i = get(handles.sourcelist,'Value');
    handles.CopiedSource = handles.Sources(i);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function pastsourceparams_Callback(hObject, eventdata, handles)
% hObject    handle to pastsourceparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.sourcelist,'String'))
    s = get(handles.sourcelist,'Value');
    if isfield(handles,'CopiedSource')
        
        for i=1:length(handles.Sources(s).ParameterNames)
            for j=1:length(handles.CopiedSource.ParameterNames)
                if strcmp(handles.Sources(s).ParameterNames{i}, handles.CopiedSource.ParameterNames{j})
                    handles.Sources(s).Parameters(i) = handles.CopiedSource.Parameters(j);
                    handles.Sources(s).EParameters(i) = handles.CopiedSource.EParameters(j);
                    handles.Sources(s).LowBoundaries(i) = handles.CopiedSource.LowBoundaries(j);
                    handles.Sources(s).UpBoundaries(i) = handles.CopiedSource.UpBoundaries(j);
                    guidata(hObject, handles);
                end
            end
        end
        displayParameters(hObject, eventdata, handles);
    end
end


% --------------------------------------------------------------------
function setweight_Callback(hObject, eventdata, handles)
% hObject    handle to setweight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.stationlist,'String'))
    
    I = get(handles.stationlist,'Value');
    if ~isempty(I)
        answer=inputdlg('Weight','weight',1,{'1.0'});
        if ~isempty(answer)
            w = str2double(answer);
            for i=1:length(I)
                handles.Stations(I(i)).Weight = w;
            end
            guidata(hObject, handles);
            displayMeasurements(hObject, eventdata, handles);
        end
    end
end


% --------------------------------------------------------------------
function newokadaXS_Callback(hObject, eventdata, handles)
% hObject    handle to newokadaXS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newOkadaXSSource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'OkadaXS'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);


% --------------------------------------------------------------------
function insarview_Callback(hObject, eventdata, handles)
% hObject    handle to insarview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
insaro = directInSAR;
if ~isempty(insaro)
    azimuth = insaro(1);
    elevation = insaro(2);
    resolution = insaro(3);
    novertical = insaro(4);
    z0 = insaro(5);
    wrapped = insaro(6);
    
    x=[];y=[]; names = [];
    for i=1:length(handles.Stations)
                x = [x,handles.Stations(i).Coordinates(2)];
                y = [y,handles.Stations(i).Coordinates(1)];
                names = [names, {handles.Stations(i).Name}];
    end
    for i=1:length(handles.Sensors)
                x = [x,handles.Sensors(i).Coordinates(2)];
                y = [y,handles.Sensors(i).Coordinates(1)];
                names = [names, {handles.Sensors(i).Name}];
    end
    for i=1:length(handles.Sources)
                x = [x,handles.Sources(i).Parameters(1)];
                y = [y,handles.Sources(i).Parameters(2)];
                names = [names, {''}];
    end

    mMx = minmax(x(:)');
    xmin =mMx(1) - max(diff(mMx)/20, 1000);
    xmax =mMx(2) + max(diff(mMx)/20, 1000);
    
    mMy = minmax(y(:)');
    ymin =mMy(1) - max(diff(mMy)/20, 1000);
    ymax =mMy(2) + max(diff(mMy)/20, 1000);
    
    plotInSAR(xmin,ymin,xmax,ymax, z0, resolution, azimuth, elevation, handles.Sources, novertical, wrapped, handles.Terrain);
end


% --------------------------------------------------------------------
function newgravimeter_Callback(hObject, eventdata, handles)
% hObject    handle to newgravimeter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Station',1,{'gravity'});
if ~isempty(answer)
    S = newGravityStation();
    S.Name = char(answer);
    
    handles.Stations = [S, handles.Stations];
    ss = get(handles.stationlist,'String');
    ss = [{S.Name};ss];
    set(handles.stationlist,'String',ss);
    set(handles.stationlist,'Value',1);
    guidata(hObject, handles);
    
    displayMeasurements(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function newsensorGravity_Callback(hObject, eventdata, handles)
% hObject    handle to newsensorGravity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer=inputdlg('Name','Sensor',1,{'Gravity'});
if ~isempty(answer)
    
    S = newGravityStation();
    S.Name = char(answer);
    
    handles.Sensors = [S, handles.Sensors];
    ss = get(handles.sensorlist,'String');
    ss = [{S.Name};ss];
    set(handles.sensorlist,'String',ss);
    set(handles.sensorlist,'Value',1);
    guidata(hObject, handles);
    
    displaySensors(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function newokadadensity_Callback(hObject, eventdata, handles)
% hObject    handle to newokadadensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sources = [newOkadaDensitySource(), handles.Sources];
ss = get(handles.sourcelist,'String');
ss = [{'OkadaDensity'};ss];
set(handles.sourcelist,'String',ss);
set(handles.sourcelist,'Value',1);
guidata(hObject, handles);
displayParameters(hObject, eventdata, handles);


% --------------------------------------------------------------------
function removeHeight_Callback(hObject, eventdata, handles)
% hObject    handle to removeHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Extr = [];
Nxtr = [];
h = msgbox('Please Wait ...','modal') ;

for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Baseline')
        Extr = [Extr; handles.Stations(i).Coordinates([2 5])', handles.Stations(i).Coordinates([2 5])'];
        Nxtr = [Nxtr; handles.Stations(i).Coordinates([1 4])', handles.Stations(i).Coordinates([1 4])'];
    else
        Extr = [Extr; handles.Stations(i).Coordinates(2), handles.Stations(i).Coordinates(2)];
        Nxtr = [Nxtr; handles.Stations(i).Coordinates(1), handles.Stations(i).Coordinates(1)];
    end
end

for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Baseline')
        Extr = [Extr; handles.Sensors(i).Coordinates([2 5])', handles.Sensors(i).Coordinates([2 5])'];
        Nxtr = [Nxtr; handles.Sensors(i).Coordinates([1 4])', handles.Sensors(i).Coordinates([1 4])'];
    else
        Extr = [Extr; handles.Sensors(i).Coordinates(2), handles.Sensors(i).Coordinates(2)];
        Nxtr = [Nxtr; handles.Sensors(i).Coordinates(1), handles.Sensors(i).Coordinates(1)];
    end
end

Eminmax = minmax(Extr(:)');
Nminmax = minmax(Nxtr(:)');

Eminmax = Eminmax + 0.15*[-1 1]*(Eminmax*[-1;1]);
Nminmax = Nminmax + 0.15*[-1 1]*(Nminmax*[-1;1]);

xi = [];
yi = [];
for i=1:length(handles.Stations)
    if strcmp(handles.Stations(i).Type,'Baseline')
        xi(end+1) = handles.Stations(i).Coordinates(2);
        yi(end+1) = handles.Stations(i).Coordinates(1);
        xi(end+1) = handles.Stations(i).Coordinates(5);
        yi(end+1) = handles.Stations(i).Coordinates(4);
    else
        xi(end+1) = handles.Stations(i).Coordinates(2);
        yi(end+1) = handles.Stations(i).Coordinates(1);
    end
end

if ~isempty(xi)
    zi = 0;
    
    j = 1;
    for i=1:length(handles.Stations)
        if strcmp(handles.Stations(i).Type,'Baseline')
            handles.Stations(i).Coordinates(3) = zi; j=j+1;
            handles.Stations(i).Coordinates(6) = zi; j=j+1;
        else
            handles.Stations(i).Coordinates(3) = zi; j=j+1;
        end
    end
end

xi = [];
yi = [];
for i=1:length(handles.Sensors)
    if strcmp(handles.Sensors(i).Type,'Baseline')
        xi(end+1) = handles.Sensors(i).Coordinates(2);
        yi(end+1) = handles.Sensors(i).Coordinates(1);
        xi(end+1) = handles.Sensors(i).Coordinates(5);
        yi(end+1) = handles.Sensors(i).Coordinates(4);
    else
        xi(i) = handles.Sensors(i).Coordinates(2);
        yi(i) = handles.Sensors(i).Coordinates(1);
    end
end

if ~isempty(xi)
    zi = 0;
    
    j = 1;
    for i=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Type,'Baseline')
            handles.Sensors(i).Coordinates(3) = zi; j=j+1;
            handles.Sensors(i).Coordinates(6) = zi; j=j+1;
        else
            handles.Sensors(i).Coordinates(3) = zi; j=j+1;
        end
    end
end

close(h);
guidata(hObject, handles);
displayMeasurements(hObject, eventdata, handles);
displaySensors(hObject, eventdata, handles);


% --------------------------------------------------------------------
function addnoise2measures_Callback(hObject, eventdata, handles)
% hObject    handle to addnoise2measures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = msgbox('Please Wait ...','modal') ;

if ~isempty(get(handles.stationlist,'String'))
    
    I = get(handles.stationlist,'Value');
    if ~isempty(I)
        for i=1:length(I)
            handles.Stations(I(i)).Measurements = ...
                handles.Stations(I(i)).Measurements + randn(1,length(handles.Stations(I(i)).Errors)).*handles.Stations(I(i)).Errors;
        end
        guidata(hObject, handles);
        displayMeasurements(hObject, eventdata, handles);
    end
end

close(h);


function [C, Pnames] = calculateParamsCovariance(hObject, eventdata, handles, whatalgorithm)

MySources = [];
ObjX = [];
n = 0;
howmany = length(handles.Stations);

[~, fval0] = ForwardModel(handles);
hwb = waitbar(0,'Residual Time Inf');
tic;
for i=1:length(handles.Stations)
    MyStation = handles.Stations;
    MySource = handles.Sources;
    for s=1:length(MySource)
        ranges = (MySource(s).UpBoundaries - MySource(s).LowBoundaries);
        randvals = ranges.*randn(1,MySource(s).NParameters)/5 + MySource(s).Parameters;
        ino = randvals<MySource(s).LowBoundaries;
        randvals( ino ) = MySource(s).LowBoundaries(ino);
        ino = randvals>MySource(s).UpBoundaries;
        randvals( ino ) = MySource(s).UpBoundaries(ino);
        MySource(s).Parameters = randvals;
        MySource(s).Parameters(not(MySource(s).ActiveParameters)) = handles.Sources(s).Parameters(not(MySource(s).ActiveParameters));
    end
    MyStation(i) = [];
    if strcmp(whatalgorithm,'GA')
        [os, fval]= solveGA(MySource, MyStation, handles.GAparameters, handles.Terrain, get(handles.isconstrained,'Value'), handles.ObjFunction);
    elseif strcmp(whatalgorithm,'PS')
        [os, fval]= solvePS(MySource, MyStation, handles.PSparameters, handles.Terrain, get(handles.isPSconstrained,'Value'), handles.ObjFunction);
    elseif strcmp(whatalgorithm,'NLSQ')
        [os, fval]= solveNLSQ(MySource, handles.Stations, handles.PSparameters, handles.Terrain, get(handles.isNLSconstrained,'Value'));
    end
    if os.Parameters(7)<0
        fdsf=3;
    end
    MySources{i} = os;
    ObjX(i) = fval;
    temp = toc;
    totaltemp = temp/(n+i);
    totaltemp = totaltemp*(howmany-n-i)/60;
    waitbar((n+i)/howmany,hwb,['Residual Time ',num2str(totaltemp,0),' minutes']);
end
close(hwb);

okdone = prctile(ObjX,99.8); %3-sigma
iok = find((ObjX<okdone) & (ObjX<fval0*1.5));

n = length(iok);
MySources = MySources(iok);


p = 0;
for i=1:length(handles.Sources)
    p = p + sum(handles.Sources(i).ActiveParameters);
end


P = nan(length(MySources),p);
Pnames = cell(1,p);
for k=1:length(MySources)
    ip = 0;
    for i=1:length(handles.Sources)
       iac = handles.Sources(i).ActiveParameters>0;
       pars = MySources{k}(i).Parameters(iac);
       ip = ip+1;
       P(k,ip:(ip+sum(iac)-1)) = pars;
       if k==1
           Pnames(ip:(ip+sum(iac)-1)) = MySources{k}(i).ParameterNames(iac);
       end
    end
end

C = corrcoef(P);


figure,corrplot(P,'varNames',Pnames,'type','Pearson');



% --------------------------------------------------------------------
function parcovariance_Callback(hObject, eventdata, handles)
% hObject    handle to parcovariance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[C, Pnames] = calculateParamsCovariance(hObject, eventdata, handles, 'NLSQ');


% --- Executes on button press in sensors2stations.
function sensors2stations_Callback(hObject, eventdata, handles)
% hObject    handle to sensors2stations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = get(handles.sensorlist,'Value');
if ~isempty(I)
    for i=1:length(I)
        handles.Stations  = [handles.Stations, handles.Sensors(I(i))];
    end
end

for i=1:length(handles.Stations)
    listtype{i} = handles.Stations(i).Name;
end
if ~isempty(handles.Stations)
    set(handles.stationlist,'String',listtype);
    set(handles.stationlist,'Value',1);
end
guidata(hObject, handles);
displayMeasurements(hObject, eventdata, handles);


% --------------------------------------------------------------------
function duplicatestation_Callback(hObject, eventdata, handles)
% hObject    handle to duplicatestation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


I = get(handles.stationlist,'Value');
if ~isempty(I)
    for i=1:length(I)
        answer=inputdlg('Name','Station',1,{[handles.Stations(I(i)).Name,'c']});
        handles.Stations  = [handles.Stations, handles.Stations(I(i))];
        handles.Stations(end).Name = answer{1};
    end
end

for i=1:length(handles.Stations)
    listtype{i} = handles.Stations(i).Name;
end
if ~isempty(handles.Stations)
    set(handles.stationlist,'String',listtype);
    set(handles.stationlist,'Value',1);
end
guidata(hObject, handles);
displayMeasurements(hObject, eventdata, handles);


% --------------------------------------------------------------------
function duplicatesensor_Callback(hObject, eventdata, handles)
% hObject    handle to duplicatesensor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = get(handles.sensorlist,'Value');
if ~isempty(I)
    for i=1:length(I)
        answer=inputdlg('Name','Sensor',1,{[handles.Sensors(I(i)).Name,'c']});
        handles.Sensors  = [handles.Sensors, handles.Sensors(I(i))];
        handles.Sensors(end).Name = answer{1};
    end
end

for i=1:length(handles.Sensors)
    listtype{i} = handles.Sensors(i).Name;
end
if ~isempty(handles.Sensors)
    set(handles.sensorlist,'String',listtype);
    set(handles.sensorlist,'Value',1);
end
guidata(hObject, handles);
displaySensors(hObject, eventdata, handles);


% --------------------------------------------------------------------
function undoinversion_Callback(hObject, eventdata, handles)
% hObject    handle to undoinversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if not(isempty(handles.SourcesHistory))
    handles.Sources = handles.SourcesHistory{end};
    handles.SourcesHistory(end) = [];
    
    guidata(hObject, handles);
    displayParameters(hObject, eventdata, handles);

end

