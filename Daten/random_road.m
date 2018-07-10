clear all
clc

global dr;
global L;
addpath 02_functions/
addpath 03_mats/

%% Parameter setting
dr = 0.01;
IRI_asphalt = 0.5;
IRI_uneven = 5;
auto = 1;
V = 30/3.6;
L = 100;
event = 'pothole'; % 'manhole';'cobbled';'railway';'unevenness';

%% random road
road = road_model(IRI_asphalt,IRI_uneven,V,event,'test',auto);
subplot(211)
plot(road(1,:))
subplot(212)
plot(road(2,:))

%% 4 road features
% pothole
h = 0.013; 
l = 0.2;
n = round(l/dr);
x1 = (0:n)*dr;
pothole = h/2*(cos(2*pi/n*(0:n))-1);

% manhole cover
h = 0.01;
l = 0.50;
n = round(l/dr);
x2 = (0:n)*dr;
manhole(1:n+1) = h*ones(1,n+1);
manhole(1:round(5*n/60)+1)=h/2*(1-cos(pi/round(5*n/60)*(0:round(5*n/60))));
manhole(round(55*n/60)+1:n+1)=h/2*(cos(pi/(n-round(55*n/60))*(0:n-round(55*n/60)))+1);

% cobbled road
h = 0.02;
l = 0.2; 
n = round(l/dr);
x3 = (0:5*n)*dr;
stone = h*ones(1,n);
stone(1:round(n/3)) = h/2*(1-cos(pi/(round(n/3))*(0:round(n/3)-1)));
stone(round(2*n/3)+1:n) = h/2*(1+cos(pi/(n-round(2*n/3))*(0:n-round(2*n/3)-1)));

z = 5;
for i = 0:z-1
    cobbled(1,n*i+1:n*(i+1)) = stone;
end
cobbled(z*length(stone)+1)=0;

% railway crossing
h = 0.10;
l = 1.6;
n = round(l/dr);
x4 = (0:n)*dr;

crack = h*zeros(1,n+1);
crack(1,1:round(n/20)+1) = h/2*(cos(2*pi/round(n/20)*(0:round(n/20)))-1);
crack(1,round(2*n/20):round(3*n/20))=h/2*(cos(2*pi/(round(3*n/20)-round(2*n/20))*(0:round(3*n/20)-round(2*n/20)))-1);
crack(1,round(17*n/20):round(18*n/20))=h/2*(cos(2*pi/(round(19*n/20)-round(18*n/20))*(0:round(19*n/20)-round(18*n/20)))-1);
crack(1,round(19*n/20)+1:n+1)=h/2*(cos(2*pi/(n-round(19*n/20))*(0:n-round(19*n/20)))-1);

figure
subplot(1,4,1)
plot(x1,pothole,'LineWidth',3)
xlabel('Laenge/[m]','FontSize',16)
ylabel('Hoehe/[m]','FontSize',16)
subplot(1,4,2)
plot(x2,manhole,'LineWidth',3)
xlabel('Laenge/[m]','FontSize',16)
subplot(1,4,3)
plot(x3,cobbled,'LineWidth',3)
xlabel('Laenge/[m]','FontSize',16)
subplot(1,4,4)
plot(x4,crack,'LineWidth',3)
xlabel('Laenge/[m]','FontSize',16)


%% write in txt
% print = [x1',pothole'];
% 
% fileID = fopen('pothole.txt','w');
% fprintf(fileID,'%1s %1s\r\n','r','h');
% fprintf(fileID,'%4.10f %4.10f\n',print');
% fclose(fileID);
% 
% print = [x2',manhole'];
% 
% fileID = fopen('manhole.txt','w');
% fprintf(fileID,'%1s %1s\r\n','r','h');
% fprintf(fileID,'%4.10f %4.10f\n',print');
% fclose(fileID);
% 
% print = [x3',cobbled'];
% 
% fileID = fopen('cobbled.txt','w');
% fprintf(fileID,'%1s %1s\r\n','r','h');
% fprintf(fileID,'%4.10f %4.10f\n',print');
% fclose(fileID);
% 
% print = [x1',-pothole'];
% 
% fileID = fopen('speed_bump.txt','w');
% fprintf(fileID,'%1s %1s\r\n','r','h');
% fprintf(fileID,'%4.10f %4.10f\n',print');
% fclose(fileID);
