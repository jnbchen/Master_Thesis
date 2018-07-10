  function [rule_praem_ausw]=praemausw(U,praemisse,anz_fuzzy)
% function [rule_praem_ausw]=praemausw(U,praemisse,anz_fuzzy)
%
% wertet die Praemisse einer Einzelregel (praemisse, muss in pla-Form gegeben sein,anz_fuzzy Terme) für
% die fuzzifizierten Daten in d_fuz aus und gibt Prämissenaktivierung rule_praem_ausw zurück
% 
% Welche Variablen sind spezifiziert ? -> Einsen in Praemisse suchen
%
% The function praemausw is part of the MATLAB toolbox Gait-CAD. 
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

ind_zeroregel=find(praemisse);
if ~isempty(ind_zeroregel)
   %Variable
   ind_merkmal=findd(ceil(ind_zeroregel/anz_fuzzy));
   %alle Werte, die zu diesen Variablen gehören
   ind_aktiv=kron((ind_merkmal-1)*anz_fuzzy,ones(1,anz_fuzzy));ind_aktiv=ind_aktiv+1+rem(0:length(ind_aktiv)-1,anz_fuzzy);
   %nur die Werte in ind_aktiv werden gebraucht
   U=U(:,ind_aktiv);
   praemisse=praemisse(:,ind_aktiv);
   %UND-Verknüpfung über Variablen wird vorbereitet, indem eine Matrix form aufgestellt wird
   %Im Ergebnis wird später elementeweise (alle Terme aller Variablen) multipliziert
   %(z.B. U1=MI in Regelprämisse und als fuzzifiziertes Meßergebnis).
   %Bei Regeln mit abgeleiteten Termen (z.B. U1=MI ODER GR in Regelprämisse und im fuzzifizierten Meßwert)
   %sind die Teilergebnisse zu addieren (=1, wenn Meßwert zwischen MI und GR)
   %(Kronecker-Multiplikation erzeugt die Formmatrix zur Addition)
   %i.-te  Spalte hat Einsen zwischen (max. Anzahl Terme)*(i-1)+1 und (max. Anzahl Terme)*i, sonst Nullen
   form=sparse(1:length(ind_merkmal)*anz_fuzzy,kron([1:length(ind_merkmal)],ones(1,anz_fuzzy)),1,length(ind_merkmal)*anz_fuzzy,length(ind_merkmal));
   
   %Punkt-Multiplikation Prämisse und fuzzifizierte Werte und Zusammenfassung mit Form-Matrix
   %Fallunterscheidung wegen MATLAB-Bug nötig
   if (length(ind_merkmal)>1) 
      rule_praem_ausw=prod(((ones(size(U,1),1)*praemisse).*U*form)');
   else
      rule_praem_ausw=((ones(size(U,1),1)*praemisse).*U*form)';
   end;
else %immer gültige Regel
   rule_praem_ausw=ones(1,size(U,1));
end;
