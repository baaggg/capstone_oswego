close all
clc

%%%%% Importing wav files (fs is always 48,000Hz)
fs = 48000;

%%%%% Brandon Go1, Right1, Left1, Back1
% Go
Go = normalize432(BG1); %3600 28000
test1 = Go([3600:28000]);
noise1 = ZCR(test1)
[~, gS] = FindSignalStart(Go);
[~, gE] = FindSignalEnd(Go);
Go = Go( [ gS : gE ] );
figure
plot(Go)
title('Go')

% Right
Right = normalize432(BR1); % 1600 28000
test2 = Right([1600:28000]);
noise2 = ZCR(test2)
[~, rS] = FindSignalStart(Right);
[~, rE] = FindSignalEnd(Right);
Right = Right( [ rS : rE ] );
figure
plot(Right)
title('Right')

% Left 
Left = normalize432(BL1); % 2000 29000
test3 = Left([2000:29000]);
noise3 = ZCR(test3)
[~, lS] = FindSignalStart(Left);
[~, lE] = FindSignalEnd(Left);
Left = Left( [ lS : lE ] );
figure
plot(Left)
title('Left')

% Back
Back = normalize432(BB1); % 500 21000
test4 = Back([500:21000]);
noise4 = ZCR(test4)
[~, bS] = FindSignalStart(Back);
[~, bE] = FindSignalEnd(Back);
Back = Back( [ bS : bE ] );
figure
plot(Back)
title('Back')

% Zero Crossing Rates of words without
% beginning and end noise
goZCR = ZCR(Go)
rightZCR = ZCR(Right)
leftZCR = ZCR(Left)
backZCR = ZCR(Back)

%%%%% Results:
%%%%% Go, Right, Left, Back
% goZCR =
%     0.0238
% rightZCR =
%     0.0255
% leftZCR =
%     0.0287
% backZCR =
%     0.0378