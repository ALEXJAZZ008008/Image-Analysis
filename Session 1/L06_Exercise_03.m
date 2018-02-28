% L06_Exercise_03

% Run length encoding (image and mask)

warning off;

% Read user selected image in
[filename,pathname] = uigetfile('Images\*.*','Select MR Image File');
filein = [pathname,filename];

info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

original_image = double(dicomread(filein));
fclose('all');

% Display image
figure
imshow(original_image, [0 4000]);
title('Original Image')

% Create and display mask
mask_image = original_image>500;
figure
imshow(mask_image, [0 1]);
title('Mask Image')

% input('\nEnter to continue');

pause

% Reshape to 1D matrices
image_to_RLE = original_image(:)';
mask_to_RLE = mask_image(:)';

% Determine length of array
original_array_size = size(image_to_RLE,2);

% Start first counts
RLE_image(1) = 1;
RLE_mask(1) = 1;
% First values encountered
RLE_image(2) = image_to_RLE(1);
RLE_mask(2) = mask_to_RLE(1);

% Initialise run numbers
image_run_number = 1;
mask_run_number = 1;

% Run length encode array
for i=2:original_array_size
    % If image value same as previous
    if image_to_RLE(i)==RLE_image(image_run_number*2),
        RLE_image(2*image_run_number-1) = RLE_image(2*image_run_number-1) + 1;
    % If image value different from previous
    else
        image_run_number = image_run_number + 1;
        RLE_image(2*image_run_number-1) = 1;
        RLE_image(2*image_run_number) = image_to_RLE(i);
    end
    % If mask value same as previous
    if mask_to_RLE(i)==RLE_mask(mask_run_number*2),
        RLE_mask(2*mask_run_number-1) = RLE_mask(2*mask_run_number-1) + 1;
    % If mask value different from previous
    else
        mask_run_number = mask_run_number + 1;
        RLE_mask(2*mask_run_number-1) = 1;
        RLE_mask(2*mask_run_number) = mask_to_RLE(i);
    end
end

% Determine length of RLE arrays
RLE_image_size = size(RLE_image,2);
RLE_mask_size = size(RLE_mask,2);

% Determine compression ratios
RLE_image_CR = original_array_size/RLE_image_size;
RLE_mask_CR = original_array_size/RLE_mask_size;

% Display results
message = sprintf('Original image size: %d', original_array_size);
message = char(message, sprintf(''));
message = char(message, sprintf('RLE image size: %d', RLE_image_size));
message = char(message, sprintf('RLE mask size: %d', RLE_mask_size));
message = char(message, sprintf(''));
message = char(message, sprintf('RLE image CR: %.2f', RLE_image_CR));
message = char(message, sprintf('RLE mask CR: %.2f', RLE_mask_CR));
hd = msgbox(cellstr(message), 'Run length encoding comparison');
set(hd, 'position', [300 300 300 150]);

% input('\nEnter to finish');

pause

clear all
close all

clc

