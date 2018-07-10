function road = road_model(IRI_asphalt,IRI_uneven,V,event,class,auto)

global L;
global dr;

%% road profile
load surface_200_auto1.mat;
Lf = 1.345; % initial Lf (auto1)
Lr = 1.345; % initial Lr (auto1)
y = [];
label = 1;
e = 1;

if auto == 2 % strcmp(auto,'S_Klasse_W220')
    load surface_200_auto2.mat;
    Lf=2.97/2;             % spacing from front to cg
    Lr=2.97/2;
elseif auto == 3 % strcmp(auto,'Sprinter')
    load surface_200_auto3.mat;
    Lf=3.67/2;             % spacing from front to cg
    Lr=3.67/2;
end

distance = 0:dr:L + Lf + Lr;
r0 = round((Lf+Lr)/dr);
N = length(distance);
road = zeros(3,N);
road(3,:) = ones(1,N);
interval = 20/dr;
p = round(N/interval); % number of events
q = 0:p-1; % insert event

if strcmp(class,'test')
    clear asphalt;
    x = 2*rand(3,p)+0.5; % random size of event
    asphalt = PSD(IRI_asphalt,L+Lf+Lr);
    uneven = PSD(IRI_uneven,5);
else
    x = ones(3,p);
    x(:,1:round(p/3)) = 0.5*ones(3,round(p/3));
    x(:,round(p/3)+1:round(2*p/3)) = ones(3,round(2*p/3)-round(p/3));
    x(:,round(2*p/3)+1:p) = 1.5*ones(3,p-round(2*p/3));
    load feature_uneven.mat;
end

for i = 1:p
    if strcmp(event,'pothole')
        if V <= 13
            K = 0.03*V;
        else
            K = 0.4;
        end
        h = K*x(1,i)*0.04;
        l = x(2,i)*0.70;
        n = round(l/dr);
        y(1,1:n+1) = h/2*(cos(2*pi/n*(0:n))-1);
        y(2,1:n+1) = zeros(1,n+1);
        label = 2;
        e = 2.5;
    elseif strcmp(event,'manhole')
        h = x(1,i)*0.015;
        l = 0.50;
        n = round(l/dr);
        y(1,:) = h*ones(1,n+1);
        y(2,:) = zeros(1,n+1);
        y(1,1:round(5*n/60)+1)=h/2*(1-cos(pi/round(5*n/60)*(0:round(5*n/60))));
        y(1,round(55*n/60):n)=h/2*(cos(pi/(n-round(55*n/60))*(0:n-round(55*n/60)))+1);
        K = 0.015*V;
        y = K*y;
        label = 3;
        e = 2;
    elseif strcmp(event,'cobbled')
        K = 0.04*V;
        h = K*x(1,i)*0.02;
        l = x(2,i)*0.2;
        long = 5;
        n = round(l/dr);
        nn = round(long/dr);
        stone = h/2*(cos(2*pi/(n-1)*(0:n-1)));
        
        z = floor(nn/n);
        c = 0.5; d = 1;
        koe = (d-c)*rand(2,z) + c;
        for m = 0:z-1
        y(1,n*m+1:n*(m+1)) = koe(1,m+1)*stone;
        y(2,n*m+1:n*(m+1)) = -koe(2,m+1)*stone;
        end          
        K = 0.08*V;     
        y = K*y;
        label = 4;
        e = 1.2;
    elseif strcmp(event,'railway')
        h = 0.10;
        l = 1.60;
        n = round(l/dr);
        crack = h*zeros(1,n+1);
        crack(1,1:round(n/20)+1) = h/2*(cos(2*pi/round(n/20)*(0:round(n/20)))-1);
        crack(1,round(2*n/20):round(3*n/20))=h/2*(cos(2*pi/(round(3*n/20)-round(2*n/20))*(0:round(3*n/20)-round(2*n/20)))-1);
        crack(1,round(3*n/20)+1:round(17*n/20)+2)=0;
        crack(1,round(17*n/20):round(18*n/20))=h/2*(cos(2*pi/(round(19*n/20)-round(18*n/20))*(0:round(19*n/20)-round(18*n/20)))-1);
        crack(1,round(19*n/20):n+1)=h/2*(cos(2*pi/(n+1-round(19*n/20))*(0:n+1-round(19*n/20)))-1);
        K = 0.02;
        y = K*[crack;crack];
        label = 5;
        e = 1.2;
    elseif strcmp(event,'unevenness')
        y = x(1,i)*uneven;
        label = 6;
        e = 1.2;
    end
    road(1:2,r0+interval*q(i)+1:r0+interval*q(i)+length(y)) = y;
    road(3,interval*q(i)+1:r0+interval*q(i)+round(e*length(y))) = label*ones(1,r0+round(e*length(y))); % labeling e times longer than the length of events
end

road(1:2,:)  = road(1:2,:) + asphalt;

%% Strassenprofile plotten
% figure()
% subplot(211)
%     plot(distance,road(1,:));
%     xlabel('Distance/[m]');
%     ylabel('height/[m]');
%     title('left road profile');
%     grid on
% 
% subplot(212)
%     plot(distance,road(2,:))
%     xlabel('Distance/[m]');
%     ylabel('height/[m]');
%     title('right road profile');
%     grid on
end