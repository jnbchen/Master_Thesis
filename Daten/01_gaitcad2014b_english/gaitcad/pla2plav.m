  function plausall=pla2plav(plausall,par)
% function plausall=pla2plav(plausall,par)
%
% schreibt alle Elemente in Plausall-Matrix, auch vollbesetzte Zeilen
% 
% plausall-Datenstruktur:
% 1-Relevanz, 2 Fehler, 3 Absicherung, 4 Konklusion, 5-Ende Primärterme (ACHTUNG !) jeder Term
% von Klasse 1 bis maximale Klassenanzahl aller Eingangsgrößen
%
% The function pla2plav is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(plausall) 
   return;
end;

%Anzahl Terme
max_term=max(par(5:4+par(2)));

%Null-Prämissen
for i=1:par(2) 
   ind=find(~sum(plausall(:,4+[1:max_term]+(i-1)*max_term)'));
   %plausall(ind,4+[1:par(4+i)]+(i-1)*max_term)=ones(length(ind),par(4+i));
   %der volle Vektor muss vollgeschrieben werden (auch wenn par(4+i)<max_term, sonst funktioniert zwar Fuzzifizierung,
   %aber nicht mehr unbedingt Berechnung c2-Matrizen in c2_compp
   plausall(ind,4+[1:max_term]+(i-1)*max_term)=ones(length(ind),max_term);
end;



