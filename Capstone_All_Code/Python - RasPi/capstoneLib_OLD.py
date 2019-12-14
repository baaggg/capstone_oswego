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
# Note: "mask" are indices, NOT the cropped signal
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
    return mask, noise

def ster2mono(data):
# Stereo to Mono conversion
    return ( data[:,0] + data[:,1] )/2

def quantize(data,nbits):
# Quantize values to any positive integer bit value, n
# Requires: normalize, numpy
    n = (2**nbits)
    a = normalize(data)
    b = a+1
    c = b/2
    d = c*(n-1)
    e = np.around(d)
    Q = 2/n
    return (Q/2) + (e*Q) - 1

def fftprops(data, Fs):
# Generates FFT and Freq. axis related to data input
# Requires: numpy, normalize
# Setting up the frequency axis
    data = normalize(data)
    N = len(data)
    K = np.arange(N)
    T = N/Fs
    freq = K/T # Double sided spectrum
    freq = freq[range(int(N/2))] # Single sided spectrum
# Performing the fft of input data
    FFT = np.fft.fft(data)/N # normalized by length of signal
    FFT = FFT[range(int(N/2))]
# Returns the magnitude of the FFT, and the frequencies in a vector
# Note: Set up for single sided spectrum
    return FFT, freq

def findStart(data):
    N = len(data)
    x = normalize(data)
    xP = np.power(x,2)

    M = 1000
    rect = np.ones((M,))
    xP = np.convolve(xP,rect,mode='same')
    xP = normalize(xP)
    Thresh = 0.15

    for i in range(N):
        if xP[i] >= Thresh:
            if i+1 > N:
                start = N
            else:
                start = i+1
            if start+500 > N:
                end = N
            else:
                end = start+500
            pRange = np.array(xP[start:end])
            avgP = np.sum(pRange) / len(pRange)
            if avgP > Thresh:
                index = i
                break
            else:
                index = 0
    signal = x[index:N]
    return signal, index

def findEnd(signal):
# Finds end of a signal
# Requires: numpy, findStart
    xFlip = np.flip(signal)
    yFlip, yIndex = findStart(xFlip)
    y = np.flip(yFlip)
    end = len(signal) - yIndex
    return y, end

def hanSig(data):
# Takes raw input data and windows it with a Hanning Window
# Requires: numpy, findStart, findEnd
    X, S = findStart(data)
    Y, E = findEnd(data)
    N = len(data)
    M = E - S # length of signal Start(S) to End(E)

    if S-(M//4) < 0:
        start = S
    else:
        start = S-(M//4)

    if E+(M//4) > N:
        end = N
    else:
        end = E+(M//4)

    wHan = np.hanning(int(end-start))

    windowed = []
    j = 0
    for i in range(start,end):
        val = data[i]*wHan[j]
        windowed.append(val)
        j += 1
    return windowed, M

def sinc_Ntaps(fcut, fs, N):
# Makes sinc h[n] of N taps
# Input the desired cutoff frequency, sampling rate, and odd value of N
# Requires: numpy
    fc = fcut/fs
    n = np.arange( -(N-1)/2 , (N-1)/2, 1)
    h = 2*fc*np.sinc(2*fc*n)
    return h

def peakFreq(FFT, fAxis):
# Given an FFT and Frequency Axis, it finds the peak frequency
    indx = 0
    for i in range(len(FFT)):
        if FFT[i] == max(FFT):
            indx = i
            break
    peakF = fAxis[indx]
    return peakF

def limiter(data):
# Any large values greater than typical sound amplitude are
# reduced to limit=0.055.
    negLim = -0.055
    posLim = 0.055
    N = len(data)
    for i in range(N):
        if data[i] >= posLim:
            data[i] = posLim
        elif data[i] <= negLim:
            data[i] = negLim
        else:
            data[i] = data[i]
    return data

def SNR_dB(voice, noise_pwr):
# Crude SNR calculation function that ended up not
# being ideal for proper analysis.
# Requires: numpy and envelope function from capstoneLib
    mask = envelope(voice, 48000, 0.015)
    speech = voice[mask]
    signal_pwr = np.mean(np.power(abs(speech), 2))
    ratio = int(signal_pwr / noise_pwr)
    snr_dB = 10*np.log10(ratio)
    return snr_dB
