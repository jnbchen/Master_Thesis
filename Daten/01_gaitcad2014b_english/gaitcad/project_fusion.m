% Script project_fusion
%
% avoid recursive adding of fusion projects
%
% The script project_fusion is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
% 
% This program is free software; you can redistribute it and/or modify,
% it under the terms of the GNU General Public License as published by 
% the Free Software Foundation; either version 2 of the License, or any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along with this program;
% if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
% You will find further information about Gait-CAD in the manual or in the following conference paper:
% 
% MIKUT, R.; BURMEISTER, O.; BRAUN, S.; REISCHL, M.: The Open Source Matlab Toolbox Gait-CAD and its Application to Bioelectric Signal Processing.  
% In:  Proc., DGBMT-Workshop Biosignal processing, Potsdam, pp. 109-111; 2008 
% Online available: https://sourceforge.net/projects/gait-cad/files/mikut08biosig_gaitcad.pdf/download
% 
% Please refer to this paper, if you use Gait-CAD for your scientific work.

if ~isempty(next_function_parameter)
    input_path = next_function_parameter;
    next_function_parameter ='';
end;

if (~exist('input_path','var') || isempty(input_path)) && (~exist('input_projects','var') || isempty(input_projects))
    global import_gui;
    input_path = get_directory_name('Choose directory or TXT-File containing projects to be merged');
    if ~isdir(input_path)
        input_projects=input_path;
    end;
    if isempty(input_path)
        return;
    end;
end;


if exist('input_projects','var') && ~isempty(input_projects) %Erwartet optional eine Datei mit Project-Namen mode_new_project muss auch manuell gesetzt sein
    try
        f=fopen(input_projects);
        entries=textscan(f,'%s','delimiter', '\n');
        entries=entries{1};
        fclose(f);
        file_list=cell2struct(entries,{'name'},2);
        [input_path,filter_file,filter_extension]= fileparts(input_projects);
        start_dir=pwd;
    catch
        myerror(strcat('Illegal list of projects. Please choose a ASCII file containing one project in each line including the hole path.',input_path));
        clear input_projects
        clear input_path
    end
    
else
    
    if ~isdir(input_path)
        [input_path,filter_file,filter_extension]= fileparts(input_path);
    else
        filter_file ='';
        filter_extension='';
        
    end;
    
    if isempty(input_path) || ~isdir(input_path)
        myerror(strcat('Invalid directory',input_path));
    end;
    
    if isempty(filter_file)
        filter_file = '*';
    end;
    
    if isempty(filter_extension)
        filter_extension = '.prjz';
    end;
    
    %read all projekt files from a directory
    if ~exist('file_list','var')
        file_list= getsubdir(input_path,[filter_file filter_extension],1);
    end;
    
end;

delete_fusion_ind = zeros(length(file_list),1);
for i=1:length(file_list)
    delete_fusion_ind(i) = ~isempty(strfind(file_list(i).name,'fusion.prjz'));
end;
delete_fusion_ind = find(delete_fusion_ind);
if ~isempty(delete_fusion_ind)
    file_list(delete_fusion_ind) = [];
end;


if isempty(file_list)
    myerror('No related files found!');
end;

fusion_parameter_set = [];
switch mode_new_project
    case {3,4}
        %get all keys
        [key_list,ind_i,ind_j] = unique({zgf_y_bez(par.y_choice,unique(code_alle(ind_auswahl,par.y_choice))).name});
        fusion_parameter_set.key_list = string2cell(char(key_list),1);
        fusion_parameter_set.key_name = deblank(bez_code(par.y_choice,:));
end;

%must be saved separately to avoid changing options
fusion_parameter_set.project_names_fusion = parameter.gui.allgemein.project_names_fusion;

d_orgs_all    = [];
var_bez_all   = [];
dorgbez_all   = [];
d_org_all     = [];
d_image_all   = [];
code_alle_all = [];
code_all      = [];
i_file        = 1;
zgf_y_bez_all = [];
bez_code      = [];
zgf_y_bez_all = [];
bez_code_all  = [];


cd(input_path);
gaitcad_extern.temp_file = [input_path filesep 'newproject_temp.mat'];
gaitcad_extern.fusion_file = [input_path filesep 'fusion.prjz'];
gaitcad_extern.fusion_protocol_file_name = [input_path filesep 'fusion_protocol.prot'];
gaitcad_extern.no_plugin_update = 1;
save(gaitcad_extern.temp_file,'file_list','d_orgs_all','var_bez_all','dorgbez_all','d_org_all','code_alle_all','code_all',...
    'i_file','mode_new_project','zgf_y_bez_all','d_image_all','fusion_parameter_set','bez_code_all');



while 1
    
    datei_load = file_list(i_file).name;
    
    
    parameter.allgemein.makro_ausfuehren = 1;
    try
        ldprj_g;
        parameter.allgemein.makro_ausfuehren = 0;
        load(gaitcad_extern.temp_file);
        
        %internal variable to detect errors in the recent file
        error_mode = 0;
    catch
        load(gaitcad_extern.temp_file);
        error_mode = 1;
        mywarning(sprintf('Invalid project %s!',file_list(i_file).name));
    end;
    
    switch mode_new_project
        
        
        case 1
            %add new project data as additional time series and single features
            
            if i_file>1
                
                if size(d_orgs,1)~=size(d_orgs_all,1)
                    mywarning('The number of data points must be equal!');
                    error_mode = 1;
                    
                end;
                if size(d_orgs,2)~=size(d_orgs_all,2)
                    mywarning('The length of time series must be equal!');
                    error_mode = 1;
                    
                end;
                
                if any(code ~= code)
                    mywarning('Class codes must be equal!');
                    error_mode = 1;
                    
                end;
                if size(code_alle,2)~=size(code_alle_all,2)
                    mywarning('The number of output variables must be equal!');
                    error_mode = 1;
                    
                end;
                
                if any(any(code_alle ~= code_alle_all))
                    mywarning('Class codes must be equal!');
                    error_mode = 1;
                    
                end;
            else
                d_orgs_all           = zeros(size(d_orgs,1),size(d_orgs,2),0);
                d_image_all.data     = zeros(size(d_orgs,1),0);
                d_image_all.filelist = {};
                d_image_all.names    = [];
                
            end;
            
            if error_mode == 0
                d_orgs_all (:,:,(end+1):(end+size(d_orgs,3)))= d_orgs;
                d_org_all  (:,  (end+1):(end+size(d_org,2))) = d_org;
                code_alle_all = code_alle;
                if fusion_parameter_set.project_names_fusion == 1
                    var_bez_all   = strvcatnew(var_bez_all,[char(ones(par.anz_merk,1)*[abs(datei) 32]) var_bez(1:par.anz_merk,:)]);
                    dorgbez_all   = strvcatnew(dorgbez_all,[char(ones(par.anz_einzel_merk,1)*[abs(datei) 32]) dorgbez(1:par.anz_einzel_merk,:)]);
                else
                    var_bez_all   = strvcatnew(var_bez_all,var_bez(1:par.anz_merk,:));
                    dorgbez_all   = strvcatnew(dorgbez_all,dorgbez(1:par.anz_einzel_merk,:));
                end;
                
                zgf_y_bez_all = zgf_y_bez;
                par_all = par;
                bez_code_all = bez_code;
                
            end;
        case 2
            %add new project data as additional data points
            
            if i_file>1
                
                if size(d_orgs,2)~=size(d_orgs_all,2)
                    mywarning(strcat('The length of time series must be equal!','The time series length are automatically matched by pressing Continue.'));
                    if size(d_orgs,2)>size(d_orgs_all,2)
                        d_orgs_all(:,end+[1:(size(d_orgs,2)-size(d_orgs_all,2))],:) = NaN;
                    else
                        d_orgs(:,end+[1:(size(d_orgs_all,2)-size(d_orgs,2))],:) = NaN;
                    end;
                    
                end;
                if error_mode == 0 && size(d_orgs,3)~=size(d_orgs_all,3)
                    mywarning('The number of time series must be equal!');
                    error_mode = 1;
                    
                end;
                if error_mode == 0 && size(d_org,2)~=size(d_org_all,2)
                    mywarning('The number of single features must be equal!');
                    error_mode = 1;
                    
                end;
                if error_mode == 0 && size(code_alle,2)~=size(code_alle_all,2)-1
                    mywarning('The number of output variables must be equal!');
                    error_mode = 1;
                    
                end;
                if error_mode == 0 && ~isempty(d_image) && size(d_image.data,2)~=size(d_image_all.data,2)
                    mywarning('The number of images must be equal!');
                    error_mode = 1;
                    
                end;
                if error_mode == 0 &&  ~isempty(dorgbez_all) && (any(size(dorgbez) ~= size(dorgbez_all)) || any(any(deblank(dorgbez) ~= deblank(dorgbez_all))))
                    mywarning('The names of single features must be the same!');
                    error_mode = 1;
                    
                end;
                if error_mode == 0 && ~isempty(var_bez_all) && (any(size(var_bez) ~= size(var_bez_all)) || any(any(deblank(var_bez) ~= deblank(var_bez_all))))
                    mywarning('The names of time series must be the same!');
                    error_mode = 1;
                    
                end;
                if error_mode == 0 && ~isempty(d_image_all.names) && (any(size(d_image.names) ~= size(d_image_all.names)) || any(any(d_image.names ~= d_image_all.names)))
                    mywarning('The names of the images must be equal!');
                    error_mode = 1;
                    
                end;
                
                
                if error_mode == 0
                    zgf_y_bez_all(end,i_file).name = file_list(i_file).name;
                end;
                
            else
                d_orgs_all = zeros(0,size(d_orgs,2),size(d_orgs,3));
                bez_code_all   = strvcatnew(bez_code,'File');
                zgf_y_bez_all = zgf_y_bez;
                zgf_y_bez_all(end+1,i_file).name = file_list(i_file).name;
                par_all = par;
                
                d_image_all.data = zeros(0,size(d_image.data,2),size(d_image.data,3),size(d_image.data,4));
                d_image_all.filelist = d_image.filelist;
                d_image_all.names = d_image.names;
            end;
            
            if error_mode == 0
                
                %HANDLING OF OUTPUT TERMS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for i=1:size(zgf_y_bez,1)
                    
                    %which output terms exist in both variables and where they are
                    [temp_bez,ind_bez,ind_bez_neu]=intersect({zgf_y_bez(i,1:par.anz_ling_y(i)).name},{zgf_y_bez_all(i,1:par_all.anz_ling_y(i)).name});
                    
                    %write a decoding table for the conversion to the term numbers in all
                    umkodierungstabelle=zeros(par.anz_ling_y(i),1);
                    umkodierungstabelle(ind_bez)=ind_bez_neu;
                    
                    %find new terms
                    ind_new = find(umkodierungstabelle==0);
                    %append these new terms
                    zgf_y_bez_all(i,par_all.anz_ling_y(i)+[1:length(ind_new)]) = zgf_y_bez(i,ind_new);
                    %new code
                    umkodierungstabelle(ind_new) = par_all.anz_ling_y(i)+[1:length(ind_new)];
                    
                    %apply modified term numbers
                    code_alle(:,i) = umkodierungstabelle(code_alle(:,i));
                    par_all.anz_ling_y(i) = par_all.anz_ling_y(i)+length(ind_new);
                end;
                
                
                
                d_orgs_all ((end+1):(end+size(d_orgs,1)),:,:)= d_orgs;
                d_org_all  ((end+1):(end+size(d_org,1)),:) = d_org;
                code_alle_all = [code_alle_all;code_alle i_file*ones(size(code_alle,1),1)];
                var_bez_all   = var_bez;
                dorgbez_all   = dorgbez;
            end;
            
        case {3,4}
            %"intelligent" fusion by appending new project data as additional time series, single features, and images
            %the selected output variable is chosen as key
            
            %select the output variable
            y_choice = getfindstr(bez_code,fusion_parameter_set.key_name,1);
            
            if isempty(y_choice)
                mywarning(sprintf('Output variable %s for fusion in project %s.prjz not found!',fusion_parameter_set.key_name,[pwd filesep parameter.projekt.datei]));
                error_mode = 1;
            else
                
                par.y_choice = max(y_choice);
                
                %write all term names in a cell array but without blanks :-)
                outputterm_list = string2cell(char({zgf_y_bez(par.y_choice,code_alle(:,par.y_choice)).name}),1);
                
                %compare the keys - must be contained in both projects, all other keys are deleted
                if mode_new_project == 3
                    [fusion_parameter_set.key_list,ind_keys,ind_auswahl] = intersect(fusion_parameter_set.key_list,outputterm_list);
                    ind_keys = generate_rowvector(ind_keys);
                    ind_auswahl = generate_rowvector(ind_auswahl);
                end;
                
                
                if mode_new_project == 4
                    %here, the key list is not reduced in case of missing data points!!!
                    [temp,ind_keys,ind_auswahl] = intersect(fusion_parameter_set.key_list,outputterm_list);
                    ind_keys = generate_rowvector(ind_keys);
                    ind_auswahl = generate_rowvector(ind_auswahl);
                    
                    %set non-fitting values to NaN
                    
                    %identify non-fitting values
                    ind_nonfitting = setdiff(1:length(fusion_parameter_set.key_list),ind_keys);
                    
                    if ~isempty(d_orgs)
                        d_orgs       (par.anz_dat + [1:length(ind_nonfitting)],:,:) = NaN;
                    else
                        %special handling of empty matrices, the NaN update does not work here
                        d_orgs = zeros(par.anz_dat + length(ind_nonfitting),size(d_orgs_all,2),0);
                    end;
                    
                    if ~isempty(d_org)
                        d_org        (par.anz_dat + [1:length(ind_nonfitting)],:)   = NaN;
                    else
                        %special handling of empty matrices, the NaN update does not work here
                        d_org   = zeros(par.anz_dat + length(ind_nonfitting),0);
                    end;
                    
                    
                    %empty images
                    if ~isempty(d_image.data)
                        d_image.data (par.anz_dat + [1:length(ind_nonfitting)],:)   = 0;
                    end;
                    if size(d_image.data,2) == 0
                        d_image.data = zeros(par.anz_dat+length(ind_nonfitting),0);
                        d_image.names ='';
                    end;
                    
                    
                    for i_code = 1:par.anz_y
                        code_alle  (par.anz_dat + [1:length(ind_nonfitting)],i_code) = par.anz_ling_y(i_code) +1;
                        zgf_y_bez (i_code,par.anz_ling_y(i_code) +1).name = 'unknown';
                    end;
                    
                    
                    ind_keys     = [ind_keys ind_nonfitting];
                    
                    fusion_parameter_set.key_list = fusion_parameter_set.key_list(ind_keys);
                    
                    %add the new non-fitting Nan elements to the selected data points
                    ind_auswahl  = [ind_auswahl  [par.anz_dat+[1:length(ind_nonfitting)]]];
                    
                end;
                
                
                if i_file>1
                    
                    %fitting time series length if necessary
                    if size(d_orgs,2)>size(d_orgs_all,2)
                        if ~isempty(d_orgs_all)
                            d_orgs_all(:,size(d_orgs_all,2)+1:size(d_orgs,2),:) = NaN;
                        else
                            d_orgs_all = zeros(size(d_orgs_all,1),size(d_orgs,2),0);
                        end;
                    end;
                    if size(d_orgs,2)<size(d_orgs_all,2)
                        if ~isempty(d_orgs)
                            d_orgs(:,size(d_orgs,2)+1:size(d_orgs_all,2),:) = NaN;
                        else
                            d_orgs = zeros(size(d_orgs,1),size(d_orgs_all,2),0);
                        end;
                    end;
                    
                    %resort resp. delete non-fitting values
                    d_org_all            = d_org_all(ind_keys,:,:);
                    d_orgs_all           = d_orgs_all(ind_keys,:,:);
                    d_image_all.data     = d_image_all.data(ind_keys,:);
                    code_alle_all        = code_alle_all(ind_keys,:);
                    
                    zgf_y_bez_all (end+[1:size(zgf_y_bez,1)],[1:size(zgf_y_bez,2)]) = zgf_y_bez;
                else
                    
                    %no tests necessary
                    d_orgs_all           = zeros(length(ind_auswahl),size(d_orgs,2),0);
                    d_image_all.data     = zeros(length(ind_auswahl),0,size(d_image.data,3),size(d_image.data,4));
                    %d_image_all.data     = zeros(size(d_image.data));
                    d_image_all.filelist = {};
                    d_image_all.names    = [];
                    zgf_y_bez_all = zgf_y_bez;
                    
                    
                    if fusion_parameter_set.project_names_fusion == 1
                        bez_code = [char(ones(par.anz_y,1)*[abs(datei) 32]) bez_code];
                    end;
                    
                end;
                
                d_orgs_all (:,:,(end+1):(end+size(d_orgs,3)))= d_orgs(ind_auswahl,:,:);
                d_org_all  (:,  (end+1):(end+size(d_org,2))) = d_org(ind_auswahl,:);
                code_alle_all = [code_alle_all code_alle(ind_auswahl,:)];
                
                if fusion_parameter_set.project_names_fusion == 1
                    %append names incl. file name
                    
                    var_bez_all   = strvcatnew(var_bez_all,[char(ones(par.anz_merk,1)*[abs(datei) 32]) var_bez(1:par.anz_merk,:)]);
                    dorgbez_all   = strvcatnew(dorgbez_all,[char(ones(par.anz_einzel_merk,1)*[abs(datei) 32]) dorgbez(1:par.anz_einzel_merk,:)]);
                    bez_code_all  = strvcatnew(bez_code_all,[char(ones(par.anz_y,1)*[abs(datei) 32]) bez_code]);
                else
                    %append names without file name
                    var_bez_all   = strvcatnew(var_bez_all,var_bez(1:par.anz_merk,:));
                    dorgbez_all   = strvcatnew(dorgbez_all,dorgbez(1:par.anz_einzel_merk,:));
                    bez_code_all  = strvcatnew(bez_code_all,bez_code);
                end;
                
                par_all = par;
            end;
            
    end;
    
    
    
    if error_mode == 0
        
        %HANDLING OF IMAGES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %matching of output terms
        if ~isempty(d_image.filelist)
            
            
            %which filenames exist in both variables and where they are
            [temp_bez,ind_bez,ind_bez_neu]=intersect(d_image.filelist,d_image_all.filelist);
            
            %write a decoding table for the conversion to the term numbers in all
            umkodierungstabelle=zeros(length(d_image.filelist),1);
            umkodierungstabelle(ind_bez)=ind_bez_neu;
            
            %find new terms
            ind_new = find(umkodierungstabelle==0);
            %new code
            umkodierungstabelle(ind_new) = length(d_image_all.filelist)+[1:length(ind_new)];
            %append these new filenames
            d_image_all.filelist = [d_image_all.filelist; d_image.filelist(ind_new)];
        end;
        
        ind = find(d_image.data);
        if ~isempty(ind)
            %new numbers for image files
            try
                d_image.data(ind) = umkodierungstabelle(d_image.data(ind));
            catch
                myerror('Error in image fusion (e.g., link to non-existing images?)!');
            end;
        end;
        
        %apply modified file numbers
        switch mode_new_project
            case 1
                %new images
                d_image_all.data = [d_image_all.data d_image.data];
                if fusion_parameter_set.project_names_fusion == 1
                    d_image_all.names = strvcatnew(d_image_all.names,[char(ones(par.anz_y,1)*[abs(datei) 32]) d_image.names]);
                else
                    d_image_all.names = strvcatnew(d_image_all.names,d_image.names);
                end;
            case 2
                %append new image numbers
                d_image_all.data = [d_image_all.data; d_image.data];
            case {3,4}
                %append new image numbers - but only selected data points
                
                d_image_all.data = [d_image_all.data d_image.data(ind_auswahl,:)];
                if fusion_parameter_set.project_names_fusion == 1
                    d_image_all.names = strvcatnew(d_image_all.names,[char(ones(par.anz_y,1)*[abs(datei) 32]) d_image.names]);
                else
                    d_image_all.names = strvcatnew(d_image_all.names,d_image.names);
                end;
                
        end;
    end;
    
    fusion_protocol_file = fopen(gaitcad_extern.fusion_protocol_file_name,'at');
    if i_file == 1
        mytime = clock;
        fprintf(fusion_protocol_file,'\n\n%02d.%02d.%02d, %02d:%02d:%02.0f: Fusion:\n',mytime([3 2 1 4 5 6]));
    end;
    switch error_mode
        case 0
            success_message = 'successful';
        otherwise
            success_message = 'not successful';
    end;
    fboth(fusion_protocol_file,'Fusion: %d/%d: %s\n',i_file,length(file_list),[file_list(i_file).name ' ' success_message]);
    fboth(fusion_protocol_file,'%d Data points, %d Single features, %d Time series (Length %d), %d Output variables, %d Images\n',size(d_org),size(d_orgs,3),size(d_orgs,2),size(code_alle,2),size(d_image.data,2));
    fclose(fusion_protocol_file);
    
    %file counter
    i_file=i_file+1;
    
    %update temporary file
    save(gaitcad_extern.temp_file,'file_list','d_orgs_all','var_bez_all','dorgbez_all','d_org_all','code_alle_all','code_all','i_file','mode_new_project','zgf_y_bez_all','d_image_all',...
        'par_all','fusion_parameter_set','bez_code_all');
    
    %all files imported?
    if i_file>length(file_list)
        break;
    end;
    
end;

%convert to regular project file
d_orgs    = d_orgs_all;
var_bez   = var_bez_all;
dorgbez   = dorgbez_all;
d_org     = d_org_all;
d_image   = d_image_all;
code_alle = code_alle_all;
code      = code_alle(:,1);
zgf_y_bez = zgf_y_bez_all;
bez_code  = bez_code_all;

%save project information (use the one from the first file)
projekt = '';
load(file_list(1).name,'-mat','projekt');

if exist('input_projects','var') %switch to start dir in case of a given project_list
    cd(start_dir);
end;
save(gaitcad_extern.fusion_file,'-mat','d_orgs','var_bez','dorgbez','d_org','d_image','code_alle','code','file_list','zgf_y_bez','bez_code','zgf_y_bez','projekt');

clear button input_path

datei_load = gaitcad_extern.fusion_file;
gaitcad_extern.no_plugin_update = 0;
ldprj_g;

