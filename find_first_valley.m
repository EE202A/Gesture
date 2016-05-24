function [ ids, stroke ] = find_first_valley( signal )
%find the first valley in the ranging signal 
%   input: ranging signal vector 
%   output: the ids and the "relevant" output signal, empty matrix if not
%   found

%% Check Input
[n, m] = size(signal);
ids = [];
stroke = [];
if ~(n == 1 || m == 1)
    error('input must be 1dim vector')
end
if n == 1
    n = m;
end
if n < 20       % less than 2sec mearsurement, discard it
    return
end


%% get the first valley
% this threshold makes sense in our case
th = -0.33; 
th_min = -0;
th_t = 5;

% moving average filter, smooth the trajectory
y = mov_avg_filter(signal);

% estimate offset
offset = mean(signal(1:10));

% ignore the first 2 data for the error introduced in the mov_avg_filter
delta_y = y(3:end) - offset;
shift = 2;      % left shift from the original sample
n = n - shift;

% the first significant move...
idx = find(delta_y < th, 1 );
if isempty(idx)
    return
end
% prev = delta_y(1:idx);

% find the left turning point of the valley
%TODO
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
% the mean value of the part before the left turn part is far larger than 0
%TODO 
if mean(delta_y(1:left)) > abs(th)*2/3
    return 
end

% explore to the valley
% get the lowest point in the valley
while idx < n && delta_y(idx) > delta_y(idx + 1)
    idx = idx + 1;
end

% the valley should larger than a length threshold
%TODO
right = min(idx -left + idx, n);
if right - left < th_t
    return 
end

% avoid going to the end, causing time mismatch
if right - left > 15 && right == n
    right = right - 5;
end

%extract the valley indx and the intensity 
ids = (left: right) + shift;        % right shift back
stroke = y(ids);        % output smoothed signal



end
