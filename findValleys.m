function [ seg, n ] = findValleys( signal)
%   input: energy signal 
%   output: valley: timecut vector of 2n size, 
%           n:      number of segments

%threshold setup
% these 3 are a little bit problematic
scale1 = 20;        % peak limit threshold
scale2 = 7;         % segment merge and final time check threshold
tscale1 = 2;        % segment merge time threshold
tscale2 = 1.7;      % final time check threshold 
vscale = 2;         % valley limit threshold

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First round, valley found
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = length(signal);
avg = mean(signal);
curmax = -1;
count = 1;
valley = zeros(n,1);
valley(1) = 1;          % first one is valley regarded as.
maxval = zeros(n - 1,1);
for i = 2:n - 1
    
        curmax = max([signal(i), curmax]);
     %its a small valley -- potential cut, the valley has to be small
     %enough
    if (signal(i) < signal(i - 1) && signal(i) < signal(i + 1) && signal(i) < vscale * avg) 
        maxval(count) = curmax;
        curmax = -1;
        count = count + 1;
        valley(count) = i;
    end
end
maxval(count) = max([signal(n), curmax]);
maxval = maxval(1:count);
count = count + 1;
valley(count) = n;
valley = valley(1:count);
n = count;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second round -- segment form
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% right = 1;
% seg = zeros(2*(n - 1));
% for i = 2:n - 1
%     noise = signal(valley(i));
%     left = valley(i);
%     for j = valley(i):-1:valley(i - 1)
%         if (signal(j) >= noise)
%             total = 0;
%             for k = j - 1:-1:j-4
%                 if (signal(k) > noise)
%                     total = total + 1;
%                 end
%             end
%             if (total > 2)
%                 left = j;
%             end
%         end
%     end
%     seg(2*i - 3) = right;
%     seg(2*i - 2) = left;
%     right = valley(i);
%     for j = valley(i):valley(i + 1)
%         if (signal(j) >= noise)
%             total = 0;
%             for k = j + 1:j + 4
%                 if (signal(k) > noise)
%                     total = total + 1;
%                 end
%             end
%             if (total > 2)
%                 right = j;
%             end
%         end
%     end
%     
% end
% seg(2*n - 3) = right;
% seg(2*n - 2) = valley(n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second round -- segment pick 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = mean(maxval);      % average peak value
if (training == 1)             % training phase, hard threshold
    pth = p / 4.5;         
else                    % testing phase
    pth = p / scale1;
end
seg = zeros(2*(n - 1), 1);
count = 0;
for i = 1:n - 1
    if ( maxval(i)> pth)
        count = count + 1;
        maxval(count) = maxval(i);
        seg(2*count - 1) = valley(i);
        seg(2*count) = valley(i + 1);
    end
end
maxval = maxval(1:count);
seg = seg(1:2*count);
n = count;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% third round -- segment merge
% Should have multiple sub-rounds to merge multi-waves on the segment top!
% The time threshold used here is the effective span (notice function "findspan"), 
% in case some adjacent valleys are greatly imbalanced!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:2
    p = mean(maxval);      % average peak value
    timespan = mean(seg(2:2:2*n) - seg(1:2:2*n-1));
    if (training == 1)             % training phase, hard threshold
        pth = p / 4.5;         
    else                    % testing phase
        pth = p / scale2;
    end
    tth = timespan / tscale1; 
    [seg2, maxval, n] = segmerge(signal, seg, maxval, tth, pth);
    seg = seg2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Final time check -- in case unreasonanly short gesture < 7
% this step may be unnecessary but also meritorious, it's for further
% truncating small disruptions during the gesture combo!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timespan = mean(seg(2:2:2*n) - seg(1:2:2*n-1));
seg = zeros(2*n,1);
tth = timespan / tscale2;
p = mean(maxval);
pth = p / scale2;
count = 0;
for i = 1:n
   % filter those small peak-valley, harsh on time, but loose on magnitude
    espan = seg2(2*i) - seg2(2*i - 1);
    pv = (2*maxval(i) - signal(seg2(2*i)) -signal(seg2(2*i - 1))) / 2;
    
    if ( (espan < tth && pv < 2 * pth) || espan <= tth/2 || pv < pth / 2)
        continue
    else
        count = count + 1;
        maxval(count) = maxval(i);
        seg(2*count - 1) = seg2(2*i - 1);
        seg(2*count) = seg2(2*i);
    end
end
seg = seg(1:2 * count);
n = count;

% harsh penalty on the first one
if (maxval(1) < p / 5 || maxval(1) < p / 3.8 && seg(2) - seg(1) < 0.6 * timespan)
    seg = seg(3:2 * n);
    n = n - 1;
end

end

function [ output_args ] = untitled5( input_args )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


end

