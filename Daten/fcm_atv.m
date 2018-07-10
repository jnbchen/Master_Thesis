clear all
clc

addpath 02_functions/
addpath 03_mats/

%% Parameter
V = 20/3.6;
L = 50;
auto = 3;
dr = 0.01;
r = 0:dr:L;

if auto == 1
    load road_profile1.mat;
elseif auto == 2
    load road_profile2.mat;
elseif auto == 3
    load road_profile3.mat;
end

% Q = 1e7*diag([100 50 20 10 20 10 2 5 2 5 4 10 4 10]);
Q = 1e6*diag([50 50 1 1 1 1 1 1 1 1 1 1 1 1]);
R = 1e-2*diag([1 1 2 2]);

%% simulation

% function output = FullCarModel(left,right,auto,type,load,V,a,b,c)
p1 = FCM_passive(road(1,:),road(2,:),V,L,auto,dr);
p2 = FCM_active_H8(road(1,:),road(2,:),V,L,auto,dr);
p3 = FCM_active_lqr(road(1,:),road(2,:),V,L,auto,dr,Q,R);

% print = [r',p1{1}(:,1),p2{1}(:,1),p1{1}(:,2),p2{1}(:,2),p1{1}(:,3),p2{1}(:,3)];
% 
% fileID = fopen('active_suspension_lqr.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s %1s %1s %1s\r\n','x','z1','z2','p1','p2','r1','r2');
% fprintf(fileID,'%4.10f %4.10f %4.10f %4.10f %4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

db = @(x) 20*log10(x);

apz = p1{2}; 
wpz = p1{4}; %xd
aaz = p2{2}; %v
waz = p2{4}; %x 
alz = p3{2}; %v
wlz = p3{4}; %x 
aaz = interp1(waz,aaz,wpz);
alz = interp1(wlz,alz,wpz);
apz = db(apz);
aaz = db(aaz);
alz = db(alz);

apr = p1{8}; 
wpr = p1{10}; %xd
aar = p2{8}; %v
war = p2{10}; %x 
alr = p3{8}; %v
wlr = p3{10}; %x 
aar = interp1(war,aar,wpr);
alr = interp1(wlr,alr,wpr);
apr = db(apr);
aar = db(aar);
alr = db(alr);

app = p1{5}; 
wpp = p1{7}; %xd
aap = p2{5}; %v
wap = p2{7}; %x 
alp = p3{5}; %v
wlp = p3{7}; %x 
aap = interp1(wap,aap,wpp);
alp = interp1(wlp,alp,wpp);
app = db(app);
aap = db(aap);
alp = db(alp);


%% plot
figure()
subplot(221)
plot(r,p1{1}(:,1),'b',r,p2{1}(:,1),'r',r,p3{1}(:,1),'k','LineWidth',2)
% xlabel('distance/[m]',FontSize',16)
ylabel('Hubbeschleunigung/[m/s^2]','FontSize',16)
title('Antwort von Hubbeschleunigung in Zeitraum','FontSize',16)

subplot(223)
plot(r,p1{1}(:,2),'b',r,p2{1}(:,2),'r',r,p3{1}(:,2),'k','LineWidth',2)
xlabel('Distanz/[m]','FontSize',16)
ylabel('Nickbeschleunigung/[rad/s^2]','FontSize',16)
title('Antwort von Nickbeschleunigung in Zeitraum','FontSize',16)

subplot(222)
plot(wpz,apz,'b',wpz,aaz,'r',wpz,alz,'k','LineWidth',2)
set(gca, 'XScale', 'log')
%xlabel('Frequenz/[Hz]',FontSize',16)
ylabel('Magnitude/[dB]','FontSize',16)
title('Antwort von Hubbeschleunigung in Frequenzraum','FontSize',16)

subplot(224)
plot(wpp,app,'b',wpp,aap,'r',wpp,alp,'k','LineWidth',2)
set(gca, 'XScale', 'log')
xlabel('Frequenz/[Hz]','FontSize',16)
ylabel('Magnitude/[dB]','FontSize',16)
title('Antwort von Nickbeschleunigung in Frequenzraum','FontSize',16)

legend({'passive','H_{infinity}','LQR'},'FontSize',16,'location','Southeast')


% subplot(313)
% plot(r,p1{1}(:,3),'b',r,p2{1}(:,3),'r',r,p3{1}(:,3),'k')
% xlabel('distance/[m]')
% ylabel('roll acceleration/[rad/s^2]')
% title('response with road profile 1')
% legend('passive','LQR','H_{inf}','location','Southeast')
% grid on


% figure()
% subplot(311)
% plot(wpz,apz,'b',wpz,aaz,'r',wpz,alz,'k')

% print = [wpz,20*log10(apz),20*log10(aaz)];
% 
% fileID = fopen('bode_active_susp_zl.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s\r\n','w','a1','a2');
% fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

% subplot(312)
% plot(wpr,apr,'b',wpr,aar,'r',wpr,alr,'k')

% print = [wpr,20*log10(apr),20*log10(aar)];
% 
% fileID = fopen('bode_active_susp_rl.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s\r\n','w','a1','a2');
% fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
% fclose(fileID);

% subplot(313)
% plot(wpp,app,'b',wpp,aap,'r',wpp,alp,'k')
% 
% print = [wpp,20*log10(app),20*log10(aap)];
% 
% fileID = fopen('bode_active_susp_pl.txt','w');
% fprintf(fileID,'%1s %1s %1s %1s\r\n','w','a1','a2');
% fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
% fclose(fileID);
