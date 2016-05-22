%% caculate the "pointing vector" from mocap data
% data2 folder
mode = 2;
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

angles = zeros(8,8);
for i = 0:7 
    M = csvread(['data', num2str(mode), '/mocap',num2str(i),'.csv']);
    x = M(:,3);
    y = M(:,4);
    z = M(:,5);
    x1 = mean(x(1:10));
    y1 = mean(y(1:10));
    z1 = mean(z(1:10));
    
    x2 = mean(x(length(x)-10:length(x)));
    y2 = mean(y(length(y)-10:length(y)));
    z2 = mean(z(length(z)-10:length(z)));
    practice = [x1 y1 z1] - [x2 y2 z2];
    for j = 0:7
        theory = [x1 y1 z1] - anchors(j+1,:);
        theory = theory / norm(theory);
        practice = practice / norm(practice);
        angles(i+1,j+1) = acos(theory * practice')/3.141592658*180;
    end
end

tem = zeros(1,8);
for i = 1:8
    if angles(i,i) == min(angles(i,:))
        tem(i) = 1;
    else
        tem(i) =0;
    end
end
% the correctness of each vector -- is it pointing at the right node?
display(tem);
% Angle in degree
display(angles)