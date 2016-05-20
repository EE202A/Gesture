close all;
clear all;
for i = 0:7
    M0 = csvread(['mocap',num2str(i),'.csv']);
    x0 = M0(:,3);
    y0 = M0(:,4);
    z0 = M0(:,5);
    figure
    xlim([min(x0(1)+0.1*x0(1),x0(length(x0))+0.1*x0(length(x0))), max(x0(1)+0.1*x0(1),x0(length(x0))+0.1*x0(length(x0)))]);
    ylim([min(y0(1)+0.1*y0(1),y0(length(y0))+0.1*y0(length(y0))), max(y0(1)+0.1*y0(1),y0(length(y0))+0.1*y0(length(y0)))]);
    zlim([min(z0(1)+10*z0(1),z0(length(z0))+10*z0(length(z0))), max(z0(1)+10*z0(1),z0(length(z0))+10*z0(length(z0)))]);
    scatter3(x0,y0,z0);
end