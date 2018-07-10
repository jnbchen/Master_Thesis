function Output = FCM_passive_t(road_left,road_right,V,L,dt,a,b,c)

Ms=1400;                % body Masse
h_aufbau = 0.5;           % height of the vehicle body
Kwr1=100000;            % tire spring front right 100000 
Kwl1=100000;            % tire spring front left  100000
Kwr2=100000;            % tire spring rear right  100000
Kwl2=100000;            % tire spring rear left   100000
% if V<=10
    Csr1=1500;              % suspension damper front right 2000 
    Csl1=1500;              % suspension damper front left  2000
    Csr2=1500;              % suspension damper rear right  2000
    Csl2=1500;              % suspension damper rear left   2000
% else 
%     Csr1=V/10*2500;              % suspension damper front right 2000 
%     Csl1=V/10*2500;              % suspension damper front left  2000
%     Csr2=V/10*2500;              % suspension damper rear right  2000
%     Csl2=V/10*2500;              % suspension damper rear left   2000
% end
Ksr1=36689.2;           % suspension spring front right 36689.2;  
Ksl1=36689.2;           % suspension spring front left
Ksr2=35902.3;           % suspension spring rear right 35902.3;  
Ksl2=35902.3;           % suspension spring rear left
Lf=1.345;               % spacing from front to cg
Lr=1.345;               % spacing from rear to cg
Dr=0.856;               % spacing from right to cg
Dl=0.856;               % spacing from left to cg
Mwr1=22.5;              % tire mass front right  22.5
Mwl1=20.5;              % tire mass front left
Mwr2=22.5;              % tire mass rear right
Mwl2=20.5;              % tire mass rear left
Ixx=1/12*Ms*(h_aufbau^2+(2*Dr)^2);                % moment of inertia 4000
Iyy=1/12*Ms*(h_aufbau^2+(2*Lr)^2);
e = 1;

%% Input
x0 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0]';    % initial state        

tmax = L/V;
t = 0:dt:tmax; 

car = round((Lf+Lr)/V/dt)-1; % Punkte zwischen Vorderachse und Hinterachse

left1 = road_left(:,car+1:end); % front axle
right1 = road_right(:,car+1:end);

left2 = road_left(:,1:end-car); % rear axle
right2 = road_right(:,1:end-car);

% figure()
% subplot(2,1,1)
% plot(r,left1,'b',r,left2,'r')
% legend('front','rear')
% title('road profile left')
% 
% subplot(2,1,2)
% plot(r,right1,'b',r,right2,'r')
% legend('front','rear')
% title('road profile right')

%% Full car Model passive
A(1,:)=[0,1,0,0,0,0,0,0,0,0,0,0,0,0];
A(3,:)=[0,0,0,1,0,0,0,0,0,0,0,0,0,0];
A(5,:)=[0,0,0,0,0,1,0,0,0,0,0,0,0,0];
A(7,:)=[0,0,0,0,0,0,0,1,0,0,0,0,0,0];
A(9,:)=[0,0,0,0,0,0,0,0,0,1,0,0,0,0];
A(11,:)=[0,0,0,0,0,0,0,0,0,0,0,1,0,0];
A(13,:)=[0,0,0,0,0,0,0,0,0,0,0,0,0,1];

A(2,1)=(-Ksr1-Ksl1-Ksr2-Ksl2)/Ms;
A(2,2)=(-Csr1-Csl1-Csr2-Csl2)/Ms;
A(2,3)=(Lf*Ksr1+Lf*Ksl1-Lr*Ksr2-Lr*Ksl2)/Ms;
A(2,4)=(Lf*Csr1+Lf*Csl1-Lr*Csr2-Lr*Csl2)/Ms;
A(2,5)=(Dr*Ksr1-Dl*Ksl1+Dr*Ksr2-Dl*Ksl2)/Ms;
A(2,6)=(Dr*Csr1-Dl*Csl1+Dr*Csr2-Dl*Csl2)/Ms;
A(2,7)=Ksr1/Ms;
A(2,8)=Csr1/Ms;
A(2,9)=Ksl1/Ms;
A(2,10)=Csl1/Ms;
A(2,11)=Ksr2/Ms;
A(2,12)=Csr2/Ms;
A(2,13)=Ksl2/Ms;
A(2,14)=Csl2/Ms;

A(4,1)=(Ksr1*Lf+Ksl1*Lf-Ksr2*Lr-Ksl2*Lr)/Iyy;
A(4,2)=(Csr1*Lf+Csl1*Lf-Csr2*Lr-Csl2*Lr)/Iyy;
A(4,3)=(-Ksr1*Lf^2-Ksl1*Lf^2-Ksr2*Lr^2-Ksl2*Lr^2)/Iyy;
A(4,4)=(-Csr1*Lf^2-Csl1*Lf^2-Csr2*Lr^2-Csl2*Lr^2)/Iyy;
A(4,5)=(-Dr*Ksr1*Lf+Dl*Ksl1*Lf+Dr*Ksr2*Lr-Dl*Ksl2*Lr)/Iyy;
A(4,6)=(-Dr*Csr1*Lf+Dl*Csl1*Lf+Dr*Csr2*Lr-Dl*Csl2*Lr)/Iyy;
A(4,7)=-Ksr1*Lf/Iyy;
A(4,8)=-Csr1*Lf/Iyy;
A(4,9)=-Ksl1*Lf/Iyy; 
A(4,10)=-Csl1*Lf/Iyy;
A(4,11)=Ksr2*Lr/Iyy;
A(4,12)=Csr2*Lr/Iyy;
A(4,13)=Ksl2*Lr/Iyy;
A(4,14)=Csl2*Lr/Iyy;

A(6,1)=(-Ksl1*Dl-Ksl2*Dl+Ksr1*Dr+Ksr2*Dr)/Ixx;
A(6,2)=(-Csl1*Dl-Csl2*Dl+Csr1*Dr+Csr2*Dr)/Ixx;
A(6,3)=(Lf*Ksl1*Dl-Lr*Ksl2*Dl-Lf*Ksr1*Dr+Lr*Ksr2*Dr)/Ixx;
A(6,4)=(Lf*Csl1*Dl-Lr*Csl2*Dl-Lf*Csr1*Dr+Lr*Csr2*Dr)/Ixx;
A(6,5)=-(Ksl1*Dl^2+Ksl2*Dl^2+Ksr1*Dr^2+Ksr2*Dr^2)/Ixx;
A(6,6)=-(Csl1*Dl^2+Csl2*Dl^2+Csr1*Dr^2+Csr2*Dr^2)/Ixx;
A(6,7)=-Ksr1*Dr/Ixx;
A(6,8)=-Csr1*Dr/Ixx;
A(6,9)= Ksl1*Dl/Ixx;
A(6,10)=Csl1*Dl/Ixx;
A(6,11)=-Ksr2*Dr/Ixx;
A(6,12)=-Csr2*Dr/Ixx;
A(6,13)=Ksl2*Dl/Ixx;
A(6,14)=Csl2*Dl/Ixx;

A(8,:)=[Ksr1/Mwr1,Csr1/Mwr1,-Lf*Ksr1/Mwr1,-Lf*Csr1/Mwr1,-Dr*Ksr1/Mwr1,-Dr*Csr1/Mwr1,-(Kwr1+Ksr1)/Mwr1,-Csr1/Mwr1,0,0,0,0,0,0];
A(10,:)=[Ksl1/Mwl1,Csl1/Mwl1,-Lf*Ksl1/Mwl1,-Lf*Csl1/Mwl1,Dl*Ksl1/Mwl1,Dl*Csl1/Mwl1,0,0,-(Ksl1+Kwl1)/Mwl1,-Csl1/Mwl1,0,0,0,0];
A(12,:)=[Ksr2/Mwr2,Csr2/Mwr2,Lr*Ksr2/Mwr2,Lr*Csr2/Mwr2,-Dr*Ksr2/Mwr2,-Dr*Csr2/Mwr2,0,0,0,0,-(Ksr2+Kwr2)/Mwr2,-Csr2/Mwr2,0,0];
A(14,:)=[Ksl2/Mwl2,Csl2/Mwl2,Lr*Ksl2/Mwl2,Lr*Csl2/Mwl2,Dl*Ksl2/Mwl2,Dl*Csl2/Mwl2,0,0,0,0,0,0,-(Ksl2+Kwl2)/Mwl2,-Csl2/Mwl2];

B=zeros(14,8);
B(8,:)=[Kwr1/Mwr1,e*sqrt(Kwr1*Mwr1),0,0,0,0,0,0];
B(10,:)=[0,0,Kwl1/Mwl1,e*sqrt(Kwl1*Mwl1),0,0,0,0];
B(12,:)=[0,0,0,0,Kwr2/Mwr2,e*sqrt(Kwr2*Mwr2),0,0];
B(14,:)=[0,0,0,0,0,0,Kwl2/Mwl2,e*sqrt(Kwl2*Mwl2)];

C(1,1)=(-Ksr1-Ksl1-Ksr2-Ksl2)/Ms;
C(1,2)=(-Csr1-Csl1-Csr2-Csl2)/Ms;
C(1,3)=(Lf*Ksr1+Lf*Ksl1-Lr*Ksr2-Lr*Ksl2)/Ms;
C(1,4)=(Lf*Csr1+Lf*Csl1-Lr*Csr2-Lr*Csl2)/Ms;
C(1,5)=(Dr*Ksr1-Dl*Ksl1+Dr*Ksr2-Dl*Ksl2)/Ms;
C(1,6)=(Dr*Csr1-Dl*Csl1+Dr*Csr2-Dl*Csl2)/Ms;
C(1,7)=Ksr1/Ms;
C(1,8)=Csr1/Ms;
C(1,9)=Ksl1/Ms;
C(1,10)=Csl1/Ms;
C(1,11)=Ksr2/Ms;
C(1,12)=Csr2/Ms;
C(1,13)=Ksl2/Ms;
C(1,14)=Csl2/Ms;

C(2,1)=(Ksr1*Lf+Ksl1*Lf-Ksr2*Lr-Ksl2*Lr)/Iyy;
C(2,2)=(Csr1*Lf+Csl1*Lf-Csr2*Lr-Csl2*Lr)/Iyy;
C(2,3)=(-Ksr1*Lf^2-Ksl1*Lf^2-Ksr2*Lr^2-Ksl2*Lr^2)/Iyy;
C(2,4)=(-Csr1*Lf^2-Csl1*Lf^2-Csr2*Lr^2-Csl2*Lr^2)/Iyy;
C(2,5)=(-Dr*Ksr1*Lf+Dl*Ksl1*Lf+Dr*Ksr2*Lr-Dl*Ksl2*Lr)/Iyy;
C(2,6)=(-Dr*Csr1*Lf+Dl*Csl1*Lf+Dr*Csr2*Lr-Dl*Csl2*Lr)/Iyy;
C(2,7)=-Ksr1*Lf/Iyy;
C(2,8)=-Csr1*Lf/Iyy;
C(2,9)=-Ksl1*Lf/Iyy; 
C(2,10)=-Csl1*Lf/Iyy;
C(2,11)=Ksr2*Lr/Iyy;
C(2,12)=Csr2*Lr/Iyy;
C(2,13)=Ksl2*Lr/Iyy;
C(2,14)=Csl2*Lr/Iyy;

C(3,1)=(-Ksl1*Dl-Ksl2*Dl+Ksr1*Dr+Ksr2*Dr)/Ixx;
C(3,2)=(-Csl1*Dl-Csl2*Dl+Csr1*Dr+Csr2*Dr)/Ixx;
C(3,3)=(Lf*Ksl1*Dl-Lr*Ksl2*Dl-Lf*Ksr1*Dr+Lr*Ksr2*Dr)/Ixx;
C(3,4)=(Lf*Csl1*Dl-Lr*Csl2*Dl-Lf*Csr1*Dr+Lr*Csr2*Dr)/Ixx;
C(3,5)=-(Ksl1*Dl^2+Ksl2*Dl^2+Ksr1*Dr^2+Ksr2*Dr^2)/Ixx;
C(3,6)=-(Csl1*Dl^2+Csl2*Dl^2+Csr1*Dr^2+Csr2*Dr^2)/Ixx;
C(3,7)=-Ksr1*Dr/Ixx;
C(3,8)=-Csr1*Dr/Ixx;
C(3,9)= Ksl1*Dl/Ixx;
C(3,10)=Csl1*Dl/Ixx;
C(3,11)=-Ksr2*Dr/Ixx;
C(3,12)=-Csr2*Dr/Ixx;
C(3,13)=Ksl2*Dl/Ixx;
C(3,14)=Csl2*Dl/Ixx;

C(4,:)=[Ksr1/Mwr1,Csr1/Mwr1,-Lf*Ksr1/Mwr1,-Lf*Csr1/Mwr1,-Dr*Ksr1/Mwr1,-Dr*Csr1/Mwr1,-(Kwr1+Ksr1)/Mwr1,-Csr1/Mwr1,0,0,0,0,0,0];
C(5,:)=[Ksl1/Mwl1,Csl1/Mwl1,-Lf*Ksl1/Mwl1,-Lf*Csl1/Mwl1,Dl*Ksl1/Mwl1,Dl*Csl1/Mwl1,0,0,-(Ksl1+Kwl1)/Mwl1,-Csl1/Mwl1,0,0,0,0];
C(6,:)=[Ksr2/Mwr2,Csr2/Mwr2,Lr*Ksr2/Mwr2,Lr*Csr2/Mwr2,-Dr*Ksr2/Mwr2,-Dr*Csr2/Mwr2,0,0,0,0,-(Ksr2+Kwr2)/Mwr2,-Csr2/Mwr2,0,0];
C(7,:)=[Ksl2/Mwl2,Csl2/Mwl2,Lr*Ksl2/Mwl2,Lr*Csl2/Mwl2,Dl*Ksl2/Mwl2,Dl*Csl2/Mwl2,0,0,0,0,0,0,-(Ksl2+Kwl2)/Mwl2,-Csl2/Mwl2];

D = [0,0,0,0,0,0,0,0;
     0,0,0,0,0,0,0,0;
     0,0,0,0,0,0,0,0;
     Kwr1/Mwr1,e*sqrt(Kwr1*Mwl1),0,0,0,0,0,0;
     0,0,Kwl1/Mwl1,e*sqrt(Kwl1*Mwl1),0,0,0,0;
     0,0,0,0,Kwr2/Mwr2,e*sqrt(Kwr2*Mwr2),0,0;
     0,0,0,0,0,0,Kwl2/Mwl2,e*sqrt(Kwl2*Mwl2)];
 
full_car_model = ss(A,B,C,D);
SimModel = full_car_model;
Input = [right1;left1;right2;left2];
Output = lsim(SimModel,Input,t,x0);

% Different position of output
if a >=0
    x = a*Lf;
else
    x = a*Lr;
end

if b >=0
    y = b*Dl;
else
    y = b*Dr;
end

Output(:,1) = Output(:,1) - x*Output(:,2) + y*Output(:,3);
Output(:,8) = c*Output(:,2); % longitudal acceleration 
Output(:,9) = -c*Output(:,3); % lateral acceleration

% %% Output
% acc_body=Output(:,1);
% acc_pitch_angle=Output(:,2);
% acc_roll_angle=Output(:,3);
% acc_wheel_r1=Output(:,4);
% acc_wheel_l1=Output(:,5);
% acc_wheel_r2=Output(:,6);
% acc_wheel_l2=Output(:,7);

end