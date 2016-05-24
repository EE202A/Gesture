function [ ranges, posix_time, offset] = load_ntbdata( mode, display)
%load offsets for each anchor node and ntb and mocap data
%
%INPUT  mode:       We get 3 sets of test data. Use mode to select different
%                   input data
%       display:    if 1 display the plot of distance changes of each anchor
%                   node.
%
%OUTPUT  ranges:    The range distance from 8 anchor node when user point to diff anchor
%                   The cell's first indx is the anchor user point to
%                   calibrated by substruct the offset
%       posix_time: The time stamp of of each ranging event corresponding to
%                   the above ranges
%       offset:     The calibrated offsets for each anchor node 


%% calculate offset
<<<<<<< HEAD
% if exist('offset.mat', 'file') == 2
%     offset = load('offset');
%     offset = offset.offset;
offset_num = 0;
if exist(['offset/ntb_offset', num2str(offset_num), '.csv'], 'file') == 2 ...
        && exist(['offset/mocap_offset', num2str(offset_num), '.csv'], 'file') == 2
    ntb = load(['offset/ntb_offset', num2str(offset_num), '.csv']);
    mocap = load(['offset/mocap_offset', num2str(offset_num), '.csv']);
    timestamps = ntb(:,1);
    recv_ids = ntb(:,3);
    rs = cell(8,1);
=======
% fetch offset from cache
if exist('offset.mat', 'file') == 2
    offset = load('offset');
    offset = offset.offset;
%calc the offset
%calibrate the data base on the mocap data and ntb data at a fixed point
elseif exist('offset/ntb_offset1.csv', 'file') == 2 ...
        && exist('offset/mocap_offset1.csv', 'file') == 2
    ntb = load('offset/ntb_offset1.csv');
    mocap = load('offset/mocap_offset1.csv');
    
    %get the practice range from ntb
    recv_ids = ntb(:,3);    %get anchor id
    rs = cell(8,1);         
>>>>>>> 30219218ab1587e1f80f0c0b48e05a8268414bd0
    for i = 0:7
        %get mask for extract data for each node in the ntb data file
        logic = (recv_ids == i);
        if sum(logic) == 0
           disp(['offset missing node ', num2str(i)])
        end
        
        %get the time measure by the anchor node
        times = ntb(logic, 5:10);
        %calc the distance using the time info base on the formula
        %return the distance from the anchor node
        %mask is to only extract the distance under than 10m
        [range, mask] = calc_ranging(times);
        range = range(mask);
        
        %save the range
        rs{i + 1} = range;
    end
    
    %get the theoretical ranges from mocap
    offset = zeros(8,1);
    th_ranges = theoretical_ranges(mocap(:,3:5));
    
    %get the difference between actual value and theoretical value as the
    %offsets
    for j = 0:7
        offset(j + 1) = mean(rs{j + 1}) - mean(th_ranges(:,j + 1));
    end
    save('./offset', 'offset')

else
    error('No offset data')
end

%% load ranges measurement
labels = 0:7;
ranges = cell(8,8);
posix_time = cell(8,8);

% this label is the anchor node the user point to
for i = labels
    if mode == 1
        filename = ['data1/ntbtiming', num2str(i), '.csv'];
    elseif mode == 2
        filename = ['data2/ntb', num2str(i), '.csv'];
    elseif mode == 3
        filename = ['data3/ntb', num2str(i), '.csv'];
    elseif mode == 4
        filename = ['data4/ntb', num2str(i), '.csv'];
    else
        error('no ntb ranges dataset')
    end
    
    
    ntb = load(filename);
    timestamps = ntb(:,1);
    recv_ids = ntb(:,3);
    
    if display
        figure(i + 1)
    end
    
    %this is when user point to anchor i, all 8 node has receive data
    for j = 0:7
        %only extract the data from anchor node j of user point to i
        logic = (recv_ids == j);
        if sum(logic) == 0
            disp([num2str(i), ' missing node ', num2str(j)])
        end
        
        % calc the range and subtract the offset
        times = ntb(logic, 5:10);
        [range, mask] = calc_ranging(times);
        range = range(mask) - offset(j + 1);
        ranges{i + 1, j + 1} = range;

        % save the time stamp
        posix_t = timestamps(logic);
        posix_t = posix_t(mask);
        posix_time{i + 1, j + 1} = posix_t;

        if display
            plot(posix_t, range)
            hold on
        end

    end
    if display
        legend('0', '1', '2', '3', '4', '5', '6', '7')
    end
end





%% old stuff 
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

