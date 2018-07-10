% Script gaitbatch
%
% Example: gaitbatchfile = 'e:\rohdaten\eric\eric.batch';gaitbatch;
% Example: gaitbatchfile = 'E:\rohdaten\peptide\500_943_all.batch';gaitbatch
% 
%
% The script gaitbatch is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

if ~exist('gaitbatchfile','var') || ~exist(gaitbatchfile,'file') || isempty(strfind(gaitbatchfile,'.batch'))
    
    [gaitbatchfile,pfad]=uigetfile('*.batch','Load Gait-CAD batch file');
    gaitbatchfile = fullfile(pfad,gaitbatchfile);
else
    %look for existing fullpath
    mypath = fileparts(gaitbatchfile);
    if isempty(mypath)
        %if not look  in search path
        gaitbatchfile = which(gaitbatchfile);
    end;
end;

if ~exist(gaitbatchfile,'file')
    return;
end;


%change to the path of the batch file if necessary
mypath = fileparts(gaitbatchfile);

cd(mypath);

oldmatlabpath = matlabpath;
addpath(mypath);

%temporary save of filename, gaitcad deletes all variables and start Gait-CAD if necessary
hndl = findobj('type','figure');
if isempty(find(ismember(hndl,1))) || isempty(strfind(get(1,'name'),'Gait-CAD'))
    save f_batch gaitbatchfile oldmatlabpath
    gaitcad;
    load f_batch gaitbatchfile oldmatlabpath
    !del f_batch.mat
end;

gaitcad_extern.i_project = 0;
gaitcad_extern.path = mypath ;
gaitcad_extern.project = {};
gaitcad_extern.oldmatlabpath = oldmatlabpath;
gaitcad_extern.gaitcadpath = fileparts(which('gaitbatch'));

%project and macro directory must be defined in batch file and should not come from
%outside, otherwise corruption by older batches possible
if isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'project_directory') 
    gaitcad_extern.user = rmfield(gaitcad_extern.user,'project_directory');
end;
if isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'macro_directory') 
    gaitcad_extern.user = rmfield(gaitcad_extern.user,'macro_directory');
end;


%read batch file
temp_name = gaitbatchfile;
clear gaitbatchfile



gaitcad_extern = read_gait_batch(temp_name,gaitcad_extern);
clear temp_name;


%ignore errors
gaitcad_extern.makro_keyboard_stop = 0;
if exist('gaitdebug','var')  && gaitdebug >= 1
    gaitcad_extern.gaitdebug = 1;
    if gaitdebug == 2
        gaitcad_extern.makro_keyboard_stop = 1;
    end;
    dbstop if error;
    set(1,'userdata','gaitdebug');
else
    gaitcad_extern.gaitdebug = 0;
    set(1,'userdata','IgnoreErrors');
end;

%reset error messages
lasterr('');

%counter
gaitcad_extern.i_project = 0;

%batch marker
gaitcad_extern.batch_processing = 1;

%look for existing of macro path, this path will be added to the MATLAB
%search path
if isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'macro_directory') && ~isempty(gaitcad_extern.user.macro_directory)
    addpath(gaitcad_extern.user.macro_directory);
end;

%while loop due to if syntax problems
%outer loop for project blocks of gaitcad_extern
while 1
    
    %inner loop for files in a project block
    gaitcad_extern.i_project = gaitcad_extern.i_project + 1;
    gaitcad_extern.i_file    = 0;
    
    %ready if finished
    if gaitcad_extern.i_project> length(gaitcad_extern.project)
        break;
    end;
    
    %reread directory (if something has been changed meanwhile)
    if isfield(gaitcad_extern.project{gaitcad_extern.i_project},'master_directory')
        gaitcad_extern.project{gaitcad_extern.i_project}.project_list = getsubdir(gaitcad_extern.project{gaitcad_extern.i_project}.master_directory,'*.prjz',1);
    end;
    
    
    while 1
        
        gaitcad_extern.i_file = gaitcad_extern.i_file + 1;
        
        %ready if finished
        if gaitcad_extern.i_file> length(gaitcad_extern.project{gaitcad_extern.i_project}.project_list)
            break;
        end;
        
        try
            %load file
            datei_load = gaitcad_extern.project{gaitcad_extern.i_project}.project_list(gaitcad_extern.i_file).name;
            next_function_parameter = '';
            
            %load dummy file - important for macros with text imports or project fusion
            if ~isempty(strfind(datei_load,'noproject.prjz'))
                datei_load = [parameter.allgemein.pfad_gaitcad sprintf('%sprj%snoproject.prjz',filesep,filesep)];
            end;
            
            eval(gaitfindobj_callback('MI_Laden'));
        catch
            message_text = 'Open file :';
            error_message_batch(gaitcad_extern.path,gaitcad_extern.project{gaitcad_extern.i_project}.project_list(gaitcad_extern.i_file).name,message_text);
        end;
        
        
        try
            %load options
            gaitcad_extern.uihdg_filename = gaitcad_extern.project{gaitcad_extern.i_project}.uihdg_filename_persistent;
            if ~isempty(gaitcad_extern.uihdg_filename)
                eval(gaitfindobj_callback('MI_Einstellungen_laden'));
            end
        catch
            message_text = 'Load options :';
            error_message_batch(gaitcad_extern.path,gaitcad_extern.project{gaitcad_extern.i_project}.project_list(gaitcad_extern.i_file).name,message_text);
        end;
        
        %perform all macros
        
        gaitcad_extern.i_batch_macro = 0;
        while 1
            gaitcad_extern.i_batch_macro = gaitcad_extern.i_batch_macro +1;
            
            if gaitcad_extern.i_batch_macro> length(gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent)
                break;
            end;
            
            if gaitcad_extern.gaitdebug >0
                %special treatment for debug mode or keyboard stop - main idea
                %enable stop if error  without any try-catch-structures
                makro_datei = char(gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent(gaitcad_extern.i_batch_macro));
                [temp,temp,makro_extension] = fileparts(makro_datei);
                if isempty(strfind(makro_datei,'gaitcad_extern.user.'))
                    if isfield(gaitcad_extern,'makro_keyboard_stop') && gaitcad_extern.makro_keyboard_stop == 1
                        fprintf('Step modus Gait-CAD batch file: Keyboard stop before macro %s\n',makro_datei);
                        keyboard;
                    end;
                    switch makro_extension
                        case '.makrog'
                            eval(gaitfindobj_callback('MI_Makro_Ausfuehren'));
                        case '.m'
                            next_function_parameter = makro_datei;
                            eval(gaitfindobj_callback('MI_MFile_Ausfuehren'));
                            
                        otherwise
                            fprintf('Unexpected file type in %s',makro_datei);
                            
                    end;
                else
                    %assign variable gaitcad_extern.* saved in string
                    %makro_datei - be careful if you change this line
                    eval(makro_datei);
                end;
            else
                %standard mode without debugging - main idea
                %run over all errors without stop and protocol errors in error.log files
                
                try
                    makro_datei = char(gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent(gaitcad_extern.i_batch_macro));
                    [temp,temp,makro_extension] = fileparts(makro_datei);
                    if isempty(strfind(makro_datei,'gaitcad_extern.user.'))
                        switch makro_extension
                            case '.makrog'
                                eval(gaitfindobj_callback('MI_Makro_Ausfuehren'));
                            case '.m'
                                next_function_parameter = makro_datei;
                                eval(gaitfindobj_callback('MI_MFile_Ausfuehren'));
                            otherwise
                                fprintf('Unexpected file type in %s',makro_datei);
                                
                        end;
                    else
                        %assign variable gaitcad_extern.* saved in string
                        %makro_datei - be careful if you change this line
                        eval(makro_datei);
                    end;
                catch
                    message_text = ['Macro : ' char(gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent(gaitcad_extern.i_batch_macro))];
                    error_message_batch(gaitcad_extern.path,gaitcad_extern.project{gaitcad_extern.i_project}.project_list(gaitcad_extern.i_file).name,message_text);
                end;
            end;
        end;
    end;
end;

%ready, no batch processing in open project
gaitcad_extern.batch_processing = 0;
parameter.allgemein.no_update_reading = 0;

set(1,'userdata','');
matlabpath(gaitcad_extern.oldmatlabpath);


