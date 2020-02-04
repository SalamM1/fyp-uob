import numpy as np
import data_loader as loader
import evaluator as eval
import neural_network as network
from keras.models import Sequential, load_model
from keras.layers import Dense
from keras.models import Sequential
from keras.utils import to_categorical


def main():
    model_name = "test1"
    idx = np.arange(5200)  # indices for all data points in x
    np.random.shuffle(idx)

    x_data = loader.load_data_file("data/features_100.txt")
    x_data_train = x_data[idx[:4200]]
    x_data_test = x_data[idx[4200:5200]]
    y_data = loader.load_data_file("data/labels.txt")
    y_data_train = y_data[idx[:4200]]
    y_data_test = y_data[idx[4200:5200]]
    y_data_test_model = to_categorical(y_data_test)
    y_data_train = to_categorical(y_data_train)
    w = eval.get_weights(y_data, 6)
    model = Sequential()
    model.add(Dense(10, input_dim=100, activation='relu'))
    model.add(Dense(6, activation='softmax'))

    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['categorical_accuracy'])

    model.fit(x_data_train, y_data_train, epochs=100, batch_size=300)
    y_pred = model.predict_classes(x_data_test)
    model.summary()
    print(eval.f1score(y_data_test, y_pred, w))

   # model_json = model.to_json()
    #with open("model.json", "w") as json_file:
     #   json_file.write(model_json)


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
