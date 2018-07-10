  function options = konvertiere_uihdg(elements, alt)
% function options = konvertiere_uihdg(elements, alt)
%
% 
%   Konvertiert die Datenstruktur der alten uihdg-Dateien in das
%   neue Strukt.
%   in alt sind die geladenen Daten der alten uihdg-Datei.
%   parameter ist das "normale" Parameter-Strukt von Gaitcad.
%   Die Rückgabe ist ein Strukt in dem Format, wie es die neuen
%   uihdg-Dateien verwenden.
%   Wenn eins der Felder popupvalues oder editvalues fehlt, dann
%   scheint die Datei noch ein anderes Format zu haben.
% 
%
% The function konvertiere_uihdg is part of the MATLAB toolbox Gait-CAD. 
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

if (~isfield(alt, 'popupvalues') || ~isfield(alt, 'editvalues'))
   myerror('Incompatible file!');
   return;
end;

options = [];
% Nach diesem Schritt sind die einzelnen uihd-Indizes in uihd_indx
% enthalten. Die erste Zeile kann noch entfernt werden, da sie bei allen
% 1 ist.
uihd_indx = myCellArray2Matrix({elements.uihd_code}');
uihd_indx = uihd_indx(:, 2);
count = 1;
% Ansonsten gehe durch die einzelnen Felder durch. Prüfe den Typ
% des Feldes und setze die Werte in optionen.
for i = 1:max(length(alt.popupvalues), length(alt.editvalues))
   % Der Index i steht für den uihd-Index. Es muss also zunächst das Element
   % gesucht werden, das dem Index i entspricht.
   indx = find(ismember(uihd_indx, i));
   % options besteht aus zwei Variablen. var_names, die die Namen der Variable
   % enthalten, in die das Oberflächenelement seine Werte einträgt und var_val,
   % die die entsprechenden Werte enthält
   % Dadurch, dass die Identifikation des Elements nicht über den Index passiert,
   % spielt die Reihenfolge keine Rolle. Es kann einfach der Reihe nach angehängt
   % werden.
   if (length(indx) == 1 )
      options.var_name{count} = elements(indx).variable;
      % So, nun muss kontrolliert werden, um welchen Typ es sich handelt.
      % Die Werte der Edit-Variablen stehen in editvalues, die der anderen Felder
      % in popupvalues. Eine Ausnahme muss hier gemacht werden. Wurde bei einem Kontroll-
      % Element der "save_as_string" Wert auf 1 gesetzt, kann die alte Speicherung
      % nicht übernommen werden. Programmiertechnisch wäre es zwar einfach, es ist aber
      % nicht sicher, ob sich die Listbox mit der Zeit verändert hat. Daher lieber nichts eintragen
      if (strcmp(elements(indx).style, 'edit'))
         options.var_val{count} = alt.editvalues(i).string;
      else
         if (isempty(elements(indx).save_as_string) || elements(indx).save_as_string ~= 1)
            options.var_val{count} = alt.popupvalues(i).value;
         end;
      end;
      count = count + 1;
   end; % if (~isemtpy(indx))
end; % for(i = 1:length(alt.popupvalues))
