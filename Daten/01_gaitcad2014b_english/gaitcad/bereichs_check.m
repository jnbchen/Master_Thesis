% Script bereichs_check
%
%  Abbrechen, wenn Index, für den die Kontrolle gemacht werden soll
%  unbekannt ist.
%
% The script bereichs_check is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('bCheckIndx', 'var') || isempty(bCheckIndx))
   return;
end;

% Lese den aktuellen Wert aus der GUI.
ausGUIIndx = bCheckIndx; ausGUI;
% Besorge den korrekten Index:
tags = {parameter.gui.control_elements.tag};
bCheckIndx_I = strcmp(bCheckIndx, tags);
if bCheckIndx_I == 0
   return;
end;
% Lese den aktuellen Wert in eine temporäre Variable
% aber natürlich nur, wenn es einen Wert gibt...
if ~isempty(parameter.gui.control_elements(bCheckIndx_I).variable)
   eval(sprintf('wert = %s;', parameter.gui.control_elements(bCheckIndx_I).variable));
else
   return;
end;
% Wenn kein Wertebereich angegeben ist, kann auch nichts kontrolliert werden...
if isempty(parameter.gui.control_elements(bCheckIndx_I).wertebereich)
   return;
end;
% Die Schranken können entweder als Zahl oder als Zeichenkette angegegen sein.
% Die Zeichenkette muss einmal ausgeführt werden, die Zahl kann direkt verwendet werden
if ~iscell(parameter.gui.control_elements(bCheckIndx_I).wertebereich)
   warning(sprintf('Wrong definition of minimal and maximal values for edit element %s! The content will not be evaluated.', bCheckIndx));
   return;
end;
untere_schranke = parameter.gui.control_elements(bCheckIndx_I).wertebereich{1};
obere_schranke = parameter.gui.control_elements(bCheckIndx_I).wertebereich{2};
if (ischar(untere_schranke))
   untere_schranke = deblank(untere_schranke);
   if (strcmp(untere_schranke(end), ';'))
      untere_schranke = untere_schranke(1:length(untere_schranke)-1);
   end;
   untere_schranke = eval(untere_schranke);
end;
if (ischar(obere_schranke))
   obere_schranke = deblank(obere_schranke);
   if (strcmp(obere_schranke(end), ';'))
      obere_schranke = obere_schranke(1:length(obere_schranke)-1);
   end;
   obere_schranke = eval(obere_schranke);
end;
% Es kann zu etwas blöden Problemen kommen, wenn die untere Schranke größer ist als die obere Schranke.
% Die untere Schranke wird dann auch die obere gesetzt (sollte eigentlich nur bei variablen Schranken
% vorkommen).
if (untere_schranke > obere_schranke)
   untere_schranke = obere_schranke;
end;
% Vektor oder Skalar?
changed = 0;
% Bugfix Ole: Bisher war eine Zeichenkette in
% der Variablen ein Hinweise darauf, dass kein Bereichscheck gemacht werden soll.
% Das hat aber einen Nachteil, denn dann können "ausversehen" Zeichenketten eingetragen werden.
% Daher hier erst prüfen, ob ein Wertebereich definiert wurde (wurde oben bereits erledigt).
% Anschließend den Wert auf den kleinstmöglichen setzen, wenn eine Zeichenkette gefunden wurde.
if (ischar(wert))
   wert = untere_schranke;
   changed = 1;
end;
if (any(wert < untere_schranke))
	wert(wert < untere_schranke) = untere_schranke;
   changed = 1;
end;
if (any(wert > obere_schranke))
	wert(wert > obere_schranke) = obere_schranke;
   changed = 1;
end;
% Eine Schranke wurde über- oder unterschritten
if (changed)
	eval(sprintf('%s = wert;', parameter.gui.control_elements(bCheckIndx_I).variable));
	% GUI aktualisieren
	inGUIIndx = bCheckIndx; inGUI;
end;
clear bCheckIndx bCheckIndx_I changed wert untere_schranke obere_schranke tags;