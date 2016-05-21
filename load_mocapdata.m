function [ mocap ] = load_mocapdata( mode )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
mocap = cell(8,1);
for i = 1:8
    if mode == 1
        filename = ['data1/mocap', num2str(i - 1), '.csv'];
    elseif mode == 3
        filename = ['data3/mocap', num2str(i - 1), '.csv'];
    else
        error('no such shit') 
    end
    mocap{i} = load(filename);
end

end

