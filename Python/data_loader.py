import numpy as np
import torch


def load_data_file(filename):
    data = np.genfromtxt(filename, delimiter=',')
    return data
