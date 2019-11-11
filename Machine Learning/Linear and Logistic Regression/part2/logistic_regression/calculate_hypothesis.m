function result=calculate_hypothesis(X,theta,training_example)
    %hypothesis = 0.0;
    %%%%%%%%%%%%%%%%%%%%%%%%
    %Calculate the hypothesis for the i-th training example in X.
    hypothesis = X(training_example , :) * theta';
    %%%%%%%%%%%%%%%%%%%%%%%%
    result=sigmoid(hypothesis);
%END OF FUNCTION
end

