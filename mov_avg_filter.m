function [ y ] = mov_avg_filter( x )
% Moving average filter, smooth the trajectories
%
%   input: vector signal
%   output: filtered signal, notice that the first and second val are
%   fucked up, y(1) = x(1) / n, y(2) = (x(1) + x(2)) / n

if ~isvector(x)
    error('filter input must be vector')
end
b = [1/3, 1/3, 1/3];
a = 1;
y = filter(b,a,x);

end

