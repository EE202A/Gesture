import os
import numpy as np
from global_var_config import DATA_TYPE


def get_mocap_data(anchor_node, global_mocap_data):
    re_mocap = []

    # filename = './data/mocap/mocap' + str(anchor_node) + '.csv'
    if len(global_mocap_data) != 0:
        # re_mocap = np.genfromtxt(filename, delimiter=',', dtype=DATA_TYPE)
        re_mocap = global_mocap_data
    else:
        print '[load_mocap]: ' + 'No Mocap data!!!'

    return re_mocap
