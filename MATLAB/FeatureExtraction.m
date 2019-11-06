addpath('msr_toolbox');
[audioIn, fs] = audioread('msr_toolbox/test_audio.mp3');
segment = [0.001; 1.551];

features = extract_mfcc(audioIn, fs, 1, 1.551, 1024, 512);