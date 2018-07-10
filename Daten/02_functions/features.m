function s = features(input,windowlength,overlap)

global L;
global dr;


%% ddz/ddp/ddr/ground truth/auto/type/load/V
ddz = input(:,1);
ddp = input(:,2);
ddr = input(:,3);
event = input(:,4);
auto = input(:,5);
type = input(:,6);
load = input(:,7);
V = input(:,8);

%% create structur
window = windowlength/dr;
n = floor((L-overlap*windowlength)/((1-overlap)*windowlength)); % number of windows/[int]

field1 = 'min_z';
field2 = 'min_p';
field3 = 'min_r';
field4 = 'max_z';
field5 = 'max_p';
field6 = 'max_r';
field7 = 'mean_z';
field8 = 'mean_p';
field9 = 'mean_r';
field10 = 'range_z';
field11 = 'range_p';
field12 = 'range_r';
field13 = 'std_z';
field14 = 'std_p';
field15 = 'std_r';
field16 = 'duration_z';
field17 = 'duration_p';
field18 = 'duration_r';
field19 = 'intAbs_z';
field20 = 'intAbs_p';
field21 = 'intAbs_r';
field22 = 'PSD_z';
field23 = 'PSD_p';
field24 = 'PSD_r';
field25 = 'RMS_z';
field26 = 'RMS_p';
field27 = 'RMS_r';
field28 = 'centeroid_z';
field29 = 'centeroid_p';
field30 = 'centeroid_r';
field31 = 'diff_z';
field32 = 'diff_p';
field33 = 'diff_r';
field34 = 'intBP_z_1_3';
field35 = 'intBP_p_1_3';
field36 = 'intBP_r_1_3';
field37 = 'intBP_z_3_5';
field38 = 'intBP_p_3_5';
field39 = 'intBP_r_3_5';
field40 = 'intBP_z_5_7';
field41 = 'intBP_p_5_7';
field42 = 'intBP_r_5_7';
field43 = 'intBP_z_7_9';
field44 = 'intBP_p_7_9';
field45 = 'intBP_r_7_9';
field46 = 'intBP_z_9_11';
field47 = 'intBP_p_9_11';
field48 = 'intBP_r_9_11';
field49 = 'intBP_z_11_13';
field50 = 'intBP_p_11_13';
field51 = 'intBP_r_11_13';
field52 = 'intBP_z_13_15';
field53 = 'intBP_p_13_15';
field54 = 'intBP_r_13_15';
field55 = 'intBP_z_15_17';
field56 = 'intBP_p_15_17';
field57 = 'intBP_r_15_17';
field58 = 'intBP_z_17_19';
field59 = 'intBP_p_17_19';
field60 = 'intBP_r_17_19';
field61 = 'intBP_z_19_21';
field62 = 'intBP_p_19_21';
field63 = 'intBP_r_19_21';
field64 = 'maxBP_z_1_3';
field65 = 'maxBP_p_1_3';
field66 = 'maxBP_r_1_3';
field67 = 'maxBP_z_3_5';
field68 = 'maxBP_p_3_5';
field69 = 'maxBP_r_3_5';
field70 = 'maxBP_z_5_7';
field71 = 'maxBP_p_5_7';
field72 = 'maxBP_r_5_7';
field73 = 'maxBP_z_7_9';
field74 = 'maxBP_p_7_9';
field75 = 'maxBP_r_7_9';
field76 = 'maxBP_z_9_11';
field77 = 'maxBP_p_9_11';
field78 = 'maxBP_r_9_11';
field79 = 'maxBP_z_11_13';
field80 = 'maxBP_p_11_13';
field81 = 'maxBP_r_11_13';
field82 = 'maxBP_z_13_15';
field83 = 'maxBP_p_13_15';
field84 = 'maxBP_r_13_15';
field85 = 'maxBP_z_15_17';
field86 = 'maxBP_p_15_17';
field87 = 'maxBP_r_15_17';
field88 = 'maxBP_z_17_19';
field89 = 'maxBP_p_17_19';
field90 = 'maxBP_r_17_19';
field91 = 'maxBP_z_19_21';
field92 = 'maxBP_p_19_21';
field93 = 'maxBP_r_19_21';
field94 = 'vehicle';
field95 = 'susp';
field96 = 'loads';
field97 = 'velocity';
field98 = 'event';


value = zeros(n,1);

s = struct(field1,value,field2,value,field3,value,field4,value,field5,value,...
    field6,value,field7,value,field8,value,field9,value,field10,value,...
    field11,value,field12,value,field13,value,field14,value,field15,value,...
    field16,value,field17,value,field18,value,field19,value,field20,value,...
    field21,value,field22,value,field23,value,field24,value,field25,value,...
    field26,value,field27,value,field28,value,field29,value,field30,value,...
    field31,value,field32,value,field33,value,field34,value,field35,value,...
    field36,value,field37,value,field38,value,field39,value,field40,value,...
    field41,value,field42,value,field43,value,field44,value,field45,value,...
    field46,value,field47,value,field48,value,field49,value,field50,value,...
    field51,value,field52,value,field53,value,field54,value,field55,value,...
    field56,value,field57,value,field58,value,field59,value,field60,value,...
    field61,value,field62,value,field63,value,field64,value,field65,value,...
    field66,value,field67,value,field68,value,field69,value,field70,value,...
    field71,value,field72,value,field73,value,field74,value,field75,value,...
    field76,value,field77,value,field78,value,field79,value,field80,value,...
    field81,value,field82,value,field83,value,field84,value,field85,value,...
    field86,value,field87,value,field88,value,field89,value,field90,value,...
    field91,value,field92,value,field93,value,field94,value,field95,value,...
    field96,value,field97,value,field98,value);

threshold_z = abs(mean(ddz))+abs(std(ddz));
threshold_p = abs(mean(ddp))+abs(std(ddp));
threshold_r = abs(mean(ddr))+abs(std(ddr));
V = mean(V);
s.event = ones(n,1);

dt = dr/V;

%% calculate
for i = 1:n
    x = (i-1)*(1-overlap)*window+1:(i-1)*(1-overlap)*window+window;
    
    % event
    gtruth = unique(event(x));
    if numel(gtruth) == 1
        s.event(i) = gtruth;
    elseif numel(find(event(x)==gtruth(end))) >= 0.1/dr % event falling in window longer than 0.1m
        s.event(i) = gtruth(end);
    else
        s.event(i) = gtruth(1);
    end
    
    % velocity
    s.velocity(i) = V;
    
    % auto
    autos = unique(auto(x));
    if numel(autos) == 1
        s.vehicle(i) = autos;
    elseif numel(find(auto(x)==autos(1))) >= 0.5*window
        s.vehicle(i) = autos(1);
    else
        s.vehicle(i) = autos(end);
    end
    
    % type
    types = unique(type(x));
    if numel(types) == 1
        s.susp(i) = types;
    elseif numel(find(type(x)==types(1))) >= 0.5*window
        s.susp(i) = types(1);
    else
        s.susp(i) = types(end);
    end
    
    % load
    last = unique(load(x));
    if numel(last) == 1
        s.loads(i) = last;
    elseif numel(find(load(x)==last(1))) >= 0.5*window
        s.loads(i) = last(1);
    else
        s.loads(i) = last(end);
    end
    
    % mean
    s.mean_z(i) = mean(ddz(x));
    s.mean_p(i) = mean(ddp(x));
    s.mean_r(i) = mean(ddr(x));
    
    % std
    s.std_z(i) = std(ddz(x));
    s.std_p(i) = std(ddp(x));
    s.std_r(i) = std(ddr(x));
    
    % max, min, duration
    [ma,t1] = max(ddz(x));
    [mi,t2] = min(ddz(x));
    s.max_z(i) = ma;
    s.min_z(i) = mi;
    if abs(s.max_z(i)) >= threshold_z && abs(s.min_z(i)) >= threshold_z
        s.duration_z(i) = abs(t1-t2);
    end
    
    [ma,t1] = max(ddp(x));
    [mi,t2] = min(ddp(x));
    s.max_p(i) = ma;
    s.min_p(i) = mi;
    if abs(s.max_p(i)) >= threshold_p && abs(s.min_p(i)) >= threshold_p
        s.duration_p(i) = abs(t1-t2);
    end
    
    [ma,t1] = max(ddr(x));
    [mi,t2] = min(ddr(x));
    s.max_r(i) = ma;
    s.min_r(i) = mi;
    if abs(s.max_r(i)) >= threshold_r && abs(s.min_r(i)) >= threshold_r
        s.duration_r(i) = abs(t1-t2);
    end
    
    % range
    s.range_z(i) = s.max_z(i) - s.min_z(i);
    s.range_p(i) = s.max_p(i) - s.min_p(i);
    s.range_r(i) = s.max_r(i) - s.min_r(i);
    
    % intAbs
    s.intAbs_z(i) = intAbs(ddz(x));
    s.intAbs_p(i) = intAbs(ddp(x));
    s.intAbs_r(i) = intAbs(ddr(x));
    
    % Derivatives
    s.diff_z(i) = max(diff(ddz(x))/dt);
    s.diff_p(i) = max(diff(ddp(x))/dt);
    s.diff_r(i) = max(diff(ddr(x))/dt);
    
    % PSD, RMS
    s.PSD_z(i) = max(ft(ddz(x)));
    s.RMS_z(i) = sqrt(sum(ft(ddz(x))));
    
    s.PSD_p(i) = max(ft(ddp(x)));
    s.RMS_p(i) = sqrt(sum(ft(ddp(x))));
    
    s.PSD_r(i) = max(ft(ddr(x)));
    s.RMS_r(i) = sqrt(sum(ft(ddr(x))));
    
    % centroid
    s.centeroid_z(i) = speccentroid(ddz(x));
    s.centeroid_p(i) = speccentroid(ddp(x));
    s.centeroid_r(i) = speccentroid(ddr(x));
    
    % intBP
    s.intBP_z_1_3(i) = intBP(ddz(x),1,3);
    s.intBP_p_1_3(i) = intBP(ddp(x),1,3);
    s.intBP_r_1_3(i) = intBP(ddr(x),1,3);
    
    s.intBP_z_3_5(i) = intBP(ddz(x),3,5);
    s.intBP_p_3_5(i) = intBP(ddp(x),3,5);
    s.intBP_r_3_5(i) = intBP(ddr(x),3,5);
    
    s.intBP_z_5_7(i) = intBP(ddz(x),5,7);
    s.intBP_p_5_7(i) = intBP(ddp(x),5,7);
    s.intBP_r_5_7(i) = intBP(ddr(x),5,7);
    
    s.intBP_z_7_9(i) = intBP(ddz(x),7,9);
    s.intBP_p_7_9(i) = intBP(ddp(x),7,9);
    s.intBP_r_7_9(i) = intBP(ddr(x),7,9);
    
    s.intBP_z_9_11(i) = intBP(ddz(x),9,11);
    s.intBP_p_9_11(i) = intBP(ddp(x),9,11);
    s.intBP_r_9_11(i) = intBP(ddr(x),9,11);
    
    s.intBP_z_11_13(i) = intBP(ddz(x),11,13);
    s.intBP_p_11_13(i) = intBP(ddp(x),11,13);
    s.intBP_r_11_13(i) = intBP(ddr(x),11,13);
    
    s.intBP_z_13_15(i) = intBP(ddz(x),13,15);
    s.intBP_p_13_15(i) = intBP(ddp(x),13,15);
    s.intBP_r_13_15(i) = intBP(ddr(x),13,15);
    
    s.intBP_z_15_17(i) = intBP(ddz(x),15,17);
    s.intBP_p_15_17(i) = intBP(ddp(x),15,17);
    s.intBP_r_15_17(i) = intBP(ddr(x),15,17);
    
    s.intBP_z_17_19(i) = intBP(ddz(x),17,19);
    s.intBP_p_17_19(i) = intBP(ddp(x),17,19);
    s.intBP_r_17_19(i) = intBP(ddr(x),17,19);
    
    s.intBP_z_19_21(i) = intBP(ddz(x),19,21);
    s.intBP_p_19_21(i) = intBP(ddp(x),19,21);
    s.intBP_r_19_21(i) = intBP(ddr(x),19,21);
    
    % maxBP
    s.maxBP_z_1_3(i) = maxBP(ddz(x),1,3);
    s.maxBP_p_1_3(i) = maxBP(ddp(x),1,3);
    s.maxBP_r_1_3(i) = maxBP(ddr(x),1,3);
    
    s.maxBP_z_3_5(i) = maxBP(ddz(x),3,5);
    s.maxBP_p_3_5(i) = maxBP(ddp(x),3,5);
    s.maxBP_r_3_5(i) = maxBP(ddr(x),3,5);
    
    s.maxBP_z_5_7(i) = maxBP(ddz(x),5,7);
    s.maxBP_p_5_7(i) = maxBP(ddp(x),5,7);
    s.maxBP_r_5_7(i) = maxBP(ddr(x),5,7);
    
    s.maxBP_z_7_9(i) = maxBP(ddz(x),7,9);
    s.maxBP_p_7_9(i) = maxBP(ddp(x),7,9);
    s.maxBP_r_7_9(i) = maxBP(ddr(x),7,9);
    
    s.maxBP_z_9_11(i) = maxBP(ddz(x),9,11);
    s.maxBP_p_9_11(i) = maxBP(ddp(x),9,11);
    s.maxBP_r_9_11(i) = maxBP(ddr(x),9,11);
    
    s.maxBP_z_11_13(i) = maxBP(ddz(x),11,13);
    s.maxBP_p_11_13(i) = maxBP(ddp(x),11,13);
    s.maxBP_r_11_13(i) = maxBP(ddr(x),11,13);
    
    s.maxBP_z_13_15(i) = maxBP(ddz(x),13,15);
    s.maxBP_p_13_15(i) = maxBP(ddp(x),13,15);
    s.maxBP_r_13_15(i) = maxBP(ddr(x),13,15);
    
    s.maxBP_z_15_17(i) = maxBP(ddz(x),15,17);
    s.maxBP_p_15_17(i) = maxBP(ddp(x),15,17);
    s.maxBP_r_15_17(i) = maxBP(ddr(x),15,17);
    
    s.maxBP_z_17_19(i) = maxBP(ddz(x),17,19);
    s.maxBP_p_17_19(i) = maxBP(ddp(x),17,19);
    s.maxBP_r_17_19(i) = maxBP(ddr(x),17,19);
    
    s.maxBP_z_19_21(i) = maxBP(ddz(x),19,21);
    s.maxBP_p_19_21(i) = maxBP(ddp(x),19,21);
    s.maxBP_r_19_21(i) = maxBP(ddr(x),19,21);
    
end

end
