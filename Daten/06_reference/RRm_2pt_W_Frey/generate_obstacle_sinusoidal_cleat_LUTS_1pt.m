% ***********************************************************
% ******* GENERATE OBSTACLE SINUSOIDAL CLEAT LUTS 2PT *******
% ***********************************************************
% generate_obstacle_sinusoidal_cleat_LUTS_1pt.m 03 April 2008
%
% 1. Obstacle dimensions
D0 =0.50; % distance fm center of cleat to center of tire (m)
L = 0.019; % 0.019m = MT Cleat obstacle length (m)
H = 0.0095; % 0.0095m = MT Cleat obstacle height (m)
Fcorr = 2; % correct rounded cleat to same area as MT cleat
new_L = Fcorr*L; % corrects length of cleat so sinusoidal area is
% identical to area under rectangular cleat
% NOTE: The model runS only after all necessary variables are loaded.
% Variable 'a' is calculated from 'input_model_parameters_(Tire).m'
% Variable 'a' is the half contact patch length (m)
% 2. Generate x positions and corresponding z heights for the 1-D LUT
% preallocate arrays for speed
Xroad = zeros(1,2*D0*10000);
Zroad_lead = zeros(1,2*D0*10000);
Zroad_trail = zeros(1,2*D0*10000);
Zroad_eff = zeros(1,2*D0*10000);
Alpha_road = zeros(1,2*D0*10000);
for i = 1:1:2*D0*10000; % 2 X distance to obstacle, in 0.1 mm
increments
% to provide the necessary resolution in X
Xroad(i) = i/10000; % converts distances back to meters
% Now determine the sin function for the leading point
if Xroad(i) < (D0 - 0.5*new_L)
Zroad_lead(i) = 0;
Alpha_road(i) = 0;
elseif (D0 - 0.5*new_L) <= Xroad(i) && Xroad(i) <= D0 + 0.5*new_L
Zroad_lead(i) = ((H/2)*(1+cos((2*pi/new_L)*...
(Xroad(i)-(D0-0.5*new_L))-pi)));
Alpha_road(i) = atan(-sin((2*pi/new_L)*...
(Xroad(i)-(D0-0.5*new_L))-pi));
else Zroad_lead(i) = 0;
Alpha_road(i) = 0;
end
% Now calculate the effective Z plane height and angle alpha
% Zroad_eff(i) = (Zroad_lead(i) + Zroad_trail(i)) / 2;
Zroad_eff(i) = Zroad_lead(i);
end
% Now check the results of the obstacle inputs
figure
plot(Xroad,Zroad_lead, 'r',...
Xroad,Zroad_trail, 'g',...
Xroad,Zroad_eff, 'b')
title('MT Cleat Sinusoidal Geometry for BASIC 1 Pt Follower',...
'FontWeight','bold')
xlabel('X Road (m)')
ylabel('Road Z (m)')
legend('Zroad lead (r in m)',...
'Zroad trail (g in m)',...
'Zroad eff (b in m)')
%axis([0.1,0.15,-0,+1])
% axis([0,0.2,-0,+0.01])
% axis([9.7,10.3,-0.2,+0.2])
grid on
figure
plot(Xroad,Alpha_road, 'm')
title('MT Cleat Sinusoidal Approach Angle for BASIC 1 Pt Follower',...
'FontWeight','bold')
xlabel('X Road (m)')
ylabel('Alpha (rad)')
legend('Alpha road (m in rad)')
%axis([0.1,0.15,-0,+1])
% axis([0,0.2,-0,+0.01])
% axis([9.7,10.3,-0.2,+0.2])
grid on
disp(' ')
disp('Completed Generate Obstacle Sinusoidal Cleat LUTs 1 Point...')
disp(' ')