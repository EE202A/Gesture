function [ beg, en ] = find_slot( t1, t2, T )
%UNTITLED10 Summary of this function goes here
%   return -1 if not matched
beg = -1;
en = -1;
if T(1) > t1 || T(end) < t2
    return 
end
beg = find(T <= t1, 1, 'last');
en = find(T >= t2, 1);

end

