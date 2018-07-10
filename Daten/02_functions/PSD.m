function Amplitude = PSD(IRI,L)

global dr;

distance = 0:dr:L;
N = length(distance);
Gd_0=IRI*(10^-6); % Classification according to ISO 
n0=1/(2*pi);
delta_n=1/L;
% spatial frequency band
Omega=delta_n*(0:N-1);  % Vektor
alpha = 2*pi*Omega; % Vektor
%PSD of road
% Gd=Gd_0.*(Omega./n0).^(-2);
m = round((1/(2*pi))/delta_n);
%random phases 
Psi_l=2*pi*randn(size(Omega)); % Vektor
Psi_r=2*pi*randn(size(Omega));

Amp(1) = 0;
Amp(2:m) = sqrt((2*delta_n*Gd_0)*(n0./Omega(2:m)).^2);
Amp(m+1:N)=sqrt((2*delta_n*Gd_0)*(n0./Omega(m+1:N)).^1.5); %Vektor, da Omega ein Vektor ist

Amplitude = zeros(2,N);

for i = 1:N
    Amplitude(1,i) = sum(Amp.*cos(alpha*distance(i)+Psi_l));% summiert alle array-elment auf
    Amplitude(2,i) = sum(Amp.*cos(alpha*distance(i)+Psi_r));% summiert alle array-elment auf
end

end