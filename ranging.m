close all
clear all
% if exist('ranges.mat', 'file') == 2
%     ranges = load('ranges');
%     ranges = ranges.ranges;
% end
% if exist('posix_time.mat', 'file') == 2
%     posix_time = load('posix_time');
%     posix_time = posix_time.posix_time;
% end
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

%% load data from data folder
% load ntb data
mode1 = 1;
mode2 = {'data2/ntb_','s',1};
[ranges, posix_time] = load_ntbdata(mode1, 1);
% load mocap data
if exist('mocap.mat', 'file') == 2
    mocap = load('mocap');
    mocap = mocap.mocap;
end
%% compare mocap and thereotical generates, calculate offset

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
% save('offset', 'offset')

%% ranging experiment
found = cell(8,1);
found_id = cell(8,1);
for i = 1:8
    f = [];
    found_id{i} = [];
    for j = 1:8
       [ids, stroke] = find_first_valley(ranges{i,j});
       if isempty(ids)
           continue
       else
           f = [f j - 1];   % the actual node index
           %found_id{i} = [found_id{i}, {ids, stroke}];
           
%            % using tianrui zhang big god's algo
%            param = cell(8,1);
%            for ii = 1:8
%             param{ii} = ranges{i,ii};
%            end
%            start = localization(param);
           % using mocap data
           start = mean(mocap{i}(1:10,3:5),1);
           cors = estimate_cor(stroke, j - 1, start);
           th_ranges = theoretical_ranges(cors);
           t = posix_time{i,j}(ids);
           scores = [];
           for k = 1:8
                if isempty(posix_time{i,k}) % no measurements
                    continue
                end
                [beg, en] = find_slot(t(1), t(end), posix_time{i,k});
                if beg == -1    % no corresponding time measurement
                    continue
                end
                scores = [scores, compare_ranges(t, th_ranges(:,k), ...
                            posix_time{i,k}(beg:en), ranges{i,k}(beg:en))];
           end
           found_id{i} = [found_id{i}, [mean(scores); var(scores)]];
       end
    end
    found{i} = f;
    
end

%% Evaluation 
accur_mean = zeros(8,1);
accur_std = zeros(8,1);
accur_synth = zeros(8,1);
for i = 1:8
    [tmp, id_mean] = min(found_id{i}(1,:));
    [tmp, id_std] = min(found_id{i}(2,:));
%     [tmp, id_synth] = 
    % eval by mean
    accur_mean(i) =  (i - 1 == found{i}(id_mean));
    accur_std(i) =  (i - 1 == found{i}(id_std));
end
display(accur_mean)
display(accur_std)




