%% information
% facial age estimation
% regression method: linear regression
% last updated: Feb 2013

%% settings
clear;
clc;

% path 
database_path = './data_age.mat';
result_path = './results/';

% initial states
absTestErr = 0;
cs_number = 0;


% cumulative error level
err_level = 5;

%% Training 
load(database_path);

nTrain = length(trData.label); % number of training samples
nTest  = length(teData.label); % number of testing samples
xtrain = trData.feat; % feature
ytrain = trData.label; % labels

w_lr = regress(ytrain,xtrain);
   
%% Testing
xtest = teData.feat; % feature
ytest = teData.label; % labels

yhat_test = xtest * w_lr;

%% Compute the MAE and CS value (with cumulative error level of 5) for linear regression 
error_lr = abs(yhat_test-ytest);
mae_lr = sum(error_lr)/size(ytest, 1);
i =5;
CS = sum(error_lr < i == 1)/ size(ytest, 1);

fprintf('MAE(Linear regression(OLS) = %f\n', mae_lr);
fprintf('CS(5) = %f\n', CS);


%% generate a cumulative score (CS) vs. error level plot by varying the error level from 1 to 15. The plot should look at the one in the Week6 lecture slides
for i = 1:15
    CS(i) = sum(error_lr < i == 1)/ size(ytest, 1);
end

plot (CS, 'b-o')

xlabel('Error Level')
ylabel('CS_OLS')

    
%% Compute the MAE and CS value (with cumulative error level of 5) for both partial least square regression and the regression tree model by using the Matlab built in functions.

% Partial least square regression
[XL,yl,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(xtrain, ytrain, 10);

yhat_test_plsr = [ones(size(xtest,1),1) xtest]*beta;

error_plsr = abs(yhat_test_plsr-ytest);
mae_plsr = sum(error_plsr)/size(ytest, 1);
i=5;
CS_plsr = sum(error_plsr < i == 1)/ size(ytest, 1);

fprintf('MAE(Partial Least square regression) = %f\n', mae_plsr);
fprintf('CS(5) = %f\n', CS_plsr);

%% 

% Regression tree
w_rt = fitrtree(xtrain, ytrain);
yhat_test_rt = predict(w_rt, xtest);

error_rt = abs(yhat_test_rt-ytest);
mae_rt = sum(error_rt)/size(ytest, 1);
i=5;
CS_rt = sum(error_rt < i == 1)/ size(ytest, 1);

fprintf('MAE(regression tree) = %f\n', mae_rt);
fprintf('CS(5) = %f\n', CS_rt);

%% Compute the MAE and CS value (with cumulative error level of 5) for Support Vector Regression by using LIBSVM toolbox
addpath(genpath('/Users/tanmaiyiirao/Desktop/ecs797/lab1/ECS797Lab1/software'));
svr = fitrsvm(xtrain, ytrain);
yhat_test_svr = predict(svr, xtest);

error_svr = abs(yhat_test_svr-ytest);
mae_svr = sum(error_svr)/size(ytest, 1);
i=5;
CS_svr = sum(error_svr < i == 1)/ size(ytest, 1);

fprintf('MAE(SVR) = %f\n', mae_svr);
fprintf('CS(5) = %f\n', CS_svr);

%% 
% Plot of Cumulative Score (CS) for error level 1 to 15 for the different models 


for i = 1:15
    CS(i) = sum(error_lr < i == 1)/ size(ytest, 1);
end

for i = 1:15
    CS_plsr(i) = sum(error_plsr < i == 1)/ size(ytest, 1);
end


for i = 1:15
    CS_rt(i) = sum(error_rt < i == 1)/ size(ytest, 1);
end

for i = 1:15
    CS_svr(i) = sum(error_svr < i == 1)/ size(ytest, 1);
end

i = 1:15;

figure
plot(i, CS(i), 'g-o'); hold on;
plot(i, CS_plsr(i),'r-o');  hold on;
plot(i, CS_rt(i), 'black-o');  hold on;
plot(i, CS_svr(i),'b-o');  hold off;
title('CS plot')
legend('Linear regression(OLS)','Partial least square regression','Regression tree','SVR')
legend('Location','southeast')
ylabel('Cumulative score')
xlabel('Error level')

