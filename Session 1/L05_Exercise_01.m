% L05_Exercise_01

% Radon transforms and sinograms (unfiltered back projection)

warning off

% Phantom image generation
phantom_image = zeros(256,256);

for x=65:192
    for y=65:192
        phantom_image(x,y) = 255;
    end
end

for x=113:144
    for y=97:160
        phantom_image(x,y) = 128;
    end
end

% UNFILTERED BACK PROJECTION ON PHANTOM IMAGE

% Display phantom image
figure
imshow(phantom_image, [0 255]);
title('Original Phantom Image')

% Radon transform of phantom image
theta = 0:179;
[R_phantom,xp] = radon(phantom_image,theta);

% Display sinogram
figure
imshow(R_phantom,[],'Xdata',theta,'Ydata',xp,...
        'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
title('Sinogram Image')

% Recreate phantom image using unfiltered back projection
phantom_BP = iradon(R_phantom,theta,'linear','none');
max_BP = max(phantom_BP(:));
phantom_BP = 255*phantom_BP/max_BP;

% Display reconstructed phantom image
figure
imshow(phantom_BP, [0 255]);
title('Reconstructed Phantom Image')

% input('\nEnter to continue');

pause

clear theta;

% UNFILTERED BACK PROJECTION ON PHANTOM IMAGE WITH USER INPUTS 

for i=1:4

    % Input number of projections
    prompt = {'Enter number of projections:'};
    dlg_title = 'Number of projections';
    num_lines = 1;
    def = {'180'};
    answer = newid(prompt,dlg_title,num_lines,def);
    num_projs = str2double(answer);

    % Radon transform of phantom image
    theta = 0:180/num_projs:179;
    [R_phantom,xp] = radon(phantom_image,theta);

    % Display sinogram
    figure
    imshow(R_phantom,[],'Xdata',theta,'Ydata',xp,...
            'InitialMagnification','fit')
    xlabel('\theta (degrees)')
    ylabel('x''')
    titletext = sprintf('Sinogram Image (%d Projections)', num_projs);
    title(titletext)

    % Recreate phantom image using unfiltered back projection
    phantom_BP = iradon(R_phantom,theta,'linear','none');
    max_BP = max(phantom_BP(:));
    phantom_BP = 255*phantom_BP/max_BP;

    % Display reconstructed phantom image
    figure
    imshow(phantom_BP, [0 255]);
    titletext = sprintf('Reconstructed Image (%d Projections)', num_projs);
    title(titletext)

%     input('\nEnter to continue');

    pause
    
    clear theta;
    
end

close all;

% UNFILTERED BACK PROJECTION ON USER SELECTED IMAGE

% Read user selected image in
[filename,pathname] = uigetfile('Images\*.*','Select Image File');
filein = [pathname,filename];

info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

original_image = double(dicomread(filein));
fclose('all');

% Display original image
figure
imshow(original_image, [0 4000]);
title('Original Image')

% Perform Radon transform
theta = 0:180;
[R_original,xp] = radon(original_image,theta);

% Display sinogram
figure
imshow(R_original,[],'Xdata',theta,'Ydata',xp,...
        'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
title('Sinogram Image')

% Recreate original image using unfiltered back projection
original_BP = iradon(R_original,theta,'linear','none');
max_BP = max(original_BP(:));
original_BP = 255*original_BP/max_BP;

% Display reconstructed image
figure
imshow(original_BP, [0 255]);
title('Reconstructed Image')

% input('\nEnter to continue');

pause

clear theta;

% UNFILTERED BACK PROJECTION ON USER SELECTED IMAGE WITH USER INPUTS 

for i=1:4

    % Input number of projections
    prompt = {'Enter number of projections:'};
    dlg_title = 'Number of projections';
    num_lines = 1;
    def = {'180'};
    answer = newid(prompt,dlg_title,num_lines,def);
    num_projs = str2double(answer);

    % Radon transform of original image
    theta = 0:180/num_projs:179;
    [R_original,xp] = radon(original_image,theta);

    % Display sinogram
    figure
    imshow(R_original,[],'Xdata',theta,'Ydata',xp,...
            'InitialMagnification','fit')
    xlabel('\theta (degrees)')
    ylabel('x''')
    titletext = sprintf('Sinogram Image (%d Projections)', num_projs);
    title(titletext)

    % Recreate original image using unfiltered back projection
    original_BP = iradon(R_original,theta,'linear','none');
    max_BP = max(original_BP(:));
    original_BP = 255*original_BP/max_BP;

    % Display reconstructed image
    figure
    imshow(original_BP, [0 255]);
    titletext = sprintf('Reconstructed Image (%d Projections)', num_projs);
    title(titletext)

%     input('\nEnter to continue');

    pause
    
    clear theta;
    
end

%clear all
%close all

clc