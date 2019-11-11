%% This loads our data
[X, y] = load_data_ex2();


%% Normalise and initialize.


[X, mean_vec, std_vec] = normalise_features(X);


%after normalising we add the bias
X = [ones(size(X, 1), 1), X];


%initialise theta
theta = [0.0, 0.0, 0.0];
alpha = 0.1;
iterations = 100;


%% 
t = gradient_descent(X, y, theta, alpha, iterations);
disp 'Press enter to exit!';
pause;


%%Predict = X*t'

x0 = 1;
x1 = (1650 - mean_vec(1))/std_vec(1);
x2 = (3 - mean_vec(2))/std_vec(2);

predict = [x0 x1 x2]*t'






