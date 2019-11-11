clear
addpath('msr_toolbox');
load('data/labels.mat');
% Each speaker has two files/sessions with labels and segments
% Each file has 2 channels
% Each speaker has an ID attached to them (1B, 2A 2B, etc.)
% Each speaker has a different number of labelled segments, varies
% The segments and labels will be stored in a seperate array
%
%% Step 0.1: Read files
load('data/labels.mat');

fid = fopen('data/audioFileNames.txt','rt');
C = textscan(fid,'%s%d','Delimiter','\t','Whitespace','','Delimiter',',');
fclose(fid);
audioFileNames = C{1};
stereoDim = C{2};

fid = fopen('data/dataFileNames.txt','rt');
C = textscan(fid,'%s','Delimiter','\t','Whitespace','');
fclose(fid);
dataFileNames = C{1};
%% Step 0.2: Variables and Prepocessing
nWorkers = 4; % for parallel computations
nLabels = size(labels, 1);
nFiles = size(dataFileNames, 1);
nSegments = 0;

htkFilepath =  'data/htkfiles/';
addpath(htkFilepath);
%% Step 1: Feature Extraction
%{
for i=1:nFiles
    [audioIn, fs, segments] = read_audio_file(audioFileNames{i}, dataFileNames{i});
    nSegments = size(segments, 1);
    for j=1:nSegments
        feature = (extract_mfcc(audioIn(:,stereoDim(i)), fs, segments(j,:), 0.04, 0.02))';
        htkwrite(append(htkFilepath, dataFileNames{i}, num2str(j, '%03d')), feature, fs, 9);
    end
end
%}

%% Step 2: UBM Model from Training Data
nmix        = 1024;
final_niter = 15;
ds_factor   = 1;
ubm = gmm_em(labels(1:nLabels,1), nmix, final_niter, ds_factor, nWorkers);

%% Step 3: Total Variability Calculations
stats = cell(nLabels, 1);
for i=1:nLabels
    [N,F] = compute_bw_stats(append(htkFilepath, labels{i, 1}), ubm);
    stats{i} = [N;F];
end

tvDim = 300;
niter = 5;
T = train_tv_space(stats, ubm, tvDim, niter, nWorkers);

%% Step 4: IVector Feature Extraction
% Obtain development IVectors
devIVs = zeros(tvDim, nLabels);
for i=1:nLabels
    devIVs(:, i) = extract_ivector(stats{i}, ubm, T);
end

%% Step 5: Perform LDA on IVectors
ldaDim = min(100, 5);
[V,D] = lda(devIVs, string(labels(1:nLabels,2)));
finalDevIVs = (V(:, 1:ldaDim)' * devIVs).*10^7;

