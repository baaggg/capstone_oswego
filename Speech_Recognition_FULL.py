import capstoneLib as cap
import numpy as np
import soundfile as sf
import scipy.signal as sig
import sounddevice as sd
import serial
import pandas as pd
import sklearn.utils
import time

##### Sampling Rate values and recorder initialization
fs = 48000 # initial sample rate
ds = 16000 # downsampled rate
sec = 3 # seconds
duration = int(sec*fs)
sd.default.channels = 1 # mono recording

###### Tx XBee
ser1 = serial.Serial()
ser1.baudrate = 9600
ser1.port = 'COM5'
ser1.open()

##### Record speaker for "sec" seconds
time.sleep(1)
print('Talk now')
voice = sd.rec(duration, fs)
sd.wait()
print('Done...')

##### Speech Detection and Preprocessing
voice = voice[:,0]
voice = cap.normalize(voice)
dsVoice = sig.decimate(voice, 3)
mask, noise = cap.envelope(dsVoice, ds, 0.04)
speech = dsVoice[mask]

##### Do STFT
F, T, STFT = sig.stft(x=speech,
                      fs=ds,
                      window='hann',
                      nperseg=128,
                      noverlap=96,
                      nfft=128,
                      return_onesided=False)

# Magnitude of the STFT
aSTFT = abs(STFT)

# Check High or Low pitch (Male vs. Female)
zeroHz = aSTFT[ [0], ]
avgZ = np.mean(zeroHz)

if avgZ >= 0.0125:
    print('Low pitch voice.')
    ##### Go and Right are typically stronger at 500Hz
    ##### Left and Back are typically stronger at 625Hz
    sec4 = aSTFT[ [4], ] # 500Hz
    low = np.sum(sec4)

    sec5 = aSTFT[ [5], ] # 625Hz
    high = np.sum(sec5)

    if low > high: # Compare RIGHT and GO
        row1 = aSTFT[ [8] , ] # Row for 1kHz
        I1 = np.where( row1 == np.amax(row1) )

        row2 = aSTFT[ [16] , ] # Row for 2kHz
        I2 = np.where( row2 == np.amax(row2) )

        if I1[1] > I2[1]:
            print('You said "Go."')
            msg = bytes('g', 'utf-8')
        else:
            print('You said "Right."')
            msg = bytes('r', 'utf-8')

    else: # Compare LEFT and BACK
        first = []
        for w in range(9,13): # 1125 - 1500 Hz
            fRow = aSTFT[ [w], ]
            first.append(fRow)
        fArr = np.array(first)
        firstSum = np.sum(fArr)

        second = []
        for q in range(13,17): # 1625 - 2000 Hz
            sRow = aSTFT[ [q], ]
            second.append(sRow)
        sArr = np.array(second)
        secondSum = np.sum(sArr)

        if firstSum > secondSum:
            print('You said "Left."')
            msg = bytes('l', 'utf-8')
        else:
            print('You said "Back."')
            msg = bytes('b', 'utf-8')

else:
    print('High pitch voice.')
    ##### Split to GO/LEFT or RIGHT/BACK
    twoK = aSTFT[ [16] , ] # Row for 2kHz
    check = np.mean(twoK)

    if check < 0.009:
        ##### GO vs LEFT
        cut1 = aSTFT[ [20] , ] # Row for 2.5kHz
        avg1 = np.mean(cut1)

        cut2 = aSTFT[ [24] , ] # Row for 3kHz
        avg2 = np.mean(cut2)

        if avg1 > avg2:
            print('You said "Go."')
            msg = bytes('g', 'utf-8')
        else:
            print('You said "Left."')
            msg = bytes('l', 'utf-8')
    else:
        ##### RIGHT vs BACK
        cut1 = aSTFT[ [24] , ] # Row for 3kHz
        avg1 = np.mean(cut1)

        cut2 = aSTFT[ [32] , ] # Row for 4kHz
        avg2 = np.mean(cut2)

        if avg1 > avg2:
            print('You said "Back."')
            msg = bytes('b', 'utf-8')
        else:
            print('You said "Right."')
            msg = bytes('r', 'utf-8')
print('~~~~~~~~~~~~~~~~~~~~~~~~~')

##### Write to the Tx XBee so it transmits to the Rx XBee
##### on the Tiva-C
ser1.write(msg)
ser1.close()
