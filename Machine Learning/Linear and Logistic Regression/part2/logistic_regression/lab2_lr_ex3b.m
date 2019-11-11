
% this loads our data
[X,y] = load_data_ex1();

% now we want to normalise our data
[X,mean,std] = normalise_features(X);

% after normalising we add the bias
X=[ones(size(X,1),1),X,ones(size(X,1),1),ones(size(X,1),1),ones(size(X,1),1)];
%X=[ones(size(X,1),1),X];
% for question 7, modify the dataset X to have more features (in each row)
	% append to X(i),the following features:
	% here append x_2 * x_3 (remember that x_1 is the bias)

	% here append x_2 * x_2 (remember that x_1 is the bias)
%
	% here append x_3 * x_3 (remember that x_1 is the bias)

% initialise theta. Remember that theta needs to be
% the same size as one row of X
% Task 7 - to have more features
%Task 8 - an addtional feature is added.
for i = 1:size(X,1)
    X(i,4)=X(i,2)*X(i,3);
    X(i,5)=X(i,2)*X(i,2);
    X(i,6)=X(i,3)*X(i,3);
    %X(i,7)=X(i,6)*X(i,3);
end

theta=[1.0,1.0,1.0,1.0,1.0,1.0];
alpha = 0.05;
iterations = 100;

[training_input,training_output,test_input,test_output] = return_test_set(X,y,20);

[t,cost_array]=gradient_descent_training(training_input,training_output,test_input,test_output,theta,alpha,iterations);

% plot_data_function(test,y)

display(['Training:',num2str(compute_cost(training_input,training_output,t))])
display(['Test:',num2str(compute_cost(test_input,test_output,t))])
h=plot_data_function(training_input,training_output,'Training set')
pause()
close(h)
h=plot_data_function(test_input,test_output,'Test set')
pause()
close(h)