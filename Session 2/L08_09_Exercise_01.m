% L08_09_Exercise_01

% Image Segmentation

warning off

% Defaults for letter box extraction
low_r = 400;
high_r = 849;
low_c = 150;
high_c = 949;

% Read user selected water image
[filename,pathname] = uigetfile('Images\*.*','Select MR Image File (Water)');
filein = [pathname,filename];
water_image = double(dicomread(filein));

[filename,pathname] = uigetfile('Images\*.*','Select MR Image File (Fat)');
filein = [pathname,filename];
fat_image = double(dicomread(filein));

info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

figure
imshow(water_image, [0 4000]);
title('Water Only Image')
figure
imshow(fat_image, [0 4000]);
title('Fat Only Image')

pause

water_extract = water_image(low_r:high_r,low_c:high_c);
fat_extract = fat_image(low_r:high_r,low_c:high_c);
extract_sum = water_extract + fat_extract;
figure
imshow(extract_sum, [0 4000]);
title('Extracted Summed Image');

pause

mask_image = extract_sum>1000;
BW = bwlabel(mask_image);
most_common = mode(BW(:));
main_mask = (BW==most_common);
figure
imshow(main_mask, [0 1]);
title('Mask Image')

pause

% Organise data for input into fuzzy c-means
water_ROI = mat2gray(water_extract);
water_data = water_ROI(main_mask>0);

fat_ROI = mat2gray(fat_extract);
fat_data = fat_ROI(main_mask>0);

fcm_data = [fat_data water_data];

% Number of points to fuzzy cluster
num_pts = size(fcm_data,1);

for i=1:3

    % Number of clusters
    prompt = {'Enter number of clusters (default=3):'};
    dlg_title = 'Clusters';
    num_lines = 1;
    def = {'3'};
    answer = newid(prompt,dlg_title,num_lines,def);
    num_clusters = str2double(answer);

    % Fuzzy c-means clustering and membership considerations
    options = [2.0,100,1e-5,0];
    [center,member,objFcn] = fcm(fcm_data,num_clusters,options);

    figure
    plot(objFcn)
    title('Objective Function Values')
    titletext = sprintf('Objective Function Values for %d Clusters', num_clusters);
    title(titletext)
    xlabel('Iteration Count')
    ylabel('Objective Function Value')

    member=member';
    [max_vals, class_labels] = max(member,[],2);

    % Reassign pixels
    class_data = zeros(high_r-low_r+1,high_c-low_c+1);
    [row,col] = find(main_mask);  
    for k=1:num_pts
        class_data(row(k),col(k)) = class_labels(k);
    end   

%   Display cluster image
    hToolFig = imtool(class_data);
    titletext = sprintf('%d Clusters', num_clusters);
    set(hToolFig, 'Name', titletext);
    
    pause
    
end

%clear all
%close all

clc
