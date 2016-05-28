import numpy as np
# import matplotlib.pyplot as plt
from scipy.signal import lfilter


def smooth_filter(signal):

    windowSize = 3
    smooth = lfilter(np.ones(windowSize) / windowSize, 1, signal)

    # plt.plot(signal)
    # plt.plot(smooth, color='red')
    # plt.show()

    return smooth