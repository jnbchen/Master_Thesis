  function freimat = menu_freischalten(parameter, freischalt)
% function freimat = menu_freischalten(parameter, freischalt)
%
% 
% 
% 
%
% The function menu_freischalten is part of the MATLAB toolbox Gait-CAD. 
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

freimat = zeros(length(parameter.gui.menu.elements), 1);
for i = 1:length(freischalt)
   try
   % Das sieht etwas blöd aus. Das Problem ist aber, dass die Auswertung boolescher
   % Ausdrücke bei Eindeutigkeit in 5.3 nur dann abgebrochen wird, wenn er innerhalb einer if-Abfrage steht.
   % (Also z.B. bei "if (0 & isempty(test))" wird isempty(test) nicht ausgewertet, bei "0 & isempty(test)"
   % schon.) Ansonsten wird der komplette Ausdruck ausgewertet, was zu Fehlern (z.B. bei nicht
   % existierenden Variablen) führen kann. Mit diesem kleinen Umweg funktioniert es aber!
	   str = ['mf_erg = 0; if(' freischalt(i).bedingung ') mf_erg = 1; end;'];
   	evalin('caller', str);
	   erg = evalin('caller', 'mf_erg');
   catch
      fprintf(1, 'Error by evaluating enabling conditions. Menu item will be disabled.\n');
      fprintf(1, 'Evaluated condition: %s\nGenerated error: %s\n', freischalt(i).bedingung, lasterr);
      erg = 0;
   end;
   if (erg)
      freimat(freischalt(i).elemente, end+1) = 1;
   else
      freimat(freischalt(i).elemente, end+1) = 2;
   end;
end;
evalin('caller', 'clear mf_erg');
% Suche alle Elemente, die nur 1 oder 0 in der Matrix haben:
tmp = freimat; tmp(tmp == 0) = 1;
undef = find(all(freimat == 0, 2));
ein = find(all(freimat < 2, 2));
ein = setdiff(ein, undef);
aus = find(any(freimat == 2, 2));
aus = setdiff(aus, undef);

% Welche Elemente enthalten Kinder?
% Ist beim Deaktivieren eher uninteressant, aber beim Aktivieren vereinfacht es die Sache etwas.
en_c = myCellArray2Matrix({parameter.gui.menu.elements.freischalt_c});
ein_kinder = ein(find(en_c(ein)));
if (~isempty(ein_kinder))
   enable_menus(parameter, 'enable_children', {parameter.gui.menu.elements(ein_kinder).tag});
   % Die, bei denen auch die Kinder eingeschaltet wurden, können nun entfernt werden.
	ein = setdiff(ein, ein_kinder);
end;

if (~isempty(ein))
	ein_tags = {parameter.gui.menu.elements(ein).tag};
   enable_menus(parameter, 'enable', ein_tags);
end;
if (~isempty(aus))
	aus_tags = {parameter.gui.menu.elements(aus).tag};
   enable_menus(parameter, 'disable', aus_tags);
end;


