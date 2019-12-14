function [y, index] = FindSignalEnd(x)

x_flip = flipud(x); % Change [start:end] to [end:start]

% Calcs end because start is flipped
% y_end is index of final non-zero value in signal
[y_flip, y_end] = FindSignalStart(x_flip);

y_fix = flipud(y_flip); % Flip again to fix orientation

N = length(x);

y = y_fix;
index = N-(y_end); % 8000 - "Start" = End index

end

