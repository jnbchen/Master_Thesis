  function [l,hkvp,sigma,hkv]=hauptk_ber(y,normieren)
% function [l,hkvp,sigma,hkv]=hauptk_ber(y,normieren)
%
%  Hauptkomponentenanalyse
%  y         - Datenmatrix
%  normieren - Normieren auf gleiche Varianz
%  l         - Eigenvektoren der Korrelationsmatrix
%  hkvp      - Beitrag der Eigenvektoren der Korrelationsmatrix (in  der Eigenwerte)
%  sigma     - (u.U. normierte) Kovarianzmatrix
%  y         - (u.U. normierte) Datenmatrix
% 
%  ACHTUNG !! ƒnderung : normieren=-1 arbeitet unzentriert und ohne Standardisierung
% 
%  Datenmatrix y:
%  Zeile:  size(y,1) - Anzahl Datentupel
%  Spalte: size(y,2) - Anzahl Merkmale
%  Matrix mit 5 Zeilen und 15 Spalten enthaelt 5 Datentupel, zu denen je 15 Merkmale
%  bekannt sind - je mehr Datentupel, desto mehr kann zur Aussagekraft der Merkmale gesagt
%  werden
% 
%  Sigma ist Korrelationsmatrix und liefert Information, wie die Matrix-Spalten
%  miteinander zusammenh‰ngen - d.h. sigma(1,2)=0.9 heiﬂt, 1. Spalte stark positiv
%  mit zweiter Spalte korreliert; 0 gar nicht, -1 stark negativ
% 
%  Eigenvektoren stehen in den Spalten von l - 1. Spalte gehˆrt zum ersten Element von
%  interessante Demo:
%  a=rand(50,4);a(:,5)=0.7*a(:,4)+0.3*rand(50,1);[l,hkvp,sigma]=hauptk_ber(a,1)
%  starke Korr. 4. und 5. Spalte, hohe Wertigkeit 1. Eigenvektor im 4. und 5. Element
% 
%
% The function hauptk_ber is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('\nPrincipal Component Analysis... \n')
fprintf('%d data points, %d features ... \n',size(y))

%Werte Null?
ind=find(~std(y));
if ~isempty(ind) 
   fprintf('Warning! Some features have zero variance-> rank deficit for correlation\nRegularization necessary!\n');
   y(:,ind)=y(:,ind)+1E-11*randn(size(y,1),length(ind));
end;

% Kovarianzmatrix Sigma (nach Normierung)
% Mittelwerte abgezogen, gleiche Varianz der Meﬂwerte
if (normieren==1)  
   sigma=corrcoef(y);
end;

%Mittelwerte abgezogen, ungleiche Varianzen der Meﬂwerte
if (normieren==0)  
   my=mean(y);
   y=y-ones(size(y,1),1)*my;
   sigma=cov(y);
end;

%Mittelwerte nicht abgezogen, ungleiche Varianzen der Meﬂwerte
if (normieren==-1) 
   sigma=cov(y);
end;


% Eigenwertzerlegung wegen sigma=gamma'^-1*lambda*gamma^-1
[gamma,lambda]=eig(sigma);
hkvus=diag(lambda);
[hkv,ind]=sort(-hkvus);
hkvp=hkv/sum(hkv);
l=gamma(:,ind);

fprintf('The first %d aggregated features from PCA contain information in %% : \n',round(min(10,size(y,2))) );	
for i=1:min(10,size(y,2)) 
   fprintf('%2d %5.1f %% \n',i,100*sum(hkvp(1:i)));
end;

%bei normierten Werten muﬂ von links an die Matrix 
%der Eigenvektoren noch die Normierungsmatrix ranmultipliziert
%werden, damit mit dem Ursprungsdatenmaterial weitergearbeitet 
%werden kann:
if (normieren==1) 
   l=diag(1./std(y))*l;
end;

fprintf('Complete ... \n');