clc
close all

%%%%% Python STFT Defaults
% Segment Length = 256
% Window Length = 256 (Hanning)
% Overlap = 128
% FFT Length = 256

%%%%% MATLAB STFT Defaults
% Segment Length = 128
% Window Length = 128 (Hanning)
% Overlap = 96 
% FFT Length = 128

%%%%% Importing wav files (fs is always 48,000Hz)
fs = 48000;
% Kory Go
[KG1, ~] = audioread('KM_go1.wav'); 
[KG2, ~] = audioread('KM_go2.wav');
[KG3, ~] = audioread('KM_go3.wav');
[KG4, ~] = audioread('KM_go4.wav');
[KG5, ~] = audioread('KM_go5.wav');
% Kory Right
[KR1, ~] = audioread('KM_right1.wav'); 
[KR2, ~] = audioread('KM_right2.wav');
[KR3, ~] = audioread('KM_right3.wav');
[KR4, ~] = audioread('KM_right4.wav');
[KR5, ~] = audioread('KM_right5.wav');
% Brandon Go
[BG1, ~] = audioread('BG_go1.wav'); 
[BG2, ~] = audioread('BG_go2.wav');
[BG3, ~] = audioread('BG_go3.wav');
[BG4, ~] = audioread('BG_go4.wav');
[BG5, ~] = audioread('BG_go5.wav');
[BG6, ~] = audioread('BG_go6.wav'); 
[BG7, ~] = audioread('BG_go7.wav');
[BG8, ~] = audioread('BG_go8.wav');
[BG9, ~] = audioread('BG_go9.wav');
[BG10, ~] = audioread('BG_go10.wav');
% Brandon Left
[BL1, ~] = audioread('BG_left1.wav'); 
[BL2, ~] = audioread('BG_left2.wav');
[BL3, ~] = audioread('BG_left3.wav');
[BL4, ~] = audioread('BG_left4.wav');
[BL5, ~] = audioread('BG_left5.wav');
[BL6, ~] = audioread('BG_left6.wav'); 
[BL7, ~] = audioread('BG_left7.wav');
[BL8, ~] = audioread('BG_left8.wav');
[BL9, ~] = audioread('BG_left9.wav');
[BL10, ~] = audioread('BG_left10.wav');
% Brandon Back
[BB1, ~] = audioread('BG_back1.wav'); 
[BB2, ~] = audioread('BG_back2.wav');
[BB3, ~] = audioread('BG_back3.wav');
[BB4, ~] = audioread('BG_back4.wav');
[BB5, ~] = audioread('BG_back5.wav');
[BB6, ~] = audioread('BG_back6.wav'); 
[BB7, ~] = audioread('BG_back7.wav');
[BB8, ~] = audioread('BG_back8.wav');
[BB9, ~] = audioread('BG_back9.wav');
[BB10, ~] = audioread('BG_back10.wav');
% Brandon Right
[BR1, ~] = audioread('BG_right1.wav'); 
[BR2, ~] = audioread('BG_right2.wav');
[BR3, ~] = audioread('BG_right3.wav');
[BR4, ~] = audioread('BG_right4.wav');
[BR5, ~] = audioread('BG_right5.wav');
[BR6, ~] = audioread('BG_right6.wav'); 
[BR7, ~] = audioread('BG_right7.wav');
[BR8, ~] = audioread('BG_right8.wav');
[BR9, ~] = audioread('BG_right9.wav');
[BR10, ~] = audioread('BG_right10.wav');
% Brandon Go, Right, Back, Left
[BA1, ~] = audioread('BG_all_GRLB1.wav');
[BA2, ~] = audioread('BG_all_GRLB2.wav');
[BA3, ~] = audioread('BG_all_GRLB3.wav');

%%%%%%%%%% Cropping signals and using STFT
buff = 2048; % arbitrary number
one = BG1;
two = BG2;
three = BG3;

%%%%% Crop noise out of signals
%%%%% Downsample to 16kHz
%%%%% Do STFT and plot spectrogram
[xR1, sR1] = FindSignalStart(one);
[yR1, eR1] = FindSignalEnd(one);
SR1 = sR1-buff;
ER1 = eR1+buff;
new1 = one([SR1:ER1]);
test = downsample(new1,3);
figure
stft(test,16000)
title('one')

[xR2, sR2] = FindSignalStart(two);
[yR2, eR2] = FindSignalEnd(two);
SR2 = sR2-buff;
ER2 = eR2+buff;
new2 = two([SR2:ER2]);
figure
stft(new2,fs)
title('two')

[xR3, sR3] = FindSignalStart(three);
[yR3, eR3] = FindSignalEnd(three);
SR3 = sR3-buff;
ER3 = eR3+buff;
new3 = three([SR3:ER3]);
figure
stft(new3,fs)
title('three')

%%%%% Take max of STFT along time axis
%%%%% Find peaks along the new maximum vector
%%%%% Print peak frequencies
%%%%% Idea recommendation from Prof. Mario Bkassiny
[s, f, t] = stft(new2,fs);
sv = max(abs(s), [], 2);
figure
plot(f,sv)
[pks, locs] = findpeaks(sv);
f(locs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Plotting STFTs under different parameters %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Brandon Right, Python Parameters
% figure
% stft(BR1,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR2,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR3,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR4,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR5,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR6,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR7,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR8,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR9,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)
% figure
% stft(BR10,fs, 'Window', hann(256,'periodic'),...
%     'OverlapLength', 128, 'FFTLength', 256)

%%%%%%%%%% Comparing Brandon saying (Go, Right Left, Back) using default MATLAB
%%%%%%%%%% STFT values vs. Python's default STFT values noted above
% figure
% stft(BA1,fs)
% title('Brandon: Go,Right,Left,Back - MATLAB Defaults')
% figure
% stft(BA1,fs, 'Window', hann(256,'periodic'), 'OverlapLength', 128, 'FFTLength', 256)
% title('Brandon: Go,Right,Left,Back - Python Parameters')

%%%%%%%%%% Changing Overlap Length in the same signal
% figure
% stft(BA1,fs)
% title('Brandon: Go,Right,Left,Back - Default Overlap=96')
% figure
% stft(BA1,fs, 'OverlapLength', 8)
% title('Brandon: Go,Right,Left,Back - Custom Overlap=8')

%%%%%%%%%% Comparing Brandon "Go" (BG4) with
%%%%%%%%%% MATLAB defaults vs Python Defaults
% figure
% stft(BG4, fs)
% title('BG4 MATLAB Defaults')
% figure
% stft(BG4, fs, 'Window', hann(256,'periodic'), 'OverlapLength', 128, 'FFTLength', 256)
% title('BG4 Python Defaults')

%%%%%%%%%% Comparing Brandon and Stephanie saying
%%%%%%%%%% Go, Right, Left, Back with MATLAB Defaults
% figure
% stft(BA1,fs)
% title('Brandon: Go,Right,Left,Back')
% figure
% stft(SA1,fs)
% title('Stephanie: Go,Right,Left,Back')

%%%%%%%%%% Marianne Go
% figure
% stft(MG1,fs)
% title('Marianne, Go')

%%%%%%%%%% Stephanie Go, Right, Left, Back
% figure
% stft(SA1,fs)
% title('Stephanie Go, Right, Left, Back')

%%%%%%%%%% Brandon Go, Right, Left, Back
% figure
% stft(BA1,fs)
% title('Brandon Go, Right, Left, Back (1)')
% 
% figure
% stft(BA2,fs)
% title('Brandon Go, Right, Left, Back (2)')
% 
% figure
% stft(BA3,fs)
% title('Brandon Go, Right, Left, Back (3)')


%%%%%%%%%% Brandon Go's
% figure
% stft(BG1,fs)
% title('BG1')
% 
% figure
% stft(BG2,fs)
% title('BG2')
% 
% figure
% stft(BG3,fs)
% title('BG3')
% 
% figure
% stft(BG4,fs)
% title('BG4')
% 
% figure
% stft(BG5,fs)
% title('BG5')

%%%%%%%%%% Brandon Right's
% figure
% stft(BR1,fs)
% title('BR1')
% 
% figure
% stft(BR2,fs)
% title('BR2')
% 
% figure
% stft(BR3,fs)
% title('BR3')
% 
% figure
% stft(BR4,fs)
% title('BR4')
% 
% figure
% stft(BR5,fs)
% title('BR5')


%%%%%%%%%% Kory Go's
% figure
% stft(KG1,fs)
% title('KG1')
% 
% figure
% stft(KG2,fs)
% title('KG2')
% 
% figure
% stft(KG3,fs)
% title('KG3')
% 
% figure
% stft(KG4,fs)
% title('KG4')
% 
% figure
% stft(KG5,fs)
% title('KG5')

%%%%%%%%%% Kory Right's
% figure
% stft(KR1,fs)
% title('KR1')

% figure
% stft(KR2,fs)
% title('KR2')

% figure
% stft(KR3,fs)
% title('KR3')

% figure
% stft(KR4,fs)
% title('KR4')

% figure
% stft(KR5,fs)
% title('KR5')

%%%%%%%%%% Lowpass Filter (fc=5kHz) Example: Brandon "Go"
% [bg4F, dF] = lowpass(BG4, 5000, fs);
% figure
% stft(bg4F,fs)
% title('BG4 LP Filtered')