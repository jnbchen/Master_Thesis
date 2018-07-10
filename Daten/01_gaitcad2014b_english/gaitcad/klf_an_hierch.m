  function pos_hierch=klf_an_hierch(d, klass_hierch_bayes)
% function pos_hierch=klf_an_hierch(d, klass_hierch_bayes)
%
%  Berechnet das Klassifikationsergebnis des mit klf_en_hierch entworfenen hierchischen Klassifikators
%  zum Abspalten von Klassen.
% 
%  Eingabeargumente:
%  d:                 Datenmatrix
%  klass_hierch_bayes.hierch_param:     Parameter für Klassifikation wie Klassenmittelpunkte, Kov.mat., InvKovMat, logdetkov
%  klass_hierch_bayes.hierch_klass:     Reihenfolge der abgespaltenen Klassen
%  klass_hierch_bayes.hierch_merkmale: ausgewählte Merkmale in den jeweiligen Hierarchiestufen
%  klass_hierch_bayes.Metrik:           Metrik des statistischen Klassifikators, 1: eukl., 2: Mahalanobis, 3: Tatsuoka, usw.
% 
%  Ausgabeargumente:
%  pos_hierch:        Klassifikationsergebnisse für jedes Datentupel
% Umstellung neue auf alte Datenstrukturen;
%
% The function klf_an_hierch is part of the MATLAB toolbox Gait-CAD. 
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

hierch_merkmale=klass_hierch_bayes.hierch_merkmale;
hierch_param=klass_hierch_bayes.hierch_param;
hierch_klass=klass_hierch_bayes.hierch_klass;
Metrik=klass_hierch_bayes.Metrik;

pos_hierch=zeros(size(d,1),1);
ind_hierch=1:size(d,1);

for NrKlasse=1:size(hierch_klass,1)
   
   % Mit jeweiligem Merkmalssatz arbeiten
   Merkmale=hierch_merkmale(NrKlasse,find(hierch_merkmale(NrKlasse,:)));
   
   % evtl. Diskrimnanz
   if ~isempty(hierch_param{NrKlasse,5}) 
      dat=d(ind_hierch,Merkmale)*hierch_param{NrKlasse,5};
   else dat=d(ind_hierch,Merkmale); 
   end;
   
   % Wenn hierarchisch keine Klassen mehr abgespalten werden können, dann Klassifikation in einem Schritt
   if length(Merkmale)==size(hierch_merkmale,2)
      [pos,md,prz]=klf_an6(dat,hierch_param{NrKlasse,1},0,hierch_param{NrKlasse,2},hierch_param{NrKlasse,3},hierch_param{NrKlasse,4},Metrik,0); 
      pos_hierch(ind_hierch)=pos;
      break;				% Aus for-Schleife raus
   end;
   
   % Klassifikation
   [pos,md,prz]=klf_an6(dat,hierch_param{NrKlasse,1},0,hierch_param{NrKlasse,2},hierch_param{NrKlasse,3},hierch_param{NrKlasse,4},Metrik,0); 
   
   % Klassifikation gemäß Hierarchie zuordnen
   gefunden=find(pos==hierch_klass(NrKlasse));
   pos_hierch(ind_hierch(gefunden))=hierch_klass(NrKlasse);
   
   % und entsprechende Datentupel löschen
   ind_hierch(gefunden)=[];
   
end;


