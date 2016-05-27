import numpy as np
import os
from calc_ranging import calc_ranging
from global_var_config import DATA_TYPE
from theoretical_ranges import theoretical_ranges


def calc_offset(ntb, mocap, anchor_node):
    recv_ids = ntb[:, 2]
    logic = (recv_ids == anchor_node)

    missing_bool = False
    for iLogic in np.nditer(logic):
        if iLogic:
            missing_bool = True
            break

    if not missing_bool:
        print 'Offset calc missing node', anchor_node
        return 0
    else:
        times = ntb[logic, 4:10]
        ntb_range, mask = calc_ranging(times)
        ntb_range = ntb_range[mask]

        th_ranges = theoretical_ranges(mocap[:, 2:5], anchor_node)

        offset = np.mean(ntb_range) - np.mean(th_ranges)

        offset = offset.astype(DATA_TYPE)
        return offset


def get_offset(anchor_node):

    re = 0
    # check if cached offset exist
    if os.path.exists('./offsets/offset.csv'):
        re = np.genfromtxt('./offsets/offset.csv', delimiter=',', dtype=DATA_TYPE)
        print 'Load offset from cache, offset: ', re

    elif os.path.exists('./offsets/ntb_offset1.csv') and \
         os.path.exists('./offsets/mocap_offset1.csv'):

        ntb = np.genfromtxt('./offsets/ntb_offset1.csv', delimiter=',', dtype=DATA_TYPE)
        mocap = np.genfromtxt('./offsets/mocap_offset1.csv', delimiter=',', dtype=DATA_TYPE)
        offset = calc_offset(ntb, mocap, anchor_node)

        np.savetxt('./offsets/offset.csv', [offset], delimiter=',')

        re = offset

        print 'Calc offset from data, offset: ', re
    else:
        print 'No offset data csv file!'

    return re
