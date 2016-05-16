function [ y ] = compare_ranges( t1, x1, t2, x2)
%compare the two input range signals, using time-interpolation
%   input: t1, t2 -- time stamp vector, may be different size
%          x1, x2 -- input signal vector, may be different size
%           y     -- comparing score between 2 signals
if ~isvector(x1) || ~isvector(x2)
    error('input signal must be vector')
end

if ~isvector(t1) || ~isvector(t2)
    error('input time stamps must be vector')
end
% linear interpolation
x12 = interp1(t1, x1, t2);
% euclidean distance between 2 signals
y = norm(x12 - x2);

end

