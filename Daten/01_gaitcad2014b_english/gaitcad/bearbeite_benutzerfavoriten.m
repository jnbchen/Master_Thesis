  function [parameter, favoriten_gui] = bearbeite_benutzerfavoriten(parameter, favoriten_gui, aktion)
% function [parameter, favoriten_gui] = bearbeite_benutzerfavoriten(parameter, favoriten_gui, aktion)
%
% 
% 
% 
% 
%  Soll die GUI neu angelegt werden?
%
% The function bearbeite_benutzerfavoriten is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 2 || isempty(favoriten_gui))
   favoriten_gui = [];
   
   x_size = 500;
   y_size = 500;
   bg_color = [.8 .8 .8];
   screensize = get(0, 'ScreenSize');
   % Zentrale Position berechnen.
   x_pos = (screensize(3)-x_size)/2;
   y_pos = (screensize(4)-y_size)/2;
   favoriten_gui.h = figure;
   set(favoriten_gui.h, 'NumberTitle', 'off', 'Name', 'User-defined favorites', ...
      'Position', [x_pos, y_pos, x_size, y_size], 'MenuBar', 'none', 'Resize', 'off', 'color', bg_color);
   
   % Suche nach den Einträgen, die nicht in der Ausschlussliste enthalten sind:
   menu_elements = char({parameter.gui.menu.elements.tag});
   [menu_elements] = setdiff(menu_elements, parameter.gui.menu.favoriten.param.ausschlussliste, 'rows');
   % Nun schmeiße die Einträge raus, die bereits in den Favoriten enthalten sind:
   if (isfield(parameter.gui.menu.favoriten, 'manuell') && ~isempty(parameter.gui.menu.favoriten.manuell))
      [menu_elements] = setdiff(menu_elements, parameter.gui.menu.favoriten.manuell.tags, 'rows');
   end;
   
   % Erstelle die Namen der Menüeinträge (inklusive der Hierarchie)
   menu_elements_names = [];
   for i = 1:size(menu_elements, 1)
      h = get_element_handle(parameter, deblank(menu_elements(i,:)), 'MI');
      if (~isempty(h))
         menu_elements_names = strvcatnew(menu_elements_names, get_name(h));
      end;
   end; % for(i = 1:size(menu_elements, 1))
   % Sortiere die Einträge, damit sie leichter zu finden sind.
   [menu_elements_names, I] = sortrows(menu_elements_names);
   % Die Tags müssen natürlich auch sortiert sein.
   menu_elements = menu_elements(I, :);
   % Lege eine Listbox mit den Elementen an, die in Menüs vorkommen.
   favoriten_gui.listbox_menu = uicontrol(favoriten_gui.h, 'style', 'listbox', 'max', 2, 'min', 0, 'String', menu_elements_names, ...
      'Position', [10, 300, 480, 180], 'UserData', menu_elements);
   
   % Nun den gleichen Kram für die Einträge, die bereits in den Favoriten enthalten sind:
   if (isfield(parameter.gui.menu.favoriten, 'manuell') && ~isempty(parameter.gui.menu.favoriten.manuell))
	   favoriten_elements = parameter.gui.menu.favoriten.manuell.tags;
   	favoriten_elements_names = [];
	   for i = 1:size(favoriten_elements, 1)
   	   h = get_element_handle(parameter, deblank(favoriten_elements(i,:)), 'MI');
	      if (~isempty(h))
   	      favoriten_elements_names = strvcatnew(favoriten_elements_names, get_name(h));
	      end;
   	end; % for(i = 1:size(favoriten_elements, 1))
	   [favoriten_elements_names, I] = sortrows(favoriten_elements_names);
      favoriten_elements = favoriten_elements(I, :);
   else
      favoriten_elements = [];
      favoriten_elements_names = [];
   end;
   favoriten_gui.listbox_favo = uicontrol(favoriten_gui.h, 'style', 'listbox', 'max', 2, 'min', 0, 'String', favoriten_elements_names, ...
      'Position', [10, 70, 480, 180], 'UserData', favoriten_elements);
   
   % Lege die Buttons zum Hinzufügen, Entfernen und Beenden der GUI an.
   favoriten_gui.button_hinzu = uicontrol(favoriten_gui.h, 'style', 'pushbutton', 'String', 'Add', ...
      'Position', [110  265 80 25], 'Callback', '[parameter, favoriten_gui] = bearbeite_benutzerfavoriten(parameter, favoriten_gui, ''hinzu'');');
   favoriten_gui.button_weg   = uicontrol(favoriten_gui.h, 'style', 'pushbutton', 'String', 'Remove', ...
      'Position', [210 265 80 25], 'Callback', '[parameter, favoriten_gui] = bearbeite_benutzerfavoriten(parameter, favoriten_gui, ''weg'');');
   favoriten_gui.button_ende  = uicontrol(favoriten_gui.h, 'style', 'pushbutton', 'String', 'Close', ...
      'Position', [310 265 80 25], 'callback', '[parameter, favoriten_gui] = bearbeite_benutzerfavoriten(parameter, favoriten_gui, ''ende'');');
   
else
   % Die GUI existiert, es wird ein Callback ausgeführt.
   switch(aktion)
   case 'ende'
      % Ergebnisse übernehmen
      % Bisher vorhandene Favoriten:
      if (isfield(parameter.gui.menu.favoriten, 'manuell') && ~isempty(parameter.gui.menu.favoriten.manuell))
         alt = parameter.gui.menu.favoriten.manuell.tags;
      else
         alt = [];
      end;
      % Aktuelle Einträge
      aktuell = get(favoriten_gui.listbox_favo, 'UserData');
      % Fenster schließen.
      close(favoriten_gui.h);
      % Welche sind neu?
      if (~isempty(alt))
         neue = setdiff(aktuell, alt, 'rows');
      else
         neue = aktuell;
      end;
      % Welche sind nicht mehr da?
      if (~isempty(alt))
         nicht_mehr = setdiff(alt, aktuell, 'rows');
      else
         nicht_mehr = [];
      end;
      
      % Alte Einträge entfernen:
      for i = 1:size(nicht_mehr, 1)
         parameter.gui.menu.favoriten = aktualisiere_favoriten(parameter.gui.menu.favoriten, deblank(nicht_mehr(i,:)), ...
            parameter, 'DEL USER', parameter.gui.menu.favoriten.param);
      end; % for(i = 1:size(nicht_mehr, 1))
      
      % Neue Einträge eintragen
      for i = 1:size(neue, 1)
         parameter.gui.menu.favoriten = aktualisiere_favoriten(parameter.gui.menu.favoriten, deblank(neue(i,:)), ...
            parameter, 'ADD USER', parameter.gui.menu.favoriten.param);
      end; % for(i = 1:size(neue, 1))
      
      if (isfield(parameter.gui.menu.favoriten.manuell, 'elements') && isempty(parameter.gui.menu.favoriten.manuell.elements))
         parameter.gui.menu.favoriten.manuell = [];
      end;
            
      % Funktion zum Aktualisieren der Favoriten ausführen.
      callback_update_favoriten;
      
      % favoriten_gui auf Start setzen.
      favoriten_gui = [];      
   case 'hinzu'
      % Es sollen Menüeinträge zur Favoriten-Liste hinzugefügt werden.
      % Welche Einträge?
      markiert = get(favoriten_gui.listbox_menu, 'value');
      if (isempty(markiert))
         return;
      end;
            
      % Die markieren Einträge werden in das Favoriten-Menü verschoben
      menu.strs = get(favoriten_gui.listbox_menu, 'String');
      menu.user = get(favoriten_gui.listbox_menu, 'UserData');
      favo.strs = get(favoriten_gui.listbox_favo, 'String');
      favo.user = get(favoriten_gui.listbox_favo, 'UserData');
      % Benutze die gekapselte Funktion.
      [menu, favo] = tauschen(menu, favo, markiert);
      
      % Die Auswahl der Listbox muss angepasst werden.
      if (isempty(menu.strs))
         auswahl = [];
      else
         auswahl = min(size(menu.strs,1), markiert(1)-1);
         if (auswahl <= 0)
	         auswahl = 1;
         end;
      end;
      % Trage die Daten neu ein.
      set(favoriten_gui.listbox_menu, 'String', menu.strs, 'UserData', menu.user, 'Value', auswahl);
      set(favoriten_gui.listbox_favo, 'String', favo.strs, 'UserData', favo.user);
      
   case 'weg'
      % Siehe 'hinzu', aber umgedrehte Richtung.
      markiert = get(favoriten_gui.listbox_favo, 'value');
      if (isempty(markiert))
         return;
      end;
      
      % Die markieren Einträge werden in das Favoriten-Menü verschoben
      menu.strs = get(favoriten_gui.listbox_menu, 'String');
      menu.user = get(favoriten_gui.listbox_menu, 'UserData');
      favo.strs = get(favoriten_gui.listbox_favo, 'String');
      favo.user = get(favoriten_gui.listbox_favo, 'UserData');
      [favo, menu] = tauschen(favo, menu, markiert);
      
      if (isempty(favo.strs))
         auswahl = [];
      else
         auswahl = min(size(favo.strs,1), markiert(1)-1);
         if (auswahl <= 0)
	         auswahl = 1;
         end;
      end;
      set(favoriten_gui.listbox_menu, 'String', menu.strs, 'UserData', menu.user);
      set(favoriten_gui.listbox_favo, 'String', favo.strs, 'UserData', favo.user, 'Value', auswahl);
      
   end; % switch(aktion)
end;


function name = get_name(handle)
name = get(handle, 'Label');
p = get(handle, 'Parent');
while ~isempty(p) && strcmp(get(p, 'Type'), 'uimenu')
   name = [get(p, 'Label'), ' - ' name];
   p = get(p, 'Parent');
end;

function [out1, out2] = tauschen(in1, in2, indizes)
% in1, in2 und out1, out2 sind jeweils Strukts mit zwei String-Matrizen.
% Die in indizes angegeben Zeilen der Matrizen in in1 werden in die Matrizen in in2 verschoben.
% Alle Stringmatrizen werden anschließend neu sortiert
out2.strs = strvcatnew(in2.strs, deblank(in1.strs(indizes,:)));
out2.user = strvcatnew(in2.user, deblank(in1.user(indizes,:)));
out1 = in1;
out1.strs(indizes,:) = [];
out1.user(indizes,:) = [];
[out1.strs, I] = sortrows(out1.strs);
out1.user = out1.user(I, :);
[out2.strs, I] = sortrows(out2.strs);
out2.user = out2.user(I, :);

