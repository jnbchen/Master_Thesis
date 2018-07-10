% Script callback_add_gaitcad_search_path
%
% The script callback_add_gaitcad_search_path is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

if  mode_searchpath == 4
   %reseting the permanent searchpath
   delete([parameter.allgemein.userpath filesep 'read_gaitcad_searchpath.m']);
end;

if mode_searchpath == 5
   %delete directories in a removable variable added temporarily in the
   %last Gait-CAD session
   try
      if isfield(parameter.allgemein,'userpath') && exist([parameter.allgemein.userpath filesep 'temp_searchpath.mat'],'file')
         load([parameter.allgemein.userpath filesep 'temp_searchpath.mat']);
         %reseting the local searchpath
         for i_path=1:length(temp_searchpath)
            rmpath(temp_searchpath{i_path});
         end;
         delete([parameter.allgemein.userpath filesep 'temp_searchpath.mat']);
      end;      
   end;
   clear mode_searchpath temp_searchpath;
   return;
end;

if mode_searchpath == 3 || mode_searchpath == 4
   %reseting the local searchpath
   for i_path=1:length(parameter.allgemein.gaitcad_searchpath)
      rmpath(parameter.allgemein.gaitcad_searchpath{i_path});
   end;
   parameter.allgemein.gaitcad_searchpath = {};
   next_function_parameter = '';
   % Plugins aktualisieren
   eval(gaitfindobj_callback('CE_PlugListUpdate'));
   
   return;
end;


%adds the path in add_gaitcad_searchpath to the matlabpath
if exist('next_function_parameter','var') && ~isempty(next_function_parameter)
   add_gaitcad_searchpath = next_function_parameter;
end;
next_function_parameter = '';


if ~exist('add_gaitcad_searchpath','var') || isempty(add_gaitcad_searchpath)
   add_gaitcad_searchpath = get_directory_name('Search path for m-files and plugins');
end;

%Cancel...
if isempty(add_gaitcad_searchpath)
   return;
end;

try
   if mode_searchpath == 1 || mode_searchpath == 2
      %temporary for the session
      parameter.allgemein.gaitcad_searchpath{end+1} = add_gaitcad_searchpath;
      parameter.allgemein.gaitcad_searchpath = unique(parameter.allgemein.gaitcad_searchpath);
      addpath(add_gaitcad_searchpath);
      
      % Plugins aktualisieren
      eval(gaitfindobj_callback('CE_PlugListUpdate'));
      
   end;
   if mode_searchpath == 1
      %in addition: permanent for the local Gait-CAD installation
      f = fopen([parameter.allgemein.userpath filesep 'read_gaitcad_searchpath.m'],'at');
      fprintf(f,'parameter.allgemein.gaitcad_searchpath{end+1} = ''%s'';\n',add_gaitcad_searchpath);
      fclose(f);
   else
      try
         %in a removable variable
         temp_searchpath = parameter.allgemein.gaitcad_searchpath;
         save([parameter.allgemein.userpath filesep 'temp_searchpath.mat'],temp_searchpath);
      end;
      
   end;
catch
   fclose('all');
   myerror(sprintf('The search path %s could not be added',add_gaitcad_searchpath));
end;
clear add_gaitcad_searchpath mode_searchpath f;
