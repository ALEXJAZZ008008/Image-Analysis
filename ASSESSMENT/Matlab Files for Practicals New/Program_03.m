function varargout = Program_03(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Program_03_OpeningFcn, ...
                   'gui_OutputFcn',  @Program_03_OutputFcn, ...
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


% --- Executes just before Program_03 is made visible.
function Program_03_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Program_03_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --------------------------------------------------------------------
function LoadImage_Callback(hObject, eventdata, handles)

% Read header info for user selected image
[filename,pathname] = uigetfile('Images\*.*','Select Image File');
filein = [pathname,filename];
info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

% Read image in
image_data = double(dicomread(filein));

% Find maximum value in image
max_data = max(image_data(:));

% Define window width slider
hw = handles.WindowWidth;
set(hw, 'visible', 'on');
set(hw, 'min', 1);
set(hw, 'max', max_data);
set(hw, 'value', max_data);
set(hw, 'sliderstep', [1/max_data 0.02]);

% Define window level slider
hl = handles.WindowLevel;
set(hl, 'visible', 'on');
set(hl, 'min', 0);
set(hl, 'max', max_data);
set(hl, 'value', fix(max_data/2));
set(hl, 'sliderstep', [1/max_data 0.02]);

% Define threshold slider (default value of zero is no filtering) 
ts = handles.ThresholdLevel;
set(ts, 'visible', 'on');
set(ts, 'min', 0);
set(ts, 'max', 5000);
set(ts, 'value', 0);
set(ts, 'sliderstep', [1/5000 0.02]);

% Display image
set(handles.ImageDisplay, 'XLim', [0.5 dim(1)+0.5]);
set(handles.ImageDisplay, 'YLim', [0.5 dim(2)+0.5]);

axes(handles.ImageDisplay);
imshow(image_data, [0 max_data]);

% Make all functionality visible
set(handles.LevelText, 'visible', 'on');
set(handles.WidthText, 'visible', 'on');
set(handles.ThresholdText, 'visible', 'on');
set(handles.SelectTumour, 'visible', 'on');
set(handles.ParamCalc, 'visible', 'on');

% Declare ROI arrays
threshold_data = zeros(dim(1),dim(2));
ROI_data = zeros(dim(1),dim(2));

handles.dim = dim;
handles.image_data = image_data;
handles.threshold_data = threshold_data;
handles.ROI_data = ROI_data;

guidata(hObject,handles);


% --- Executes on slider movement.
function WindowLevel_Callback(hObject, eventdata, handles)

image_data = handles.image_data;
threshold_data = handles.threshold_data;

wwidth = fix(get(handles.WindowWidth, 'value'));
wlevel = fix(get(hObject, 'value'));
axes(handles.ImageDisplay);
imshow (image_data, [fix(wlevel-wwidth/2) fix(wlevel+wwidth/2)]);
showMaskAsOverlay(0.4,threshold_data);

locstr = sprintf('Window level (%d)', wlevel);
hd = handles.LevelText;
set(hd,'String',locstr);

clear wwidth wlevel;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function WindowLevel_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function LevelText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String', 'Window Level');


% --- Executes on slider movement.
function WindowWidth_Callback(hObject, eventdata, handles)

image_data = handles.image_data;
threshold_data = handles.threshold_data;

wwidth = fix(get(hObject, 'value'));
wlevel = fix(get(handles.WindowLevel, 'value'));
axes(handles.ImageDisplay);
imshow (image_data, [fix(wlevel-wwidth/2) fix(wlevel+wwidth/2)]);
showMaskAsOverlay(0.4,threshold_data);

locstr = sprintf('Window width (%d)', wwidth);
hd = handles.WidthText;
set(hd,'String',locstr);

clear wwidth wlevel;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function WindowWidth_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function WidthText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String', 'Window Width');


% --- Executes on slider movement.
function ThresholdLevel_Callback(hObject, eventdata, handles)

image_data = handles.image_data;

% Get new threshold value
thresh_val = fix(get(hObject, 'value'));

% Apply threshold and refresh display
wwidth = fix(get(handles.WindowWidth, 'value'));
wlevel = fix(get(handles.WindowLevel, 'value'));
axes(handles.ImageDisplay);
imshow (image_data, [fix(wlevel-wwidth/2) fix(wlevel+wwidth/2)]);
threshold_data = (image_data>thresh_val);
showMaskAsOverlay(0.4,threshold_data);

% Update threshold text
locstr = sprintf('Threshold Value (%d)', thresh_val);
hd = handles.ThresholdText;
set(hd,'String',locstr);

handles.thresh_val = thresh_val;
handles.threshold_data = threshold_data;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function ThresholdLevel_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function ThresholdText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String', 'Threshold');


% --- Executes on button press in SelectTumour.
function SelectTumour_Callback(hObject, eventdata, handles)

image_data = handles.image_data;
threshold_data = handles.threshold_data;
dim = handles.dim;

wwidth = fix(get(handles.WindowWidth, 'value'));
wlevel = fix(get(handles.WindowLevel, 'value'));
axes(handles.ImageDisplay);
h = imshow(image_data, [fix(wlevel-wwidth/2) fix(wlevel+wwidth/2)]);
showMaskAsOverlay(0.4,threshold_data);

p = ginput(1);
initPos(1) = round(axes2pix(dim(2), get(h, 'XData'), p(2)));
initPos(2) = round(axes2pix(dim(1), get(h, 'YData'), p(1)));

ROI_labels = bwlabel(threshold_data,4);
ROI_val = ROI_labels(initPos(1),initPos(2));
ROI_data  = (ROI_labels>(ROI_val-1)).*(ROI_labels<(ROI_val+1));

imshow(image_data, [fix(wlevel-wwidth/2) fix(wlevel+wwidth/2)]);
showMaskAsOverlay(0.4,ROI_data);

handles.ROI_data = ROI_data;

guidata(hObject,handles);

% --- Executes on button press in ParamCalc.
function ParamCalc_Callback(hObject, eventdata, handles)

image_data = handles.image_data;
ROI_data = handles.ROI_data;
dim = handles.dim;
thresh_val = handles.thresh_val;

num_pts = sum(ROI_data(:));

if num_pts==0,
    
    message = sprintf('Shape Analysis Results');
    message = char(message, sprintf(''));
    message = char(message, sprintf('ROI area is zero!'));
    hd = msgbox(cellstr(message), 'Calculation Error');
    set(hd, 'position', [300 300 300 50]);

else
    
    % Calculate elongatedness, convexity, circularity
    bw_image = ROI_data>0;
    shape_info = regionprops(bw_image, 'Area', 'ConvexHull', 'BoundingBox');
    circle_area = shape_info.Area;
    box_width = shape_info.BoundingBox(3);
    box_length = shape_info.BoundingBox(4);
    elongatedness = box_length/box_width;
    
    white_image = ones(dim(1),dim(2));
    [~,convex_hull_image] = roifill(white_image, shape_info.ConvexHull(:,1), shape_info.ConvexHull(:,2));
    circle_convex_hull = sum(convex_hull_image(:));
    convexity = 100*circle_area/circle_convex_hull;
    
    perim_sum = 0;
    bw_perim = bwperim(ROI_data,4);
    
    for i=1:dim(1)
        for j=1:dim(2)
            if bw_perim(i,j)==1,
                test_sum = 4 - (bw_image(i,j-1)+bw_image(i+1,j)+bw_image(i,j+1)+bw_image(i-1,j));
                if test_sum == 1, perim_sum = perim_sum + 1; end
                if test_sum == 2, perim_sum = perim_sum + sqrt(2); end
                if test_sum == 3, perim_sum = perim_sum + 1 + sqrt(2); end
            end
        end
    end

    circle_perimeter = perim_sum;
    circularity = 4*pi*circle_area/(circle_perimeter*circle_perimeter);
    
    message = sprintf('Shape Analysis Results');
    message = char(message, sprintf(''));
    message = char(message, sprintf('Threshold value of %d', thresh_val));
    message = char(message, sprintf('ROI area is %d pixels', num_pts));
    message = char(message, sprintf('Circularity is %.3f', circularity));
    message = char(message, sprintf('Convexity is %.1f percent', convexity));
    message = char(message, sprintf('Elongatedness is %.3f', elongatedness));
    hd = msgbox(cellstr(message), 'Data Analysis');
    set(hd, 'position', [300 300 350 100]);
    
end


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)

clear, close all;
