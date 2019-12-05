import numpy as np


def get_weights(labels, numOfCategories):
    labels = labels.astype(int)
    w = np.zeros(numOfCategories)
    for i in np.nditer(labels):
        w[i] += 1
    return w / np.sum(w)


def f1score(y_test, y_pred, w):
    return
