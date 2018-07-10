% Script execute_macro_inside_macro
%
% look if macro name exist
%
% The script execute_macro_inside_macro is part of the MATLAB toolbox Gait-CAD. 
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

if exist('next_function_parameter','var') && ~isempty(strfind(next_function_parameter,'.makrog'))
   
   %get full path
   next_function_parameter_fullpath = which(next_function_parameter);
   
   %not in the current directory, check for standardmakro directory ...
   if isempty(next_function_parameter_fullpath)
      
      %.. of Gait-CAD
      temp_name = [parameter.allgemein.pfad_gaitcad filesep 'standardmakros' filesep next_function_parameter];
      if exist(temp_name,'file')
         next_function_parameter_fullpath = temp_name;
      else
         %.. of extension packages of Gait-CAD
         for i_appl = 1:length(parameter.allgemein.appl_specials.name)
            temp_name = [parameter.allgemein.pfad_gaitcad filesep 'application_specials' filesep parameter.allgemein.appl_specials.name{i_appl} filesep 'standardmakros' filesep next_function_parameter];
            if exist(temp_name,'file')
               next_function_parameter_fullpath = temp_name;
               break;
            end;
         end;
      end;
   end;
   
   %nothing found
   if isempty(next_function_parameter_fullpath)
      errorstring = sprintf('Macro %s not found!',next_function_parameter);
      clear temp_name mfilename_fullpath next_function_parameter_fullpath mfilename
      next_function_parameter = '';
      myerror(errorstring);
   end;
   
   %prepare name of an excutable file in the current working directory
   [temp_name,mfilename] = fileparts(next_function_parameter_fullpath);
   mfilename_fullpath = [pwd filesep mfilename '.m'];
   
   %name exist before, could be a problem with recursive calls or former
   %stopped executions
   if exist(mfilename_fullpath,'file')
      delete(mfilename_fullpath);
      errorstring = strcat('A macro can non called recursively.',sprintf('%s was deleted.',mfilename_fullpath));
      clear temp_name mfilename_fullpath next_function_parameter_fullpath mfilename
      next_function_parameter = '';
      myerror(errorstring);
   end;
   
   %copy .makrog to m file in working directory
   copyfile(next_function_parameter_fullpath,mfilename_fullpath);
   try
      %evalauate m file in working directory
      eval(mfilename);
   catch
      errorstring = sprintf('Error by executing a macro (%s)! The m file could not be executed.',mfilename);
      clear temp_name mfilename_fullpath next_function_parameter_fullpath mfilename
      next_function_parameter = '';
      myerror(errorstring);
   end;
   delete(mfilename_fullpath);
end;
clear temp_name mfilename_fullpath next_function_parameter_fullpath mfilename
next_function_parameter = '';