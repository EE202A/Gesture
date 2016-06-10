# Gesture-based Device Selection System
### This repo consists of following components:

* Matlab simulation and evaluation for a distributive gesture-based device selection algorithm that runs on each NTB nodes.
* Distributed version Python codes implemented on ROS platforms for the same system.

#Structure of this repository
### Under Distributed(Python) folder:

* file "anchor" is the code running on ROS nodes to control corrosponding NTB nodes
* Other files corroponds to the following Matlab version source codes. 

### Under Source(matlab) folder:

#### Data colleced: 
* Offset: mocap and ranging data measured at a fixed location for offset calculations
* data1/2/3: mocap and ranging data collected when pointing ntb anchor node from node0 to node7 at 3 different locations

#### Main program:
* <code>ranging.m</code>: The whole program starts from here. In the first stage, it loads all mocap and ntb data from one of the data set(the default
is data2) and calculates the ranging data from the raw ntb data. Next, it will adjust the ranging data with the pre-calculated offsets and 
smooth them with the moving average filter. In the second stage, it will first try to locate all potential candidates for the ntb node being 
pointed by detecting which node expereiced a significant decrease in their ranging measurements. The detection is done through simple 
thresholdings, whose values are selected manually based on observations. Then, it will narrow down the candidates pool to make final decision
by comparing the actual waveforms of ranging measurements from all ntb anchor nodes to the theoretical waveforms assuming the candidate is the
one being pointed at. The candidate with minium euclidean distances between waveforms will win. Currently, it uses mocap data in caclulations,
but we will later use localization algorithms to replace the location data. The last stage of the program will perform a performance check based
on the ground truth.

#### Supporting functions:

* <code>cal_ranging.m</code>: calculate ranging values based on raw ntb data
* <code>load_ntbdata.m</code>: calculate offsets based on offset data, load selected ntb data, find corrosponding ranging values, and adjust them with 
offsets found above. It also plot all ranging measurements at the same time.
* <code>load_mocapdata.m</code>: load mocap data
* <code>mov_avg_filter.m</code>: smooth input vector by finding moving average with window size 3
* <code>find_first_valley.m</code>: detect if the smoothened given input has decrease below the given threshold and return the decreasing part
* <code>estimate_cor.m</code>: assuming user's movement is a straight line toward selected node, find the 3D coordinates of corresponding ranging measurements.
* <code>theoretical_ranges</code>: given trace of 3D coordinates, find corresponding ranging measurements from all ntb anchor nodes.
* <code>find_slot.m</code>: find the beginning and ending points of a slot given two corresponding thresholds
* <code>compare_ranges.m</code>: Given two ranging measurments and corrosponding timestamps, return euclidean distance between the two measurements after 
adjusting the measurments with linear interpolations. 

#### Unused functions:  
Functions created for temporary testing purpose.

* <code>localization.m</code>
* <code>mocap_analysis.m</code>
* <code>mocap_analysis0.m</code>



