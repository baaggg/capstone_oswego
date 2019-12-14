import numpy as np
import capstoneLib as cap
import sounddevice as sd
import matplotlib.pyplot as plt

'''
This script records your voice for *duration* amount of seconds for
*AMOUNT* number of times and plots the Magnitude Spectrum
of the word you spoke.

Outputs 5 waveforms on 1 graph, and the highest frequency component
within each iteration
'''

# JOUNIVO mic: Fs = 48kHz, Channels = 1(mono) or 2(stereo)
fs = 48000 # Hz
duration = 1.5 # seconds
ts = 1/fs # period
sd.default.channels = 2 # stereo recording

FFTs = []
faxes = []
Freqs = []
SampleNums = []
AMOUNT = 5 # How many times do you want to say the word?
print("-------------------- BEGINNING --------------------")
for q in range(AMOUNT):

    # Record for duration (seconds) at sampling rate fs
    print("Talk now")
    voice = sd.rec( int(duration*fs), fs)
    sd.wait()
    print("Done recording \n~~~~~~~~~~~~~~~~~~~~~~")

    # Convert Stereo to Mono, limit amplitude, normalize from [-1,1], make time axis
    mVoice = cap.ster2mono(voice)
    limited = cap.limiter(mVoice)
    normVoice = cap.normalize(limited)
    N = len(normVoice)
    time = np.arange(0, N, 1)

    # Crop start/end of signal and multiply cropped data by Hanning Window
    X, S = cap.findStart(normVoice)
    Y, E = cap.findEnd(normVoice)
    N = len(normVoice)
    M = int(E - S) # length of signal Start(S) to End(E)
##    SampleNums.append(M) ############################
    if S-(M//4) < 0:
        start = S
    else:
        start = S-(M//4)

    if E+(M//4) > N:
        end = N
    else:
        end = E+(M//4)

    K = int(end - start)
    if K%2 == 0: # Make window length odd number
        K += 1
        start += 1 # Signal dimension must equal Window dimension
    wHan = np.hanning(int(K))

    windowed = []
    j = 0
    for k in range(start,end):
        val = normVoice[k]*wHan[j]
        windowed.append(val)
        j += 1
    winTime = np.arange(0,len(windowed),1)

    # Fourier Transform of windowed voice signal and peak frequency
    FFT, fax = cap.fftprops(windowed,fs)
    FFTN = cap.normalize(FFT)
    faxes.append(fax) ########################

    ft = abs(FFT)
    F = len(FFT)
    Y = 10
    rect = np.ones((Y,))
    ftN = np.convolve(ft,rect,mode='same')
    ftN = cap.normalize(ftN)
    FFTs.append(ftN)  ##########################

    peakF = cap.peakFreq(ftN, fax)
    peakF = np.around(peakF)
    Freqs.append(peakF)
print("Peak frequencies from each recorded word:\n",Freqs)

##### Plotting multiple waves on the same plot
plt.figure(figsize=(10,6))
for g in range(AMOUNT):
    plt.plot(faxes[g], FFTs[g], label=str(g+1))

##### Plot customization
plt.axis([0, 1000, 0, 1])
plt.xticks(np.arange(0,1000,100))
plt.yticks(np.arange(0,1,0.1))
plt.title('Brandon "Back"')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Magnitude')
plt.legend()
plt.show()
