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
dr = 0.01;
r = 0:dr:L;

if auto == 1
    load road_profile1.mat;
elseif auto == 2 % strcmp(auto,'S_Klasse_W220')
    load road_profile2.mat;
elseif auto == 3 % strcmp(auto,'Sprinter')
    load road_profile3.mat;
end

%% simulation
p1 = FullCarModel(road(1,:),road(2,:),auto,0,0,V,0,0,0);
p2 = FCM_passive_tf(road(1,:),road(2,:),V,L,auto,dr);
czz = mscohere(p1(:,1),p2(:,1));
cpp = mscohere(p1(:,2),p2(:,2));
crr = mscohere(p1(:,3),p2(:,3));

%% plot
figure()
subplot(221)
plot(r,p1(:,1),'b',r,p2(:,1),'r')
xlabel('distance/[m]')
ylabel('a_z/[m/s^2]')
title('response with road profile 1')
grid on
subplot(222)
plot(czz)
grid on
subplot(223)
plot(r,p1(:,3)/180*pi,'b',r,p2(:,3)/180*pi,'r')
xlabel('distance/[m]')
ylabel('pitch acceleration/[rad/s^2]')
title('response with road profile 1')
legend('MISO structure','SISO structure','location','Southeast')
grid on
subplot(224)
plot(crr)
grid on

load workspace.mat;

figure()
h = ss(A,B,C,D);
bodeplot(h(1:3,:))
grid on

[a,p,w] = bode(h(1,1));
phase(:,1) = w;


for i = 1:4
    [a1,p1,w1] = bode(h(1,i));
    p1 = squeeze(p1);
    p1 = interp1(w1,p1,w);
    phase(:,i+1) = p1;
    
    [a2,p2,w2] = bode(h(2,i));
    p2 = squeeze(p2);
    p2 = interp1(w2,p2,w);
    phase(:,i+5) = p2;
    
    [a3,p3,w3] = bode(h(3,i));
    p3 = squeeze(p3);
    p3 = interp1(w3,p3,w);
    phase(:,i+9) = p3;
end

% print = [phase(:,1),phase(:,2),phase(:,3),phase(:,4),phase(:,5),phase(:,6),...
%     phase(:,7),phase(:,8),phase(:,9),phase(:,10),phase(:,11),phase(:,12),phase(:,13)];
% fileID = fopen('phase_tf.txt','w');
% 
% fprintf(fileID,'%1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s %1s\r\n','f','p1','p2','p3','p4','p5','p6','p7','p8','p9','p10','p11','p12');
% fprintf(fileID,'%4.0f %4.10f %4.10f %4.10f %4.0f %4.10f %4.10f %4.10f %4.0f %4.10f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

% print = [[1:length(crr)]',czz,crr,cpp];
% 
% fileID = fopen('transfer_function.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s\r\n','x','z1','z2','z3');
% fprintf(fileID,'%4.0f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);