%% Step 1: Variables and Prepocessing
colorMap = ['r', 'b', 'g', 'c', 'y', 'm'];
letterMap = ['A', 'J', 'M', 'E', 'N', 'O'];

load('data/ivectors.mat');
load('data/labels.mat');
nLabels = size(labels, 1);
nDim = size(finalDevIVs, 1);
nMaxData = 700;
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

%% Step 3: Commit an NxN 2D scatter plot set for visualization
pointSize = 1; %size of point on plot
for i = 1:nDim
    for j = 1:nDim
        if i == j
            continue
        end
        subplot(nDim, nDim, nDim*(i-1) + j);
        hold on
        scatter(lab4(j,1:nMaxData), lab4(i,1:nMaxData), pointSize, colorMap(5));
        scatter(lab0(j,:), lab0(i,:), pointSize, colorMap(1));
        scatter(lab1(j,:), lab1(i,:), pointSize, colorMap(2));
        scatter(lab2(j,:), lab2(i,:), pointSize, colorMap(3));
        scatter(lab3(j,:), lab3(i,:), pointSize, colorMap(4));
        %scatter(lab4(j,1:nMaxData), lab4(i,1:nMaxData), pointSize, colorMap(5));
        scatter(lab5(j,:), lab5(i,:), pointSize, colorMap(6));
    end
end

hold off
