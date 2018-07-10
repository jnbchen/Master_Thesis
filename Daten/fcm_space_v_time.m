clear all
clc

addpath 02_functions/
addpath 03_mats/
global dr;
global L;

%% Setting
V = (30:10:60)/3.6;
auto = 1;
L = 10;
dr = 0.01;
dt = 0.01;
l = 0.6;
r = 0:dr:L;
k = 2;

road_l = zeros(4,1270);
road_l(1,300:300+(l/dr)) = k*0.005*(1-cos(2*pi/(l/dr)*(0:l/dr)));

color = [0 0 1;1 0 0;0.5 0.5 1;0 0 0;1 0.5 0];
x = length(V);
st_l = zeros(3,x);
st_t = zeros(3,x);

figure()
for i = 1:x

    t_l = r/V(i);
    t_t = 0:dt:L/V(i);

    road_t = zeros(4,round((L+1.345*2)/V(i)/dt));
    road_t(1,(3/V(i))/dt:((3+l)/V(i))/dt) = k*0.025*(1-cos(2*pi/(l/V(i)/dt)*(0:l/V(i)/dt)));

    % function output = FullCarModel(left,right,auto,type,load,V,a,b,c)
    output_l = FullCarModel(road_l(1,:),road_l(3,:),auto,0,0,V(i),0,0,0);
    output_t = FCM_passive_t(road_t(1:2,:),road_t(3:4,:),V(i),L,dt,0,0,0);

    st_l(1,i) = std(output_l(:,1));
    output_l(:,2) = cumtrapz(t_l,output_l(:,2));
    output_l(:,3) = cumtrapz(t_l,output_l(:,3));
    st_l(2,i) = std(output_l(:,2));
    st_l(3,i) = std(output_l(:,3));

    st_t(1,i) = std(output_t(:,1));
    output_t(:,2) = cumtrapz(t_t,output_t(:,2));
    output_t(:,3) = cumtrapz(t_t,output_t(:,3));
    st_t(2,i) = std(output_t(:,2));
    st_t(3,i) = std(output_t(:,3));

    subplot(321)
    plot(r,output_l(:,1),'color',color(i,:));
    hold on
    subplot(322)
    plot(t_t,output_t(:,1),'color',color(i,:));
    hold on
    subplot(323)
    plot(r,output_l(:,2),'color',color(i,:));
    hold on
    subplot(324)
    plot(t_t,output_t(:,2),'color',color(i,:));
    hold on
    subplot(325)
    plot(r,output_l(:,3),'color',color(i,:));
    hold on
    subplot(326)
    plot(t_t,output_t(:,3),'color',color(i,:));
    hold on
    legend('20','40','60','80','100')
end

% subplot(311)
% plot(r,100*road_l(1,270:1270),'g')
% xlabel('distance/[m]')
% ylabel('body acceleration/[m/s^2]')
% subplot(312)
% xlabel('distance/[m]')
% ylabel('pitch rate/[rad/s]')
% subplot(313)
% xlabel('distance/[m]')
% ylabel('roll rate/[rad/s]')
% legend('20','40','60','80','100','road')

figure()
subplot(321)
plot(V,st_l(1,:));
ylabel('std(vertical acceleration)/[m/s^2]')
subplot(322)
plot(V,st_t(1,:));
ylabel('std(pitch rate)/[rad/s]')
subplot(323)
plot(V,st_l(2,:));
ylabel('std(pitch rate)/[rad/s]')
subplot(324)
plot(V,st_t(2,:));
ylabel('std(pitch rate)/[rad/s]')
subplot(325)
plot(V,st_l(3,:));
xlabel('velocity/[m/s]')
ylabel('std(roll rate)/[rad/s]')
subplot(326)
plot(V,st_t(3,:));
xlabel('velocity/[m/s]')
ylabel('std(roll rate)/[rad/s]')