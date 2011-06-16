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

% Last Modified by GUIDE v2.5 31-May-2011 13:43:20

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
