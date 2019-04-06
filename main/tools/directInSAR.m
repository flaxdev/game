function varargout = directInSAR(varargin)
% DIRECTINSAR MATLAB code for directInSAR.fig
%      DIRECTINSAR, by itself, creates a new DIRECTINSAR or raises the existing
%      singleton*.
%
%      H = DIRECTINSAR returns the handle to a new DIRECTINSAR or the handle to
%      the existing singleton*.
%
%      DIRECTINSAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIRECTINSAR.M with the given input arguments.
%
%      DIRECTINSAR('Property','Value',...) creates a new DIRECTINSAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before directInSAR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to directInSAR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help directInSAR

% Last Modified by GUIDE v2.5 05-Jan-2019 17:09:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @directInSAR_OpeningFcn, ...
                   'gui_OutputFcn',  @directInSAR_OutputFcn, ...
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


% --- Executes just before directInSAR is made visible.
function directInSAR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to directInSAR (see VARARGIN)

% Choose default command line output for directInSAR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes directInSAR wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = directInSAR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
% delete(handles.figure1);

set(handles.figure1,'Visible','off');

% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
azim = str2double(get(handles.azim,'String'));
elev = str2double(get(handles.elev,'String'));
novert = get(handles.novert,'Value');
resol = str2double(get(handles.resol,'String'));
z0 = str2double(get(handles.z0,'String'));
wrapped = get(handles.wrapped,'Value');

handles.output = [azim elev resol novert z0 wrapped];

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = [];

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes on button press in novert.
function novert_Callback(hObject, eventdata, handles)
% hObject    handle to novert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of novert



function azim_Callback(hObject, eventdata, handles)
% hObject    handle to azim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of azim as text
%        str2double(get(hObject,'String')) returns contents of azim as a double


% --- Executes during object creation, after setting all properties.
function azim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to azim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elev_Callback(hObject, eventdata, handles)
% hObject    handle to elev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elev as text
%        str2double(get(hObject,'String')) returns contents of elev as a double


% --- Executes during object creation, after setting all properties.
function elev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resol_Callback(hObject, eventdata, handles)
% hObject    handle to resol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resol as text
%        str2double(get(hObject,'String')) returns contents of resol as a double


% --- Executes during object creation, after setting all properties.
function resol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, just close it
    delete(handles.figure1);
end



function z0_Callback(hObject, eventdata, handles)
% hObject    handle to z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z0 as text
%        str2double(get(hObject,'String')) returns contents of z0 as a double


% --- Executes during object creation, after setting all properties.
function z0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in wrapped.
function wrapped_Callback(hObject, eventdata, handles)
% hObject    handle to wrapped (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wrapped
