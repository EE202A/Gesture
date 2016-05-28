import numpy as np
from get_offset import get_offset
from load_ntb import get_ntb_data
from load_mocap import get_mocap_data
from find_first_valley import get_first_valley
from estimate_coor import get_estimate_coors
from theoretical_ranges import theoretical_ranges_with_all
from ntb_data_from_others import get_ntb_from_others
from compare_ranges import get_score_of_nodes


class ntb_score:

    local_ntb_data = []
    anchor_node = []
    stroke = []
    ids = []
    posix_time = []

    def __init__(self, anchor_node, local_ntb_data):
        self.local_ntb_data = local_ntb_data
        self.anchor_node = anchor_node
        pass

    def find_valley(self):
        offset = get_offset(self.anchor_node)

        ntb_range, posix_time = get_ntb_data(self.anchor_node, offset, self.local_ntb_data)

        if len(ntb_range) == 0:
            print '[ranging]: ' + 'Anchor node: ', self.anchor_node, ' get no data, output score is -1'
            return False

        find_valley, ids, stroke = get_first_valley(ntb_range)

        self.stroke = stroke
        self.ids = ids
        self.posix_time = posix_time

        if not find_valley:
            print '[ranging]: ' + 'Find no valley at this anchor node! output score is -1'
            return False
        else:
            return True

    # if find valley then get the global ntb data and then calc score
    # if didn't find valley then score is (-1, -1) and don't need to get the global ntb data.
    # this should be set in ray's function
    def get_score(self, global_ntb_data):
        # find a valley
        start = [] # wait for ray's localizaiton
        coors = get_estimate_coors(self.anchor_node, self.stroke, start)
        # calc the theoretical range with all node
        th_ranges = theoretical_ranges_with_all(coors)
        t = self.posix_time[self.ids]

        # TODO: broadcast t, and request interpolated smoothed strokes from all node

        pkl_data = get_ntb_from_others(t, global_ntb_data)

        scores = []
        for iNode in range(len(pkl_data['idx'])):
            node_idx = pkl_data['idx'][iNode]
            if len(pkl_data['time_span'][node_idx]) == 0:
                scores.append(0)
            else:
                score = get_score_of_nodes(t, th_ranges[:, node_idx], pkl_data['time_span'][node_idx], pkl_data['range_data'][node_idx])
                scores.append(score)

        return np.mean(scores), np.var(scores)