''' Record audio and save as .wav file '''

import capstoneLib as cap
import numpy as np
import soundfile as sf
import scipy.io.wavfile
import scipy.signal as sig
import matplotlib.pyplot as plt
import sounddevice as sd

# Jounivo Microphone: Fs = 48kHz, Channels = 1(mono) or 2(stereo)
fs = 48000 # Hz
duration = 2 # seconds
sd.default.channels = 1 # mono recording

# Record for duration (seconds) at sampling rate fs
print('Begin')
voice = sd.rec( int(duration*fs), fs)
sd.wait()
print('Done...')

mVoice = cap.ster2mono(voice)
N = len(mVoice)
time = np.arange(0, N*ts, ts) # time, seconds
samples = np.arange(0, N, 1) # samples, n

# Plot to check if the recorded audio is worth keeping
plt.plot(time, mVoice)
plt.xlabel('Time, s')
plt.ylabel('Amplitude')
plt.show()

filename = 'testfile.wav'
scipy.io.wavfile.write(filename, fs, mVoice)
