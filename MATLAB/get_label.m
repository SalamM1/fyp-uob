function c_out = get_label(c_in, map_in, map_out, map_val)
%GET_MAPPING Finds most frequent char in an array of mapped chars
for i=1:strlength(c_in)
   c_in(i) = map_out(map_in == c_in(i)); 
end
%c_out = map_val(map_out == mode(c_in));
c_out = mode(c_in);
end