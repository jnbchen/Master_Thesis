% *******************************************
% ******* GENERATE INITIAL CONDITIONS *******
% *******************************************
%
% Initial conditions for the 'integrated system'


Z_init = 0 ; % m
Zdot_init = 0 ; % m/s
X_init = 0; % m
Xdot_init = (8) * (1/3.6); % enter kph to yield m/s
Theta_init = X_init/Reff; % rad/sec
Thetadot_init = Xdot_init/Reff; % rad/sec
Throttle_initial = 0.00; % initial throttle fraction (0 to 1)
Throttle_final = 0.00; % final throttle fraction (0 to 1)
Throttle_step_time = 0.00; % throttle step time (sec)
Throttle_lag = 0.00; % throttle lag of 0.05 seems reasonable
% disp('Initial system velocity '); Xdot_init
% print speed table and prompt for speed in m/sec (13.42 m/sec=30 mph)
% for i = 1:1:8
% x(:,i) = [(5*i) ; (5*i*3.6/1.609344)];
% end
% disp('');
% disp(' m/sec mph');
% disp(x')
% disp(' ')
% Xdot_init= ('Initial speed in (m/s)? ')
% % prompt for simulation time, t_end
% disp(' ');
% t_end = ('Simulation end time (sec)? ')
% disp(' ')
% Assign each mass component its initial conditions
% Z conditions for all components
Z_ring_0 = Z_init;
Zdot_ring_0 = Zdot_init;
Z_rim_0 = Z_init;
Zdot_rim_0 = Zdot_init;
Z_truck_0 = Z_init;
Zdot_truck_0 = Zdot_init;
% X conditions for all components
X_ring_0 = X_init;
Xdot_ring_0 = Xdot_init;
X_rim_0 = X_init;
Xdot_rim_0 = Xdot_init;
X_truck_0 = X_init;
Xdot_truck_0 = Xdot_init;
X_tread_0 = X_init;
Xdot_tread_0 = Xdot_init;
% Theta conditions for all components
Theta_ring_0 = Theta_init;
Thetadot_ring_0 = Thetadot_init;
Theta_rim_0 = Theta_init;
Thetadot_rim_0 = Thetadot_init;
Theta_tread_0 = Theta_init;
Thetadot_tread_0 = Thetadot_init;
% Physical constants needed for the simulation
rho = 1.204; % air density [kg/m^3]
Area = 1.8*1.5/4; % 1/4th the frontal area of the car [m^2]
Cd = 0.4; % non-dimensional coefficent of aero
disp(' ')
disp('Completed Generate Initial Conditions...')
disp(' ')