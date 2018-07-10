% Script menu_elements_appl
%
% The script menu_elements_appl is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

if ~isempty(parameter.allgemein.appl_specials) && (~isempty(parameter.allgemein.appl_specials.menu_elements))
   %nach Menü-Eintrag Data-Mining einfügen (muss man u.U. später mal überdenken)
   ind_nach = getfindstr(parameter.gui.menu.main_menu, 'MI_DataMining', 'exact'); %ind_nach = strmatch('MI_DataMining', parameter.gui.menu.main_menu, 'exact');
   rest = parameter.gui.menu.main_menu(ind_nach+1:end);
   parameter.gui.menu.main_menu = parameter.gui.menu.main_menu(1:ind_nach);
   
   % Ruft die einzelnen speziellen Funktionen für die Definition von Kontroll-Elementen auf
   for i = 1:length(parameter.allgemein.appl_specials.menu_elements)
      %wird ab Spalte 15 eingetragen - jedes Paket braucht 3 Spalten (Menü, Control analog 11, Control analog 12)
      parameter.allgemein.uihd_column=12+3*i;
      parameter.allgemein.appl_specials.uihd_column(i)=12+3*i;
      
      eval(['els = ' parameter.allgemein.appl_specials.menu_elements{i} '(parameter);']);
      
      parameter.gui.menu.main_menu{end+1} = els(1).tag;
      
      
      %add menu element for help file - if it exist 
      if ~isempty(parameter.allgemein.appl_specials.help{i})
         %Separator
         els(1).menu_items{end+1} = -1; 
         %Link to entry for Help
         els(1).menu_items{end+1} = [els(1).tag '_Help']; 
         
         %Append entry for help
         els(end+1).uihd_code = els(end).uihd_code + [0 1];
         els(end).handle = [];
         els(end).name = 'Help';
         els(end).delete_pointerstatus = 0;
         els(end).callback = sprintf('eval(''!%s &'');', parameter.allgemein.appl_specials.help{i}.name);
         els(end).tag = els(1).menu_items{end};
         %is enabled if at least one single feature exist
         els(end).freischalt = {'1'};
      end;         

      
      % Das Kopieren von Strukts in Strukts ist bei Matlab manchmal etwas nervig...
      % Bei der folgenden Zeile trat ein Fehler auf, weil die Strukturen unterschiedlich
      % waren. Dabei war lediglich die Reihenfolge eine andere...
      % parameter.gui.menu.elements(end+1:end+length(els)) = els;
      % Also sicherheitshalber die Felder einzeln kopieren:
      for j = 1:length(els)
         fields = fieldnames(els(j));
         indx = length(parameter.gui.menu.elements) + 1;
         parameter.gui.menu.elements(indx).tag = [];
         for f = 1:length(fields)
            parameter.gui.menu.elements(indx) = setfield(parameter.gui.menu.elements(indx), fields{f}, getfield(els(j), fields{f}));
         end;
      end;
      
   end; 
   
   parameter.gui.menu.main_menu(end+1:end+length(rest)) = rest;
end;