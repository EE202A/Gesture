import numpy as np
from get_offset import get_offset
from load_ntb import get_ntb_data
from load_mocap import get_mocap_data
from find_first_valley import get_first_valley
from estimate_coor import get_estimate_coors
from theoretical_ranges import theoretical_ranges_with_all
from global_var_config import anchor_count


def get_score(anchor_node):
    output_score = np.array([0, 0])

    offset = get_offset(anchor_node)
    ntb_range, posix_time = get_ntb_data(anchor_node, offset)

    if len(ntb_range) == 0:
        print 'Anchor node: ', anchor_node, ' get no data, output score is -1'
        output_score[0] = -1
        output_score[1] = -1
        return output_score

    mocap = get_mocap_data(anchor_node)

    find_valley, ids, stroke = get_first_valley(ntb_range)
    if not find_valley:
        print 'Find no valley at this anchor node! output score is -1'
        output_score[0] = -1
        output_score[1] = -1
        return output_score
    else:
        # find a valley
        # estimate the start point, here use mocap data, later use Ray's algo
        if len(mocap) == 0:
            print 'No Mocap data, cannot estimate the start point coordinate! output score is -1'
            output_score[0] = -1
            output_score[1] = -1
            return output_score

        else:
            start = np.mean(mocap[0:10, 2:5], axis=0)
            coors = get_estimate_coors(anchor_node, stroke, start)
            th_ranges = theoretical_ranges_with_all(coors)
            t = posix_time[ids]

            # for iNode in range(anchor_count):
























