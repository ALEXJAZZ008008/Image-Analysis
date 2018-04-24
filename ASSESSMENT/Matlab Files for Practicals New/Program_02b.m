% Program_02b

% Polynomial Fitting

warning off;

% Create data to perform polynomial fitting on
num_pts = 35;

T_Data = 1:num_pts;
last_x = T_Data(end);

S_Data = [43.0 23.4 20.1 29.0 52.5 78.0 116.1 162.3 195.3 256.9 294.7 352.8 379.9 415.6 479.9 497.6 506.4 507.3 552.8 553.1 521.8 518.2 552.4 510.6 467.3 446.8 427.0 434.0 392.0 373.8 353.9 328.0 353.52 340.4 360.0];

figure('Name','Experimental Data','NumberTitle','off');
plot(T_Data, S_Data,'o')
hold off

% Input polynomial order required
prompt = {'Enter polynomial order:'};
dlg_title = 'Polynomial Order';
num_lines = 1;
def = {'2'};
answer = newid(prompt,dlg_title,num_lines,def);
poly_order = str2double(answer);

% Fit data to nth order polynomial
p_fit = polyfit(T_Data, S_Data, poly_order);

% Create polynomial at fine resolution for display
x1 = linspace(1,last_x);
y1 = polyval(p_fit,x1);

figure('Name','Polynomial Fit','NumberTitle','off');
plot(T_Data, S_Data,'o')
hold on
plot(x1,y1)
hold off
titletext = sprintf('Fit to Polynomial of Order %d', poly_order);
title(titletext)

% Create polynomial at data resolution for R squared calculation
x2 = 1:last_x;
y2 = polyval(p_fit,x2);

% Calculate R squared and AIC
SSR = 0;
SST = 0;
mean_y = mean(S_Data);
for i=1:num_pts
    SSR = SSR + (y2(i) - mean_y)*(y2(i) - mean_y);
    SST = SST + (S_Data(i) - mean_y)*(S_Data(i) - mean_y);
end
R_squared = SSR/SST;
dof = poly_order+2;
if poly_order==2, dof = dof + 2; end
AIC = 2*dof - num_pts*log(R_squared/num_pts);

% Display results
message = sprintf('');
message = char(message, sprintf('R squared = %.3f', R_squared));
message = char(message, sprintf('Akaike Information Criterion = %.2f', AIC));
titletext = sprintf('Quality of Fit for Polynomial of Order %d', poly_order);
hd = msgbox(cellstr(message), titletext);
set(hd, 'position', [300 300 300 75]);
