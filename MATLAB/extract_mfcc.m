function feature_vector = extract_mfcc(audioIn, fs, segment, window_length, overlap_length, fs_scale)
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

%% Step 0: Error checking and Assignment
% Do error checking and assignment
segment = fix(segment*fs);
startTime = segment(1);
endTime = segment(2);
if startTime == 0 && endTime ~= 0
    startTime = 1;
end
if startTime < 1  && (startTime ~= 0) && (endTime ~= 0)
    error('The segment cannot start before 1. Make sure the start * sample rate is at least 1.');
end
if startTime >= endTime
    error('The segment needs to start before it ends.');
end
if fs_scale <= 0
    error('Scaling cannot be zero or lower.')
end
%for now compress stereo audio into mono?
if size(audioIn, 2)==2
    audioIn = audioIn(:,1);
end
% convert ms to usable matlab format
window_length = fix(window_length * fs);
overlap_length = fix(overlap_length * fs);
%% Obtain segment, window and fourier transform
% Set up the audio, window and fourier transform
if (startTime ~= 0) && (endTime ~= 0)
    audioIn = audioIn(startTime:endTime);
end
win = hamming(window_length, 'periodic');
ft = stft(audioIn, 'Window', win, 'OverlapLength', overlap_length, 'Centered', false);

%% Get feature vector from mfcc function
% Extract the 40-dimensional MFCC vector
[mfccs, delta, deltaDelta, loc] = mfcc(ft, fs * fs_scale, "LogEnergy", "Ignore");
feature_vector = [mfccs, delta, deltaDelta, loc];
end