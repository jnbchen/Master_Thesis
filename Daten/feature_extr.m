clear all
close all
clc

global L;
global dr;
addpath 02_functions/
addpath 03_mats/

%% Variation Setting (a full loop of train takes 30mins and of test takes 60min)
class = 'train'; %or 'test'
auto = [1 2 3]; % {'BMW_116d','S_Klasse_W220','Sprinter'};
% auto = 1;
% auto = 2;
% auto = 3;
type = [0 5 10]; % {'pasv','arb','actv'};
% type = 0;
% type = 5;
% type = 10;
load = 0:100:400; % loads
% load = 0;
% load = 200;
% load = 400;

%% Parameter
if strcmp(class,'train')
    L = 200;
elseif strcmp(class,'test')
    L = 100;
end
dr = 0.01;
r = 0:dr:L;
V = (30:10:60)/3.6;
IRI_asphalt = 0.2;
IRI_uneven = 4;
events = {'pothole';'manhole';'cobbled';'railway';'unevenness'};
T = []; T2 = []; yz = []; yp = []; yy = [];

%% Simulation
for i = 1:length(V)
    for j = 1:length(events)
        for n = 1:length(auto)
            for m = 1:length(load)
                for p = 1:length(type)
                    road = road_model(IRI_asphalt,IRI_uneven,V(i),events{j},class,auto(n)); % random Pothole, L_road = L_wheel + L_vehicle        
                    y = FullCarModel(road(1,:),road(2,:),auto(n),type(p),load(m),V(i),1,0,0);
                    l = length(y);
                    % ddz/ddp/ddr/ground truth/auto/type/load/V
                    vehicle = auto(n)*ones(l,1);
                    groundturth = road(3,1:l)';
                    susp = type(p)*ones(l,1);
                    loads = load(m)*ones(l,1);
                    velocity = V(i)*ones(l,1);
                    input = [y(:,1),y(:,2),y(:,3),groundturth,vehicle,susp,loads,velocity];
                    windowlength = 10;
                    overlap = 0.25;
                    s = features(input,windowlength,overlap);
                    T = [T; struct2table(s)];
                end
            end
        end
    end
end

data = table2array(T);

name = [class '_' mat2str(auto) '_' mat2str(type) '_' mat2str(load)];
project_name = [name '.prjz'];
save([name '.mat'],'T');

%% Frequency analysis
% N = length(yy);
% Fs = 1/dr;
% 
% if mod(N,2) == 1
%         N = N-1;
% end
% 
% f = Fs*(0:(N/2))/N;
% mag = zeros(length(f),3);
% 
% figure
% for i = 1:3
%     xdft = fft(yy(:,i));
%     xdft = xdft(1:N/2+1);
%     mag(:,i) = (1/(Fs*N)) * abs(xdft).^2;
%     mag(2:end-1,i) = 2*mag(2:end-1,i);
%     subplot(3,1,i)
%     plot(f(1:N/2),mag(1:N/2,i))
% end

%% Create project
code_alle = data(:,end);
bez_code = 'event';
zgf_y_bez(1,1).name = 'asphalt';
zgf_y_bez(1,2).name = 'pothole';
zgf_y_bez(1,3).name = 'manhole';
zgf_y_bez(1,4).name = 'cobbled';
zgf_y_bez(1,5).name = 'railway';
zgf_y_bez(1,6).name = 'unevenness';
d_org = data(:,1:end-1);
dorgbez = char(T.Properties.VariableNames(1:end-1));
generate_new_scixminer_project(project_name,code_alle,bez_code,zgf_y_bez,d_org,dorgbez,[],[],[],[]);

%% Write in .txt

% data = table2array(T);
% p_79 = data(:,74);
% p_13 = data(:,65);
% r_79 = data(:,75);
% label = data(:,end);
% 
% print = [d(:,1),d(:,2),code];
% 
% fileID = fopen('class_af_pasv_200.txt','w');
% fprintf(fileID,'%1s %1s %1s\r\n','z','x','y','label');
% fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
% fclose(fileID);