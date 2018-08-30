%% GUIDE basic setup functions
%

function varargout = GUI_HillDiffSim(varargin)
% GUI_HILLDIFFSIM MATLAB code for GUI_HillDiffSim.fig
%      GUI_HILLDIFFSIM, by itself, creates a new GUI_HILLDIFFSIM or raises the existing
%      singleton*.
%
%      H = GUI_HILLDIFFSIM returns the handle to a new GUI_HILLDIFFSIM or the handle to
%      the existing singleton*.
%
%      GUI_HILLDIFFSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_HILLDIFFSIM.M with the given input arguments.
%
%      GUI_HILLDIFFSIM('Property','Value',...) creates a new GUI_HILLDIFFSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_HillDiffSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_HillDiffSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_HillDiffSim

% Last Modified by GUIDE v2.5 31-Oct-2014 15:24:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_HillDiffSim_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_HillDiffSim_OutputFcn, ...
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
end

% --- Executes just before GUI_HillDiffSim is made visible.
function GUI_HillDiffSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_HillDiffSim (see VARARGIN)

% Choose default command line output for GUI_HillDiffSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_HillDiffSim wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = GUI_HillDiffSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%% Simulation run functions
%

% --- Executes on button press in InitializeButton.
function InitializeButton_Callback(hObject, eventdata, handles)
% hObject    handle to InitializeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla
% user supplied inputs
duration=str2double(get(handles.edit_duration,'string'));   % kyr
noise_amp=str2double(get(handles.edit_noise,'string'));     % m
kappa=str2double(get(handles.edit_kappa,'string'));         % m^2/kyr

axes(handles.hillslope)
% initial plot
x=[1:10:1001];              % m
z=noise_amp*rand(size(x));    % m
z(1)=0; z(68)=0; z(end)=0;
plot(x,z,'b'),axis([0 1000 -2 28]),grid on, hold on
xlabel('horizontal distance (m)','fontsize',16)
ylabel('surface elevation (m)','fontsize',16)
set(gca,'fontsize',16)

% save plot data
setappdata(handles.InitializeButton,'x',x);
setappdata(handles.InitializeButton,'z',z);
end

% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla
% user supplied inputs
duration=str2double(get(handles.edit_duration,'string'));   % m
noise_amp=str2double(get(handles.edit_noise,'string'));     % m
kappa=str2double(get(handles.edit_kappa,'string'));         % m^2/kyr
uplift=str2double(get(handles.edit_uplift_rate,'string'));  % m/kyr
incision_rate=str2double(get(handles.edit_incision_rate,'string')); %m/kyr

% save intialized data
x=getappdata(handles.InitializeButton,'x');
z=getappdata(handles.InitializeButton,'z');
chans=getappdata(handles.checkbox_channels,'chans');

% initial plot
axes(handles.hillslope)
plot(x,z,'b'),axis([0 1000 -2 28]),grid on, hold on
xlabel('horizontal distance (m)','fontsize',16)
ylabel('surface elevation (m)','fontsize',16)
set(gca,'fontsize',16)

for i=1:duration
    dRdt=kappa*del2(z);
    z=z+dRdt+uplift;
    if chans==1
        z(1)=z(2);
%         z(1:2)=z(1)+incision_rate;
        z(67:69)=z(68)+incision_rate;
        z(end)=z(end-1);
%         z(end-1:end)=z(end)+incision_rate;
    else
        z(1)=z(2);z(end)=z(end-1);
    end
    axes(handles.hillslope);
    plot(x,z,'r'),axis([0 1000 -2 28])
    if i==duration,plot(x,z,'b'),end
    pause(0.1)
end
end

%% Parameter definition functions
%

function edit_kappa_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kappa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kappa as text
%        str2double(get(hObject,'String')) returns contents of edit_kappa as a double
end

% --- Executes during object creation, after setting all properties.
function edit_kappa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kappa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_uplift_rate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_uplift_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_uplift_rate as text
%        str2double(get(hObject,'String')) returns contents of edit_uplift_rate as a double
end

% --- Executes during object creation, after setting all properties.
function edit_uplift_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_uplift_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_noise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise as text
%        str2double(get(hObject,'String')) returns contents of edit_noise as a double
end

% --- Executes during object creation, after setting all properties.
function edit_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_duration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_duration as text
%        str2double(get(hObject,'String')) returns contents of edit_duration as a double
end

% --- Executes during object creation, after setting all properties.
function edit_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in checkbox_channels.
function checkbox_channels_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_channels

if (get(hObject,'Value') == get(hObject,'Max'))
	display('Channels selected');
    chans=1;
else
	display('Channels not selected');
    chans=0;
end
setappdata(handles.checkbox_channels,'chans',chans);
end

function edit_incision_rate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_incision_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_incision_rate as text
%        str2double(get(hObject,'String')) returns contents of edit_incision_rate as a double
end

% --- Executes during object creation, after setting all properties.
function edit_incision_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_incision_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
