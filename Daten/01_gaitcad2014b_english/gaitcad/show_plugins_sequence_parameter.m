% Script show_plugins_sequence_parameter
%
% name for the temporary file with the sequence parameter list 
%
% The script show_plugins_sequence_parameter is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

sequence_filename = [parameter.allgemein.pfad_temp filesep 'mysequence.txt'];
f_list = fopen(sequence_filename,'wt');

%run over all plugins in a sequence
for i_plugin = 1: length(plugins.mgenerierung_plugins.sequence.command_line)
   
   %Header 
   fprintf(f_list,'\n\nPlugin %d: %s\n',i_plugin, plugins.mgenerierung_plugins.full_string(plugins.mgenerierung_plugins.sequence.plugins(i_plugin),:));
      
   %run over parameters
   for i_plugin_parameter = 1:length(plugins.mgenerierung_plugins.sequence.command_line{i_plugin}.description)
      
      %convert numbers to strings if necessary
      temp_parameter = plugins.mgenerierung_plugins.sequence.command_line{i_plugin}.parameter_commandline{i_plugin_parameter};
      if isnumeric(temp_parameter)
         temp_parameter = sprintf('%g',temp_parameter);
      end;
      
      %plot parameter names and values
      fprintf(f_list,'%3d: %-50s %s\n',...
         i_plugin_parameter, ...
         plugins.mgenerierung_plugins.sequence.command_line{i_plugin}.description{i_plugin_parameter},...
         temp_parameter);
   end;
end;

%close file if it is not the MATLAB command window output
if f_list>1
   fclose(f_list);
end;

%show file
if parameter.allgemein.makro_ausfuehren==0
   viewprot(sequence_filename);
end;

%clean up
clear f_list sequence_filename temp_parameteri_plugin
