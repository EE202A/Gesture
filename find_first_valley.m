function [ y ] = find_first_valley( signal )
%find the first valley in the ranging signal 
%   input: signal vector "removed off offset and well-filtered"
% this threshold makes sense in our case
th = -0.3; 
th_min = -0.05;
th_t = 5;

[n, m] = size(signal);
y = NaN;
if ~(n == 1 || m == 1)
    error(['input must be 1dim vector'])
end
if n == 1
    n = m;
end

idx = find(signal < th, 1 );
if isempty(idx)
    return
end
prev = signal(1:idx);
idx_valley = find(prev > th_min, 1, 'last' );
if idx - idx_valley < th_t
    return 
end
y = idx;