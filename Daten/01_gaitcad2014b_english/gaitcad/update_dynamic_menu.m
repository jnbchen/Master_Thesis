  function dyn_menu = update_dynamic_menu(parameter, dyn_menu, elements)
% function dyn_menu = update_dynamic_menu(parameter, dyn_menu, elements)
%
% 
%  Funktion zum Aktualisieren eines dynamischen Menüs
% 
%  parameter: das Gait-CAD-Parameterstrukt
%  dyn_menu ist ein Strukt, das folgende Struktur hat
%  dyn_menu.fig: Handle der figure, in der das Menü steht.
%  dyn_menu.add_sep: Fügt eine Trennlinie vor dem ersten Eintrag ein.
%  dyn_menu.cleartag: Eine Zeichenkette, die den Menüelementen als Tag mitgegeben wird.
%  Durch diese Zeichenkette werden die alten Menüpunkte identifiziert und gelöscht.
%  Dieses Feld darf nicht fehlen!!!
%  dyn_menu.parents: Enthält ein Array-Strukt mit den Eltern des Eintrags. Die Struktur ist eine
%  abgespeckte Version von parameter.gui.menu.elements (siehe folgendes Beispiel)
% 
%  Beispiel: Die Einträge in elements sollen in das Menü Datei/Alt
%  Der Menüpunkt Datei existiert, Alt aber nicht.
%  Die korrekte Definition des Strukts ist:
%  dyn_menu.parents(1).tag = 'MI_Datei'; (wenn der Tag 'MI_Datei' heißt...)
%  dyn_menu.parents(2).name = 'Alt';
%  dyn_menu.parents(2).tag = 'MI_Alt';
%  dyn_menu.parents(2).separator = 1;
%  Durch den letzten Eintrag wird vor dem Menüpunkt noch eine Trennlinie gesetzt.
% 
%  elements: neue Elemente im Menü. Die alten werden zunächst gelöscht.
%  Bei elements reicht die Angabe von Name und Callback.
%  Die Rückgabe ist ein aktualisiertes Strukt, in dem auch die aktuellen
%  Elemente eingetragen werden.
% 
% 
% 
%
% The function update_dynamic_menu is part of the MATLAB toolbox Gait-CAD. 
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

if (~isfield(dyn_menu, 'cleartag'))
   error('Field ''cleartag'' was not defined! See PDF help for further information');
   dyn_menu = [];
   return;
end;
parents = dyn_menu.parents;
tags = {parameter.gui.menu.elements.tag};
% Prüfe, ob es die Eltern gibt, wenn nicht, lege sie neu an.
p_handles = [];
for i = 1:length(parents)
   tag = dyn_menu.parents(i).tag;
   h = findobj('type', 'uimenu', 'Tag', tag);
   if (isempty(h))
      if (isfield(dyn_menu.parents(i), 'separator') && dyn_menu.parents(i).separator)
         separator = 'on';
      else
         separator = 'off';
      end;
      if (i == 1)
         h = uimenu(dyn_menu.fig, 'Label', dyn_menu.parents(i).name, 'Tag', dyn_menu.parents(i).tag, 'Separator', separator);
      else
         h = uimenu(p_handles(end), 'Label', dyn_menu.parents(i).name, 'Tag', dyn_menu.parents(i).tag, 'Separator', separator);
      end;
   end;
   p_handles = [p_handles h];
end;

% Zunächst alle bisherigen Elemente löschen:
cl = findobj('type', 'uimenu', 'Tag', dyn_menu.cleartag);
if (~isempty(cl))
   try
      delete(cl);
   catch
   end;
end;
dyn_menu.handles = [];
% Nun die einzelnen Elemente eintragen
if (isempty(elements) && length(p_handles) > 1)
   set(p_handles(end), 'enable', 'off');
else
   set(p_handles(end), 'enable', 'on');
   for i = 1:length(elements)
      if ( (i == 1 && dyn_menu.add_sep) || (isfield(elements, 'separator') && ~isempty(elements(i).separator) && elements(i).separator) )
         separator = 'on';
      else
         separator = 'off';
      end;
      h = uimenu(p_handles(end), 'Label', elements(i).name, 'Callback', elements(i).callback, 'Separator', separator, 'tag', dyn_menu.cleartag);
   end;
end;
