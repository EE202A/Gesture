import numpy as np
from numpy import linalg as la


def get_score_of_nodes(base_time, th_range, anchor_time, actual_range):

    if anchor_time[0] > base_time[0] or anchor_time[-1] < base_time[-1]:
        print 'Error interpolate!'
        return -1
    else:
        x21 = np.interp(base_time, anchor_time, actual_range)
        x21 = x21 - (x21[0] - th_range[0])

        y = la.norm(x21 - th_range) / len(th_range)
        return y