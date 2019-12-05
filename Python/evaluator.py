import numpy as np


def get_weights(labels, numOfCategories):
    labels = labels.astype(int)
    w = np.zeros(numOfCategories)
    for i in np.nditer(labels):
        w[i] += 1
    return w / np.sum(w)


def f1score(y_test, y_pred, weights):
    n_categories = weights.size
    classification_components = np.zeros([n_categories, 4])  # 0 = TP,  1 = FP, 2 = TN, 3 = FN
    score_components = np.zeros([n_categories, 3])  # 0 = Recall, 1 = Precision, 2 = Specificity,

    for i in range(y_test.size):
        for j in range(n_categories):
            if y_test[i] == j:
                if y_test[i] == y_pred[i]:
                    classification_components[j][0] += 1
                else:
                    classification_components[j][3] += 1
            else:
                if y_test[i] == j:
                    if y_test[i] == y_pred[i]:
                        classification_components[j][2] += 1
                    else:
                        classification_components[j][1] += 1

    for i in range(classification_components.shape[0]):
        score_components[i][0] = classification_components[i][0] / (classification_components[i][0] + classification_components[i][3])  # Recall = TP / (TP + FN)
        score_components[i][1] = classification_components[i][0] / (classification_components[i][0] + classification_components[i][1])  # Precision = TP / (TP + FP)
        score_components[i][2] = classification_components[i][2] / (classification_components[i][2] + classification_components[i][3])  # Spec = TN / (TN + FN)
    score_components = np.nan_to_num(score_components)

    unweighted_score = np.zeros(weights.size)
    for i in range(score_components.shape[0]):
        unweighted_score[i] = (2 * score_components[i][0] * score_components[i][1])/(score_components[i][0] + score_components[i][1])
    unweighted_score = np.nan_to_num(unweighted_score)
    return np.mean(unweighted_score)
    # return np.sum(np.multiply(unweighted_score, weights))
