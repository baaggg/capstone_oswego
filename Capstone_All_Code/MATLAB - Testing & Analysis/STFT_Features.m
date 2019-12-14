close all
clc

%%%%% Importing wav files (fs is always 48,000Hz)
% % Brandon Go
% [BG1, ~] = audioread('BG_go1.wav'); 
% [BG2, ~] = audioread('BG_go2.wav');
% [BG3, ~] = audioread('BG_go3.wav');
% [BG4, ~] = audioread('BG_go4.wav');
% [BG5, ~] = audioread('BG_go5.wav');
% [BG6, ~] = audioread('BG_go6.wav'); 
% [BG7, ~] = audioread('BG_go7.wav');
% [BG8, ~] = audioread('BG_go8.wav');
% [BG9, ~] = audioread('BG_go9.wav');
% [BG10, ~] = audioread('BG_go10.wav');
% % Brandon Right
% [BR1, ~] = audioread('BG_right1.wav'); 
% [BR2, ~] = audioread('BG_right2.wav');
% [BR3, ~] = audioread('BG_right3.wav');
% [BR4, ~] = audioread('BG_right4.wav');
% [BR5, ~] = audioread('BG_right5.wav');
% [BR6, ~] = audioread('BG_right6.wav'); 
% [BR7, ~] = audioread('BG_right7.wav');
% [BR8, ~] = audioread('BG_right8.wav');
% [BR9, ~] = audioread('BG_right9.wav');
% [BR10, ~] = audioread('BG_right10.wav');
% % Brandon Left
% [BL1, ~] = audioread('BG_left1.wav'); 
% [BL2, ~] = audioread('BG_left2.wav');
% [BL3, ~] = audioread('BG_left3.wav');
% [BL4, ~] = audioread('BG_left4.wav');
% [BL5, ~] = audioread('BG_left5.wav');
% [BL6, ~] = audioread('BG_left6.wav'); 
% [BL7, ~] = audioread('BG_left7.wav');
% [BL8, ~] = audioread('BG_left8.wav');
% [BL9, ~] = audioread('BG_left9.wav');
% [BL10, ~] = audioread('BG_left10.wav');
% % Brandon Back
% [BB1, ~] = audioread('BG_back1.wav'); 
% [BB2, ~] = audioread('BG_back2.wav');
% [BB3, ~] = audioread('BG_back3.wav');
% [BB4, ~] = audioread('BG_back4.wav');
% [BB5, ~] = audioread('BG_back5.wav');
% [BB6, ~] = audioread('BG_back6.wav'); 
% [BB7, ~] = audioread('BG_back7.wav');
% [BB8, ~] = audioread('BG_back8.wav');
% [BB9, ~] = audioread('BG_back9.wav');
% [BB10, ~] = audioread('BG_back10.wav');

fs = 48000;
ds = 16000;

% word  = BG6;
% word = normalize432(word);
% newDS = downsample(word,3);
% [STFT1, F, T] = stft(newDS, ds);
% STFT1 = abs(STFT1);
% word2 = BB10;
% word2 = normalize432(word2);
% newDS2 = downsample(word2,3);
% [STFT2, F, T] = stft(newDS2, ds);
% STFT2 = abs(STFT2);
% 
% chunk1 = STFT1(72:73, 1:length(T));
% sv1 = max(chunk1, [], 1); % freq=1 / time=2
% 
% chunk2 = STFT1(74:75, 1:length(T));
% sv2 = max(chunk2, [], 1); % freq=1 / time=2

% figure
% plot(T, sv1)
% title('Top')
% figure
% plot(T, sv2)
% title('Bottom')
% figure('Position', [50 50 500 300])
% stft(newDS, ds)
% title('Left')
% figure('Position', [50 50 500 300])
% stft(newDS2, ds)
% title('Back')


% % word3 = BL2;
% % word3 = normalize432(word3);
% % newDS3 = downsample(word3,3);

% % word4 = BB9;
% % word4 = normalize432(word4);
% % newDS4 = downsample(word4,3);
%
% [STFT1, F1, T1] = stft(newDS, ds);
% cut1 = STFT1(72:76 , 1:length(T1));
% cut1 = abs(cut1);
% GO = sum(sum(cut1));
% 
% [STFT2, F2, T2] = stft(newDS2, ds);
% cut2 = STFT2(72:76 , 1:length(T2));
% cut2 = abs(cut2);
% RIGHT = sum(sum(cut2));
% 
% [STFT3, F3, T3] = stft(newDS3, ds);
% cut3 = STFT3(64:68 , 1:length(T3));
% cut3 = abs(cut3);
% LEFT = sum(sum(cut3));
% 
% [STFT4, F4, T4] = stft(newDS4, ds);
% cut4 = STFT4(64:68 , 1:length(T4));
% cut4 = abs(cut4);
% BACK = sum(sum(cut4));
% 
% figure('Position', [50 50 500 300])
% stft(newDS, ds)
% title('Left')
% 
% figure('Position', [50 50 500 300])
% stft(newDS2, ds)
% title('Back')
% 
% figure('Position', [50 50 500 300])
% stft(newDS3, ds)
% title('Left')
% 
% figure('Position', [50 50 500 300])
% stft(newDS, ds)
% title('Back')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Always Listening idek anymore
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pause(2)
recObj = audiorecorder(fs, 16, 1);
disp('Talk now')
recordblocking(recObj, 2);
disp('Done recording...')
data = getaudiodata(recObj);

word  = data;
word = normalize432(word);
newDS = decimate(word, 3);

figure('Position', [50 50 750 450])
stft(newDS, ds)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Looking at "Dixie"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [data, ~] = audioread('BG_go4.wav'); 
% word  = data;
% word = normalize432(word);
% newDS = downsample(word,3);
% [STFT1, F1, T1] = stft(word, fs);
% STFT1 = abs(STFT1);
% SV1 = max(abs(STFT1), [], 2);
% [~, locs1] = findpeaks(SV1);
% maxes1 = F1(locs1);
% maxes1 = maxes1(maxes1>=0);
% maxes1 = maxes1(1:5);
% 
% [data2, ~] = audioread('BG_right2.wav'); 
% word2  = data2;
% word2 = normalize432(word2);
% newDS2 = downsample(word2,3);
% [STFT2, F2, T2] = stft(word2, fs);
% STFT2 = abs(STFT2);
% SV2 = max(abs(STFT2), [], 2);
% [~, locs2] = findpeaks(SV2);
% maxes2 = F2(locs2);
% maxes2 = maxes2(maxes2>=0);
% maxes2 = maxes2(1:5);
% 
% figure
% stft(newDS, ds)
% figure
% stft(newDS2, ds)

% [data3, ~] = audioread('BG_dixie3.wav'); 
% word3  = data3;
% word3 = normalize432(word3);
% newDS3 = downsample(word3,3);
% % [STFT3, F3, T3] = stft(word3, fs);
% % SV3 = max(abs(STFT3), [], 2);
% % [~, locs3] = findpeaks(SV3);
% % maxes3 = F3(locs3);
% % maxes3 = maxes3(maxes3>=0);
% % maxes3 = maxes3(1:10)
% 
% figure
% stft(word, fs)
% figure
% stft(word2, fs)
% figure
% stft(word3, fs)