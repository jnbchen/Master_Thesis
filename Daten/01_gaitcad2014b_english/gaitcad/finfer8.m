  function [ydach,mu_y,pos,s_glaub,glaub,glaub_roh]=finfer8(d_fuz,rulebase,par,zgfy,concl_default,wichtung,inferenz,anzeige)
% function [ydach,mu_y,pos,s_glaub,glaub,glaub_roh]=finfer8(d_fuz,rulebase,par,zgfy,concl_default,wichtung,inferenz,anzeige)
%
%   schätzt Ausgangsklasse ydach mittels einer gewählten Inferenzmethode und gibt
%   Gesamtglaubwürdigkeit s_glaub (= Abdeckung der Datentupel durch Regeln) und deren Einzelwerte
%   pro Regel (glaub) zurück
%   d_fuz         - fuzzifizierte Eingangsdaten
%   rulebase      - Regelbasis
%   par           - Parametervektor
%   zgfy          - ZGF-Parameter Ausgangsgröße
%   concl_default - Konklusion der Nichtregel
%   wichtung      - Vektor der Regelplausibilitäten (wenn 0, dann a)
%   inferenz      - ==1 JGM (Jäkel-Gröll-Mikut) - Fuzzy-Inferenz (default)
%                   ==2 SUM-PROD-Inferenz
%                   ==3 MAX-MIN-Inferenz
%   ACHTUNG !
%     - Nicht abgedeckte Regeln geben ydach=0 zurück !!
% 
%   Default: JGM-Inferenz
%
% The function finfer8 is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<7
   inferenz=1;
end;
if nargin<8
   anzeige=1;
end;


%interner Parameter: Inferenz bei über 11 Regeln
if (inferenz==1)&&(size(rulebase,1)>11)
   if (anzeige)
      mywarning('In case of great rulebases, JGM-interference is not efficiently. Hence, SUM-PROD-interference is utilized.');
   end;
   inferenz=2;
end;

%Regelbasis, aber ohne Ergebnisse und -statistik (Regelprämissen)

%Prämissen extrahieren (ab Element 5 in rulebase-Zeilen)
praemisse_nv=rulebase(:,5:size(rulebase,2));
anz_fuzzy=size(praemisse_nv,2)/par(2);

%andere Prämissenform erzeugen, bei der alle Terme nichtspezifizierter Variable (xl_=beliebig auf Eins gesetzt werden)
rulebase=pla2plav(rulebase,par);
praemisse=rulebase(:,5:size(rulebase,2));

%Regelplausibilitäten explizit angegeben  ?
%wenn nicht, dann automatisch setzen
if (nargin<6)
   wichtung=0;
end;

%automatisch setzen: immer 1, wenn keine Nullregel, die auf fast Null
ind_nichtleerepraemisse=find(~min(praemisse'));
if (wichtung==0)
   wichtung=~min(praemisse')'+1E-100;
end;

%wenn keine Defaultkonklusion angegeben, dann nehme die der letzten Regel if (nargin<5) concl_default=rulebase(size(rulebase,1),4);end;

%Rausstreichen aller irrelevanter Teile aus d_fuz und rules
%die ling. Variablen raussuchen, die irgendwo spezifiziert sind
anz_fuzzy=size(praemisse,2)/par(2);
[ind_aktiv,ind_merkmal]=findaktiv(praemisse_nv,anz_fuzzy);

if ~isempty(ind_aktiv)
   d_fuz=d_fuz(:,ind_aktiv);
   rulebase=rulebase(:,[1 2 3 4 4+ind_aktiv]);
   praemisse=praemisse(:,[ind_aktiv]);
   par=[size(d_fuz,1) length(ind_merkmal) par(3:4) par(4+ind_merkmal)];
end;


%keine gültige Regel!
if isempty(ind_merkmal)
   
   if (rulebase(1,4) == 0)
      rulebase(1,4) = 1;
   end;
   
   ydach=rulebase(1,4)*ones(size(d_fuz,1),1);
   pos=ydach;
   glaub=ones(1,size(d_fuz,1));
   glaub_roh=glaub;
   mu_y=zeros(size(d_fuz,1),par(4));
   mu_y(:,rulebase(1,4))=1;
   s_glaub=sum(glaub,1);
   return;
end;

switch inferenz
   case 1
      %Überdeckungen zwischen Prämissen werden korrigiert
      [c2,praemisse]=c2_compp(praemisse,par,wichtung);
      if (anzeige)
         fprintf('\nFuzzy-interference according to Jäkel, Gröll and Mikut ...\n');
      end
   case 2
      %Überdeckungen zwischen Prämissen werden ignoriert
      c2=eye(size(rulebase,1));
      if (anzeige)
         fprintf('\nSUM-PROD-interference ...\n');
      end;
   case 3
      %Überdeckungen zwischen Prämissen werden ignoriert
      c2=eye(size(rulebase,1));
      if (anzeige)
         fprintf('\nMAX-MIN-interference ...\n');
      end;
end;
if (anzeige)
   fprintf('(Evaluation of a rulebase with %d rules for %d data points...)\n',size(rulebase,1),size(d_fuz,1));
end;

%UND-Verknüpfung der Prämisse über Variablen wird vorbereitet, indem eine Matrix form aufgestellt wird
%Im Ergebnis wird später elementeweise (alle Terme aller Variablen) multipliziert
%(z.B. x1=MI in Regelprämisse und als fuzzifiziertes Meßergebnis).
%Bei Regeln mit abgeleiteten Termen (z.B. x1=MI ODER GR in Regelprämisse und im fuzzifizierten Meßwert)
%sind die Teilergebnisse zu addieren (=1, wenn Meßwert zwischen MI und GR)
%(Kronecker-Multiplikation erzeugt die Formmatrix zur Addition)
%i.-te  Spalte hat Einsen zwischen (max. Anzahl Terme)*(i-1)+1 und (max. Anzahl Terme)*i, sonst Nullen
form=sparse(1:size(praemisse,2),kron([1:par(2)],ones(1,size(praemisse,2)/par(2))),1,size(praemisse,2),par(2));

%Vorinitialisierungen:
%Schätzwert Ausgangsgröße in TERMEN (z.B. 1.5 zwischen TERM 1 und TERM 2 der Ausgangsgröße)
ydach=zeros(size(d_fuz,1),1);
%Matrix der Wahrheitswerte der Regelkonklusionen (in Nr. der Regel, noch nicht als Ausgangsterm !!)
%Dimension r (Anzahl Regeln) x N (Anzahl Beispiele)
%(Ergebnis Aktivierung)
glaub=zeros(size(rulebase,1),size(d_fuz,1));
glaub_roh=zeros(size(rulebase,1),size(d_fuz,1));

%die Regeln, die einen Wahrheitswert der Regelkonklusion >0 haben können
%(alle, wenn c2 gegeben; spezifische Auswertung, wenn c2 nicht gegeben)
rule=1:size(praemisse,1);
rulec=1:size(rulebase,1);

%über alle N Beispiele
for i=1:size(d_fuz,1)
   
   %Anzeige Fortschritt
   if (rem(i,20)==0) && anzeige
      fprintf('%4d \n',i);
   end;
   
   % C2-Matrix muss in reduzierter Form sein
   % (Nullspalten fuer Kombinationen logisch disjunkter Praemissen sind nicht enthalten)
   % mu_p Vektor der Wahrheitswerte
   % (siehe auch Erklärung Formmatrix)
   %
   % Berechnung Prämissenauswertung und Aktivierung unter Vernachlässigung von Überdeckungen:
   % elementeweise für alle Regeln und i-tes Beispiel
   % 1. Prämissen der Regeln mit Vektor der Zugehörigkeitswerte multiplizieren (ergibt Zugehörigkeitswerte der ling. Terme für die Prämissen)
   % 2. mit Formmatrix multiplizieren oder Maximum suchen (ergibt Zugehörigkeitswerte der Variablen - ODER über Terme einer Variablen)
   % 3. multiplizieren/Minimum suchen (ergibt Zugehörigkeitswerte der Prämissen in mu_ps)
   % Operatoren SUM und PROD (inferenz<3) oder MAX/MIN (sonst)
   %
   % NUR HIER MUSS ZEITKORREKTUR REIN - VERKNÜPFUNG ÜBER SCHLEIFE MIT d_fuz(i-k,:)*mu_zeit(k+1,:) !!! UND NACHFOLGENDEM ODER
   % REALISIERT IST SONDERFALL MIT mu_zeit(1,:)=1 für alle !
   %mehrere Variable
   if (size(form,2)>1)
      if (inferenz<3)
         mu_ps=prod(((ones(size(praemisse(rule,:),1),1)*d_fuz(i,:)).*praemisse(rule,:)*form)',1)';
      else
         for j=1:size(form,2)
            tmp(:,j)=max((((ones(size(praemisse(rule,:),1),1)*d_fuz(i,:)).*praemisse(rule,:)).*(form(:,j)*ones(1,size(rulebase,1)))')',[],1)';
         end;
         mu_ps=min(tmp',[],1)';
      end;
      %nur eine Variable - sonst spinnt MATLAB
   else
      mu_ps=((ones(size(praemisse(rule,:),1),1)*d_fuz(i,:)).*praemisse(rule,:)*form);
   end;
   
   % zweiter Korrekturschritt (Korrektur Überdeckung, Summe darf max. 1 sein) - nur bei JGM-Inferenz relevant
   glaubi=c2*mu_ps;
   
   % die errechneten Aktivierungen der zugehörigen Regeln (rule) in Matrix der Aktivierungen eintragen
   glaub(rulec,i)=glaubi;
   glaub_roh(rulec,i)=mu_ps(1:length(glaubi));
end;

%Summe der Regelaktivierungen aller Regeln berechnen
%(braucht man für Ergänzung der negierten Terme)
if size(glaub,1)>1
   s_glaub=sum(glaub);
else
   s_glaub=glaub;
end;

%Sum-Prod oder Min-Max: Summen der Regelaktivierungen <>1 werden auf Eins gesetzt (Division durch Summe
%der ZGF), wenn Aktivierung > 0
if (inferenz>1)
   %Wichtung mit Regelplausibilitäten?
   ind=find(s_glaub>0);
   if ~isempty(ind)
      %Multiplikation mit Wichtungsfaktoren
      glaub(:,ind)=(glaub(:,ind).*(wichtung*ones(1,length(ind))));
      %Skalierung auf "alte" Summme der Aktivierungen
      glaub(:,ind)=glaub(:,ind).*(ones(size(glaub,1),1)*(sum(glaub(ind_nichtleerepraemisse,ind),1)./(1E-10+sum(glaub_roh(ind_nichtleerepraemisse,ind),1))));
      
      s_glaub=sum(glaub);
   end;
   
   %Korrigieren, wenn Summe der Regelaktivierungen größer als Eins wird
   ind=find(s_glaub>1);
   if ~isempty(ind)
      glaub(:,ind)=glaub(:,ind)./(ones(size(glaub,1),1)*s_glaub(ind));
      s_glaub(ind)=ones(1,length(ind));
   end;
end;

if max(s_glaub>1.1)
   myerror('Error in ZGF or C2-calculation, activation of rule greater than one !');
end;

%Aktivierungen der Terme der Ausgangszugehörigkeitsfunktionen
mu_y=zeros(size(d_fuz,1),par(4));
for i=1:par(4)
   if (inferenz<3)
      %Summe als ODER-Operator
      mu_y(:,i)=[glaub;1-s_glaub]'*([rulebase(:,4);concl_default]==i);
   else
      %Maximum als ODER-Operator
      mu_y(:,i)=max([glaub;1-s_glaub].*(([rulebase(:,4);concl_default]==i)*ones(1,size(d_fuz,1))))';
   end;
end;

%Default-Regel anhängen!
glaub=[glaub;1-s_glaub];

%Defuzzifizierung COGS
if size(zgfy,1)==1
   mu_y_sum=sum(mu_y');
   ind=find(mu_y_sum);
   if ~isempty(ind)
      ydach(ind)=(mu_y(ind,:)*zgfy(1,1:par(4))')./(mu_y_sum(ind)');
   end;
end;

%Qualitative Entscheidung
[tmp,pos]=max(mu_y');
pos=pos';

if (anzeige)
   fprintf('Complete ...\n');
end;
