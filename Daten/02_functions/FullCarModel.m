function output = FullCarModel(left,right,auto,type,load,V,a,b,c)

    global L;
    global dr;

    %% Parameters
    %if strcmp(auto,'BMW_116d')  % 1er BMW 116d
    if auto == 1
        Ms=1400;                % body Masse
        h_aufbau = 1;           % height of the vehicle body
        Kwr1=160000;            % tire spring front right 100000 
        Kwl1=160000;            % tire spring front left  100000
        Kwr2=160000;            % tire spring rear right  100000
        Kwl2=160000;            % tire spring rear left   100000
        Csr1=1000;              % suspension damper front right 2000 
        Csl1=1000;              % suspension damper front left  2000
        Csr2=1000;              % suspension damper rear right  2000
        Csl2=1000;              % suspension damper rear left   2000
        % end
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

    elseif auto == 2 % strcmp(auto,'S_Klasse_W220') % S-Klasse W220

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

    elseif auto == 3 % strcmp(auto,'Sprinter') % Sprinter

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
    else
        disp('no car found')
    end
    
    Carf = 600;  % anti roll bar stiffness front 
    Carr = 600;
    Aarf = 0.2;  % anti roll bar length front
    Aarr = 0.2;
    
    Ms = Ms + load;
    Ixx=1/12*Ms*(h_aufbau^2+(2*Dr)^2);                % moment of inertia
    Iyy=1/12*Ms*(h_aufbau^2+(2*Lr)^2)+Ms*Lr^2;        % moment of inertia

    %% Input                      
    dt = dr/V;                              % time step for input data
    tmax = L/V;                              % simulation time length
    t = 0:dt:tmax; 

    car = round((Lf+Lr)/dr);  % length of the vehicle

    left1 = left(car+1:end);
    right1 = right(car+1:end);
    left2 = left(1:end-car);
    right2 = right(1:end-car);

    %% Full car Model passive
    if type == 0 % strcpm(type,'pasv')
        
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

        B=zeros(14,4);
        B(8,:)=[Kwr1/Mwr1,0,0,0];
        B(10,:)=[0,Kwl1/Mwl1,0,0];
        B(12,:)=[0,0,Kwr2/Mwr2,0];
        B(14,:)=[0,0,0,Kwl2/Mwl2];

        C(1,:)=A(2,:);
        C(2,:)=A(4,:);
        C(3,:)=A(6,:);
        C(4,:)=A(8,:);
        C(5,:)=A(10,:);
        C(6,:)=A(12,:);
        C(7,:)=A(14,:);

        D = [0,0,0,0;
             0,0,0,0;
             0,0,0,0;
             Kwr1/Mwr1,0,0,0;
             0,Kwl1/Mwl1,0,0;
             0,0,Kwr2/Mwr2,0;
             0,0,0,Kwl2/Mwl2];
        
        full_car_model = ss(A,B,C,D);
    
    elseif type == 5 % strcmp(type,'arb')
        
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
        A(6,7)=-(Ksr1*Dr-(Dr+Dl)*Carf/(Aarf^2))/Ixx;
        A(6,8)=-Csr1*Dr/Ixx;
        A(6,9)= (Ksl1*Dl-(Dr+Dl)*Carf/(Aarf^2))/Ixx;
        A(6,10)=Csl1*Dl/Ixx;
        A(6,11)=-(Ksr2*Dr-(Dr+Dl)*Carr/(Aarr^2))/Ixx;
        A(6,12)=-Csr2*Dr/Ixx;
        A(6,13)=(Ksl2*Dl-(Dr+Dl)*Carr/(Aarr^2))/Ixx;
        A(6,14)=Csl2*Dl/Ixx;

        A(8,:)=[Ksr1/Mwr1,Csr1/Mwr1,-Lf*Ksr1/Mwr1,-Lf*Csr1/Mwr1,-Dr*Ksr1/Mwr1-(Dr+Dl)*Carf/(Aarf^2),-Dr*Csr1/Mwr1,-(Kwr1+Ksr1)/Mwr1-Carf/(Aarf^2),-Csr1/Mwr1,Carf/(Aarf^2),0,0,0,0,0];
        A(10,:)=[Ksl1/Mwl1,Csl1/Mwl1,-Lf*Ksl1/Mwl1,-Lf*Csl1/Mwl1,Dl*Ksl1/Mwl1+(Dr+Dl)*Carf/(Aarf^2),Dl*Csl1/Mwl1,Carf/(Aarf^2),0,-(Ksl1+Kwl1)/Mwl1-Carf/(Aarf^2),-Csl1/Mwl1,0,0,0,0];
        A(12,:)=[Ksr2/Mwr2,Csr2/Mwr2,Lr*Ksr2/Mwr2,Lr*Csr2/Mwr2,-Dr*Ksr2/Mwr2-(Dr+Dl)*Carr/(Aarr^2),-Dr*Csr2/Mwr2,0,0,0,0,-(Ksr2+Kwr2)/Mwr2-Carr/(Aarr^2),-Csr2/Mwr2,Carr/(Aarr^2),0];
        A(14,:)=[Ksl2/Mwl2,Csl2/Mwl2,Lr*Ksl2/Mwl2,Lr*Csl2/Mwl2,Dl*Ksl2/Mwl2+(Dr+Dl)*Carr/(Aarr^2),Dl*Csl2/Mwl2,0,0,0,0,Carr/(Aarr^2),0,-(Ksl2+Kwl2)/Mwl2-Carr/(Aarr^2),-Csl2/Mwl2];

        B=zeros(14,4);
        B(8,:)=[Kwr1/Mwr1,0,0,0];
        B(10,:)=[0,Kwl1/Mwl1,0,0];
        B(12,:)=[0,0,Kwr2/Mwr2,0];
        B(14,:)=[0,0,0,Kwl2/Mwl2];

        C(1,:)=A(2,:);
        C(2,:)=A(4,:);
        C(3,:)=A(6,:);
        C(4,:)=A(8,:);
        C(5,:)=A(10,:);
        C(6,:)=A(12,:);
        C(7,:)=A(14,:);

        D = [0,0,0,0;
             0,0,0,0;
             0,0,0,0;
             Kwr1/Mwr1,0,0,0;
             0,Kwl1/Mwl1,0,0;
             0,0,Kwr2/Mwr2,0;
             0,0,0,Kwl2/Mwl2];
         
        full_car_model = ss(A,B,C,D);
         
    elseif type == 10 % strcmp(type, 'actv')
        
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
        A(6,7)=-(Ksr1*Dr-(Dr+Dl)*Carf/(Aarf^2))/Ixx;
        A(6,8)=-Csr1*Dr/Ixx;
        A(6,9)= (Ksl1*Dl-(Dr+Dl)*Carf/(Aarf^2))/Ixx;
        A(6,10)=Csl1*Dl/Ixx;
        A(6,11)=-(Ksr2*Dr-(Dr+Dl)*Carr/(Aarr^2))/Ixx;
        A(6,12)=-Csr2*Dr/Ixx;
        A(6,13)=(Ksl2*Dl-(Dr+Dl)*Carr/(Aarr^2))/Ixx;
        A(6,14)=Csl2*Dl/Ixx;

        A(8,:)=[Ksr1/Mwr1,Csr1/Mwr1,-Lf*Ksr1/Mwr1,-Lf*Csr1/Mwr1,-Dr*Ksr1/Mwr1-(Dr+Dl)*Carf/(Aarf^2),-Dr*Csr1/Mwr1,-(Kwr1+Ksr1)/Mwr1-Carf/(Aarf^2),-Csr1/Mwr1,Carf/(Aarf^2),0,0,0,0,0];
        A(10,:)=[Ksl1/Mwl1,Csl1/Mwl1,-Lf*Ksl1/Mwl1,-Lf*Csl1/Mwl1,Dl*Ksl1/Mwl1+(Dr+Dl)*Carf/(Aarf^2),Dl*Csl1/Mwl1,Carf/(Aarf^2),0,-(Ksl1+Kwl1)/Mwl1-Carf/(Aarf^2),-Csl1/Mwl1,0,0,0,0];
        A(12,:)=[Ksr2/Mwr2,Csr2/Mwr2,Lr*Ksr2/Mwr2,Lr*Csr2/Mwr2,-Dr*Ksr2/Mwr2-(Dr+Dl)*Carr/(Aarr^2),-Dr*Csr2/Mwr2,0,0,0,0,-(Ksr2+Kwr2)/Mwr2-Carr/(Aarr^2),-Csr2/Mwr2,Carr/(Aarr^2),0];
        A(14,:)=[Ksl2/Mwl2,Csl2/Mwl2,Lr*Ksl2/Mwl2,Lr*Csl2/Mwl2,Dl*Ksl2/Mwl2+(Dr+Dl)*Carr/(Aarr^2),Dl*Csl2/Mwl2,0,0,0,0,Carr/(Aarr^2),0,-(Ksl2+Kwl2)/Mwl2-Carr/(Aarr^2),-Csl2/Mwl2];

        B=zeros(14,8);
        B(2,:)=[0 0 0 0 1/Ms 1/Ms 1/Ms 1/Ms];
        B(4,:)=[0 0 0 0 -Lf/Iyy -Lf/Iyy Lr/Iyy Lr/Iyy];
        B(6,:)=[0 0 0 0 -Dr/Ixx Dl/Ixx -Dr/Ixx Dr/Ixx];
        B(8,:)=[Kwr1/Mwr1 0 0 0 -1/Mwr1 0 0 0];
        B(10,:)=[0 Kwl1/Mwl1 0 0 0 -1/Mwl1 0 0];
        B(12,:)=[0 0 Kwr2/Mwr2 0 0 0 -1/Mwr2 0];
        B(14,:)=[0 0 0 Kwl2/Mwl2 0 0 0 -1/Mwl2];

        C(1,:)=A(2,:);
        C(2,:)=A(4,:);
        C(3,:)=A(6,:);
        C(4,:)=A(8,:);
        C(5,:)=A(10,:);
        C(6,:)=A(12,:);
        C(7,:)=A(14,:);

        C(8,:)= [1 0 -Lf 0 -Dl 0 -1 0 0 0 0 0 0 0];
        C(9,:)= [1 0 -Lf 0 Dl 0 0 0 -1 0 0 0 0 0];
        C(10,:)=[1 0 Lf 0 -Dl 0 0 0 0 0 -1 0 0 0];
        C(11,:)=[1 0 Lf 0 Dl 0 0 0 0 0 0 0 -1 0];

        D=zeros(11,8);
        D(1:7,:)=[ 0,0,0,0,1/Ms,1/Ms,1/Ms,1/Ms;
                   0,0,0,0,-Lf/Iyy,-Lf/Iyy,Lr/Iyy,Lr/Iyy;
                   0,0,0,0,-Dr/Ixx Dl/Ixx -Dr/Ixx Dr/Ixx
                   Kwr1/Mwr1,0,0,0,-1/Mwr1,0,0,0;
                   0,Kwl1/Mwl1,0,0,0,-1/Mwl1,0,0;
                   0,0,Kwr2/Mwr2,0,0,0,-1/Mwr2,0;
                   0,0,0,Kwl2/Mwl2,0,0,0,-1/Mwl2];

        fcm = ss(A,B,C,D);
        fcm.StateName = {'body travel';'body vel';'body pitch';'pitch vel';'body roll';'roll vel';'wheel1 travel';'wheel1 vel';...
                          'wheel2 travel';'wheel2 vel';'wheel3 travel';'wheel3 vel';'wheel4 travel';'wheel4 vel';};
        fcm.InputName = {'r1';'r2';'r3';'r4';'f1';'f2';'f3';'f4'};
        fcm.OutputName = {'ddz';'ddp';'ddr';'ddz1';'ddz2';'ddz3';'ddz4';'sd1';'sd2';'sd3';'sd4'};

        num = {[0 150] 0 0 0;0 [0 150] 0 0;0 0 [0 150] 0;0 0 0 [0 150]};
        deno = [1/60 1];
        ActNom = 1.5*tf(num,deno);
        Wunc = makeweight(0.40,15,3);
        Act = ActNom*(1 + Wunc);
        Act.InputName = {'u1';'u2';'u3';'u4'};
        Act.OutputName = {'f1';'f2';'f3';'f4'};

        Numerators = {[0 150] 0 0 0;0 [0 150] 0 0;0 0 [0 150] 0;0 0 0 [0 150]};
        Denominator = [1 600];

        Wact = 0.8*tf(Numerators,Denominator);
        Wact.u = {'u1';'u2';'u3';'u4'};
        Wact.y = {'e1';'e2';'e3';'e4'};

        Wdz = ss(0.2); Wdw = ss([0.2 0;0 0.2]); Wdt = ss(diag([0.2 0.2 0.2 0.2]));
        Wdz.u = 'd5'; Wdz.y = 'Wd5'; Wdw.u = {'d6';'d7'}; Wdw.y = {'Wd6';'Wd7'};
        Wdt.u = {'d8';'d9';'d10';'d11'}; Wdt.y = {'Wd8';'Wd9';'Wd10';'Wd11'};

        heave = tf([1 21 20],[1 8 15]);
        rotate = tf([1 31 30],[1 11 24]);
        ComfortTarget = [heave 0 0; 0 rotate 0; 0 0 rotate];
        numerator = {[1 55 250] 0 0 0; 0 [1 55 250] 0 0; 0 0 [1 55 250] 0;0 0 0 [1 55 250]};
        denominators = [1 30 200];
        HandlingTarget = tf(numerator,denominators);

        Wad = ComfortTarget;
        Wad.u = {'ddz';'ddp';'ddr'};
        Wad.y = {'e5';'e6';'e7'};
        Wsd = 0.5*HandlingTarget;
        Wsd.u = {'sd1';'sd2';'sd3';'sd4'};
        Wsd.y = {'e8';'e9';'e10';'e11'};

        ddzmeas = sumblk('y1 = ddz+Wd5');
        ddpmeas = sumblk('y2 = ddp+Wd6');
        ddrmeas = sumblk('y3 = ddr+Wd7');
        sd1meas  = sumblk('y4 = sd1+Wd8');
        sd2meas  = sumblk('y5 = sd2+Wd9');
        sd3meas  = sumblk('y6 = sd3+Wd10');
        sd4meas  = sumblk('y7 = sd4+Wd11');
        ICinputs = {'r1';'r2';'r3';'r4';'d5';'d6';'d7';'d8';'d9';'d10';'d11';...
                    'u1';'u2';'u3';'u4'};
        ICoutputs = {'e1';'e2';'e3';'e4';'e5';'e6';'e7';'e8';'e9';'e10';'e11';...
                     'y1';'y2';'y3';'y4';'y5';'y6';'y7'};
        fcaric = connect(fcm([1:3 8:11],:),Act,Wact,Wad,Wsd,Wdz,Wdw,Wdt,...
                         ddzmeas,ddpmeas,ddrmeas,sd1meas,sd2meas,sd3meas,sd4meas,...
                         ICinputs,ICoutputs);

        ncont = 4; % one control signal, u
        nmeas = 7; % two measurement signals, sd and ab
        K = hinfsyn(fcaric,nmeas,ncont);

        K.u = {'ddz','ddp','ddr','sd1','sd2','sd3','sd4'};
        K.y = {'u1','u2','u3','u4'};
        full_car_model = connect(fcm,Act,K,{'r1';'r2';'r3';'r4'},{'ddz';'ddp';'ddr';'ddz1';'ddz2';'ddz3';'ddz4'});
    end

    input = [right1;left1;right2;left2];
    output = lsim(full_car_model,input,t);

    % Different position of output
    if a >= 0
        x = a*Lf;
    else
        x = a*Lr;
    end

    if b >= 0
        y = b*Dl;
    else
        y = b*Dr;
    end

    output(:,1) = output(:,1) - x*output(:,2) + y*output(:,3);
    output(:,8) = c*output(:,2); % longitudal acceleration 
    output(:,9) = -c*output(:,3); % lateral acceleration

    % %% Output
    % acc_body=Output(:,1);
    % acc_pitch_angle=Output(:,2);
    % acc_roll_angle=Output(:,3);
    % acc_wheel_r1=Output(:,4);
    % acc_wheel_l1=Output(:,5);
    % acc_wheel_r2=Output(:,6);
    % acc_wheel_l2=Output(:,7);

end