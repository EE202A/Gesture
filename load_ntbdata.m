function [ ranges, posix_time ] = load_ntbdata( mode, display)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
if exist('offset.mat', 'file') == 2
    offset = load('offset');
    offset = offset.offset;
else 
    error('no fucking offset data')
end

%% load ranges measurement
labels = 0:7;
ranges = cell(8,8);
posix_time = cell(8,8);

for i = labels
%     mocap{i + 1} = load(['data1/mocap', num2str(i), '.csv']);
    if mode == 1
        filename = ['data1/ntbtiming', num2str(i), '.csv'];
    elseif mode == 2
        filename = ['ntb', num2str(i), '.csv'];
    else 
        filename = [mode{1}, num2str(i), '_', mode{2}, '_', num2str(mode{3}), '.csv'];
    end
    ntb = load(filename);
    timestamps = ntb(:,1);
    recv_ids = ntb(:,3);
    if display
        figure(i + 1)
    end
    for j = 0:7
        logic = (recv_ids == j);
        if sum(logic) == 0
%             display([num2str(i), ' missing node ', num2str(j)])
%             display('missing node')
            [num2str(i), ' missing node ', num2str(j)]
        end
        posix_t = timestamps(logic);
        times = ntb(logic, 5:10);
        [range, mask] = calc_ranging(times);
        range = range(mask) - offset(j + 1);
        posix_t = posix_t(mask);
        % remove the offset calibrated from mocap data
        ranges{i + 1, j + 1} = range;
        posix_time{i + 1, j + 1} = posix_t;
        if display
            plot(posix_t, range)
            hold on
        end
    end
    legend('0', '1', '2', '3', '4', '5', '6', '7')
end
% save('ranges', 'ranges')  
% save('posix_time', 'posix_time')
% save('mocap', 'mocap')

end

