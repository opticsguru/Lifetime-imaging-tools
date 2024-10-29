function varargout = LifeImage(varargin)
% LIFEIMAGE M-file for LifeImage.fig
%      LIFEIMAGE, by itself, creates a new LIFEIMAGE or raises the existingcurr_tpsf
%      singleton*.
%
%      H = LIFEIMAGE returns the handle to a new LIFEIMAGE or the handle to
%      the existing singleton*.
%
%      LIFEIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIFEIMAGE.M with the given input arguments.
%
%      LIFEIMAGE('Property','Value',...) creates a new LIFEIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TDrecon3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LifeImage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LifeImage

% Last Modified by GUIDE v2.5 18-Jan-2022 14:44:14
%%%%%%%%%%  Change Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4/30/12: fixed bug lifetime analysis, failure to add label results in one
% roi.
% Added uipanels and togglebuttons for lifetime and amp maps
%5/16 make platform indedpendent. (directory slashes)




%%%%%%%%%%%%%%%%  end  Change Log %%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LifeImage_OpeningFcn, ...
    'gui_OutputFcn',  @LifeImage_OutputFcn, ...
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


% --- Executes just before LifeImage is made visible.
function LifeImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LifeImage (see VARARGIN)

% Choose default command line output for LifeImage
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

set(handles.uipanel7,'Visible','Off');
set(handles.uipanel8,'Visible','Off');
set(handles.uipanel3,'Visible','On');
% set(handles.ImageToolsPanel,'Visible','Off');
set(handles.togglebutton_CW_Intensity,'Value',1);
set(handles.togglebutton_lifetime_image,'Value',0);
set(handles.togglebutton_amplitude_image,'Value',0);
%to automatically start LifeImage with a specified directory save the path
%with  setappdata(0,'passeddir', 'path to the data directory');
if  isappdata(0,'passeddir')
    set(handles.edit6,'String',[getappdata(0,'passeddir'),'/*']);
    rmappdata(0,'passeddir');
    edit6_Callback(hObject, eventdata, handles);
end


if ispc
    %          cd ('b:\Data\');
end
% path(path,'D:\Work\projects\MatlabTools\FlimFit');
% UIWAIT makes LifeImage wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LifeImage_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%a andles.file_names(get(hObject,'Value'));
%a =  char(cellstr(a{1}))
%whosaa

all_fun = dbstack;
calling_fun = all_fun(2).name;

if strcmp(calling_fun, 'togglebutton_CW_Intensity_Callback')
    fileprefix_curr = get(handles.edit9,'String');
else
    contents = get(hObject,'String');
    fileprefix_curr = contents{get(hObject,'Value')};
    set(handles.edit9,'String',fileprefix_curr);
end

dir_path = get(handles.edit6,'String');

%get ready for Cw image to be on axes6
set(handles.uipanel5,'Visible','On');
set(handles.uipanel7,'Visible','Off');
set(handles.uipanel8,'Visible','Off');
set(handles.togglebutton_CW_Intensity,'Value',1);
set(handles.togglebutton_lifetime_image,'Value',0);
set(handles.togglebutton_amplitude_image,'Value',0);


srcno=[];delay=[];
%############# NEW way with mat files              ########################
%does a mat file exist for this fileprefix??
if isequal (exist ([dir_path(1:end-1),'/',fileprefix_curr,'_01.mat']), 2 )
    %there is a matfile.
    
    load ([dir_path(1:end-1),'/',fileprefix_curr,'_01.mat'], 'delay', 'srcno');
    %get date info
%     files=dir ([dir_path(1:end-1),'/',fileprefix_curr,'_01.mat']);
%     dd1=files.date;
    %added by anand 08/23/17
    %get date info from text file
    files_txt = dir ([dir_path(1:end-1),'/',fileprefix_curr,'.txt']);
   dd1=files_txt.date;
else
    
    %############# OLD way with bin files  sad sad sad ########################
    for ii = 1:length(handles.file_names) %traverse files, determine srcno and delay
        a=handles.file_names{ii};
        N = size(a,2);
        if ~isempty(a)
            fileprefix1{1} = a(1:N-17);
            if N>=3
                if a(N-2:N)=='IMX' | a(N-2:N)=='bin'
                    if strcmp(fileprefix1,fileprefix_curr)
                        srcno = [srcno,str2num(a(N-14:N-12))];
                        delay = [delay,str2num(a(N-10:N-6))];
                        dd1=handles.dates{ii};
                    end
                end
            end
        end
    end
    delay=unique(delay);
    srcno=unique(srcno);
    %############# OLD way with bin files  sad sad sad ########################
end %see if matfile.

if length(delay)>1
    delaystep=delay(2)-delay(1);
else
    delaystep=0;
end
set(handles.edit7, 'String',[num2str(srcno(1)),':',num2str(srcno(end))]);
set(handles.text32, 'String',dd1);
if delaystep~=0
    set(handles.edit8, 'String',[num2str(delay(1)),':',num2str(delaystep),':',num2str(delay(end))]);
else
    set(handles.edit8, 'String',num2str(delay(1)));
end



if get(handles.checkbox5,'Value')==1  %instant replay
    %_______just repeat whats in edit 8 callback
    dir_path = get(handles.edit6,'String');
    nn = find(dir_path == '*');
    dir_path = dir_path(1:nn-1);
    if ispc
        a = strrep([dir_path,'\',fileprefix_curr],'\','\\');
    else
        %     a = [dir_path fileprefix_curr];
        a = strrep([dir_path,'/',fileprefix_curr],'/','//');
    end
    axes(handles.axes1);
    
    System = get(handles.figure1,'Userdata');
    
    if isfield(System,'grayImage')
        if ~isempty(System.grayImage)
            System.CurrImage = plotRawImagenew(srcno,1,delay,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'),System.grayImage);
        else
            System.CurrImage = plotRawImagenew(srcno,1,delay,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
        end
    else
        System.CurrImage = plotRawImagenew(srcno,1,delay,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
    end
    set(handles.figure1,'Userdata',System);
    %_______________________
end  % instant replay

[m n] = caxis;
set(handles.Coloraxis1,'String', m);
set(handles.Coloraxis2,'String', n);

%Save CW image if Save toggle button is activated
if get(handles.saveMovie,'Value')==1 && strcmp(calling_fun, 'togglebutton_CW_Intensity_Callback') % check if save button is on and that this was called from togglebutton CW Intensity
%     if length(true_delay) > 1   % Check if data is time resolved
%         msgbox('This is a time resolved data. Select delay and save using "Show Delay" button');
%         return;
%     end
   [fileprefix, path, indx] = uiputfile({'*.tiff'; '*.fig'}, 'Save image');
   if fileprefix == 0     %Check if the user changed mind and didn't enter path/filename to save
       return;
   end
   Image_fileName = ([path,fileprefix]);
    top = 0; bottom = 0;
    left = 0; right = 0;
    spacing1 = 0; spacing2 = 0;
    ncol = 1; nrow = 1;
    cols = 60*4; rows = 40*4;
    ratio = cols/rows; % col to rows
    subplot1 = @(m,n,p) subtightplot (m, n, p, [spacing1 spacing2], [bottom top], [left right]);
    figure(100);
    set(figure(100), 'Position', [400 400 (1+(ncol-1)*spacing1)*(1+right+left)*500 (1+(nrow-1)*spacing2)*(1+bottom+top)*(500/(ratio * (ncol/nrow)))]);
    %figure(100), a = subplot1(1, 1, 1);
    imagesc(System.CurrImage); set(gca,'YDir','normal'); axis image; 
    caxis([c1 c2]);
    if get(handles.Jet_checkbox,'Value')==1
            colormap(jet);
        elseif get(handles.billsmap_checkbox,'Value')==1
            colormap(billsmap);
        else
            colormap(gray);
    end
    set(gcf, 'Color', 'white'); % white bckgr
    if indx == 1
    export_fig(gcf, ...       % figure handle
        sprintf('%s.tiff', Image_fileName(1:end-5)),... % name of output file without extension
        '-painters', ...      % renderer
        '-tiff', ...           % file format
        '-r300' );            % resolution in dpi
    close (figure(100));
    elseif indx == 2
    export_fig(gcf, ...       % figure handle
        sprintf('%s.fig', Image_fileName(1:end-4)),... % name of output file without extension
        '-painters', ...      % renderer
        '-fig', ...          % file format
        '-r300' );            % resolution in dpi
    close (figure(100));
    end
    

end



% dir_path = get(handles.edit6,'String');
% nn = find(dir_path == '*');
% dir_path = dir_path(1:nn-1)
% a = readimx([dir_path,'\',a]);
% axes(handles.axes6);
% imagesc(a.Data);axis image
% tpsf_image=a.Data;
% save tpsf_image
% h = get(gcf);set(h.Children(1),'YDir','Normal');axis image
% System.CurrImage = a.Data;
% tpsf_image=System.CurrImage;
% save tpsf_image;
% set(handles.figure1,'Userdata',System);
%
% px = str2num(get(handles.edit3,'String'));
% py =  str2num(get(handles.edit4,'String'));
% pxymax = size(a.Data);
% slider_step = 2/pxymax(1);
% set(handles.slider2,'sliderstep',[slider_step,slider_step],...
%     'max',pxymax(1),'min',1,'Value',px);
% slider_step = 2/pxymax(1);
% set(handles.slider3,'sliderstep',[slider_step,slider_step],...
%     'max',pxymax(2),'min',1,'Value',py);
%
% System.pointer =  text(px,py,'X');
% set(handles.figure1,'UserData',System);


%pixval on
% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

fileprefix = get(handles.edit9,'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    fileprefix = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    fileprefix = strrep([dir_path,'/',fileprefix],'/','//');
end


srcrange = str2num(get(handles.edit7,'String'));
dlyrange = str2num(get(handles.edit8,'String'));

npix = str2num(get(handles.edit10,'String'));
px = str2num(get(handles.edit3,'String'));
py = str2num(get(handles.edit4,'String'));

%System = get(handles.figure1,'UserData');
%axes(handles.axes6);
%set(System.pointer,'Position',[px-npix/2,py-npix/2, 1]);

axes(handles.axes2);
if get(handles.checkbox1,'value') == 1
    hold on
else
    hold off
end
CWD=pwd;
dir_path = get(handles.edit6,'String'); dir_path=dir_path(1:end-1);
cd(dir_path);
TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, get(handles.rebincheckbox,'Value'),...
    round([px py]),get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'), get(handles.checkbox1,'Value'));
cd(CWD);
%TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, [px py],get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'));
% save curr_tpsf dlyrange TPSF
%save data to handles
handles.TPSF =TPSF;
guidata(hObject,handles); %save the handles
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
fileprefix = get(handles.edit9,'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    fileprefix = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    fileprefix = strrep([dir_path,'/',fileprefix],'/','//');
end
srcrange = str2num(get(handles.edit7,'String'));
dlyrange = str2num(get(handles.edit8,'String'));

npix = str2num(get(handles.edit10,'String'));
px = str2num(get(handles.edit3,'String'));
py = str2num(get(handles.edit4,'String'));
axes(handles.axes2);
if get(handles.checkbox1,'value') == 1
    hold on
else
    hold off
end
CWD=pwd;
dir_path = get(handles.edit6,'String'); dir_path=dir_path(1:end-1);
cd(dir_path);

TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, get(handles.rebincheckbox,'Value'),...
    round([px py]),get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'), get(handles.checkbox1,'Value'));
cd(CWD);

%TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, [px py],get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'),get(handles.checkbox1,'value'));
% save curr_tpsf dlyrange TPSF
handles.TPSF =TPSF;
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

fileprefix = get(handles.edit9,'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    fileprefix = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    fileprefix = strrep([dir_path,'/',fileprefix],'/','//');
end
srcrange = str2num(get(handles.edit7,'String'));
dlyrange = str2num(get(handles.edit8,'String'));

npix = str2num(get(handles.edit10,'String'));
px = str2num(get(handles.edit3,'String'));
py = str2num(get(handles.edit4,'String'));
axes(handles.axes2);
if get(handles.checkbox1,'value') == 1
    hold on
else
    hold off
end
CWD=pwd;
dir_path = get(handles.edit6,'String'); dir_path=dir_path(1:end-1);
cd dir_path;
TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, [px py],get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'));
cd CWD;


% save curr_tpsf dlyrange TPSF
handles.TPSF =TPSF;
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if exist('TDrecondir_path') == 1
    %     'hehe'
    load TDrecondir_path;
    set(handles.edit6,'String',dir_path);
end
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

% contents = get(hObject,'String');
% a = contents{get(hObject,'Value')};
% N = size(a,2);
% fileprefix = a(1:N-17);
% set(handles.edit9,'String',fileprefix);
% % srcno = str2num(a(N-14:N-12));
% % delay = str2num(a(N-10:N-6));


dir_path = get(handles.edit6,'String');
%dir_path=uigetdir('d:\data','select the data directory');
% if dir_path(end)~='*' & dir_path(end-1)~='/'
%     dir_path=[dir_path,'\*'];
% end
set(handles.edit6,'String',dir_path);
%nn = find(dir_path == '*');
%dir_path = dir_path(1:nn);

%%% NEW way  (mat files) ##################################################
dir_struct = dir([dir_path(1:end-1), '/*.txt']);
%check to see if matfiles exist for thise text files.
if isequal (exist ([dir_path(1:end-1), '/',dir_struct(1).name(1:end-4),'_01.mat']), 2 )
    %there is a matfile.
    disp('matfile');
    
    [junk,sorted_index] = sortrows({dir_struct.date}');
    sorted_dates={dir_struct(sorted_index').date};
    sorted_names={dir_struct(sorted_index').name};
    
    fileprefix{1}={};
    date1{1}={};
    %fileprefix_old={}
    ll=1;
    DlyIndex(1).Dly=[];
    SrcIndex(1).Src=[];
    SrcIndex_old=[];
    DlyIndex_old=[];
    
    for ii = 1:length(sorted_names)
        a=sorted_names{ii};
        dd=sorted_dates{ii};
        N = size(a,2);
        if ~isempty(a)
            fileprefix1{1} = a(1:N-4);
            fileprefix_old=fileprefix1{1};
            if N>=3
                
                %             srcno = str2num(a(N-14:N-12));
                %             delay = str2num(a(N-10:N-6));
                if strcmp(fileprefix1,fileprefix_old)
                    fileprefix(ll)=fileprefix1;
                    date1{ll}=dd;
                    ll=ll+1;
                    %                DlyIndex(ll).Dly=delay; SrcIndex(ll).Src=srcno;
                end
                
            end
        end
    end
    
    [handles.fileprefix,III]=unique_no_sort(fileprefix);
    handles.dates=sorted_dates;
    handles.file_names = sorted_names;
    handles.is_dir = [dir_struct.isdir];
    handles.sorted_index = [sorted_index];
    guidata(handles.figure1,handles);
    set(handles.listbox1,'String',handles.fileprefix,...
        'Value',1)
    % set(handles.listbox5,'String',handles.fileprefix,...
    %     'Value',1)
    set(handles.popupmenu2,'String',handles.fileprefix,...
        'Value',1)
    % save TDrecondir_path dir_path
    
else
    %%% OLD way  (keep) ######################################################
    disp('binfile');
    
    dir_struct = dir([dir_path]);
    [junk,sorted_index] = sortrows({dir_struct.date}');
    sorted_dates={dir_struct(sorted_index').date};
    sorted_names={dir_struct(sorted_index').name};
    
    fileprefix{1}={};
    date1{1}={};
    %fileprefix_old={}
    ll=1;
    DlyIndex(1).Dly=[];
    SrcIndex(1).Src=[];
    SrcIndex_old=[];
    DlyIndex_old=[];
    
    for ii = 1:length(sorted_names)
        a=sorted_names{ii};
        dd=sorted_dates{ii};
        N = size(a,2);
        if ~isempty(a)
            fileprefix1{1} = a(1:N-17);
            fileprefix_old=fileprefix1{1};
            if N>=3
                if a(N-2:N)=='IMX' | a(N-2:N)== 'bin'
                    %             srcno = str2num(a(N-14:N-12));
                    %             delay = str2num(a(N-10:N-6));
                    if strcmp(fileprefix1,fileprefix_old)
                        fileprefix(ll)=fileprefix1;
                        date1{ll}=dd;
                        ll=ll+1;
                        %                DlyIndex(ll).Dly=delay; SrcIndex(ll).Src=srcno;
                    end
                end
            end
        end
    end
    
    [handles.fileprefix,III]=unique_no_sort(fileprefix);
    handles.dates=sorted_dates;
    handles.file_names = sorted_names;
    handles.is_dir = [dir_struct.isdir];
    handles.sorted_index = [sorted_index];
    guidata(handles.figure1,handles);
    set(handles.listbox1,'String',handles.fileprefix,...
        'Value',1)
    % set(handles.listbox5,'String',handles.fileprefix,...
    %     'Value',1)
    set(handles.popupmenu2,'String',handles.fileprefix,...
        'Value',1)
    % save TDrecondir_path dir_path
    
end

function axes6_CreateFcn(hObject, eventdata, handles)
%handles.axes6.pointer = text(0,0,'X');




% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
fileprefix = get(handles.edit9,'String');
% dlyrange = str2num(get(hObject,'String'));
dlyrange = str2num(get(handles.edit8,'String'));
srcrange = str2num(get(handles.edit7,'String'));
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);

if ispc
    a = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    a = strrep([dir_path,'/',fileprefix],'/','//');
end

axes(handles.axes1);;

System = get(handles.figure1,'Userdata');

if isfield(System,'grayImage')
    if ~isempty(System.grayImage)
        System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'),System.grayImage);
    else
        System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
    end
else
    System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
end

%System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[]);
set(handles.figure1,'Userdata',System);

% % % 
% % % function edit7_Callback(hObject, eventdata, handles)
% % % % hObject    handle to edit7 (see GCBO)
% % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % handles    structure with handles and user data (see GUIDATA)
% % % 
% % % % Hints: get(hObject,'String') returns contents of edit7 as text
% % % %        str2double(get(hObject,'String')) returns contents of edit7 as a double
% % % fileprefix = get(handles.edit9,'String');
% % % srcrange = str2num(get(hObject,'String'));
% % % dlyrange = str2num(get(handles.edit8,'String'));
% % % 
% % % System = get(handles.figure1,'Userdata');
% % % dir_path = get(handles.edit6,'String');
% % % nn = find(dir_path == '*');
% % % dir_path = dir_path(1:nn-1);
% % % if ispc
% % %     a = strrep([dir_path,'\',fileprefix],'\','\\');
% % % else %isunix
% % %     a = strrep([dir_path,'/',fileprefix],'/','//');
% % % end
% % % 
% % % axes(handles.axes6);
% % % 
% % % if isfield(System,'grayImage')
% % %     if ~isempty(System.grayImage)
% % %         System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'),System.grayImage);
% % %     else
% % %         System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
% % %     end
% % % else
% % %     System.CurrImage =     plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
% % % 
% % % %     System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
% % % end
% % % % set(handles.figure1,'Userdata',System);
% % % set(handles.figure1,'Userdata',System);
% % % 
% % % % handles.figure1.Name='CW intensity';
% % % tpsf_image=System.CurrImage;
% % % % refresh;
% % % % figure1;
% % % % figure;
% % % set(handles.figure1,'Userdata',System);
% % % imagesc(System.CurrImage);
% % % axis image;
% % % a=1;
% % % a2=1;
%  refresh;
 
% save tpsf_image;
% set(handles.figure1,'Userdata',System);


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
fileprefix = get(handles.edit9,'String');
dlyrange = str2num(get(hObject,'String'));
srcrange = str2num(get(handles.edit7,'String'));
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);

if ispc
    a = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    a = strrep([dir_path,'/',fileprefix],'/','//');
end

axes(handles.axes6);;

System = get(handles.figure1,'Userdata');

if isfield(System,'grayImage')
    if ~isempty(System.grayImage)
        System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'),System.grayImage);
    else
        System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
    end
else
    System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
end

%System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[]);
set(handles.figure1,'Userdata',System);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

fileprefix = get(handles.edit9,'String');
dlyrange = str2num(get(handles.edit8,'String'));
srcrange = str2num(get(handles.edit7,'String'));
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    a = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    a = strrep([dir_path,'/',fileprefix],'/','//');
end

axes(handles.axes6);

%plotRawImagenew(srcrange,1,dlyrange,a,[]);
if isfield(System,'grayImage')
    if ~isempty(System.grayImage)
        System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'),System.grayImage);
    else
        System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
    end
else
    System.CurrImage = plotRawImagenew(srcrange,1,dlyrange,a,[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));refresh
end

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double

fileprefix = get(handles.edit9,'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    fileprefix = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    fileprefix = strrep([dir_path,'/',fileprefix],'/','//');
end



srcrange = str2num(get(handles.edit7,'String'));
dlyrange = str2num(get(handles.edit8,'String'));

npix = str2num(get(handles.edit10,'String'));
px = str2num(get(handles.edit3,'String'));
py = str2num(get(handles.edit4,'String'));
axes(handles.axes2);
if get(handles.checkbox1,'value') == 1
    hold on
else
    hold off
end
CWD=pwd;
dir_path = get(handles.edit6,'String'); dir_path=dir_path(1:end-1);
cd(dir_path);

%TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, [px py],get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'));

TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, get(handles.rebincheckbox,'Value'),...
    round([px py]),get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'), get(handles.checkbox1,'Value'));

cd (CWD);
% save curr_tpsf dlyrange TPSF
handles.TPSF =TPSF;
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
[px py] = (ginput(1));

fileprefix = get(handles.edit9,'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    fileprefix = strrep([dir_path,'\',fileprefix],'\','\\');
else %isunix
    fileprefix = strrep([dir_path,'/',fileprefix],'/','//');
end
srcrange = str2num(get(handles.edit7,'String'));
dlyrange = str2num(get(handles.edit8,'String'));

npix = str2num(get(handles.edit10,'String'));
axes(handles.axes2);
if get(handles.checkbox1,'value') == 1
    hold on
else
    hold off
end
CWD=pwd;
dir_path = get(handles.edit6,'String'); dir_path=dir_path(1:end-1);
cd (dir_path);
TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, get(handles.rebincheckbox,'Value'),...
    round([px py]),get(handles.checkbox2,'Value'),get(handles.checkbox3,'Value'), get(handles.checkbox1,'Value'));
cd (CWD);
% disp(sprintf('CW:%1.3e',sum(TPSF)*1e-12*(dlyrange(2)-dlyrange(1))))
% save curr_tpsf dlyrange TPSF
set(handles.edit3,'String',num2str(round(px)));
set(handles.edit4,'String',num2str(round(py)));
% set(handles.slider2,'Value',round(px));
% set(handles.slider3,'Value',round(py));

xlabel(handles.axes2,'Time (ns)');
ylabel(handles.axes2,'Counts (a.u.)');

handles.TPSF =TPSF;
handles.dlyrange = dlyrange;
assignin('base', 'TPSF', TPSF);
assignin('base', 'TPSF_dlyrange', dlyrange);
guidata(hObject,handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Medium.idxRefr = str2num(get(handles.edit11,'String'));
Medium.Muao=str2num(get(handles.edit12,'String'));
Medium.Muso=str2num(get(handles.edit13,'String'));
Medium.g= str2num(get(handles.edit15,'String'));
Medium.Muspo = Medium.Muso *(1-Medium.g);set(handles.edit16,'String',num2str(Medium.Muspo));
Medium.v= 2.9979*1e10/Medium.idxRefr; set(handles.edit17,'String',sprintf('%1.1e',(Medium.v)));
Medium.Geometry= 'slab';
MediumSlab_Thickness=str2num(get(handles.edit18,'String'));

Medium.CompVol.XStep = str2num(get(handles.edit20,'String'));
Medium.CompVol.YStep = str2num(get(handles.edit23,'String'));
Medium.CompVol.ZStep = str2num(get(handles.edit26,'String'));

Xstart = str2num(get(handles.edit19,'String'));
Xend = str2num(get(handles.edit21,'String'));
Ystart = str2num(get(handles.edit22,'String'));
Yend = str2num(get(handles.edit24,'String'));
Zstart = str2num(get(handles.edit25,'String'));
Zend = str2num(get(handles.edit27,'String'));

Medium.CompVol.X = Xstart:Medium.CompVol.XStep:Xend
Medium.CompVol.Y = Ystart:Medium.CompVol.YStep:Yend;
Medium.CompVol.Z = Zstart:Medium.CompVol.ZStep:Zend;

Medium.Object= {};

System.Medium = Medium;
set(handles.figure1,'Userdata',System);



% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
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
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% fileprefix = get(handles.edit9,'String');
% dir_path = get(handles.edit6,'String');
% nn = find(dir_path == '*');
% dir_path = dir_path(1:nn-1);
% fileprefix = strrep([dir_path,'\',fileprefix],'\','\\');
% srcrange = str2num(get(handles.edit7,'String'));
% dlyrange = str2num(get(handles.edit8,'String'));
%
% npix = (get(handles.slider1,'Value'));
% set(handles.edit10,'String',num2str(npix));
% px = str2num(get(handles.edit3,'String'));
% py = str2num(get(handles.edit4,'String'));
% axes(handles.axes2);
% if get(handles.checkbox1,'value') == 1
%     hold on
% else
%     hold off
% end
%
% TPSF = plotTPSFdata(fileprefix, srcrange(1), dlyrange, npix, [px py],get(handles.checkbox2,'value'),get(handles.checkbox3,'Value'));
% save curr_tpsf dlyrange TPSF
handles.TPSF =TPSF;
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
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
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


px = round(get(handles.slider2,'Value'));

set(handles.edit3,'String',num2str(px));

edit3_Callback(handles.edit3, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
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
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

py = round(get(handles.slider3,'Value'));

set(handles.edit4,'String',num2str(py));

edit4_Callback(handles.edit4, eventdata, handles);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
if get(handles.checkbox3,'Value')==1
    set(handles.axes2,'YScale','Log');
else
    set(handles.axes2,'YScale','Linear')
end


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


System = get(handles.figure1,'UserData');

pxstart = str2num(get(handles.edit28,'String'));
pxstep = str2num(get(handles.edit30,'String'));
pxNstep = str2num(get(handles.edit32,'String'));

pystart = str2num(get(handles.edit29,'String'));
pystep = str2num(get(handles.edit31,'String'));
pyNstep = str2num(get(handles.edit33,'String'));
axes(handles.axes6);
ll = 0;
get(handles.axes6)
if isfield(System,'CurrImage')
    imagesc(System.CurrImage);axis image
    tpsf_image=System.CurrImage;
    %     save tpsf_image;
    h = get(gcf);set(h.Children(1),'YDir','Normal');
end

for ii = 1:pxNstep
    for jj = 1:pyNstep
        ll = ll + 1;
        DetPosPix(ll,1) = pxstart + pxstep*ii;
        DetPosPix(ll,2) = pystart + pystep*jj;
        text(DetPosPix(ll,1),DetPosPix(ll,2),'o');
    end
end

System.Optodes.DetPosPix = DetPosPix;
set(handles.figure1,'Userdata',System);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2);
title('select the start and end points')
taufit1
axes(handles.axes2);
hold on
title([num2str(1e-3*tau),' ns'])
if get(handles.checkbox3,'Value')==1
    plot(1e-12*dlyrange1,p(1)*dlyrange1+p(2),'r');
else
    plot(1e-12*dlyrange1,exp(p(1)*dlyrange1+p(2)),'r');
end




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

curr_dir=get(handles.edit6,'String');
if ~isempty(curr_dir)
    if curr_dir(end)=='*'
        curr_dir=curr_dir(1:end-1);
    end
    [getdir]=uigetdir(curr_dir);
else
    [getdir]=uigetdir(curr_dir);
    %     if isunix
    %        [getdir]=uigetdir('/autofs/space/dpdw_007/users/rice');
    %     else
    %     [getdir]=uigetdir('C:\Users\wrice\Documents\Data');
    %     end
end
if getdir~=0
    
    if ispc
        set(handles.edit6,'String',[getdir,'\*']);
    else
        set(handles.edit6,'String',[getdir,'/*']);
    end
    edit6_Callback(hObject, eventdata, handles)
end



% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4

% --- Outputs from this function are returned to the command line.

%*********************************************************88
% THis section of code is really old and outdated


System = get(handles.figure1,'Userdata');
if get(hObject,'Value') == 1;
    % contents = get(handles.listbox5,'String');
    contents = get(handles.popupmenu2,'String');
    grayfileprefix = contents{get(handles.popupmenu2,'Value')};
    %      grayfileprefix = contents{get(handles.listbox5,'Value')};
    fileprefix_curr = contents{get(handles.listbox1,'Value')};
    for ii = 1:length(handles.file_names)
        a=handles.file_names{ii};
        N = size(a,2);
        if ~isempty(a)
            if N>=3
                if a(N-2:N)=='IMX'
                    fileprefix1 = a(1:N-17);
                    if strcmp(fileprefix1,grayfileprefix)==1
                        srcno = str2num(a(N-14:N-12));
                        delay = str2num(a(N-10:N-6));break
                    end
                end
            end
        end
    end
    
    dir_path = get(handles.edit6,'String');
    nn = find(dir_path == '*');
    dir_path = dir_path(1:nn-1);
    
    %only good for one image
    srcno=0;
    delay=4800;
    % *********
    
    if ispc
        grayfilename = sprintf([strrep(dir_path,'\','\\'),grayfileprefix,'_s%03d_%05dps.IMX'],round(srcno),round(delay));
    else
        grayfilename = sprintf([strrep(dir_path,'/','//'),grayfileprefix,'_s%03d_%05dps.bin'],round(srcno),round(delay));
    end
    
    
    
    %333333333333333333333333333333333333333333333333333333333333333333
    %          Enable gray backgorund for mat files.
    
    fileprefix = sprintf([strrep(dir_path,'\','//'),grayfileprefix]);
    if isequal (exist ([fileprefix,'_01.mat']), 2 ) %there is a matfile.
        
        filename1 = sprintf([fileprefix,'_%02d.mat'], 1);
        details = whos('-file', filename1', 'Image_matrix');
        num_sources_included=details.size(1); % tells us how many sources are in this matfile
        
        
        %most of the time we will only open a single mat file.
        first_time=1;
        for src_pos = srcno %is ths the right syntax ################################
            
            if isequal (src_pos, 0) %then there is only one image, usually a "freespace"
                filename1 = sprintf([fileprefix,'_%02d.mat'], 1);
                load (filename1, 'Image_matrix');
                load (filename1, 'delay'); %delay is a vector
                mat_file_to_open=0; %so the m
            else
                % which mat file is this source in?
                
                % if its the same one, dont open it again...
                if first_time
                    mat_file_to_open=0;
                end
                
                
                %for each source, load the correct mat file
                if ~isequal(mat_file_to_open, ceil(src_pos/ num_sources_included))
                    mat_file_to_open = ceil( src_pos/ num_sources_included );
                    filename1 = sprintf([fileprefix,'_%02d.mat'], mat_file_to_open);
                    load (filename1, 'Image_matrix');
                    load (filename1, 'delay'); %delay is a vector
                end
            end
            % for delay = delay1 %for loop non needed
            %correction for this callback only  (grayscale background)
            dlyrange=delay;
            
            [tf, loc]=ismember (dlyrange, delay); %loc are the indecies of dealy where you find the values of delay1
            
            for kk=1:size(loc,2) %sum up each image for each delay range
                
                if isequal( first_time,1)
                    first_time=0;
                    image1= squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                    if size(image1,1)==1024 & rebinflag==1
                        image1 = imresize(readbin(filename1),1/4) ;
                    end
                    grayImage=image1;
                    image2=zeros(size(image1,1),size(image1,2),length(dlyrange));
                else
                    image1=squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                    if size(image1,1)==1024 & rebinflag==1
                        image1 = imresize(readbin(filename1),1/4) ;
                    end
                    image2(:,:,kk)=  image2(:,:,kk)+double(image1);
                    %                 grayImage=squeeze(sum(image2,3));
                end
            end
        end
        if kk > 1
            grayImage=squeeze(sum(image2,3));
        end
        %      clear image2;
    else
        
        grayImage=readbin(grayfilename);
    end
    %     grayImage=readimx(grayfilename);
    System.grayImage=double(grayImage);
    if ispc
        System.CurrImage = plotRawImagenew(srcno,1,delay,[strrep(grayfilename(1:end-17),'\','//')],[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'),System.grayImage);
        
    else
        System.CurrImage = plotRawImagenew(srcno,1,delay,[strrep(grayfilename(1:end-17),'/','//')],[],handles.axes6,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'),System.grayImage);
        
    end
    
    
else
    System.grayImage=[];
    axes(handles.axes6);
    if isfield(System,'CurrImage'),
        imagesc(System.CurrImage);axis image;set(gca,'YDir','Normal')
    end
end
set(handles.figure1,'Userdata',System);



% set(handles.edit9,'String',fileprefix_curr);
%
% srcno=[];delay=[];
% for ii = 3:length(handles.file_names)
%     a=handles.file_names{ii};
%     N = size(a,2);
%     if ~isempty(a)
%         fileprefix1{1} = a(1:N-17);
%         if a(N-2:N)=='IMX'
%             if strcmp(fileprefix1,fileprefix_curr)
%                 srcno = [srcno,str2num(a(N-14:N-12))];
%                 delay = [delay,str2num(a(N-10:N-6))];
%             end
%         end
%     end
% end
% delay=unique(delay);
% srcno=unique(srcno);
% if length(delay)>1
%     delaystep=delay(2)-delay(1);
% else
%     delaystep=0;
% end
% set(handles.edit7, 'String',[num2str(srcno(1)),':',num2str(srcno(end))]);
%
% if delaystep~=0
%     set(handles.edit8, 'String',[num2str(delay(1)),':',num2str(delaystep),':',num2str(delay(end))]);
% else
%     set(handles.edit8, 'String',num2str(delay(1)));
% end
% %_______just repeat whats in edit 8 callback
%

% axes(handles.axes6);;
%
% System = get(handles.figure1,'Userdata');
% System.CurrImage = plotRawImagenew(srcno,1,delay,a,[]);
% set(handles.figure1,'Userdata',System);
%
%
%


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uiputfile;
System = get(handles.figure1,'Userdata');
imwrite(System.CurrImage,[pathname,filename],'jpg');


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes2);
title('select the start and end points')

% load curr_tpsf.mat
dlyrange=str2num (get (handles.edit8, 'string'));
TPSF=handles.TPSF;

dlystep=dlyrange(2)-dlyrange(1);
disp('select range using two button clicks')

junk=ginput(2);
begindly=1e12*junk(1,1);
enddly=1e12*junk(2,1);

for ii = 1:length(dlyrange)
    if dlyrange(ii)>begindly
        startind=ii;
        dlystart1=dlyrange(ii);
        break
    end
end

for ii = 1:length(dlyrange)
    if dlyrange(ii)>enddly
        endind=ii;
        dlyend1=dlyrange(ii);
        break
    end
end


dlyrange1=dlystart1:dlystep:dlyend1;
data11=(TPSF(startind:endind));
m1=max(data11);

%__to incorporate forward convolution - Anand 08/07/2013, bill for multiexp
%june2014
t0 = get(handles.edit34,'String');
if strcmp(t0, 'irf')
    if isfield(handles,'irf')
        %         multiexpfit_conv(dlyrange*1e-3,startind:endind,data11/m1,handles.irf,handles.irf_dly);
        
        xfit= fminsearchbnd('NLfit1_conv',[data11(end)/m1, 1, 1, 1, 1],[0, 0, 0, 0, 0],[], [],...
            dlyrange*1e-3, startind:endind, data11/m1, handles.irf, handles.irf_dly);
        % this does not work!!!!
        
        %
        %           fminsearch('NLfit1_conv',[data11(end), 1, .5], [],...
        %             dlyrange*1e-3, startind:endind, data11, handles.irf, handles.irf_dly);
        %
        
        %         [x,fval,exitflag,output] = fminsearchbnd(fun,x0,LB,UB,options,varargin)
    else
        msgbox('No IRF found, first save irf, or choose numeric t0')
    end
else
    t0 = str2num(t0);
    multiexpfit(dlyrange1*1e-3 ,data11/m1,t0);
end
%____to incorporate forward convolution - Anand 08/07/2013




global FitResults

a0=FitResults.x(1)*m1;
a1=FitResults.x(2)*m1;
tau1=FitResults.x(3);
a2 =FitResults.x(4)*m1;
tau2=FitResults.x(5);
%t0=FitResults.x(6);

FitParams.startind=startind;
FitParams.endind=endind;
FitResults.FitParams=FitParams;


set(handles.edit34,'String',t0)
axes(handles.axes2);
hold on
%string1=get(handles.edit35,'String')
set(handles.edit35,'String',[sprintf('Fit Results\n a0=%1.2e\n a1=%1.2e\n t1= %2.2f ns\n a2 = %1.2e\n t2 = %2.2f ns',a0,a1,tau1,a2,tau2)]);
if(get(handles.checkbox2,'Value'))==0
    plot(dlyrange1*1e-12,log(m1*FitResults.Phi0),'r');
else
    plot(dlyrange1*1e-12,log(FitResults.Phi0),'r');
end
set (handles.AF_lifetime1,'String',tau1);
set (handles.AF_lifetime2,'String',tau2);
set (handles.amplitude1,'String',a1);
set (handles.amplitude2,'String',a2);

% load curr_tpsf
% Data.t=dlyrange*1e-3;Data.y=TPSF;
% filename1=get(handles.edit34,'String');
% fid=fopen(filename1,'w');
% fprintf(fid,'%e\t%e\n',[Data.t;Data.y]);
% fclose(fid);

function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% hold on
% title([num2str(1e-3*tau),' ns'])
% if get(handles.checkbox3,'Value')==1
%     plot(1e-12*dlyrange1,p(1)*dlyrange1+p(2),'r');
% else
%     plot(1e-12*dlyrange1,exp(p(1)*dlyrange1+p(2)),'r');
% end


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%for some reason getting variables from handels was missing
tic
bin = str2num(get(handles.edit10,'String'));
dlyrange = str2num(get(handles.edit8,'String'));
t0 = str2num(get(handles.edit34,'String'));

axes(handles.axes2);
title('select the start and end points')

% load curr_tpsf.mat
dlyrange=str2num (get (handles.edit8, 'string'));
TPSF=handles.TPSF;
dlystep=dlyrange(2)-dlyrange(1);

if get(handles.autorange,'Value')==0
    
    
    disp('select range using two button clicks')
    junk=ginput(2);
    begindly=1e12*junk(1,1);
    enddly=1e12*junk(2,1);
    
    for ii = 1:length(dlyrange)
        if dlyrange(ii)>begindly
            startind=ii;
            dlystart1=dlyrange(ii);
            break
        end
    end
    
    for ii = 1:length(dlyrange)
        if dlyrange(ii)>enddly
            endind=ii;
            dlyend1=dlyrange(ii);
            break
        end
    end
    
else
    startind = find(TPSF == max(TPSF));
    endind = length(dlyrange);
end


dlyrange1=(dlyrange(startind:endind));
data11=(TPSF(startind:endind));

t0=str2num(get(handles.edit34,'String'));
% dlyrange1=dlystart1:dlystep:dlyend1; %commented out bill sept 2013


m1=max(data11);

data11=data11/m1;%seems to be in my version ,so added it-Anand 08/07/2013

%__to incorporate forward convolution - Anand 08/07/2013
%oneexpfit(dlyrange1*1e-3 ,data11/m1,t0);%this is the old way, just calls NLfit1 anyways
t0 = get(handles.edit34,'String');
if strcmp(t0, 'irf')
    if isfield(handles,'irf')
        fminsearch('NLfit1_conv',[data11(end), 1, .5], [],...
            dlyrange*1e-3, startind:endind, data11, handles.irf, handles.irf_dly);
    else
        msgbox('No IRF found, first save irf, or choose numeric t0')
    end
else
    t0 = str2num(t0);
    fminsearch('NLfit1',[data11(end), 1, 1], [], dlyrange1*1e-3 - t0, data11);
    %    oneexpfit(dlyrange1*1e-3 ,data11/m1,t0);
end
%____to incorporate forward convolution - Anand 08/07/2013

global FitResults

a0=FitResults.x(1)*m1;
a1=FitResults.x(2)*m1;
tau1=FitResults.x(3);
%t0=FitResults.x(4);
set(handles.edit34,'String',t0)
axes(handles.axes2);
hold on
%string1=get(handles.edit35,'String')
set(handles.edit35,'String',[sprintf('Fit Results\n a0=%1.2e\n a1=%1.2e\n t1= %2.2f ns\n ',a0,a1,tau1)]);

if(get(handles.checkbox2,'Value'))==0
    plot(dlyrange1*1e-12,log(m1*FitResults.Phi0),'r');
else
    plot(dlyrange1*1e-12,log(FitResults.Phi0),'r');
end

FitParams.startind=startind;
FitParams.endind=endind;
FitResults.FitParams=FitParams;
toc


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function thres_Callback(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres as text
%        str2double(get(hObject,'String')) returns contents of thres as a double


% --- Executes during object creation, after setting all properties.
function thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in lifetimemap.
function lifetimemap_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimemap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
srcno = str2num(get(handles.edit7,'String'));
bin = str2num(get(handles.edit10,'String'));

dlyrange = str2num(get(handles.edit8,'String'));
t0 = str2num(get(handles.edit34,'String'));
threshold=str2num(get(handles.thres,'String'));
fileprefix_curr=get(handles.edit9,'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    fileprefix = strrep([dir_path, fileprefix_curr], '\', '\\');
else
    fileprefix = strrep([dir_path, fileprefix_curr], '/', '//');
end
global FitResults
dlyfitrange=FitResults.FitParams.startind:FitResults.FitParams.endind;
% dlyfitrange=(dlyrange(FitResults.FitParams.startind:FitResults.FitParams.endind));

rebinflag=get(handles.rebincheckbox,'value');

%get ready for Lifetime image to be on axes6 of uipanel7
set(handles.uipanel5,'Visible','Off');
set(handles.uipanel7,'Visible','On');
set(handles.uipanel8,'Visible','Off');
set(handles.togglebutton_CW_Intensity,'Value',0);
set(handles.togglebutton_lifetime_image,'Value',1);
set(handles.togglebutton_amplitude_image,'Value',0);

axes(handles.axes6);


%_load data_____________
%###################  NEW with mat file ##################################
% dont forget that this will traverse both sources and detectors.

if isequal (exist ([fileprefix,'_01.mat']), 2 ) %there is a matfile.
    
    filename1 = sprintf([fileprefix,'_%02d.mat'], 1);
    details = whos('-file', filename1', 'Image_matrix');
    num_sources_included=details.size(1); % tells us how many sources are in this matfile
    
    
    %most of the time we will only open a single mat file.
    first_time=1;
    for src_pos = srcno %is ths the right syntax ################################
        
        if isequal (src_pos, 0) %then there is only one image, usually a "freespace"
            filename1 = sprintf([fileprefix,'_%02d.mat'], 1);
            load (filename1, 'Image_matrix');
            load (filename1, 'delay'); %delay is a vector
            mat_file_to_open=0; %so the m
        else
            % which mat file is this source in?
            
            % if its the same one, dont open it again...
            if first_time
                mat_file_to_open=0;
            end
            
            
            %for each source, load the correct mat file
            if ~isequal(mat_file_to_open, ceil(src_pos/ num_sources_included))
                mat_file_to_open = ceil( src_pos/ num_sources_included );
                filename1 = sprintf([fileprefix,'_%02d.mat'], mat_file_to_open);
                load (filename1, 'Image_matrix');
                load (filename1, 'delay'); %delay is a vector
            end
        end
        % for delay = delay1 %for loop non needed
        
        [tf, loc]=ismember (dlyrange, delay); %loc are the indecies of dealy where you find the values of delay1
        
        for kk=1:size(loc,2) %sum up each image for each delay range
            
            if isequal( first_time,1)
                first_time=0;
                image1= squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                if size(image1,1)==1024 & rebinflag==1
                    image1 = imresize(readbin(filename1),1/4) ;
                end
                image2=zeros(size(image1,1),size(image1,2),length(dlyrange));
            else
                image1=squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                if size(image1,1)==1024 & rebinflag==1
                    image1 = imresize(readbin(filename1),1/4) ;
                end
                image2(:,:,kk)=  image2(:,:,kk)+double(image1);
            end
        end
    end
else
    
    % ################  OLD way ##############################################
    
    
    
    filename1 = sprintf([fileprefix,'_s%03d_%05dps.bin'], round(srcno(1)), round(dlyrange(1)));
    image1 = readbin(filename1);
    if size(image1,1)==1024 & rebinflag==1
        image1 = imresize(readbin(filename1),1/4) ;
    end
    image2=zeros(size(image1,1),size(image1,2),length(dlyrange));
    for ii = 1:length(dlyrange)
        % disp(ii),pause(.00001)
        for jj = 1:length(srcno)
            filename1 = sprintf([fileprefix,'_s%03d_%05dps.bin'], round(srcno(jj)), round(dlyrange(ii)));
            image1 = readbin(filename1);
            if size(image1,1)==1024 & rebinflag==1
                image1 = imresize(readbin(filename1),1/4) ;
            end
            image2(:,:,ii)=  image2(:,:,ii)+double(image1);
        end
    end
    
end




%select ROI
if get(handles.selectROI,'Value')==1;
    image2CW=sum(image2,3);
    %if user has not entered a set of labels, set the number of ROI to
    %1
    if  (strcmp('Label', get(handles.ROIlabel,'String')))
        ROI_suff=1;
        nROI=1;
    else
        ROI_suff=str2num(get(handles.ROIlabel,'String'));
        nROI = length(ROI_suff);
    end
    if isempty(handles.BW)
        %         figure(124);
        imagesc(image2CW);set(gca,'YDir','Normal');
        %axis image;
        for ii = 1:nROI
            BW(ii,:,:)=roipoly;
        end
        %         close(124)
        handles.BW=BW;
        guidata(handles.figure1,handles);
    else
        BW=handles.BW;
    end
    
    for ll = 1:nROI
        BW1=squeeze(BW(ll,:,:));
        for ii=1:length(dlyrange)
            image3(:,:,ii) =  image2(:,:,ii).*BW1;
        end
        %[MI,MJ]=ind2sub(size(BW1), find(BW1));
        %image3 = image2(min(MI):max(MI),min(MJ):max(MJ),:);
        if get(handles.biexpcheckbox,'Value')==0;
            if get(handles.checkmulticore,'Value')==1;
                if strcmp(get(handles.edit34,'String'), 'irf')
                    [map1] = lifetimemap_par(image3, dlyrange, threshold, bin, get(handles.edit34,'String'),dlyfitrange,rebinflag,handles.irf, handles.irf_dly);
                else
                    [map1] = lifetimemap_par(image3, dlyrange, threshold, bin, t0,dlyfitrange,rebinflag);
                end
            else
                if strcmp(get(handles.edit34,'String'), 'irf')
                    [map1] = lifetimemap(image3, dlyrange, threshold, bin, get(handles.edit34,'String'),dlyfitrange,rebinflag, handles.irf, handles.irf_dly);
                else
                    [map1] = lifetimemap(image3, dlyrange, threshold, bin, str2num(get(handles.edit34,'String')),dlyfitrange,rebinflag);
                end
            end
            %             figure(333);
            imagesc(map1.lmap);
            %axis image;
        else
            [map1] = lifetimemap2exp(image3, dlyrange, threshold, bin, t0,dlyfitrange,rebinflag);
        end
        assignin('base',['OMI_',fileprefix_curr,'_',num2str(ROI_suff(ll))],map1);
    end
else
    if get(handles.biexpcheckbox,'Value')==0;
        tic
        if get(handles.checkmulticore,'Value')==1;
            [map1] = lifetimemap_par(image2, dlyrange, threshold, bin, t0,dlyfitrange,rebinflag);
        else  
            [map1] = lifetimemap(image2, dlyrange, threshold, bin, t0,dlyfitrange,rebinflag);
            %  [map1] = lifetimemap_bill2015(image2, dlyrange, threshold, bin, t0,dlyfitrange,rebinflag);
        end
        %         figure(333);
        imagesc(map1.lmap);
        %axis image;
        toc
    else
        [map1] = lifetimemap2exp(image2, dlyrange, threshold, bin, t0,dlyfitrange,rebinflag);
    end
    assignin('base',fileprefix_curr,map1);
    
% add CW and lmap to Load Analysis listbox
list = get(handles.listbox6,'String');
new_ImCW = [fileprefix_curr, '_ImCW'];
new_lmap = [fileprefix_curr, '_lmap'];
if any(strcmp(list, new_ImCW)) && any(strcmp(list, new_lmap)) % check if analysis already exists
%     index_CW = find(contains(list, new_ImCW));
%     index_lmap = find(contains(list, new_lmap));
%     list(index_CW) = cellstr(new_ImCW);
%     list(index_lmap) = cellstr(new_lmap);
    set(handles.listbox6,'string',list);
else   
    list{end+1} = new_ImCW;
    list{end+1} = new_lmap;
    set(handles.listbox6,'string',list);
end
%%%%%%%%%%%%%%
end
set(gca,'YDir','normal');
colorbar;

% --- Executes on button press in amplitudeMap.
function amplitudeMap_Callback(hObject, eventdata, handles)
% hObject    handle to amplitudeMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
srcno = str2num(get(handles.edit7,'String'));
bin = str2num(get(handles.edit10,'String'));
dlyrange = str2num(get(handles.edit8,'String'));
t0 = str2num(get(handles.edit34,'String'))*1000;
thres=str2num(get(handles.thres,'String'));
fileprefixF=get(handles.edit9,'String');
fileprefixX=get(handles.excitationdata,'String');

tau1=str2num(get(handles.lifetime1,'String'))*1000;
tau2=str2num(get(handles.lifetime2,'String'))*1000;
tau3=str2num(get(handles.lifetime3,'String'))*1000;
tau4=str2num(get(handles.AF_lifetime1,'String'))*1000;
tau5=str2num(get(handles.AF_lifetime2,'String'))*1000;

%get ready for Lifetime image to be on axes7 of uipanel8
set(handles.uipanel5,'Visible','Off');
set(handles.uipanel7,'Visible','Off');
set(handles.uipanel8,'Visible','On');
set(handles.togglebutton_CW_Intensity,'Value',0);
set(handles.togglebutton_lifetime_image,'Value',0);
set(handles.togglebutton_amplitude_image,'Value',1);

axes(handles.axes7); axis image; axis off;

dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    a = strrep([dir_path, fileprefixX], '\', '\\');
    b = strrep([dir_path, fileprefixF], '\', '\\');
else
    a = strrep([dir_path, fileprefixX], '/', '//');
    b = strrep([dir_path, fileprefixF], '/', '//');
end

if get(handles.normalizecheckbox,'Value')==1
    normflag=1;
else
    normflag=0;
end

global FitResults
dlyfitrange=FitResults.FitParams.startind:FitResults.FitParams.endind;
dlyrange1=dlyrange(dlyfitrange);

if strcmp(get(handles.edit34,'String'), 'irf')
    if isfield(handles,'irf')
        %########   Create basis functions convolved with IRF #########
        % the irf and the current dataset may cover different time scales AND/or
        % delay ranges.
        % make new time axis based on irf spacing from 0 to 12K (picoseceond)
        
        t_new = [handles.irf_dly(1):(handles.irf_dly(2)-handles.irf_dly(1)):handles.irf_dly(1) + 12000];
        
        basis(:,1) = ones(size(dlyrange1))';
        
        basis_new = conv(exp(-(t_new - t_new(1))/tau1), handles.irf); %lifetime 1
        basis(:,2) = interp1(t_new, basis_new(1:length(t_new)), dlyrange1);
        i=3;
        if tau2 ~= 0
            basis_new = conv(exp(-(t_new - t_new(1))/tau2), handles.irf); %lifetime 2
            basis(:,3) = interp1(t_new, basis_new(1:length(t_new)), dlyrange1);
            i=i+1;
        end
        if tau3 ~= 0
            basis_new = conv(exp(-(t_new - t_new(1))/tau3), handles.irf); %lifetime 3
            basis(:,4) = interp1(t_new, basis_new(1:length(t_new)), dlyrange1);
            i=i+1;
        end
        if tau4 ~=0
            if tau5 == 0
                basis_new = conv(exp(-(t_new - t_new(1))/tau4), handles.irf); %
                basis(:,i) = interp1(t_new, basis_new(1:length(t_new)), dlyrange1);
                
            else %then you have a biexp AF basis function, and should take into account the relative amplitudes
                %of each lifetime
                amp1=str2num(get(handles.amplitude1,'String'));
                amp2=str2num(get(handles.amplitude2,'String'));
                normconst=amp1+amp2;
                amp1=amp1/normconst;
                amp2 = amp2/normconst;
                clear normconst
                
                basis_new = conv(   ( amp1* exp(-(t_new - t_new(1))/tau4)...
                    +amp2* exp(-(t_new - t_new(1))/tau5) ) , handles.irf);
                basis(:,i) = interp1(t_new, basis_new(1:length(t_new)), dlyrange1);
            end
        end
    else
        msgbox('No IRF found, first save irf, or choose numeric t0')
    end
else
    
    %########   create basis functions that are simple exponentials #########
    
    basis(:,1) = ones(size(dlyrange1))'; %bill change oct 2013
    % basis(:,1)=0;
    %      basis(:,1) = zeros(size(dlyrange1))';
    basis(:,2) = exp(-(dlyrange1-t0)/tau1)'; %lifetime 1
    i=3;
    
    if tau2 ~= 0
        basis(:,i) = exp(-(dlyrange1-t0)/tau2)'; %lifetime 2
        i=i+1;
    end
    if tau3 ~= 0
        basis(:,i) = exp(-(dlyrange1-t0)/tau3)'; %lifetime 3
        i=i+1;
    end
    if tau4 ~=0
        if tau5 == 0
            basis(:,i) = exp(-(dlyrange1-t0)/tau4)';
        else %then you have a biexp AF basis function, and should take into account the relative amplitudes
            %of each lifetime
            amp1=str2num(get(handles.amplitude1,'String'));
            amp2=str2num(get(handles.amplitude2,'String'));
            %           normconst=max([amp1 amp2]);
            
            normconst=amp1+amp2;
            amp1=amp1/normconst;
            amp2 = amp2/normconst;
            clear normconst
            basis(:,i) = amp1*exp(-(dlyrange1-t0)/tau4)' + amp2*exp(-(dlyrange1-t0)/tau5)';
        end
    end
    
    
    %######## ----------------------------------------------------   #########
end
%     for ii=1:i  basis(:,ii)=normalize(basis(:,ii)); end

rebinflag=get(handles.rebincheckbox,'value');

dlyrangeX = str2num(get(handles.excitationdelays,'String'));


%select ROI
%only set up for 1 ROI for now
if get(handles.selectROI,'Value')==1;
    K=getimage(handles.axes6);
    %if user has not entered a set of labels, set the number of ROI to
    %1
    if  (strcmp('Label', get(handles.ROIlabel,'String')))
        ROI_suff=1;
        nROI=1;
    else
        ROI_suff=str2num(get(handles.ROIlabel,'String'));
        nROI = length(ROI_suff);
    end
    if isempty(handles.BW)
        figure(124);
        imagesc(K);axis image;set(gca,'YDir','Normal');
        for ii = 1:nROI
            BW(ii,:,:)=roipoly;
        end
        close(124)
        handles.BW=BW;
        guidata(handles.figure1,handles);
    else
        BW=handles.BW;
    end
else
    BW=ones(size( getimage(handles.axes6)));
end


%###### GENERATE THE AMPLITUDE IMAGES for a SERIES of SOURCES ie. tomo scan #
%###
%###
%#############################################################################
if get(handles.AmpMapAllSourcesCheckbox, 'Value')
    
    disp('going par')
    disp('size(srcno,2) ')
    [M N]=size ( getimage(handles.axes6) );
    O=size (basis,2);
    %make the stack variables
    amp_image_stack = zeros(M, N, O, size(srcno,2) );
    rgbim_stack     = zeros(M, N, 3, size(srcno,2) );
    rgbim1=zeros(M, N);
    rgbim2=zeros(M, N);
    rgbim3=zeros(M, N);
    
    testvalue=get(handles.checkbox10,'Value'); %see if statment a few lines below.
    %###############################################################3
    if get(handles.checkmulticore,'Value')==1;
        
        parfor i=1:size(srcno,2)
            rgbim1=zeros(M, N);
            rgbim2=zeros(M, N);
            rgbim3=zeros(M, N);
            [amp_image, chisq] = gen_amp_image(a,b,dlyrangeX,dlyrange1,srcno(i),basis,thres,...
                normflag,bin,rebinflag,BW);
            
            %########---------- clean up the amplitude imag e-----------------#########
            
            max1=max(max(max(amp_image)));
            amp_image(find(amp_image<0))=0; %set negative values to 0
            
            if testvalue==1  %normalize to max amplitude
                rgbim1=amp_image(:,:,3)/max1; %red   Is this not backwards?
                rgbim2=amp_image(:,:,2)/max1;
                if isequal(size(amp_image,3), 4)
                    rgbim3=amp_image(:,:,4)/max1;
                else
                    %                rgbim3=0;
                end
            else
                % not interested in the first channel of amp_image. If there are three
                % fluorophores, store the amplitudes in RGB or channels 1,2,3  if there
                % are three fluorophores and autoflu, dont show the autoflu.
                if isequal(size(amp_image,3), 2)
                    rgbim1=amp_image(:,:,2)/(max(max( amp_image(:,:,2)  )));
                else
                    rgbim1=amp_image(:,:,2)/(max(max( amp_image(:,:,2)  )));
                    rgbim2=amp_image(:,:,3)/(max(max( amp_image(:,:,3)  )));
                end
                if isequal(size(amp_image,3), 4)||isequal(size(amp_image,3), 5)
                    rgbim3=amp_image(:,:,4)/(max(max( amp_image(:,:,4)  )));
                else
                    rgbim3=zeros(M, N);
                end
            end
            
            
            %########---------- POPULATE THE STACKS  ----------------#########
            %         if first_time
            %             first_time=0;
            %             %make the stack variables
            %             [M N O]=size(amp_image);
            %             amp_image_stack = zeros(M, N, O, size(srcno,2) );
            %             rgbim_stack     = zeros(M, N, 3, size(srcno,2) );
            %         end
            rgbim1=reshape(rgbim1,M*N,1);
            rgbim2=reshape(rgbim2,M*N,1);
            rgbim3=reshape(rgbim3,M*N,1);
            
            rgbim=[rgbim1; rgbim2; rgbim3];
            
            rgbim1=reshape(rgbim1,M,N);
            rgbim2=reshape(rgbim2,M,N);
            rgbim3=reshape(rgbim3,M,N);
            rgbim=reshape(rgbim,M,N,3);
            
            amp_image_stack(:,:,:,i)=amp_image;
            %             O=size(amp_image,3);
            %             switch O
            %                 case 1
            %                     amp_image_stack(:,:,:,i)=amp_image;
            %                 case 2
            %                     amp_image_stack(:,:,:,i)=amp_image;
            %
            %                 case 3
            %                     amp_image_stack(:,:,:,i)=amp_image;
            %                 case 4
            %                     amp_image_stack(:,:,:,i)=amp_image(:,:,2:4);
            %             end
            %                  amp_image_stack(:,:,1:O,i)=amp_image;
            rgbim_stack(:,:,:,i)=rgbim;
            
        end %for each source
        disp('done all sources');
    else
        %###############################################################3
        
        
        
        for i=1:size(srcno,2)
            %         waitbar(i/size(srcno,2),H, 'Processing for each source');
            
            [amp_image, chisq] = gen_amp_image(a,b,dlyrangeX,dlyrange1,srcno(i),basis,thres,...
                normflag,bin,rebinflag,BW);
            
            %########---------- clean up the amplitude imag e-----------------#########
            
            max1=max(max(max(amp_image)));
            amp_image(find(amp_image<0))=0; %set negative values to 0
            
            if testvalue==1  %normalize to max amplitude
                rgbim1=amp_image(:,:,3)/max1; %red
                rgbim2=amp_image(:,:,2)/max1;
                if isequal(size(amp_image,3), 4)
                    rgbim3=amp_image(:,:,4)/max1;
                else
                    %                rgbim3=0;
                end
            else
                % not interested in the first channel of amp_image. If there are three
                % fluorophores, store the amplitudes in RGB or channels 1,2,3  if there
                % are three fluorophores and autoflu, dont show the autoflu.
                if isequal(size(amp_image,3), 2)
                    rgbim1=amp_image(:,:,2)/(max(max( amp_image(:,:,2)  )));
                else
                    rgbim1=amp_image(:,:,2)/(max(max( amp_image(:,:,2)  )));
                    rgbim2=amp_image(:,:,3)/(max(max( amp_image(:,:,3)  )));
                end
                if isequal(size(amp_image,3), 4)||isequal(size(amp_image,3), 5)
                    rgbim3=amp_image(:,:,4)/(max(max( amp_image(:,:,4)  )));
                else
                    rgbim3=zeros(M, N);
                end
            end
            
            
            %########---------- POPULATE THE STACKS  ----------------#########
            %         if first_time
            %             first_time=0;
            %             %make the stack variables
            %             [M N O]=size(amp_image);
            %             amp_image_stack = zeros(M, N, O, size(srcno,2) );
            %             rgbim_stack     = zeros(M, N, 3, size(srcno,2) );
            %         end
            rgbim1=reshape(rgbim1,M*N,1);
            rgbim2=reshape(rgbim2,M*N,1);
            rgbim3=reshape(rgbim3,M*N,1);
            
            rgbim=[rgbim1; rgbim2; rgbim3];
            
            rgbim1=reshape(rgbim1,M,N);
            rgbim2=reshape(rgbim2,M,N);
            rgbim3=reshape(rgbim3,M,N);
            rgbim=reshape(rgbim,M,N,3);
            
            O=size(amp_image,3);
            amp_image_stack(:,:,1:O,i)=amp_image;
            rgbim_stack(:,:,:,i)=rgbim;
            
        end %for each source
        
    end
    %  if isequal(i, size(srcno,2))
    %     close (H);
    rgbim=squeeze(sum(rgbim_stack,4));
    rgbim(:,:,1)=rgbim(:,:,1) /(size(srcno,2));
    rgbim(:,:,2)=rgbim(:,:,2) /(size(srcno,2));
    rgbim(:,:,3)=rgbim(:,:,3) /(size(srcno,2));
    
    
    assignin('base',[fileprefixF,'_amp_image_stack'],amp_image_stack);
    %         assignin('base',[fileprefixF,'_amp_image_chisq'],chisq);
    %     assignin('base',[fileprefixF,'_amp_image_rgb'],rgbim);
    amp_image=squeeze(sum(amp_image_stack,4));
    % end
else %then there is only one source...
    %######## ------------GENERATE THE AMPLITUDE IMAGE------ ###################
    [amp_image, chisq] = gen_amp_image(a,b,dlyrangeX,dlyrange1,srcno,basis,thres,...
        normflag,bin,rebinflag,BW);
    
    %########---------- clean up the amplitude imag e-----------------#########
    
    max1=max(max(max(amp_image)));
    amp_image(find(amp_image<0))=0; %set negative values to 0
    
    if get(handles.checkbox10,'Value')==1  %normalize to max amplitude
        rgbim(:,:,1)=amp_image(:,:,3)/max1; %red
        rgbim(:,:,2)=amp_image(:,:,2)/max1;
        if isequal(size(amp_image,3), 4)
            rgbim(:,:,3)=amp_image(:,:,4)/max1;
        else
            rgbim(:,:,3)=0;
        end
    else
        % not interested in the first channel of amp_image. If there are three
        % fluorophores, store the amplitudes in RGB or channels 1,2,3  if there
        % are three fluorophores and autoflu, dont show the autoflu.
        
        %here we should also inform the user of hte max of the red and
        %green channles. (add blue later you lazy bastard.)
        
        if isequal(size(amp_image,3), 2)
            rgbim(:,:,1)=amp_image(:,:,2)/(max(max( amp_image(:,:,2)  )));
            set(handles.edit76,'String',(max(max( amp_image(:,:,2)  ))));
        else
            rgbim(:,:,1)=medfilt2(squeeze(amp_image(:,:,2)/(max(max( amp_image(:,:,2))))));
            rgbim(:,:,2)=medfilt2(squeeze(amp_image(:,:,3)/(max(max( amp_image(:,:,3))))));
            set(handles.edit77,'String',(max(max( amp_image(:,:,3)  ))));
        end
        if isequal(size(amp_image,3), 4)|isequal(size(amp_image,3), 5)
            rgbim(:,:,3)=amp_image(:,:,4)/(max(max( amp_image(:,:,4)  )));
            set(handles.edit78,'String',(max(max( amp_image(:,:,4)  ))));
        else
            rgbim(:,:,3)=0;
        end
    end
    assignin('base',[fileprefixF,'_amp_image'],amp_image);
    assignin('base',[fileprefixF,'_amp_image_chisq'],chisq);
    % assignin('base',[fileprefixF,'_amp_image_rgb'],rgbim);
    
end %check AmpMapAllSourcesCheckbox

%###  This section is used to display the mean amplitudes as title text. ####
% find the mean values for the amplitude images
% amp_lifetime1=0;
% amp_lifetime2=0;
% amp_lifetime3=0;
% %mean value of lifetime 1
% [Mm Nn]=size(find (amp_image(:,:,2))); %how many non zero pixels
% amp_lifetime1=sum(sum( amp_image(:,:,2) ))/Mm;
% %mean value of lifetime 2
% if isequal(size(amp_image,3), 3)
% [Mm Nn]=size(find (amp_image(:,:,3))); %how many non zero pixels
% amp_lifetime2=sum(sum( amp_image(:,:,3) ))/Mm;
% end
% %mean value of lifetime 3
% if isequal(size(amp_image,3), 4)
% [Mm Nn]=size(find (amp_image(:,:,4))); %how many non zero pixels
% amp_lifetime3=sum(sum( amp_image(:,:,4) ))/Mm;
% end
% clear Mm Nn;

%  figure;
imagesc(rgbim);axis image; axis off;

%not sure if the output is entirely correct, may be averaged over the whole
%image.... 9/26/2012  bill
%title(['R, LT2, AMP=',num2str(round(amp_lifetime2)),' G, LT1, AMP=',num2str(round(amp_lifetime1)),' B, LT3, AMP=',num2str(round(amp_lifetime3))] );
%###  ################################################################ ####
% April 29 2013, set the min and max values for each RGB channel.
%By default these are 0 and 1 because it is an RGB image.
set(handles.Rmin, 'String', '0');
set(handles.Rmax, 'String', '1');
set(handles.Gmin, 'String', '0');
set(handles.Gmax, 'String', '1');
set(handles.Bmin, 'String', '0');
set(handles.Bmax, 'String', '1');

set(handles.Rcheckbox, 'Value', 1);
set(handles.Gcheckbox, 'Value', 1);
set(handles.Bcheckbox, 'Value', 0); %set b off by default?

set(gca,'YDir','normal');
handles.rgbim=rgbim;
handles.amp_image=amp_image;
guidata(hObject,handles);



function lifetime1_Callback(hObject, eventdata, handles)
% hObject    handle to lifetime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetime1 as text
%        str2double(get(hObject,'String')) returns contents of lifetime1 as a double


% --- Executes during object creation, after setting all properties.
function lifetime1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lifetime2_Callback(hObject, eventdata, handles)
% hObject    handle to lifetime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetime2 as text
%        str2double(get(hObject,'String')) returns contents of lifetime2 as a double


% --- Executes during object creation, after setting all properties.
function lifetime2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double


% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in normalizecheckbox.
function normalizecheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to normalizecheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalizecheckbox



function excitationdata_Callback(hObject, eventdata, handles)
% hObject    handle to excitationdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excitationdata as text
%        str2double(get(hObject,'String')) returns contents of excitationdata as a double


% --- Executes during object creation, after setting all properties.
function excitationdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitationdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in rebincheckbox.
function rebincheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to rebincheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rebincheckbox





function excitationdelays_Callback(hObject, eventdata, handles)
% hObject    handle to excitationdelays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excitationdelays as text
%        str2double(get(hObject,'String')) returns contents of excitationdelays as a double


% --- Executes during object creation, after setting all properties.
function excitationdelays_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitationdelays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in info.
function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileprefix = get(handles.edit9,'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
if ispc
    fileprefix = strrep([dir_path,'\',fileprefix],'\','\\');
else
    fileprefix = strrep([dir_path,'/',fileprefix],'/','//');
end
if exist([fileprefix,'.txt'])
    popupmessage([fileprefix,'.txt']);
    
    %     open([fileprefix,'.txt']);
else
    msgbox('No info available')
end







% --- Executes on button press in biexpcheckbox.
function biexpcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to biexpcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of biexpcheckbox




% --- Executes on button press in selectROI.
function selectROI_Callback(hObject, eventdata, handles)
% hObject    handle to selectROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of selectROI

handles.BW=[];
guidata(handles.figure1,handles);




function ROIlabel_Callback(hObject, eventdata, handles)
% hObject    handle to ROIlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROIlabel as text
%        str2double(get(hObject,'String')) returns contents of ROIlabel as a double
handles.BW=[];
guidata(handles.figure1,handles);

% --- Executes during object creation, after setting all properties.
function ROIlabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROIlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in togglebutton_CW_Intensity.
function togglebutton_CW_Intensity_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_CW_Intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton_CW_Intensity
set(handles.uipanel5,'Visible','On');
set(handles.uipanel7,'Visible','Off');
set(handles.uipanel8,'Visible','Off');
set(handles.togglebutton_lifetime_image,'Value',0);
set(handles.togglebutton_amplitude_image,'Value',0);
listbox1_Callback(hObject, eventdata, handles);




% --- Executes on button press in togglebutton_lifetime_image.
function togglebutton_lifetime_image_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_lifetime_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton_lifetime_image
set(handles.uipanel5,'Visible','Off');
set(handles.uipanel7,'Visible','On');
set(handles.uipanel8,'Visible','Off');
set(handles.togglebutton_CW_Intensity,'Value',0);
set(handles.togglebutton_amplitude_image,'Value',0);

axes(handles.axes6);
[m n] = caxis;
set(handles.Coloraxis1,'String', m);
set(handles.Coloraxis2,'String', n);

% --- Executes on button press in togglebutton_amplitude_image.
function togglebutton_amplitude_image_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_amplitude_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton_amplitude_image
set(handles.uipanel5,'Visible','Off');
set(handles.uipanel7,'Visible','Off');
set(handles.uipanel8,'Visible','On');
set(handles.togglebutton_lifetime_image,'Value',0);
set(handles.togglebutton_CW_Intensity,'Value',0);


% --- Executes on button press in pushbutton15.
%sends data to TomoRecon and calls that function
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Launches TomoRecon  and passes some inital variables via the base
%workspace
%Pass the CW image, the File Name, and the Path to the data.
% global f3DImage CCDImage

CCDImage=getimage(handles.axes1);
assignin('base','freespace',CCDImage);
dir_path = get(handles.edit6,'String');
dir_path=dir_path(1:end-1);
assignin('base','dir_path',dir_path);
datafileprefix=get(handles.edit9,'String');
assignin('base','datafileprefix',datafileprefix);


% TomoRecon
TomoRecon;
% run('C:\Users\wrice\Documents\MATLAB\CombinedMatlabTools\tomography\TomoRecon');

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lifetime3_Callback(hObject, eventdata, handles)
% hObject    handle to lifetime3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetime3 as text
%        str2double(get(hObject,'String')) returns contents of lifetime3 as a double


% --- Executes during object creation, after setting all properties.
function lifetime3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetime3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amplitude1_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amplitude1 as text
%        str2double(get(hObject,'String')) returns contents of amplitude1 as a double


% --- Executes during object creation, after setting all properties.
function amplitude1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amplitude2_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amplitude2 as text
%        str2double(get(hObject,'String')) returns contents of amplitude2 as a double


% --- Executes during object creation, after setting all properties.
function amplitude2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
K=handles.rgbim;
%select region of interest
axes(handles.axes7); axis image; axis off;
imagesc(K);
set(gca, 'YDir','normal');
title('Select region to separate components')
[x, y, BW, xi, yi] = roipoly;


X=round (max(xi)) - round (min(xi))+1 ; %size of the boinding box
Y=round (max(yi)) - round (min(yi))+1 ;

%need to incorporate the stuff for blue and autofluorescence.
%handles.rgbim will only have R,G,B channels. for three lifetimes. In the
%case that there are three fluorophores AND autofluorescence, the AF data
%is stored in the 5th channel of handles.amp_image
if isequal(size(handles.amp_image,3) ,4)| isequal(size(handles.amp_image,3) ,5)
    KO=zeros(Y*2,(X*3),3);
    %if there are 4 channels in handles.amp_image, then there will be a
    %blue channel (3) in rgbimg.
    KO(Y+1:2*Y,X+1:2*X,1)= flipud(K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 3));
    KO(Y+1:2*Y,X+1:2*X,2)= flipud(K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 3));
    KO(Y+1:2*Y,X+1:2*X,3)= flipud(K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 3));
    
    if isequal(size(handles.amp_image,3) ,5) %this is for the AF component
        KO(Y+1:2*Y,2*X+1:3*X,1)=flipud( handles.amp_image(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 5)  /max(max(handles.amp_image(:,:,5))) );
        KO(Y+1:2*Y,2*X+1:3*X,2)=flipud( handles.amp_image(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 5)  /max(max(handles.amp_image(:,:,5))));
        KO(Y+1:2*Y,2*X+1:3*X,3)=flipud( handles.amp_image(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 5)  /max(max(handles.amp_image(:,:,5))));
    end
else
    KO=zeros(Y,(X*3),3);
end
KO(1:Y,1:X,1)=       flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)),1));
KO(1:Y,1:X,2)=       flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)),2));
KO(1:Y,1:X,3)=       flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)),3));

KO(1:Y,X+1:2*X,1)=   flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 1));
KO(1:Y,X+1:2*X,2)=   flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 1));
KO(1:Y,X+1:2*X,3)=   flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 1));
KO(1:Y,2*X+1:3*X,1)= flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 2));
KO(1:Y,2*X+1:3*X,2)= flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 2));
KO(1:Y,2*X+1:3*X,3)= flipud (K(round (min(yi)):round (max(yi)), round (min(xi)):round (max(xi)), 2));

imshow(KO); %determines range for colorbar
% set(gca, 'YDir','normal');

title('Figure sent to system clipboard');
h=figure (123),imshow(KO,'border','tight');

print(h,'-dmeta');
close (123);



% --- Executes on button press in brightestpixels.
function brightestpixels_Callback(hObject, eventdata, handles)
% hObject    handle to brightestpixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of brightestpixels



function AF_lifetime1_Callback(hObject, eventdata, handles)
% hObject    handle to AF_lifetime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AF_lifetime1 as text
%        str2double(get(hObject,'String')) returns contents of AF_lifetime1 as a double


% --- Executes during object creation, after setting all properties.
function AF_lifetime1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AF_lifetime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AF_lifetime2_Callback(hObject, eventdata, handles)
% hObject    handle to AF_lifetime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AF_lifetime2 as text
%        str2double(get(hObject,'String')) returns contents of AF_lifetime2 as a double


% --- Executes during object creation, after setting all properties.
function AF_lifetime2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AF_lifetime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lifetimeanalysis.
function lifetimeanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.uipanel3,'Visible','On');
% set(handles.ImageToolsPanel,'Visible','Off');


% --- Executes on button press in getAverageROI.
function getAverageROI_Callback(hObject, eventdata, handles)
% hObject    handle to getAverageROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%sloppy at first

if get(handles.togglebutton_CW_Intensity,'Value');
    H=handles.axes6;
    K=getimage(H);
    
elseif get(handles.togglebutton_lifetime_image,'Value');
    H=handles.axes6;
    K=getimage(H);
    
elseif get(handles.togglebutton_amplitude_image,'Value');
    H=handles.axes7;
    K=handles.amp_image;  %dont forget that the first of the third dimension we dont use. so (:,:,2) is R
    
end

results_forcopy=zeros([str2num(get(handles.edit65,'String')),8]);



if isfield(handles, 'reuse_ROI') && isequal(handles.reuse_ROI ,1)
    ROI_mask_matrix=handles.ROI_mask_matrix;
    reuse_ROI=1;
    handles.reuse_ROI=0;
else
    
    handles.ROI_mask_matrix=zeros([size(K,1), size(K,2),...
        str2num(get(handles.edit65,'String'))]); %store the ROI in here.
    reuse_ROI=0;
end

for numberofROI=1:str2num(get(handles.edit65,'String'))
    
    if reuse_ROI
        mask=squeeze(ROI_mask_matrix(:,:,numberofROI));
    else
        
        if get(handles.togglebutton_CW_Intensity,'Value');
            
            figure(99), imagesc(K);
        elseif get(handles.togglebutton_lifetime_image,'Value');
            
            figure(99), imagesc(K);
        elseif get(handles.togglebutton_amplitude_image,'Value');
            figure(99), imagesc(handles.rgbim);
        end
        set(gca, 'YDir', 'normal');
        title('Select ROI')
        %
        % figure(99), imagesc(normalize(K));
        mask=roipoly;
        handles.ROI_mask_matrix(:,:,numberofROI)=mask;
    end
    if isequal(size(K,3), 1)
        K2=K.*mask;
        %apply the threshold based on the values in the selected reigon.
        K_Thresh=  str2num(get(handles.percent_threshold,'String'))/100  *(max(max(K2))); %top whatever percent
        KA=mean(K2(find(K2 > K_Thresh)));
        KS= std (K2(find(K2 > K_Thresh)));
        %KA=(   sum(sum(K2))/  sum(sum(mask)));
        
        %set(handles.Results,'String',[sprintf('\n Mean Intensity = %d\n                 STD = %d\n \n\n\n\n\n\n\n :) ',round(KA),round(KS))]);
        set(handles.Results,'String',[sprintf('\n Mean Intensity = %d\n                 STD = %d\n \n\n\n\n\n\n\n :) ',KA,KS)]);
        
        % set(handles.Results,'String',[sprintf('\n Mean Red= %d\n Mean Green = %d\n Mean Blue = %d\n ',KA,KA,KA)]);
        figure(99), imagesc(K2.*(K2 > K_Thresh));
        pause(1);
        close (99);
        results_forcopy(numberofROI,1:2)=[KA, KS];
    else %K is prob an RGB or amplitude image.
        % K can vary in size from (:,:,2) to (:,:,4 or 5)
        KA_R  =0;
        KA_Rs =0;
        KA_G  =0;
        KA_Gs =0;
        KA_B  =0;
        KA_Bs =0;
        
        for i=2:size(K,3)
            % this code may be needed to remove really high values byhand
            K2=K(:,:,2);
            figure(2), imagesc(K2)
            %         I=((K(:,:,2)> 3000));
            %         K2(I)=0;
            %         figure(2), imagesc(K2)
            %         K(:,:,2)=K2;
            
            
            K2=K(:,:,i).*mask;
            %         K_Thresh=str2num(get(handles.percent_threshold,'String'))/100 *(max(max(K(:,:,i)))); %top whatever percent
            K_Thresh=str2num(get(handles.percent_threshold,'String'))/100 *(max(max(K2(:,:)))); %top whatever percent
            switch i
                case 2
                    KA_R  = mean(K2(find(K2 > K_Thresh)));
                    %                 KA_R  = sum(K2(find(K2 > K_Thresh)));
                    KA_Rs = std(K2(find(K2 > K_Thresh)));
                case 3
                    KA_G  = mean(K2(find(K2 > K_Thresh)));
                    %                 KA_G  = sum(K2(find(K2 > K_Thresh)));
                    KA_Gs = std(K2(find(K2 > K_Thresh)));
                case 4
                    KA_B  = mean(K2(find(K2 > K_Thresh)));
                    KA_Bs = std(K2(find(K2 > K_Thresh)));
                case 5
                    %not yet implimented... OMG!!
                    KA_O  = mean(K2(find(K2 > K_Thresh)));
                    KA_Os = std(K2(find(K2 > K_Thresh)));
            end
        end
        if isequal(size(K,3), 5)
            set(handles.Results,'String',[sprintf('\n Mean LT1= %d\n          STD =%d\n\n Mean LT2 = %d\n          STD =%d\n\n Mean LT3 = %0.3d\n           STD =%d\n\n Mean LT4 = %0.3d\n          STD =%0.3d\n  '...
                ,round(KA_R),round(KA_Rs),round(KA_G),round(KA_Gs),round(KA_B),round(KA_Bs),round(KA_O),round(KA_Os))]);
            results_forcopy(numberofROI,:)=[round(KA_R),round(KA_Rs),round(KA_G),round(KA_Gs),round(KA_B),round(KA_Bs),round(KA_O),round(KA_Os)];
        else
            set(handles.Results,'String',[sprintf('\n Mean LT1= %d\n          STD =%d\n\n Mean LT2 = %d\n          STD =%d\n\n Mean LT3 = %0.3d\n          STD =%0.3d\n '...
                ,round(KA_R),round(KA_Rs),round(KA_G),round(KA_Gs),round(KA_B),round(KA_Bs))]);
            % results_forcopy=[round(KA_R),round(KA_Rs),round(KA_G),round(KA_Gs),round(KA_B),round(KA_Bs)];
            results_forcopy(numberofROI,1:4)=[round(KA_R),round(KA_Rs),round(KA_G),round(KA_Gs)];
        end
        
        [M N]=size(mask);
        mask3D=zeros(M, N ,3);
        mask3D(:,:,1)=mask;  mask3D(:,:,2)=mask;  mask3D(:,:,3)=mask;
        
        figure(99), imshow(handles.rgbim.*mask3D);
        pause(1);
        close (99);
        close(2);
    end
end %for
guidata(hObject,handles);
num2clip(results_forcopy);

% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17



function edit65_Callback(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit65 as text
%        str2double(get(hObject,'String')) returns contents of edit65 as a double


% --- Executes during object creation, after setting all properties.
function edit65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ImageTools.
function ImageTools_Callback(hObject, eventdata, handles)
% hObject    handle to ImageTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.uipanel3,'Visible','Off');
% set(handles.ImageToolsPanel,'Visible','On');



function Results_Callback(hObject, eventdata, handles)
% hObject    handle to Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Results as text
%        str2double(get(hObject,'String')) returns contents of Results as a double


% --- Executes during object creation, after setting all properties.
function Results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function percent_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to percent_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percent_threshold as text
%        str2double(get(hObject,'String')) returns contents of percent_threshold as a double


% --- Executes during object creation, after setting all properties.
function percent_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percent_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Copy_to_clipboard.
function Copy_to_clipboard_Callback(hObject, eventdata, handles)
% hObject    handle to Copy_to_clipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%which axis should we use?  CW is axes6, lifetime is axes6, amp is axes7
if isequal(get(handles.togglebutton_CW_Intensity,'Value'),1)
    K=get(get(handles.axes6,'Children'),'CData');
elseif isequal(get(handles.togglebutton_lifetime_image,'Value'),1)
    K=get(get(handles.axes6,'Children'),'CData');
elseif isequal(get(handles.togglebutton_amplitude_image,'Value'),1)
    K=get(get(handles.axes7,'Children'),'CData');
end

sz = size(K);
h = figure;
% K=flipud(K);
imagesc(K);set(gca,'YDir','normal');
if isequal(get(handles.billsmap_checkbox,'Value'),1)
    colormap billsmap;
elseif isequal(get(handles.Jet_checkbox,'Value'),1)
    colormap jet;
else
    colormap gray;
end
if isequal(get(handles.togglebutton_lifetime_image,'Value'),1)
    caxis([str2num(get(handles.Coloraxis1,'String')) str2num(get(handles.Coloraxis2,'String'))]);
end

set(gcf,'position',[100 100 sz(2) sz(1)]);
set(gca,'position',[0 0 1 1])
print (h,'-dbitmap')
close(h)

% --- Executes on button press in Jet_checkbox.
function Jet_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Jet_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Jet_checkbox

%##########  Set the colormap to jet
colormap jet;
[M N]=caxis;
%########## display color axis in text boxes
set(handles.Coloraxis1,'String',num2str(M));
set(handles.Coloraxis2,'String',num2str(N));
%##########  reset the other colormap checkboxes
set (handles.billsmap_checkbox,'value',0);
set (handles.grayscale_checkbox,'value',0);


% --- Executes on button press in billsmap_checkbox.
function billsmap_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to billsmap_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of billsmap_checkbox

%##########  Set the colormap to billsmap
colormap billsmap;
[M N]=caxis;
%########## display color axis in text boxes
set(handles.Coloraxis1,'String',num2str(M));
set(handles.Coloraxis2,'String',num2str(N));
%##########  reset the other colormap checkboxes
set (handles.Jet_checkbox,'value',0);
set (handles.grayscale_checkbox,'value',0);


% --- Executes on button press in grayscale_checkbox.
function grayscale_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to grayscale_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of grayscale_checkbox

%##########  Set the colormap to jet
colormap gray;
[M N]=caxis;
%########## display color axis in text boxes
set(handles.Coloraxis1,'String',num2str(M));
set(handles.Coloraxis2,'String',num2str(N));
%##########  reset the other colormap checkboxes
set (handles.billsmap_checkbox,'value',0);
set (handles.Jet_checkbox,'value',0);


function Coloraxis1_Callback(hObject, eventdata, handles)
% hObject    handle to Coloraxis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Coloraxis1 as text
%        str2double(get(hObject,'String')) returns contents of Coloraxis1 as a double

if get(handles.togglebutton_CW_Intensity, 'Value')==1
    axes(handles.axes6);
elseif get(handles.togglebutton_lifetime_image, 'Value')==1
    axes(handles.axes6);
end

[M N]=caxis;
J=str2num(get(handles.Coloraxis1,'String'));
caxis([J N]);

% --- Executes during object creation, after setting all properties.
function Coloraxis1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Coloraxis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Coloraxis2_Callback(hObject, eventdata, handles)
% hObject    handle to Coloraxis2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Coloraxis2 as text
%        str2double(get(hObject,'String')) returns contents of Coloraxis2 as a double

if get(handles.togglebutton_CW_Intensity, 'Value')==1
    axes(handles.axes6);
elseif get(handles.togglebutton_lifetime_image, 'Value')==1
    axes(handles.axes6);
end

[M N]=caxis;
J=str2num(get(handles.Coloraxis2,'String'));
caxis([M J]);


% --- Executes during object creation, after setting all properties.
function Coloraxis2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Coloraxis2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AmpMapAllSourcesCheckbox.
function AmpMapAllSourcesCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to AmpMapAllSourcesCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AmpMapAllSourcesCheckbox


% --- Executes on button press in checkmulticore.
function checkmulticore_Callback(hObject, eventdata, handles)
% hObject    handle to checkmulticore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkmulticore
if get(handles.checkmulticore,'Value')==0;
    delete(gcp('nocreate'))
else
    parpool (str2num(getenv('NUMBER_OF_PROCESSORS'))/2); %this works on windows
    %parpool('local');
end

% --- Executes on button press in Rcheckbox.
function Rcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to Rcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Rcheckbox


% --- Executes on button press in Bcheckbox.
function Bcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to Bcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Bcheckbox


% --- Executes on button press in Gcheckbox.
function Gcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to Gcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Gcheckbox



function Rmin_Callback(hObject, eventdata, handles)
% hObject    handle to Rmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rmin as text
%        str2double(get(hObject,'String')) returns contents of Rmin as a double
rgbim=handles.rgbim;
Rmin = str2num(get(handles.Rmin, 'String'));
Rmax = str2num(get(handles.Rmax, 'String'));

Gmin = str2num(get(handles.Gmin, 'String'));
Gmax = str2num(get(handles.Gmax, 'String'));

Bmin = str2num(get(handles.Bmin, 'String'));
Bmax = str2num(get(handles.Bmax, 'String'));

%modify the displayed image
if get(handles.Rcheckbox,'Value')
    K=rgbim(:,:,1);  I=(K > Rmax); K(I)=1;   I=(K < Rmin); K(I)=0;   rgbim(:,:,1)=K;
    rgbim(:,:,1)= rgbim(:,:,1)-min(min( rgbim(:,:,1)));
    rgbim(:,:,1)= rgbim(:,:,1)/max(max( rgbim(:,:,1)));
else
    rgbim(:,:,1)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,2);  I=(K > Gmax); K(I)=1;   I=(K < Gmin); K(I)=0;   rgbim(:,:,2)=K;
    rgbim(:,:,2)= rgbim(:,:,2)-min(min( rgbim(:,:,2)));
    rgbim(:,:,2)= rgbim(:,:,2)/max(max( rgbim(:,:,2)));
else
    rgbim(:,:,2)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,3);  I=(K > Bmax); K(I)=1;   I=(K < Bmin); K(I)=0;   rgbim(:,:,3)=K;
    rgbim(:,:,3)= rgbim(:,:,3)-min(min( rgbim(:,:,3)));
    rgbim(:,:,3)= rgbim(:,:,3)/max(max( rgbim(:,:,3)));
else
    rgbim(:,:,3)=0;
end

axes(handles.axes7); axis image; axis off;
imagesc(rgbim);axis image; axis off;
set(gca,'YDir', 'Normal');

% --- Executes during object creation, after setting all properties.
function Rmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rmax_Callback(hObject, eventdata, handles)
% hObject    handle to Rmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rmax as text
%        str2double(get(hObject,'String')) returns contents of Rmax as a double
rgbim=handles.rgbim;
Rmin = str2num(get(handles.Rmin, 'String'));
Rmax = str2num(get(handles.Rmax, 'String'));

Gmin = str2num(get(handles.Gmin, 'String'));
Gmax = str2num(get(handles.Gmax, 'String'));

Bmin = str2num(get(handles.Bmin, 'String'));
Bmax = str2num(get(handles.Bmax, 'String'));

%modify the displayed image
if get(handles.Rcheckbox,'Value')
    K=rgbim(:,:,1);  I=(K > Rmax); K(I)=1;   I=(K < Rmin); K(I)=0;   rgbim(:,:,1)=K;
    rgbim(:,:,1)= rgbim(:,:,1)-min(min( rgbim(:,:,1)));
    rgbim(:,:,1)= rgbim(:,:,1)/max(max( rgbim(:,:,1)));
else
    rgbim(:,:,1)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,2);  I=(K > Gmax); K(I)=1;   I=(K < Gmin); K(I)=0;   rgbim(:,:,2)=K;
    rgbim(:,:,2)= rgbim(:,:,2)-min(min( rgbim(:,:,2)));
    rgbim(:,:,2)= rgbim(:,:,2)/max(max( rgbim(:,:,2)));
else
    rgbim(:,:,2)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,3);  I=(K > Bmax); K(I)=1;   I=(K < Bmin); K(I)=0;   rgbim(:,:,3)=K;
    rgbim(:,:,3)= rgbim(:,:,3)-min(min( rgbim(:,:,3)));
    rgbim(:,:,3)= rgbim(:,:,3)/max(max( rgbim(:,:,3)));
else
    rgbim(:,:,3)=0;
end

axes(handles.axes7); axis image; axis off;
imagesc(rgbim);axis image; axis off;
set(gca,'YDir', 'Normal');


% --- Executes during object creation, after setting all properties.
function Rmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bmin_Callback(hObject, eventdata, handles)
% hObject    handle to Bmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bmin as text
%        str2double(get(hObject,'String')) returns contents of Bmin as a double
rgbim=handles.rgbim;
Rmin = str2num(get(handles.Rmin, 'String'));
Rmax = str2num(get(handles.Rmax, 'String'));

Gmin = str2num(get(handles.Gmin, 'String'));
Gmax = str2num(get(handles.Gmax, 'String'));

Bmin = str2num(get(handles.Bmin, 'String'));
Bmax = str2num(get(handles.Bmax, 'String'));

%modify the displayed image
if get(handles.Rcheckbox,'Value')
    K=rgbim(:,:,1);  I=(K > Rmax); K(I)=1;   I=(K < Rmin); K(I)=0;   rgbim(:,:,1)=K;
    rgbim(:,:,1)= rgbim(:,:,1)-min(min( rgbim(:,:,1)));
    rgbim(:,:,1)= rgbim(:,:,1)/max(max( rgbim(:,:,1)));
else
    rgbim(:,:,1)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,2);  I=(K > Gmax); K(I)=1;   I=(K < Gmin); K(I)=0;   rgbim(:,:,2)=K;
    rgbim(:,:,2)= rgbim(:,:,2)-min(min( rgbim(:,:,2)));
    rgbim(:,:,2)= rgbim(:,:,2)/max(max( rgbim(:,:,2)));
else
    rgbim(:,:,2)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,3);  I=(K > Bmax); K(I)=1;   I=(K < Bmin); K(I)=0;   rgbim(:,:,3)=K;
    rgbim(:,:,3)= rgbim(:,:,3)-min(min( rgbim(:,:,3)));
    rgbim(:,:,3)= rgbim(:,:,3)/max(max( rgbim(:,:,3)));
else
    rgbim(:,:,3)=0;
end

axes(handles.axes7); axis image; axis off;
imagesc(rgbim);axis image; axis off;
set(gca,'YDir', 'Normal');

% --- Executes during object creation, after setting all properties.
function Bmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bmax_Callback(hObject, eventdata, handles)
% hObject    handle to Bmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bmax as text
%        str2double(get(hObject,'String')) returns contents of Bmax as a double
rgbim=handles.rgbim;
Rmin = str2num(get(handles.Rmin, 'String'));
Rmax = str2num(get(handles.Rmax, 'String'));

Gmin = str2num(get(handles.Gmin, 'String'));
Gmax = str2num(get(handles.Gmax, 'String'));

Bmin = str2num(get(handles.Bmin, 'String'));
Bmax = str2num(get(handles.Bmax, 'String'));

%modify the displayed image
if get(handles.Rcheckbox,'Value')
    K=rgbim(:,:,1);  I=(K > Rmax); K(I)=1;   I=(K < Rmin); K(I)=0;   rgbim(:,:,1)=K;
    rgbim(:,:,1)= rgbim(:,:,1)-min(min( rgbim(:,:,1)));
    rgbim(:,:,1)= rgbim(:,:,1)/max(max( rgbim(:,:,1)));
else
    rgbim(:,:,1)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,2);  I=(K > Gmax); K(I)=1;   I=(K < Gmin); K(I)=0;   rgbim(:,:,2)=K;
    rgbim(:,:,2)= rgbim(:,:,2)-min(min( rgbim(:,:,2)));
    rgbim(:,:,2)= rgbim(:,:,2)/max(max( rgbim(:,:,2)));
else
    rgbim(:,:,2)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,3);  I=(K > Bmax); K(I)=1;   I=(K < Bmin); K(I)=0;   rgbim(:,:,3)=K;
    rgbim(:,:,3)= rgbim(:,:,3)-min(min( rgbim(:,:,3)));
    rgbim(:,:,3)= rgbim(:,:,3)/max(max( rgbim(:,:,3)));
else
    rgbim(:,:,3)=0;
end

axes(handles.axes7); axis image; axis off;
imagesc(rgbim);axis image; axis off;
set(gca,'YDir', 'Normal');

% --- Executes during object creation, after setting all properties.
function Bmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gmin_Callback(hObject, eventdata, handles)
% hObject    handle to Gmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gmin as text
%        str2double(get(hObject,'String')) returns contents of Gmin as a double
rgbim=handles.rgbim;
Rmin = str2num(get(handles.Rmin, 'String'));
Rmax = str2num(get(handles.Rmax, 'String'));

Gmin = str2num(get(handles.Gmin, 'String'));
Gmax = str2num(get(handles.Gmax, 'String'));

Bmin = str2num(get(handles.Bmin, 'String'));
Bmax = str2num(get(handles.Bmax, 'String'));

%modify the displayed image
if get(handles.Rcheckbox,'Value')
    K=rgbim(:,:,1);  I=(K > Rmax); K(I)=1;   I=(K < Rmin); K(I)=0;   rgbim(:,:,1)=K;
    rgbim(:,:,1)= rgbim(:,:,1)-min(min( rgbim(:,:,1)));
    rgbim(:,:,1)= rgbim(:,:,1)/max(max( rgbim(:,:,1)));
else
    rgbim(:,:,1)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,2);  I=(K > Gmax); K(I)=1;   I=(K < Gmin); K(I)=0;   rgbim(:,:,2)=K;
    rgbim(:,:,2)= rgbim(:,:,2)-min(min( rgbim(:,:,2)));
    rgbim(:,:,2)= rgbim(:,:,2)/max(max( rgbim(:,:,2)));
else
    rgbim(:,:,2)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,3);  I=(K > Bmax); K(I)=1;   I=(K < Bmin); K(I)=0;   rgbim(:,:,3)=K;
    rgbim(:,:,3)= rgbim(:,:,3)-min(min( rgbim(:,:,3)));
    rgbim(:,:,3)= rgbim(:,:,3)/max(max( rgbim(:,:,3)));
else
    rgbim(:,:,3)=0;
end

axes(handles.axes7); axis image; axis off;
imagesc(rgbim);axis image; axis off;
set(gca,'YDir', 'Normal');

% --- Executes during object creation, after setting all properties.
function Gmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gmax_Callback(hObject, eventdata, handles)
% hObject    handle to Gmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gmax as text
%        str2double(get(hObject,'String')) returns contents of Gmax as a double
rgbim=handles.rgbim;
Rmin = str2num(get(handles.Rmin, 'String'));
Rmax = str2num(get(handles.Rmax, 'String'));

Gmin = str2num(get(handles.Gmin, 'String'));
Gmax = str2num(get(handles.Gmax, 'String'));

Bmin = str2num(get(handles.Bmin, 'String'));
Bmax = str2num(get(handles.Bmax, 'String'));

%modify the displayed image
if get(handles.Rcheckbox,'Value')
    K=rgbim(:,:,1);  I=(K > Rmax); K(I)=1;   I=(K < Rmin); K(I)=0;   rgbim(:,:,1)=K;
    rgbim(:,:,1)= rgbim(:,:,1)-min(min( rgbim(:,:,1)));
    rgbim(:,:,1)= rgbim(:,:,1)/max(max( rgbim(:,:,1)));
else
    rgbim(:,:,1)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,2);  I=(K > Gmax); K(I)=1;   I=(K < Gmin); K(I)=0;   rgbim(:,:,2)=K;
    rgbim(:,:,2)= rgbim(:,:,2)-min(min( rgbim(:,:,2)));
    rgbim(:,:,2)= rgbim(:,:,2)/max(max( rgbim(:,:,2)));
else
    rgbim(:,:,2)=0;
end

if get(handles.Gcheckbox,'Value')
    K=rgbim(:,:,3);  I=(K > Bmax); K(I)=1;   I=(K < Bmin); K(I)=0;   rgbim(:,:,3)=K;
    rgbim(:,:,3)= rgbim(:,:,3)-min(min( rgbim(:,:,3)));
    rgbim(:,:,3)= rgbim(:,:,3)/max(max( rgbim(:,:,3)));
else
    rgbim(:,:,3)=0;
end

axes(handles.axes7); axis image; axis off;
imagesc(rgbim);axis image; axis off;
set(gca,'YDir', 'Normal');

% --- Executes during object creation, after setting all properties.
function Gmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save_IRF.
function Save_IRF_Callback(hObject, eventdata, handles)
% hObject    handle to Save_IRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.irf_dly  = str2num(get(handles.edit8,'String')); %handles.dlyrange;
handles.irf = handles.TPSF/sum(handles.TPSF) * (handles.irf_dly(2) -  handles.irf_dly(1));
guidata(hObject,handles);


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit8,'String','6300:150:9900,11250:150:15000 ');
edit8_Callback(handles.edit8,eventdata, handles);



function edit76_Callback(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit76 as text
%        str2double(get(hObject,'String')) returns contents of edit76 as a double


% --- Executes during object creation, after setting all properties.
function edit76_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit77_Callback(hObject, eventdata, handles)
% hObject    handle to edit77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit77 as text
%        str2double(get(hObject,'String')) returns contents of edit77 as a double


% --- Executes during object creation, after setting all properties.
function edit77_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rescaleAMP.
function rescaleAMP_Callback(hObject, eventdata, handles)
% hObject    handle to rescaleAMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
amp_image=handles.amp_image;
Max_Red= str2num(get(handles.edit76,'String'));
Max_Green= str2num(get(handles.edit77,'String'));
Max_Blue= str2num(get(handles.edit78,'String'));


if isequal(size(amp_image,3), 2)
    rgbim(:,:,1)=amp_image(:,:,2)/Max_Red;
else
    rgbim(:,:,1)=amp_image(:,:,2)/Max_Red;
    rgbim(:,:,2)=amp_image(:,:,3)/Max_Green;
    
end
if isequal(size(amp_image,3), 4)|isequal(size(amp_image,3), 5)
    rgbim(:,:,3)=amp_image(:,:,4)/Max_Blue;
    
else
    rgbim(:,:,3)=0;
end


imshow(rgbim);axis image; axis off;

function edit78_Callback(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit78 as text
%        str2double(get(hObject,'String')) returns contents of edit78 as a double


% --- Executes during object creation, after setting all properties.
function edit78_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in repeat_ROI_average.
function repeat_ROI_average_Callback(hObject, eventdata, handles)
% hObject    handle to repeat_ROI_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.reuse_ROI=1;
guidata(hObject,handles);
getAverageROI_Callback(hObject, eventdata, handles);


% --- Executes on button press in autorange.
function autorange_Callback(hObject, eventdata, handles)
% hObject    handle to autorange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autorange


% --- Executes on button press in togglebutton_ShowRawData.
function togglebutton_ShowRawData_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_ShowRawData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.togglebutton_ShowRawData,'Value',1);
set(handles.togglebutton_CW_Intensity,'Value',0);
set(handles.togglebutton_lifetime_image,'Value',0);
set(handles.togglebutton_amplitude_image,'Value',0);

%set(handles.uipanel15,'Visible','On');
set(handles.uipanel5,'Visible','On');
set(handles.uipanel7,'Visible','Off');
set(handles.uipanel8,'Visible','Off');
axes(handles.axes1);

fileprefix_curr = get(handles.edit9, 'String');
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
file = ([dir_path,'\',fileprefix_curr,'_01.mat']);
all_files = load(file);
%all_delay = 1:all_files.num_binFiles;
true_delay = str2num(get(handles.edit8,'String'));

if get(handles.Normalize_Color,'Value')==1  %check whether Normalize button is on
    for i = 1:length(true_delay)
        Image = squeeze(all_files.Image_matrix(1,:,:,i));
        maxPixel(i) = max(Image(:));
    end
end

set(handles.popupmenu3, 'String', true_delay);
Curr_delay = get(handles.popupmenu3, 'Value');
if length(true_delay)>1     % do this if time-resolved data
    imagesc(squeeze(all_files.Image_matrix(1,:,:,Curr_delay))); set(gca,'YDir','normal'); axis image;
    if exist('maxPixel')>0 % maxPixel will exist if Normalize button is clicked on
        caxis([0 (max(maxPixel))]);
        set(handles.Coloraxis1,'String', 0);
        set(handles.Coloraxis2,'String',num2str(max(maxPixel)));
    else    % print image without normalizing
        %caxis([0 max(max(all_files.Image_matrix(1,:,:,Curr_delay)))]);
        [m n] = caxis;
        set(handles.Coloraxis1,'String', m);
        set(handles.Coloraxis2,'String', n);
    end
    
else        % do this if white light image
    set(handles.popupmenu3, 'String', true_delay);
    set(handles.popupmenu3, 'Value', 1);
    imagesc(squeeze(all_files.Image_matrix(1,:,:,1))); set(gca,'YDir','normal'); axis image;
    [m n] = caxis;
    set(handles.Coloraxis1,'String', m);
    set(handles.Coloraxis2,'String', n);
end

% save selected delay as .png, .tiff, .jpeg
if get(handles.saveMovie,'Value')==1 % check if save button is on
    if length(true_delay)==1
       msgbox('This is not a time resolved data. Use "CW intensity image" button to save');
       return;
    end
   [fileprefix, path, indx] = uiputfile({'*.tiff'; '*.fig'}, 'Save image');
   if fileprefix == 0     % stop if user does not provide filename and selects 'Close'
       return;
   end
   Image_fileName = ([path,fileprefix]);
    top = 0; bottom = 0;
    left = 0; right = 0;
    spacing1 = 0; spacing2 = 0;
    ncol = 1; nrow = 1;
    cols = 60*4; rows = 40*4;
    ratio = cols/rows; % col to rows
    subplot1 = @(m,n,p) subtightplot (m, n, p, [spacing1 spacing2], [bottom top], [left right]);
    figure(100);
    set(figure(100), 'Position', [400 400 (1+(ncol-1)*spacing1)*(1+right+left)*500 (1+(nrow-1)*spacing2)*(1+bottom+top)*(500/(ratio * (ncol/nrow)))]);
    %figure(100), a = subplot1(1, 1, 1);
    imagesc(squeeze(all_files.Image_matrix(1,:,:,Curr_delay))); set(gca,'YDir','normal');
    axis image;
    if get(handles.Normalize_Color,'Value')==1
        caxis([0 (max(maxPixel))]);    
    else
        caxis([c1 c2]);
        %caxis([0 max(max(all_files.Image_matrix(1,:,:,Curr_delay)))]);
    end
    set(gcf, 'Color', 'white'); % white bckgr
    if get(handles.Jet_checkbox,'Value')==1
            colormap(jet);
        elseif get(handles.billsmap_checkbox,'Value')==1
            colormap(billsmap);
        else
            colormap(gray);
    end
    if indx == 1
    export_fig(gcf, ...       % figure handle
        sprintf('%s.tiff', Image_fileName(1:end-5)),... % name of output file without extension
        '-painters', ...      % renderer
        '-tiff', ...           % file format
        '-r300' );            % resolution in dpi
    close (figure(100));
    elseif indx == 2
    export_fig(gcf, ...       % figure handle
        sprintf('%s.fig', Image_fileName(1:end-4)),... % name of output file without extension
        '-painters', ...      % renderer
        '-fig', ...          % file format
        '-r300' );            % resolution in dpi
    close (figure(100));
    end
end



% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in playMovie.
function playMovie_Callback(hObject, eventdata, handles)
% hObject    handle to playMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dlyrange = str2num(get(handles.edit8,'String'));
srcrange = str2num(get(handles.edit7,'String'));
dir_path = get(handles.edit6,'String');
nn = find(dir_path == '*');
dir_path = dir_path(1:nn-1);
fileprefix_curr = get(handles.edit9, 'String');
if ispc
    a = strrep([dir_path,'\',fileprefix_curr],'\','\\');
else %isunix
    a = strrep([dir_path,'/',fileprefix_curr],'/','//');
end

axes(handles.axes1);;

System = get(handles.figure1,'Userdata');

% 
% fileprefix_curr = get(handles.edit9, 'String');
% dir_path = get(handles.edit6,'String');
% nn = find(dir_path == '*');
% dir_path = dir_path(1:nn-1);
% 
% file = strrep([dir_path,'\',fileprefix_curr]);
CurrImage = plotRawImagenew_mk(srcrange,1,dlyrange,a,[],handles.axes1,get(handles.rebincheckbox,'Value'),get(handles.brightestpixels,'Value'));

% all_files = load(file);
Image_matrix(1,:,:,:)=CurrImage;
all_files.Image_matrix=Image_matrix;
clear Image_matrix;
%all_delay = 1:all_files.num_binFiles;
true_delay = str2num(get(handles.edit8,'String'));
axes(handles.axes1);

if get(handles.Normalize_Color,'Value')==1
    for i = 1:length(true_delay)
        Image = squeeze(all_files.Image_matrix(1,:,:,i));
        maxPixel(i) = max(Image(:));
    end
end

% Save movie
if get(handles.saveMovie,'Value')==1
    if length(true_delay) ==1   % Check if data is time resolved
        msgbox('Can not play. This is not a time resolved data.');
        return;
    end
    [fileprefix, path] = uiputfile('*.avi');
    if fileprefix == 0     %User didn't enter path/filename to save movie
        return;
    end
    AVI_file = ([path,fileprefix,'.avi']);
    writerObj = VideoWriter(AVI_file);
    writerObj.FrameRate = 10;
    open(writerObj);
    for i = 1:length(true_delay)
        frame = squeeze(all_files.Image_matrix(1,:,:,i))/max(max(squeeze(all_files.Image_matrix(1,:,:,i))));
        writeVideo(writerObj, frame);
    end
    close(writerObj);  
end
% end of save movie

for i = 1:length(true_delay)
    if get(hObject,'Value')~=0
        pause(0.1);
        imagesc(squeeze(all_files.Image_matrix(1,:,:,i))); set(gca,'YDir','normal'); 
        axis image; title(['Delay: ', num2str(true_delay(i))]);
        if get(handles.Normalize_Color,'Value')==1
            caxis([0 (max(maxPixel))]);
            set(handles.Coloraxis1,'String', 0);
            set(handles.Coloraxis2,'String',num2str(max(maxPixel)));
        else
            [m n] = caxis;
            set(handles.Coloraxis1,'String', m);
            set(handles.Coloraxis2,'String', n);
        end
        if get(handles.Jet_checkbox,'Value')==1
            colormap(jet);
        elseif get(handles.billsmap_checkbox,'Value')==1
            colormap(billsmap);
        else
            colormap(gray);
        end
    else
        break;
%         w = waitforbuttonpress;
%         if w == 1 && get(hObject,'Value')~=0
%             continue;
%         end
    end
end

% --- Executes on button press in Normalize_Color.
function Normalize_Color_Callback(hObject, eventdata, handles)
% hObject    handle to Normalize_Color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Normalize_Color


% --- Executes on button press in stopMovie.
function stopMovie_Callback(hObject, eventdata, handles)
% hObject    handle to stopMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
        set(handles.playMovie,'Value',0);
end


% --- Executes on button press in saveMovie.
function saveMovie_Callback(hObject, eventdata, handles)
% hObject    handle to saveMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveMovie


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save current workspace before proceeding
choice = questdlg('Save current workspace?', 'Save Analysis', 'Yes', 'No', 'No');
switch choice
    case 'Yes'
        pushbutton33_Callback(hObject, eventdata, handles);
    case 'No'
end
%%%%%%%%%%%%%%%%%%%

evalin('base','clear variables')
startingFolder = pwd;
% Get the name of the file that the user wants to use.
defaultFileName = fullfile(startingFolder, '*.mat*');
[baseFileName, folder] = uigetfile(defaultFileName, 'Select a file');
if baseFileName == 0
  % User clicked the Cancel button.
  return;
end
filename = [folder, baseFileName];
evalin('base', ['load(''', filename ''')']);
workspace_var = evalin('base','who');

handles.listbox6.String = [];
list = get(handles.listbox6,'String');
for i = 1:length(workspace_var)
    name = char(workspace_var(i));
    strName = evalin('base', name);
    if isstruct(strName)
        list{end+1} = [name, '_ImCW'];
        list{end+1} = [name, '_lmap'];
        set(handles.listbox6,'string',list);
    end
end




% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6

contents = get(hObject,'String');
fileprefix_curr = contents{get(hObject,'Value')};

if fileprefix_curr(end-3:end) == 'lmap'
    set(handles.uipanel5,'Visible','Off');
    set(handles.uipanel7,'Visible','On');
    set(handles.uipanel8,'Visible','Off');
    set(handles.togglebutton_CW_Intensity,'Value',0);
    set(handles.togglebutton_lifetime_image,'Value',1);
    set(handles.togglebutton_amplitude_image,'Value',0);
    axes(handles.axes6);
    lmap = evalin('base', [fileprefix_curr(1:end-5),'.lmap']);
    imagesc(lmap); axis image; set(gca,'YDir','normal'); colormap(jet);
    
elseif fileprefix_curr(end-3:end) == 'ImCW'
    set(handles.uipanel5,'Visible','On');
    set(handles.uipanel7,'Visible','Off');
    set(handles.uipanel8,'Visible','Off');
    set(handles.togglebutton_CW_Intensity,'Value',1);
    set(handles.togglebutton_lifetime_image,'Value',0);
    set(handles.togglebutton_amplitude_image,'Value',0); 
    axes(handles.axes1);
    CW = evalin('base', [fileprefix_curr(1:end-5),'.ImCW']);
    imagesc(CW); axis image; set(gca,'YDir','normal'); colormap(gray);
    
end

% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curr_dir=get(handles.edit6,'String');
if ~isempty(curr_dir)
    if curr_dir(end)=='*'
        curr_dir=curr_dir(1:end-1);
    end
    [getdir]=uigetdir(curr_dir);
else
    [getdir]=uigetdir(curr_dir);
end
cd (getdir);
filename = ['Analysis',datestr(now,'mmddyy_HHMM'),'.mat'];
evalin('base', ['save(''', filename ''')']);
cd (curr_dir);




% --- Executes during object creation, after setting all properties.
function uipanel15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
