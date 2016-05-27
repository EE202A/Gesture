import os
import numpy as np
from global_var_config import DATA_TYPE


def get_mocap_data(anchor_node):
    re_mocap = []

    filename = './data/mocap/mocap' + str(anchor_node) + '.csv'
    if os.path.exists(filename):
        re_mocap = np.genfromtxt(filename, delimiter=',', dtype=DATA_TYPE)

    return re_mocap