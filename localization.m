function [ xyz ] = localization(ranges, offset)
% Given ranging measurements and offset of each anchor node, calculate 
% 3d coordinate at the stationary point
%   input: 
%           ranges -- 8 * 1 cell of ranges from alpha to hotel, []
%                                   means no measurement
%           offset -- 8 by 1 vector of default offset for each node,
%                   assumed to be constant and calibrated from mocap measurement
%   output: xyz  -- [x y z] coordinate of the stationary point

global anchors
for i = 1:8
r = ranges{1}
pos = mean(r(:10))


end

