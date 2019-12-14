import capstoneLib as cap
import numpy as np
import soundfile as sf
import scipy.io.wavfile
import scipy.signal as sig
import matplotlib.pyplot as plt
import sounddevice as sd

'''
Jounivo Microphone:
    Fs = 48kHz
    Channels=1 if mono | Channels=2 if stereo
    16-bit ADC
'''

# Jounivo Microphone: Fs = 48kHz, Channels = 1(mono) or 2(stereo)
fs = 48000 # Hz
duration = 2 # seconds
ts = 1/fs # period
sd.default.channels = 2 # stereo recording

# Record for duration (seconds) at sampling rate fs
print('Talk now')
voice = sd.rec( int(duration*fs), fs)
sd.wait()
print('Done recording...')

# Convert Stereo to Mono, limit amplitude, normalize, downsample
dsVoice = sig.decimate(voice, 3)
mVoice = cap.ster2mono(dsVoice)
limited = cap.limiter(mVoice)
normVoice = cap.normalize(limited)
N = len(normVoice)
time = np.arange(0, N, 1)

# Crop start/end of signal and multiply cropped data by Hanning Window
X, S = cap.findStart(normVoice)
Y, E = cap.findEnd(normVoice)
M = int(E - S) # length of signal Start(S) to End(E)

# Conditional statements to make sure there is no indexing outside of the signal
if S-(M//10) < 0:
    start = S
else:
    start = S-(M//10)

if E+(M//10) > N:
    end = N
else:
    end = E+(M//10)

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

# Smooth Fourier Transform with convolution of 10 ones
ft = abs(FFT)
F = len(FFT)
Y = 10
rect = np.ones((Y,))
ftN = np.convolve(ft,rect,mode='same')
ftN = cap.normalize(ftN)

peakF = cap.peakFreq(ftN, fax)
peakF = np.around(peakF)
print("Peak Frequency Component:",peakF,"Hz")

''' 4 Subplots
1. Raw time domain voice signal
2. Windowed/Cropped time domain signal
3. Spectrum of Windowed WITHOUT smoothing/convolution
4. Spectrum of Windowed WITH smoothing/convolution '''
fig, ax = plt.subplots(2, 2, figsize=(8,6))
ax[0,0].plot(time, mVoice)
ax[0,0].set_xlabel('Samples')
ax[0,0].set_ylabel('Amplitude')

ax[0,1].plot(winTime, windowed)
ax[0,1].set_xlabel('Samples')
ax[0,1].set_ylabel('Windowed Amp.')

ax[1,0].plot(fax, abs(FFTN))
ax[1,0].set_xlabel('Frequency, Hz')
ax[1,0].set_ylabel('Magnitude')
ax[1,0].axis([0, 1000, 0, 1])
ax[1,0].set_xticks(np.arange(0,1000,100))

ax[1,1].plot(fax, ftN)
ax[1,1].set_xlabel('Frequency, Hz')
ax[1,1].set_ylabel('Magnitude')
ax[1,1].axis([0, 1000, 0, 1])
ax[1,1].set_xticks(np.arange(0,1000,100))

fig.suptitle('"Go" at ' + str(peakF) + 'Hz')
plt.savefig('C:\\Users\\brand\\Desktop\\CapstoneGraphs\\Go15 Sig-Window-FFT.png',
           bbox_inches='tight')
plt.show()

##### Uncomment to save recorded audio
# scipy.io.wavfile.write('file.wav', fs, mVoice)
