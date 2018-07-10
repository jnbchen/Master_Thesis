  function [newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern)
% function [newlinestring,type] = getnewbatchline(f_batch,gaitcad_extern)
%
% 
% 
% type = -1 invalid
%      = 0 no string
%      = 1 directory
%      = 2 prjz file
%      = 3 uihdg file
%      = 4 makrog file
%      = 5 gaitbatch file
% 
% 
% 
%
% The function getnewbatchline is part of the MATLAB toolbox Gait-CAD. 
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

while 1
    %read a new line and check for the file type
    newlinestring = fgetl(f_batch);
    
    %End of file
    if ~ischar(newlinestring)
        type = 0;
        return;
    end;
    
    if ~isempty(deblank(newlinestring)) && ~strcmp(newlinestring(1),'%')
        break;
    end;
end;


newlinestring = deblank(newlinestring);

%recent working directory
if strcmp(newlinestring,'pwd')
    newlinestring = pwd;
end;

%project in the recent working directory
if length(newlinestring)>3 && strcmp(newlinestring(1:4),['pwd' filesep])
    newlinestring = [strrep(newlinestring(1:3),'pwd',pwd) newlinestring(4:end)];
end;

%recent project directory
if strcmp(newlinestring,'project_directory') && isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'project_directory') && ~isempty(gaitcad_extern.user.project_directory)
    newlinestring = gaitcad_extern.user.project_directory;
end;

%project in the recent project directory
if length(newlinestring)>17 && strcmp(newlinestring(1:18),['project_directory' filesep]) && isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'project_directory') && ~isempty(gaitcad_extern.user.project_directory)
    newlinestring = [strrep(newlinestring(1:17),'project_directory',gaitcad_extern.user.project_directory) newlinestring(18:end)];
end;

%project in the recent macro directory
if length(newlinestring)>15 && strcmp(newlinestring(1:16),['macro_directory' filesep]) && isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'macro_directory') && ~isempty(gaitcad_extern.user.macro_directory)
    newlinestring = [strrep(newlinestring(1:15),'macro_directory',gaitcad_extern.user.macro_directory) newlinestring(16:end)];
end;

%Directory
if exist(newlinestring,'dir')
    type = 1;
    return;
end;

%Command to change gaitcad_extern.user Variable
if ~isempty(strfind(newlinestring,'gaitcad_extern.user.'))
    type = 6;
    return;
end;

warning_mode = 0;
%dummy batch is the only possible value - here, a project is not necessary
if ~exist(newlinestring,'file') && isempty(strfind(newlinestring,'noproject.prjz'))
    mywarning(sprintf('A filename was expected in the batch file: %s.',newlinestring));
    warning_mode = 1;
end;

%extract extension
[pathstr,temp,extension] = fileparts(newlinestring);
if ~isempty(pathstr)
    if ~exist(pathstr,'dir')
        try
            %try to generate a non-existing directory (e.g., a project
            %directory)
            mkdir_gaitcad(pathstr);
        end;
    end;
    cd(pathstr);
end;

%get the full name if necessary
if isempty(strfind(newlinestring,'noproject.prjz')) && warning_mode == 0
    newlinestring_original = newlinestring;
    newlinestring = which(newlinestring);
    
    %overwrite with project directories etc. if necessary -
    %but only if the project does not contain a pathname!
    if isempty(pathstr) && isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'project_directory') && ~isempty(gaitcad_extern.user.project_directory) && ~isempty(strfind(newlinestring,'.prjz'))
        newlinestring = [gaitcad_extern.user.project_directory filesep newlinestring_original];
    end;
    
    %overwrite with project directories etc. if necessary-
    %but only if the project does not contain a pathname!
    if isempty(pathstr) && isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'macro_directory') && ~isempty(gaitcad_extern.user.macro_directory) && ~isempty(strfind(newlinestring,'.makrog'))
        newlinestring = [gaitcad_extern.user.macro_directory filesep newlinestring_original];
    end;
end;


%get file type
switch extension
    case '.prjz'
        type = 2;
    case '.uihdg'
        type = 3;
    case '.makrog'
        type = 4;
    case '.batch'
        type = 5;
    case '.m'
        type = 9;
    otherwise
        error('Unknown file type!');
end;



