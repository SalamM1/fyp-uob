letterMap = ['A', 'J', 'M', 'E', 'N', 'O'];

% load('data/ivectors.mat');
load('data/labels.mat');

labels = labels(:,2);
labelVals = zeros(size(labels, 1), 1);

test = labels{2};

for i = 1:size(labels, 1)
   labelVals(i) = strfind(letterMap, labels{i}) - 1; 
end
testList = normalize(finalDevIVs');
writematrix(testList, 'features_100')