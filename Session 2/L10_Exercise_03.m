% L10_Exercise_03

warning off;

% Create polynomial test data
T_Data = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
S_Data = -0.7*T_Data.*T_Data.*T_Data + 23*T_Data.*T_Data + 30*T_Data + 200;
num_pts = size(T_Data,2);
last_x = T_Data(end);

figure('Name','Experimental Data','NumberTitle','off');
plot(T_Data, S_Data,'o')
hold off

pause

% Fit data to 2nd order polynomial
p_2nd = polyfit(T_Data, S_Data, 2);

% Create polynomial at fine resolution
x1 = linspace(0,last_x);
y1 = polyval(p_2nd,x1);

figure('Name','2nd Order Polynomial Fit (Perfect Data)','NumberTitle','off');
plot(T_Data, S_Data,'o')
hold on
plot(x1,y1)
hold off

% Display results
message = sprintf('Correct Polynomial');
message = char(message, sprintf('y = ????'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Polynomial (2nd Order)'));
message = char(message, sprintf('y = %.2f*x^2 + %.2f*x + %.2f', p_2nd(1), p_2nd(2), p_2nd(3)));
hd = msgbox(cellstr(message), 'Polynomial Information for Perfect Data');
set(hd, 'position', [300 300 350 100]);

% Create polynomial at data resolution for R squared calculation
x2 = 0:1:last_x;
y2 = polyval(p_2nd,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Data);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Data(i) - mean_y)*(S_Data(i) - mean_y);
end
R_squared_2nd_ideal = SSR/SST;
AIC_2nd_ideal = 2*(3+1) - num_pts*log(R_squared_2nd_ideal/num_pts);

pause

% Fit data to 3rd order polynomial
p_3rd = polyfit(T_Data, S_Data, 3);

% Create polynomial at fine resolution
x1 = linspace(0,30);
y1 = polyval(p_3rd,x1);

figure('Name','3rd Order Polynomial Fit (Perfect Data)','NumberTitle','off');
plot(T_Data, S_Data,'o')
hold on
plot(x1,y1)
hold off

% Display results
message = sprintf('Correct Polynomial');
message = char(message, sprintf('y = -0.70*x^3 + 23.00*x^2 + 30.00*x + 200.00'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Polynomial (3rd Order)'));
message = char(message, sprintf('y = %.2f*x^3 + %.2f*x^2 + %.2f*x + %.2f', p_3rd(1), p_3rd(2), p_3rd(3), p_3rd(4)));
hd = msgbox(cellstr(message), 'Polynomial Information for Perfect Data');
set(hd, 'position', [300 300 350 100]);

% Create polynomial at data resolution for R squared calculation
y2 = polyval(p_3rd,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Data);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Data(i) - mean_y)*(S_Data(i) - mean_y);
end
R_squared_3rd_ideal = SSR/SST;
AIC_3rd_ideal = 2*(4+1) - num_pts*log(R_squared_3rd_ideal/num_pts);

pause

% Fit data to 7th order polynomial
p_7th = polyfit(T_Data, S_Data, 7);

% Create polynomial at fine resolution
y1 = polyval(p_7th,x1);

figure('Name','7th Order Polynomial Fit (Perfect Data)','NumberTitle','off');
plot(T_Data, S_Data,'o')
hold on
plot(x1,y1)
hold off

% Display results
message = sprintf('Correct Polynomial');
message = char(message, sprintf('y = -0.70*x^3 + 23.00*x^2 + 30.00*x + 200.00'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Polynomial (7th Order)'));
message = char(message, sprintf('y = %.2f*x^7 + %.2f*x^6 + %.2f*x^5 + %.2f*x^4', p_7th(1), p_7th(2), p_7th(3), p_7th(4)));
message = char(message, sprintf('+ %.2f*x^3 + %.2f*x^2 + %.2f*x + %.2f', p_7th(5), p_7th(6), p_7th(7), p_7th(8)));
hd = msgbox(cellstr(message), 'Polynomial Information for Perfect Data');
set(hd, 'position', [300 300 350 100]);

% Create polynomial at data resolution for R squared calculation
y2 = polyval(p_7th,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Data);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Data(i) - mean_y)*(S_Data(i) - mean_y);
end
R_squared_7th_ideal = SSR/SST;
AIC_7th_ideal = 2*(8+1) - num_pts*log(R_squared_7th_ideal/num_pts);

pause

% Input noise level required
prompt = {'Enter noise level (% of maximum signal):'};
dlg_title = 'Noise level';
num_lines = 1;
def = {'20'};
answer = newid(prompt,dlg_title,num_lines,def);
noise_percent = str2double(answer);

% Generate noise for individual points
% Noise will be between -1 and +1
noise = 2*(rand(31,1)-0.5);
% Scale by appropriate percentage
noise = noise*max(S_Data)*noise_percent/100;
noise = noise';

% Add noise to signal
S_Noisy = S_Data+noise;

figure('Name','Experimental Data (Noisy)','NumberTitle','off');
plot(T_Data, S_Noisy,'o')
hold off

pause

% Fit data to 2nd order polynomial
p_2nd_noisy = polyfit(T_Data, S_Noisy, 2);

% Create polynomial at fine resolution
x1 = linspace(0,30);
y1 = polyval(p_2nd_noisy,x1);

figure('Name','2nd Order Polynomial Fit (Noisy Data)','NumberTitle','off');
plot(T_Data, S_Noisy,'o')
hold on
plot(x1,y1)
hold off

% Display results
message = sprintf('Correct Polynomial');
message = char(message, sprintf('y = -0.70*x^3 + 23.00*x^2 + 30.00*x + 200.00'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Polynomial (2nd Order)'));
message = char(message, sprintf('y = %.2f*x^2 + %.2f*x + %.2f', p_2nd_noisy(1), p_2nd_noisy(2), p_2nd_noisy(3)));
hd = msgbox(cellstr(message), 'Polynomial Information for Noisy Data');
set(hd, 'position', [300 300 350 100]);

% Create polynomial at data resolution for R squared calculation
y2 = polyval(p_2nd_noisy,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Noisy);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Data(i) - mean_y)*(S_Data(i) - mean_y);
end
R_squared_2nd_noisy = SSR/SST;
AIC_2nd_noisy = 2*(3+1) - num_pts*log(R_squared_2nd_noisy/num_pts);

pause

% Fit data to 3rd order polynomial
p_3rd_noisy = polyfit(T_Data, S_Noisy, 3);

% Create polynomial at fine resolution
y1 = polyval(p_3rd_noisy,x1);

figure('Name','3rd Order Polynomial Fit (Noisy Data)','NumberTitle','off');
plot(T_Data, S_Noisy,'o')
hold on
plot(x1,y1)
hold off

% Display results
message = sprintf('Correct Polynomial');
message = char(message, sprintf('y = -0.70*x^3 + 23.00*x^2 + 30.00*x + 200.00'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Polynomial (3rd Order)'));
message = char(message, sprintf('y = %.2f*x^3 + %.2f*x^2 + %.2f*x + %.2f', p_3rd_noisy(1), p_3rd_noisy(2), p_3rd_noisy(3), p_3rd_noisy(4)));
hd = msgbox(cellstr(message), 'Polynomial Information for Noisy Data');
set(hd, 'position', [300 300 350 100]);

% Create polynomial at data resolution for R squared calculation
y2 = polyval(p_3rd_noisy,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Noisy);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Noisy(i) - mean_y)*(S_Noisy(i) - mean_y);
end
R_squared_3rd_noisy = SSR/SST;
AIC_3rd_noisy = 2*(4+1) - num_pts*log(R_squared_3rd_noisy/num_pts);

pause

% Input polynomial order required
prompt = {'Enter polynomial order:'};
dlg_title = 'Polynomial Order';
num_lines = 1;
def = {'7'};
answer = newid(prompt,dlg_title,num_lines,def);
poly_order1 = str2double(answer);

% Fit data to higher order polynomial
p_nth_noisy = polyfit(T_Data, S_Noisy, poly_order1);

% Create polynomial at fine resolution
x1 = linspace(0,30);
y1 = polyval(p_nth_noisy,x1);

figure('Name','nth Order Polynomial Fit (Noisy Data)','NumberTitle','off');
plot(T_Data, S_Noisy,'o')
hold on
plot(x1,y1)
hold off

% Display results
message = sprintf('Correct Polynomial');
message = char(message, sprintf('y = -0.70*x^3 + 23.00*x^2 + 30.00*x + 200.00'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Polynomial (nth Order)'));
message = char(message, sprintf('y = %.2f*x^%d', p_nth_noisy(1), poly_order1));
for i=2:poly_order1
    message = char(message, sprintf('+ %.2f*x^%d', p_nth_noisy(i), poly_order1-i+1));
end
message = char(message, sprintf('+ %.2f', p_nth_noisy(end)));
hd = msgbox(cellstr(message), 'Polynomial Information for Noisy Data');
set(hd, 'position', [300 300 350 350]);

% Create polynomial at data resolution for R squared calculation
y2 = polyval(p_nth_noisy,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Noisy);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Noisy(i) - mean_y)*(S_Noisy(i) - mean_y);
end
R_squared_nth_noisy1 = SSR/SST;
AIC_nth_noisy1 = 2*(poly_order1+2) - num_pts*log(R_squared_nth_noisy1/num_pts);

pause

% Input polynomial order required
prompt = {'Enter polynomial order:'};
dlg_title = 'Polynomial Order';
num_lines = 1;
def = {'7'};
answer = newid(prompt,dlg_title,num_lines,def);
poly_order2 = str2double(answer);

% Fit data to higher order polynomial
p_nth_noisy = polyfit(T_Data, S_Noisy, poly_order2);

% Create polynomial at fine resolution
x1 = linspace(0,30);
y1 = polyval(p_nth_noisy,x1);

figure('Name','nth Order Polynomial Fit (Noisy Data)','NumberTitle','off');
plot(T_Data, S_Noisy,'o')
hold on
plot(x1,y1)
hold off

% Display results
message = sprintf('Correct Polynomial');
message = char(message, sprintf('y = -0.70*x^3 + 23.00*x^2 + 30.00*x + 200.00'));
message = char(message, sprintf(''));
message = char(message, sprintf('Fitted Polynomial (nth Order)'));
message = char(message, sprintf('y = %.2f*x^%d', p_nth_noisy(1), poly_order2));
for i=2:poly_order2
    message = char(message, sprintf('+ %.2f*x^%d', p_nth_noisy(i), poly_order2-i+1));
end
message = char(message, sprintf('+ %.2f', p_nth_noisy(end)));
hd = msgbox(cellstr(message), 'Polynomial Information for Noisy Data');
set(hd, 'position', [300 300 350 350]);

% Create polynomial at data resolution for R squared calculation
y2 = polyval(p_nth_noisy,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Noisy);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Noisy(i) - mean_y)*(S_Noisy(i) - mean_y);
end
R_squared_nth_noisy2 = SSR/SST;
AIC_nth_noisy2 = 2*(poly_order2+2) - num_pts*log(R_squared_nth_noisy2/num_pts);

pause

% Display results
message = sprintf('R squared values');
message = char(message, sprintf('Ideal data 2nd order polynomial R^2 = %.3f,   AIC = %.3f', R_squared_2nd_ideal, AIC_2nd_ideal));
message = char(message, sprintf('Ideal data 3rd order polynomial R^2 = %.3f,   AIC = %.3f', R_squared_3rd_ideal, AIC_3rd_ideal));
message = char(message, sprintf('Ideal data 7th order polynomial R^2 = %.3f,   AIC = %.3f', R_squared_7th_ideal, AIC_7th_ideal));
message = char(message, sprintf(''));
message = char(message, sprintf('Noisy data 2nd order polynomial R^2 = %.3f,   AIC = %.3f', R_squared_2nd_noisy, AIC_2nd_noisy));
message = char(message, sprintf('Noisy data 3rd order polynomial R^2 = %.3f,   AIC = %.3f', R_squared_3rd_noisy, AIC_3rd_noisy));
message = char(message, sprintf('Ideal data %dth order polynomial R^2 = %.3f,   AIC = %.3f', poly_order1, R_squared_nth_noisy1, AIC_nth_noisy1));
message = char(message, sprintf('Ideal data %dth order polynomial R^2 = %.3f,   AIC = %.3f', poly_order2, R_squared_nth_noisy2, AIC_nth_noisy2));
hd = msgbox(cellstr(message), 'Quality of Data Fit');
set(hd, 'position', [300 300 350 150]);

pause

%clear all
%close all