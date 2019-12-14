clc
close all

fs = 48000;

%%%%% Compute Cepstrum and find
%%%%% fundamental frequecy from its peak
n1 = normalize432(BR3);
[~, S] = FindSignalStart(n1);
[~, E] = FindSignalEnd(n1);
M = floor((E-S)/10);
new = n1([ S-M : E+M ]);
N = length(new);

Y = fft(new.*hann(N));
C = fft( log(abs(Y) + eps));
maxim = 5000*length(Y)/fs;
f = (0:maxim)*fs/length(Y);
Y = Y(1:length(f));

ms1 = fs/1000; % 1000Hz (48)
ms20 = fs/50; % 50Hz (960)
q = (ms1:ms20)/fs;
C = abs( C(ms1:ms20) );

% Plot of the Fourier Transform
figure
plot(f, abs(Y))
title('FFT')
% Plot of the Cepstrum
figure
plot(q, C)
title('Cepstrum')

% Cepstrum max quefrequency and frequency conversion
[c, fx] = max(C)
Peak = fs / (ms1+fx-1)