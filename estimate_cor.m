function [ y ] = estimate_cor( delta_rin, id, start )
% given a set of range measurements, reconstruct the 3d coordinate
%   input: delta_rin -- the serial range measurements, only the valley part
%               id   -- the node pointed to, 0-7
%              start -- the initial localization point
%   output: y -- result N by 3 coordinates

global anchors
[n, m] = size(start);
if n ~= 1 || m ~= 3
    error('size of start must be 1*3 vector')
end

%get the distance form the anchor node to the start point
%roughly localization the start point
ray = anchors(id+1,:) - start;
dist = norm(ray);

%calc the valley's diff with the start-anchor distance
%reverse the valley direction
delta_rin = dist - delta_rin;

ray = ray / norm(ray);
N = length(delta_rin);

%ray is the dist vector
%roughly estimate the coordinate of each point in the valley
%ray has to be normlized
y = repmat(delta_rin, 1, 3) .* repmat(ray, N, 1) + repmat(start, N, 1);
end

