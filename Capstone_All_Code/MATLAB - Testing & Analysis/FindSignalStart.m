function [y, index] = FindSignalStart(x)
N = length(x);
xn = normalize432(x);
xP = (xn).^2; % power signal

M = 1000;
rect = ones(M,1);
xP = conv(xP, rect,'same');
xP = normalize432(xP);
Threshold = 0.08;

index = find(xP > Threshold, 1);

y = x([index : end]);

end