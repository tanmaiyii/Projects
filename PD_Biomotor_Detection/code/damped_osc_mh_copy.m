
%https://uk.mathworks.com/help/stats/nlinfit.html 
clear all; 
close all;

Le = readtable('left_leg_speed.csv');
Le = table2cell(Le);
save('left_speed.mat','Le'); 
% 

load ('left_speed.mat');
Le = cell2mat(Le);

x_max = 200;
x = Le(:,1);
y_obs = Le(:,2);

% smooth the data
y_obs = smoothdata(y_obs, 'gaussian',3);

%% 
Ld_gait = readtable('left_leg_speed.csv');
Ld_gait = table2cell(Ld_gait);
save('left_mat/Ld_gait.mat','Ld_gait'); 
% % 
load ('left_mat/Ld_gait.mat');
Ld_gait = cell2mat(Ld_gait);
f_x = Ld_gait(:,2);
% 
% 

Maxlag = 100;
W = [0.1, linspace(1, 00.1, Maxlag-1)];
%ft_data = (f_x-mean(f_x))/std(f_x);
peak = peak2peak(f_x);
RMS = rms(f_x);
ft_trend = detrend(f_x);
figure(1)
plot(f_x);
n_smooth = smoothdata(ft_trend, 'gaussian',10);
figure(2)
plot(n_smooth);
xlabel('Time'),ylabel('Distance');
hold on
title('Left Time Series with Smoothing - Gait')
print('Lsmooth_gait','-dpdf')
gacf_y = pACF(n_smooth, Maxlag);
gacf_x = 0:(length(gacf_y)-1);
figure(3)
plot(gacf_x,gacf_y);
xlabel('Lags'),ylabel('ACF');
hold on
title('ACF - left_gait Speed')
print('LACF_gait','-dpdf')
% % %% Import sunspot data
% 
% ssData = csvread('zuerich-monthly-sunspot-numbers-.csv',1,1);
% ssData(end)=[]; % remove last element from data as it is a 0
% % plot sunspot data
% figure(4)
% dateT = 1:(1983-1748)*12; %linspace(0,200, length(ssData));
% plot(dateT,ssData)
% xlabel('Months')
% ylabel('Sunspots')
% title('Number of Sun Spots per Months 1749-1983')
% print('validation/sunspot_data','-dpdf')
% 
% Maxlag = 500;
% W = [0.1, linspace(1, 00.1, Maxlag-1)];
% 
% dt_ssData = detrend(ssData);
% n_ssData = (dt_ssData-mean(dt_ssData))/std(dt_ssData);
% 
% figure(5)
% gacf_y = pACF(n_ssData, Maxlag);
% gacf_x = 0:(length(gacf_y)-1);
% figure(5)
% plot(gacf_x,gacf_y)
% xlabel('Lags')
% ylabel('ACF')
% hold on
% title('ACF for Sun Spot Data')
% print('validation/sunspot_acf','-dpdf')
% %% Generate dummy data
% noise_lev = 0.1;
% %dh_fun = @dampedHarmonic;
% %x_d = linspace(0,20, 200);
% %y = feval(dh_fun, x,1, 1, 1, 0)
% %y_d = sin(x_d) + noise_lev*randn(size(x_d));
% 
% %model = @(pars,gacf_x)(1./(1+pars(1).*gacf_x) .* cos(pars(2).*gacf_x));
%     
%     %              ((1-pars(5)).*cos(pars(3).*gacf_x) + pars(5).*cos(pars(4))));
% model = @(pars,gacf_x)(exp(-pars(1).*gacf_x) .* cos(pars(2).*gacf_x));
% 
% % RANSAC parameter sampling
% num_try = 100000;
% %scale_try = max(gacf_y) + 0.01 * randn(num_try,1);
% decay_try = 0.1 + 0.1*randn(num_try,1);
% %0.0001 + (0.1 - 0.0001) * rand(num_try,1);
% freq_try = 2*pi/50 + 0.01 * rand(num_try,1);
% %freq2_try = 2*pi/50 + 2*pi*(1/2.5-1/10) * rand(num_try,1);
% %blend_try = rand(num_try,1);
% 
% err_min = inf;
% pars = [];
% 
% for k = 1:num_try
%    pars_try = [decay_try(k), freq_try(k)];
%    y_try = model(pars_try,gacf_x);
%    % absolute error
%    err_try = sum(abs(y_try - gacf_y));
%    if err_try < err_min
%       % keep this set
%       pars = pars_try;
%       err_min = err_try;
%    end
% end
% 
% % Nonlinear optimzation
% opts.RobustWgtFun = 'cauchy';
% [pars_opt,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(gacf_x, gacf_y, model, pars, opts)
% 
% y_try = model(pars,gacf_x);
% y_opt = model(pars_opt,gacf_x);
% %y_d = model(pars, x_d) +
% %y_f = model(pars_opt, x_d);
% 
% figure(6)
% plot(gacf_x,gacf_y, 'DisplayName', 'Actual');
% hold on;
% %plot(x_d,y_d, 'DisplayName', 'Actual' );
% %plot(x_d,y_f, 'DisplayName', 'Optimiser' );
% plot(gacf_x, y_opt, 'DisplayName', 'Optimiser');
% xlabel('Lags'),ylabel('ACF');
% title('Curve Fit for SunSpot - ACF');
% hold off;
% lgd = legend;
% lgd.FontSize = 14;
% lgd.Title.String = ['MSE =', num2str(MSE)];
% print('validation/D_OSc_sunspot_exp','-dpdf')
% 
% save('sunspot.mat', 'pars_opt', '-v7.3');
% name = 'sunspot';
% save('sunspot.mat', 'name', 'pars_opt', '-append','-nocompression');
% 
% LE = load('sunspot.mat')
% MSE
% %RMS
% f = (pars_opt(2)/2.*pi)*30
% %peak