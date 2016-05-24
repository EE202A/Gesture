function [ mocap ] = load_mocapdata( mode )
%load mocap data and save in a 8*1 cell
% the mocap data is the data when user point to diff anchor node

mocap = cell(8,1);
for i = 1:8
    if mode == 1
        filename = ['data1/mocap', num2str(i - 1), '.csv'];
    elseif mode == 2
        filename = ['data2/mocap', num2str(i - 1), '.csv'];
    elseif mode == 3
        filename = ['data3/mocap', num2str(i - 1), '.csv'];
    elseif mode == 4
        filename = ['data4/mocap', num2str(i - 1), '.csv'];
    else 
        error('no mocap ranges data') 
    end
    mocap{i} = load(filename);
end

end

