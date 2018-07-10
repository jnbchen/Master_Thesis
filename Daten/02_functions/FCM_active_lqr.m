function Output = FCM_active_lqr(road_left,road_right,V,L,auto,dr,Q,R)

%% Parameters
if auto == 1  % 1er BMW 116d
    
Ms=1400;                % body Masse
h_aufbau = 1;           % height of the vehicle body
Kwr1=150000;            % tire spring front right
Kwl1=150000;            % tire spring front left
Kwr2=150000;            % tire spring rear right 
Kwl2=150000;            % tire spring rear left
Csr1=2500;              % suspension damper front right
Csl1=2500;              % suspension damper front left
Csr2=2500;              % suspension damper rear right
Csl2=2500;              % suspension damper rear left
Ksr1=36689.2;           % suspension spring front right
Ksl1=36689.2;           % suspension spring front left
Ksr2=35902.3;           % suspension spring rear right
Ksl2=35902.3;           % suspension spring rear left
Lf=1.345;               % spacing from front to cg
Lr=1.345;               % spacing from rear to cg
Dr=0.856;               % spacing from right to cg
Dl=0.856;               % spacing from left to cg
Mwr1=22.5;              % tire mass front right
Mwl1=22.5;              % tire mass front left
Mwr2=22.5;              % tire mass rear right
Mwl2=22.5;              % tire mass rear left
Carf = 800;             % anti roll bar stiffness front 
Carr = 800;
Aarf = 0.2;
Aarr = 0.2;
Ixx=1/12*Ms*(h_aufbau^2+(2*Dr)^2);                        % moment of inertia
Iyy=1/12*Ms*(h_aufbau^2+(2*Lr)^2); % +Ms*Lr^2;            % moment of inertia; ist wohl nicht n?tig das Tr?gheitsmoment mit steinerschem Satz auf Achse zu verschieben

elseif auto == 2 % S-Klasse W220
    
Ms=2000;                % body Masse
h_aufbau = 1.1;         % height of the vehicle body
Kwr1=180000;            % tire spring front right
Kwl1=180000;            % tire spring front left
Kwr2=180000;            % tire spring rear right 
Kwl2=180000;            % tire spring rear left
Csr1=3900;              % suspension damper front right
Csl1=3900;              % suspension damper front left
Csr2=3900;              % suspension damper rear right
Csl2=3900;              % suspension damper rear left
Ksr1=61356.6;           % suspension spring front right
Ksl1=61356.6;           % suspension spring front left
Ksr2=54908.75;          % suspension spring rear right
Ksl2=54908.75;          % suspension spring rear left
Lf=2.965/2;             % spacing from front to cg
Lr=2.965/2;             % spacing from rear to cg
Dr=1.574/2;             % spacing from right to cg
Dl=1.574/2;             % spacing from left to cg
Mwr1=22.5;              % tire mass front right
Mwl1=22.5;              % tire mass front left
Mwr2=22.5;              % tire mass rear right
Mwl2=22.5;              % tire mass rear left
Carf = 800;             % anti roll bar stiffness front 
Carr = 800;
Aarf = 0.2;
Aarr = 0.2;
Ixx=1/12*Ms*(h_aufbau^2+(2*Dr)^2);                % moment of inertia
Iyy=1/12*Ms*(h_aufbau^2+(2*Lr)^2)+Ms*Lr^2;                % moment of inertia

else % Sprinter

Ms=2100;                % body Masse
h_aufbau = 1.5;         % height of the vehicle body
Kwr1=180000;            % tire spring front right
Kwl1=180000;            % tire spring front left
Kwr2=180000;            % tire spring rear right 
Kwl2=180000;            % tire spring rear left
Csr1=3900;              % suspension damper front right
Csl1=3900;              % suspension damper front left
Csr2=3900;              % suspension damper rear right
Csl2=3900;              % suspension damper rear left
Ksr1=36300;             % suspension spring front right
Ksl1=36300;             % suspension spring front left
Ksr2=36300;             % suspension spring rear right
Ksl2=36300;             % suspension spring rear left
Lf=3.665/2;             % spacing from front to cg
Lr=3.665/2;             % spacing from rear to cg
Dr=1.9/2;               % spacing from right to cg
Dl=1.9/2;               % spacing from left to cg
Mwr1=25;                % tire mass front right
Mwl1=25;                % tire mass front left
Mwr2=25;                % tire mass rear right
Mwl2=25;                % tire mass rear left
Carf = 800;             % anti roll bar stiffness front 
Carr = 800;
Aarf = 0.2;
Aarr = 0.2;
Ixx=1/12*Ms*(h_aufbau^2+(2*Dr)^2);                % moment of inertia
Iyy=1/12*Ms*(h_aufbau^2+(2*Lr)^2)+Ms*Lr^2;                % moment of inertia

end

%% Input
x0 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0]';    % initial state                        

dt = dr/V;                              % time step for input data
tmax = L/V;                              % simulation time length
t = 0:dt:tmax; 

car = round((Lf+Lr)/dr); % Punkte zwischen Vorderachse und Hinterachse

left1 = road_left(car+1:end);
right1 = road_right(car+1:end);

left2 = road_left(1:end-car);
right2 = road_right(1:end-car);

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
A(6,5)=-(Ksl1*Dl^2+Ksl2*Dl^2+Ksr1*Dr^2+Ksr2*Dr^2-(Dr+Dl)^2*Carf/(Aarf^2)-(Dr+Dl)^2*Carr/(Aarr^2))/Ixx;
A(6,6)=-(Csl1*Dl^2+Csl2*Dl^2+Csr1*Dr^2+Csr2*Dr^2)/Ixx;
A(6,7)=-Ksr1*Dr/Ixx;
A(6,8)=-Csr1*Dr/Ixx;
A(6,9)= Ksl1*Dl/Ixx;
A(6,10)=Csl1*Dl/Ixx;
A(6,11)=-Ksr2*Dr/Ixx;
A(6,12)=-Csr2*Dr/Ixx;
A(6,13)=Ksl2*Dl/Ixx;
A(6,14)=Csl2*Dl/Ixx;

A(8,:)=[Ksr1/Mwr1,Csr1/Mwr1,-Lf*Ksr1/Mwr1,-Lf*Csr1/Mwr1,-Dr*Ksr1/Mwr1-(Dr+Dl)*Carf/(Aarf^2),-Dr*Csr1/Mwr1,-(Kwr1+Ksr1)/Mwr1-Carf/(Aarf^2),-Csr1/Mwr1,Carf/(Aarf^2),0,0,0,0,0];
A(10,:)=[Ksl1/Mwl1,Csl1/Mwl1,-Lf*Ksl1/Mwl1,-Lf*Csl1/Mwl1,Dl*Ksl1/Mwl1+(Dr+Dl)*Carf/(Aarf^2),Dl*Csl1/Mwl1,Carf/(Aarf^2),0,-(Ksl1+Kwl1)/Mwl1-Carf/(Aarf^2),-Csl1/Mwl1,0,0,0,0];
A(12,:)=[Ksr2/Mwr2,Csr2/Mwr2,Lr*Ksr2/Mwr2,Lr*Csr2/Mwr2,-Dr*Ksr2/Mwr2-(Dr+Dl)*Carr/(Aarr^2),-Dr*Csr2/Mwr2,0,0,0,0,-(Ksr2+Kwr2)/Mwr2-Carr/(Aarr^2),-Csr2/Mwr2,Carr/(Aarr^2),0];
A(14,:)=[Ksl2/Mwl2,Csl2/Mwl2,Lr*Ksl2/Mwl2,Lr*Csl2/Mwl2,Dl*Ksl2/Mwl2+(Dr+Dl)*Carr/(Aarr^2),Dl*Csl2/Mwl2,0,0,0,0,Carr/(Aarr^2),0,-(Ksl2+Kwl2)/Mwl2-Carr/(Aarr^2),-Csl2/Mwl2];

B=zeros(14,4);
B(2,:)=[1/Ms 1/Ms 1/Ms 1/Ms];
B(4,:)=[-Lf/Iyy -Lf/Iyy Lr/Iyy Lr/Iyy];
B(6,:)=[-Dr/Ixx Dl/Ixx -Dr/Ixx Dr/Ixx];
% B(8,:)=[-1/Mwr1 0 0 0];
% B(10,:)=[0 -1/Mwl1 0 0];
% B(12,:)=[0 0 -1/Mwr2 0];
% B(14,:)=[0 0 0 -1/Mwl2];

C(1,:)=A(2,:);
C(2,:)=A(4,:);
C(3,:)=A(6,:);
C(4,:)=A(8,:);
C(5,:)=A(10,:);
C(6,:)=A(12,:);
C(7,:)=A(14,:);

D=[ 1/Ms,1/Ms,1/Ms,1/Ms;
    -Lf/Iyy,-Lf/Iyy,Lr/Iyy,Lr/Iyy;
    -Dr/Ixx Dl/Ixx -Dr/Ixx Dr/Ixx
    -1/Mwr1,0,0,0;
    0,-1/Mwl1,0,0;
    0,0,-1/Mwr2,0;
    0,0,0,-1/Mwl2];

% LQR Regler f?r x' = Ax+Bu+Gr
% Q = 1e6*diag(ones(1,14));
% R = 1e-1*diag(ones(1,4));
K = lqr(A,B,Q,R);

% x' = (A-B*K)x+Gr
Ac = A-B*K;
Bc = zeros(14,4);
Bc(8,:) = [Kwr1/Mwr1,0,0,0];
Bc(10,:) = [0,Kwl1/Mwl1,0,0];
Bc(12,:) = [0,0,Kwr2/Mwr2,0];
Bc(14,:) = [0,0,0,Kwl2/Mwl2];

Cc = C;

Dc = [0,0,0,0;
      0,0,0,0;
      0,0,0,0;
      Kwr1/Mwr1,0,0,0;
      0,Kwl1/Mwl1,0,0;
      0,0,Kwr2/Mwr2,0;
      0,0,0,Kwl2/Mwl2];

full_car_model = ss(Ac,Bc,Cc,Dc);
SimModel = full_car_model;
Input = [right1;left1;right2;left2];
Output{1} = lsim(SimModel,Input,t,x0);

bodemag(SimModel(1:3,1),'k',{1,1000})
legend('passive','H_{inf}','LQR')
grid on
 
[a,p,w]=bode(SimModel(1,1),{1,1000});
[aa,pp,ww]=bode(SimModel(2,1),{1,1000});
[aaa,ppp,www]=bode(SimModel(3,1),{1,1000});
Output{2} = squeeze(a);
Output{3} = squeeze(p);
Output{4} = w;
Output{5} = squeeze(aa);
Output{6} = squeeze(pp);
Output{7} = ww;
Output{8} = squeeze(aaa);
Output{9} = squeeze(ppp);
Output{10} = www;

% %% Output
% acc_body=Output(:,1);
% acc_pitch_angle=Output(:,2);
% acc_roll_angle=Output(:,3);
% acc_wheel_r1=Output(:,4);
% acc_wheel_l1=Output(:,5);
% acc_wheel_r2=Output(:,6);
% acc_wheel_l2=Output(:,7);

end