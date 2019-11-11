
%loading the model for phno =1 for k=6
load('c.mat');
mu_3 = c.mu;
s2_3 = c.s2;
p3 = c.p;

%loading the model for phno =2 for k=6
load('d.mat');
mu_4 = d.mu;
s2_4 = d.s2;
p4 = d.p;

% Initialise parameters
load('PB_data.mat');
J = [f1 f2];

%phoneme sets
set1 = find(phno==1);
set2 = find(phno==2);

% test set
x_t1 = J(set1(122:152),:);
x_t2 = J(set2(122:152),:);

% combining for phno 1 and phno 2 in one test set
x_t = vertcat(x_t1, x_t2);

ground_truth = vertcat(ones(length(x_t1), 1), ones(length(x_t2), 1) + 1);


%Classifying for model 1 = phoneme 1 , k =6
[n D] = size(x_t);
 k=6;

 % p1(x) for phno 1
 for i=1:k
     Z3(:,i) = p3(i)*(2*pi)^(-D*0.5)*det(s2_3(:,:,i))^(-0.5)*exp(-0.5*sum((x_t'-repmat(mu_3(:,i),1,n))'*inv(s2_3(:,:,i)).*(x_t'-repmat(mu_3(:,i),1,n))',2));
 end
    sum_3 = sum(Z3,2);
  
 %p2(x) for phno 2  
 for i=1:k
      Z4(:,i) = p4(i)*(2*pi)^(-D*0.5)*det(s2_4(:,:,i))^(-0.5)*exp(-0.5*sum((x_t'-repmat(mu_4(:,i),1,n))'*inv(s2_4(:,:,i)).*(x_t'-repmat(mu_4(:,i),1,n))',2));
 end
    sum_4 = sum(Z4,2);
    
    % phoneme classifier
    compare = [sum_3, sum_4];
    % comparing the values in each phoneme using the max function
    [~, model] = max(compare, [], 2)
    
   %accuracy and the misclassification rate
   test_acc = sum((model == ground_truth)/length(ground_truth))*100
   test_error = 100 - test_acc
    
   
    
    