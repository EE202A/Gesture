function [r, mask] = calc_ranging( times )
%calucate ranging for a specific anchor node base on the formula
%   input: N*6 times without unit transformation
%   output: N*1 ranging results for every time stamp
%           mask logical indices that are valid
light_speed = 299792458;
threshold = 10;        % 10m threshold
times = times / 63.8976 / 1e9;
rnd0 = times(:,4) - times(:,1);
rnd1 = times(:,6) - times(:,3);
rsp0 = times(:,3) - times(:,2);
rsp1 = times(:,5) - times(:,4);
r = light_speed * (rnd0 .* rnd1 - rsp0 .* rsp1) ./ (rnd0 + rnd1 + rsp0 + rsp1);
mask = r < threshold;  %max distance is set to 10m, so only consider distance within 10 meter

end

