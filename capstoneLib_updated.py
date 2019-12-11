'''
Custom functions written for ECE492
----------------
Libraries used: numpy, pandas
'''

import numpy as np
import pandas as pd

def normalize(data):
# Normalizes input values based on absolute maximum
# Requires: numpy
    dArray = np.array(data)
    dMax = max(abs(dArray))
    return dArray/dMax

def envelope(data, rate, threshold):
# Returns indices in data below the specified threshold
# Requires: pandas, numpy
    mask = []
    noise = []
    data = pd.Series(data).apply(np.abs)
    dataMean = data.rolling(window=int(rate/10),
                            min_periods=1,
                            center=True).mean()
    for mean in dataMean:
        if mean > threshold:
            mask.append(True)
            noise.append(False)
        else:
            mask.append(False)
            noise.append(True)
# Mask = above threshold
# Noise = below threshold
    return mask, noise

def ster2mono(data):
# Crude Stereo to Mono conversion
    return ( data[:,0] + data[:,1] )/2
