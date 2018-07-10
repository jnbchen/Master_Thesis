  function set_anzeigeparameter_new(parameter,v)
% function set_anzeigeparameter_new(parameter,v)
%
% The function set_anzeigeparameter_new is part of the MATLAB toolbox Gait-CAD. 
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

for i = 1:length(parameter.gui.control_elements)
   set(parameter.gui.control_elements(i).handle, 'Visible', 'off');
   if (~isempty(parameter.gui.control_elements(i).bezeichner))
      set(parameter.gui.control_elements(i).bezeichner.handle, 'Visible', 'off');
   end;
end;
if isnumeric(v) && (v <= length(parameter.gui.waehlbare_felder))
   sucheVisibleElemente(parameter.gui.optionen_felder(parameter.gui.waehlbare_felder(v)), parameter);
else
   % Die Angabe v ist eine Zeichenkette. Suche nach dem Namen in der Definition der Felder und zeige
   % seine Elemente an.
   felder = char({parameter.gui.optionen_felder.name});
   indx   = getfindstr(felder, v, 'exact'); %indx   = strmatch(v, felder, 'exact');
   if (~isempty(indx))
      sucheVisibleElemente(parameter.gui.optionen_felder(indx), parameter);
   end;
end;

% Diese Unterfunktion durchsucht die entsprechenden Felder nach
% visualisierbaren Elemente. Dabei werden auch subfelder berücksichtigt:
function sucheVisibleElemente(feld, parameter)
tags = char({parameter.gui.control_elements.tag});
for i = 1:length(feld.visible)
   %c_indx = feld.visible(i).i_control_elements;
   c_indx = getElementIndx(feld.visible(i).i_control_elements, tags);
   if (~isempty(c_indx))
      % Besorge die Handles und die korrekten Positionen der Elemente
      handle_el  = parameter.gui.control_elements(c_indx).handle;
      pos_el  = [feld.visible(i).pos parameter.gui.control_elements(c_indx).breite parameter.gui.control_elements(c_indx).hoehe];
      
      % Auf sichtbar schalten
      set(handle_el,  'Visible', 'on');
      % An die richtigen Positionen verschieben
      set(handle_el,  'Position', pos_el);
      
      % Evtl. den Bezeichner ebenfalls sichtbar machen und verschieben
      if (~isempty(parameter.gui.control_elements(c_indx).bezeichner))
         handle_bez = parameter.gui.control_elements(c_indx).bezeichner.handle;
         set(handle_bez, 'Visible', 'on');
         pos_bez = [ [pos_el(1:2) + feld.visible(i).bez_pos_rel] parameter.gui.control_elements(c_indx).bezeichner.breite parameter.gui.control_elements(c_indx).bezeichner.hoehe];
         set(handle_bez, 'Position', pos_bez);
      end; % if (~isempty(parameter.gui.control_elements(c_indx).bezeichner))
   end;
end; % for(i = 1:length(feld.visible))

% Falls ein Subfeld vorhanden ist, ebenfalls anzeigen lassen:
if (~isempty(feld.subfeld))
   % Lese die Sub-Feld-Bedingung aus:
   bed_indx = getElementIndx(feld.subfeldbedingung, tags);
   if (isempty(bed_indx))
      error('Subfield condition does not exist!');      
   end;
   % ÄNDERN!!! Hier soll mal auf das Parameterstrukt zugegriffen werden. Zurzeit manuell auslesen:
   bed_val  = get(parameter.gui.control_elements(bed_indx).handle, 'value');
   % Aber zunächst prüfen, ob ein zu großer Wert in bed_val steht
   % (führt sonst bei nachträglich eingefügten Optionen zu einem Absturz)
   if (bed_val <= length(feld.subfeld)) && bed_val~=0
      % Nun wird rekursiv die gleiche Funktion aufgerufen, aber mit einem anderen
      % Feld-Parameter:
      felder = char({parameter.gui.optionen_felder.name});
      fIndx = getfindstr(felder, feld.subfeld{bed_val}, 'exact'); %fIndx = strmatch(feld.subfeld{bed_val}, felder, 'exact');
      if (~isempty(fIndx))
         sucheVisibleElemente(parameter.gui.optionen_felder(fIndx), parameter);
      end;
   end;
end; % if (~isempty(feld.subfeld))

function indx = getElementIndx(name, tags)
indx = getfindstr(tags, name, 'exact'); %indx = strmatch(name, tags, 'exact');