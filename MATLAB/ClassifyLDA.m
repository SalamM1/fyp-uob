clc
clear
%% Step 1: Variables and Prepocessing
letterMap = ['A', 'J', 'M', 'E', 'N', 'O'];
load('data/ivectors.mat');
load('data/labels.mat');

nLabels = size(labels, 1);
nClasses = size(finalDevIVs, 1) + 1;
nMaxData = 700;

finalDevIVs = normalize(finalDevIVs')';

labelVals = zeros(nLabels, 1);
for i = 1:size(labels, 1)
   labelVals(i) = strfind(letterMap, labels{i, 2}); 
end

lab0 = [];
lab1 = [];
lab2 = [];
lab3 = [];
lab4 = [];
lab5 = [];

%% Step 2: Sort the data into different arrays with respect to their label
for i = 1:nLabels
    if strcmp(labels{i, 2}, 'A')
        lab0 = [lab0 finalDevIVs(:, i)];
    elseif strcmp(labels{i, 2}, 'J')
        lab1 = [lab1 finalDevIVs(:, i)];
    elseif strcmp(labels{i, 2}, 'M')
        lab2 = [lab2 finalDevIVs(:, i)];
    elseif strcmp(labels{i, 2}, 'E')
        lab3 = [lab3 finalDevIVs(:, i)];
    elseif strcmp(labels{i, 2}, 'N')
        lab4 = [lab4 finalDevIVs(:, i)];
    elseif strcmp(labels{i, 2}, 'O')
        lab5 = [lab5 finalDevIVs(:, i)];
    end
end

%% Step 3: Obtain normalized cluster means
clusterMeans = zeros(5, nClasses);
clusterMeans(:, 1) = mean(lab0, 2);
clusterMeans(:, 2) = mean(lab1, 2);
clusterMeans(:, 3) = mean(lab2, 2);
clusterMeans(:, 4) = mean(lab3, 2);
clusterMeans(:, 5) = mean(lab4, 2);
clusterMeans(:, 6) = mean(lab5, 2);


%% Step 4: Predict classes with Cosine Similarity
predicted_classes = zeros(nLabels, 1);
for i = 1:nLabels
    similarity = zeros(6, 1);
    for j = 1:nClasses
        similarity(j) = getCosineSimilarity(finalDevIVs(:, i), clusterMeans(:, j));
    end
    [M,predicted_classes(i)] = max(similarity);
end

%% Step 5: Test categorical accuracy
nCorrect = zeros(nClasses, 2);
for i = 1:nLabels
   if predicted_classes(i) == labelVals(i)
       nCorrect(predicted_classes(i), 1) = nCorrect(predicted_classes(i), 1) + 1;
   else
       nCorrect(predicted_classes(i), 2) = nCorrect(predicted_classes(i), 2) + 1;
   end
end
nAcc = zeros(nClasses, 1);
for i = 1:nClasses
    nAcc(i) = nCorrect(i, 1) / (max(nCorrect(i,1) + nCorrect(i,2), 1));
end
sprintf('Cosine Similarity Accuracy:  %.4f', mean(nAcc))

%% Step 6: Predict Classes with Cluster Proximity
predicted_classes = zeros(nLabels, 1);
for i = 1:nLabels
    similarity = zeros(6, 1);
    for j = 1:nClasses
        similarity(j) = norm(finalDevIVs(:, i) - clusterMeans(:, j));
    end
    [M,predicted_classes(i)] = min((similarity));
end

%% Step 7: Test categorical accuracy
nCorrect = zeros(nClasses, 2);
for i = 1:nLabels
   if predicted_classes(i) == labelVals(i)
       nCorrect(predicted_classes(i), 1) = nCorrect(predicted_classes(i), 1) + 1;
   else
       nCorrect(predicted_classes(i), 2) = nCorrect(predicted_classes(i), 2) + 1;
   end
end
nAcc = zeros(nClasses, 1);
for i = 1:nClasses
    nAcc(i) = nCorrect(i, 1) / (max(nCorrect(i,1) + nCorrect(i,2), 1));
end
sprintf('Cluster Proximity Accuracy:  %.4f', mean(nAcc))