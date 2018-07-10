  function [klass_hierch_bayes, konf_neu]=klf_en_hierch(d_org, code, maxAnzMerk, fehlermax, maxDim, Metrik)
% function [klass_hierch_bayes, konf_neu]=klf_en_hierch(d_org, code, maxAnzMerk, fehlermax, maxDim, Metrik)
%
%  Die Funktion erstellt einen Klassifikator zur hierarchischen Klassifikation
%  des Datenmaterials d_org. Sukzessive wird dabei eine nach der anderen Klasse
%  erkannt und entfernt.
% 
%  Eingabeargumente:
%  d_org:             Datenmatrix
%  code:              Klassenlabel
%  maxAnzMerk:        maximale Anzahl zu betrachtender Merkmale
%  fehlermax:     max. zulässiger Fehler zum Abspalten einer Klasse
%  maxDim:            Dimension für Merkmalsaggregation
%  Metrik:            Metrik für statistischen Klassifikator. 1: euklid., 2:Mahalanobis, 3:Tatsuoka
% 
%  Ausgabeargumente als Bestandteile von klass_hierch
%  hierch_param:  Parameter für Klassifikation wie Klassenmittelpunkte, Kov.mat., InvKovMat, logdetkov
%  hierch_klass:  Reihenfolge der abgespaltenen Klassen
%  hierch_merkmale:ausgewählte Merkmale in den jeweiligen Hierarchiestufen
% 
%
% The function klf_en_hierch is part of the MATLAB toolbox Gait-CAD. 
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

if nargin < 6
   Metrik=3; 
end;					% 3: "Tatsuoka-Metrik"
if nargin < 5
   maxDim=3; 
end;					% max. Dimension bei Merk.agg.
if nargin < 4
   fehlermax=0.01; 
end;			% Kosten zulässiger Fehlklassifikationen
if nargin < 3
   maxAnzMerk=8;
end;			% max. verfügbare Anzahl an Merkmalen

hierch_param=[];					% Cell-Array, enthält Mittelpunkte und Kovarianzmatrizen erkannter Klassen
hierch_klass=[];					% enthält erkannte Klassen
merkmal_auswahl_ges=[];			% enthält aktuell zu verwendenden Merkmalssatz (bzw. deren Nummern)
hierch_merkmale=[];				% enthält Merkmale bzw. deren Kombinationen die zum Erkennen einer Klasse notwendig waren
fehler_einzeln=[];				% Fehlervektor, jedes Element steht für die Anzahl an Fehlern, die durch Reduktion um eine Klasse entstehen
konf_neu=zeros(length(findd(code)));	% Konfusionsmatrix
select=ones(max(code));			% Kostenmatrix (alle Kosten sind 1)

ind_auswahl=1:size(d_org,1);

if size(d_org,2)<maxAnzMerk 
   maxAnzMerk=size(d_org,2); 
end;
if size(d_org,2)<maxDim 
   maxDim=size(d_org,2); 
end;

% Solange noch nicht alle Klassen klassifiziert sind
while ~isempty(findd(code))
   
   % Für alle Merkmale Abstände zwischen den Klassen berechnen, hierdurch optimales Merkmal finden
   Max=[0 0];
   for i=1:size(d_org,2)			% suboptimal, wenn gut zu separierende Klasse nicht durch ein Merkmal gefunden werden kann.
      [maxkla, tmp, hierch_param_hilf] = klassdist(d_org(:,[merkmal_auswahl_ges i]),code,0);   
      fprintf('%d\n',i);
      if maxkla>=Max(1) 
         Max(1)=maxkla; 
         Max(2)=i; 
      end;
   end;
   
   % neu gefundenes Merkmal in Merkmalsauswahl mitaufnehmen, Merkmal bei nächster Suche nicht mehr berücksichtigen
   merkmal_auswahl_ges=[merkmal_auswahl_ges Max(2)];
   ind_auswahl(find(ind_auswahl==Max(2)))=[];
   
   % Datenmatrix (Kov.matrizen etc.) zusammenstellen
   d=d_org(:,merkmal_auswahl_ges);
   [maxkla, dist, hierch_param_hilf] = klassdist(d,code,0);			 
   
   % Maximal maxDim-dimensional, sonst Diskriminanz mit Optimierung
   [tmp, index] = sort(-dist); 
   hilf=findd(code); 
   index=hilf(index); % Achtung! Indizierung entspricht durch sort nicht der Klassenzugehörigkeit
   
   phi_dis=[];
      
   
   if (length(merkmal_auswahl_ges)>maxDim) && (length(merkmal_auswahl_ges)<maxAnzMerk)
      
      % Startparameter für Transformationsmatrix festlegen
      hilf_d=d; 
      hilf_code=code; 
      for i=1:maxDim
         if length(findd(hilf_code))>=2		% sonst existiert nur eine übriggebliebene Klasse -> Abstandsberechnung wird schwierig ;-)
            phi_dis=[phi_dis [mean(hilf_d(hilf_code==index(i),:))- mean(hilf_d(hilf_code~=index(i),:))]'];
            hilf_d(find(hilf_code==index(i)),:)=[]; hilf_code(find(hilf_code==index(i)))=[];   
         else 
            phi_dis=[phi_dis ones(size(phi_dis,1),1)]; 
         end;
      end;
      
      % nach vorgegebenem Gütekriterium optimieren
      fprintf('Optimize ... \n');
      change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));											% Parameter, die optimiert werden dürfen
      phi_dis=optimiere(phi_dis, change_param, code, d, 1, 'guete_hierch', 1);					% neuen Transformationsvektor aus altem TV berechnen
      
      % Transformation durchführen;
      d=d*phi_dis;
      
      % Wenn Merkmalsauswahl zu lange dauert, dann übrig gebliebene Klassen direkt klassifizieren   
   elseif length(merkmal_auswahl_ges)>=maxAnzMerk 
      fehlermax=1e100; 
      fprintf('\nMaximum number of features is too small\n');
      
      %Als Startparameter herkömmliche Diskriminanzanalyse
      [tmp,tmp,s_dis,tmp,tmp]=klf_en6(d,code);
      [d_dis,phi_dism,davpm]=merk_opt1(d,s_dis,maxDim,code);
      phi_dis=phi_dism';
      clear tmp s_dis phi_dism merkmal_auswahl_ind;
      % nach vorgegebenem Gütekriterium optimieren
      change_param=find(phi_dis(:,1))*ones(1,size(phi_dis,2));				% Parameter, die optimiert werden dürfen
      %ÄNDERUNG Sebastian (30.09.05): im Gait-CAD-Projekt wird die Funktion guete_bestklass_g verwendet
      %phi_dis=optimiere(phi_dis, change_param, code, d, 1, 'guete_bestklass', -1);					% neuen Transformationsvektor aus altem TV berechnen
      optionen.metrik = Metrik;
      phi_dis=optimiere(phi_dis, change_param, code, d, 1, 'guete_bestklass_g', -1, 1E-3, optionen);
      
      d=d*phi_dis;
   end;
   
   [maxkla, dist, hierch_param_hilf] = klassdist(d,code,0);			% Parameterextraktion für später 
   
   
   %es gibt Konstellationen, wo keine Transformation existiert - da muss es eine Einheitsmatrix sein
   if isempty(phi_dis)
      phi_dis = eye(size(d,2));
   end;
   
   
   % Berechne Klassifikationsgüten des gefundenen Parametersatzes   
   [kl,su,s,s_invers,log_s]=klf_en6(d,code,0);
   [pos,md,prz]=klf_an6(d,kl,su,s,s_invers,log_s,Metrik,0);
   [konf,fehlproz]=klass9(d,code,pos,prz,-1);
   
   % Berechne Maß für die Güte der Klassifikation
   p_stern=0.5; 						% Knickpunkt der Guetefunktion
   mEins=[0.63 0.1575];				% Punkt, an dem die Steigung der gewählten Kurve  eins ist (gewählte Kurve: y=x^4)
   fehler=[];
   
   for j=findd(code)
      Q=0;
      for i=1:length(code) 
         if j==code(i)					% falsche Klassifikationen
            Q=Q+select(j,j)*((prz(i,code(i))/100<0.5)*(1-2*prz(i,code(i))/100)+1-(prz(i,code(i))/100));	%+(prz(i,code(i))/100<0.5));   
         end;
      end;
      fehler=[fehler Q];
   end;  
   
   fprintf('Error: '); 
   fprintf('%1.2f ',fehler); 
   fprintf('\n');
   
   hilf=findd(code);										% Welche Klassen existieren noch?
   
   % Klasse(n) konnte extrahiert werden, d.h. Gütemaß ist ausreichend
   for i=find(fehler<=fehlermax)						% Für alle Klassen, die wenige Fehler aufweisen
      
      %figure; hold on; nummerierung=1; plot_klass;
      fprintf('Class %i removed\n', hilf(i));
      
      % Erkannte Klassen löschen -> Restklassenproblem
      d(find(code==hilf(i)),:)=[];				% nur für den Fall einer Zeichenumgebung nötig
      d_org(find(code==hilf(i)),:)=[];				
      code(find(code==hilf(i)))=[];
      
      % Merkmalskombination, erkannte Klassen und Fehler merken
      if isempty(hierch_merkmale)          
         hierch_merkmale=merkmal_auswahl_ges;			% beim ersten Mal
      else          
         hierch_merkmale=[hierch_merkmale zeros(size(hierch_merkmale,1),length(merkmal_auswahl_ges)-size(hierch_merkmale,2)); merkmal_auswahl_ges];
      end;
      hierch_klass=[hierch_klass; hilf(i)];   				% erkannte Klasse merken   
      konf_neu(1:size(konf,1),hilf(i))=konf(:,hilf(i));	% Konfusionsmatrix neu berechnen
      hierch_param=[hierch_param; hierch_param_hilf {phi_dis}];		% Mittelwerte und KOv.matrizen merken
   end;
   
   % Wenn nur noch eine Klasse übrig ist, dann kann diese auch erkannt werden (passiert, wenn von drei übrig gebliebenen Klassen zwei innerhalb der Fehlertoleranz liegen
   if length(findd(code))==1
      hilf(i)=findd(code);
      fprintf('Class %i removed\n', hilf(i));
      code(find(code==hilf(i)))=[];
      % Merkmalskombination, erkannte Klassen und Fehler merken
      hierch_merkmale=[hierch_merkmale zeros(size(hierch_merkmale,1),length(merkmal_auswahl_ges)-size(hierch_merkmale,2)); merkmal_auswahl_ges];
      hierch_klass=[hierch_klass; hilf(i)];   				% erkannte Klasse merken   
      konf_neu(1:size(konf,1),hilf(i))=konf(:,hilf(i));	% Konfusionsmatrix neu berechnen
      hierch_param=[hierch_param; hierch_param_hilf {phi_dis}];		% Mittelwerte und KOv.matrizen merken
   end;
   ind_auswahl=1:size(d_org,1);
end;

%Umstellung alte auf neue Datenstrukturen;
klass_hierch_bayes.hierch_merkmale=hierch_merkmale;
klass_hierch_bayes.hierch_param=hierch_param;
klass_hierch_bayes.hierch_klass=hierch_klass;
klass_hierch_bayes.Metrik=Metrik;