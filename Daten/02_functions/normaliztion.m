clear all
clc

load pasv_testA2_.mat;
data1 = table2array(T1);
load pasv_testA3_.mat;
data2 = table2array(T1);

project_name1 = 'pasv_test_A2_n.prjz';
project_name2 = 'actv_test_A3_n.prjz';

norm1 = zeros(1580,94);
for k = 1:94
    norm1(:,k) = (data1(:,k)-min(data1(:,k)))./(max(data1(:,k))-min(data1(:,k)));
end

norm2 = zeros(1580,94);
for k = 1:94
    norm2(:,k) = (data2(:,k)-min(data2(:,k)))./(max(data2(:,k))-min(data2(:,k)));
end

code_alle = data1(:,end);
bez_code = 'event';
zgf_y_bez(1,1).name = 'asphalt';
zgf_y_bez(1,2).name = 'pothole';
zgf_y_bez(1,3).name = 'manhole';
zgf_y_bez(1,4).name = 'cobbled';
zgf_y_bez(1,5).name = 'railway';
zgf_y_bez(1,6).name = 'unevenness';
d_org1 = norm1;
d_org2 = norm2;
dorgbez = char(T1.Properties.VariableNames(1:end-1));
generate_new_scixminer_project(project_name1,code_alle,bez_code,zgf_y_bez,d_org1,dorgbez,[],[],[],[]);
generate_new_scixminer_project(project_name2,code_alle,bez_code,zgf_y_bez,d_org2,dorgbez,[],[],[],[]);


% project_name_norm = ['project_active_test_norm.prjz'];
% d_org_norm = norm(:,1:end-1);
% generate_new_scixminer_project(project_name_norm,code_alle,bez_code,zgf_y_bez,d_org_norm,dorgbez,[],[],[],[]);


%save('road_profile1','road');
%print = [r',road(1,:)',road(2,:)'];

%fileID = fopen('road_profile1.txt','w');
%fprintf(fileID,'%1s %1s %1s\r\n','r','h1','h2');
%fprintf(fileID,'%4.10f %4.10f %4.10f\n',print');
%fclose(fileID);