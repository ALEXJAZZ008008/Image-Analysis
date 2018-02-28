% L03_Exercise_03

% Point Operations

warning off

% Read user selected image in
[filename,pathname] = uigetfile('Images\*.*','Select Image File');
filein = [pathname,filename];

info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

original_image = double(dicomread(filein));
fclose('all');

figure
imshow(original_image, [0 4000]);
title('Original Image')

figure
histogram(original_image, 256);
title('Image Histogram (Original)')

% input('\nEnter to continue');

pause

% Display image negative
max_int = max(original_image(:));
negative_image = max_int - original_image;
figure
imshow(negative_image, [0 10000]);
title('Negative Image')

figure
histogram(negative_image, 256);
title('Image Histogram (Negative)')

% input('\nEnter to continue');

pause

% Display log image
log_image = log(original_image);
figure
imshow(log_image, [0 10]);
title('Log Image')

figure
histogram(log_image, 256);
title('Image Histogram (Log)')

% input('\nEnter to continue');

pause

% Display clipped image
imtool(original_image, [0 max_int]);
title('Image Clipping')

% input('\nEnter to continue');

pause

% HE image generation

% Input number of grey levels
prompt = {'Enter number of grey levels:'};
dlg_title = 'Grey levels';
num_lines = 1;
def = {'32'};
answer = newid(prompt,dlg_title,num_lines,def);
num_grey = str2double(answer);

figure
h = histogram(original_image, max_int+1, 'Normalization','cdf');
title('Cumulative Histogram')
cum_hgram = h.Values;

% input('\nEnter to continue');

pause

% Create look up table
look_up = zeros(1,max_int+1);

% Start at grey level of zero
gry_lvl = 0;

% Fills look up table
% Attempts to place equal number 
% of pixels in each final bin
% Loops through all possible intensities
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

% Create HE array image
equalised_image = zeros(dim(1),dim(2));

% Loop through image
for x=1:dim(1)
    for y=1:dim(2)
        equalised_image(x,y) = look_up(original_image(x,y)+1);    
    end
end

% Display HE image

figure
imshow(equalised_image, [0 num_grey-1]);
title('Histogram Equalised Image')

% figure
% histogram(equalised_image, num_grey);
% title('Image Histogram (Equalised)')

input('\nEnter to finish');

clear all
close all

clc