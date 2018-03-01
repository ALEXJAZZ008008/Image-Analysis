% L11_Exercise_03

warning off;

% Default settings

% Number of distinct grey levels in perfect image
num_grey_distinct = 16;
% Test image size;
data_size = 64;
% Image intensity step
int_step = 256;

% Calculate box size within image
box_size = 4*data_size/num_grey_distinct;

% Create homogeneous test data
homo_data = zeros(data_size,data_size);

homo_data(1:box_size,1:box_size) = 0;
homo_data(box_size+1:2*box_size,1:box_size) = int_step-1;
homo_data(2*box_size+1:3*box_size,1:box_size) = 2*int_step-1;
homo_data(3*box_size+1:4*box_size,1:box_size) = 3*int_step-1;

homo_data(1:box_size,box_size+1:2*box_size) = 4*int_step-1;
homo_data(box_size+1:2*box_size,box_size+1:2*box_size) = 15*int_step-1;
homo_data(2*box_size+1:3*box_size,box_size+1:2*box_size) = 13*int_step-1;
homo_data(3*box_size+1:4*box_size,box_size+1:2*box_size) = 11*int_step-1;

homo_data(1:box_size,2*box_size+1:3*box_size) = 5*int_step-1;
homo_data(box_size+1:2*box_size,2*box_size+1:3*box_size) = 14*int_step-1;
homo_data(2*box_size+1:3*box_size,2*box_size+1:3*box_size) = 12*int_step-1;
homo_data(3*box_size+1:4*box_size,2*box_size+1:3*box_size) = 10*int_step-1;

homo_data(1:box_size,3*box_size+1:4*box_size) = 6*int_step-1;
homo_data(box_size+1:2*box_size,3*box_size+1:4*box_size) = 7*int_step-1;
homo_data(2*box_size+1:3*box_size,3*box_size+1:4*box_size) = 8*int_step-1;
homo_data(3*box_size+1:4*box_size,3*box_size+1:4*box_size) = 9*int_step-1;

imtool(homo_data)

pause

% Add noise to homogeneous test data

% Input noise level required
prompt = {'Enter noise level (% of maximum signal):'};
dlg_title = 'Noise level';
num_lines = 1;
def = {'2'};
answer = newid(prompt,dlg_title,num_lines,def);
noise_percent = str2double(answer);

% Generate noise for individual points
% Noise will be between -1 and +1
noise = 2*(rand(data_size,data_size)-0.5);
% Scale by appropriate percentage
max_signal = max(homo_data(:));
noise = noise*max_signal*noise_percent/100;

% Add noise to signal
homo_noisy = floor(homo_data + noise);
% Ensure no negative data
homo_noisy = abs(homo_noisy);

imtool(homo_noisy)

pause

% Create heterogeneous test data
hetero_data = floor((max_signal+1)*rand(data_size,data_size));

imtool(hetero_data)

pause

% Calculate sample texture parameters without histogram equalisation
num_grey_homo_data = max(homo_data(:))+1;
num_grey_homo_noisy = max(homo_noisy(:))+1;
num_grey_hetero_data = max(hetero_data(:))+1;

GLCM_homo_data = graycomatrix(homo_data,'NumLevels',num_grey_homo_data,'GrayLimits', [0 num_grey_homo_data-1],'Offset',[0 1]);
GLCM_homo_noisy = graycomatrix(homo_noisy,'NumLevels',num_grey_homo_noisy,'GrayLimits', [0 num_grey_homo_noisy-1],'Offset',[0 1]);
GLCM_hetero_data = graycomatrix(hetero_data,'NumLevels',num_grey_hetero_data,'GrayLimits', [0 num_grey_hetero_data-1],'Offset',[0 1]);

GLCM_homo_data = GLCM_homo_data/sum(GLCM_homo_data(:));
GLCM_homo_noisy = GLCM_homo_noisy/sum(GLCM_homo_noisy(:));
GLCM_hetero_data = GLCM_hetero_data/sum(GLCM_hetero_data(:));

% Create results array
text_no_HE = zeros(3,2);

% CALCULATE f1 - ANGULAR SECOND MOMENT
text_no_HE(1,1) = sum(sum(GLCM_homo_data.*GLCM_homo_data));
text_no_HE(2,1) = sum(sum(GLCM_homo_noisy.*GLCM_homo_noisy));
text_no_HE(3,1) = sum(sum(GLCM_hetero_data.*GLCM_hetero_data));

% CALCULATE f9 - ENTROPY
ent_homo_data = GLCM_homo_data.*log2(GLCM_homo_data);
ent_homo_data(isnan(ent_homo_data))=0;
text_no_HE(1,2) = -sum(sum(ent_homo_data));
ent_homo_noisy = GLCM_homo_noisy.*log2(GLCM_homo_noisy);
ent_homo_noisy(isnan(ent_homo_noisy))=0;
text_no_HE(2,2) = -sum(sum(ent_homo_noisy));
ent_hetero_data = GLCM_hetero_data.*log2(GLCM_hetero_data);
ent_hetero_data(isnan(ent_hetero_data))=0;
text_no_HE(3,2) = -sum(sum(ent_hetero_data));

% Display results
message = sprintf('Angular Second Moment');
message = char(message, sprintf('Homogeneous image, f1 = %.4f', text_no_HE(1,1)));
message = char(message, sprintf('Homogeneous image (with noise), f1 = %.4f', text_no_HE(2,1)));
message = char(message, sprintf('Heterogeneous image, f1 = %.4f', text_no_HE(3,1)));
message = char(message, sprintf(''));
message = char(message, sprintf('Entropy'));
message = char(message, sprintf('Homogeneous image, f9 = %.4f', text_no_HE(1,2)));
message = char(message, sprintf('Homogeneous image (with noise), f9 = %.4f', text_no_HE(2,2)));
message = char(message, sprintf('Heterogeneous image, f9 = %.4f', text_no_HE(3,2)));
hd = msgbox(cellstr(message), 'Texture Results before Histogram Equalisation');
set(hd, 'position', [300 300 350 150]);

pause

% Calculate sample texture parameters with histogram equalisation

% Histogram equalisation    
max_int_homo_data = max(homo_data(:));
max_int_homo_noisy = max(homo_noisy(:));
max_int_hetero_data = max(hetero_data(:));
hgram_homo_data = zeros(1,max_int_homo_data+1);
hgram_homo_noisy = zeros(1,max_int_homo_noisy+1); 
hgram_hetero_data = zeros(1,max_int_hetero_data+1); 

% next 3 lines for histogram display
roi_homo_noisy = zeros(1,data_size*data_size);
roi_hetero_data = zeros(1,data_size*data_size);

i=1;
for x=1:data_size
    for y=1:data_size 
        hgram_homo_data(homo_data(x,y)+1) = hgram_homo_data(homo_data(x,y)+1)+1;
        hgram_homo_noisy(homo_noisy(x,y)+1) = hgram_homo_noisy(homo_noisy(x,y)+1)+1;
        hgram_hetero_data(hetero_data(x,y)+1) = hgram_hetero_data(hetero_data(x,y)+1)+1;
        % next 3 lines for histogram display
        roi_homo_noisy(i) = homo_noisy(x,y);
        roi_hetero_data(i) = hetero_data(x,y);
        i = i+1;
    end
end

% Display histogram of homogeneous noisy data
figure
hist(roi_homo_noisy(:), 80); set(gca, 'XLim', [0 max_int_homo_noisy], 'YLim', [0 fix(data_size*data_size/6)])
    xlabel('Grey level');
    ylabel('Counts');
    ht = findobj(gca,'Type','patch');
    set(ht,'FaceColor','black','EdgeColor','w');
    title('Homogeneous Noisy Data');

% Display histogram of heterogeneous data
figure
hist(roi_hetero_data(:), 80); set(gca, 'XLim', [0 max_int_hetero_data], 'YLim', [0 fix(data_size*data_size/6)])
    xlabel('Grey level');
    ylabel('Counts');
    ht = findobj(gca,'Type','patch');
    set(ht,'FaceColor','black','EdgeColor','w');
    title('Heterogeneous Data');
    
pause

% Input number of grey levels required
prompt = {'Enter num grey levels:'};
dlg_title = 'Grey levels';
num_lines = 1;
def = {'16'};
answer = newid(prompt,dlg_title,num_lines,def);
num_grey = str2double(answer);

norm_hgram_homo_data = hgram_homo_data/(data_size*data_size);
cum_hgram_homo_data = cumsum(norm_hgram_homo_data);
look_up_homo_data = zeros(1,max_int_homo_data+1);
norm_hgram_homo_noisy = hgram_homo_noisy/(data_size*data_size);
cum_hgram_homo_noisy = cumsum(norm_hgram_homo_noisy);
look_up_homo_noisy = zeros(1,max_int_homo_noisy+1);
norm_hgram_hetero_data = hgram_hetero_data/(data_size*data_size);
cum_hgram_hetero_data = cumsum(norm_hgram_hetero_data);
look_up_hetero_data = zeros(1,max_int_hetero_data+1);

% Create look up table for homogeneous data
gry_lvl = 0;
for i=1:max_int_homo_data+1
    if cum_hgram_homo_data(i) > 1
        look_up_homo_data(i) = gry_lvl;
    elseif cum_hgram_homo_data(i) <= (gry_lvl+1)/num_grey
        look_up_homo_data(i) = gry_lvl;
    else
        gry_lvl = gry_lvl+1;
        look_up_homo_data(i) = gry_lvl;
    end
end

% Create look up table for homogeneous noisy data
gry_lvl = 0;
for i=1:max_int_homo_noisy+1
    if cum_hgram_homo_noisy(i) > 1
        look_up_homo_noisy(i) = gry_lvl;
    elseif cum_hgram_homo_noisy(i) <= (gry_lvl+1)/num_grey
        look_up_homo_noisy(i) = gry_lvl;
    else
        gry_lvl = gry_lvl+1;
        look_up_homo_noisy(i) = gry_lvl;
    end
end

% Create look up table for heterogeneous data
gry_lvl = 0;
for i=1:max_int_hetero_data+1
    if cum_hgram_hetero_data(i) > 1
        look_up_hetero_data(i) = gry_lvl;
    elseif cum_hgram_hetero_data(i) <= (gry_lvl+1)/num_grey
        look_up_hetero_data(i) = gry_lvl;
    else
        gry_lvl = gry_lvl+1;
        look_up_hetero_data(i) = gry_lvl;
    end
end

equalised_homo_data = zeros(data_size,data_size);
equalised_homo_noisy = zeros(data_size,data_size);
equalised_hetero_data = zeros(data_size,data_size);

homo_data(homo_data>max_int_homo_data)=max_int_homo_data;
homo_noisy(homo_noisy>max_int_homo_noisy)=max_int_homo_noisy;
hetero_data(hetero_data>max_int_hetero_data)=max_int_hetero_data;

for x=1:data_size
    for y=1:data_size
        equalised_homo_data(x,y) = look_up_homo_data(homo_data(x,y)+1);
        equalised_homo_noisy(x,y) = look_up_homo_noisy(homo_noisy(x,y)+1);
        equalised_hetero_data(x,y) = look_up_hetero_data(hetero_data(x,y)+1);
    end
end

% Display histogram of homogeneous noisy data after equalisation
figure
hist(equalised_homo_noisy(:),num_grey); set(gca, 'XLim', [0 num_grey], 'YLim', [0 fix(2*data_size*data_size/num_grey)], 'XTick', 0:num_grey-1)
    xlabel('Grey level');
    ylabel('Counts');
    ht = findobj(gca,'Type','patch');
    set(ht,'FaceColor','black','EdgeColor','w');
    title('Homogeneous Noisy Data (after HE)');

% Display histogram of heterogeneous data after equalisation
figure
hist(equalised_hetero_data(:),num_grey); set(gca, 'XLim', [0 num_grey], 'YLim', [0 fix(2*data_size*data_size/num_grey)], 'XTick', 0:num_grey-1)
    xlabel('Grey level');
    ylabel('Counts');
    ht = findobj(gca,'Type','patch');
    set(ht,'FaceColor','black','EdgeColor','w')
    title('Heterogeneous Data (after HE)');

pause

% Display histogram equalised images

imtool(equalised_homo_noisy)

pause

imtool(equalised_hetero_data)

pause

% Calculate sample texture parameters without histogram equalisation
GLCM_homo_data_HE = graycomatrix(equalised_homo_data,'NumLevels',num_grey,'GrayLimits', [0 num_grey-1],'Offset',[0 1]);
GLCM_homo_noisy_HE = graycomatrix(equalised_homo_noisy,'NumLevels',num_grey,'GrayLimits', [0 num_grey-1],'Offset',[0 1]);
GLCM_hetero_data_HE = graycomatrix(equalised_hetero_data,'NumLevels',num_grey,'GrayLimits', [0 num_grey-1],'Offset',[0 1]);

GLCM_homo_data_HE = GLCM_homo_data_HE/sum(GLCM_homo_data_HE(:));
GLCM_homo_noisy_HE = GLCM_homo_noisy_HE/sum(GLCM_homo_noisy_HE(:));
GLCM_hetero_data_HE = GLCM_hetero_data_HE/sum(GLCM_hetero_data_HE(:));

GLCM_ALL_HE = cat(3, GLCM_homo_data_HE, GLCM_homo_noisy_HE, GLCM_hetero_data_HE);

% Create results array
text_HE = zeros(3,2);

% CALCULATE f1 - ANGULAR SECOND MOMENT
text_HE(:,1) = sum(sum(GLCM_ALL_HE.*GLCM_ALL_HE));

% CALCULATE f9 - ENTROPY
ENT_ALL_HE = GLCM_ALL_HE.*log2(GLCM_ALL_HE);
ENT_ALL_HE(isnan(ENT_ALL_HE))=0;
text_HE(:,2) = -sum(sum(ENT_ALL_HE));

% Display results
message = sprintf('Number of Grey Levels = %d', num_grey);
message = char(message, sprintf(''));
message = char(message, sprintf('Angular Second Moment'));
message = char(message, sprintf('Homogeneous image, f1 = %.4f', text_HE(1,1)));
message = char(message, sprintf('Homogeneous image (with noise), f1 = %.4f', text_HE(2,1)));
message = char(message, sprintf('Heterogeneous image, f1 = %.4f', text_HE(3,1)));
message = char(message, sprintf(''));
message = char(message, sprintf('Entropy'));
message = char(message, sprintf('Homogeneous image, f9 = %.4f', text_HE(1,2)));
message = char(message, sprintf('Homogeneous image (with noise), f9 = %.4f', text_HE(2,2)));
message = char(message, sprintf('Heterogeneous image, f9 = %.4f', text_HE(3,2)));
hd = msgbox(cellstr(message), 'Texture Results after Histogram Equalisation');
set(hd, 'position', [300 300 350 170]);