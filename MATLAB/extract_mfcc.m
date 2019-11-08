function feature_vector = extract_mfcc(audioIn, fs, segment, window_length, overlap_length)
%EXTRACT_MFCC Extracts the mfcc feature vector from given audio
%   Inputs: filepath, window_length, overlap_length
%
%   - audioIn        : The vector representation of the audio, obtained from
%                      audioread usually
%
%   - fs             : sampling rate of the audio
%
%   - segment        : [START END] the start and end time of a desired segment. If
%                      0s, the entire file will be read instead.
%   - window_length  : Length (in ms) of the window to use
%
%   - overlap_length : Length (in ms) the STFT windows will overlap
%
%   Output:
%   
%   feature_vector   : Combined feature vector for the desired audio segment

%%
% Do error checking and assignment
segment = fix(segment*fs);
startTime = segment(1);
endTime = segment(2);
if startTime < 1  && (startTime ~= 0) && (endTime ~= 0)
    error('The segment cannot start before 1. Make sure the start * sample rate is at least 1.');
end
if startTime >= endTime
    error('The segment needs to start before it ends.');
end

% convert ms to usable matlab format
window_length = window_length * fs;
overlap_length = overlap_length * fs;
%%
% Set up the audio, window and fourier transform
if (startTime ~= 0) && (endTime ~= 0)
    audioIn = audioIn(startTime:endTime);
end
win = hamming(window_length, 'periodic');
ft = stft(audioIn, 'Window', win, 'OverlapLength', overlap_length, 'Centered', false);

%%
% Extract the 40-dimensional MFCC vector
[mfccs, delta, deltaDelta, loc] = mfcc(ft, fs, "LogEnergy", "Ignore");
feature_vector = [mfccs, delta, deltaDelta];
end