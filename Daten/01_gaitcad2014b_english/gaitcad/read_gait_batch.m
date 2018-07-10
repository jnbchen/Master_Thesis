  function gaitcad_extern = read_gait_batch(gaitbatchfile,gaitcad_extern)
% function gaitcad_extern = read_gait_batch(gaitbatchfile,gaitcad_extern)
%
% 
% 
%
% The function read_gait_batch is part of the MATLAB toolbox Gait-CAD. 
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

f_batch = fopen(gaitbatchfile,'rt');

if f_batch == -1
    myerror('File %s not found.\n',gaitbatchfile);
end;


fprintf('Checking entries in Gait-CAD batch file...\n');


%next line
[newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern);

while 1
    
    
    %end of file or invalid
    if type == 0
        break;
    end;
    
    i_file = 1;
    
    last_file_was_batch_file = 0;
    
    %RECURSIVE CALL OF ANOTHER GAIT-BATCH FILE?
    if type == 5
        gaitcad_extern = read_gait_batch(newlinestring,gaitcad_extern);
        %next line
        [newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern);
        %end of file or invalid
        if type == 0
            break;
        end;
        last_file_was_batch_file = 1;
        
        
    else
        if type~=1 && type~=2 && type~=6
            fclose(f_batch);
            myerror(['Project file or path were expected' sprintf(' (%s)',newlinestring)]);
        end;
        
        %new project or new directory
        gaitcad_extern.i_project = gaitcad_extern.i_project + 1;
    end;
    
    
    %DIRECTORY?
    if type == 1
        cd(newlinestring);
        gaitcad_extern.project{gaitcad_extern.i_project}.master_directory = newlinestring;
        gaitcad_extern.project{gaitcad_extern.i_project}.project_list     = getsubdir(newlinestring,'*.prjz',1);
        fprintf('Path %s ready...\n',newlinestring);
        i_file = length(gaitcad_extern.project{gaitcad_extern.i_project}.project_list)+1;
        %next line
        [newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern);
    end;
    
    
    
    %PROJECT FILE ?
    if type == 2
        while 1
            
            %write the name
            gaitcad_extern.project{gaitcad_extern.i_project}.project_list(i_file).name = newlinestring;
            fprintf('Project %s ready...\n',gaitcad_extern.project{gaitcad_extern.i_project}.project_list(i_file).name);
            i_file = i_file +1;
            
            
            %next line
            [newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern);
            
            if type ~= 2
                break;
            end;
        end;
    end;
    
    % OPTION FILE?
    if type == 3
        gaitcad_extern.project{gaitcad_extern.i_project}.uihdg_filename_persistent = newlinestring;
        fprintf('Option file %s ready...\n',gaitcad_extern.project{gaitcad_extern.i_project}.uihdg_filename_persistent);
        
        
        %next line
        [newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern);
    else
        if type~=5
            gaitcad_extern.project{gaitcad_extern.i_project}.uihdg_filename_persistent = '';
        end;
        
    end;
    
    %MACRO FILES OR VARIABLE DEFINITION?
    if type == 4 || type == 6 || type == 9
        i_macro = 1;
        while 1
            
            gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent{i_macro} = newlinestring;
            switch type
                case 4
                    fprintf('Read macro %s ...\n',gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent{i_macro});
                case 6
                    fprintf('Read variable assignment %s...\n',gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent{i_macro});
                    eval(gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent{i_macro});
                case 9
                    fprintf('Read M-file %s...\n',gaitcad_extern.project{gaitcad_extern.i_project}.macro_file_persistent{i_macro});
            end;
            
            
            i_macro = i_macro + 1;
            
            %next line
            [newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern);
            
            if (type ~= 4) && (type ~= 6) && (type ~= 9)
                break;
            end;
        end;
    else
        %only one possible case: a batch file followed by another batch file
        if type~= 5 || last_file_was_batch_file == 0
            fclose(f_batch);
            myerror(['Macro file was expected' sprintf(' (%s)',newlinestring)])
        end;
    end;
    
    
    
end;
fprintf('Entries Gait-CAD batch file checked!\n');

fclose(f_batch);