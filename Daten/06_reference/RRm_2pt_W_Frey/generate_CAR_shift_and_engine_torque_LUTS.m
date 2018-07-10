% *********************************************************
% ******* GENERATE CAR SHIFT AND ENGINE TORQUE LUTS *******
% *********************************************************
% generate_CAR_shift_program_and_engine_torque_LUT
% MANUAL transmission

diff_ratio = 4.10; % 2.64 in spec sheet
efficiency = 0.95; % total driveline efficiency
% Reff = 0.480; % effective tire radius (m)
% Only use this Reff for troubleshooting - must synchronize
% with the initial condition file -
% MANUAL transmission only gear ratios
gear_ratio_6 = 0.84;
gear_ratio_5 = 1.00;
gear_ratio_4 = 1.25;
gear_ratio_3 = 1.72;
gear_ratio_2 = 2.61;
gear_ratio_1 = 4.46;
% AUTOMATIC transmission only gear ratios
%gear_ratio_4 = 0.69;
%gear_ratio_3 = 1.00;
%gear_ratio_2 = 1.57;
%gear_ratio_1 = 2.84;
% Speed (mps)to shift to next higher gear = mph*(1 mph = 0.44704 m/sec)
MPS_5_6 = 90*0.44704; % 90 MPH * 0.44704 = 40.2336 m/sec (5th => 6th)
MPS_4_5 = 75*0.44704; % 23
MPS_3_4 = 50*0.44704; % 18
MPS_2_3 = 35*0.44704; % 14
MPS_1_2 = 20*0.44704; % 9 4.0234 m/sec
% Data for RPM vs Torque LUT
% RPM and TORQUE in Nm
% Six Cylinder 60deg V, 3778 cc 230.5 in^3, 12 OHV, roller folllowers,
% Hydraulic lifters, SMPFI
% Peak 205HP (153 kW) @ 5200 RPM, 240 ft-lb torque (325 Nm)
Engine_RPM_Breakpoints = [400 800 1200 1600 2000 2400 2800 3200 3600 ...
4000 4400 4800 5200 5600 6000 6400];
Engine_Torque_Data = [ 0 182 198 206 212 220 217 224 233 ...
233 232 227 211 191 161 0];
%convert torque to Nm
Engine_Torque_Data = 1.35582 .* Engine_Torque_Data;
disp(' ')
disp('Completed Car shift program and engine torque Look up tables...')
disp(' ')