  function [elements, parameter] = suche_figures(show, del_handles, parameter)
% function [elements, parameter] = suche_figures(show, del_handles, parameter)
%
% 
% 
%
% The function suche_figures is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 1)
   show = 0;
end;
if (nargin < 2)
   del_handles = [];
end;
if (nargin < 3)
   parameter = [];
   if (show == 1)
      show = 0;
   end;
end;
elements = [];
figs = findobj('Type','figure');
if (~isempty(del_handles))
   figs(find(ismember(figs, del_handles))) = [];
end;
[figs, sort_i] = sort(figs);
if (isempty(figs))
   return;
end;
ind=get(figs, 'name');
if (~iscell(ind))
   ind = cellstr(ind);
end;
for i = 1:length(figs)
   
    %MATLAB 2014B compatibility
    if (~isempty(ind{i}))
      if (strcmp(get(figs(i), 'NumberTitle'), 'off'))
         elements(i).name = ind{i};
      else
         elements(i).name = sprintf('Figure No: %d: %s', get_figure_number(figs(i)), ind{i});
      end;
   else
      elements(i).name = sprintf('Figure No: %d', get_figure_number(figs(i)));
   end;
   elements(i).callback = sprintf('figure(%d);', get_figure_number(figs(i)));
   elements(i).handle = figs(i);
end;

% Zeigt ein Fenster mit einer Auswahlliste aller Fenster an.
if (show)
   if (isfield(parameter.gui.menu.dyn_fenster, 'fensterliste') && ~isempty(parameter.gui.menu.dyn_fenster.fensterliste))
      delete(parameter.gui.dyn_menu.fensterliste);
   else
      h = figure;
      parameter.gui.menu.dyn_fenster.fensterliste = h;
   end;
   set(h, 'DeleteFcn', 'parameter.gui.menu.dyn_fenster.fensterliste = [];');
   set(h, 'Position', [70 511 260 370], 'MenuBar', 'none');
   set(h, 'NumberTitle', 'off', 'Name', 'Window list');
   t = uicontrol(h, 'tag', 'dynm_fenster_listbox', 'style', 'listbox', 'max', 1, 'min', 0, 'String', char(elements.name));
   set(t, 'UserData', myCellArray2Matrix({elements.handle}));
   set(t, 'Position', [10 50 240 300]);
   t = uicontrol(h, 'Style', 'pushbutton', 'String', 'Activate', 'Position', [75 10 100 20]);
   set(t, 'callback', 'h = findobj(''style'', ''listbox'', ''tag'', ''dynm_fenster_listbox''); ind = get(h, ''value''); hndls = get(h, ''UserData''); figure(hndls(ind));');
end;
