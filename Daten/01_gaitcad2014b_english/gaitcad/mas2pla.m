  function plausall=mas2pla(maske)
% function plausall=mas2pla(maske)
%
% vektorisiert Regelmatrix maske, ergänzt Binärisierung und löscht Steuerzeichen
% 
% ACHTUNG ! geht nur, wenn keine ODER-Verknüpfung der Terme
% 
% maske-Datenstruktur
% Zeilen: Variablen
% 1. Spalte : -1  zusammengebaut aus ODER-Verknuepfung mehrerer Terme
%             0   nicht in Praemissse
%             i>0 Term i in Praemisse
% j-te Spalte: wenn 1. Spalte == -1, dann (j-1)-ter Term in ODER-Verknuepfung
% 
% plausall-Datenstruktur:
% 1-Relevanz, 2 Fehler, 3 Absicherung, 4 Konklusion, 5-Ende Primärterme (ACHTUNG !) jeder Term
% von Klasse 1 bis maximale Klassenanzahl aller Eingangsgrößen
% 
% Term i in Prämisse
%
% The function mas2pla is part of the MATLAB toolbox Gait-CAD. 
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

ind=find(maske(:,1)>0);
if ~isempty(ind) 
   maske(ind+size(maske,1)*(maske(ind,1)))=ones(length(ind),1);
end;

%Steuerzeichen wegschneiden
maske(:,1)=[];
maske=maske';
plausall=maske(:)';




	