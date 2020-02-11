import numpy as np


def get_weights(labels, numOfCategories):
    labels = labels.astype(int)
    w = np.zeros(numOfCategories)
    for i in np.nditer(labels):
        w[i] += 1
    w = (1 /(w / np.sum(w)))
    return w / w[4]


def class_acc(y_test, y_pred, weights):
    n_categories = weights.size
    classification_components = np.zeros([n_categories, 2])  # 0 = Correct,  1 = Incorrect

    for i in range(y_test.size):
        if y_test[i] == y_pred[i]:
            classification_components[int(y_test[i])][0] += 1
        else:
            classification_components[int(y_test[i])][1] += 1

    unweighted_score = np.zeros(n_categories)
    for i in range(weights.size):
        unweighted_score[i] = classification_components[i][0] / (max(classification_components[i][0] +
                                                                 classification_components[i][1], 1))

    return_val = 0
    return_ind = 0
    for i in range(weights.size):
        if classification_components[i][0] + classification_components[i][1] == 0:
            continue
        return_val += unweighted_score[i]
        return_ind += 1

    return return_val/return_ind
    # return np.sum(np.multiply(unweighted_score, weights))
