  function [decision,cost,relevanz,r,decision_all,cost_all]=decision_opt_cost(L,type,p_ydach_bed_premise,p_premise,feature_aktiv,default_konklusion,P,Y)
% function [decision,cost,relevanz,r,decision_all,cost_all]=decision_opt_cost(L,type,p_ydach_bed_premise,p_premise,feature_aktiv,default_konklusion,P,Y)
%
% L                   - Kostenstrukt, in L.ld muss Kostenmatrix stehen
% type                - =1 optimale Entscheidung für jede Beobachtung,
%                       =2 wie 1, aber possibilistische Entscheidung nach inversen Kosten für letzte Beobachtung
% p_ydach_bed_premise - bed. Wahrscheinlichkeit Ausgangsklasse bei Beobachtung
%                       Zeilen: Ausgangsklasse, Spalten: Beobachtungen
% p_premise           - Wahrscheinlichkeit Beobachtung
% 
% Rückgabewerte
% decision            - Vektor der optimalen Entscheidungen pro Beobachtung (immer Typ 1)
% cost                - Gesamtkosten (Typ 1: Summe alle optimalen Teilentscheidungen,
%                                     Typ 2: wie 1, aber für letzte Beobachtung korrigiert)
% r                   - (u.U. bei Typ 2 possibilistische) Entscheidungsmatrix
%                       (Zeilen: Entscheidung==Konklusion, Spalten: Beobachtung=Prämisse
% decision_all        - sortierte Matrix aller möglichen Entscheidungen pro Beobachtung (immer Typ 1)
% cost_all            - zugehörige Kostenanteile (immer Typ 1)
% 
% Beispiel: L.ld=ones(2,2)-eye(2);[decision,cost,relevanz,r,decision_all,cost_all]=decision_opt_cost(L,2,[0.9 0.1]',1)
%           L.ld=ones(3,3)-eye(3);L.ld(1,3)=100;[decision,cost,r,relevanz,decision_all,cost_all]=decision_opt_cost(L,2,[0.9 0.05 0.05;0.1 0.8 0.1]',[0.6 0.4])
% Anzahl Ausgangsklassen
%
% The function decision_opt_cost is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Sebastian Beck, Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


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

anz_class=size(L.ld,2);
anz_entscheidung=size(L.ld,1);
%Anzahl Beobachtungen = Prämissen
anz_prem=size(p_premise,2);
alpha=L.parameter_regelsuche.alpha;
beta=L.parameter_regelsuche.beta;
%aktive Merkmale?
if nargin<5 
   feature_aktiv=[];
end;
if nargin<6 
   default_konklusion=zeros(anz_prem,1);
end;
if nargin<8 
   P=[]; 
   Y=[]; 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Allgemeine Berechnungen            																					   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Wahrscheinlichkeit Ausgangsklasse und Beobachtung = bed Wahrscheinlichkeit Ausgangsklasse bei Beobachtung * Wahrscheinlichkeit Beobachtung
p_ydach_und_premise=p_ydach_bed_premise(1:anz_class,:).*(ones(anz_class,1)*p_premise);

% Berechnung der KLassenwahrscheinlichkeiten aus p_ydach_und_premise:
p_y=sum(p_ydach_und_premise,2);

%(u.U. unscharfe) Matrix der Entscheidungen (Zeilen) für die Beobachtungen (Spalten)
r=zeros(anz_entscheidung,anz_prem);

%optimale Entscheidung für jede Beobachtung ermitteln
for i=1:anz_prem
   %Entscheidung mit min. Kosten wird vorsortiert, alle Entscheidungen und Kosten kommen nach Sinnfälligkeit sortiert in Matrix
   [cost_all(i,:),decision_all(i,:)]=sort(sum(L.ld'.*(p_ydach_und_premise(:,i)*ones(1,anz_entscheidung))));
   
   %Beste Entscheidungen sichern:
   decision_orig(i,:)=decision_all(i,:);
   %Korrektur Default-Konklusion notwendig?
   %Jede Regel hat vorher festgelegte Konklusion-> umsortieren
   if (default_konklusion(i))
      ind_default=find(decision_all(i,:)==default_konklusion(i));
      ind_neu=[ind_default 1:ind_default-1 ind_default+1:anz_entscheidung];
      decision_all(i,:)=decision_all(i,ind_neu);
      cost_all(i,:)=cost_all(i,ind_neu);
   end;
   
   % cost_all_ohne_rw notwendig?
   if isfield(L,'rueckweisung')
      ind_rw=find(decision_all(i,:)==L.rueckweisung);
      ind_neu=[1:ind_rw-1 ind_rw+1:anz_entscheidung];
      decision_all_ohne_rw(i,:)=decision_all(i,ind_neu);
      cost_all_ohne_rw(i,:)=cost_all(i,ind_neu);
   end;
   
   %scharfe Entscheidung eintragen
   r(decision_all(i,1),i)=1;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% type==1 scharfe, optimale Entscheidungen für alle Regeln - erste Matrixspalte!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

decision=decision_all(:,1);
cost=sum(cost_all(:,1));
% Bei Regelsuche mit Rückweisung ist cost_0 und decision_0 ohne RW interessant:
if isfield(L,'rueckweisung')
   [cost_0_ohne_rw,decision_0_ohne_rw]=sort(sum(L.ld(1:anz_entscheidung-1,:)'.*(p_y*ones(1,anz_entscheidung-1))));
end;
[cost_0,decision_0]=sort(sum(L.ld'.*(p_y*ones(1,anz_entscheidung))));

% Berechnung der Normierung für den schlechtesten möglichen KLassifikator (alles falsch) Ansatz gemäß ROC-Analysis
% Kosten für den teuersten Fehler einer Klasse:
L_fault=max(L.ld);
% Normierungsfaktor
norm=cost_0(1);
feature_cost=sum(L.lcl(feature_aktiv));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% type==2 Entscheidung fuer letzte Prämisse=Beobachtung probabilistisch, alle anderen bleiben scharf!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Idee: über inverse Kosten pro Entscheidung ermitteln
% ist zwar keinesfalls billiger als Typ 1, eignet sich aber vielleicht zum suchen
% Dieser Typ wird nicht mehr verwendet.....
if (type==2)
   % inverse Kosten, 1E-99 verhindert Division durch Null, sorry Hack
   cost_inv_default=1./(1E-99+cost_all(anz_prem,:)');
   %unscharfe Entscheidung eintragen
   r(:,anz_prem)=cost_inv_default/sum(cost_inv_default);
   %p Zustand=Klasse wird gebraucht, um Kosten zu berechnen
   p_ydach=sum(p_ydach_und_premise,2);
   %Berechnung Wahrscheinlichkeit Beobachtung und Zustand - nur für letzte Prämisse (deshalb Multiplikation mit p letzte Prämisse!)
   pij_last=p_premise(anz_prem)*(r(:,anz_prem)*p_ydach');
   %Kosten für letzte Entscheidung korrigieren
   cost=sum(cost_all(1:anz_prem-1,1))+sum(sum(pij_last.*L.ld));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnungen für Typ=3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (type==3)
   %if (cost>0)*(p_premise(anz_prem)>0)*(p_premise(anz_prem)<1)*(anz_prem>1)
   %Anteil Abdeckung aller Prämissen
   anteil_abdeckung=1-p_premise(anz_prem);
   %ganz schlecht, wenn überdurchschnittlicher Kostenanteil in Prämissen...
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Ansatz über Abstände zu den Trenngeraden an denen die Entscheidungen kippen
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Berechnung der Wahrscheinlichkeit der Premise bei gegebener Klasse bzw. Konklusion (Bayes Theorem)
   % mit Division-durch-Null-Killer
   p_premise_bed_ydach=(p_ydach_und_premise./(max(1E-10,(p_y*ones(1,anz_prem)))))';
   p_premise_bed_konklusion(:,1)=p_premise_bed_ydach(:,decision(1,1));
   ind_dec=[1:decision(1,1)-1 decision(1,1)+1:anz_class];
   p_y_ohne_k=p_y(ind_dec);
   p_premise_bed_konklusion(:,2)=sum(p_premise_bed_ydach(:,ind_dec).*(ones(anz_prem,1)*p_y_ohne_k')/sum(p_y_ohne_k),2);
   %obige Zeile funktioniert bei zwei und dreiklassenproblem bei fünfklassen nicht ??? derzeit ohnehin ausser Betrieb
   
   % Bestimmung der Kosten für Fehlentscheidungen (Reduktion auf 2 Klassenfall)
   L_k_knicht=L.ld(decision(1,1),ind_dec)*p_y_ohne_k/sum(p_y_ohne_k);
   L_knicht_k=max(L.ld(:,decision(1,1)));
   
   % Berechnung der Steigung im p(pr|k) -p(pr_nicht|k_nicht)-Diagramm
   steig=L_k_knicht/L_knicht_k*(1-p_y(decision(1,1)))/p_y(decision(1,1));
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Ansatz über Betrachtung der Kosten, dei durch die Prämisse verursacht werden.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   %p_premise darf nicht null sein, da sonst Division by zero! Langfrisistig: Änderung der cost_all Berechung, wenn
   %Bewertungsmaß ausgewählt. Dann ist Division durch p_premise nicht mehr erforderlich.
   p_premise=max(p_premise,1E-99);
   
   p_y_und_neg_prem=p_ydach_und_premise(:,2); %Bezogen auf alle Beispiele
   
   %----------------------------------------------------------------------------------------------------------------------------------------
   % Aktuell implementierete Version: Kosten der Prämisse, Malus für nicht abgedeckte Elemente einer Klasse
   %----------------------------------------------------------------------------------------------------------------------------------------
   % Wahrscheinlichkeit der Konklusion in der negierten Prämisse.
   %p_rest=(1-anteil_klasse)*p_y(decision(1));
   p_rest=p_y_und_neg_prem(decision(1,1));
   
   e_alternativ=setdiff(1:anz_entscheidung,decision(1,1));
   for k=e_alternativ
      p_verhaeltnis(k)=(L.ld(k,k)-L.ld(decision(1,1),k))/(L.ld(decision(1,1),decision(1,1))-L.ld(k,decision(1,1)));
   end;
   L_def=0;
   norm=0;
   p_prem_alternativ=0;
   p_prem_norm=0;
   if p_rest>0 % Anteil der Klasse in Restprämisse muss größer null sein!
      p_rest_uebrig=p_rest; % Kopie von Rest anlegen....
      p_y_uebrig=p_y(decision(1,1));
      [worst,ind]=sort(-L.ld(e_alternativ,decision(1,1)));  % Kosten der Schlimmsten Fehlentscheidung
      worst=worst*-1;
      ind2=0;
      while ((p_rest_uebrig>0) || (p_y_uebrig>0)) && (ind2<length(e_alternativ)) % solange es noch alternative Regeln gilt.
         ind2=ind2+1;
         if p_rest_uebrig>0 
            anteil_rest=min(p_rest_uebrig,p_y_und_neg_prem(e_alternativ(ind(ind2)))*p_verhaeltnis(e_alternativ(ind(ind2)))); 
         end;
         if p_y_uebrig>0    
            anteil_rest_y=min(p_y_uebrig,p_y(e_alternativ(ind(ind2)))*p_verhaeltnis(e_alternativ(ind(ind2)))); 
         end;
         norm=norm+anteil_rest_y*worst(ind2);
         L_def=L_def+anteil_rest*worst(ind2);
         p_rest_uebrig=p_rest_uebrig-anteil_rest;
         p_y_uebrig=p_y_uebrig-anteil_rest_y;
         p_prem_alternativ=p_prem_alternativ+anteil_rest+anteil_rest/(p_verhaeltnis(e_alternativ(ind(ind2))));
         p_prem_norm=p_prem_norm+anteil_rest_y+anteil_rest_y/(p_verhaeltnis(e_alternativ(ind(ind2))));
         anteil_rest=0;
         anteil_rest_y=0;
      end; % while
   else
      norm=cost_0(1);
      p_rest_uebrig=0;
   end; % if >0
   
   if p_prem_alternativ==0
      L_def=0;
   else
      L_def=L_def/p_prem_alternativ;
   end;
   if p_prem_norm==0;
      norm=cost_0(1);
   else
      norm=norm*alpha/p_prem_norm;
   end;
   
   %Kosten bezogen auf alle Beispiele
   % Das hier ist die Aktuelle Masterzeile für einzelregeln !!!! 7.6.2004
   cost=(cost_all(1,1)+alpha*L_def*(p_rest-p_rest_uebrig))/(p_premise(1)+(p_rest-p_rest_uebrig));
   
   %HACK!!!! Sebastian 19.1.04 fängt gute BEWERTUNG für SONST Regeln ab!
   if (p_premise(2)<0.0001)  
      norm=cost_0(1);  
   end;
   
   if (decision(1)==decision(2))
      L_nicht_erfasst=L.ld(decision_all(2,2),decision(1));
   else
      L_nicht_erfasst=L.ld(decision(2),decision(1));
   end;
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Kostenkorrektur, wenn Regel nicht im sinvollen Bereich liegt.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   feature_cost=sum(L.lcl(feature_aktiv));
   
end;  % End von type 3

% Bewertung von Regelbasen durch Schaetzung von p(e|pr)
if type==4
   % Wenn Defaultkonklusion festzulegen ist, dann nehme die beste Entscheidung für den Rest...
   merk=0;
   if default_konklusion(size(default_konklusion,1))==0
      merk=1;
      default_konklusion(size(default_konklusion,1))=decision(size(default_konklusion,1));
   end;
   % Einmal über alle möglichen Entscheidungen gehen
   for ind=findd(default_konklusion)
      mu_y(ind,:)=sum(P(find(default_konklusion==ind),:),1);
   end;
   % Defuzzifizieren,
   [tmp,ent]=max(mu_y);
   [tmp,code]=max(Y);
   % Konfusionmatrix
   for i=1:anz_class 
      for j=1:anz_entscheidung 
         konf(i,j)=sum((code==i).*(ent==j));
      end;
   end;
   % Und die Kosten
   cost=sum(sum(L.ld(1:anz_entscheidung,1:anz_class)'.*konf))/length(ent);
   
   % Achtung Normkosten sind noch abhänig von der Prämissenschätzung
   p_y=sum(konf,2)/sum(sum(konf,2));
   % Updaten von cost_0
   [cost_0,tmp]=sort(sum(L.ld'.*(p_y*ones(1,anz_entscheidung))));
   
   %cost_0=cost_0*beta;
   
   if default_konklusion(length(default_konklusion))>max(code)
      if (isfield(L,'rueckweisung')) && (p_premise(anz_prem))
         L.ld(anz_entscheidung,:)=cost_0(1); % Default-Kosten
         cost_prem=sum(sum(L.ld(1:anz_entscheidung-1,1:anz_class)'.*konf(:,1:anz_entscheidung-1)));
         cost_rest=sum(L.ld(anz_entscheidung,1:anz_class)'.*konf(:,anz_entscheidung));
         cost=(cost_prem+beta*cost_rest)/length(ent);
      end;
   end;
   
   % Zurücksetzen der Default_Konkl für anz_prem , da sonst weiter unten die default Konkl. gedreht werden können
   if merk
      default_konklusion(size(default_konklusion,1))=0;
   end;
end;

if (nargout>2)
   %Kosten und Entscheidung ohne Regel
   
   % Änderung Sebastian:
   % Verhindert Zuweisung der RW-Klasse zu decision_0_best
   % ACHTUNG: bei unsymmetrischen Kostenmatrizen führt dies zu Problemen!!!!!!
   if isfield(L,'rueckweisung')
      % beste Entscheidung für den Rest
      relevanz.decision_default_best=decision_all_ohne_rw(anz_prem,1);
      % Kosten bei Defaultentscheidung für den Rest
      relevanz.cost_default_best=cost_all_ohne_rw(anz_prem,1);
      % Gesamtkosten ohne Rückweisung
      relevanz.cost_ohne_rw=sum(cost_all_ohne_rw(:,1));
      relevanz.L_rw=L.ld(anz_entscheidung,:);
      % Gesamtkosten ohen Regel und ohne RW
      relevanz.cost_0_ohne_rw=cost_0_ohne_rw(1);
      % beste Entscheidung ohne Regel und ohne RW
      relevanz.decision_0_ohne_rw=decision_0_ohne_rw(1);
   end;
   
   relevanz.decision_0_best=decision_0(1);
   
   %Korrektur Default-Konklusion notwendig?
   if (default_konklusion(anz_prem))
      ind_default=find(decision_0==default_konklusion(anz_prem));
      ind_neu=[ind_default 1:ind_default-1 ind_default+1:anz_entscheidung];
      decision_0=decision_0(ind_neu);
      % Normierung für Güteberechnung bei RW ändern!
      norm=cost_0(ind_neu(1));
   end;
   
   %Wichtig fuer Bäume: Prämissensumme muss nicht alle Datentupel abdecken - im Gegensatz zu Regelprämissen usw.
   %diese Größe wird entweder direkt uebergeben oder auf Eins gesetzt
   
   if ~isfield(L,'p_premise') 
      L.p_premise=1;
   end;
   
   relevanz.cost_0=cost_0(1);%*L.p_premise;
   relevanz.cost_norm=norm;%*L.p_premise;
   relevanz.decision_0=decision_0;
   
   %Entscheidungspräferenzen eintragen
   relevanz.dec_y=zeros(1,anz_entscheidung);
   relevanz.dec_y(decision_0(1))=1;
   
   %Kosten ohne Merkmale
   relevanz.cost=cost;%*L.p_premise;
   
   %Kosten Merkmale:
   relevanz.feature_aktiv=feature_aktiv;
   relevanz.feature_cost=feature_cost;
   relevanz.feature_cost=sum(L.lcl(feature_aktiv)); %wird jetzt in den einzelnen Fällen bestimmt.
   
   %Kosten Gesamt
   relevanz.cost_complete=relevanz.cost+relevanz.feature_cost;
   
   %relative Güte zur Defaultregel zwischen Null und Eins (ohne Merkmalskosten)
   relevanz.guete_relativ=1-relevanz.cost/relevanz.cost_norm;
   relevanz.guete_relativ_merkmale=1-relevanz.cost_complete/relevanz.cost_norm;
   
   
   %relative Güte zur Defaultregel zwischen Null und Eins (multiplizierte Merkmalskosten)
   relevanz.guete_relativ_merkmale_prod=relevanz.guete_relativ*exp(-5*relevanz.feature_cost);
   
   %Archiv!
   relevanz.cost_all=cost_all;
   relevanz.decision_all=decision_all;
   relevanz.decision_orig=decision_orig;
   relevanz.p_restpraemisse=p_premise(anz_prem);
   relevanz.p_ydach_und_premise=p_ydach_und_premise;
   if (type==3)
      relevanz.p_premise_bed_ydach=p_premise_bed_ydach;
      relevanz.steig=steig;
      relevanz.p_premise_bed_konklusion=p_premise_bed_konklusion;
   end;
end;

