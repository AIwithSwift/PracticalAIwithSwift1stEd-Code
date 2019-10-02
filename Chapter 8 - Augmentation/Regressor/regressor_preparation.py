# BEGIN regpyimp
import csv
import numpy as np
from sklearn.datasets import load_boston
# END regpyimp

# BEGIN regpyvars1
dataset = load_boston()
# END regpyvars1

# BEGIN regpyvars2
attributes = np.array(dataset.data)
outcome = np.array(dataset.target)
output_filename = 'housing.csv'
headings = ['RM', 'LSTAT', 'PTRATIO', 'MEDV']
# END regpyvars2

# BEGIN regpyworking
with open(output_filename, 'w+') as output_file:
	writer = csv.writer(output_file)
	writer.writerow(headings)
	for index, row in enumerate(attributes):
		values = [row[5], row[12], row[10], outcome[index]]
		writer.writerow(values)
# END regpyworking