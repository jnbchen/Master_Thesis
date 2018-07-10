function psdx = ft(x)

global dr;

N = length(x);
Fs = 1/dr;

if mod(N,2) == 1
        N = N-1;
end

xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);

end
