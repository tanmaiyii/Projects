function hypothesis = calculate_hypothesis(X, theta, training_example)
    %CALCULATE_HYPOTHESIS This calculates the hypothesis for a given X,
    %theta and specified training example

    %hypothesis=0.0;
    % theta_0 = theta(1);
     %theta_1 = theta(2);
     %theta_2 = theta(3);
     hypothesis = X(training_example , :) * theta';
     %hypothesis = X(training_example, 1) * theta(1) + X(training_example, 2) * theta(2)+ X(training_example, 3) * theta(3);
end

