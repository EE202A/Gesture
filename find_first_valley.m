function [ ids, stroke ] = find_first_valley( signal )
%find the first valley in the ranging signal 
%   input: ranging signal vector 
%   output: the ids and the "relevant" output signal, empty matrix if not
%   found
[n, m] = size(signal);
ids = [];
stroke = [];
if ~(n == 1 || m == 1)
    error(['input must be 1dim vector'])
end
if n == 1
    n = m;
end
if n < 20       % less than 2sec mearsurement, discard it
    return
end

% this threshold makes sense in our case
th = -0.33; 
th_min = -0;
th_t = 5;

% moving average filter 
b = [1/3, 1/3, 1/3];
a = 1;
y = filter(b,a,signal);
% estimate offset
offset = mean(signal(1:10));
delta_y = y(3:end) - offset;
% y2 = y1 .^ 2;
shift = 2;      % left shift from the original sample
n = n - shift;

% the first significant move...
idx = find(delta_y < th, 1 );
if isempty(idx)
    return
end
% prev = delta_y(1:idx);
% find left turning point
left = idx - 1;
while left > 0 && delta_y(left) > delta_y(left + 1) && delta_y(left) < th_min
    left = left - 1;
end

% % rule out the case if this is not the first valley point
% if min(delta_y(1:left)) < th / 2 && left >= 20
%     return 
% end

% left = find(prev >= th_min, 1, 'last' );
% omit the case if this is not the "first significant valley"
if mean(delta_y(1:left)) > abs(th)*2/3
    return 
end

% explore to the valley
while idx < n && delta_y(idx) > delta_y(idx + 1)
    idx = idx + 1;
end
right = min(idx -left + idx, n);
if right - left < th_t
    return 
end
ids = (left: right) + shift;            % right shift back
stroke = signal(ids);

