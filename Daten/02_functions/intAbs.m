function inty = intAbs(vek)

x = abs(vek - mean(vek));
a = [1 -0.999];    % a = 0,9
b = (1 + a(2)); % b = 1 - a -> y(k) = a*y(k-1) + b*x(k)
y = filter(b,a,x); % IIR-Filter for "Integration" (not the real value of the integral but equivalent feature) 
inty = y(end);

end

