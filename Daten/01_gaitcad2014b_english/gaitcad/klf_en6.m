  function  [kl,su,s,s_invers,log_s,p_apriori]=klf_en6(d_org,code,anzeige)
% function  [kl,su,s,s_invers,log_s,p_apriori]=klf_en6(d_org,code,anzeige)
%
%  berechnet Mittelwerte und verschiedene Kovarianzmatrizen
%  von Datenmatrix d_org für gegebene Klasseneinteilung code
% 
%  Eingangsvariablen:
%  d_org       -> Datenmatrix - size(d_org,2) (Mess-) Werte und size(d_org,1) Datentupel
%  code        -> Klassencode
%             (!!!code von 1 bis kl_anz!!!)
% 
%  Ausgangsvariablen:
%  kl      -> Klassenmittelpunkte
%  su      -> biasfreie Kovarianzmatrix des gesamten Datenmaterials
%  s       -> Kovarianzmatrizen der Klassen s - als Blockmatrix
%  s_invers    -> Inverse von s bzw. der Ersatzmatrix (Diagonalmatrix der Streuungen)
%  log_s       -> Logarithmus der Determinante von s bzw. der Ersatzmatrix
%  p_apriori       -> geschätzte A-Priori-Wahrscheinlichkeiten der Klassen
% 
%
% The function klf_en6 is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin==2) 
   anzeige=1;
end;

%max. Anzahl Klassen
kl_anz=max(code);
if anzeige 
   fprintf('\nCreate classifier ... \n');
end;
anz_merk=size(d_org,2);
kl=NaN*ones(kl_anz,size(d_org,2));

%Voraussetzung zur Berechnung der Kovarianzmatrix: genügend Beispiele pro Klasse
%(mindestens Anzahl der Merkmale)
[a,b]=hist(code,findd(code));
if (min(a)<anz_merk) 
   fprintf(1,'Representative of the class:\n');fprintf(1,'%d  ',a);
   warning('Too few data or unoccupied classes.');
end;

%Elemente, die zur Klasse gehören
ind=zeros(kl_anz,size(d_org,1));

%biasfreie Summen-Kovarianzmatrix su
%dabei muss in Kovarianzmatrix unbedingt durch N geteilt werden !!, deswegen cov(..,1)
su=cov(d_org,1);

%ACHTUNG Änderung: geht auch für unvollständige Klassen - wichtig bei Datenauswahl!!
for i=findd(code)				%!!!Klassencodes beginnen bei Klasse 1
   
   %Klassenvertreter raussuchen
   ki=find(code==i);
   anz_ind(i)=length(ki);
   p_apriori(i)=anz_ind(i)/length(code); % Berechnung der a-priori Wahrscheinlichkeit
   
   %Mittelwerte berechnen
   kl(i,:)=mean(d_org(ki,:),1);
   
   %Kovarianzmatrizen der Klassen s - als Blockmatrix
   %dabei muss in Kovarianzmatrix unbedingt durch N geteilt werden !!, deswegen cov(..,1)
   if length(ki)>1 
      klkov=cov(d_org(ki,:),1);
   else         
      klkov=eye(anz_merk);  %numerische Probleme, wenn nur ein Klassenvertreter!!!
   end;
   
   
   %Rangabfall bzw. MATLAB-Rechenfehler mit negativen Kovarianzmatrizen
   if (det(klkov) < 10e-5*det(su))
      klkov=klkov+0.001.*eye(size(su)).*su;
      fprintf(1,'Rank deficit in class %d (standard deviation of feature =0) was rectified (1 per mill covariance matrix of whole data)...\n',i);
   end;
   
   s((i-1)*anz_merk+[1:anz_merk],:)=klkov;
   
   %Vorbereitung für Diskriminanz: Invertieren der Klassen-Kovarianzmatrizen         
   %wenn Rangverlust, dann nur Invertieren einer Diagonalmatrix mit Streuungen auf der
   %Hauptdiagonale
   if (rank(klkov)<anz_merk) 
      s_invers((i-1)*anz_merk+[1:anz_merk],:)=pinv(klkov.*eye(anz_merk));
      log_s(i)=0;
      fprintf(1,'\nAttention! Decay of rank class covariance matrix of class %d !\nSubstitution against pseudoinverse.\n',i);
   else
      s_invers((i-1)*anz_merk+[1:anz_merk],:)=pinv(klkov);
      log_s(i)=log(det(klkov));
   end;
end; 

if anzeige 
   fprintf('Complete ... \n');
end;