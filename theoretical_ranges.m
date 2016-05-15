function [ Y ] = theoretical_ranges( input )
%compute the theoretical ranges given localization points
%   input: N by 3 coordinates
%   output: N by 8 ranges from alpha to hotel, left to right

global anchors
[N, M]= size(input);
if M ~= 3
    error('input needs to be 3d coordinates!')
end
Y = [];
for i = 1:8
    tmp = input - repmat(anchors(i,:),N, 1);
    Y = [Y sqrt(tmp(:,1).^2 + tmp(:,2).^2 + tmp(:,3).^2)];
end

end

