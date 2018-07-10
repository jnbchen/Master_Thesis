  function export_ansi_c_bayes(datei,phi_last,kl, var_bez, s, s_invers, log_s, su, Metrik, code_alle, d_org, zgf_bez)
% function export_ansi_c_bayes(datei,phi_last,kl, var_bez, s, s_invers, log_s, su, Metrik, code_alle, d_org, zgf_bez)
%
% erzeugt C-Quellcode für einen Bayes-Klassifikator
%
% The function export_ansi_c_bayes is part of the MATLAB toolbox Gait-CAD. 
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

if nargin < 12 
   zgf_bez_def=0; 
else 
   zgf_bez_def=1; 
end;
if nargin < 11 
   d_org=0; 
end;
if nargin < 10 
   code_alle=0; 
end;
if nargin < 9 
   Metrik=3; 
end;            % Tatsuoka als Standardmetrik

%number of features 
NrMerkmale=find(any(phi_last,2));
AnzahlMerkmale=length(NrMerkmale);
AnzahlKlassen=size(kl,1);
AnzahlDiskr=size(phi_last,2);
Metrikart=0;                                % unterscheidet klassenspez. Metriken von Gesamtmetriken (1: klassspez. 2:gesamt)
Diagonaldominanz=1;                     % kleiner, je kleiner der Einfluss von Nebenelementen der Kovmatrix
DiagDomSchwell=0.1;                     % Schwellwert für Diagonaldominanz
AnzMerkZeile=10;                            % Anzahl Merkmale, die in eine Zeile geschrieben werden sollen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Metrik festlegen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (Metrik == 1)                        %Euklidische Distanz
   su=eye(AnzahlDiskr);
   su_invers=su;
   log_det_su=0;
   Metrikart=2;
elseif (Metrik == 2)                    % Mahalanobis Distanz
   Metrikart=2;                     % Übergabeparameter können weiterverwendet werden
   su_invers=pinv(su);
   log_det_su=log(det(su));
elseif (Metrik == 3)                    % Tatsuoka Distanz
   Metrikart=1;                     % Übergabeparameter können weiterverwendet werden
elseif (Metrik == 4)                    % Varianznormierung (HD) Mahalanobis
   Metrikart=2;
   su_invers=pinv(su.*eye(AnzahlDiskr));
   log_det_su=log(det(su));
elseif (Metrik == 5)                    % gemittelte Klassenkovarianzen
   Metrikart=2;
   su=zeros(size(AnzahlDiskr));
   for i=1:AnzahlKlassen            % Klasskovmat mitteln
      s_einz=(s((i-1)*AnzahlDiskr+1:i*AnzahlDiskr,:));
      su=su + s_einz./AnzahlKlassen;
   end;
   su_invers=pinv(su);
   log_det_su=log(det(su));   
elseif (Metrik == 6)                    % gemittelte Klassenkovarianzen mit Varianznormierung
   Metrikart=2;
   su=zeros(size(AnzahlDiskr));
   for i=1:AnzahlKlassen            % Klasskovmat mitteln
      s_einz=(s((i-1)*AnzahlDiskr+1:i*AnzahlDiskr,:));
      su=su + s_einz./AnzahlKlassen;
   end;
   su_invers=pinv(su.*eye(AnzahlDiskr));    % Diagonalelemente extrahieren
   log_det_su=log(det(su));   
end;

if (Metrikart == 2)                 % Wie groß ist der Anteil der Nebenelemente der Kovmatrix?
   Diagonaldominanz = max((sum(abs(su))-abs(diag(su))')./sum(abs(su)));
end;

f=fopen(sprintf('%s.c',datei),'wt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Funktionskopf + Kommentare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(f,'int klass_bayes (double *x, double *p)\n');
fprintf(f,'/* Attention, Indexing of vector x is displaced.\n'); 
fprintf(f,'x has to start with a zero, then the features\n');
fprintf(f,'The same is valid to returning vector p (Likelihood of classes for x)\n');
fprintf(f,'Essential: Including of math.h\n\n');
fprintf(f,'Call:\n');
fprintf(f,'  double x[]={0, x1, x2, x3, ... }\n');
fprintf(f,'  double y[AnzahlKlassen+1]; \n');
fprintf(f,'  int ZG; \n');
fprintf(f,'  ZG=klass_bayes(x,y);\n\n');

cl=clock;
fprintf(f,'Project: %s.prj, %s, %02d:%02d \n',datei,date,cl(4:5));

fprintf(f,'Following features are utilised:\n');                              % Merkmalsbezeichner
for iLauf=1:AnzahlMerkmale
   fprintf(f,'// x[%d]: %s \n',iLauf, var_bez(NrMerkmale(iLauf),:)');
end;
fprintf(f,'\n');

if (zgf_bez_def)                                                                        % Klassenbezeichnungen
   fprintf(f,'Used classes:\n');
   for iKlasse=1:AnzahlKlassen
      fprintf(f,'class identifier 1: %s\n', zgf_bez(size(zgf_bez,1),iKlasse).name);
   end;
   fprintf(f,'\n');
end;

fprintf(f,'Used metrics: %i\n\n', Metrik);

fprintf(f,'class identification ..... globale constants?...');       

if all(all(code_alle)~=0) && (AnzahlMerkmale < 2*AnzMerkZeile)                     % Beispieldatensätze
   fprintf(f,'\nexemplarily test data sets (features with which the classifier is fed (see.above.):\n');                % Testdatensätze generieren
   for iLauf=1:AnzahlKlassen
      fprintf(f,'class %d: ', iLauf);
      fprintf(f,'double x[]= {0 ');
      hilf=d_org(max(find(code_alle==iLauf)), find(phi_last(:,1)));
      fprintf(f,', %1.5f',hilf);
      fprintf(f,'};\n');
   end;   
end;

fprintf(f,'*/\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Variablen deklarieren %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(f,'\n\n{');
fprintf(f,'\n  // declare varaibles\n');
fprintf(f,'  double Mittel[%d][%d]; \n', AnzahlKlassen+1,AnzahlDiskr+1);
fprintf(f,'  double x_d[%d];\n', AnzahlDiskr+1);
fprintf(f,'  double Wahrscheinlichkeit_gesamt = 0; \n');
fprintf(f,'  double maxp=0; \n');
fprintf(f,'  int ZG=0; \n');
if (Metrikart==2)&&(Diagonaldominanz<DiagDomSchwell)
   fprintf(f,'  int iKlasse, iMerkmal;\n');
   fprintf(f,'  double Dist;\n');
   fprintf(f,'  double s_inv[%d]; \n', AnzahlDiskr+1);
   fprintf(f,'  double ln_det_kov;\n');
else    % Diagnoaldominanz liegt nicht vor
   fprintf(f,'  int iKlasse, iMerkmal, iMerkmal1, iMerkmal2;\n');
   fprintf(f,'  double Dist[%d];\n', AnzahlDiskr+1);
   if (Metrikart==1)
      fprintf(f,'  double s_inv[%d][%d][%d]; \n', AnzahlKlassen+1, AnzahlDiskr+1, AnzahlDiskr+1);
      fprintf(f,'  double ln_det_kov[%d];\n', AnzahlKlassen+1);
   elseif (Metrikart==2)
      fprintf(f,'  double s_inv[%d][%d]; \n', AnzahlDiskr+1, AnzahlDiskr+1);
      fprintf(f,'  double ln_det_kov;\n');
   else myerror('Wrong metrics!');
   end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Klassifikator festlegen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(f,'\n  // determine classifier\n');
fprintf(f,'  // Mean values: \n  ');
for iLauf=1:AnzahlKlassen
   for jLauf=1:AnzahlDiskr
      fprintf(f,'mean[%d][%d]= %1.5f; ',iLauf,jLauf,kl(iLauf,jLauf));
   end;
   fprintf(f,'\n  ');
end;

if (Metrikart==1)
   fprintf(f,'\n  // inverse covariance matrices\n  ');
   for iLauf=1:AnzahlKlassen
      for jLauf=1:AnzahlDiskr
         for kLauf=1:AnzahlDiskr
            fprintf(f,'s_inv[%d][%d][%d]= %1.5f; ',iLauf,jLauf,kLauf,s_invers((iLauf-1)*AnzahlDiskr+jLauf, kLauf) );
         end;
         fprintf(f,'\n  ');
      end;
      fprintf(f,'\n  ');
   end;
   fprintf(f,' // Logarithm of the determinant of the covariance matrix\n');
   for iLauf=1:AnzahlKlassen
      fprintf(f,'  ln_det_kov[%d]=%1.5f;\n', iLauf, log_s(iLauf));   
   end;
elseif (Metrikart==2)
   if (Diagonaldominanz>DiagDomSchwell)     % keine Diagonaldominanz
      fprintf(f,'\n  // inverse covariance matrices\n  ');
      for jLauf=1:AnzahlDiskr
         for kLauf=1:AnzahlDiskr
            fprintf(f,'s_inv[%d][%d]= %1.5f; ',jLauf,kLauf,su_invers(jLauf,kLauf));
         end;
         fprintf(f,'\n  ');
      end;
   else             % Diagonaldominanz liegt vor
      fprintf(f,'\n  // diagonal elements of the inverse covariance matrix\n  ');
      for kLauf=1:AnzahlDiskr
         fprintf(f,'s_inv[%d]= %1.5f; ',kLauf,su_invers(kLauf,kLauf));
      end;
   end;
   fprintf(f,'\n\n  // Logarithm of the determinants of the covariance matrix\n');
   fprintf(f,'  ln_det_kov=%1.5f;\n', log_det_su);   
else myerror('Wrong metrics');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Diskriminanzfunktionen berechnen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
fprintf(f,'\n  // Calculate discriminant functions\n');
for jLauf=1:AnzahlDiskr
   fprintf(f,'  x_d[%d]=',jLauf);
   for iLauf=1:AnzahlMerkmale 
      Koeff=phi_last(NrMerkmale(iLauf),jLauf);
      if (iLauf>1) && (Koeff>0) 
         fprintf(f,'+');
      end;      
      fprintf(f,'%1.5f*x[%d]', Koeff, iLauf); 
      if (mod(iLauf,AnzMerkZeile)==0) fprintf(f,'\n          '); end;   % Zeilenumbruch, wenn zu lang
   end;   
   fprintf(f,';\n');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Klassenzugehörigk. berechnen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(f,'\n  // Calculate affiliation of classes\n');
fprintf(f,'  for (iKlasse=1; iKlasse<=%d; iKlasse++)\n  {\n',AnzahlKlassen);
fprintf(f,'    p[iKlasse]=0;\n');
if (Metrikart==2) && (Diagonaldominanz<DiagDomSchwell)
   fprintf(f,'    for (iMerkmal=1; iMerkmal<=%d; iMerkmal++)\n', AnzahlDiskr);
   fprintf(f,'    {\n');
   fprintf(f,'      Dist=');
   fprintf(f,'  x_d[iMerkmal]-Mittel[iKlasse][iMerkmal];\n');
   fprintf(f,'      p[iKlasse]+=s_inv[iMerkmal]*Dist*Dist;\n');
   fprintf(f,'    }\n');  
   fprintf(f,'    p[iKlasse]=exp(-(0.5*ln_det_kov+0.5*p[iKlasse]));\n');     
else        % keine Diagonaldominanz
   fprintf(f,'    // Distanz \n');
   fprintf(f,'    for (iMerkmal=1; iMerkmal<=%d; iMerkmal++)\n', AnzahlDiskr);
   fprintf(f,'      Dist[iMerkmal]=');
   fprintf(f,'  x_d[iMerkmal]-Mittel[iKlasse][iMerkmal];\n');
   fprintf(f,'\n    // Likelihood of affiliation to class iKlasse\n');
   fprintf(f,'    for (iMerkmal1=1; iMerkmal1<=%d; iMerkmal1++)\n', AnzahlDiskr);
   fprintf(f,'      for (iMerkmal2=1; iMerkmal2<=%d; iMerkmal2++)\n', AnzahlDiskr);
   if (Metrikart==1)
      fprintf(f,'        p[iKlasse]+=s_inv[iKlasse][iMerkmal1][iMerkmal2]*Dist[iMerkmal1]*Dist[iMerkmal2];\n');
      fprintf(f,'    p[iKlasse]=exp(-(0.5*ln_det_kov[iKlasse]+0.5*p[iKlasse]));\n');
   elseif (Metrikart==2)
      fprintf(f,'        p[iKlasse]+=s_inv[iMerkmal1][iMerkmal2]*Dist[iMerkmal1]*Dist[iMerkmal2];\n');
      fprintf(f,'    p[iKlasse]=exp(-(0.5*ln_det_kov+0.5*p[iKlasse]));\n');
   else myerror('Wrong metrics');
   end;
end;
fprintf(f,'    Wahrscheinlichkeit_gesamt+=p[iKlasse];\n');
fprintf(f,'  }\n');
fprintf(f,'\n  // Normalization\n');
fprintf(f,'  for (iKlasse=1; iKlasse<=%d; iKlasse++)\n',AnzahlKlassen);
fprintf(f,'  {\n');
fprintf(f,'    p[iKlasse]=p[iKlasse]/Wahrscheinlichkeit_gesamt;\n');
fprintf(f,'    if (p[iKlasse]>maxp)\n');
fprintf(f,'    {\n');
fprintf(f,'      maxp=p[iKlasse];\n');
fprintf(f,'      ZG=iKlasse;\n');
fprintf(f,'    }\n');
fprintf(f,'  }\n');
fprintf(f,'  return ZG;\n');
fprintf(f,'\n} // End of function\n');

fclose(f);

%Ergebnis anzeigen
viewprot(sprintf('%s.c',datei)); 
