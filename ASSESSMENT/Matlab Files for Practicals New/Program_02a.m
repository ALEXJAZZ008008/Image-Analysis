
% Program_02a

% Mono-exponential vs bi-exponential fitting

warning off;

% Input number of data points
prompt = {'Enter number of data points to fit (4 or 20):'};
dlg_title = 'Number Points';
num_lines = 1;
def = {'20'};
answer = newid(prompt,dlg_title,num_lines,def);
num_pts = str2double(answer);

% Input mono- or bi-exponential fitting
prompt = {'Enter monoexponential (1) or biexponential (2) fitting:'};
dlg_title = 'Model Choice';
num_lines = 1;
def = {'2'};
answer = newid(prompt,dlg_title,num_lines,def);
model_choice = str2double(answer);

% Create test data
b_Data_20 = [0 4 8 14 21 30 41 55 73 94 122 156 198 251 318 401 505 635 797 1000];
S_Data_20 = [1063.0 1038.0 990.7 978.9 940.3 915.5 873.7 836.8 788.3 756.1 709.8 713.3 667.5 642.2 568.4 553.5 495.2 427.2 358.0 284.1];

% Create fine b value array for plotting
b_fine = 0:1000;

% mse_bi =
% 
%    18.4784
% 
% 

% Extract smaller dataset
b_Data_4 = [b_Data_20(1) b_Data_20(8) b_Data_20(18) b_Data_20(20)];
S_Data_4 = [S_Data_20(1) S_Data_20(8) S_Data_20(18) S_Data_20(20)];

if model_choice==1,

    % Create mono-exponential model function
    modelfun_mono = @(x_mo,b)x_mo(1)*exp(-b*x_mo(2));
    
    if num_pts==4,
        b_Data = b_Data_4;
        S_Data = S_Data_4;
    else
        b_Data = b_Data_20;
        S_Data = S_Data_20;
    end

    % Initial estimates for S0(x_mo0(1)) and D(x_mo0(2))
    x_mo0(1) = S_Data(1);
    x_mo0(2) = log(S_Data(1)/S_Data(end))/(b_Data(end)-b_Data(1)); % in millimetres squared per second

    % Non-linear fitting
    [xfit_mo,residuals_mo,J,COVB,mse_mo] = nlinfit(b_Data,S_Data,modelfun_mono,x_mo0);
    results_mono = [xfit_mo mse_mo x_mo0];

    % Data plotting
    
    % Generate curve
    S_fit = xfit_mo(1)*exp(-b_fine*xfit_mo(2));
    
    figure('Name','Monoexponential Data Fit','NumberTitle','off')
    
    subplot(2, 1, 1)
        plot(b_Data, S_Data, 'ko')
        hold on
        plot(b_fine, S_fit, 'b-')
        hold on
        xlabel('b (s/mm2)')
        ylabel('Signal (Arbitrary Units)')
        titletext = sprintf('Function = S0*exp(-bD) for %d data points', num_pts);
        title(titletext)
        legend('Data', 'Model Fit');
        hold off
    
    subplot(2, 1, 2)
        plot(b_Data, residuals_mo, 'rd:')
        hold on
        xlabel('b (s/mm2)')
        ylabel('Signal (Arbitrary Units)')
        title('Residuals')
        hold off
        
    % Display results
    message = sprintf('');
    message = char(message, sprintf('S0 = %.1f (a.u.)', xfit_mo(1)));
    message = char(message, sprintf('D = %.4f mm2/s', xfit_mo(2)));
    message = char(message, sprintf(''));
    message = char(message, sprintf('Mean squared error (MSE) = %.1f', mse_mo));
    titletext = sprintf('Results for %d pts with mono-exponential fitting', num_pts);
    hd = msgbox(cellstr(message), titletext);
    set(hd, 'position', [300 300 350 90]);
        
else
    
    % Create bi-exponential model function
    modelfun_bi = @(x_bi,b)x_bi(1)*((1-x_bi(2))*exp(-b*x_bi(3)) + x_bi(2)*exp(-b*x_bi(4)));
    
    if num_pts==4,
        b_Data = b_Data_4;
        S_Data = S_Data_4;
    else
        b_Data = b_Data_20;
        S_Data = S_Data_20;
    end
    
    % Initial estimates for S0(x_bi0(1)), f(x_bi0(2)), D(x_bi0(3)), and D*(x_bi0(4))
    x_bi0(1) = S_Data(1);
    x_bi0(3) = log(S_Data(end-1)/S_Data(end))/(b_Data(end)-b_Data(end-1)); % in millimetres squared per second
    x_bi0(2) = 1-(S_Data(end)/(x_bi0(1)*exp(-b_Data(end)*x_bi0(3)))); % decimal
    x_bi0(4) = 0.01; % in millimetres squared per second

    % Non-linear fitting
    [xfit_bi,residuals_bi,J,COVB,mse_bi] = nlinfit(b_Data,S_Data,modelfun_bi,x_bi0);
    results_bi_6pts = [xfit_bi mse_bi x_bi0];
    if num_pts==4, mse_bi = 0; end
    
    % Data plotting
    
    % Generate curves for two components 
    FC_D = xfit_bi(1)*(1-xfit_bi(2))*exp(-b_fine*xfit_bi(3));
    FC_DStar = xfit_bi(1)*xfit_bi(2).*exp(-b_fine*xfit_bi(4));
    S_fit = FC_D + FC_DStar;
    
    figure('Name','Biexponential Data Fit','NumberTitle','off')
    
    subplot(2, 1, 1)
        plot(b_Data, S_Data, 'ko')
        hold on
        plot(b_fine, S_fit, 'b-')
        hold on
        plot(b_fine, FC_D, 'b--')
        hold on
        plot(b_fine, FC_DStar, 'b:')
        hold on
        xlabel('b (s/mm2)')
        ylabel('Signal (Arbitrary Units)')
        titletext = sprintf('Function = S0*[(1-f)*exp(-bD) + f*exp(-bD*)] for %d data points', num_pts);
        title(titletext)
        legend('Data', 'Model Fit', 'Component [D]', 'Component [D*]');
        hold off
    
    subplot(2, 1, 2)
        plot(b_Data, residuals_bi, 'rd:')
        hold on
        xlabel('b (s/mm2)')
        ylabel('Signal (Arbitrary Units)')
        title('Residuals')
        hold off
        
    % Display results
    message = sprintf('');
    message = char(message, sprintf('S0 = %.1f (a.u.)', xfit_bi(1)));
    message = char(message, sprintf('D = %.4f mm2/s', xfit_bi(3)));
    message = char(message, sprintf('D* = %.3f mm2/s', xfit_bi(4)));
    message = char(message, sprintf('f = %.2f', xfit_bi(2)));
    message = char(message, sprintf(''));
    message = char(message, sprintf('Mean squared error (MSE) = %.1f', mse_bi));
    titletext = sprintf('Results for %d pts with bi-exponential fitting', num_pts);
    hd = msgbox(cellstr(message), titletext);
    set(hd, 'position', [300 300 350 110]);
    
end
