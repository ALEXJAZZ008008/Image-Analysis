% L05_Exercise_02

% Radon transforms and sinograms (filtered back projection)

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

% FILTERED BACK PROJECTION ON PHANTOM IMAGE

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

% Recreate phantom image using filtered back projection
phantom_BP = iradon(R_phantom,theta,256);

% Display reconstructed phantom image
figure
imshow(phantom_BP, [0 255]);
title('Reconstructed Phantom Image')

% input('\nEnter to continue');

pause

% Display subtracted image
sub_image = phantom_image - phantom_BP;
hToolFig = imtool(sub_image);
set(hToolFig, 'Name', 'Difference Between Original & Reconstructed Images');

% input('\nEnter to continue');

pause

% Illustration of different filters

% Recreate phantom image using filtered back projection
phantom_BP = iradon(R_phantom,theta,256,'Hamming');

% Display reconstructed phantom image
figure
imshow(phantom_BP, [0 255]);
title('Reconstructed Phantom Image (Hamming Filter)')

% input('\nEnter to continue');

pause

% Display subtracted image
sub_image = phantom_image - phantom_BP;
hToolFig = imtool(sub_image);
set(hToolFig, 'Name', 'Difference Using Hamming Filter');

% input('\nEnter to continue');

pause

% Recreate phantom image using filtered back projection
phantom_BP = iradon(R_phantom,theta,256,'Cosine');

% Display reconstructed phantom image
figure
imshow(phantom_BP, [0 255]);
title('Reconstructed Phantom Image (Cosine Filter)')

% input('\nEnter to continue');

pause

% Display subtracted image
sub_image = phantom_image - phantom_BP;
hToolFig = imtool(sub_image);
set(hToolFig, 'Name', 'Difference Using Cosine Filter');

% input('\nEnter to continue');

pause

clear all
close all

% FILTERED BACK PROJECTION ON USER SELECTED IMAGE

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
theta = 0:0.36:180;
[R_original,xp] = radon(original_image,theta);

% Display sinogram
figure
imshow(R_original,[],'Xdata',theta,'Ydata',xp,...
        'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
title('Sinogram Image')

% Recreate original image using filtered back projection
original_BP = iradon(R_original,theta,dim(1));

% Display reconstructed image
figure
imshow(original_BP, [0 4000]);
title('Reconstructed Image')

% Display subtracted image
sub_image = original_image - original_BP;
hToolFig = imtool(sub_image);
set(hToolFig, 'Name', 'Difference Between Original & Reconstructed Images');

% input('\nEnter to continue');

pause

% Illustration of different filters

% Recreate phantom image using filtered back projection
original_BP = iradon(R_original,theta,dim(1),'Hamming');

% Display reconstructed image
figure
imshow(original_BP, [0 4000]);
title('Reconstructed User Image (Hamming Filter)')

% input('\nEnter to continue');

pause

% Display subtracted image
sub_image = original_image - original_BP;
hToolFig = imtool(sub_image);
set(hToolFig, 'Name', 'Difference Using Hamming Filter');

% input('\nEnter to continue');

pause

% Recreate original image using filtered back projection
original_BP = iradon(R_original,theta,dim(1),'Cosine');

% Display reconstructed image
figure
imshow(original_BP, [0 4000]);
title('Reconstructed User Image (Cosine Filter)')

% input('\nEnter to continue');

pause

% Display subtracted image
sub_image = original_image - original_BP;
hToolFig = imtool(sub_image);
set(hToolFig, 'Name', 'Difference Using Cosine Filter');

% input('\nEnter to continue');

pause

clear all
close all

clc