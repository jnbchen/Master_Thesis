  function [C_dis,phi_dis,davp,A]=merk_opt1(dat,s,merk_red,code,anzeige)
% function [C_dis,phi_dis,davp,A]=merk_opt1(dat,s,merk_red,code,anzeige)
%
% Diskriminanzanalyse, gibt die besten merk_red Merkmale zurück, die aus
% Datenmaterial dat und klassenspezifischen Kovarianzmatrizen s berechnet
% werden
% Ergebnisse stehen in C_dis (transformierte Merkmale), phi_dis (zugehörige
% Eigenvektoren, davp (prozentuale Anteile) und A (Matrix) inv(W)*B
% 
% Anzeige=1 ist default
%
% The function merk_opt1 is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<5)
   anzeige=1;
end;
kl_anz=size(s,1)/size(s,2);

if (anzeige)
   fprintf('Discriminant analysis ... \n');
   fprintf('Selection of %d out of %d features... \n',merk_red,size(dat,2));
end;

%ursprüngliche Anzahl der Merkmale
anz_merk=size(dat,2);

%Totale Varianz
%mit der Anzahl der Datentupel multiplizierte Kovarianzmatrix
%ACHTUNG FEHLERKOREKTUR cov(dat) gegen cov(dat,1) !!!!!
T=size(dat,1)*cov(dat,1);

%Binnenklassenvarianz
%mit der Anzahl der Klassenvertreter multiplizierte Klassen-Kovarianzmatrizen
W=zeros(anz_merk,anz_merk);
for i=1:kl_anz
   W=W+length(find(code==i))*s((i-1)*anz_merk+[1:anz_merk],:);
end;


%Zwischenklassenvarianz
B_old=T-W;W_old=W;

%ACHTUNG jetzt neu: jetzt robustere Alternativberechnung
%UNTERSCHIEDE NUR BEI MANIPULIERTEN INNERKLASSEN-KOV-MATRIZEN WEGEN UNGENÜGENDER BESETZUNG!!!
B=zeros(anz_merk,anz_merk);
for i=findd(code)
   ind_i=find(code==i);
   n_i=length(ind_i);
   n=size(dat,1);
   tmp=(1/n_i*ones(1,n_i)*dat(ind_i,:)-1/n*ones(1,n)*dat);
   B=B+n_i*tmp'*tmp;
end;
W=T-B;

%Diskriminanzkriterium
if rank(W)<size(W,1) 
   warning(sprintf('Loss of rank of the inner class covariance W!\nUtilise the pseudoinverse.\n'));
   A=pinv(W)*B;
else
   A=inv(W)*B;
end;

%Eigenwerte lambda und Eigenvektoren Gamma
[gamma,lambda]=eig(A,'nobalance');

%Eigenwerte lambda extrahieren und sortieren
davus=diag(real(lambda));
[dav,ind]=sort(-davus);

%prozentuale Anteile berechnen Eigenwert/Summe der Eigenwerte
davp=dav/sum(dav);

%Eigenvektoren für die gesuchten Besipiele
phi_dis=real(gamma(:,ind(1:merk_red)))';

%Berechnung der transformierten Merkmale
C_dis=dat*phi_dis';

if anzeige
   fprintf('The first %d discriminant functions provide total information in %% : \n',min(10,size(dat,2)));
   for i=1:min(10,size(dat,2)) 
      fprintf('%2d %5.1f %% \n',i,100*sum(davp(1:i)));
   end;
   fprintf('\nComplete... \n');
end;



