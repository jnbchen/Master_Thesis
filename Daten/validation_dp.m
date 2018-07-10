clear all
clc

%% Parameter
global L;
global dr;
addpath 02_functions/
addpath 03_mats/

V = 20/3.6-0.5;
L = 4*V; % 4 sec
auto = 1;
dr = 0.01;
dt = dr/V;
IRI = 1;
Profile = 3; % P1/P2/P3/P4
Side = 'left'; % left/right/both
g = 9.81;

%% simulation
% load speedbump.mat;
road = speed_bump(L, dr, IRI, V, Profile, Side, auto);
p = FullCarModel(road(1,:),road(3,:),auto,0,0,V,-1,0,0); % rear-mid

%% Plot
t = 0:dt:4;
z0 = p(:,7)/g+1;
z1 = p(:,6)/g+1;
z2 = p(:,1)/g+1;
xgyro = cumtrapz(t,p(:,3));
ygyro = -cumtrapz(t,p(:,2));
xgyro = awgn(xgyro,50,'measured');
ygyro = awgn(ygyro,50,'measured');
CreateFigure(t,z0,z1,z2,xgyro,ygyro)

t = t(666:1271);
z0 = p(666:1271,7)/g+1;
z1 = p(666:1271,6)/g+1;
z2 = p(666:1271,1)/g+1;
xgyro = cumtrapz(t,p(666:1271,3));
ygyro = -cumtrapz(t,p(666:1271,2));
xgyro = awgn(xgyro,50,'measured');
ygyro = awgn(ygyro,50,'measured');

% print = [t',z2,xgyro];
% fileID = fopen('validation_measure_data.txt','w');
% fprintf(fileID,'%1s %1s %1s \r\n','t','z','r');
% fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

% print = [t',ygyro];
% fileID = fopen('validation_measure_p.txt','w');
% fprintf(fileID,'%1s %1s \r\n','t','p');
% fprintf(fileID,'%4.10f %4.10f\n',print');
% fclose(fileID);

