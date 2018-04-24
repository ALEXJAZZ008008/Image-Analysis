% Program_05

% Texture Analysis

warning off;

% Prompt user for selected filename
[filename,pathname] = uigetfile('Images\*.*','Select Image File');
filein = [pathname,filename];
file_text = filename(end-5:end);

% Read header information
file = sprintf('%s%s',char(filein));
info = dicominfo(file);
dim = [double(info.Width), double(info.Height)];

% Declare image array size
image_data = zeros(dim(1),dim(2));

% Read in image
filetoread = sprintf('%s%s',char(filein));
image_data(:,:)=double(dicomread(filetoread));
fclose('all');

% Read in ROI file   
ROIfilename = strcat(filename, '.rgn');
ROIfile = [pathname,ROIfilename];
fid = fopen(ROIfile, 'r');

white_image = ones(dim(1),dim(2));
mask_data = zeros(dim(1),dim(2));

numROIs = fread(fid, 1, 'int16', 'b');

slice = fread(fid, 1, 'int16', 'b');
numpts = fread(fid, 1, 'int16', 'b');
data_pts = fread(fid, 2*numpts, 'float32', 'b');
[~,temp] = roifill(white_image, data_pts(1:2:end), dim(2) - data_pts(2:2:end));
mask_data = mask_data + temp; 

% Maximum intensity in image
max_int = max(image_data(:));

% Display image and mask
imshow(image_data, [0 max_int]);
showMaskAsOverlay(0.3,mask_data);
titletext = sprintf('ROI overlay for %s', file_text);
title(titletext)

% Input number of grey levels required
prompt = {'Enter num grey levels:'};
dlg_title = 'Grey levels';
num_lines = 1;
def = {'32'};
answer = newid(prompt,dlg_title,num_lines,def);
num_grey = str2double(answer);

% Histogram equalisation
image_roi = mask_data.*image_data;     
max_int = max(image_roi(:));
hgram = zeros(1,max_int+1); 
roi_size = sum(mask_data(:));

for x=1:dim(1)
    for y=1:dim(2)
        if mask_data(x,y) == 1, 
            hgram(image_data(x,y)+1) = hgram(image_data(x,y)+1)+1;
        end
    end
end

norm_hgram = hgram/roi_size;
cum_hgram = cumsum(norm_hgram);
look_up = zeros(1,max_int+1);
gry_lvl = 0;

for i=1:max_int+1
    if cum_hgram(i) > 1
        look_up(i) = gry_lvl;
    elseif cum_hgram(i) <= (gry_lvl+1)/num_grey
        look_up(i) = gry_lvl;
    else
        gry_lvl = gry_lvl+1;
        look_up(i) = gry_lvl;
    end
end

equalised_data = zeros(dim(1),dim(2));

image_data(image_data>max_int)=max_int;

for x=1:dim(1)
    for y=1:dim(2)
        if mask_data(x,y) == 1, equalised_data(x,y) = look_up(image_data(x,y)+1);
        else equalised_data(x,y) = NaN;
        end
    end
end

% Calculate sample texture parameters with histogram equalisation
GLCM_HE = graycomatrix(equalised_data,'NumLevels',num_grey,'GrayLimits', [0 num_grey-1],'Offset',[0 1]);
GLCM_HE = GLCM_HE/sum(GLCM_HE(:));

% Calculate f1 - ANGULAR SECOND MOMENT
ASM = sum(sum(GLCM_HE.*GLCM_HE));

% Calculate f9 - ENTROPY
ENT_HE = GLCM_HE.*log2(GLCM_HE);
ENT_HE(isnan(ENT_HE))=0;
Entropy = -sum(sum(ENT_HE));

% Display results
message = sprintf('');
message = char(message, sprintf('Results for %s', file_text));
message = char(message, sprintf(''));
message = char(message, sprintf('Angular Second Moment = %.4f', ASM));
message = char(message, sprintf('Entropy = %.4f', Entropy));
titletext = sprintf('Texture results for %d grey levels', num_grey);
hd = msgbox(cellstr(message), titletext);
set(hd, 'position', [300 300 300 100]);

clear all
close all