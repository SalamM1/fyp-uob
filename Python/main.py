import numpy as np
from keras.layers import Dense
from keras.models import Sequential
from keras.utils import to_categorical

import data_loader as loader


def main():
    idx = np.arange(5000)  # indices for all data points in x
    np.random.shuffle(idx)

    x_data_train, x_data_test = loader.load_data_file("features.txt", idx)
    y_data_train, y_data_test = loader.load_data_file("labels.txt", idx)
    y_data_train = to_categorical(y_data_train)
    model = Sequential()
    model.add(Dense(12, input_dim=5, activation='relu'))
    model.add(Dense(8, activation='relu'))
    model.add(Dense(6, activation='softmax'))

    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['categorical_accuracy'])

    model.fit(x_data_train, y_data_train, epochs=50, batch_size=100)
    model.summary()


if __name__ == '__main__':
    # idx = np.arange(5000)  # indices for all data points in x
    # np.random.shuffle(idx)
    #
    # x_data_train, x_data_test = loader.load_data_file("features.txt", idx)
    # y_data_train, y_data_test = loader.load_data_file("labels.txt", idx)
    # y_data_train = to_categorical(y_data_train)
    # y_data_test = to_categorical(y_data_test)
    #
    # model = load_model('model')
    #
    # test_pred = model.predict_classes(x_data_test)
    # print("")
    main()
    pass