% Script callback_update_favoriten
%
% 
%  Wenn Gait-CAD beendet wurde, muss dieser Callback nicht mehr ausgeführt werden.
%
% The script callback_update_favoriten is part of the MATLAB toolbox Gait-CAD. 
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

if (isempty(parameter.projekt))
   return;
end;

parameter.gui.menu.dyn_favoriten.parents = [];
parameter.gui.menu.dyn_favoriten.parents(1).tag = 'MI_Favoriten';
parameter.gui.menu.dyn_favoriten.fig = 1;
parameter.gui.menu.dyn_favoriten.add_sep = 0;
parameter.gui.menu.dyn_favoriten.cleartag = 'LdFuaMd';

% Erzeuge die Liste mit den Elementen aus parameter.gui.menu.favoriten
% Die benutzerdefinierten Favoriten stehen in parameter.gui.menu.favoriten.manuell,
% die Standard-Funktionen in parameter.gui.menu.favoriten.standard und
% die Nicht-Standard-Funktionen (z.B. Makros) in parameter.gui.menu.favoriten.nonstandard.
% In jedem dieser Strukts gibt es ein Feld elements und (mit Ausnahme von manuell) ein Feld
% element_indx, das die verwendeten elements angibt
elements = [];
indx = 0;
if (isfield(parameter.gui.menu.favoriten, 'manuell') && ~isempty(parameter.gui.menu.favoriten.manuell))
   elements = parameter.gui.menu.favoriten.manuell.elements;
   elements(1).separator = 1;
   indx = length(elements);
end;
if (isfield(parameter.gui.menu.favoriten, 'standard') && ~isempty(parameter.gui.menu.favoriten.standard))
   if (isempty(elements))
      elements = parameter.gui.menu.favoriten.standard.elements(parameter.gui.menu.favoriten.standard.element_indx);
   else
      elements(end+1:end+length(parameter.gui.menu.favoriten.standard.element_indx)) = parameter.gui.menu.favoriten.standard.elements(parameter.gui.menu.favoriten.standard.element_indx);
   end;
	elements(indx+1).separator = 1;
   indx = length(elements);
end;
if (isfield(parameter.gui.menu.favoriten, 'nonstandard') && ~isempty(parameter.gui.menu.favoriten.nonstandard))
   if (isempty(elements))
      elements = parameter.gui.menu.favoriten.nonstandard.elements(parameter.gui.menu.favoriten.nonstandard.element_indx);
   else
      elements(end+1:end+length(parameter.gui.menu.favoriten.nonstandard.element_indx)) = parameter.gui.menu.favoriten.nonstandard.elements(parameter.gui.menu.favoriten.nonstandard.element_indx);
   end;
   elements(indx+1).separator = 1;
end;

parameter.gui.menu.dyn_favoriten = update_dynamic_menu(parameter, parameter.gui.menu.dyn_favoriten, elements);

% Die aktuellen Favoriten in einer Datei speichern
if (~isfield(parameter.gui.menu.favoriten, 'manuell'))
   manuell = [];
else
   manuell = parameter.gui.menu.favoriten.manuell;
end;
if (~isfield(parameter.gui.menu.favoriten, 'standard'))
   standard = [];
else
   standard = parameter.gui.menu.favoriten.standard;
end;
if (~isfield(parameter.gui.menu.favoriten, 'nonstandard'))
   nonstandard = [];
else
   nonstandard = parameter.gui.menu.favoriten.nonstandard;
end;
dateiname = sprintf('%s%s%s', parameter.allgemein.userpath,filesep,parameter.allgemein.name_favoritefile);
save(dateiname, 'manuell', 'standard', 'nonstandard', ...
   '-mat',char(parameter.gui.allgemein.liste_save_mode_matlab_version(parameter.gui.allgemein.save_mode_matlab_version))); 
clear elements indx favoriten name;


