import numpy as np
from global_var_config import anchor_coor, anchor_count


def theoretical_ranges(mocap_data, anchor_node):
    tmp = mocap_data - np.tile(anchor_coor[anchor_node], (mocap_data.shape[0], 1))
    th_r = np.sqrt(tmp[:, 0]**2 + tmp[:, 1]**2 + tmp[:, 2]**2)

    return th_r


def theoretical_ranges_with_all(coors):
    th_r = np.zeros((coors.shape[0], anchor_count))

    for iNode in range(anchor_count):
        anchor_coor_tmp = anchor_coor[iNode]
        tmp = coors - np.tile(anchor_coor_tmp, (coors.shape[0], 1))
        th_r[:, iNode] = np.sqrt(tmp[:, 0]**2 + tmp[:, 1]**2 + tmp[:, 2]**2)

    return th_r