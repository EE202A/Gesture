# Gesture-based Device Selection System
This repo consists of following components:

1. Matlab simulation and evaluation for a distributive gesture-based device selection algorithm that runs on each NTB nodes.
2. Distributed version Python codes implemented on ROS platforms for the same system.

#Structure of this repository
Under Distributed(Python) folder:

1. file "anchor" is the code running on ROS nodes to control corrosponding NTB nodes
2. Other files corroponds to the following Matlab version source codes. 

Under Source(matlab) folder:

Data colleced: 

1. Offset: mocap and ranging data measured at a fixed location for offset calculations
2. data1/2/3: mocap and ranging data collected when pointing ntb anchor node from node0 to node7 at 3 different locations

Main program:

1. ranging.m: The whole program starts from here. In the first stage, it loads all mocap and ntb data from one of the data set(the default
is data2) and calculates the ranging data from the raw ntb data. Next, it will adjust the ranging data with the pre-calculated offsets and 
smooth them with the moving average filter. In the second stage, it will first try to locate all potential candidates for the ntb node being 
pointed by detecting which node expereiced a significant decrease in their ranging measurements. The detection is done through simple 
thresholdings, whose values are selected manually based on observations. Then, it will narrow down the candidates pool to make final decision
by comparing the actual waveforms of ranging measurements from all ntb anchor nodes to the theoretical waveforms assuming the candidate is the
one being pointed at. The candidate with minium euclidean distances between waveforms will win. Currently, it uses mocap data in caclulations,
but we will later use localization algorithms to replace the location data. The last stage of the program will perform a performance check based
on the ground truth.

Supporting functions:

1. cal_ranging.m: calculate ranging values based on raw ntb data
2. load_ntbdata.m: calculate offsets based on offset data, load selected ntb data, find corrosponding ranging values, and adjust them with 
offsets found above. It also plot all ranging measurements at the same time.
3. load_mocapdata.m: load mocap data
4. mov_avg_filter.m: smooth input vector by finding moving average with window size 3
5. find_first_valley.m: detect if the smoothened given input has decrease below the given threshold and return the decreasing part
6. estimate_cor.m: assuming user's movement is a straight line toward selected node, find the 3D coordinates of corresponding ranging measurements.
7. theoretical_ranges: given trace of 3D coordinates, find corresponding ranging measurements from all ntb anchor nodes.
8. find_slot.m: find the beginning and ending points of a slot given two corresponding thresholds
9. compare_ranges.m: Given two ranging measurments and corrosponding timestamps, return euclidean distance between the two measurements after 
adjusting the measurments with linear interpolations. 

Unused functions:

Functions created for temporary testing purpose.

1. localization.m
2. mocap_analysis.m
3. mocap_analysis0.m



