% L04_Exercise_02

% Fourier Filtering of Images

warning off

% Read user selected image in
[filename,pathname] = uigetfile('Images\*.*','Select Image File');
filein = [pathname,filename];

info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

original_image = double(dicomread(filein));
fclose('all');

% Display image
hToolFig = imtool(original_image);
set(hToolFig, 'Name', 'Original Image');

% FT image and display k-space data
kspace_image = fft2(original_image);
kspace_image = fftshift(kspace_image);
freq_domain_image = abs(kspace_image);
hToolFig = imtool(freq_domain_image);
set(hToolFig, 'Name', 'Frequency Domain Image');

% input('\nEnter to continue');

pause

% Display natural log of k-space data
log_freq_domain_image = log(freq_domain_image+1);
hToolFig = imtool(log_freq_domain_image);
set(hToolFig, 'Name', 'Log Frequency Domain Image');

% input('\nEnter to continue');

pause

% Prompt user for filtering options
prompt = {'Filter centre (0) or periphery of k-space (1):'};
dlg_title = 'Region to Filter';
num_lines = 1;
def = {'1'};
answer = newid(prompt,dlg_title,num_lines,def);
region_to_filter = str2double(answer);

prompt = {'Enter percentage of k-space to filter (0-100%):'};
dlg_title = 'Percentage of k-space';
num_lines = 1;
def = {'0'};
answer = newid(prompt,dlg_title,num_lines,def);
filter_percentage = str2double(answer);

% Remove central data if appropriate
if region_to_filter == 0,
    size_to_remove = floor(dim*filter_percentage/100);
    low_y = floor((dim(1)-size_to_remove(1))/2 + 1);
    high_y = floor((dim(1)+size_to_remove(1))/2);
    low_x = floor((dim(2)-size_to_remove(2))/2 + 1);
    high_x = floor((dim(2)+size_to_remove(2))/2);
    kspace_image(low_y:high_y,low_x:high_x) = 0;
end

% Remove peripheral data if appropriate
if region_to_filter == 1,
    size_to_remove = floor(dim*filter_percentage/100);
    low_y = floor(size_to_remove(1)/2);
    high_y = floor((dim(1)-size_to_remove(1)/2)+1);
    low_x = floor(size_to_remove(2)/2);
    high_x = floor((dim(2)-size_to_remove(2)/2)+1);
    kspace_image(1:low_y,:) = 0;
    kspace_image(high_y:end,:) = 0;
    kspace_image(:,1:low_x) = 0;
    kspace_image(:,high_x:end) = 0;
end

% Display filtered data
filtered_freq_domain_image = abs(kspace_image);
log_filtered_freq_domain_image = log(filtered_freq_domain_image+1);
hToolFig = imtool(log_filtered_freq_domain_image);
set(hToolFig, 'Name', 'Log Filtered Frequency Domain Image');

% input('\nEnter to continue');

pause

% Display image after filtering of k-space
filtered_image = ifft2(kspace_image);
filtered_image = abs(filtered_image);
hToolFig = imtool(filtered_image);
set(hToolFig, 'Name', 'Filtered Image');

% input('\nEnter to continue');

pause

% Display subtracted image
subtracted_image = filtered_image - original_image;
hToolFig = imtool(subtracted_image);
set(hToolFig, 'Name', 'Subtracted Image');

input('\nEnter to finish');

clear all
close all

clc
