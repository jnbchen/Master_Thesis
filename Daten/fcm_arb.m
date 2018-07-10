clear all
clc

%% Parameter
addpath 02_functions/
addpath 03_mats/
load road_profile1.mat;

V = 20/3.6;
L = 10;
auto = 1;
dr = 0.01;
r = 0:dr:L;
%% simulation

p1 = FCM_passive(road(1,:),road(2,:),V,L,auto,dr);
p2 = FCM_anti_roll_bar(road(1,:),road(2,:),V,L,auto,dr);

%% plot

a1 = p1{2}; 
w1 = p1{4}; %xd
a2 = p2{2}; %v
w2 = p2{4}; %x 
a2 = interp1(w2,a2,w1);

a1 = 20*log10(a1);
a2 = 20*log10(a2);

figure
subplot(1,2,2)
plot(w1,a1,'b',w1,a2,'r','LineWidth',2)
set(gca, 'XScale', 'log')
xlabel('Frequenz/[Hz]','FontSize',16)
ylabel('Magnitude/[dB]','FontSize',16)
title('Antwort in Frequenzraum','FontSize',16)
subplot(1,2,1)
plot(r,p1{1}(:,3),'b',r,p2{1}(:,3),'r','LineWidth',2)
xlabel('Distanz/[m]','FontSize',16)
ylabel('roll acceleration/[rad/s^2]','FontSize',16)
title('Antwort in Zeitraum','FontSize',16)
legend({'ohne Stabilisator','mit Stabilisator'},'FontSize',16,'location','Southeast')


% figure()
% plot(w1,a1,'b',w1,a2,'r')


% print = [r',p1{1}(:,3),p2{1}(:,3)];
% 
% fileID = fopen('anti_roll_bar_time_domain.txt','w');
% fprintf(fileID,'%1s %1s %1s\r\n','x','y1','y2');
% fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

% print = [w1,20*log10(a1),20*log10(a2)];
% 
% fileID = fopen('bode_plot.txt','w');
% fprintf(fileID,'%1s %1s %1s\r\n','w','a1','a2');
% fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

