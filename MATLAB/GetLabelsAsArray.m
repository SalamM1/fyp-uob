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

fs_scales = [0.8, 0.9, 1, 1.1, 1.2];

for i=1:nLabels
    if i ~= nLabels
        if strcmp(labels(i+1,1), labels{i, 1}) %if the group ID is the same, find most frequent from all choices
            acc_label = append(C{3}(i),C{4}(i),C{5}(i));
            continue
        end 
    end
    raw_label = append(acc_label, C{3}(i),C{4}(i),C{5}(i));
    if (has_dupe(raw_label, map_in, map_out) == 1)
        continue
    end
    labels{i,2} = get_label(raw_label, map_in, map_out);
    idx = [idx i];
    acc_label = '';
end

labels = labels(idx, :);
nLabels = size(labels, 1);
%{ data augmentation labels lazy way
labels_total = cell(nLabels*1, 2);
for i=1:nLabels
    labels_total{i,1} = labels{i, 1};
    labels_total{i,1} = labels{i, 1};
    labels_total{i,1} = labels{i, 1};
    labels_total{i,1} = labels{i, 1};
    labels_total{i,1} = labels{i, 1};
    for j=1:1
        labels_total{i + ((j - 1)*nLabels), 1} = append(labels{i,1}, '_', num2str(fs_scales(j)));
        labels_total{i + ((j - 1)*nLabels), 2} = labels{i,2};
    end
end
labels = labels_total;
%}
function c_dupe = has_dupe(c_in, map_in, map_out)
%HAS_DUPE determines if the label is equal across all three labelers.
for i=1:strlength(c_in)
   c_in(i) = map_out(map_in == c_in(i)); 
end
c_dupe = 0;
c_temp = c_in(1);
for i=1:strlength(c_in)
    if c_in(i) ~= c_temp
        c_dupe = 1;
    end
end
end
        
function c_out = get_label(c_in, map_in, map_out)
%GET_LABEL Finds most frequent char in an array of mapped chars
for i=1:strlength(c_in)
   c_in(i) = map_out(map_in == c_in(i)); 
end
c_out = mode(c_in);
end