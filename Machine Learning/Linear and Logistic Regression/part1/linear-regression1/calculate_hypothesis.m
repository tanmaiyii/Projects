function hypothesis = calculate_hypothesis(X, theta, training_example)
    %CALCULATE_HYPOTHESIS This calculates the hypothesis for a given X,
    %theta and specified training example

    %hypothesis = 0:0 ;
    
hypothesis = X(training_example, 1) * theta(1) + X(training_example, 2) * theta(2);

end

