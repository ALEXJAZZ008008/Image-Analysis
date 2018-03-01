% L07_Exercise_02

% Mean and median filtering (noisy image)
% Image sharpening

warning off

% Read header info for user selected image
[filename,pathname] = uigetfile('Images\*.*','Select MR Image File');
filein = [pathname,filename];
info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];
original_image = double(dicomread(filein));

% Input noise level required
prompt = {'Enter noise level (%):'};
dlg_title = 'Noise level';
num_lines = 1;
def = {'2'};
answer = newid(prompt,dlg_title,num_lines,def);
noise_percent = str2double(answer);

noisy_image = zeros(dim(1),dim(2));

% Generate noise for individual image points
% Noise will be between -1 and +1
noise_mask = 2*(rand(dim(1),dim(2))-0.5);
% Scale by appropriate percentage
for i=1:dim(1)
    for j=1:dim(2)
        noisy_image(i,j) = original_image(i,j)*(1 + noise_mask(i,j)*noise_percent/100);
    end
end
noisy_image = noisy_image.*(noisy_image>0);

hToolFig = imtool(noisy_image);
set(hToolFig, 'Name', 'Original Image with Added Noise');

pause

% Mean filtering
intImage = integralImage(noisy_image);

% Input size of filter
prompt = {'Enter size of mean filter (odd number):'};
dlg_title = 'Filter size';
num_lines = 1;
def = {'3'};
answer = newid(prompt,dlg_title,num_lines,def);
filt_size = str2double(answer);
    
avgH = integralKernel([1 1 filt_size filt_size], 1/(filt_size*filt_size));
mean_filt_image = integralFilter(intImage, avgH);
mean_filt_image = double(mean_filt_image);
hToolFig = imtool(mean_filt_image);
set(hToolFig, 'Name', 'Mean Filtered Image');
    
mean_filt_temp = zeros(dim(1),dim(2));
index_offset = (filt_size+1)/2;
mean_filt_temp(index_offset:end-index_offset+1,index_offset:end-index_offset+1) = mean_filt_image;
difference_image_mean = noisy_image - mean_filt_temp;    
hToolFig = imtool(difference_image_mean);
set(hToolFig, 'Name', 'Difference Image using Mean Filtering');

pause
    
% Median filtering   

% Input size of filter
prompt = {'Enter size of median filter (odd number):'};
dlg_title = 'Filter size';
num_lines = 1;
def = {'3'};
answer = newid(prompt,dlg_title,num_lines,def);
filt_size = str2double(answer);

median_filt_image = medfilt2(noisy_image, [filt_size filt_size]);    
hToolFig = imtool(median_filt_image);
set(hToolFig, 'Name', 'Median Filtered Image');
    
difference_image_median = noisy_image - median_filt_image;    
hToolFig = imtool(difference_image_median);
set(hToolFig, 'Name', 'Difference Image using Median Filtering');

pause

% Input k-factor
prompt = {'Enter multiplication factor for image sharpening (0-1):'};
    dlg_title = 'k-factor';
    num_lines = 1;
    def = {'0.2'};
    answer = newid(prompt,dlg_title,num_lines,def);
    k_factor = str2double(answer);

sharpened_image_mean = original_image + k_factor*difference_image_mean;
hToolFig = imtool(sharpened_image_mean);
set(hToolFig, 'Name', 'Sharpened Image using Mean Filtering');

sharpened_image_median = original_image + k_factor*difference_image_median;
hToolFig = imtool(sharpened_image_median);
set(hToolFig, 'Name', 'Sharpened Image using Median Filtering');

%clear all

clc
