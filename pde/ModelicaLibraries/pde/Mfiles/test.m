function varargout = test(varargin)
% TEST M-file for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 30-Jun-2004 15:12:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

matfile='';
if nargin >= 5 
    if not(strcmpi(varargin{1},'mat'))
        errordlg(['Unrecognized option: ' varargin{1}],'Input Argument Error!') 
        return
    else
        if not(exist(varargin{2},'file'))
            errordlg(['File does not exist or not a regular file: ' varargin{2}],'Input Argument Error!')
            return
        else
            matfile=varargin{2};
        end
    end
else
    matfile=uigetfile('*.mat','Open simulation result file');
    if not(exist(matfile,'file'))
       errordlg(['File does not exist or not a regular file: ' matfile],'Input Argument Error!')
       return
   end
end
load_variables(matfile,handles);

function load_variables(matfile, handles)
mat=dymload(matfile);
handles.matstr = mat;
femfnames=get_matching_names(mat.name,'(.*)\.domain\.grid\.triangle');
femfnames1d=get_matching_names(mat.name,'(.*)\.domain\.grid\.interval');
fdmfnames=get_matching_names(mat.name,'(.*)\.domain\.grid\.x1');
handles.femfnames=femfnames;
handles.femfnames1d=femfnames1d;
handles.fdmfnames=fdmfnames;
handles.currentvar = '-Variables-';
handles.plotfunc = @ones;
handles.interrupt = 0;
guidata(handles.figure1,handles);
set(handles.varpopup,'String',{'-Variables-' femfnames1d{:} femfnames{:} fdmfnames{:} });
set(handles.varpopup,'Value',1);
set(handles.timeslider,'Max',2);
set(handles.timeslider,'Min',1);
set(handles.timeslider,'SliderStep',[1 1]);
set(handles.timeslider,'Value',1);
time=dymget(handles.matstr,'Time');
set(handles.timeedit,'String',num2str(time(1)));

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function names = get_matching_names(namearray,regxp)
[s,f,t]=regexp(namearray,regxp);
names={};
for i=1:size(t)
    if not(isempty(t{i}))
        name=namearray(i,t{i}{1}(1):t{i}{1}(2));
        names=union(names,{name});
    end
end


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function timeslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function timeslider_Callback(hObject, eventdata, handles)
% hObject    handle to timeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=get(hObject,'Value');
val=round(val);
set(hObject,'Value',val);
time=dymget(handles.matstr,'Time');
set(handles.timeedit,'String',num2str(time(val)));
update_plot(handles);

% --- Executes during object creation, after setting all properties.
function timeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function timeedit_Callback(hObject, eventdata, handles)
% hObject    handle to timeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeedit as text
%        str2double(get(hObject,'String')) returns contents of timeedit as a double


% --- Executes during object creation, after setting all properties.
function varpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in varpopup.
function varpopup_Callback(hObject, eventdata, handles)
% hObject    handle to varpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns varpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from varpopup
contents=get(hObject,'String');
fname=contents{get(hObject,'Value')};
handles.currentvar=fname;
guidata(hObject, handles);
update_plot_var(handles);


function update_plot_var(handles)
fname=handles.currentvar;
if strcmpi(fname,'-Variables-')
    return
end
steps=1;
handles.plotfunc=@ones;
if ismember(fname,handles.femfnames)
    handles.plotfunc=@femplot;    
else
    if ismember(fname,handles.fdmfnames)
        handles.plotfunc=@fdmplot;
    else
        if ismember(fname,handles.femfnames1d)
            handles.plotfunc=@femplot1d;
        end
    end
end
guidata(handles.figure1, handles);
set(handles.viewchange,'Value',0);
set(handles.timeslider,'Value',1);
steps=update_plot(handles);
if (steps == 0)
    return
end
set(handles.timeslider,'Max',steps);
set(handles.timeslider,'SliderStep',[1./steps 1./steps]);
set(handles.movieframes,'String',num2str(steps));

if (get(handles.autoscale,'Value') == 0)
    val=cell2mat(dymget(handles.matstr,[handles.currentvar '.val']));
    minval=min(val);
    minval=min(minval);
    minval=round(0.95*minval*100)/100;
    maxval=max(val);
    maxval=max(maxval);
    maxval=round(1.05*maxval*100)/100;
    range=[minval maxval];
    set(handles.zrange,'String',num2str(range,2));
    set(handles.axes,'ZLim',range);
end

function steps=update_plot(handles)
fname=handles.currentvar;
view=get(handles.axes,'View');
step=get(handles.timeslider,'Value');
if strcmpi(fname,'-Variables-')
    return;
end
f=functions(handles.plotfunc);
fn=f.function;
steps=0;
if (strcmp(fn,'femplot') | strcmp(fn,'fdmplot'))
    steps=feval(handles.plotfunc, handles.matstr,fname,step);
    set(handles.axes,'View',view);
    set(handles.viewchange,'Value',0);
    if get(handles.autoscale,'Value') == 0
        zscale = 'manual';
        set(handles.axes,'ZLim',str2num(get(handles.zrange,'String')));
    else
        zscale = 'auto';
    end
    set(handles.axes,'ZLimMode',zscale);
end



% --- Executes on button press in viewchange.
function viewchange_Callback(hObject, eventdata, handles)
% hObject    handle to viewchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of viewchange
if get(hObject,'Value')
    rotate3d on;
else
    rotate3d off;
end


% --- Executes during object creation, after setting all properties.
function zrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zrange_Callback(hObject, eventdata, handles)
% hObject    handle to zrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zrange as text
%        str2double(get(hObject,'String')) returns contents of zrange as a double
update_plot(handles);

% --- Executes on button press in autoscale.
function autoscale_Callback(hObject, eventdata, handles)
% hObject    handle to autoscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoscale
update_plot(handles);


% --- Executes on button press in movie.
function movie_Callback(hObject, eventdata, handles)
% hObject    handle to movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
maxsteps=str2num(get(handles.movieframes,'String'));
min=get(handles.timeslider,'Min');
max=get(handles.timeslider,'Max');
if (maxsteps > max | maxsteps == 0)
    maxsteps=max;
end
step=round(max/maxsteps);
j=1;
for i=min:step:max
    set(handles.timeslider,'Value',i);
    update_plot(handles);
    M(j)=getframe;
    j=j+1;
    drawnow;
    handles=guidata(hObject);
    if (handles.interrupt==1)
        handles.interrupt==0;
        guidata(hObject,handles);
        break;
    end
end
f=figure;
movie(f,M,100);


% --- Executes on button press in abort.
function abort_Callback(hObject, eventdata, handles)
% hObject    handle to abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.interrupt=1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function movieframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movieframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function movieframes_Callback(hObject, eventdata, handles)
% hObject    handle to movieframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movieframes as text
%        str2double(get(hObject,'String')) returns contents of movieframes as a double


