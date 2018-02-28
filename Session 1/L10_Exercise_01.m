% L10_Exercise_01

warning off;

% Create perfect test data
Data = [0 1000.0; 4 990.7; 8 981.7; 14 968.6; 21 953.9; 30 936.0; 41 915.4; 55 891.1; 73 862.4; 94 832.3; 122 796.7; 156 758.7; 198 718.0; 251 673.5; 318 624.7; 401 571.9; 505 513.9; 635 450.7; 797 383.1; 1000 312.7];
D_Data = [0 850.0; 4 846.6; 8 843.2; 14 838.2; 21 832.3; 30 824.9; 41 815.9; 55 804.5; 73 790.2; 94 773.7; 122 752.4; 156 727.2; 198 697.3; 251 6661.3; 318 618.5; 401 569.2; 505 513.0; 635 450.4; 797 383.1; 1000 312.7];
Dstar_Data = [0 150.0; 4 144.1; 8 138.5; 14 130.4; 21 121.6; 30 111.1; 41 99.5; 55 86.5; 73 72.3; 94 58.6; 122 44.3; 156 31.5; 198 20.7; 251 12.2; 318 6.2; 401 2.7; 505 1.0; 635 0.3; 797 0.1; 1000 0.0];

% Extract b-values and signal into separate arrays
b = Data((1:end),1);
S = Data((1:end),2);

% Create model function
modelfun = @(x,b)x(1)*((1-x(2))*exp(-b*x(3)) + x(2)*exp(-b*x(4)));

% Initial (good) estimates for S0(x0(1)), f(x0(2)), D(x0(3)), and D*(x0(4))

% S0 estimate is first data point
x0(1) = S(1);
% D estimate is slope of last five points
% (assuming D* component is negligible)
x0(3) = log(S(end-5)/S(end))/(b(end)-b(end-5)); % in millimetres squared per second
% Ensure within physiological bounds
if x0(3)<0.0005, x0(3) = 0.001; end
if x0(3)>0.0030, x0(3) = 0.001; end
% f estimate based on difference at first data point
% between data and D only extrapolation
x0(2) = 1-(S(end)/(x0(1)*exp(-b(end)*x0(3)))); % decimal
% Ensure within physiological bounds
if x0(2)<0, x0(2) = 0.10; end
if x0(2)>1, x0(2) = 0.10; end
% D* estimate calculated directly from other estimates
x0(4) = (log((x0(1)*x0(2))/(S(2)-x0(1)*(1-x0(2))*exp(-b(2)*x0(3)))))/b(2); % in millimetres squared per second
% Ensure within physiological bounds
if x0(4)>x0(3)*30; x0(4) = x0(3)*10; end
if x0(4)<x0(3); x0(4) = x0(3)*10; end
    
FC_D_init = x0(1)*(1-x0(2))*exp(-b*x0(3));
FC_DStar_init = x0(1)*x0(2).*exp(-b*x0(4));
FC_Total_init = FC_D_init + FC_DStar_init;
residuals_init = S - FC_Total_init;
    
figure('Name','Initial (Good) Estimates Fit','NumberTitle','off');
    
subplot(2, 1, 1)
    plot(b, S, 'ko')
    hold on
    plot(b, FC_Total_init, 'b-')
    hold on
    plot(b, FC_D_init, 'b--')
    hold on
    plot(b, FC_DStar_init, 'b:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Function = S0*[(1-f)*exp(-bD) + f*exp(-bD*)]');
    legend('Data', 'Model Fit', 'Component [D]', 'Component [D*]');
    hold off
        
subplot(2, 1, 2)
    plot(b, residuals_init, 'rd:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Residuals')
    hold off

pause

% Display results
message = sprintf('Actual Parameters');
message = char(message, sprintf('D = 0.0010 mm2/s'));
message = char(message, sprintf('D* = 0.010 mm2/s'));
message = char(message, sprintf('f = 0.15'));
message = char(message, sprintf(''));
message = char(message, sprintf('Initial Estimates'));
message = char(message, sprintf('D = %.4f mm2/s', x0(3)));
message = char(message, sprintf('D* = %.3f mm2/s', x0(4)));
message = char(message, sprintf('f = %.2f', x0(2)));
hd = msgbox(cellstr(message), 'Results for Initial Estimates');
set(hd, 'position', [300 300 350 150]);

pause
    
[xfit,residuals,J,COVB,mse] = nlinfit(b(1:end),S(1:end),modelfun,x0);

results = [xfit mse x0];
    
% Data plotting
    
% Generate curves for two components 
FC_D = xfit(1)*(1-xfit(2))*exp(-b*xfit(3));
FC_DStar = xfit(1)*xfit(2).*exp(-b*xfit(4));
FC_Total = FC_D + FC_DStar;
    
figure('Name','Final (Good Initial Estimates) Biexponential Data Fit','NumberTitle','off')
    
subplot(2, 1, 1)
    plot(b, S, 'ko')
    hold on
    plot(b, FC_Total, 'b-')
    hold on
    plot(b, FC_D, 'b--')
    hold on
    plot(b, FC_DStar, 'b:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Function = S0*[(1-f)*exp(-bD) + f*exp(-bD*)]');
    legend('Data', 'Model Fit', 'Component [D]', 'Component [D*]');
    hold off
    
subplot(2, 1, 2)
    plot(b, residuals, 'rd:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Residuals')
    hold off

pause

% Display results
message = sprintf('Actual Parameters');
message = char(message, sprintf('D = 0.0010 mm2/s'));
message = char(message, sprintf('D* = 0.010 mm2/s'));
message = char(message, sprintf('f = 0.15'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Parameters'));
message = char(message, sprintf('D = %.4f mm2/s', xfit(3)));
message = char(message, sprintf('D* = %.3f mm2/s', xfit(4)));
message = char(message, sprintf('f = %.2f', xfit(2)));
hd = msgbox(cellstr(message), 'Results for Ideal Data (Good Estimates)');
set(hd, 'position', [300 300 350 150]);

pause
    
% Initial (poor) estimates for S0(x0(1)), f(x0(2)), D(x0(3)), and D*(x0(4))

% S0 estimate is multiple of first data point
x0(1) = 0.80*S(1);
% D estimate is slope of first five points
% (assuming D* component is negligible)
x0(3) = log(S(1)/S(5))/(b(5)-b(1)); % in millimetres squared per second
% f estimate assumes equal proportions
x0(2) = 0.5; % decimal
% D* estimate calculated as twice D estimate
x0(4) = 2*x0(3);
    
FC_D_init = x0(1)*(1-x0(2))*exp(-b*x0(3));
FC_DStar_init = x0(1)*x0(2).*exp(-b*x0(4));
FC_Total_init = FC_D_init + FC_DStar_init;
residuals_init = S - FC_Total_init;
    
figure('Name','Initial (Poor) Estimates Fit','NumberTitle','off');
    
subplot(2, 1, 1)
    plot(b, S, 'ko')
    hold on
    plot(b, FC_Total_init, 'b-')
    hold on
    plot(b, FC_D_init, 'b--')
    hold on
    plot(b, FC_DStar_init, 'b:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Function = S0*[(1-f)*exp(-bD) + f*exp(-bD*)]');
    legend('Data', 'Model Fit', 'Component [D]', 'Component [D*]');
    hold off
        
subplot(2, 1, 2)
    plot(b, residuals_init, 'rd:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Residuals')
    hold off

pause

% Display results
message = sprintf('Actual Parameters');
message = char(message, sprintf('D = 0.0010 mm2/s'));
message = char(message, sprintf('D* = 0.010 mm2/s'));
message = char(message, sprintf('f = 0.15'));
message = char(message, sprintf(''));
message = char(message, sprintf('Initial Estimates'));
message = char(message, sprintf('D = %.4f mm2/s', x0(3)));
message = char(message, sprintf('D* = %.3f mm2/s', x0(4)));
message = char(message, sprintf('f = %.2f', x0(2)));
hd = msgbox(cellstr(message), 'Results for Initial Estimates');
set(hd, 'position', [300 300 350 150]);

pause
    
[xfit,residuals,J,COVB,mse] = nlinfit(b(1:end),S(1:end),modelfun,x0);

results = [xfit mse x0];
    
% Data plotting
    
% Generate curves for two components 
FC_D = xfit(1)*(1-xfit(2))*exp(-b*xfit(3));
FC_DStar = xfit(1)*xfit(2).*exp(-b*xfit(4));
FC_Total = FC_D + FC_DStar;
    
figure('Name','Final (Poor Initial Estimates) Biexponential Data Fit','NumberTitle','off')
    
subplot(2, 1, 1)
    plot(b, S, 'ko')
    hold on
    plot(b, FC_Total, 'b-')
    hold on
    plot(b, FC_D, 'b--')
    hold on
    plot(b, FC_DStar, 'b:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Function = S0*[(1-f)*exp(-bD) + f*exp(-bD*)]');
    legend('Data', 'Model Fit', 'Component [D]', 'Component [D*]');
    hold off
    
subplot(2, 1, 2)
    plot(b, residuals, 'rd:')
    hold on
    xlabel('b (s/mm2)')
    ylabel('Signal (Arbitrary Units)')
    title('Residuals')
    hold off
    
pause

% Display results
message = sprintf('Actual Parameters');
message = char(message, sprintf('D = 0.0010 mm2/s'));
message = char(message, sprintf('D* = 0.010 mm2/s'));
message = char(message, sprintf('f = 0.15'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Parameters'));
message = char(message, sprintf('D = %.4f mm2/s', xfit(3)));
message = char(message, sprintf('D* = %.3f mm2/s', xfit(4)));
message = char(message, sprintf('f = %.2f', xfit(2)));
hd = msgbox(cellstr(message), 'Results for Ideal Data (Poor Estimates)');
set(hd, 'position', [300 300 350 150]);

pause

clear all
close all
