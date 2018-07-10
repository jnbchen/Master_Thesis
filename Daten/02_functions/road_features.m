function profile = road_model(a,b,type,V)

global dr;
global L;
global distance;
global asphalt;
global uneven;


%% road profile
N = length(distance);
road = zeros(4,N);
r0 = round((distance(end)-L)/dr); % begining of the obstacle is set at the front axle
l = 0;

if strcmp(type,'pothole')
    if V <= 13
        K = 0.03*V;
    else
        K = 0.4;
    end
    h = K*a*0.04; 
    l = b*0.7;
    n = round(l/dr);
    road(1,r0:r0+n) = h/2*(cos(2*pi/n*(0:n))-1);
%    road(3,r0:r0+n) = h/2*(cos(2*pi/n*(0:n))-1);
%     e = -K*h*pi/n*sin(2*pi/n*(n/2:n));
%     road(2,r0+round(n/2):r0+n) = sqrt(e.^2/(e.^2+1))*V;
elseif strcmp(type,'manhole')
    h = a*0.01;
    l = b*0.50;
    n = round(l/dr);
    road(1,r0:r0+n) = h*ones(1,n+1);
    road(1,r0:r0+round(5*n/60))=h/2*(1-cos(pi/round(5*n/60)*(0:round(5*n/60))));
    road(1,r0+round(55*n/60):r0+n)=h/2*(cos(pi/(n-round(55*n/60))*(0:n-round(55*n/60)))+1);
    K = 0.015*V;
    road(1,:) = K*road(1,:);
%    road(3,:) = K*road(1,:);
%     e = K*h/2*pi/round(5*n/60)*sin(pi/round(5*n/60)*(0:round(5*n/60)));
%     road(2,r0:r0+round(5*n/60)) = sqrt(e.^2/(1-e.^2))*V;
elseif strcmp(type,'cobbled')
    K = 0.04*V;
    h = a*K*0.02;
    l = b*0.2; 
    n = round(l/dr);
    stone1(1:n) = h/2*(0.5-cos(2*pi/(n-1)*(0:n-1)));
    stone2(1:n) = h/2*(cos(2*pi/(n-1)*(0:n-1))+1.5);
    z = floor(N/n);
    koe = rand(2,z);
    for i = 0:z-1
        road(1,n*i+1:n*(i+1)) = koe(1,i+1)*stone1;
        road(3,n*i+1:n*(i+1)) = koe(2,i+1)*stone2;
    end
    
elseif strcmp(type,'railway')
    K = 0.02;
    h = K*0.10;
    l = 1.60;
    n = round(l/dr);
    
    crack = K*h*ones(1,n+1);
    crack(1,1:round(n/20)+1) = h/2*(cos(2*pi/round(n/20)*(0:round(n/20)))-1);
    crack(1,round(2*n/20):round(3*n/20))=h/2*(cos(2*pi/(round(3*n/20)-round(2*n/20))*(0:round(3*n/20)-round(2*n/20)))-1);
    crack(1,round(3*n/20)+1:round(18*n/20)+2)=0;
    crack(1,round(18*n/20):round(19*n/20))=h/2*(cos(2*pi/(round(19*n/20)-round(18*n/20))*(0:round(19*n/20)-round(18*n/20)))-1);
    crack(1,round(19*n/20):n+1)=h/2*(cos(2*pi/(n+1-round(19*n/20))*(0:n+1-round(19*n/20)))-1);
    
%     k = 1.2;
%     e = -h*pi/round(n/20)*sin(2*pi/round(n/20)*(round(n/40):round(n/20)));
%     crack(2,round(n/40):round(n/20)) = k*sqrt(e.^2/(1-e.^2))*V;
%     crack(2,round(5*n/40):round(3*n/20)) = k*sqrt(e.^2/(1-e.^2))*V;
%     crack(2,round(37*n/40):round(19*n/20)) = k*sqrt(e.^2/(1-e.^2))*V;
%     crack(2,round(39*n/40):n) = k*sqrt(e.^2/(1-e.^2))*V;
    
    road([1 3],r0:r0+n) = [crack;crack];
%     road([1 3],r0+round(9*n/10):r0+n) = [K*crack;K*crack];
    
elseif strcmp(type,'unevenness')
    road([1 3],:) = uneven - asphalt;
end

road([1 3],:)  = road([1 3],:) + asphalt;

% Fs = 1/dr;
% W = Fst/Fs/2; % greater than 25Hz cut
% [b,a] = butter(1,W);
% road(1,:) = filter(b,a,road(1,:)); 
% road(2,:) = filter(b,a,road(2,:));

profile{1} = road; % input of left
profile{2} = [r0;l]; % record begin and end point of the event

%% Strassenprofile plotten

% figure(2)
% % Create subplot
% subplot(211)
%     plot(distance,profile{1}(1,:));
%     xlabel('Distanz [m]');
%     ylabel('H?he [m]');
%     title('Linkes Strassenprofil');
%     grid on
% 
% subplot(212)
%     plot(distance,profile{1}(2,:))
%     xlabel('Distance m');
%     ylabel('Elevation (m)');
%     title('Rechtes Strassenprofil');
%     grid on
end