%% Step 1: Variables and Prepocessing
letterMap = ['A', 'J', 'M', 'E', 'N', 'O'];
load('data/ivectors.mat');
load('data/labels.mat');

nLabels = size(labels, 1);
nClasses = size(finalDevIVs, 1) + 1;
nMaxData = 700;

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
clusterMeans(:, 1) = normalize(mean(lab0, 2));
clusterMeans(:, 2) = normalize(mean(lab1, 2));
clusterMeans(:, 3) = normalize(mean(lab2, 2));
clusterMeans(:, 4) = normalize(mean(lab3, 2));
clusterMeans(:, 5) = normalize(mean(lab4, 2));
clusterMeans(:, 6) = normalize(mean(lab5, 2));


%% Step 4: Predict classes with Cosine Similarity
predicted_classes = zeros(nLabels, 1);
for i = 1:nLabels
    similarity = zeros(6, 1);
    for j = 1:nClasses
        similarity(j) = getCosineSimilarity(normalize(finalDevIVs(:, i)), clusterMeans(:, j));
    end
    [M,predicted_classes(i)] = max(similarity);
end

%% Step 5: Test categorical accuracy
nCorrect = 0;
for i = 1:nLabels
   if predicted_classes(i) == labelVals(i)
       nCorrect = nCorrect + 1;
   end
end

sprintf('Accuracy:  %.2f', nCorrect/nLabels)