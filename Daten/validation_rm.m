clear all
clc

global dr;
global L;
global distance;
%global asphalt;
global uneven;
load asphalt.mat;
%load uneven.mat;
addpath 02_functions/
addpath 03_mats/

Lf = 1.345;               
Lr = 1.345;
L = 100;
dr = 0.01;
distance = 0:dr:L + Lf + Lr;
% asphalt = PSD(0.2,L + Lf + Lr);
uneven = PSD(8,L + Lf + Lr);
V = (30:10:60)/3.6;
coe = [1 1; 0.95 1.05; 1 1.05]; % different height/length of obstacles
events = {'asphalt';'railway';'manhole';'cobbled';'pothole';'unevenness'};

stdz = zeros(length(events),length(V),size(coe,1));
stdp = stdz;
stdr = stdz;

mean_stdz = zeros(length(events),length(V));
mean_stdp = mean_stdz;
mean_stdr = mean_stdz;

err_stdz = mean_stdz;
err_stdp = mean_stdz;
err_stdr = mean_stdz;

marker = {'-o';':s';':^';'--d';'-.x';'-.p'};
color = [0 0 1;1 0 0;1 0 0.4;0 0 0;0 0 0.5;0.5 0.5 1];
title = {'std(vertical acceleration)/[m/s^2]'; 'std(pitch rate)/[rad/s]';...
    'std(roll rate)/[rad/s]'};

for i = 1:length(events)
    for j = 1:length(V)
        for p = 1:size(coe,1)
            road = road_features(coe(p,1),coe(p,2),events(i),V(j));
            y = FCM_passive_output(road{1}(1:2,:),road{1}(3:4,:),V(j),0,0,0); % output at cg
            if i == 2||i == 3||i == 5 %/'manhole'/'pothole'/'railway'
                e = (3.6*V(j)-20)/50+1.5; % range of event is relative to velocity
                r = 1:(road{2}(1)+e*road{2}(2)/dr); % range of event from front axle untill rear axle
            else % 'cobbled'/'unevenness'/'asphalt'
                r = 1:(L/dr+1); % entrie range
            end
            t = dr/V(j)*r;
            yz = y(r,1); % ddz
            yp = y(r,2); % ddp
            yp = cumtrapz(t,yp); % dp
            yr = y(r,3); % ddr
            yr = cumtrapz(t,yr); % dr
            stdz(i,j,p) = std(yz); % std(dz) of pst weight
            stdp(i,j,p) = std(yp);
            stdr(i,j,p) = std(yr);
        end
        mean_stdz(i,j) = mean(stdz(i,j,:)); % mean(std(dz)) of ist event and jst V
        mean_stdp(i,j) = mean(stdp(i,j,:));
        mean_stdr(i,j) = mean(stdr(i,j,:));
        
        err_stdz(i,j) = std(stdz(i,j,:)); % std(std(dz)) of ist event and jst V
        err_stdp(i,j) = std(stdp(i,j,:));
        err_stdr(i,j) = std(stdr(i,j,:));
    end
%     figure()
%     subplot(211)
%     plot(road{1}(1,:))
%     subplot(212)
%     plot(road{1}(3,:))
end

mean_std(:,:,1) = mean_stdz; % mean(std) of ddz, dp, dr
mean_std(:,:,2) = mean_stdp;
mean_std(:,:,3) = mean_stdr;

err_std(:,:,1) = err_stdz; % std(std) of ddz, dp, dr
err_std(:,:,2) = err_stdp;
err_std(:,:,3) = err_stdr;

for j = 1:length(title)
    figure(6+j)
    for i = 1:length(events)
        errorbar(V,mean_std(i,:,j),err_std(i,:,j),marker{i},'Color',color(i,:));
        hold on
    end
    xlabel('Velocity/[m/s]')
    ylabel(title(j))
    legend('asphalt','railway','manhole','cobbled','pothole','unevenness')
end

% print = [V',mean_stdr(1,:)',mean_stdr(2,:)',mean_stdr(3,:)',mean_stdr(4,:)',mean_stdr(5,:)',mean_stdr(6,:)',...
%     err_stdr(1,:)',err_stdr(2,:)',err_stdr(3,:)',err_stdr(4,:)',err_stdr(5,:)',err_stdr(6,:)'];
% fileID = fopen('ddr_obstacles_velocity.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s\r\n','v','m1','m2','m3','m4','m5','m6','e1','e2','e3','e4','e5','e6');
% fprintf(fileID,'%4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);
% 
% print = [V',mean_stdz(1,:)',mean_stdz(2,:)',mean_stdz(3,:)',mean_stdz(4,:)',mean_stdz(5,:)',mean_stdz(6,:)',...
%     err_stdz(1,:)',err_stdz(2,:)',err_stdz(3,:)',err_stdz(4,:)',err_stdz(5,:)',err_stdz(6,:)'];
% fileID = fopen('ddz_obstacles_velocity.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s\r\n','v','m1','m2','m3','m4','m5','m6','e1','e2','e3','e4','e5','e6');
% fprintf(fileID,'%4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

% print = [V',mean_stdp(1,:)',mean_stdp(2,:)',mean_stdp(3,:)',mean_stdp(4,:)',mean_stdp(5,:)',mean_stdp(6,:)',...
%     err_stdp(1,:)',err_stdp(2,:)',err_stdp(3,:)',err_stdp(4,:)',err_stdp(5,:)',err_stdp(6,:)'];
% fileID = fopen('ddp_obstacles_velocity.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s\r\n','v','m1','m2','m3','m4','m5','m6','e1','e2','e3','e4','e5','e6');
% fprintf(fileID,'%4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);
