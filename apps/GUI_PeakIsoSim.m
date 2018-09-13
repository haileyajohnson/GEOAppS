%% GUIDE basic setup functions
%

function varargout = GUI_PeakIsoSim(varargin)
% GUI_PEAKISOSIM MATLAB code for GUI_PeakIsoSim.fig
%      GUI_PEAKISOSIM, by itself, creates a new GUI_PEAKISOSIM or raises the existing
%      singleton*.
%
%      H = GUI_PEAKISOSIM returns the handle to a new GUI_PEAKISOSIM or the handle to
%      the existing singleton*.
%
%      GUI_PEAKISOSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PEAKISOSIM.M with the given input arguments.
%
%      GUI_PEAKISOSIM('Property','Value',...) creates a new GUI_PEAKISOSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PeakIsoSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PeakIsoSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PeakIsoSim

% Last Modified by GUIDE v2.5 08-Nov-2016 15:33:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PeakIsoSim_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PeakIsoSim_OutputFcn, ...
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

% --- Executes just before GUI_PeakIsoSim is made visible.
function GUI_PeakIsoSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PeakIsoSim (see VARARGIN)

% Choose default command line output for GUI_PeakIsoSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PeakIsoSim wait for user response (see UIRESUME)
% uiwait(handles.figure1);

initialize(hObject, eventdata, handles)

end

% --- Outputs from this function are returned to the command line.
function varargout = GUI_PeakIsoSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%%
% Simulation run functions

% --- Executes on button press in initialize_button.
function initialize(hObject, eventdata, handles)
cla
set(handles.pause_button,'string', 'Pause');
setappdata(handles.pause_button,'pause', 0);
setappdata(handles.reset_button, 'stopped', 0);
% enable run button
set(handles.run_button,'Enable', 'on');
crust=str2double(get(handles.crust_input,'string')); % km

xi=(0:10:1200);
elevation=(crust*ones(size(xi)))-(0.81*crust);
surf_init=elevation(1);
moho_init=surf_init-crust;
boundary=elevation-crust;

update_plot(xi, elevation, boundary, elevation, crust, surf_init, moho_init,'0');
set(gca,'fontsize',16)

setappdata(handles.run_button,'xi',xi);
setappdata(handles.run_button,'surf_init',surf_init);
setappdata(handles.run_button,'moho_init',moho_init);
end

% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% % hObject    handle to run_button (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
cla

% disable run button until reset
set(handles.run_button,'Enable', 'off');

incision_rate=str2double(get(handles.incision_input,'string')); % mm/yr
crust=str2double(get(handles.crust_input,'string')); % km
duration=str2double(get(handles.duration_input,'string')); %kyr

% density parameters
rho_w=1000;
rho_contcrust=2700;
rho_ocncrust=3000;
rho_mantle=3300;

g=9.81;      % gravity

dt=0.1;      % timestep size (in myr)

% get intialized data
xi=getappdata(handles.run_button,'xi');
surf_init=getappdata(handles.run_button,'surf_init');
moho_init=getappdata(handles.run_button,'moho_init');

% set fold points
x=(0:200:1200);
folded_crust=ones(1,7)*crust;


i=1;
while i<=duration/dt
    paused = getappdata(handles.pause_button, 'pause');
    stopped = getappdata(handles.reset_button, 'stopped');
    if stopped
        initialize(hObject, eventdata, handles);
        return;
    end
    if ~paused
        % incise valleys
        folded_crust([2 4 6])=folded_crust([2 4 6])-(incision_rate*dt);
        folded_interp=interp1(x,folded_crust,xi);
        folded_mean=mean(folded_interp);
        % isostaitc rebound
        M=(rho_contcrust/rho_mantle)*(crust-folded_mean);
        elevation=M+folded_interp-(0.81*crust);
        boundary=elevation-folded_interp;
        mean_elevation=mean(elevation)*ones(size(xi));
        % update plot
        update_plot(xi, elevation, boundary, mean_elevation, crust, surf_init, moho_init, num2str(i*dt));
        i=i+1;
     else
         pause(.1);
    end
end

hold on
% plot final comparison with inition conditions
plot(xi,moho_init*ones(size(xi)),'r-.','linewidth',2)
plot(xi,(surf_init*ones(size(xi))),'b-.','linewidth',2)
%title(['After ' num2str(i*dt) 'myr'],'Fontsize',12)
%text(300,mean(elevation)-1,['Mean Elev. = ' num2str(round(10*mean(elevation))/10) 'km'],'Fontsize',10)
hold off
drawnow
setappdata(handles.reset_button, 'stopped', 1);

end

%%
% Simulation helper functions

function update_plot(x, elevation, boundary, mean_elevation, crust, surf_init, moho_init, time)
plot(x,elevation,'linewidth',2),hold on  % surface line
plot(x,boundary,'r','linewidth',2)  % boundary line
plot(x,mean_elevation,'k-.','linewidth',2) %mean elevation line
axis([0 1200 surf_init-crust-5 surf_init+10])
title(['After ' time 'myr'],'Fontsize',14)
text(100, moho_init-3,'Mantle','Fontsize',16),text(100,surf_init-(crust/2),'Crust','Fontsize',16)
text(300,mean_elevation(1)-1,['Mean Elev. = ' num2str(round(10*mean_elevation(1))/10) 'km'],'Fontsize',16)
xlabel('km','fontsize',16)
ylabel('surface elevation (m)','fontsize',16)
hold off
set(gca,'fontsize',16)
drawnow
end 

%% Parameter definition functions
%
function incision_input_Callback(hObject, eventdata, handles)
% hObject    handle to incision_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of incision_input as text
%        str2double(get(hObject,'String')) returns contents of incision_input as a double
end

% --- Executes during object creation, after setting all properties.
function incision_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to incision_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function crust_input_Callback(hObject, eventdata, handles)
% hObject    handle to crust_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of crust_input as text
%        str2double(get(hObject,'String')) returns contents of crust_input as a double
initialize(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function crust_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to crust_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function duration_input_Callback(hObject, eventdata, handles)
% hObject    handle to duration_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_input as text
%        str2double(get(hObject,'String')) returns contents of duration_input as a double
end

% --- Executes during object creation, after setting all properties.
function duration_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','FontSize',16);
end
end

%% Run control functions
%

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
