clc
close all

fs = 48000;

%%%%% Plots continuous wavelet transform of 4 signals
Norm1 = normalize432(BG1);
figure
cwt(Norm1,fs)

Norm2 = normalize432(BG3);
figure
cwt(Norm2,fs)

Norm3 = normalize432(BG8);
figure
cwt(Norm3,fs)

Norm4 = normalize432(BG7);
figure
cwt(Norm4,fs)

















