function [r] = calc_ranging( times )
%calucate ranging for a specific anchor node
%   input: N*6 times without unit transformation
%   output: N*1 ranging results
light_speed = 299792458;
times = times / 63.8976 / 1e9;
rnd0 = times(:,4) - times(:,1);
rnd1 = times(:,6) - times(:,3);
rsp0 = times(:,3) - times(:,2);
rsp1 = times(:,5) - times(:,4);
r = light_speed * (rnd0 .* rnd1 - rsp0 .* rsp1) ./ (rnd0 + rnd1 + rsp0 + rsp1);

end

