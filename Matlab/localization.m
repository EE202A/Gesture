function [ loc ] = localization(ranges)
% Given ranging measurements of each anchor node, calculate 
% 3d coordinate at the stationary point
%   input: 
%           ranges -- 8 * 1 cell of ranges from alpha to hotel, []
%                                   means no measurement
%   output: xyz  -- [x y z] coordinate of the stationary point

global anchors;
range = zeros(1,8);
for i = 1:8
    if length(ranges{i}) < 9
        continue;
    end
    r = ranges{i};
    range(i) = mean(r(1:5));
end

% range = [4.777,3.916,4.269,5.47,2.001,2.512,3.29,6.01]; %test data1--initial location
% range = [4.41,3.062,4.593,5.539,1.414,2.6,3.349,5.332]; %test data2--end point
display(range)
syms x y z;
x_limits = [-5.88, 3.055];
y_limits = [0, 2.434];
z_limits = [-4.124, 4.069];
%Centroid point
loc1 = zeros(1,3);
counter=0; 
counter_loop = 0;

%least square method
A = zeros(8,3);%Linearization of sphere near loc point
b = zeros(8,1);

valid_range_index = find(range);
if(length(valid_range_index) < 3)
   display('no solution');
   loc = [];
   return
end

node1 = anchors(valid_range_index(1),:);
for i = valid_range_index(2)
    for k = valid_range_index(3:end) 
        counter_loop = counter_loop+1;
        nodei = anchors(i,:);
        nodek = anchors(k,:);
        [sx, sy, sz] = solve([(x-node1(1))^2+(y-node1(2))^2+(z-node1(3))^2 == (range(1))^2,...
            (x-nodei(1))^2+(y-nodei(2))^2+(z-nodei(3))^2 == (range(i))^2,...
            (x-nodek(1))^2+(y-nodek(2))^2+(z-nodek(3))^2 == (range(k))^2],x,y,z,'Real',true);
        if(~isempty(sx) && ~isempty(sy) && ~isempty(sz))
            loc_candidate = [double(sx), double(sy), double(sz)];
    %         display(loc_candidate);
            for j = 1:length(sx) %remove points over range
                if(loc_candidate(j,1) >= x_limits(1) && loc_candidate(j,1) <= x_limits(2) ...
                        && loc_candidate(j,2)>= y_limits(1) && loc_candidate(j,2)<= y_limits(2)...
                        && loc_candidate(j,3)>= z_limits(1) && loc_candidate(j,3)<= z_limits(2))
    %                 display(loc_candidate(j,:));
                    loc1 = loc1 + loc_candidate(j,:);
                    counter = counter+1;
                    
                    for n_num = 1:8
                        n = anchors(n_num,:) - loc_candidate(j,:);
                        A((counter_loop-1)*8+n_num,:) = n;
                        b((counter_loop-1)*8+n_num) =  loc_candidate(j,:) * n';                
                    end
                end
            end        
        end
    end
end
% display(A);
% display(b);
% display(counter_loop)
loc1 = loc1/counter;
display(loc1);
loc2 = A\b;
display(loc2');
loc = (loc1 + loc2')/2;

