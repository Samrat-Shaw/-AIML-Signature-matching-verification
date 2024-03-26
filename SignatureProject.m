function varargout = SignatureProject(varargin)
% SIGNATUREPROJECT MATLAB code for SignatureProject.fig
%      SIGNATUREPROJECT, by itself, creates a new SIGNATUREPROJECT or raises the existing
%      singleton*.
%
%      H = SIGNATUREPROJECT returns the handle to a new SIGNATUREPROJECT or the handle to
%      the existing singleton*.
%
%      SIGNATUREPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNATUREPROJECT.M with the given input arguments.
%
%      SIGNATUREPROJECT('Property','Value',...) creates a new SIGNATUREPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SignatureProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SignatureProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 30-Apr-2020 15:58:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SignatureProject_OpeningFcn, ...
                   'gui_OutputFcn',  @SignatureProject_OutputFcn, ...
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


% --- Executes just before SignatureProject is made visible.
function SignatureProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SignatureProject (see VARARGIN)

% Choose default command line output for SignatureProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SignatureProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Set up the key press callback
set(handles.figure1, 'KeyPressFcn', @keyPressCallback);

% --- Outputs from this function are returned to the command line.
function varargout = SignatureProject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[a, b] = uigetfile('*.*', 'All Files');
img1 = imread([b, a]);
handles.img1 = img1;
guidata(hObject, handles);
imshow(img1, 'Parent', handles.axes1);
imshow(img1, 'Parent', handles.axes7);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
[a, b] = uigetfile('*.*', 'All Files');
img2 = imread([b, a]);
handles.img2 = img2;
guidata(hObject, handles);
imshow(img2, 'Parent', handles.axes2);
imshow(img2, 'Parent', handles.axes8);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
set(handles.panel, 'visible', 'off');
if isfield(handles, 'img1') && isfield(handles, 'img2')
    [V1, imgp1] = SignatureProjectFuntion(handles.img1);
    imshow(imgp1, 'Parent', handles.axes5);
    [V2, imgp2] = SignatureProjectFuntion(handles.img2);
    imshow(imgp2, 'Parent', handles.axes6);
    
    % Compare the features of the signatures
    difference = max(abs(V2 - V1));  % Calculate the maximum difference
    
    % Determine validity based on the difference
    if difference <= 0.4 % Adjust the threshold as needed
        msgbox('Valid Signature Verification');
        set(handles.resultview, 'string', 'Valid Signature Verification');
    else
        warndlg('Invalid Signature Verification');
        set(handles.resultview, 'string', 'Invalid Signature Verification');
    end
else
    errordlg('Please go back and select both images.');
    set(handles.resultview, 'string', 'Please go back and select both images.');
end
set(handles.panel2, 'visible', 'on');


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
set(handles.panel, 'visible', 'on');
set(handles.panel2, 'visible', 'off');


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
cla(handles.axes1, 'reset');
cla(handles.axes2, 'reset');
cla(handles.axes7, 'reset');
cla(handles.axes8, 'reset');

% Key press callback function
function keyPressCallback(src, evt)
    if strcmp(evt.Key, 'q') || strcmp(evt.Key, 'Q')
        close(gcf); % Close the current figure
    end
