  function [c2_neu,praemissen_neu]=c2update(c2,praemissen,regel_praemisse,par)
% function [c2_neu,praemissen_neu]=c2update(c2,praemissen,regel_praemisse,par)
%
% berechnet neue c2-Matrix, die mit neuer Regel (regel_praemisse) entsteht
% (Nullspalten werden weggelassen)
% und gibt erweiterte Regelbasis (Prämissen) mit überdeckenden Teilregeln zurück
% ACHTUNG !
%   - Regelbasis muß vorher mittels pla2plav in volle Regelstruktur umgewandelt werden !!!
% 
% UND-Verknüpfung über Variablen wird vorbereitet, indem eine Matrix form aufgestellt wird
% Im Ergebnis wird später elementeweise (alle Terme aller Variablen) multipliziert
% (z.B. U1=MI in Regelprämisse und als fuzzifiziertes Meßergebnis).
% Bei Regeln mit abgeleiteten Termen (z.B. U1=MI ODER GR in Regelprämisse und im fuzzifizierten Meßwert)
% sind die Teilergebnisse zu addieren (=1, wenn Meßwert zwischen MI und GR)
% (Kronecker-Multiplikation erzeugt die Formmatrix zur Addition)
% i.-te  Spalte hat Einsen zwischen (max. Anzahl Terme)*(i-1)+1 und (max. Anzahl Terme)*i, sonst Nullen
%
% The function c2update is part of the MATLAB toolbox Gait-CAD. 
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

form=sparse(1:size(regel_praemisse,2),kron([1:par(2)],ones(1,size(regel_praemisse,2)/par(2))),...
   1,size(regel_praemisse,2),par(2));

[m,n]=size(c2);
c2_neu=[eye(m+1) [c2(:,m+1:n);zeros(1,n-m)]];
if m>1
   praemissen_neu=[praemissen(1:m,:);regel_praemisse;praemissen(m+1:n,:)];
else
   praemissen_neu=[praemissen(1:m,:);regel_praemisse];
end

%UND-Verknüpfung alte Regeln mit neuer Regel (regelweise)
verk_mat=praemissen.*(ones(size(praemissen,1),1)*regel_praemisse);

%wo gibt es nicht leere Schnitt-Mengen?
ind=find(prod((verk_mat*form)'));

if ~isempty(ind)
   praemissen_neu=[praemissen_neu;verk_mat(ind,:)];
   
   %nur Struktur für anzuhängende c2-Matrix
   c2_neu_tmp=[c2(:,ind)~=0;ones(1,length(find(ind)))];
   tmp=sum(c2_neu_tmp);
   
   %Wichtungsfaktoren in c2-Matrix
   c2_neu_tmp=c2_neu_tmp./(ones(size(c2_neu_tmp,1),1)*tmp).*...
      (-1*ones(size(c2_neu_tmp))).^(ones(size(c2_neu_tmp,1),1)*(tmp-1));
   c2_neu=[c2_neu c2_neu_tmp];
end
