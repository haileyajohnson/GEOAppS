%% GUIDE basic setup functions
%

function varargout = GUI_PeriglacialSim(varargin)
% GUI_PERIGLACIALSIM MATLAB code for GUI_PeriglacialSim.fig
%      GUI_PERIGLACIALSIM, by itself, creates a new GUI_PERIGLACIALSIM or raises the existing
%      singleton*.
%
%      H = GUI_PERIGLACIALSIM returns the handle to a new GUI_PERIGLACIALSIM or the handle to
%      the existing singleton*.
%
%      GUI_PERIGLACIALSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PERIGLACIALSIM.M with the given input arguments.
%
%      GUI_PERIGLACIALSIM('Property','Value',...) creates a new GUI_PERIGLACIALSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PeriglacialSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PeriglacialSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PeriglacialSim

% Last Modified by GUIDE v2.5 10-Nov-2016 11:06:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PeriglacialSim_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PeriglacialSim_OutputFcn, ...
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


% --- Executes just before GUI_PeriglacialSim is made visible.
function GUI_PeriglacialSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PeriglacialSim (see VARARGIN)

% Choose default command line output for GUI_PeriglacialSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PeriglacialSim wait for user response (see UIRESUME)
% uiwait(handles.figure1);

initialize(hObject, eventdata, handles);

end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_PeriglacialSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end

%% Simulation run functions
%

function initialize(hObject, eventdata, handles)
cla

set(handles.pause_button,'string', 'Pause');
setappdata(handles.pause_button,'pause', 0);
setappdata(handles.reset_button, 'stopped', 0);
% enable run button
set(handles.run_button,'Enable', 'on');

type=get(handles.temp_function_input, 'Value');

kappa_mm2persec=1;
kappa_m2persec=kappa_mm2persec*((1/1000)^2);
P=pi*1e7;
zstar=sqrt(kappa_m2persec*P/pi);

z=(0:0.1:20)';
Tamp=15;
dTdz=-0.025;
t=0:P/50:3*P;
x = t./P;

switch type
    case 1
        [surf_t, subsurf_t]=get_sinusoidal_temps(z, zstar, dTdz, t, Tamp, P);
    case 2
        [surf_t, subsurf_t]=get_linear_temps(z, zstar, dTdz, t, Tamp, P, x);
    case 3
        [surf_t, subsurf_t]=get_log_temps(z, zstar, dTdz, t, Tamp, P, x);
    case 4
        [surf_t, subsurf_t]=get_exp_temps(z, zstar, dTdz, t, Tamp, P, x);
end
update_plot(surf_t, x, subsurf_t, 1, handles);

setappdata(handles.run_button,'surf_t',surf_t);
setappdata(handles.run_button,'subsurf_t',subsurf_t);
setappdata(handles.run_button,'x',x);
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla

% disable run button until reset
set(handles.run_button,'Enable', 'off');

type=getappdata(handles.temp_function_input, 'value');

surf_t=getappdata(handles.run_button, 'surf_t');
subsurf_t=getappdata(handles.run_button, 'subsurf_t');
x=getappdata(handles.run_button, 'x');

time=1;
while time<=length(x)    
    paused = getappdata(handles.pause_button, 'pause');
    stopped = getappdata(handles.reset_button, 'stopped');
    if stopped
        initialize(hObject, eventdata, handles);
        return;
    end
    if ~paused
        update_plot(surf_t, x ,subsurf_t, time, handles);
        time=time+1;
    else
        pause(.05);
    end
end

setappdata(handles.reset_button, 'stopped', 1);
end


%% Simulation helper functions
%

function [surf, sub] = get_sinusoidal_temps(z, zstar, dTdz, t, Tamp, P)
Ts=-10*ones(length(z),1);
sub=zeros(length(z),length(t));
surf=Tamp*sin((2*pi*t/P))-10;
for time = (1:1:length(t))    
    sub(:,time)=(Ts)-((dTdz).*z)+(Tamp.*exp(-z./zstar).*sin((2*pi*t(time)/P)-(z./zstar)));
end
end

function [surf, sub] = get_linear_temps(z, zstar, dTdz, t, Tamp, P, x)
slope = (2*Tamp)/(x(end) - x(1));
Ts=-10*ones(length(z),1);
sub=zeros(length(z),length(t));
surf=(slope.*x)-10;
for time = (1:1:length(t))    
    sub(:,time)=(Ts)-((dTdz).*z)+(Tamp.*exp(-z./zstar).*(slope.*t(time)/P - (z./zstar)));
end
end

function [surf, sub] = get_log_temps(z, zstar, dTdz, t, Tamp, P, x)
Ts=-10*ones(length(z),1);
sub=zeros(length(z),length(t));
surf=(Tamp/(x(end)-x(1)))*log(x);
for time = (1:1:length(t))    
    sub(:,time)=(Ts)-((dTdz).*z)+(Tamp.*exp(-z./zstar).*log(t(time)/P - (z./zstar)));
end
end

function [surf, sub] = get_exp_temps(z, zstar, dTdz, t, Tamp, P, x)
Ts=-10*ones(length(z),1);
sub=zeros(length(z),length(t));
surf=exp(x)-10;
for time = (1:1:length(t))    
    sub(:,time)=(Ts)-((dTdz).*z)+(Tamp.*exp(-z./zstar).*exp(t(time)/P - (z./zstar)));
end
end

function update_plot(surf_t, x, subsurf_t, time, handles)

z=(0:0.1:20)';
% Surface temperature plot
axes(handles.surf_temp);
plot([0 3],[0 0],'r--','linewidth',2),hold on
plot(x, surf_t,'linewidth',2),grid on
xlabel('Time (years)','fontsize',16)
ylabel('Temperature (deg C)','fontsize',16)
title('Surface Temperature Time Series','fontsize',16)
plot(x(time), surf_t(time),'ko','markersize',15,'markerfacecolor','r')
set(gca,'fontsize',16), hold off

%temperature profile plot
axes(handles.ground_temp);
plot(subsurf_t(:,time),z,'linewidth',2),axis([-25 5 0 8]),hold on
plot([0 0],[0 20],'r--','linewidth',2),axis ij,grid on,hold off
ylabel('depth (m)','fontsize',16)
xlabel('Temperature (deg C)','fontsize',16)
title('Temperature Profile','fontsize',16)
set(gca,'fontsize',16)
drawnow
end

%% Paramter definition functions
%

% --- Executes on selection change in temp_function_input.
function temp_function_input_Callback(hObject, eventdata, handles)
% hObject    handle to temp_function_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns temp_function_input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from temp_function_input
initialize(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function temp_function_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp_function_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pause_button.
function pause_button_Callback(hObject, eventdata, handles)
% hObject    handle to pause_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
paused=getappdata(handles.pause_button, 'pause');
paused=~paused;
setappdata(handles.pause_button,'pause', paused);
if paused
    set(handles.pause_button,'string', 'Resume');
else
    set(handles.pause_button,'string', 'Pause');
end
end


%% Run control functions
%

% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if getappdata(handles.reset_button, 'stopped')
    initialize(hObject, eventdata, handles)
else
setappdata(handles.reset_button, 'stopped', 1);
end
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
