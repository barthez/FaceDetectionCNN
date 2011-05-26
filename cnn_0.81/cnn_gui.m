function varargout = cnn_gui(varargin)
% CNN_GUI M-file for cnn_gui.fig
%      CNN_GUI, by itself, creates a new CNN_GUI or raises the existing
%      singleton*.
%
%      H = CNN_GUI returns the handle to a new CNN_GUI or the handle to
%      the existing singleton*.
%
%      CNN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CNN_GUI.M with the given input arguments.
%
%      CNN_GUI('Property','Value',...) creates a new CNN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cnn_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cnn_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cnn_gui

% Last Modified by GUIDE v2.5 04-Jan-2010 23:15:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cnn_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @cnn_gui_OutputFcn, ...
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


        
% --- Executes just before cnn_gui is made visible.
function cnn_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cnn_gui (see VARARGIN)

% Choose default command line output for cnn_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cnn_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cnn_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%Create waitbar inside gui for training
axFontSize=get(0,'FactoryAxesFontSize');
colormap([]);
%axPos = get(hObject,'position');
axPos=[100,10,200,10];
handles.prBar1 = axes('XLim',[0 100],...
    'YLim',[0 1],...
    'Box','on', ...
    'Units','Points',...
    'FontSize', axFontSize,...
    'Position',axPos,...
    'XTickMode','manual',...
    'YTickMode','manual',...
    'XTick',[],...
    'YTick',[],...
    'XTickLabelMode','manual',...
    'XTickLabel',[],...
    'YTickLabelMode','manual',...
    'YTickLabel',[]);

xpatch = [0 0 0 0];
ypatch = [0 0 1 1];
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
handles.PBpatch1 = patch(xpatch,ypatch,'r','EdgeColor','r','EraseMode','none','Tag','TrainPatch');
setappdata(handles.PBpatch1 ,'waitbar__data__',0);
handles.PBline1 = line(xline,yline,'EraseMode','none');
set(handles.PBline1,'Color',get(gca,'XColor'));

%Create waitbar inside gui for Hessian
axPos=[360,10,200,10];
handles.prBar2 = axes('XLim',[0 100],...
    'YLim',[0 1],...
    'Box','on', ...
    'Units','Points',...
    'FontSize', axFontSize,...
    'Position',axPos,...
    'XTickMode','manual',...
    'YTickMode','manual',...
    'XTick',[],...
    'YTick',[],...
    'XTickLabelMode','manual',...
    'XTickLabel',[],...
    'YTickLabelMode','manual',...
    'YTickLabel',[],...
    'Tag','HPrBar');

xpatch = [0 0 0 0];
ypatch = [0 0 1 1];
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
handles.PBpatch2 = patch(xpatch,ypatch, 'r','EdgeColor','r','EraseMode','none','Tag','HessPatch');
setappdata(handles.PBpatch2 ,'waitbar__data__',0);
handles.PBline2 = line(xline,yline,'EraseMode','none','Tag','HessLine');
set(handles.PBline2,'Color',get(gca,'XColor'));


% --- Executes on button press in AbortButton.
function AbortButton_Callback(hObject, eventdata, handles)
% hObject    handle to AbortButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData','abort');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over AbortButton.
function AbortButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to AbortButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData','abort');



function EpEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EpEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EpEdit as text
%        str2double(get(hObject,'String')) returns contents of EpEdit as a double


% --- Executes during object creation, after setting all properties.
function EpEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EpEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ItEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ItEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ItEdit as text
%        str2double(get(hObject,'String')) returns contents of ItEdit as a double


% --- Executes during object creation, after setting all properties.
function ItEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ItEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RMSEedit_Callback(hObject, eventdata, handles)
% hObject    handle to RMSEedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RMSEedit as text
%        str2double(get(hObject,'String')) returns contents of RMSEedit as a double


% --- Executes during object creation, after setting all properties.
function RMSEedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RMSEedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MCRedit_Callback(hObject, eventdata, handles)
% hObject    handle to MCRedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MCRedit as text
%        str2double(get(hObject,'String')) returns contents of MCRedit as a double


% --- Executes during object creation, after setting all properties.
function MCRedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MCRedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TrainPrEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TrainPrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TrainPrEdit as text
%        str2double(get(hObject,'String')) returns contents of TrainPrEdit as a double


% --- Executes during object creation, after setting all properties.
function TrainPrEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrainPrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HessPrEdit_Callback(hObject, eventdata, handles)
% hObject    handle to HessPrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HessPrEdit as text
%        str2double(get(hObject,'String')) returns contents of HessPrEdit as a double


% --- Executes during object creation, after setting all properties.
function HessPrEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HessPrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TetaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TetaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TetaEdit as text
%        str2double(get(hObject,'String')) returns contents of TetaEdit as a double


% --- Executes during object creation, after setting all properties.
function TetaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TetaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
