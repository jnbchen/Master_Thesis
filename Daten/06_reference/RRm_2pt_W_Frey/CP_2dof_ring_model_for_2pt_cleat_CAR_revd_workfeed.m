% ****************************
% ******* MAIN PROGRAM *******
% ****************************
% CP_2dof_ring_model_for_2pt_cleat_CAR_revd_workfeed.m 25 Mar 2009
% MAIN Program to launch 2 point rigid ring Simulink Model
% ------- Housekeeping
clc; % clears command window history
clear; % clears variables
close all; % closes all graphics windows
my_home_dir = pwd;
delete sim_record.txt
diary sim_record.txt
% ------- Set up all the variables for 'one quarter' drive position
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_Gen_Data') %Data repository
input_model_parameters_PS2
% ------- Obstacle dimensions
L = 0.0190; % 0.019m = MT Cleat obstacle length (m)
H = 0.0095; % 0.0095m = MT Cleat obstacle height (m)
D0 = 0.50; % distance from center of cleat to center of tire(m)
Fineness = 10000; % multiply by 10,000 to convert 0.0001 m to integers
a_rnd = round(a*Fineness)/Fineness; % round off one-half Contact
% patc length (a) for indexing
% ------- generate 2-Pt Follower over obstacle LUTs
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_2Pt_Data') %Data repository
generate_obstacle_sinusoidal_cleat_LUTS_2pt
%generate_obstacle_square_cleat_LUTS_2pt
% ------- Set up the initial condtions
% Set model initial conditions here in m, m/s (propagates to components)
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_Gen_Data') %Data repository
generate_initial_conditions
% ------- generate Longitudinal Traction Fz = Fcn(Fnorm, %Slip) LUT
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_Gen_Data') %Data repository
generate_CAR_Ftrac_LUT
% ------- load the transmission gear ratios and shift point LUT
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_Gen_Data') %Data repository
generate_CAR_shift_program_and_engine_torque_LUT
% ------- Run the Simulink model
t_end = 0.5;
time_step = 0.0001;
t = (0:time_step:t_end)';
% Change directories and run the simulink model
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_Models')
sim('Rigid_Ring_2Pt_QV_revb',t, simset('Solver','ode23t','RelTol',5e-14))
disp(' ')
disp('Completed Rigid_ring_model_for_2pt_cleat_FixedSpindle_revb...')
disp(' ')
% ------- Seed Structured Array Output and Save
% seed the simulation output parameters
test_name = ' QV'; % Fixed Spindle (FS) or Quarter Vehicle (QV);
model_name = ' 2Pt'; % Models include:
% ATAC_1PtK_, ATAC_1_PtKM_
% ATAC_RingK_, ATAC_RingKM_
% ATAC_ConstK_, ATAC_ConstKM_
% ATAC_Adapt_
% 2Pt_, 5Pt_
% FTire_
obstacle_name = ' MTSin'; % MTSqr_ or MTSin_ or BMP_
load_name = strcat(num2str(Mcar,3),'Kg '); % Mass of vehicle
speed_name = strcat(num2str(Xdot_init*3.6,2),'Kph ');% 08, 10,30,50 kph
tire_press_name = strcat(num2str(Tire_press_bar,2),'b');% 2b or 3b
sim_comment = '';
final_name = strcat(test_name, model_name, obstacle_name,load_name,...
speed_name, tire_press_name, sim_comment);
file_name = 'Vehicle Cleat - 2 Point Rigid Ring Chassis Accelerations';
% generate the simulation output structure - return 'sim_data'
structure
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_Gen_Data')
my_2Pt_rigid_ring_struc_revb
% ------- Save the 'sim_data' data structure
cd('C:\Thesis\MatLab\Eight_A\Veh_Common_Out')
QV_2Pt_MTSin_589Kg_8Kph_2b = sim_data;
save QV_2Pt_MTSin_589Kg_8Kph_2b
% ------ Time when the metrics will be calculated
t_begin_wave = 0.1809; % set Fx engagement for each individual model
t_end_wave = 0.2686; % set for Fx disengagement for each model
t_delta_wave = t_end_wave-t_begin_wave;
% ------- check simulation results
figure
plot(sim_data.Chassis.time , sim_data.Chassis.fz, 'm',...
sim_data.Chassis.time , sim_data.Chassis.fx, 'b')
title('MT Cleat - Raw Quarter Vehicle Chassis Forces')
legend('Chassis Fz',...
'Chassis Fx' )
xlabel('Time (sec)')
ylabel('Raw Chassis Forces from Matlab (N)')
grid on
new_sim_data.Rim.time = sim_data.Rim.time;
new_sim_data.Rim.fz = sim_data.Rim.fz;
new_sim_data.Rim.fx = sim_data.Rim.fx;
new_sim_data.Chassis.time = sim_data.Chassis.time;
new_sim_data.Chassis.fz = sim_data.Chassis.fz;
new_sim_data.Chassis.fx = sim_data.Chassis.fx;
new_sim_data.Chassis.zdotdot = sim_data.Chassis.zdotdot;
new_sim_data.Chassis.xdotdot = sim_data.Chassis.xdotdot;
% find average chassis fz and fx force levels before and after impulse
my_outer_i = 0;
for my_i = 1:1:length(new_sim_data.Chassis.time)
if new_sim_data.Chassis.time(my_i)<= t_begin_wave || ...
new_sim_data.Chassis.time(my_i)>= t_end_wave
my_outer_i = my_outer_i + 1;
my_meaner_fz(my_outer_i) = new_sim_data.Chassis.fz(my_i);
my_meaner_fx(my_outer_i) = new_sim_data.Chassis.fx(my_i);
end
end
my_mean_outer_fz = mean(my_meaner_fz);
my_mean_outer_fx = mean(my_meaner_fx);
% Subtract out the mean offsets
new_sim_data.Chassis.fz = new_sim_data.Chassis.fz - my_mean_outer_fz;
new_sim_data.Chassis.fx = new_sim_data.Chassis.fx - my_mean_outer_fx;
% generate the wave = zero outside the valid impact time
for my_i = 1:1:length(new_sim_data.Chassis.time)
if new_sim_data.Chassis.time(my_i)<= t_begin_wave || ...
new_sim_data.Chassis.time(my_i)>= t_end_wave % time in sec
new_sim_data.Rim.fz(my_i) = 0;
new_sim_data.Rim.fx(my_i) = 0;
new_sim_data.Chassis.fz(my_i) = 0;
new_sim_data.Chassis.fx(my_i) = 0;
new_sim_data.Chassis.zdotdot(my_i) = 0;
new_sim_data.Chassis.xdotdot(my_i) = 0;
end
end
figure
plot(new_sim_data.Rim.time , sim_data.Rim.fz, 'm',...
new_sim_data.Rim.time , new_sim_data.Rim.fz, 'b')
title('MT Cleat - Quarter Vehicle Rim Forces - Fz')
legend('Old Rim Fz',...
'New Rim Fz' )
xlabel('Time (sec)')
ylabel('Fz Rim Force (N)')
grid on
figure
plot(sim_data.Rim.time , sim_data.Rim.fx, 'm',...
sim_data.Rim.time , new_sim_data.Rim.fx, 'g')
title('MT Cleat - Quarter Vehicle Rim Forces - Fx')
legend('Old Rim Fx',...
'New Rim Fx' )
xlabel('Time (sec)')
ylabel('Fx Rim Force (N)')
grid on
figure
plot(new_sim_data.Chassis.time , sim_data.Chassis.fz, 'm',...
new_sim_data.Chassis.time , new_sim_data.Chassis.fz, 'b')
title('MT Cleat - Quarter Vehicle Chassis Forces - Fz')
legend('Old Chassis Fz',...
'New Chassis Fz' )
xlabel('Time (sec)')
ylabel('Fz Chassis Force (N)')
grid on
figure
plot(sim_data.Chassis.time , sim_data.Chassis.fx, 'm',...
sim_data.Chassis.time , new_sim_data.Chassis.fx, 'g')
title('MT Cleat - Quarter Vehicle Chassis Forces - Fx')
legend('Old Chassis Fx',...
'New Chassis Fx' )
xlabel('Time (sec)')
ylabel('Fx Chassis Force (N)')
grid on
figure
plot(new_sim_data.Chassis.time , sim_data.Chassis.zdotdot/9.81,'m',...
new_sim_data.Chassis.time , new_sim_data.Chassis.zdotdot/9.81,'b')
title('MT Cleat - Quarter Vehicle Chassis Z Acceleration')
legend('Old Chassis Z Acceleration',...
'New Chassis Z Acceleration' )
xlabel('Time (sec)')
ylabel('Chassis Z Acceleration (g)')
grid on
figure
plot(sim_data.Chassis.time , sim_data.Chassis.xdotdot/9.81, 'm',...
sim_data.Chassis.time , new_sim_data.Chassis.xdotdot/9.81, 'g')
legend('Old Chassis X Acceleration',...
'New Chassis X Acceleration' )
xlabel('Time (sec)')
ylabel('Chassis X Acceleration (g)')
grid on
% ------- Final Acceleration Plots
% Load Appropriate FTire simulation and FTire suspension forces
load('C:\Thesis\MatLab\Eight_A\Y_FTire_Cleat_Sinus\Fsuspension_cleat')
load('C:\Thesis\MatLab\Eight_A\Y_FTire_Cleat_Sinus\FTire_cleat')
figure
plot(sim_data.Chassis.time, sim_data.Chassis.zdotdot/9.81,'m',...
QVFTireMTSqr589Kg8Kph2b.Chassis.time-1,...
QVFTireMTSqr589Kg8Kph2b.Chassis.zdotdot/9.81,'g',...
new_sim_data.Chassis.time, new_sim_data.Chassis.zdotdot/9.81,...
'b','linewidth',2);
title('Check Accelerations for TRAPZ','FontSize',10,'FontWeight','bold');
xlabel('Time (sec)','FontSize',08,'FontWeight','bold');
ylabel('Chassis Acceleration (g)','FontSize',08,'FontWeight','bold');
legend('Sim Data Chassis Accel Az (g)',...
'SIMPACK and FTire Az (g)',...
'New Sim Data Chassis Az (g)')
set(gca,'FontSize',08,'FontWeight','bold')
set(gcf,'Color',[1 1 1])
box on, grid on
figure
plot(sim_data.Chassis.time, sim_data.Chassis.xdotdot/9.81,'m',...
QVFTireMTSqr589Kg8Kph2b.Chassis.time-1,...
QVFTireMTSqr589Kg8Kph2b.Chassis.xdotdot/9.81,'g',...
new_sim_data.Chassis.time, new_sim_data.Chassis.xdotdot/9.81,...
'b','linewidth',2);
title('Check Accelerations for TRAPZ','FontSize',10,'FontWeight','bold');
xlabel('Time (sec)','FontSize',08,'FontWeight','bold');
ylabel('Chassis Acceleration (g)','FontSize',08,'FontWeight','bold');
legend('Sim Data Chassis Accel Ax (g)',...
'SIMPACK and FTire Ax (g)',...
'New Sim Data Chassis Ax (g)')
set(gca,'FontSize',08,'FontWeight','bold')
set(gcf,'Color',[1 1 1])
box on, grid on
figure
subplot(2,1,1)
plot(sim_data.Chassis.time-t_off, sim_data.Chassis.zdotdot/9.81,'r',...
QVFTireMTSqr589Kg8Kph2b.Chassis.time-1,...
QVFTireMTSqr589Kg8Kph2b.Chassis.zdotdot/9.81,'g','linewidth',2);
title(file_name,'FontSize',10,'FontWeight','bold');
ylabel('Vertical Acceleration Az(g)','FontSize',08,'FontWeight','bold');
legend('Model Accel Az','SIMPACK and FTire Az')
axis([ 0.0, 0.5, -0.1, 0.1])
set(gca,'FontSize',08,'FontWeight','bold')
set(gcf,'Color',[1 1 1])
box on, grid on
subplot(2,1,2)
plot(sim_data.Chassis.time-t_off, sim_data.Chassis.xdotdot/9.81, b',...
QVFTireMTSqr589Kg8Kph2b.Chassis.time-1,...
QVFTireMTSqr589Kg8Kph2b.Chassis.xdotdot/9.81,'g','linewidth',2);
xlabel('Time (sec)','FontSize',08,'FontWeight','bold');
ylabel('Longitudinal Accel Ax (g)','FontSize',08,'FontWeight','bold');
legend('Model Accel Ax','SIMPACK and FTire Ax','location','southeast')
axis([ 0.0, 0.5, -0.2, 0.2])
set(gca,'FontSize',08,'FontWeight','bold')
set(gcf,'Color',[1 1 1])
box on, grid on
% Now save figure
cd('C:\Thesis\Comfort_Thesis\Accel_Graphics')
saveas(gcf,final_name,'bmp')
saveas(gcf,final_name,'fig')
figure
file_name = 'Vehicle Cleat - 2 Point Rigid Ring Suspension Forces';
subplot(2,1,1)
plot(sim_data.Chassis.time-t_off, sim_data.Chassis.fz,'b',...
QVFTireMTSqr589Kg8Kph2b.Chassis.time-1,...
QVFTireMTSqr589Kg8Kph2b.Chassis.fz-5615,'g','linewidth',2);
title(file_name,'FontSize',10,'FontWeight','bold');
ylabel('Vertical Suspension Fz (N)','FontSize',08,'FontWeight','bold');
legend('Model Supension Fz','SIMPACK and FTire Fz')
axis([ 0.0, 0.5, -1000, 1500])
set(gca,'FontSize',08,'FontWeight','bold')
set(gcf,'Color',[1 1 1])
box on, grid on
subplot(2,1,2)
plot(sim_data.Chassis.time-t_off, sim_data.Chassis.fx,'b',...
QVFTireMTSqr589Kg8Kph2b.Chassis.time-1,...
QVFTireMTSqr589Kg8Kph2b.Chassis.fx,'g','linewidth',2);
xlabel('Time (sec)','FontSize',08,'FontWeight','bold');
ylabel('Longitudinal Suspension Fx(N)','FontSize',08,'FontWeight','bold');
legend('Model Suspension Fx','SIMPACK and FTire Fx','location','southeast')
axis([ 0.0, 0.5, -1000, 1000])
set(gca,'FontSize',08,'FontWeight','bold')
set(gcf,'Color',[1 1 1])
box on, grid on
% Now save figure
cd('C:\Thesis\Comfort_Thesis\Force_Graphics')
saveas(gcf,final_name,'bmp')
saveas(gcf,final_name,'fig')
% ------- Generate Output Metrics
cd('C:\Thesis\Comfort_Thesis\Diary')
diary ('QV_Az_Ax_PkFz_PkFx_ImpFz_ImpFx_chassis.txt')
disp(' ')
disp(file_name)
fprintf('%.5f \n', max(new_sim_data.Chassis.zdotdot/9.81),...
min(new_sim_data.Chassis.xdotdot/9.81),...
max(new_sim_data.Rim.fz),...
min(new_sim_data.Rim.fx),...
trapz(sim_data.Chassis.time,sim_data.Chassis.fz),...
trapz(sim_data.Chassis.time,sim_data.Chassis.fx))
diary off
% ------- Home directory
%cd('C:\Thesis\MatLab\Eight_A\A_Point_K_Cleat_Sinus')
cd(my_home_dir);