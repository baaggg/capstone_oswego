clc
close all

% audiodevinfo
fs = 48000; % sample rate 48kHz
nbits = 16; % bits per sample
channels = 1; % mono
duration = 2.5; % seconds

% Slow down MATLAB
pause(2)

% Record speaker audio
recObj = audiorecorder(fs, nbits, 1);
disp('Talk now')
recordblocking(recObj, duration);
disp('Done...')

% Get values from the object / make X-axis
data = getaudiodata(recObj);

% Plot to see if signal is worth keeping
plot(data)

% Save the file
% Note: 'filename' needs to change depending on
% where you want to save the wav file.
filename = 'C:\Users\brand\Desktop\noiseRM236.wav';
audiowrite(filename, data, fs);