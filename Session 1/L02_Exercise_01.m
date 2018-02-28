% L02_Exercise_01

% Dicom Headers (MRI)

warning off

% Read header info for user selected image
[filename,pathname] = uigetfile('Images\*.*','Select MR Image File');
filein = [pathname,filename];
info = dicominfo(filein);

original_image = double(dicomread(filein));
figure
imshow(original_image, [0 4000]);
title('Original Image')

% Extract relevant header information
modality = info.Modality;

num_x = info.Height;
num_y = info.Width;
num_z = info.ImagesInAcquisition;
image_number = info.InstanceNumber;

FOV = info.ReconstructionDiameter;
slice_thickness = info.SliceThickness;

field_strength = info.MagneticFieldStrength;
scanner_type = info.ManufacturerModelName;

% Display results
message = sprintf('Modality: %s', modality);
message = char(message, sprintf(''));
message = char(message, sprintf('Data size: %d by %d by %d', num_x, num_y, num_z));
message = char(message, sprintf('Slice number: %d', image_number));
message = char(message, sprintf('Field of view: %d mm', FOV));
message = char(message, sprintf('Slice thickness: %d mm', slice_thickness));
message = char(message, sprintf(''));
message = char(message, sprintf('Field strength: %.1f T', field_strength));
message = char(message, sprintf('Scanner type: %s', scanner_type));
hd = msgbox(cellstr(message), 'Selected header information');
set(hd, 'position', [300 300 250 150]);

% input('\nEnter to continue');

pause

info

input('\nEnter to finish');

%clear all
%close all

clc
