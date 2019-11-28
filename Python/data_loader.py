import numpy as np
import torch


def load_data_file(filename, idx):
    data = np.genfromtxt(filename, delimiter=',')
    data_train = data[idx[:4000]]
    data_test = data[idx[4000:5000]]
    return data_train, data_test
