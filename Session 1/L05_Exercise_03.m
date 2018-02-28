% L05_Exercise_03

% Wavelet transforms and reconstruction

warning off

% Wavelet settings
n = 4;          % Decomposition Level
w = 'db4';    % Daubechies wavelet
% w = 'Haar';     % Haar wavelet

% Image selection
Z = 19;

% Phantom images generation
phantom_image = zeros(256,256,10);

for i=1:10
    for x=65:192
        for y=65:192
            phantom_image(x,y,i) = 255;
        end
    end
end

for i=1:10
    for x=113:144
        for y=97:160
            phantom_image(x,y,i) = 128;
        end
    end
end

% WAVELET TRANSFORM AND RECONSTRUCTION ON PHANTOM IMAGES

% Display phantom images
figure
for i=1:10
    subplot(2,5,i), imshow(phantom_image(:,:,i),[0 255]);
    hT1 = title(num2str(i));
    if i==8,
        [HeightA,~,~] = size(phantom_image(:,:,i));
        T1Pos = round(get(hT1,'Position'));
        hT1_2 = text(T1Pos(1), T1Pos(2)+HeightA+200,'Phantom Images','HorizontalAlignment','center');
    end
end

% input('\nEnter to continue');

pause

map = gray;

% Calculate wavelets to nth (default 4th) level for phantom images
Coeffs = wavedec3(phantom_image, n, w);

% Multilevel reconstruction
A = cell(1,n);
D = cell(1,n);

for k = 1:n
    A{k} = waverec3(Coeffs,'a',k);   % Approximations (low-pass components)
    D{k} = waverec3(Coeffs,'d',k);   % Details (high-pass components)
end

% Check for perfect reconstruction
err = zeros(1,n);
for k = 1:n
    E = double(phantom_image)-A{k}-D{k};
    err(k) = max(abs(E(:)));
end

message = sprintf('Reconstruction errors');
message = char(message, sprintf(''));
for k=1:n
    message = char(message, sprintf('Level %d error: %.3e', k, err(k)));
end
hd = msgbox(cellstr(message), 'Reconstruction');

% Extract approximations and details for first image only
A_1 = zeros(256,256,n);
D_1 = zeros(256,256,n);
diff_images = zeros(256,256,n);

for i=1:n
    A_1(:,:,i) = A{i}(:,:,1);
    D_1(:,:,i) = abs(D{i}(:,:,1));
    diff_images(:,:,i) = phantom_image(:,:,1) - A_1(:,:,1);
end

D_1_maxs = (squeeze(max(max(D_1))))';

% input('\nEnter to continue');

pause

% Display approximations and details
figure
colormap(map)
for k = 1:n
    labstr = int2str(k) ;
    subplot(2,n,k);
    imshow(A_1(:,:,k), [0 255]);
    xlabel(['A' labstr]);
    subplot(2,n,k+n);
    imshow(abs(D_1(:,:,k)), [0 D_1_maxs(k)]);
    xlabel(['D' labstr]);
    if k==3,
        [HeightA,~,~] = size(phantom_image(:,:,i));
        T1Pos = round(get(hT1,'Position'));
        hT1_2 = text(T1Pos(1)-200, T1Pos(2)+HeightA+200,['Approximations and details at levels 1 to 4 (' w ' wavelet)'],'HorizontalAlignment','center');
    end
end

% input('\nEnter to continue');

pause

% Display differences between actual images 
% and approximations at different levels
figure
colormap(map)
for k=1:n
    labstr = int2str(k) ;
    subplot(1,n,k);
    imshow(diff_images(:,:,k), [-255 255]);
    xlabel(['A' labstr]);
    if k==3,
        [HeightA,~,~] = size(phantom_image(:,:,i));
        T1Pos = round(get(hT1,'Position'));
        hT1_2 = text(T1Pos(1)-200, T1Pos(2)+HeightA+200,['Difference between images and approximations for slice 19 (' w ' wavelet)'],'HorizontalAlignment','center');
    end
end

avg_error = (squeeze(sum(sum(abs(diff_images))))')/(256*256);
labstr = ['Approximation errors for ' w ' wavelet'];
message = sprintf(labstr);
message = char(message, sprintf(''));
for k=1:n
    message = char(message, sprintf('Level %d error: %.2f', k, avg_error(k)));
end
hd = msgbox(cellstr(message), 'Approximations');

% input('\nEnter to continue');

pause

% WAVELET TRANSFORM AND RECONSTRUCTION ON USER SELECTED IMAGES

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

% input('\nEnter to continue');

pause

% Calculate wavelets to nth (default 4th) level for user images
Coeffs = wavedec3(image_data, n, w);

% Multilevel reconstruction
A = cell(1,n);
D = cell(1,n);

h = waitbar(0,'Wavelet reconstruction in process');
for k = 1:n
    A{k} = waverec3(Coeffs,'a',k);   % Approximations (low-pass components)
    D{k} = waverec3(Coeffs,'d',k);   % Details (high-pass components)
    waitbar(k/n);
end
close (h);

% Check for perfect reconstruction
err = zeros(1,n);
for k = 1:n
    E = double(image_data)-A{k}-D{k};
    err(k) = max(abs(E(:)));
end

message = sprintf('Reconstruction errors');
message = char(message, sprintf(''));
for k=1:n
    message = char(message, sprintf('Level %d error: %.3e', k, err(k)));
end
hd = msgbox(cellstr(message), 'Reconstruction');

% input('\nEnter to continue');

pause

% Extract approximations and details for Zth image only
A_1 = zeros(dim(1),dim(2),n);
D_1 = zeros(dim(1),dim(2),n);
diff_images = zeros(dim(1),dim(2),n);

for i=1:n
    A_1(:,:,i) = A{i}(:,:,Z);
    D_1(:,:,i) = abs(D{i}(:,:,Z));
    diff_images(:,:,i) = image_data(:,:,Z) - A{i}(:,:,Z);
end

D_1_maxs = (squeeze(max(max(D_1))))';

% Display approximations and details
figure
colormap(map)
for k = 1:n
    labstr = int2str(k);
    subplot(2,n,k);
    imshow(A_1(:,:,k), [0 4000]);
    xlabel(['A' labstr]);
    subplot(2,n,k+n);
    imshow(abs(D_1(:,:,k)), [0 D_1_maxs(k)]);
    xlabel(['D' labstr]);
    if k==3,
        [HeightA,~,~] = size(image_data(:,:,Z));
        T1Pos = round(get(hT1,'Position'));
        hT1_2 = text(T1Pos(1)-300, T1Pos(2)+HeightA+400,['Approximations and details at levels 1 to 4 for image ' num2str(Z) ' (' w ' wavelet)'],'HorizontalAlignment','center');
    end
end

% input('\nEnter to continue');

pause

% Display differences between actual images 
% and approximations at different levels (Zth image only)
figure
colormap(map)
for k=1:n
    labstr = int2str(k) ;
    subplot(1,n,k);
    imshow(diff_images(:,:,k), [-255 255]);
    xlabel(['A' labstr]);
    if k==3,
        [HeightA,~,~] = size(phantom_image(:,:,i));
        T1Pos = round(get(hT1,'Position'));
        hT1_2 = text(T1Pos(1)-300, T1Pos(2)+HeightA+700,['Difference between images and approximations for image ' num2str(Z) ' (' w ' wavelet)'],'HorizontalAlignment','center');
    end
end

avg_error = (squeeze(sum(sum(abs(diff_images))))')/(dim(1)*dim(2));
labstr = ['Approximation errors for ' w ' wavelet'];
message = sprintf(labstr);
message = char(message, sprintf(''));
for k=1:n
    message = char(message, sprintf('Level %d error: %.2f', k, avg_error(k)));
end
hd = msgbox(cellstr(message), 'Approximations');

% input('\nEnter to finish');

pause

%clear all
%close all

clc