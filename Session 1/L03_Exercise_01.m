% L03_Exercise_01

% Thresholding

warning off

% Otsu thresholding of coin image
I = imread('coins.png');
figure
imshow(I);
title('Original Image')

% input('\nEnter to continue');

pause

% Display histogram
figure
I_hist = histogram(I,128);
title('Image Histogram')

% input('\nEnter to continue');

pause

% Otsu thresholding
level = graythresh(I);
I_Otsu = im2bw(I,level);
figure
imshow(I_Otsu);
titletext = sprintf('Otsu Thresholded Image (Level = %.3f)', level);
title(titletext)

% input('\nEnter to continue');

pause

for i=1:100

    prompt = {'Enter threshold value required (0-1):'};
    dlg_title = 'Threshold Value';    
    num_lines = 1;
    def = {'0.5'};
    answer = newid(prompt,dlg_title,num_lines,def);
    thresh = str2double(answer);

    % Threshold image with user value
    I_user = im2bw(I,thresh);
    figure
    imshow(I_user);
    titletext = sprintf('User Thresholded Image (Level = %.3f)', thresh);
    title(titletext)
    
%     input('\nEnter to continue');

    pause
    
end

input('\nEnter to finish');

clear all
close all

clc