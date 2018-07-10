  function klassen = get_klassen(string, trennung)
% function klassen = get_klassen(string, trennung)
%
% 
%  Liest die Klassenzuweisungen ein. String enthält dabei den
%  Pfad zur Datei
% 
%
% The function get_klassen is part of the MATLAB toolbox Gait-CAD. 
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

if (isempty(string))
   klassen = [];
   return;
end;
% Nur wenn Trennzeichen nicht leer
if (~isempty(trennung))
   % Speicher initialisieren
   klassen = cell(0); count = 1;
   % Und Zeichenkette zerlegen
   teile = strfind(string, '\');
   % Wenn eine einzelne Datei übergeben wird, fehlt hier ein Backslash.
   % Der wird durch die folgende Zeilen simuliert.
   if (isempty(teile))
      teile = length(string)+1;
   end;
   start = 1;
   % Hier müssen auch die einzelnen Teile des Pfad berücksichtigung finden.
   for i = 1:length(teile)
      ende = teile(i)-1;
      [t, r] = strtok(string(start:ende), trennung);
      while(~isempty(r))
         klassen{1, count} = t;
         [t, r] = strtok(r, trennung);
         count = count + 1;
      end;
      klassen{1, count} = t;
      start = ende + 2;
   end; % for(i = 1:length(teile))
else
   klassen{1,1} = string;
end;