function feature_vector = extract_mfcc(audioIn, fs, start, en, window_length, overlap_length)
%EXTRACT_MFCC Extracts the mfcc feature vector from given file
%   Inputs: filepath, window_length, overlap_length
%
%   --audioIn: The vector representation of the audio, obtained from
%              audioread usually
%
%   --fs: sampling rate of the audio
%
%   -segment: [START END] the start and end time of a desired segment. If
%             0s, the entire file will be read instead.
%
%   -window_length: Length (in ms) of the window to use
%
%   -overlap_length: Length (in ms) the STFT windows will overlap
%

%%
% Set up the audio, window and fourier transform
if (start ~= en) && (en ~= 0)
    audioIn = audioIn(start*fs:en*fs);
end
win = hamming(window_length, 'periodic');
ft = stft(audioIn, 'Window', win, 'OverlapLength', overlap_length, 'Centered', false);

%%
% Extract the 40-dimensional MFCC vector
[mfccs, delta, deltaDelta, loc] = mfcc(ft, fs, "LogEnergy", "Ignore");
feature_vector = [mfccs, delta, deltaDelta, loc];
end

