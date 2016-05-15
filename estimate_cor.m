function [ y ] = estimate_cor( delta_rin, id, start )
% given a set of range measurements, reconstruct the 3d coordinate
%   input: delta_rin -- the serial range measurements, vector
%               id   -- the node pointed to, 0-8
%              start -- the initial localization point
%   output: y -- result N by 3 coordinates
global anchors
[n, m] = size(start);
if n ~= 1 || m ~= 3
    error('size of start must be 1*3 vector')
end
ray = anchors(id+1,:) - start;
dist = norm(ray);
delta_rin = dist - delta_rin;       %reverse the direction
ray = ray / norm(ray);
N = length(delta_rin);
y = repmat(delta_rin, 1, 3) .* repmat(ray, N, 1) + repmat(start, N, 1);
end

