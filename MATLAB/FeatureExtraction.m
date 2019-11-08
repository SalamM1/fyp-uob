addpath('msr_toolbox');
addpath('data');
[audioIn, fs] = audioread('data/1B.wav');
segment = [0; 1];
% Each speaker has two files/sessions with labels and segments
% Each file has 2 channels
% Each speaker has an ID attached to them (1B, 2A 2B, etc.)
% Each speaker has a different number of labelled segments, varies
% The segments and labels will be stored in a seperate array
%
%% Step 0: Variables and Prepocessing
nEmotions = 1;
nSpeakers = 20;
nWorkers = 12; % for parallel computations

%testing

%% Step 1: Feature Extraction
trainingData = cell(nEmotions, nSpeakers);
for i=1:nSpeakers %Extracting all from 1 file for test
    for j=1:nEmotions
        trainingData{j,i} = cmvn((extract_mfcc(audioIn(:,1), fs, (segment + ((i-1))), 0.05, 0.02))');
    end
end
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

