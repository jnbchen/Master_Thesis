% ******************************************
% ******* INPUT MODEL PARAMETERS PS2 *******
% ******************************************
% input_model_paramters_PS2.m 08 Feb 2009
%
% File contains the following information:
% - tire data from Michelin Machine Rigidity Testing
% - tire data from tire omega cuts and weighing the components
% - simple 1/4 car model mass estimates (total mass: max load at 2.0b)
% - tire data comes from Michelin Machine Rigidity Testing
%
% T&RA Data is as follows:
% - 26 psi / 180 kPa : 589 kg
% - 29 psi / 200 kPa : 631 kg
% - 32 psi / 220 kPa : 671 kg
% - 35 psi / 240 kPa : 710 kg
% - Max Section Width = 243mm, 677 OD
% - Max RTW = 95% of Max overall width (0.95*243 = 231 mm)
%
% Advertised Specifications
% - 25 lbs => 11.3 Kg
% - Revs per mile = 778 => DLR = (1,609.344)/2/pi/778
% - DLR (Dynamic Loaded Radius) =0.3292 m
% - O/A diameter = 26.7 inches (678.18 mm)
% *** VEHICLE MASS Properties - weight based upon 2 bar design load
% MT data was taken at 362 or 589 kgf at 2.0 bar
% Spindle_mass = 362; % For minimum solicitation and CP length (kg)
Spindle_mass = 589; % For maximum solicitation and CP length (kg)
Mcar = Spindle_mass; % (kg) !NF This is for one quarter vehicle
% *** TIRE MASS Properties - from tire that cut & measured manually.
% Values used are in the Mass and MOI spreadsheet for rigid ring model.
Mbead_meas = 2.252; % decorticage cut (kg)
Msidewall_meas = 1.798; % decorticage cut (kg)
Msummit_meas = 5.871; % decorticage cut (kg)
Mtread_meas = 1.993; % decorticage cut (kg) using CSR estimates
Mtire = Mbead_meas + Msidewall_meas + Msummit_meas + Mtread_meas; %(kg)
Ibead_meas = 0.148; % decorticage cut (kg-m^2)
Isidewall_meas = 0.155; % decorticage cut (kg-m^2)
Isummit_meas = 0.632; % decorticage cut (kg-m^2)
Itread_meas = 0.222; % decorticage cut (kg-m^2)
Itire = Ibead_meas+Isidewall_meas+Isummit_meas+Itread_meas; %(kg-m^2)
% *** RIM MASS Properties
% Values used in the Mass and MOI spreadsheet for the rigid ring model.
Mrim = 17.330; % test rim-measured by MT-alum rim ~10 (kg)
Irim = 0.725; % test rim-measured by MT-spin MOI (kg m^2)
% *** AXLE Inputs 2007 Lexus IS350 from Michelin K&C Test FW601
% dated 7 Nov 07 w/ 4 people ***
Maxle = (106/2)-Mrim-Mtire; % mass of axle for one wheel position(kg)
% 1/4 car - '07 IS350 V-6 RWD (kg)
Kaxle = 1000*(29.4+28.6+34.1+34.6)/4; % avg spring rate (N/m)
Caxle = (1400+4500)/2; % Typical avg. comp./rebound [N/(m/s)]
Mdrive = 0; % driveline input torque to rim (Nm)
% *** TIRE/RIM SIZE Inputs ***
SW = 0.245; % Section Width (m)
RTW = 0.183; % Rolling Tread Width fm contact patch (m)
%RTW = 0.197; % Rolling Tread Width (m)
AR = 45; % Aspect Ratio
Rim = 18; % Rim seat diameter (in)
% Reff = ((0.5*Rim*25.4)+(AR/100)*SW)/1000; % => 0.3389 (m)
% Reff = 0.3920; % Eff. Rolling Radius from TP^2 program (m)
% Reff = 0.3292; % RPM data-dynamic loaded radius (m)
Reff = 0.3292;
% *** CONTACT PATCH LENGTH ***
% Calculate One-Half Contact Patch Length 'a' (use Z Force=Press*Area)
% Calculating a (1/2 contact patch length) for tire at 2.0 bar(32 psi)
% at a loading of spindle_mass kg's static loading using F = P*A. The
% rolling tread width RTW is approximated by the mean width of the two
% subtread belts, measured on the tire omega cut.
Tire_press_psi = 29; % tire pressure (lb/in^2)
% Note:35 psi~2.20b
Tire_press_bar = 1.0*round(10*(Tire_press_psi*0.06894757))/10; % (bar)
Tire_press_kPa = 29*6.894757; % tire pressure (kPa)
Tire_press_Pa = 29*6894.757; % tire pressure (Pa)
CP_Area_in2 = Spindle_mass*2.204623/Tire_press_psi; % CP area (in^2)
CPL_pneu = (CP_Area_in2*0.00064516/RTW); % CP length (m)
% CP_Area_m2 = (Spindle_mass)*9.80665/Tire_press_Pa; % CP area (m^2)
% CPL_pneu_metric = (CP_Area_m2/RTW); % CP length (m)
% Half contact patch length 'a' is used in the models
a = 0.5 * CPL_pneu; % 1/2 * CPL (m)
disp(' ')
disp('Calculated Contact Patch Length: '),a;
disp(' ')
% *** TIRE MOI Corrections within the contact patch
% Appropriate sidewall mass and inertia to bead and summit
Mbead = Mbead_meas + 0.5*Msidewall_meas; % (kg)
Ibead = Ibead_meas + 0.5*Isidewall_meas; % (kg m^2)
% Appropriate tread mass & inertia to summit according to in/out of CP
frac_CP = (2*a)/(2*pi*Reff); % fraction of circumference w/in CP
Mring=Msummit_meas+0.5*Msidewall_meas+(1-frac_CP)*Mtread_meas;%(kg)
Iring=Isummit_meas+0.5*Isidewall_meas+(1-frac_CP)*Itread_meas;%(kg-m^2)
Mtread = frac_CP*Mtread_meas; % (kg)
Itread = frac_CP*Itread_meas; % (kg-m^2)
Ktire_z = 261347; % vertical spring constant (N/m)
Ctire_z = 0.0008*Ktire_z; % est. of damping constant (N-s/m)
Ktire_x = 1354447; % longitudinal spring constant (N/m)
Ctire_x = 0.0010*Ktire_x; % est. of damping constant (N-s/m)
Ktire_theta = 60057; % tire torsional stiffness (Nm/rad)
Ctire_theta = 0.0012*Ktire_theta; % est. torsional damping (Nms/rad)
Ktread_vr = 1775149; % tread block vert. resid. spring (N/m)
Ctread_vr = 0.0010*Ktread_vr; % tread block vert. resid. damping(N-s/m)
Ktread_cr = 2692900; % tread block circum. resid. spring (N/m)
Ctread_cr = 0.0010*Ktread_cr; % tread block circum. resid. damp (N-s/m)
% *** ADD'L CALCULATED VALUES ***
Msprung = Spindle_mass - Maxle - Mrim - Mtire; % 1/4 sprung mass (kg)
disp(' ')
disp('Completed Input Model Parameters for PS2...')
disp(' ')