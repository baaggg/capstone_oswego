function y = ZCR(x)
%%%%% Function to calculate the Zero Crossing Rate of a signal
y = sum(abs(diff(x>0)))/length(x);
end