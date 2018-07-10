function inty = maxBP (x, MinFreq, MaxFreq)

global dr;

fs = 1/dr;
W = 2/fs*[MinFreq, MaxFreq]; % normalized frequencies
[b,a] = butter(2,W,'bandpass'); % coefficients for the Butterworth filter
xm = [x(1)*ones(fs*fs,1);x]; % adding artificial constant signal for filter initialisation (peak avoidance)
ym = filter(b,a,xm); % filtered signal
y = ym(fs*fs+1:end); % removing the artificial signal

inty = max(y);

end