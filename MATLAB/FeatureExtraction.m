addpath('msr_toolbox');
addpath('data');
[audioIn, fs] = audioread('data/1B');
segment = [0; 24.6];

features = extract_mfcc(audioIn, fs, segment, 0.05, 0.025);
% Each speaker has two files with labels and segments
% Each speaker has an ID attached to them
% Each speaker has a different number of labelled segments
% The segments and labels will be stored in a seperate array
%
%% Step 0: Variables and Prepocessing
nEmotions = 5;
nSpeakers = 30;
nWorkers = 12; % for parallel computations
%% Step 1: Feature Extraction
trainingData = cell(nEmotions, nSpeakers);
testData = cell(nEmotions, nSpeakers);

%% Step 2: UBM Model from Training Data
nmix        = 256;
final_niter = 10;
ds_factor   = 1;
ubm = gmm_em(trainingData(:), nmix, final_niter, ds_factor, nWorkers);

%% Step 3: Total Variability Calculations
stats = cell(nEmotions, nSpeakers);
for e=1:nEmotions
    for s=1:nSpeakers
        [N,F] = compute_bw_stats(trainingData{e,s}, ubm);
        stats{e,s} = [N; F];
    end
end

tvDim = 100;
niter = 5;
T = train_tv_space(stats(:), ubm, tvDim, niter, nWorkers);

%% Step 4: IVector Feature Extraction
% Obtain development IVectors
for e=1:nEmotions
    for s=1:nSpeakers
        devIVs(:, e, s) = extract_ivector(stats{e, s}, ubm, T);
    end
end

