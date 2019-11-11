
load('PB12.mat');
%concatenating the data into one matrix
X = vertcat(X1, X2);
%calculating the min and max for X1(phoneme1)
min_x1 = min(X(:,1));
max_x1 = max(X(:,1));
%calculating the min and max for X2(phoneme2)
min_x2 = min(X(:,2));
max_x2 = max(X(:,2));


%making a grid for all the values between the min and max of X1 and X2
[grid1, grid2] = meshgrid(min_x1:max_x1,min_x2:max_x2) ;


M = [grid1(:), grid2(:)];

%loading the model for phno =2 for k=3
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
x1 = M;



 %Classifying for model 1 = phoneme 1 , k =3
 [n D] = size(x1);
 k=3;
 
 % p1(x) for phno 1
 for i=1:k
      Z_1(:,i) = p1(i)*(2*pi)^(-D*0.5)*det(s2_1(:,:,i))^(-0.5)*exp(-0.5*sum((x1'-repmat(mu_1(:,i),1,n))'*inv(s2_1(:,:,i)).*(x1'-repmat(mu_1(:,i),1,n))',2));
 end
    sum_a = sum(Z_1,2);
    
%p2(x) for phno 2 
 for i=1:k
      Z_2(:,i) = p2(i)*(2*pi)^(-D*0.5)*det(s2_2(:,:,i))^(-0.5)*exp(-0.5*sum((x1'-repmat(mu_2(:,i),1,n))'*inv(s2_2(:,:,i)).*(x1'-repmat(mu_2(:,i),1,n))',2));
 end
    sum_b = sum(Z_2,2);
    
    
    
    
    %checking whether example belongs to phoneme1 or phoneme2
    
    lh = [sum_a, sum_b];
    [~, M1] = max(lh, [], 2);
    
    %reshaping the vector into a grid
    M1 = reshape(M1, [1901, 491]);
    
    %plotting the grid
    imagesc(M1);
    
     
    %to check which color belongs to which phoneme
    %then compare with the plot of the classification matrix
    plot(X1(:,1),X1(:,2), 'b.'); %phoneme1
    hold on;
    plot(X2(:,1),X2(:,2), 'r.'); %phoneme2

   
 