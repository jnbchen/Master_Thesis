function c = speccentroid(x)

global dr;

Fs = 1/dr;
L = length(x);
n = 2^nextpow2(L);
y = fft(x,n);
f = Fs*(0:(n/2))/n;
p = abs(y/n);
a = 0;
b = 0;
for i = 1:(n/2+1)
    a = a + f(i)*p(i);
    b = b + p(i);
end
c = a/b;

end