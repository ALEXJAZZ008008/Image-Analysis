% Program_01

% Dicom Header Assessment

warning off

% Read header info for user selected image
[filename,pathname] = uigetfile('Images\*.*','Select Image File');
filein = [pathname,filename];
info = dicominfo(filein);

% Display image
original_image = double(dicomread(filein));
figure
imshow(original_image, [0 4000]);
title('Original Image')

% Output full header to command window
info

input('\nEnter to clear all variables and figures');

% clear all
% close all
