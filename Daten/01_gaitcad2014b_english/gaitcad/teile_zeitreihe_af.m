  function [zr_trig] = teile_zeitreihe_af(vars, var_bez, zr_trig)
% function [zr_trig] = teile_zeitreihe_af(vars, var_bez, zr_trig)
%
% 
% 
%
% The function teile_zeitreihe_af is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 3)
   zr_trig = [];
end;

if (isempty(zr_trig) || ~isfield(zr_trig, 'fig_handles') || isempty(zr_trig.fig_handles))
   % Die figure anlegen.
   x_size = 440;
   y_size = 220;
   bg_color = [.8 .8 .8];
   screensize = get(0, 'ScreenSize');
   % Zentrale Position berechnen.
   x_pos = (screensize(3)-x_size)/2;
   y_pos = (screensize(4)-y_size)/2;
   zr_trig.fig_handles.h = figure;
   set(zr_trig.fig_handles.h, 'NumberTitle', 'off', 'Name', 'Gait-CAD: Split time series', ...
      'Position', [x_pos, y_pos, x_size, y_size], 'MenuBar', 'none', 'Resize', 'off', 'color', bg_color, ...
      'DeleteFcn',  'zr_trig.fig_handles = []; if (~zr_trig.ok) zr_trig.out = [];end;');
   
   % Auswahlliste für Quelle:
   zr_trig.out.quelle = 0;
   toolstr = sprintf('Looks for the trigger time series as time series in the given project\nor as variable in the workspace.');
   zr_trig.fig_handles.quelle = uicontrol(zr_trig.fig_handles.h, 'Style', 'popupmenu', 'String', 'Time series (TS)|Workspace', ...
      'Position', [150 180 200 20], 'value', 1, 'callback', '[zr_trig] = teile_zeitreihe_af([], [], zr_trig);', 'TooltipString', toolstr);
   uicontrol(zr_trig.fig_handles.h, 'Style', 'text', 'String', 'Source', 'Position', [20 177 100 20], ...
      'BackgroundColor', bg_color, 'HorizontalAlignment', 'right', 'TooltipString', toolstr);
   
   % Auswahlliste für die Variable oder Zeitreihe:
   toolstr = sprintf('Selection of the time series or workspace variable\ncontaining trigger events.\n');
   toolstr = [toolstr sprintf('This time series is a vector with the same length as the time series of the Gait-CAD project.\nIt has non-zero values for the samples of the trigger events.')];
   toolstr = [toolstr sprintf('The amplitude of the trigger event gives\n the value for the output variable for the new segment.')];
   zr_trig.fig_handles.trig_var = uicontrol(zr_trig.fig_handles.h, 'Style', 'popupmenu', 'String', 'Empty', ...
      'Position', [150 150 200 20], 'callback', 'zr_trig.out.trig_var = get(zr_trig.fig_handles.trig_var, ''value'');', 'TooltipString', toolstr);
   uicontrol(zr_trig.fig_handles.h, 'Style', 'text', 'String', 'Trigger event', 'Position', [20 147 100 20], ...
      'BackgroundColor', bg_color, 'HorizontalAlignment', 'right', 'TooltipString', toolstr);
   
   % Offset +/-:
   toolstr = sprintf('This field contains the number of sample points before and after a trigger event. \nThese sample points build new data points with the extracted segments.');
   zr_trig.out.offset = [-50 50];
   zr_trig.fig_handles.offset = uicontrol(zr_trig.fig_handles.h, 'Style', 'edit', 'String', num2str(zr_trig.out.offset), ...
      'Position', [150 120 200 20], 'TooltipString', toolstr, ...
      'callback', 'tmp = str2num(get(zr_trig.fig_handles.offset, ''String'')); if(~isempty(tmp)) zr_trig.out.offset = tmp; else set(zr_trig.fig_handles.offset, ''String'', num2str(zr_trig.out.offset));end;');
   uicontrol(zr_trig.fig_handles.h, 'Style', 'text', 'String', 'Offset -/+', 'Position', [20 117 100 20], ...
      'BackgroundColor', bg_color, 'HorizontalAlignment', 'right', 'TooltipString', toolstr);
   
   % Neue Trigger-ZR anhängen:
   toolstr = sprintf('If this option is chosen, a new time series will be added to the project.');
   toolstr = [toolstr sprintf('The time series \n can be used as trigger time series for time series classifiers.\n')];
   toolstr = [toolstr sprintf('This option can be deactivated if only sample points after the trigger events \nhave to be copied into the new time series. Then, the classifier will be applied to the complete time series.')];
   zr_trig.out.trigger = 1;
   zr_trig.fig_handles.trigger = uicontrol(zr_trig.fig_handles.h, 'Style', 'Checkbox', 'String', 'Add trigger event to project', ...
      'Position', [150 90 250 20], 'BackgroundColor', bg_color, 'Callback', 'zr_trig.out.trigger = get(zr_trig.fig_handles.trigger, ''value'');', ...
      'value', zr_trig.out.trigger, 'TooltipString', toolstr);
   
   % Buttons
   zr_trig.fig_handles.OK = uicontrol(zr_trig.fig_handles.h, 'Style', 'pushbutton', 'String', 'OK', ...
      'Position', [130 40 70 20], 'Callback', 'zr_trig.ok = 1; close(zr_trig.fig_handles.h);');
   zr_trig.fig_handles.Abbrechen = uicontrol(zr_trig.fig_handles.h, 'Style', 'pushbutton', 'String', 'Cancel', ...
      'Position', [250 40 70 20], 'Callback', 'zr_trig.ok = 0; close(zr_trig.fig_handles.h);');
   zr_trig.vars = vars;
   zr_trig.var_bez = var_bez;
   zr_trig.ok = 0;
end;

% Hier werden die Daten aktualisiert.
tmp = get(zr_trig.fig_handles.quelle, 'value');
% Aber nur, wenn sich etwas geändert hat.
if (zr_trig.out.quelle ~= tmp)
   zr_trig.out.quelle = tmp;
   if (zr_trig.out.quelle == 1)
      set(zr_trig.fig_handles.trig_var, 'value', 1, 'String', zr_trig.var_bez);
      zr_trig.out.trig_var = 1;
   else
      set(zr_trig.fig_handles.trig_var, 'value', 1, 'String', zr_trig.vars);
      zr_trig.out.trig_var = 1;
   end;
end;

