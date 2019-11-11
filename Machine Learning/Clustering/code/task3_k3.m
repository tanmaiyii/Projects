
%loading the model for phno =1 for k=3
load('a.mat');
mu_1 = a.mu;
s2_1 = a.s2;
p1 = a.p;

%loading the model for phno =2 for k=3
load('b.mat');
mu_2 = b.mu;
s2_2 = b.s2;
p2 = b.p;


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

%ground_truth is used to detect the true labels of the phonemes
ground_truth = vertcat(ones(length(x_t1), 1), ones(length(x_t2), 1) + 1);


 %Classifying for k =3
 [n D] = size(x_t);
 k=3;

 % p1(x) for phno 1
 for i=1:k
      Z1(:,i) = p1(i)*(2*pi)^(-D*0.5)*det(s2_1(:,:,i))^(-0.5)*exp(-0.5*sum((x_t'-repmat(mu_1(:,i),1,n))'*inv(s2_1(:,:,i)).*(x_t'-repmat(mu_1(:,i),1,n))',2));
 end
    sum_1 = sum(Z1,2);
    
%p2(x) for phno 2 
 for i=1:k
      Z2(:,i) = p2(i)*(2*pi)^(-D*0.5)*det(s2_2(:,:,i))^(-0.5)*exp(-0.5*sum((x_t'-repmat(mu_2(:,i),1,n))'*inv(s2_2(:,:,i)).*(x_t'-repmat(mu_2(:,i),1,n))',2));
 end
    sum_2 = sum(Z2,2);
    
    % phoneme classifier 
    compare = [sum_1, sum_2];
    % comparing the values in each phoneme using the max function
    [~, model] = max(compare, [], 2)
    
   %accuracy and the misclassification rate
   test_acc = sum((model == ground_truth)/length(ground_truth))*100
   test_error = 100 - test_acc
 
   