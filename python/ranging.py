import numpy as np
import pickle as pkl
from get_offset import get_offset
from load_ntb import get_ntb_data
from load_mocap import get_mocap_data
from find_first_valley import get_first_valley
from estimate_coor import get_estimate_coors
from theoretical_ranges import theoretical_ranges_with_all
from global_var_config import anchor_count
from ntb_data_from_others import get_ntb_from_others
from compare_ranges import get_score_of_nodes


def get_score(anchor_node):
    offset = get_offset(anchor_node)
    ntb_range, posix_time = get_ntb_data(anchor_node, offset)

    if len(ntb_range) == 0:
        print 'Anchor node: ', anchor_node, ' get no data, output score is -1'
        return -1, -1

    mocap = get_mocap_data(anchor_node)

    find_valley, ids, stroke = get_first_valley(ntb_range)
    if not find_valley:
        print 'Find no valley at this anchor node! output score is -1'
        return -1, -1
    else:
        # find a valley
        # estimate the start point, here use mocap data, later use Ray's algo
        if len(mocap) == 0:
            print 'No Mocap data, cannot estimate the start point coordinate! output score is -1'
            return -1, -1

        else:
            start = np.mean(mocap[0:10, 2:5], axis=0)
            coors = get_estimate_coors(anchor_node, stroke, start)
            # calc the theoretical range with all node
            th_ranges = theoretical_ranges_with_all(coors)
            t = posix_time[ids]

            # TODO: broadcast t, and request interpolated smoothed strokes from all node

            pkl_data = get_ntb_from_others(t, anchor_node)

            scores = []
            for iNode in range(len(pkl_data['idx'])):
                node_idx = pkl_data['idx'][iNode]
                if len(pkl_data['time_span'][node_idx]) == 0:
                    scores.append(0)
                else:
                    score = get_score_of_nodes(t, th_ranges[:, node_idx], pkl_data['time_span'][node_idx], pkl_data['range_data'][node_idx])
                    scores.append(score)

            return np.mean(scores), np.var(scores)