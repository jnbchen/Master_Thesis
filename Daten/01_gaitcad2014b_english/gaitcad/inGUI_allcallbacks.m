% Script inGUI_allcallbacks
%
% list of callbacks not be executed
%
% The script inGUI_allcallbacks is part of the MATLAB toolbox Gait-CAD. 
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

list_of_forbidden_callbacks = {'CE_EditAuswahl_ZR','CE_EditAuswahl_EM','CE_EditAuswahl_IM','CE_Auswahl_Plugins','CE_Auswahl_PluginsCommandLine','CE_Plugins_ParameterNumber'};

%all control elements
temp_hndl = findobj('type','uicontrol');

%exclude pushbuttons
temp_hndl_push = findobj('type','uicontrol','style','pushbutton');
temp_hndl = setdiff(temp_hndl,temp_hndl_push);


%remove forbidden callbacks
for i_lfbc=1:length(list_of_forbidden_callbacks)
   temp_hndl = setdiff(temp_hndl, findobj('tag',list_of_forbidden_callbacks{i_lfbc}));   
end;

%get all different callbacks
temp_callback_ingui = unique(get(temp_hndl,'callback'));

%perform
for i_callback=1:length(temp_callback_ingui)
   eval(temp_callback_ingui{i_callback});
end;

%clean up
clear i_callback temp_callback_ingui list_of_forbidden_callbacks i_lfbc temp_hndl

   