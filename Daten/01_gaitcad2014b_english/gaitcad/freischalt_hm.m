  function hm_strukt = freischalt_hm(parameter)
% function hm_strukt = freischalt_hm(parameter)
%
% 
%  Berechne für die Hauptmenüpunkte verkleinerte Freischalt-Strukts.
%  Die können dann bei einem Klick auf das entsprechende Hauptmenü
%  ausgewertet werden. Insbesondere die Verringerung der Anzahl
%  an Menüpunkten sollte eine deutliche Beschleunigung gegenüber
%  der direkten Verwendung von menu_freischalten auf dem kompletten
%  Menü bewirken.
% 
%  Die Hauptmenü-Einträge:
%
% The function freischalt_hm is part of the MATLAB toolbox Gait-CAD. 
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

main_menu = parameter.gui.menu.main_menu;
% Für jeden Eintrag durchgehen und _alle_ Kinder suchen
% (muss also rekursiv geschehen)
for mm = 1:length(main_menu)
   % get_menu_items sucht rekursiv nach allen Elementen
   % des Menüpunkts.
   items = get_menu_items(parameter, main_menu{mm});
   items = unique(items);
   % Nun verwende die Funktion freischalt_strukt  mit einer
   % verringerten Anzahl an Menüeinträgen
   tmp_strukt.gui.menu.elements = parameter.gui.menu.elements(items);
   s = freischalt_strukt(tmp_strukt);
   % Die Indizes stimmen nun nicht. Also einmal für alle Bedingungen korrigieren:
   for s_c = 1:length(s)
      s(s_c).elemente = items(s(s_c).elemente);
   end;
   eval(sprintf('hm_strukt.%s = s;', main_menu{mm}));
end;

function items = get_menu_items(parameter, element, items)
if (nargin < 3)
   items = [];
end;
% Den index von element bestimmen:
i = get_element_indx(parameter, element, 'MI');
items(end+1) = i;
if (~isempty(i))
   tmp = parameter.gui.menu.elements(i).menu_items;
   for j = 1:length(tmp)
      if (ischar(tmp{j}))
         items(end+1) = get_element_indx(parameter, tmp{j}, 'MI');
         % Rekursiv nach weiteren Elementen durchsuchen:
         if (~isempty(parameter.gui.menu.elements(items(end)).menu_items))
            items = get_menu_items(parameter, parameter.gui.menu.elements(items(end)).tag, items);
         end;
      end;
   end;
end;
