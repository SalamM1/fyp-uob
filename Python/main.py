import numpy as np
from keras import optimizers

import data_loader as loader
import evaluator as eval
import weighted_categorical_crossentropy as my_loss
from keras.layers import Dense
from keras.models import Sequential
from keras.utils import to_categorical


def main():
    # Variables
    hidden_layer_count = 1
    layer_size = 10
    activation = 'relu'
    epoch_count = 30
    batch_size = 30
    optimizer = 'adam'
    learning_rate = 0.006
    verbose = 0
    summary = False
    trials = 5

    data_file = "features_100_lda.txt"
    train_test_split = 0.8
    validation_split = 0.15

    # Constants and Calculated Values
    n_labels = 5302
    n_train = int(n_labels * train_test_split)
    n_test = int(n_labels * (1-train_test_split))

    for trial in range(trials):
        idx = np.arange(n_labels)  # indices for all data points in x
        np.random.shuffle(idx)

        x_data = loader.load_data_file("data/" + data_file)
        x_data_train = x_data[idx[:n_train]]
        x_data_test = x_data[idx[n_train:(n_train + n_test)]]
        y_data = loader.load_data_file("data/labels.txt")
        y_data_train = to_categorical(y_data[idx[:n_train]])
        y_data_test = y_data[idx[n_train:(n_train + n_test)]]
        w = eval.get_weights(y_data, 6)
        w_model = {0: w[0],
                   1: w[1],
                   2: w[2],
                   3: w[3],
                   4: w[4],
                   5: w[5]}
        model = Sequential()

        model.add(Dense(layer_size, input_dim=x_data.shape[1], activation=activation))
        for i in range(max(hidden_layer_count, 0)):
            model.add(Dense(layer_size, activation=activation))
        model.add(Dense(6, activation='softmax'))

        loss = my_loss.weighted_categorical_crossentropy(w)
        if optimizer == 'sgd':
            optim = optimizers.SGD(lr=learning_rate)
        elif optimizer == 'adam':
            optim = optimizers.Adam(lr=learning_rate)
        model.compile(loss=loss, optimizer=optim, metrics=['categorical_accuracy'])

        model.fit(x_data_train, y_data_train,
                  epochs=epoch_count, batch_size=batch_size, validation_split=validation_split,
                  verbose=verbose)
        y_pred = model.predict_classes(x_data_test)
        if summary:
            model.summary()
        print("Trial " + str(trial + 1) + ": " + str(eval.class_acc(y_data_test, y_pred, w)))


if __name__ == '__main__':
    main()
