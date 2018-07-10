% Script callback_save_commandline_val
%
% callback for the commandline field
%
% The script callback_save_commandline_val is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

hndl_commandline = findobj('tag','CE_Auswahl_PluginsCommandLine');

%check consistency
mycommandline = checkvalidcommandline(plugins,parameter);
if isempty(mycommandline)
   return;
end;


%look for integer restriction and correct the value if necessary
if isfield(mycommandline,'format') && strcmp(mycommandline.format{parameter.gui.merkmalsgenerierung.plug_par_number},'any')
   %no format restriction:
   %update the related command line value if the format is compatible
   plugins.mgenerierung_plugins.sequence.command_line{plugins.mgenerierung_plugins.sequence.pos(1)}.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number} = ...
      parameter.gui.merkmalsgenerierung.plug_commandline;
else
   
   %handling of popup strings - the string is written to the commandline
   %variable
   if mycommandline.ispopup{parameter.gui.merkmalsgenerierung.plug_par_number} == 1
      temp_string = get(hndl_commandline,'string');
      parameter.gui.merkmalsgenerierung.plug_commandline = get(hndl_commandline,'value');
      %save popup value
      mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number} = parameter.gui.merkmalsgenerierung.plug_commandline;
      if plugins.sequence_field == 0
         %save plugin list parameter
         plugins.mgenerierung_plugins.info(plugins.ind_listbox(1)).commandline = mycommandline;
      else
         %save plugin sequence parameter
         plugins.mgenerierung_plugins.sequence.command_line{plugins.mgenerierung_plugins.sequence.pos(1)} =  mycommandline;
      end;
      return;
   end;
   
   
   %compatibility check
   if (ischar(parameter.gui.merkmalsgenerierung.plug_commandline) && ...
         ischar(mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number})) || ...
         (isnumeric(parameter.gui.merkmalsgenerierung.plug_commandline) && ...
         isnumeric(mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number}))
      
      
      %look for integer restriction and correct the value if necessary
      if isfield(mycommandline,'ganzzahlig') && ~isempty(mycommandline.ganzzahlig{parameter.gui.merkmalsgenerierung.plug_par_number}) && mycommandline.ganzzahlig{parameter.gui.merkmalsgenerierung.plug_par_number} == 1
         parameter.gui.merkmalsgenerierung.plug_commandline = round(parameter.gui.merkmalsgenerierung.plug_commandline);
         set(hndl_commandline,'string',parameter.gui.merkmalsgenerierung.plug_commandline);
      end;
      
      %look for min-max restrictions and correct the value if necessary
      if isfield(mycommandline,'wertebereich') && length(mycommandline.wertebereich)>=parameter.gui.merkmalsgenerierung.plug_par_number && ~isempty(mycommandline.wertebereich{parameter.gui.merkmalsgenerierung.plug_par_number})
         
         min_value = mycommandline.wertebereich{parameter.gui.merkmalsgenerierung.plug_par_number}{1};
         max_value = mycommandline.wertebereich{parameter.gui.merkmalsgenerierung.plug_par_number}{2};
         if ischar(min_value)
            min_value = eval(min_value);
         end;
         if ischar(max_value)
            max_value = eval(max_value);
         end;
         
         parameter.gui.merkmalsgenerierung.plug_commandline = min(max_value,max(parameter.gui.merkmalsgenerierung.plug_commandline,min_value));
         set(hndl_commandline,'string',sprintf('%g ',parameter.gui.merkmalsgenerierung.plug_commandline));
      end;
      
      %update the related command line value if the format is compatible
      mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number} = parameter.gui.merkmalsgenerierung.plug_commandline;
      if plugins.sequence_field == 0
         %save plugin list parameter
         plugins.mgenerierung_plugins.info(plugins.ind_listbox(1)).commandline = mycommandline;
      else
         %save plugin sequence parameter
         plugins.mgenerierung_plugins.sequence.command_line{plugins.mgenerierung_plugins.sequence.pos(1)} =  mycommandline;
      end;
      
   else
      %refresh the old one
      temp_str = mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number};
      
      if isnumeric(temp_str)
         temp_str = sprintf('%g ',temp_str);
      end;
    
      set(hndl_commandline,'string',temp_str);
   end;
end;


clear hndl_commandline mycommandline
