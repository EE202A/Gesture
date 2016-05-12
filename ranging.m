close all
clear all
labels = 0:7;

for i = labels
    mocap = load(['mocap', num2str(i), '.csv']);
    ntb = load(['ntbtiming',num2str(i), '.csv']);
    timestamps = ntb(:,1);
    recv_ids = ntb(:,3);
    figure(i + 1)
    for j = 0:7
        logic = (recv_ids == j);
        if sum(logic) == 0
            display([num2str(i), ' missing node ', num2str(j)])
        end
        posix_t = timestamps(logic);
        times = ntb(logic, 5:10);
        ranges = calc_ranging(times);
        plot(posix_t, ranges)
        hold on
    end
    legend('0', '1', '2', '3', '4', '5', '6', '7')
end