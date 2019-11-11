
map_out  = ['A'; 'T'; 'R'; 'J'; 'M'; 'E'; 'N'; 'O'; 'S'; 'B'; 'H']; %original emotional mappings
color   = ['r'; 'r'; 'r'; 'b'; 'g'; 'c'; 'y'; 'm'; 'm'; 'm'; 'm'];
for i = 1:nLabels
    if strcmp(labels{i, 2}, 'N')
        continue
    end
    
    scatter3(finalDevIVs(1,i), finalDevIVs(2,i), finalDevIVs(3,i), get_color(labels{i, 2}, map_out, color));
    hold on
end
hold off

function col = get_color(label, map, colr)
    col = colr(map==label);
end
