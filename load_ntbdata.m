function [ ranges, posix_time, offset] = load_ntbdata( mode, display)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

%% calculate offset
if exist('offset.mat', 'file') == 2
    offset = load('offset');
    offset = offset.offset;
elseif exist('offset/ntb_offset.csv', 'file') == 2 ...
        && exist('offset/mocap_offset.csv', 'file') == 2
    ntb = load('offset/ntb_offset.csv');
    mocap = load('offset/mocap_offset.csv');
    timestamps = ntb(:,1);
    recv_ids = ntb(:,3);
    rs = cell(8,1);
    for i = 0:7
        logic = (recv_ids == i);
        if sum(logic) == 0
%             display([num2str(i), ' missing node ', num2str(j)])
%             display('missing node')
            ['offset missing node ', num2str(i)]
        end
        posix_t = timestamps(logic);
        times = ntb(logic, 5:10);
        [range, mask] = calc_ranging(times);
        range = range(mask);
        % remove the offset calibrated from mocap data
        rs{i + 1} = range;
    end
    offset = zeros(8,1);
    th_ranges = theoretical_ranges(mocap(:,3:5));
    for j = 0:7
        offset(j + 1) = mean(rs{j + 1}) - mean(th_ranges(:,j + 1));
    end
    save('offset', 'offset')

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
    elseif mode == 3
        filename = ['data3/ntb', num2str(i), '.csv'];
    elseif mode == 4
        filename = ['data4/ntb', num2str(i), '.csv'];
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

% if exist('mocap.mat', 'file') == 2
%     mocap = load('mocap');
%     mocap = mocap.mocap;
% end
% %% compare mocap and thereotical generates, calculate offset -- depreciated now
% 
% % load data from mocap files and generate theoretical ranges
% mocap = cell(8,1);
% % timestamps and ranges
% th_ranges = cell(8,2);
% 
% for i = 0:7
%     mocap{i + 1} = load(['mocap', num2str(i), '.csv']);
%     th_ranges{i + 1,1} = mocap{i + 1}(:,1);    % save timestamp
%     th_ranges{i + 1,2} = theoretical_ranges(mocap{i + 1}(:,3:5));  % save ranges
% end
% load the time and ranges from the measured ntb units

% %% calculate the offset of each anchor node, assumed to be constant for each
% offset = zeros(8,1);
% j = 1;
% for j = 0:7
%     a = [];
%     for i = 1:8
%         if isempty(ranges{i, j + 1})
%             continue
%         end
%         a = [a mean(ranges{i, j + 1}) - mean(th_ranges{i,2}(:,j + 1))];
%     end
%     offset(j + 1) = mean(a);
% end
% save('offset', 'offset')
% save('ranges', 'ranges')  
% save('posix_time', 'posix_time')
% save('mocap', 'mocap')

end

