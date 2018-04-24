% Program_04

% Image Segmentation using Clustering

warning off

% Read images
[filename,pathname] = uigetfile('Images\*.*','Select Pre-Contrast Image');
filein = [pathname,filename];
pre_contrast = double(dicomread(filein));

[filename,pathname] = uigetfile('Images\*.*','Select Post-Contrast Image');
filein = [pathname,filename];
post_contrast = double(dicomread(filein));

info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];
FOV = double(info.ReconstructionDiameter);
slice_thk = double(info.SliceThickness);

figure
imshow(pre_contrast, [0 6000]);
title('Pre-Contrast Image')
figure
imshow(post_contrast, [0 6000]);
title('Post-Contrast Image')

% Read in ROI file   
ROIfilename = strcat(filename, '.rgn');
ROIfile = [pathname,ROIfilename];
fid = fopen(ROIfile, 'r');

white_image = ones(dim(1),dim(2));
mask_data = zeros(dim(1),dim(2));

numROIs = fread(fid, 1, 'int16', 'b');

slice = fread(fid, 1, 'int16', 'b');
numpts = fread(fid, 1, 'int16', 'b');
data_pts = fread(fid, 2*numpts, 'float32', 'b');
[~,temp] = roifill(white_image, data_pts(1:2:end), dim(2) - data_pts(2:2:end));
mask_data = mask_data + temp; 

% Organise data for input into fuzzy c-means
pre_ROI = mat2gray(pre_contrast);
pre_data = pre_ROI(mask_data>0);

post_ROI = mat2gray(post_contrast);
post_data = post_ROI(mask_data>0);

fcm_data = [post_data pre_data];

% Number of points to fuzzy cluster
num_pts = size(fcm_data,1);

% Number of clusters
prompt = {'Enter number of clusters (default=2):'};
dlg_title = 'Clusters';
num_lines = 1;
def = {'2'};
answer = newid(prompt,dlg_title,num_lines,def);
num_clusters = str2double(answer);

% Declare results array
class_data = zeros(dim(1),dim(2));

% Fuzzy c-means clustering and membership considerations
options = [2.0,100,1e-5,0];
[center,member,objFcn] = fcm(fcm_data,num_clusters,options);

member=member';
[max_vals, class_labels] = max(member,[],2);

% Reassign pixels
[row,col] = find(mask_data);  
for k=1:num_pts
    class_data(row(k),col(k)) = class_labels(k);
end

% Read in stripped ROI file   
ROIfilename = strcat(filename, '1.rgn');
ROIfile = [pathname,ROIfilename];
fid = fopen(ROIfile, 'r');

stripped_mask_data = zeros(dim(1),dim(2));

numROIs = fread(fid, 1, 'int16', 'b');

slice = fread(fid, 1, 'int16', 'b');
numpts = fread(fid, 1, 'int16', 'b');
data_pts = fread(fid, 2*numpts, 'float32', 'b');
[~,temp] = roifill(white_image, data_pts(1:2:end), dim(2) - data_pts(2:2:end));
stripped_mask_data = stripped_mask_data + temp; 

final_class_data = class_data.*stripped_mask_data;

figure
imshow(final_class_data, [0 num_clusters]);
title('Cluster Image')

sum_clusters = zeros(1,num_clusters);
vol_clusters = zeros(1,num_clusters);

for i=1:num_clusters
    sum_clusters(i) = sum(sum(final_class_data==i));
    vol_clusters(i) = sum_clusters(i)*(FOV/dim(1))*(FOV/dim(2))*slice_thk;
end

% Display results
message = sprintf('');
message = char(message, sprintf('Results for %d clusters', num_clusters));
message = char(message, sprintf(''));
for i=1:num_clusters
    message = char(message, sprintf('Cluster %d volume is %.1f mm3', i, vol_clusters(i)));
end
hd = msgbox(cellstr(message), 'k Means Clustering');
set(hd, 'position', [300 300 350 150]);
    
