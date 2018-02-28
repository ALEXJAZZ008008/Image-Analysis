% L04_Exercise_01

% Fourier Analysis of Square Wave

warning off

% Define square wave
sq_wave(1:1000) = 1;
sq_wave(1001:2000) = -1;
sq_wave(2001:3000) = 1;
sq_wave(3001:4000) = -1;
sq_wave(4001:5000) = 1;
sq_wave(5001:6000) = -1;

% Turn into time series
ts_square = timeseries(sq_wave,1:6000);

% Plot square wave
plot(ts_square)
ylim([-1.27,1.27])
title('Square Wave')
ylabel('Amplitude')

% input('\nEnter to continue');

pause

% Create sine waves (up to 99th harmonic)
x = 0:pi/1000:6*pi-pi/1000;
num_pts = size(x,2);

y = zeros(100,num_pts);

for i=1:1000
    
    coeff = i*2-1;
    y(i,:) = (1.27/coeff)*sin(coeff*x);
    
end

% Turn into time series
for i=1:1000
    ts(i) = timeseries(y(i,:),1:6000);
end

% Plot lowest 5 frequencies as illustration
figure
plot(ts(1))
ylim([-1.27,1.27])
title('Sine Wave (Lowest Frequency)')
ylabel('Amplitude')

figure
plot(ts(2))
ylim([-1.27,1.27])
title('Sine Wave (2nd Frequency)')
ylabel('Amplitude')

figure
plot(ts(3))
ylim([-1.27,1.27])
title('Sine Wave (3rd Frequency)')
ylabel('Amplitude')

figure
plot(ts(4))
ylim([-1.27,1.27])
title('Sine Wave (4th Frequency)')
ylabel('Amplitude')

figure
plot(ts(5))
ylim([-1.27,1.27])
title('Sine Wave (5th Frequency)')
ylabel('Amplitude')

% input('\nEnter to continue');

pause

% Loop through 100 times to see range of reconstructions
for j=1:100

    % Reconstruct to user specification
    prompt = {'Number of frequencies to use in square wave reconstruction:'};
    dlg_title = 'Square Wave Reconstuction';
    num_lines = 1;
    def = {'1'};
    answer = newid(prompt,dlg_title,num_lines,def);
    num_freqs = str2double(answer);

    sq_wv_recon = zeros(1,num_pts);

    for i=1:num_freqs
        sq_wv_recon = sq_wv_recon + y(i,:);
    end

    % Turn into time series
    ts_sq_wv_recon = timeseries(sq_wv_recon,1:6000);

    % Plot user results
    figure
    plot(ts_sq_wv_recon)
    ylim([-1.27,1.27])
    titletext = sprintf('Sum of %d Sine Waves', num_freqs);
    title(titletext)
    ylabel('Amplitude')

%     input('\nEnter to continue');

    pause

    % Plot user results overlaid on original square wave
    figure
    plot(ts_square)
    ylim([-1.27,1.27])
    hold on
    plot(ts_sq_wv_recon)
    ylim([-1.27,1.27])
    titletext = sprintf('First %d Terms Overlaid on Original', num_freqs);
    title(titletext)
    ylabel('Amplitude')
    
%     input('\nEnter to continue');

    pause
    
    close all
    
end

input('\nEnter to finish');

clear all

clc
