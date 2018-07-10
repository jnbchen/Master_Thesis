  function [applspec_gui] = verwalte_specials(parameter, applspec_gui)
% function [applspec_gui] = verwalte_specials(parameter, applspec_gui)
%
% 
% 
%
% The function verwalte_specials is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 2 || isempty(applspec_gui))
   % Die figure anlegen.
   x_size = 440;
   y_size = 220;
   bg_color = [.8 .8 .8];
   screensize = get(0, 'ScreenSize');
   % Zentrale Position berechnen.
   x_pos = (screensize(3)-x_size)/2;
   y_pos = (screensize(4)-y_size)/2;
   applspec_gui.h = figure;
   applspec_gui.orig_aktiv = parameter.allgemein.aktiv;
   applspec_gui.kopie_aktiv = applspec_gui.orig_aktiv;
   applspec_gui.ok = 0;
   set(applspec_gui.h, 'NumberTitle', 'off', 'Name', 'Gait-CAD: Settings for application-specific extensions', ...
      'Position', [x_pos, y_pos, x_size, y_size], 'MenuBar', 'none', 'Resize', 'off', 'color', bg_color);
   
   % Auswahlliste für die Variable oder Zeitreihe:
   toolstr = sprintf('Selection of extension packages\n');
   toolstr = strcat(toolstr,'(De-)activation switch the state for the chosen extension.\n');
   toolstr = strcat(toolstr,'The changes will be activated after a Gait-CAD restart.');
   applspec_gui.fig_handles.liste = uicontrol(applspec_gui.h, 'Style', 'listbox', 'String', char({parameter.allgemein.aktiv.name}), ...
      'Position', [130 100 200 100], 'TooltipString', toolstr, 'Min', 0, 'Max', 2);
   uicontrol(applspec_gui.h, 'Style', 'text', 'String', 'Found extension packages', 'Position', [10 127 115 30], ...
      'BackgroundColor', bg_color, 'HorizontalAlignment', 'left', 'TooltipString', toolstr);
   
   % Buttons
   applspec_gui.toggle = 0;
   applspec_gui.fig_handles.toggle = uicontrol(applspec_gui.h, 'Style', 'pushbutton', 'String', '(De-)activation', ...
      'Position', [340 140 90 20], 'Callback', 'applspec_gui.toggle = 1; applspec_gui=verwalte_specials(parameter, applspec_gui);');
   
   applspec_gui.fig_handles.OK = uicontrol(applspec_gui.h, 'Style', 'pushbutton', 'String', 'OK', ...
      'Position', [130 30 70 20], 'Callback', 'applspec_gui.ok = 1; close(applspec_gui.h); applspec_gui.h = [];');
   applspec_gui.fig_handles.Abbrechen = uicontrol(applspec_gui.h, 'Style', 'pushbutton', 'String', 'Cancel', ...
      'Position', [250 30 70 20], 'Callback', 'applspec_gui.ok = 0; close(applspec_gui.h); applspec_gui.h = [];');
end;
if (applspec_gui.toggle)
   applspec_gui.toggle = 0;
   indx = get(applspec_gui.fig_handles.liste, 'value');
   for i = 1:length(indx)
      applspec_gui.kopie_aktiv(indx(i)).an = ~applspec_gui.kopie_aktiv(indx(i)).an;
   end;
end;

% Verändere die Einträge der Listbox:
namen = {applspec_gui.orig_aktiv.name};
for i = 1:length(namen)
   if (applspec_gui.kopie_aktiv(i).an)
      namen{i} =  [namen{i} ' (activated)'];
   else
      namen{i} = [namen{i} ' (deactivated)'];
   end;
end;
set(applspec_gui.fig_handles.liste, 'String', char(namen));