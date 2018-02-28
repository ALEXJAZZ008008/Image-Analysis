% L06_Exercise_01

% Image Compression using Zip

warning off

% Read in MR image dataset
[filename,pathname] = uigetfile('Images\MR Series\*.*','Select All Image Files', 'MultiSelect','On');
filesin = [pathname,filename];

file1 = sprintf('%s%s',char(filesin(1)),char(filesin(2)));
info = dicominfo(file1);
dim = [double(info.Width), double(info.Height)];
dim(3) = size(filesin,2)-1;

image_data = zeros(dim(1),dim(2),dim(3));

for i=1:dim(3)
    filetoread = sprintf('%s%s',char(filesin(1)),char(filesin(i+1)));
    image_data(:,:,i)=double(dicomread(filetoread));
end

figure
for i=1:15
    subplot(3,5,i), imshow(image_data(:,:,(i-1)*3+1),[0 4000]);
    hT1 = title(num2str((i-1)*3+1));
    if i==13,
        [HeightA,~,~] = size(image_data(:,:,i));
        T1Pos = round(get(hT1,'Position'));
        hT1_2 = text(T1Pos(1), T1Pos(2)+HeightA+200,'Original Images','HorizontalAlignment','center');
    end
end

% Calculate dataset sizes in bytes
s = dir(file1);
num_bytes_images = s.bytes*dim(3);

num_bytes_image_data = size(image_data,1)*size(image_data,2)*size(image_data,3)*2;

% Compress images using zip
foldertocompress = sprintf('%s',char(filesin(1)));
zip('image_data.zip',foldertocompress);
s = dir('image_data.zip');
num_bytes_compressed_images = s.bytes;

CR_images = num_bytes_images/num_bytes_compressed_images;

fclose('all');

% Display results
message = sprintf('Size of images on disk: %d bytes', num_bytes_images);
message = char(message, sprintf('Size of images (no header info): %d bytes', num_bytes_image_data));
message = char(message, sprintf(''));
message = char(message, sprintf('Size of compressed images: %d bytes', num_bytes_compressed_images));
message = char(message, sprintf(''));
message = char(message, sprintf('Compression ratio for images: %.2f', CR_images));
hd = msgbox(cellstr(message), 'Compression information (images)');
set(hd, 'position', [300 300 300 100]);

% input('\nEnter to continue');

pause

% Read in MR mask dataset
[filename,pathname] = uigetfile('Images\MR Series (Masks)\*.*','Select All Image Files', 'MultiSelect','On');
filesin = [pathname,filename];

file1 = sprintf('%s%s',char(filesin(1)),char(filesin(2)));
info = dicominfo(file1);
dim = [double(info.Width), double(info.Height)];
dim(3) = size(filesin,2)-1;

mask_data = zeros(dim(1),dim(2),dim(3));

for i=1:dim(3)
    filetoread = sprintf('%s%s',char(filesin(1)),char(filesin(i+1)));
    mask_data(:,:,i)=double(dicomread(filetoread));
end

figure
for i=1:15
    subplot(3,5,i), imshow(mask_data(:,:,(i-1)*3+1),[0 1]);
    hT1 = title(num2str((i-1)*3+1));
    if i==13,
        [HeightA,~,~] = size(mask_data(:,:,i));
        T1Pos = round(get(hT1,'Position'));
        hT1_2 = text(T1Pos(1), T1Pos(2)+HeightA+200,'Mask Images','HorizontalAlignment','center');
    end
end

% Calculate dataset sizes in bytes
s = dir(file1);
num_bytes_masks = s.bytes*dim(3);

num_bytes_mask_data = size(mask_data,1)*size(mask_data,2)*size(mask_data,3)*2;

% Compress masks using zip
foldertocompress = sprintf('%s',char(filesin(1)));
zip('mask_data.zip',foldertocompress);
s = dir('mask_data.zip');
num_bytes_compressed_masks = s.bytes;

CR_masks = num_bytes_masks/num_bytes_compressed_masks;

fclose('all');

% Display results
message = sprintf('Size of masks on disk: %d bytes', num_bytes_masks);
message = char(message, sprintf('Size of masks (no header info): %d bytes', num_bytes_mask_data));
message = char(message, sprintf(''));
message = char(message, sprintf('Size of compressed masks: %d bytes', num_bytes_compressed_masks));
message = char(message, sprintf(''));
message = char(message, sprintf('Compression ratio for masks: %.2f', CR_masks));
hd = msgbox(cellstr(message), 'Compression information (masks)');
set(hd, 'position', [300 300 300 100]);

% input('\nEnter to finish');

pause

clear all
close all

clc
