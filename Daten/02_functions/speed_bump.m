function profile = road_model(L, dr, IRI, V, Profile, Side, auto)

switch auto
    case 1
        Lf=1.345;               % spacing from front to cg
        Lr=1.345;
    case 2
        Lf=2.965/2;             % spacing from front to cg
        Lr=2.965/2;
    otherwise
        Lf=3.665/2;             % spacing from front to cg
        Lr=3.665/2;
end

switch Profile
    case 1
        h = 0.005;
        b = 4*0.03;    % if the bump 4 times wider, the simulation is much better. It can be explained by the geometry of rigid roll contact.
    case 2
        h = 0.0105;
        b = 4*0.058;
    case 3
        h = 0.015;
        b = 4*0.07;
    case 4
        h = 0.0195;
        b = 4*0.045;
end

%% road profile
N=round(L/dr)+round((Lf+Lr)/dr);
distance=dr*(0:N);
road = zeros(2,N+1);
x = round(2*V/dr);
l = round(b/dr);
road(1,x:x+l) = h/2*(1-cos(2*pi/l*(0:l)));
e = pi/l*h*sin(2*pi/l*(0:round(l/2)));
road(2,x:x+round(l/2)) = sqrt(e.^2/(e.^2+1))*V;

% delta = round(b/dr);
% sample_x=1:13;
% sample_y=[0.0001 0.0025 0.5000 0.8600 0.9250 0.9750 1.0000 0.9750 0.9250 0.8600 0.5000 0.0025 0.0001];
% road(x:x+delta) = h*interp1(sample_x,sample_y,1:delta+1);

%% PSD
Gd_0_l=IRI*(10^-6);         % Classification according to ISO 
Gd_0_r=IRI*(10^-6); 
n0=1/(2*pi);
delta_n=1/L;
% spatial frequency band
Omega=delta_n*(0:N);  % Vektor
alpha = 2*pi*Omega; % Vektor
%PSD of road
% Gd=Gd_0.*(Omega./n0).^(-2);
m = round((1/(2*pi))/delta_n);
%random phases 
Psi_l=2*pi*randn(size(Omega)); % Vektor
Psi_r=2*pi*randn(size(Omega));

Amp_l(1:m) = 0;
Amp_r(1:m) = 0;
Amp_l(2:m) = sqrt((2*delta_n*Gd_0_l)*(n0./Omega(2:m)).^2);
Amp_r(2:m) = sqrt((2*delta_n*Gd_0_r)*(n0./Omega(2:m)).^2);
Amp_l(m+1:N+1)=sqrt((2*delta_n*Gd_0_l)*(n0./Omega(m+1:N+1)).^1.5); %Vektor, da Omega ein Vektor ist
Amp_r(m+1:N+1)=sqrt((2*delta_n*Gd_0_r)*(n0./Omega(m+1:N+1)).^1.5);

A_l = zeros(size(distance));
A_r = zeros(size(distance));

for i = 1:length(distance)
    A_r(i) = sum(Amp_r.*cos(alpha*distance(i)+Psi_r));% summiert alle array-elment auf
    A_l(i) = sum(Amp_l.*cos(alpha*distance(i)+Psi_l));% summiert alle array-elment auf
end

%% road sinal
if strcmp(Side,'left')
    road_l = road;
    road_r = zeros(2,N+1);
    road_l(1,:) = road_l(1,:) + A_l;
    road_r(1,:) = A_r;
elseif strcmp(Side,'right')
    road_l = zeros(2,N+1);
    road_r = road;
    road_l(1,:) = A_l;
    road_r(1,:) = road_r(1,:) + A_r;
else
    road_l = road;
    road_r = road;
    road_l(1,:) = road_l(1,:) + A_l;
    road_r(1,:) = road_r(1,:) + A_r;
end

profile(1:2,:) = road_l;
profile(3:4,:) = road_r;

%% Strassenprofile plotten

% figure(2)
% % Create subplot
% subplot(211)
%     plot(distance/V,road_l);
%     xlabel('Distanz [m]');
%     ylabel('H?he [m]');
%     title('Linkes Strassenprofil');
%     grid on
% 
% subplot(212)
%     plot(distance/V,road_r)
%     xlabel('Distance m');
%     ylabel('Elevation (m)');
%     title('Rechtes Strassenprofil');
%     grid on
% end