import numpy as np
import os
from global_var_config import DATA_TYPE
from calc_ranging import calc_ranging


def get_ntb_data(anchor_node, offset):

    re_ntb = []
    re_posix_t = []
    filename = './data/ntb/ntb'+str(anchor_node)+'.csv'
    if os.path.exists(filename):
        ntb = np.genfromtxt(filename, delimiter=',', dtype=DATA_TYPE)
        timestamps = ntb[:, 0]
        recv_ids = ntb[:, 2]

        logic = (recv_ids == anchor_node)
        missing_bool = False
        for iLogic in np.nditer(logic):
            if iLogic:
                missing_bool = True
                break

        if not missing_bool:
            print 'Missing Anchor node: ', anchor_node, ' data!!!'

        else:
            times = ntb[logic, 4:10]
            ntb_range, mask = calc_ranging(times)
            ntb_range = ntb_range[mask]

            ntb_range = ntb_range - offset

            posix_t = timestamps[logic]
            posix_t = posix_t[mask]

            re_ntb = ntb_range
            re_posix_t = posix_t

    else:
        print 'No Anchor node: ', anchor_node, ' data csv file!!! At ', filename

    return re_ntb, re_posix_t


