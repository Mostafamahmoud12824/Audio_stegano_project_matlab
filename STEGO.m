function varargout = STEGO(varargin)
% STEGO MATLAB code for STEGO.fig
%      STEGO, by itself, creates a new STEGO or raises the existing
%      singleton*.
%
%      H = STEGO returns the handle to a new STEGO or the handle to
%      the existing singleton*.
%
%      STEGO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEGO.M with the given input arguments.
%
%      STEGO('Property','Value',...) creates a new STEGO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before STEGO_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to STEGO_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help STEGO

% Last Modified by GUIDE v2.5 13-Mar-2021 02:53:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @STEGO_OpeningFcn, ...
                   'gui_OutputFcn',  @STEGO_OutputFcn, ...
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


% --- Executes just before STEGO is made visible.
function STEGO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to STEGO (see VARARGIN)

% Choose default command line output for STEGO
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes STEGO wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = STEGO_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in playInput.
function playInput_Callback(hObject, eventdata, handles)
% hObject    handle to playInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a=handles.a;
filename=handles.filename;
[y,fs] = audioread(filename);
sound(a,fs);

% --- Executes on button press in playOutput.
function playOutput_Callback(hObject, eventdata, handles)
% hObject    handle to playOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d=handles.d;
filename=handles.filename;
[y,fs] = audioread(filename);
sound(d,fs);

% --- Executes on button press in showOut.
function showOut_Callback(hObject, eventdata, handles)
% hObject    handle to showOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.secretAfter , 'string' , handles.message);

function secretAfter_Callback(hObject, eventdata, handles)
% hObject    handle to secretAfter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secretAfter as text
%        str2double(get(hObject,'String')) returns contents of secretAfter as a double


% --- Executes during object creation, after setting all properties.
function secretAfter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secretAfter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enterAudio.
function enterAudio_Callback(hObject, eventdata, handles)
% hObject    handle to enterAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.wav', 'Pick an audio');
if isequal(filename,0) || isequal(pathname,0)
    warndlg('Audio is not selected');
else
    a=audioread(filename);
    axes(handles.axes1);
    plot(a);
%   disp(a);
    handles.filename=filename;
    handles.a=a;
    guidata(hObject, handles);
    helpdlg('Input audio is Selected');
end

% --- Executes on button press in enterSecret.
function enterSecret_Callback(hObject, eventdata, handles)
% hObject    handle to enterSecret (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.txt', 'Pick any txt file');
if isequal(filename,0) || isequal(pathname,0)
	warndlg('txt file is not selected');
else
    F = filename;
end

handles.F=F;
guidata(hObject, handles);
helpdlg('Text File is Selected');

% --- Executes on button press in embed.
function embed_Callback(hObject, eventdata, handles)
% hObject    handle to embed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[sound, fs] = audioread(handles.filename);

[sound_bits, neg_loc] = getBitsFromSound(handles.filename);
string_bits = getBitsFromString("Secret.txt");

sound_bits = embedStringBitsToSoundBits(sound_bits, string_bits);

reconstructed_sound = bin2dec(sound_bits) / 32768;

for i=1:length(neg_loc)
    reconstructed_sound(neg_loc(i)) = reconstructed_sound(neg_loc(i)) * -1;
end

audiowrite("hidden_sound.wav", reconstructed_sound, fs);

    d = audioread("hidden_sound.wav");
    axes(handles.axes2);
    plot(d);
    handles.d=d;
    guidata(hObject, handles);
helpdlg('Embedded process completed');


% --- Executes on button press in extract.
function extract_Callback(hObject, eventdata, handles)
% hObject    handle to extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message = extractMessageFromSteganographedSound("hidden_sound.wav");
handles.message=message;
    guidata(hObject, handles);
helpdlg('Extraction process completed');