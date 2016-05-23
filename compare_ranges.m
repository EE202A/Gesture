function [ y ] = compare_ranges( t1, x1, t2, x2)
%compare the two input range signals, using time-interpolation, t2 is
% guaranteed to be larger than t1
%   input: t1, t2 -- time stamp vector, may be different size
%          x1, x2 -- raw input signal vector, may be different size
%           y     -- comparing score between 2 signals
% figure(1)
% plot(x1)
% hold on
% plot(x2)
% close(1)


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

%if t1!=t2, interpolate
x21 = interp1(t2, x2, t1);
% keep only relative changes value
x21 = x21 - (x21(1) - x1(1));


% average euclidean distance between 2 signals
%get the score how far is the distance between te two signal as the
%evaulation score
y = norm(x21 - x1) / length(x1);


end

