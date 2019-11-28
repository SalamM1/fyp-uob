import torch
import torch.nn as nn
import torch.nn.functional as F


class Net(nn.Module):
    def __init__(self, input_size, hidden_layer_count, class_count):
        super(Net, self).__init__()
        self.layer1 = nn.Linear(input_size, hidden_layer_count)
        self.output = nn.Linear(hidden_layer_count, class_count)

    def forward(self, x):
        ret = self.layer1(x)
        ret = F.relu(ret)
        ret = self.output(ret)
        ret = F.softmax(ret, dim=1)
        return ret


def train(x_train, y_train, num_epochs, hidden_layer_count, device):
    num_features = x_train.size(1)
    model = Net(num_features, hidden_layer_count, 6).to(device)
    model = model.double()

    loss_func = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

    running_loss = 0

    for epoch in range(num_epochs):
        optimizer.zero_grad()

        output = model(x_train)
        loss = loss_func(output, y_train.long())

        loss.backward()
        optimizer.step()

        print(loss.item())

    return model
