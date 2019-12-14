function [y] = normalize432(x)
check = sum(sum(x));

y = x./max(abs(x));

if check==0 % Is Matrix all 0s?
    y = []
end
    
end