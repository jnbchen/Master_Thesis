% Script callback_check_commandline
%
% get the related handles
%
% The script callback_check_commandline is part of the MATLAB toolbox Gait-CAD. 
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

hndl_sequence   = findobj('tag','CE_Auswahl_PluginsList');
hndl_commandline = findobj('tag','CE_Auswahl_PluginsCommandLine');
hndl_commandlinename = findobj('tag','CE_Auswahl_PluginsCommandLineName');
hndl_parameter_number = findobj('tag','CE_Plugins_ParameterNumber');
hndl_parameter_number_check = findobj('tag','CE_Plugins_ParameterNumberPush');

%number of the sequence
plugins.mgenerierung_plugins.sequence.pos  = get(hndl_sequence,'value');

mycommandline = checkvalidcommandline(plugins,parameter);

if isempty(mycommandline)
   %if not: diable all related fields 
   set(hndl_commandline,'enable','off','string','','style','edit');
   set(hndl_commandlinename,'string','Plugin parameter','enable','off'); 
   set(hndl_parameter_number,'string','None','enable','off','value',1);
   set(hndl_parameter_number_check,'enable','off');   

else 
   %if yes: 
   %update the string for the number of paramters field
   len = length(mycommandline.description);
   parameter_string = '';
   parameter_string (1:2:2*len) = 1:len;
   parameter_string (2:2:2*len) = len;
   
   %the P is necessary for macros!!!
   parameter_string = sprintf('P%d/%d|',parameter_string);
   set(hndl_parameter_number,'string',parameter_string(1:end-1),'value',1,'enable','on');
   %execute the related callback
   temp_callback = get(hndl_parameter_number,'callback');
   if ~isempty(temp_callback)
      eval(temp_callback);
   end;
   
   %enable the field for changes
   set(hndl_parameter_number_check,'enable','on');
end;

%clean up
clear hndl_sequence hndl_commandline hndl_commandlinename hndl_parameter_number hndl_parameter_number_check 


