function [audioIn, fs, segments] = read_audio_file(audioFile, dataFile)
%READ_AUDIO_FILES Function to read an audio file designed for the AIBO project
%   Inputs: audioFile, dataFile
%
%   - audioFile : Name of the .wav audio file (Without extension)
%
%
%   - dataFile  : Name of the .lab data file (Without extension)
%
%
%   Output:
%   
%   - audioIn  : Vector representation of sampled audio
%   - fs       : Sampling rate (Hz)
%   - segments : the segments of the labeled speech
addpath('data');
addpath('data/audio');
addpath('data/data');

[audioIn, fs] = audioread(append( audioFile, '.wav'));

fid = fopen(append('data/data/', dataFile, '.lab'),'rt');
C = textscan(fid,'%d64%d64%s','Delimiter','\t','Whitespace',' ');
fclose(fid);

nTotalSegments = size(C{1}, 1);
segments = zeros(nTotalSegments, 2);
segments(:,1) = C{1};
segments(:,2) = C{2};
indices = [];
for i=1:nTotalSegments
    if strcmp(C{3}(i), 'sil') || contains(C{3}(i), 'babble')
        indices = [indices, i];
    end
end

segments(indices,:) = [];
segments = segments .*(10^-7);
if(strcmp(dataFile, '24B'))
    segments = segments(1:15, :);
end
end

