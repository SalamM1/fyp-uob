%% Step 0: Preliminary work
clear
addpath('data');
map_in  = ['A'; 'T'; 'R'; 'J'; 'M'; 'E'; 'N'; 'O'; 'S'; 'B'; 'H']; %original emotional mappings
map_out = ['A'; 'A'; 'A'; 'J'; 'M'; 'E'; 'N'; 'O'; 'O'; 'O'; 'O']; %mappings to use in project
map_val = [ 0 ;  0 ;  0 ;  1 ;  2 ;  3 ;  4 ;  5 ;  5 ;  5 ;  5 ];

%% Step 1: Read raw label file into cell arrays
fid = fopen('labels.raw.txt','rt');
C = textscan(fid,'%s%s%c%c%c','Delimiter','\t','Whitespace','','Delimiter',' ');
fclose(fid);

nLabels = size(C{3}, 1);
labels = cell(nLabels, 2);
labels(:,1) = C{1}(:,1);

%% Step 2: Obtain most frequent mapping for each group of sound (instead of words)
acc_label = '';
idx = [];

for i=1:nLabels
    if i ~= nLabels
        if strcmp(labels(i+1,1), labels{i, 1}) %if the group ID is the same, find most frequent from all choices
            acc_label = append(C{3}(i),C{4}(i),C{5}(i));
            continue
        end 
    end
    raw_label = append(acc_label, C{3}(i),C{4}(i),C{5}(i));
    labels{i,2} = get_label(raw_label, map_in, map_out, map_val);
    idx = [idx i];
    acc_label = '';
end

labels = labels(idx, :);