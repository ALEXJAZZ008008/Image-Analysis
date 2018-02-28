% L03_Exercise_02

% Histogram Analysis

warning off

% Read user selected image in
[filename,pathname] = uigetfile('Images\*.*','Select Image File');
filein = [pathname,filename];

info = dicominfo(filein);
dim = [double(info.Width), double(info.Height)];

original_image = double(dicomread(filein));
fclose('all');

h = imshow (original_image, [0 4000]);
title('Original Image')

% Input circle centre
p = ginput(1);
initPos(1) = round(axes2pix(dim(2), get(h, 'XData'), p(2)));
initPos(2) = round(axes2pix(dim(1), get(h, 'YData'), p(1)));

% Input circle radius
prompt = {'Enter circle radius required:'};
dlg_title = 'Circle Radius';
num_lines = 1;
def = {'10'};
answer = newid(prompt,dlg_title,num_lines,def);
circ_diam = str2double(answer);
    
% Create circle border points
theta = 0:0.1:2*pi;
ypts = initPos(1) + circ_diam*sin(theta(:));
xpts = initPos(2) + circ_diam*cos(theta(:));

% Fill in circle to create ROI mask
white_image = ones(dim(1),dim(2));
[~,ROI_data] = roifill(white_image, xpts, ypts);

% Ensure data is zero (not in ROI) and ones (in ROI)
ROI_data = ROI_data>0;
showMaskAsOverlay(0.4,ROI_data);

% input('\nEnter to continue');

pause

% Create array for ROI points
num_ROI = sum(ROI_data(:));
ROI_pts = zeros(1,num_ROI);

% Extract image data from ROI only
k = 1;
for i=1:dim(1)
    for j=1:dim(2)
        if ROI_data(i,j)==1,
            ROI_pts(k) = original_image(i,j);
            k = k+1;
        end
    end
end

% Display histogram
figure
histogram(ROI_pts,128);
title('ROI Histogram')

% input('\nEnter to continue');

pause

% Display normalised histogram
figure
h = histogram(ROI_pts, 128, 'Normalization','probability');
title('ROI Histogram (Normalised)')

% input('\nEnter to continue');

pause

% Display cumulative histogram
figure
histogram(ROI_pts, 128, 'Normalization','cdf')
title('ROI Histogram (Cumulative)')

% input('\nEnter to continue');

pause

% 1st order statistics for selected ROI
mean_ROI = mean(ROI_pts);
SD_ROI = std(ROI_pts);
skew_ROI = skewness(ROI_pts);

% Energy calculation
prob_dist = h.Values;
energy_array = prob_dist.*prob_dist;
energy_ROI = sum(energy_array);

% Entropy calculation
entropy_array = prob_dist.*log(prob_dist);
entropy_ROI = sum(entropy_array,'omitnan');

% Display results
message = sprintf('ROI mean %.2f', mean_ROI);
message = char(message, sprintf('Standard deviation %.2f', SD_ROI));
message = char(message, sprintf('Skewness %.3f', skew_ROI));
message = char(message, sprintf('Energy %.3f', energy_ROI));
message = char(message, sprintf('Entropy %.3f', entropy_ROI));
hd = msgbox(cellstr(message), 'First order statistics');
set(hd, 'position', [300 300 250 100]);

input('\nEnter to finish');

clear all
close all

clc


