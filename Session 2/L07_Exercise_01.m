% L07_Exercise_01

% Mean and median filtering

warning off

% Read header info for user selected image
[filename,pathname] = uigetfile('Images\*.*','Select MR Image File');
filein = [pathname,filename];
info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

original_image = double(dicomread(filein));
figure
imshow(original_image, [0 4000]);
title('Original Image')

pause

% Mean filtering
intImage = integralImage(original_image);

for i=1:3

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
    figure
    imshow(mean_filt_image, [0 4000]);
    titletext = sprintf('Mean Filtered Image using %dx%d Filter ', filt_size, filt_size);
    title(titletext)
    
    mean_filt_temp = zeros(dim(1),dim(2));
    index_offset = (filt_size+1)/2;
    mean_filt_temp(index_offset:end-index_offset+1,index_offset:end-index_offset+1) = mean_filt_image;
    difference_image = original_image - mean_filt_temp;    
    figure
    imshow(difference_image, [-1000 1000]);
    titletext = sprintf('Difference Image using %dx%d Mean Filter ', filt_size, filt_size);
    title(titletext)
    
    clear mean_filt_image
    
    pause
    
end
    
% Median filtering   
for i=1:3

    % Input size of filter
    prompt = {'Enter size of median filter (odd number):'};
    dlg_title = 'Filter size';
    num_lines = 1;
    def = {'3'};
    answer = newid(prompt,dlg_title,num_lines,def);
    filt_size = str2double(answer);

    median_filt_image = medfilt2(original_image, [filt_size filt_size]);    
    figure
    imshow(median_filt_image, [0 4000]);
    titletext = sprintf('Median Filtered Image using %dx%d Filter ', filt_size, filt_size);
    title(titletext)
    
    difference_image = original_image - median_filt_image;    
    figure
    imshow(difference_image, [-1000 1000]);
    titletext = sprintf('Difference Image using %dx%d Median Filter ', filt_size, filt_size);
    title(titletext)

    pause
    
end

%clear all

clc
