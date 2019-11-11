import pandas as pd
import sklearn.datasets
import numpy as np
from numpy import cov
import matplotlib.pyplot as plt

# load train data
TrainDF = pd.read_csv(
    "/Users/adebisiafolalu/Desktop/OneDrive/Documents/MSc_Assignments/Semester2/Data_Analytics/dataset/35_train.csv")
# print(TrainDF)


# split train data into X and class labels y
X = TrainDF.iloc[:, 1:35]


# data scaling
X_std = sklearn.preprocessing.StandardScaler().fit_transform(X)


# covariance matrix
print('Covariance matrix: \n%s' % cov(X_std.T))


# eigendecomposition on covariance matrix
cov_mat = np.cov(X_std.T)

eigen_vals, eigen_vecs = np.linalg.eig(cov_mat)

print('Eigenvectors \n%s' %eigen_vecs)
print('\nEigenvalues \n%s' %eigen_vals)


# make a list of (eigenvalue, eigenvector) tuples
eigen_pairs = [(np.abs(eigen_vals[i]), eigen_vecs[:,i]) for i in range(len(eigen_vals))]
eigen_pairs = [(np.abs(eigen_vals[i]), eigen_vecs[:,i]) for i in range(len(eigen_vals))]

# sort the (eigenvalue, eigenvector) tuples in descending order
eigen_pairs.sort()
eigen_pairs.reverse()


# visually confirm that the list is correctly sorted by decreasing eigenvalues
print('Eigenvalues in descending order:')

eig_list = []
for i in eigen_pairs:
    #print(i[0])
    eig_list.append(i[0])

PC_lab = [x+1 for x in range(len(eig_list))]
z = zip(PC_lab, eig_list)
d = dict(z)
print(d)

#calculates the explained variance as a percentage
total = sum(eigen_vals)
exp_var = [(i / total)*100 for i in sorted(eigen_vals, reverse=True)]
print('Explained Variance % in descending order:')
print(exp_var)


#generates a barchart of explained variance against PC
plt.bar(d.keys(), exp_var)
plt.xlabel('Principal Components (PC)')
plt.ylabel('Explained Variance %')
plt.title('Principal Component Analysis (PCA)')
plt.show()

