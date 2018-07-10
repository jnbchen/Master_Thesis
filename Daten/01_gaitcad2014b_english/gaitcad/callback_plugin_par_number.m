% Script callback_plugin_par_number
%
% plugins must exist
%
% The script callback_plugin_par_number is part of the MATLAB toolbox Gait-CAD. 
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

if ~isfield(plugins,'mgenerierung_plugins') || ~isfield(plugins.mgenerierung_plugins,'funktionsnamen')
   return;
end;

%callback for the number field of the parameters for the commandline field
mycommandline = checkvalidcommandline(plugins,parameter);
ind_tag = find(ismember({parameter.gui.control_elements.tag},'CE_Auswahl_PluginsCommandLine'));
if ~isempty(mycommandline)
   %get the handles
   hndl_commandline = findobj('tag','CE_Auswahl_PluginsCommandLine');
   hndl_commandlinename = findobj('tag','CE_Auswahl_PluginsCommandLineName');
   
   %update the right parameter name and value from the sequence
   set(hndl_commandline,'enable','on','tooltipstring',mycommandline.tooltext{parameter.gui.merkmalsgenerierung.plug_par_number});
   
   if mycommandline.ispopup{parameter.gui.merkmalsgenerierung.plug_par_number} == 0
      temp_str = mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number};
      if isnumeric(temp_str)
         temp_str = sprintf('%g ',temp_str);
      end;
      set(hndl_commandline,'string',temp_str,'style','edit');
      parameter.gui.control_elements(ind_tag).style = 'edit';
      parameter.gui.merkmalsgenerierung.plug_commandline = mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number};
      
      if ~isempty(teach_modus)
         set(hndl_commandline,'callback',teach_modus.callback_parameter_edit);
      end;
      
      
   else
      set(hndl_commandline,'string',mycommandline.popup_string{parameter.gui.merkmalsgenerierung.plug_par_number},'style','popup','value',mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number});
      parameter.gui.control_elements(ind_tag).style = 'popup';
      parameter.gui.merkmalsgenerierung.plug_commandline = mycommandline.parameter_commandline{parameter.gui.merkmalsgenerierung.plug_par_number};
      if ~isempty(teach_modus)
         set(hndl_commandline,'callback',teach_modus.callback_parameter_popup);
      end;
      
   end;
   
   set(hndl_commandlinename,'string',mycommandline.description{parameter.gui.merkmalsgenerierung.plug_par_number},'enable','on');
end;

clear mycommandline
