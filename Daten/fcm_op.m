clear all
clc

%% Parameter
global L;
global dr;
addpath 02_functions/
addpath 03_mats/

V = 20/3.6;
L = 10;
auto = 1;

if auto == 1
    load road_profile1.mat;
elseif auto == 2 % strcmp(auto,'S_Klasse_W220')
    load road_profile2.mat;
elseif auto == 3 % strcmp(auto,'Sprinter')
    load road_profile3.mat;
end

dr = 0.01;
r = 0:dr:L;
%% simulation

%function output = FullCarModel(left,right,auto,type,load,V,a,b,c)
p1 = FullCarModel(road(1,:),road(2,:),auto,0,0,V,0,0,0); %S1 cg
p2 = FullCarModel(road(1,:),road(2,:),auto,0,0,V,1,0,0); %S2 front-mid
p3 = FullCarModel(road(1,:),road(2,:),auto,0,0,V,0,1,0); %S3 left-mid
p4 = FullCarModel(road(1,:),road(2,:),auto,0,0,V,1,1,0); %S4 front-left

%% FFT
data = [p1(:,1) p2(:,1) p3(:,1) p4(:,1)];
N = length(p1(:,1));
Fs = 1/dr;

if mod(N,2) == 1
        N = N-1;
end
f = Fs*(0:(N/2))/N;
y = zeros(501,4);

figure
for i = 1:4
    xdft = fft(data(:,i));
    xdft = xdft(1:N/2+1);
    y(:,i) = (1/(Fs*N)) * abs(xdft).^2;
    y(2:end-1,i) = 2*y(2:end-1,i);
    subplot(4,1,i)
    plot(f,y(:,i))
end

%% plot
figure
plot(r,p1(:,1),'b',r,p2(:,1),'r',r,p3(:,1),'k',r,p4(:,1),'g')
ylabel('a_z/[m/s^2]')
xlabel('distance/[m]')
ylabel('roll acceleration/[rad/s^2]')
title('response with road profile 1')
legend('center of gravity','front-middle','left-middle','front-left')
grid on



% print = [r',p1(:,1),p2(:,1),p3(:,1),p4(:,1)];
% 
% fileID = fopen('position_of_output.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s %1s\r\n','x','y1','y2','y3','y4');
% fprintf(fileID,'%4.10f %4.10f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);
% 
% print = [f',y(:,1),y(:,2),y(:,3),y(:,4)];
% 
% fileID = fopen('position_of_output_f.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s %1s\r\n','f','y1','y2','y3','y4');
% fprintf(fileID,'%4.10f %4.10f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

