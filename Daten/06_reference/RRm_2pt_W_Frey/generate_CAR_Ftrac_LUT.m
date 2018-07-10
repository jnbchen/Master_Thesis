% **************************************
% ******* GENERATE CAR FTRAC LUT *******
% **************************************
% generate_CAR_Ftrac_LUT 16 Mar 07
% generates 3 Fx=fcn(Fz, slip G)
% clear
% format short
% format compact
% ----------Input data For low vertical load Fz ----------------
disp(' ')
disp('Generating Fx as Fcn(Fz, Percent Slip)');
B=80; C=1.7; D=1; E=0.97;
for i = 1:1:201;
G(i) = (i-101)/100;
mu_lo_Fz(i) = -D*sin(C*atan(B*G(i)-E*(B*G(i)-atan(B*G(i)))));
end;
close all;
% Plot the 1st results
% figure
z = [G', mu_lo_Fz'];
plot(z(:,1),z(:,2),'r')
title('Mu vs Percent Longitudinal Slip and Fz',...
'FontWeight','bold')
xlabel('Longitdinal Slip G')
ylabel('Longitudinal Mu (Fx/Fz)')
% legend('accel', 'vel','position')
grid on
hold on
% ---Generate the second curve for Medium vertical load Fz --------
B=20; C=2.0; D=1; E=0.99;
for i = 1:1:201;
G(i) = (i-101)/100;
mu_med_Fz(i) = -D*sin(C*atan(B*G(i)-E*(B*G(i)-atan(B*G(i)))));
end;
% Plot the 2nd results
% figure
z = [G', mu_med_Fz'];
% ---Generate the third curve for High vertical load Fz -----------
B=8; C=2.2; D=1; E=1.01;
for i = 1:1:201;
G(i) = (i-101)/100;
mu_hi_Fz(i) = -D*sin(C*atan(B*G(i)-E*(B*G(i)-atan(B*G(i)))));
end;
% Plot the 3rd results
% figure
z = [G', mu_hi_Fz'];
% plot(z(:,1),z(:,2),'b')
% legend('Fz = 9.45 kN', 'Fz = 24.8 kN','Fz = 40.9 kN')
% ------------
load_vector = [508*9.801*0.25 , 508*9.801*1.00, 508*9.801*2.00 ]';
slip_vector = G;
Fx_table = [ mu_lo_Fz *load_vector(1,1) ;
mu_med_Fz*load_vector(2,1) ;
mu_hi_Fz *load_vector(3,1) ];
figure
plot(G, Fx_table(1,:),'r-',G,Fx_table(2,:),'g:',G,Fx_table(3,:),'b-.')
title('Typical Fx vs. Longitudinal Slip For Constant Loads Fz',...
'FontWeight','bold')
xlabel('Longitdinal Slip G')
ylabel('Longitudinal Force Fx')
legend('Fz = 1.245 kN', 'Fz = 4.979 kN','Fz = 9.957 kN')
grid on
disp(' ')
disp('Completed Generate Car Ftrac Look Up Tables...')
disp(' ')