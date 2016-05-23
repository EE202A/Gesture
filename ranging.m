close all
clear

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
% load data, mode = 3,4
mode = 2;
[ranges, posix_time, offset] = load_ntbdata(mode, 0);
mocap = load_mocapdata(mode);    

%% ranging experiment
found = cell(8,1);
found_id = cell(8,1);
for i = 1:8
    
    %f store all the potential candidates
    f = [];
    found_id{i} = [];
    for j = 1:8
       % find the first valley for one trajectory
       [ids, stroke] = find_first_valley(ranges{i,j});
       
       if isempty(ids)
           continue
       else
           %find a valley for anchor node j-1
           f = [f j - 1];   % the actual node index
           %found_id{i} = [found_id{i}, {ids, stroke}];
           
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
%            % using tianrui zhang big god's algo
%            param = cell(8,1);
%            for ii = 1:8
%             param{ii} = ranges{i,ii};
%            end
%            start = localization(param);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


           % using mocap data
           %get the mean of first 10 point as start point
           start = mean(mocap{i}(1:10,3:5), 1);
           cors = estimate_cor(stroke, j - 1, start);
           
           %estimate the theoretical dist between the 8 anchor node and the
           %valley points
           th_ranges = theoretical_ranges(cors);
           
           t = posix_time{i,j}(ids);
           scores = zeros(1, 8);
           for k = 1:8
                if isempty(posix_time{i,k}) % no measurements
                    continue
                end
                %time sync to get at the same time of the valley
                %find the begin time and end time at the anchor node for
                %the valley, return the idx
                [beg, en] = find_slot(t(1), t(end), posix_time{i,k});
                
                if beg == -1    % no corresponding time measurement
                    continue
                end
                
                %smooth the whole tracjectory
                rr = mov_avg_filter(ranges{i,k});
                
                %t: the valley duration time stamp
                %th_ranges(:,k): the dist to the k anchor node
                %posix_time{i,k}(beg:en): same as t, might be diff.....
                %rr(beg:en): the smoothed valley part of the trackjectory
                scores(:,k) = compare_ranges(t, th_ranges(:,k), posix_time{i,k}(beg:en), rr(beg:en));
           end
           found_id{i} = [found_id{i}, [mean(scores); var(scores)]];
       end
    end
    
    found{i} = f;
end

%% Evaluation 
% performance metrics, the estimated pointing node and the "trust score"
performance = zeros(8,2);
% accur_std = zeros(8,2);
% accur_synth = zeros(8,2);
for i = 1:8
    if isempty(found{i})
        performance(i) = [-1 -1];
%         accur_std(i) = 0;
        continue
    end
    % evaluation metrics -- f([mean], [std])
    % evaluation metrics lowest sum of mean and std
    eval = found_id{i}(1,:) + found_id{i}(2,:);
    [~, id_mean] = min(eval);
    
%     [tmp, id_std] = min(found_id{i}(2,:));
    % trust score calculation -- compare with second largest element 
    tmp = sort(eval);
    if length(tmp) > 1
        %final score definte as the how many times is the lowest score to
        %the second lowest score
        score = tmp(1) / tmp(2);
    else
        score = 0;
    end
%     accur_mean(i) =  [(i - 1 == found{i}(id_mean)) ];
%     accur_std(i) =  (i - 1 == found{i}(id_std));
    performance(i,:) = [found{i}(id_mean), score];
end
display(performance')

% display(accur_std')




