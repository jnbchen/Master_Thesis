  function [merk,merkmal_auswahl,rueckstufung,merk_archiv]=corrkorrekt(merk,d_org,c_krit,merkmal_auswahl,merk_archiv)
% function [merk,merkmal_auswahl,rueckstufung,merk_archiv]=corrkorrekt(merk,d_org,c_krit,merkmal_auswahl,merk_archiv)
%
% function [merk,merkmal_auswahl]=corrkorrekt(merk,d_org,c_krit,merkmal_auswahl)
%
% The function corrkorrekt is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

[tmp,ind]=sort(-merk);
sigma=mycorrcoef(d_org(:,ind));

% Strukts bringen einen manchmal zur Verzweiflung. Daher erst einmal in Vektoren eintragen
% und die hinterher in ein Strukt kopieren:
von = zeros(size(d_org, 2),1);
ccoeff = zeros(size(d_org, 2),1);

for i=1:length(ind)
   ind_redundant=find(abs(sigma(i+1:length(ind),i))>c_krit);
   
   %Relevanzen zurücksetzen
   merk(ind(ind_redundant+i))=0;
   merk_archiv.guete(:,ind(ind_redundant+i))=0;

   rueckInd = ind(ind_redundant+i);
   % Nur das erste Rücksetzen soll gespeichert werden:
   indx_loesch = find(ismember(rueckInd, find(von)));
   rueckInd(indx_loesch) = [];
   ind_redundant(indx_loesch) = [];
   von(rueckInd) = ind(i);
   ccoeff(rueckInd) = sigma(i+ind_redundant, i);
end;
rueckstufung.von = von;
rueckstufung.ccoeff = ccoeff;

%Archiv füllen
merk_archiv.rueckstufung=rueckstufung;
merk_archiv.merkmal_auswahl=merkmal_auswahl;

if (nargin>3) 
   [tmp,ind]=sort(-merk);
   merkmal_auswahl=ind(1:length(merkmal_auswahl));
end;