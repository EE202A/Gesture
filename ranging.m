close all
clear all

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
%         range = calc_ranging(times);
%         plot(posix_t, range)
%         ranges{i + 1, j + 1} = range;
%         posix_time{i + 1, j + 1} = posix_t;
%         hold on
%     end
%     legend('0', '1', '2', '3', '4', '5', '6', '7')
% end
% save('ranges', 'ranges')  
% save ('posix_time', 'posix_time')

% %% analysis
% % moving average filter 
% b = [1/3, 1/3, 1/3];
% a = 1;
% y = filter(b,a,sample);
% 
% % estimate offset
% offset = mean(sample(1:10));
% y1 = y(3:end) - offset;
% y2 = y1 .^ 2;
% shift = 2;      % shift from the original sample
% 
% % find the significant down turn
% y = find_first_valley(y2);


%% save the 8 anchor nodes' coordinate
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
% load data from mocap files and generate theoretical ranges
mocap = cell(8,1);
% timestamps and ranges
th_ranges = cell(8,2);

for i = 0:7
    mocap{i + 1} = load(['mocap', num2str(i), '.csv']);
    th_ranges{i + 1,1} = mocap{i + 1}(:,1);    % save timestamp
    th_ranges{i + 1,2} = theoretical_ranges(mocap{i + 1}(:,3:5));  % save ranges
end
% load the time and ranges from the measured ntb units
ranges = load('ranges');
posix_time = load('posix_time');
ranges = ranges.ranges;
posix_time = posix_time.posix_time;







