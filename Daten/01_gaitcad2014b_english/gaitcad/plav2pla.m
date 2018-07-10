  function plausall=plav2pla(plausall,par,anz_fuzzy)
% function plausall=plav2pla(plausall,par,anz_fuzzy)
%
% schreibt alle Elemente in Plausall-Matrix, auch vollbesetzte Zeilen
% 
% plausall-Datenstruktur:
% 1-Relevanz, 2 Fehler, 3 Absicherung, 4 Konklusion, 5-Ende Primärterme (ACHTUNG !) jeder Term
% von Klasse 1 bis maximale Klassenanzahl aller Eingangsgrößen
% 
% wenn nur die Prämisse übergeben wird (Erkennung über Länge), wird das automatisch berücksichtigt
% 
% Anzahl Terme
%
% The function plav2pla is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<3)
   anz_fuzzy=max(floor(size(plausall,2)/par(2),max(par(5:length(par)))));
end;

%nur Praemissenteil, wird automatisch erkannt
if size(plausall,2)==(anz_fuzzy*par(2))
   ind_versch=0;
else
   ind_versch=4;
end;

%Null-Prämissen, wenn alle fuer den jeweiligen Term moeglichen Praemissen
%(par(4+i))-Stück besetzt sind, ACHTUNG! Gesamtzaehlung aber ueber Anzahl Gesamtterme
%for i=1:par(2) ind=find(par(4+i)==sum(plausall(:,ind_versch+[1:par(4+i)]+(i-1)*anz_fuzzy)'));
for i=1:par(2)
   ind=find(par(4+i)<=sum(plausall(:,ind_versch+[1:anz_fuzzy]+(i-1)*anz_fuzzy)'));
   plausall(ind,ind_versch+[1:anz_fuzzy]+(i-1)*anz_fuzzy)=zeros(length(ind),anz_fuzzy);
end;




