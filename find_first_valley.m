function [ ids, stroke ] = find_first_valley( signal )
%find the first valley in the ranging signal 
%   input: ranging signal vector 
%   output: the ids and the "valuable" output signal, empty matrix if not
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
th = -0.3; 
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


% the first significant move...
idx = find(delta_y < th, 1 );
if isempty(idx)
    return
end
prev = delta_y(1:idx);
left = find(prev > th_min, 1, 'last' );
right = min(idx -left + idx, n - shift);
if right - left < th_t
    return 
end
ids = (left: right) + shift;            % right shift back
stroke = delta_y(left:right);

