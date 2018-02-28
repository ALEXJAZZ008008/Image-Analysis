% L02_Exercise_02

% Dicom Headers (CT)

warning off

% Read header info for user selected image
[filename,pathname] = uigetfile('Images\*.*','Select CT Image File');
filein = [pathname,filename];
info = dicominfo(filein);

original_image = double(dicomread(filein));
figure
imshow(original_image, [0 20000]);
title('Original Image')

% Extract relevant header information
modality = info.Modality;

num_x = info.Height;
num_y = info.Width;
image_number = info.InstanceNumber;

FOV = info.DataCollectionDiameter;
slice_thickness = info.SliceThickness;

scanner_type = info.ManufacturerModelName;

KVP = info.KVP;
Current = info.XrayTubeCurrent;
Time = info.ExposureTime;

% Display results
message = sprintf('Modality: %s', modality);
message = char(message, sprintf(''));
message = char(message, sprintf('Data size: %d by %d', num_x, num_y));
message = char(message, sprintf('Slice number: %d', image_number));
message = char(message, sprintf('Field of view: %d mm', FOV));
message = char(message, sprintf('Slice thickness: %.3f mm', slice_thickness));
message = char(message, sprintf(''));
message = char(message, sprintf('Scanner type: %s', scanner_type));
message = char(message, sprintf(''));
message = char(message, sprintf('Peak kilovoltage: %d kVp', KVP));
message = char(message, sprintf('Current: %d mA', Current));
message = char(message, sprintf('Exposure time: %d ms', Time));
hd = msgbox(cellstr(message), 'Selected header information');
set(hd, 'position', [300 300 250 200]);

% input('\nEnter to continue');

pause

info

input('\nEnter to finish');

clear all
close all

clc
