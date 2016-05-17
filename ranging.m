close all
clear all
ranges = load('ranges');
posix_time = load('posix_time');
ranges = ranges.ranges;
posix_time = posix_time.posix_time;
% 8 * 3 matrix, [x y z] from Alpha to Hotel, in meters
global anchors
anchors = [
        -3.817, 2.416, 2.296;
        1.062, 2.381, 2.308;
        0.986, 2.434, -3.173;
        -3.852, 2.434, -3.163;
        -1.368, 2.402, 0.486;
        -1.349, 2.431, -1.323;
        -2.413, 0.796, -1.366;
        -3.282, 0.738, 4.009        
];

% %% generate ranges measurement
% labels = 0:7;
% ranges = cell(8,8);
% posix_time = cell(8,8);
% for i = labels
%     mocap = load(['mocap', num2str(i), '.csv']);
%     ntb = load(['ntbtiming',num2str(i), '.csv']);
%     timestamps = ntb(:,1);
%     recv_ids = ntb(:,3);
%     figure(i + 1)
%     for j = 0:7
%         logic = (recv_ids == j);
%         if sum(logic) == 0
%             display([num2str(i), ' missing node ', num2str(j)])
%         end
%         posix_t = timestamps(logic);
%         times = ntb(logic, 5:10);
%         [range, mask] = calc_ranging(times);
%         range = range(mask);
%         posix_t = posix_t(mask);
%         plot(posix_t, range)
%         ranges{i + 1, j + 1} = range;
%         posix_time{i + 1, j + 1} = posix_t;
%         hold on
%     end
%     legend('0', '1', '2', '3', '4', '5', '6', '7')
% end
% save('ranges', 'ranges')  
% save ('posix_time', 'posix_time')


%% save the 8 anchor nodes' coordinate

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
% % load the time and ranges from the measured ntb units
% 
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
% save offset

%% ranging experiment
found = cell(8,1);
found_id = cell(8,1);
for i = 1:8
    f = [];
    found_id{i} = {};
    for j = 1:8
       [ids, stroke] = find_first_valley(ranges{i,j});
       if isempty(ids)
           continue
       else
           f = [f j - 1];   % the actual node index
           %found_id{i} = [found_id{i}, {ids, stroke}];
           start = localization(ranges{i,:}, offset);
           cors = estimate_cor(stroke, j - 1, start);
           th_ranges = theoretical_ranges(cors);
           scores = zeros(8,1);
           t = posix_time{i,j}(ids);
           score = []
           for k = 1:8
                if isempty(posix_time{i,k}) % no measurements
                    continue
                end
                [beg, en] = find_slot(t(1), t(en), posix_time{i,k});
                if beg == -1    % no corresponding time measurement
                    continue
                end
                scores = [score, compare_ranges(t, th_ranges(:,k), ...
                            posix_time{i,k}(beg:en), ranges{i,k}(beg:en))];
           end
           found_id{i} = [found_id{i}, {mean(score), var(score)}];
       end
    end
    found{i} = f;
    
end

