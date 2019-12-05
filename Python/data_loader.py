import numpy as np


def load_data_file(filename):
    data = np.genfromtxt(filename, delimiter=',')
    return data
