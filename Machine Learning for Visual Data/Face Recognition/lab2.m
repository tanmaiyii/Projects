%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%coursework: face recognition with eigenfaces

% need to replace with your own path
addpath '/Users/tanmaiyiirao/Desktop/ecs797/lab1/ECS797Lab1/software';
%% 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading of the images: You need to replace the directory 
Imagestrain = loadImagesInDirectory ( '/Users/tanmaiyiirao/Desktop/ecs797/lab2/ECS734Lab2/training-set/23x28/');
[Imagestest, Identity] = loadTestImagesInDirectory ( '/Users/tanmaiyiirao/Desktop/ecs797/lab2/ECS734Lab2/testing-set/23x28/');

%% 2 and 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Computation of the mean, the eigenvalues, amd the eigenfaces stored in the
%facespace:
ImagestrainSizes = size(Imagestrain);
Means = floor(mean(Imagestrain));
CenteredVectors = (Imagestrain - repmat(Means, ImagestrainSizes(1), 1));

CovarianceMatrix = cov(CenteredVectors);
%[evectors, score, evalues] = pca(Imagestrain');
[U, S, V] = svd(CenteredVectors);
%Eigenvectors U
%Eigenfaces are S*V'
Space = V(: , 1 : ImagestrainSizes(1))';
Eigenvalues = diag(S);

%% 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display of the mean image:
MeanImage = uint8 (zeros(28, 23));
for k = 0:643
   MeanImage( mod (k,28)+1, floor(k/28)+1 ) = Means (1,k+1);
end
figure;
subplot (1, 1, 1);
imshow(MeanImage);
title('Mean Image');
%% 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display of the 20 first eigenfaces : Write your code here

% Normalise mean to add back to the Eigenface after normalisation
Means = (Means/255.);

EigenFace = zeros(1, 644);
num_eigenfaces = 20;
%Computing Eigenfaces - using V from SVD (Singular Value Decomposition)
eigs = S*V';
%normalization eigenfaces for better visualisation
eigs = 255 *(eigs - min(eigs(:))) ./ (max(eigs(:)) - min(eigs(:)));
% denormalise eigenvector by adding the mean back.
eigenf = eigs + Means;

for k = 1:num_eigenfaces
   EigenFace = eigs(k,:);
   EigenFace = reshape(EigenFace, [28,23]);
   subplot (5,4,k);
   imshow(uint8(EigenFace));
end

%% 
%% 6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Projection of the two sets of images onto the face space:
Locationstrain=projectImages (Imagestrain, Means, Space);
Locationstest=projectImages (Imagestest, Means, Space);

Threshold =20;

TrainSizes=size(Locationstrain);
TestSizes = size(Locationstest);
Distances=zeros(TestSizes(1),TrainSizes(1));
%% 7

%Distances contains for each test image, the distance to every train image.

for i=1:TestSizes(1)
    for j=1: TrainSizes(1)
        Sum=0;
        for k=1: Threshold
   Sum=Sum+((Locationstrain(j,k)-Locationstest(i,k)).^2);
        end
     Distances(i,j)=Sum;
    end
end

Values=zeros(TestSizes(1),TrainSizes(1));
Indices=zeros(TestSizes(1),TrainSizes(1));
for i=1:70
[Values(i,:), Indices(i,:)] = sort(Distances(i,:));
end

%% 8

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display of first 6 recognition results, image per image:
figure;
x=6;
y=2;
for i=1:6
      Image = uint8 (zeros(28, 23));
      for k = 0:643
     Image( mod (k,28)+1, floor(k/28)+1 ) = Imagestest (i,k+1);
      end
   subplot (x,y,2*i-1);
    imshow (Image);
    title('Image tested');
    
    Imagerec = uint8 (zeros(28, 23));
      for k = 0:643
     Imagerec( mod (k,28)+1, floor(k/28)+1 ) = Imagestrain ((Indices(i,1)),k+1);
      end
     subplot (x,y,2*i);
imshow (Imagerec);
title(['Image recognised with ', num2str(Threshold), ' eigenfaces:',num2str((Indices(i,1))) ]);
end


%% 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recognition rate compared to the number of test images: Write your code here to compute the recognition rate using top 20 eigenfaces.
recognition_rate = zeros(1, length(Imagestest(:,1)));

for i = 1: length(Imagestest(:,1))
    %the recognition rate has been computed by identifying the indexes of the 20 eigenfaces;
    % if the indices of train does not match with Identity in test then rate is 0.
    if ceil(Indices(i,1)/5) == Identity(i)
        rec_rate(i) = 1;
    else 
        rec_rate(i) = 0;
    end
end
% The total recognition rate for the whole test set that has 70 images
recognition_rate = sum(rec_rate)/70 *100



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% 10
%effect of threshold (i.e. number of eigenfaces):   

averageRR=zeros(1,20);
for t=1:10
  Threshold =t;  
  Distances=zeros(TestSizes(1),TrainSizes(1));

  for i=1:TestSizes(1)
      for j=1: TrainSizes(1)
          Sum=0;
          for k=1: Threshold
              Sum=Sum+((Locationstrain(j,k)-Locationstest(i,k)).^2);
          end
          Distances(i,j)=Sum;
      end
  end
  Values=zeros(TestSizes(1),TrainSizes(1));
  Indices=zeros(TestSizes(1),TrainSizes(1));
  number_of_test_images=zeros(1,40);% Number of test images of one given person.%YY I modified here
  for i=1:70
      number_of_test_images(1,Identity(1,i))= number_of_test_images(1,Identity(1,i))+1;%YY I modified here
      [Values(i,:), Indices(i,:)] = sort(Distances(i,:));
  end
  recognised_person=zeros(1,40);
  recognitionrate=zeros(1,5);
  number_per_number=zeros(1,5);
  
  i=1;
  while (i<70)
      id=Identity(1,i);   
      distmin=Values(id,1);
      indicemin=Indices(id,1);
      while (i<70)&&(Identity(1,i)==id)
          if (Values(i,1)<distmin)
              distmin=Values(i,1);
              indicemin=Indices(i,1);
          end
          i=i+1;
      end
      recognised_person(1,id)=indicemin;
      number_per_number(number_of_test_images(1,id))=number_per_number(number_of_test_images(1,id))+1;
      if (id==floor((indicemin-1)/5)+1) %the good personn was recognised
          recognitionrate(number_of_test_images(1,id))=recognitionrate(number_of_test_images(1,id))+1;
      end
  end
  for  i=1:5
      recognitionrate(1,i)=recognitionrate(1,i)/number_per_number(1,i);
  end
  averageRR(1,t)=mean(recognitionrate(1,:));
end
figure;
plot(averageRR(1,:));
title('Recognition rate against the number of eigenfaces used');
%% 11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%To investigate the effect of using KNN % Plotting the average recognition rate against K. 

train_lab = [];
for i = 1:40
    train_lab = horzcat(train_lab, repmat(i,1,5));
end
%% 
% can set the value of K (nearest neighbours)
K=1:20;
rec_rate = zeros(1,20);

% the identity of the test image was found using KNN
% The obtained identity was evaluated.
% The recognition rate is calculated
for k = 1:20
    knn = fitcknn(Imagestrain, train_lab, 'NumNeighbors', k);
    knn_prediction = predict(knn, Imagestest);
    knn_rec_rate = zeros(1, length(Imagestest(:,1)));
    
    for i = 1:length(Imagestest(:,1))
        if ceil(Indices(i,1)/5) == knn_prediction(i)
            knn_rec_rate(i) = 1;
        else
            knn_rec_rate(i) = 0;
        end
    end
    
    rec_rate(k) = (sum(knn_rec_rate)/70)*100;
end
figure
plot(K, rec_rate);
Xlabel('K'); ylabel('Recognition rate')



