function [ y ] = compare_ranges( t1, x1, t2, x2)
%compare the two input range signals, using time-interpolation, t2 is
% guaranteed to be larger than t1
%   input: t1, t2 -- time stamp vector, may be different size
%          x1, x2 -- raw input signal vector, may be different size
%           y     -- comparing score between 2 signals

% moving average filter 
b = [1/3, 1/3, 1/3];
a = 1;
x1 = filter(b,a,x1);
x2 = filter(b,a,x2);

if ~isvector(x1) || ~isvector(x2)
    error('input signal must be vector')
end

if ~isvector(t1) || ~isvector(t2)
    error('input time stamps must be vector')
end
if length(t1) ~= length(x1) || length(t2) ~= length(x2)
    error('timestamps and signal dont match')
end
% linear interpolation, t2 is guaranteed to include t1
if t2(1) > t1(1) || t2(end) < t1(end)
    error('interpolation failed!')
end
x21 = interp1(t2, x2, t1);
% average euclidean distance between 2 signals
y = norm(x21 - x1) / length(x1);

end

