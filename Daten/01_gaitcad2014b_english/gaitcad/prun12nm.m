  function [rulebase,masze]=prun12nm(rulebase,par,d_fuz,yfuz,parameter_regelsuche,weights,L)
% function [rulebase,masze]=prun12nm(rulebase,par,d_fuz,yfuz,parameter_regelsuche,weights,L)
%
%   prunt Regelbasis rulebase durch Streichen von Partialprämissen und Übernahme der relevantesten Regel
%   in parameter_regelsuche enthalten:
%   wenn typegen=0, dann keine Generalisierung von Termen (default), wenn typegen=1 dann Terme generalisieren
%   wenn anzeige=1 (optional), werden Regelvarianten auf Monitor angezeigt
%   faktor ist Wichtungsfaktor für Gütefunktion vom Typ Approximationsfehler + Klarheit ^faktor
%   stat_absich gibt Maß für statistische Absicherung der Gültigkeit einer Regel an
%   min_klarheit gibt minimale Klarheit in  an
% 
%   Checknummer für übernommene Regeln
%   Zufallszahlen über alle Werte
%   wenn fastcheck, wird jeder Pruningprozess einer  Regel dann abgebrochen,
%   wenn die beste Regel früher schon mal beste Regel war
%   gibt u.U. dann Schwierigkeiten, wenn andere Regel mit Mindestanforderungen
%   gespeichert
% 
%
% The function prun12nm is part of the MATLAB toolbox Gait-CAD. 
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

fastcheck=1;
if fastcheck 
   check_ueb=zeros(10*size(rulebase,1),1);
   chzz=0;
   chzzmax=0;
else     
   check_ueb=zeros(size(rulebase,1),1);
end;
check_rand=rand(size(rulebase,2)-3,1);

%ID für Monitor-Ausgaben - mit Umscahltun Anzeigeparameter
fmon=[1 parameter_regelsuche.anzeige_details];


%Checksummen für Regelbasis, verhindert doppeltes Anhängen bei Pareto-Optimierung
check_rulebase=rulebase(:,4:size(rulebase,2))*check_rand;   

%Anzeige geänderte Regeln
%auf Monitor
%Standard: Terme nicht mit generalisieren
%Klarheitsmaß für Regelbewertung im Pruning
%Auswaehlen: Mindestrelevanz und Mindestaktivierung:
%Anzahl Beispiele
%Bewertung der Regeln, Default: Konklusionmatrix mit offenen Konklusionen
if (nargin<5) 
   anzeige=0;
   typegen=0;
   faktor=3;
   stat_absich=0; 
   min_klarheit=90; 
   typ_regelmatrix=1; 
   texprotokoll=0;
   texprot=[];
   %wieviele Eingangsterme ?
   anz_term=max(par(5:4+par(2)));


else       
   typegen=parameter_regelsuche.typegen;
   anzeige=parameter_regelsuche.anzeige;
   faktor=parameter_regelsuche.faktor;
   stat_absich=parameter_regelsuche.stat_absich;
   min_klarheit=parameter_regelsuche.min_klarheit;
   typ_regelmatrix=parameter_regelsuche.typ_regelmatrix;
   texprotokoll=parameter_regelsuche.texprotokoll;
   logred_pruning=parameter_regelsuche.logred_pruning;
   schaetzung_einzelregel=parameter_regelsuche.schaetzung_einzelregel;
   anz_term= parameter_regelsuche.anz_fuzzy;
end; %if

if (nargin<6) 
   weights=[];
end;

if (nargin<7)
   L=[];
end;

fboth(fmon,'\nPrune rulebase ... \n');

%Warnung Sebastian
if typ_regelmatrix>3 && typ_regelmatrix<8 && min_klarheit>0 
   warning('A positive clearness is unusual for decision theory!'); 
end;

if typ_regelmatrix==7 && logred_pruning 
   warning('For a Pareto pruning, a logical reduction of rules should not be used!');
   logred_pruning=0;
end;


%Anpassen Parametervektor (wichtung bei ind_auswahl!!)
par(1)=size(d_fuz,1);

%Regelstatisitik
%=0, wenn Regel nicht verbessert, =1  wenn verbessert
rule_verbesserung=zeros(size(rulebase,1),1);
%Anzahl gelöschter Regeln
ind_loesch=0;
%Anzahl doppelter Regeln
ind_doppelt=0;
%Anzahl Veraenderungen
anz_veraend=0;
%Anzahl Du
anz_lauf=0;

rule_mindest=[];

%alle Regeln durchgehen
i=0;

%Zeitregistrierung
t0=clock;

%alle die Variablen löschen, die nirgends in der Regelbasis spezifiziert sind 
%->Einparung Rechenzeit
if size(rulebase,1)>1
   [ind_aktiv_d,ind_merkmal]=findaktiv(rulebase(:,5:size(rulebase,2)),anz_term);
   if ~isempty(L)
      L.ind_merkmal=ind_merkmal;
   end;
   d_fuz=d_fuz(:,ind_aktiv_d);
   %für Regeln:
   ind_aktiv=[1:4 4+ind_aktiv_d]; 
   par_red=[size(d_fuz,1) length(ind_merkmal) par(3:4) par(4+ind_merkmal)];
else 
   ind_aktiv=1:size(rulebase,2);
   ind_aktiv_d=1:size(rulebase,2)-4;
   par_red=par;  
   if ~isempty(L) 
      ind_merkmal=1:par(2);
      L.ind_merkmal=ind_merkmal;
   end;   
end;

%hier wird über alle Prunigkandidaten die Regelbasis durchsucht
while 1
   %weiterzählen, darf aber wegen variabler Struktur nicht als for-Schleife realisiert werden
   i=i+1;
   anz_lauf=anz_lauf+1;
   
   %fertig mit der letzten Regel, Pruning ist beendet
   if (i>size(rulebase,1)) 
      fprintf('Pruning finished: Rule %4d - %d improved, %d deleted, %d double, %d saved, %d tested, %d remaining candidates- (time %5.1fs)\n',i+ind_loesch+ind_doppelt-1,sum(rule_verbesserung(1:i-1)),ind_loesch,ind_doppelt,sum(rule_verbesserung(1:i-1)==0),anz_veraend,size(rulebase,1)+1-i,etime(clock,t0));
      break;
   end;
   
   %Anzeige Fortschritt alle 20 Regeln
   if (rem(anz_lauf,10)==0) 
      fboth(fmon,'Rule %4d - %d improved, %d deleted, %d double, %d saved, %d tested, %d remaining candidates - (time %5.1fs)\n',i+ind_loesch+ind_doppelt-1,sum(rule_verbesserung(1:i-1)),ind_loesch,ind_doppelt,sum(rule_verbesserung(1:i-1)==0),anz_veraend,size(rulebase,1)+1-i,etime(clock,t0));
   end;
   
   %besetzte Stellen (nur Partialprämissen)
   ind=find(rulebase(i,:));
   ind=ind(find(ind>4)); 
   
   if (typegen==1) 
      %Verallgemeinerungen
      indplus=ind-4+1; 
      indminus=ind-4-1;        
      
      %aber keine bereits eingetragenen Terme
      %Tests notwendig, weil Fehler bei Zuweisung variable([])=[] !!
      if ~isempty(indplus)  
         indplus(find(diff(ind)==1))=[];
      end; 
      if ~isempty(indminus) 
         indminus(1+find(diff(ind)==1))=[]; 
      end; 
      
      %aber nicht über Termgrenzen
      %nächster Term
      if ~isempty(indplus)  
         indplus (find(rem(indplus ,anz_term)==1))=[];
      end;
      
      %selber Term, aber unzulässige Anzahl 
      terme=1+fix((indplus-1)/anz_term);
      if ~isempty(indplus)  
         indplus (find(rem(indplus ,anz_term)>par(4+terme)))=[];
      end;  
      
      %Term der vorherigen Variablen
      if ~isempty(indminus) 
         indminus(find(rem(indminus,anz_term)==0))=[]; 
      end;
      
      %Steuerzeichen wieder berücksichtigen
      indsetzen=4+[sort([indplus indminus])];        
      
      %Kandidaten für Regelersetzung aufstellen 
      %urspruengliche Regeln als Ausgangsbasis, immer alle Partialprämissen eines Terms löschen 
      terme=fix((ind-5)/anz_term);
      if ~isempty(terme) 
         terme(find(~diff(terme)))=[];
      end;
      
      tmp=ones(length(terme)+length(indsetzen)+1,1)*rulebase(i,:); 
      for j=1:length(terme)     
         tmp(j,[1:anz_term]+4+anz_term*terme(j))=zeros(1,anz_term);
      end;
      for j=1:length(indsetzen) 
         tmp(j+1+length(terme),indsetzen(j))=1;
      end; 
   else         
      %Kandidaten für Regelersetzung aufstellen 
      %urspruengliche Regeln als Ausgangsbasis, immer eine Partialprämisse löschen 
      terme=fix((ind-5)/anz_term);
      if ~isempty(terme) 
         terme(find(~diff(terme)))=[];
      end;
      tmp=ones(length(terme)+1,1)*rulebase(i,:); 
      for j=1:length(terme)     
         tmp(j,[1:anz_term]+4+anz_term*terme(j))=zeros(1,anz_term);
      end;
   end;  
   
   best_plaus=-1;
   anz_parameter=[(length(terme)-1)*ones(length(terme),1);length(terme)*ones(size(tmp,1)-length(terme),1)];
   
   %Durchgehen: Ursprungsregel und alle Ersatzregeln
   %Regelplausibilitäten berechnen
   %nur bei Anzeige wird Aktivierung (Protokoll in relemas >-1) berechnet
   
   %zweite Kuerzrunde: jetzt nur Aktivitaeten pro Regel!!
   [ind_aktiv_rd,ind_merkmal_r]=findaktiv(tmp(:,4+ind_aktiv_d),anz_term);
   if ~isempty(L) 
      %die Originalregel
      L.urspungs_regel_pruning=length(terme)+1;
      %nur die Merkmale sind spezifiziert, Rest ist gestrichen
      L.ind_merkmal=ind_merkmal(ind_merkmal_r);
      % Erster Durchlauf mit ungedrehten Konklusionen
      L.concl_gedreht=0;
   end;
   
   ind_aktiv_rr=[1:4 4+ind_aktiv_d(ind_aktiv_rd)]; 
   par_red_r=[size(d_fuz,1) length(ind_merkmal_r) par(3:4) par(4+ind_merkmal_r)];
   
   %Plausibilitätsberechnung für alle aktuellen Pruningkandidaten
   [rele,concl,masze,aktiv,r_alle,erg,bewertungs_details]=relemas3(tmp(:,ind_aktiv_rr),yfuz,d_fuz(:,ind_aktiv_rd),par_red_r,faktor,typ_regelmatrix,-1+anzeige,stat_absich,length(terme)+1,weights,L,schaetzung_einzelregel);   
   
   %nach Regelrelevanzen rele sortieren, Reihenfolge steht in ind 
   [xxx,ind]=sort(-rele);
   
   if isfield(bewertungs_details,'dec_best') % Nur wenn das Feld existiert
      % Regeln bei denen die Konklusion gedreht würde, und die besser sind, als die beste ungedrehte werden übernommen
      % Regeln mit zu drehenden Konklusionen bestimmen: 
      concl_drehen=find(concl'~=bewertungs_details.dec_best);
      %Regeln zusammenstellen
      tmp2=tmp(concl_drehen,:);
      
      if ~isempty(tmp2) % Nur wenn nicht leer
         %Jetzt sind die Konklusionen gedreht...
         L.concl_gedreht=1;
         % Konklusionen drehen!
         tmp2(:,4)=bewertungs_details.dec_best(concl_drehen)';
         % Bewertung besorgen
         [rele2,concl2,masze2,aktiv2,r_alle2,erg2,bewertungs_details2]=relemas3(tmp2(:,ind_aktiv_rr),yfuz,d_fuz(:,ind_aktiv_rd),par_red_r,faktor,typ_regelmatrix,-1+anzeige,stat_absich,1,weights,L,schaetzung_einzelregel);        
         %Sortieren
         [xxx,ind2]=sort(-rele2);
         % Gibt es eine bessere Regel mit gedrehter Konklusion?
         if rele2(ind2(1))>rele(ind(1))
            bewertungs_details.suboptimal_verworfen=concl_drehen(ind2(1));
         end;
      end;
   end; %if isfield
   
   %SEBASTIAN: Pareto-optimale Regeln ermitteln
   if ~isempty(bewertungs_details.suboptimal_verworfen)
      for k=bewertungs_details.suboptimal_verworfen % Schleife über alle suboptimalen Kandidaten
         checkk=tmp(k,4:size(rulebase,2))*check_rand; % Berechnung Chechsumme für suboptimalen Kandidaten
         if (sum(tmp(k,5:size(tmp,2)))~=0) && (~(max(checkk==[check_ueb(1:chzzmax);check_rulebase]))) % Regel wird aufgenommen, wenn nicht nullregel und nicht bereits vorhanden. 
            %Checksummen für Regelbasis, verhindert doppeltes Anhängen bei Pareto-Optimierung
            check_rulebase=[check_rulebase;tmp(k,4:size(rulebase,2))*check_rand];   
            rulebase=[rulebase;tmp(k,:)];
         end;
      end;
   end;
   
   
   %Anzeige
   if (anzeige) 
      fprintf('%d. Rule %d.Test (Origin: Rule 1)\n',i,i+ind_doppelt+ind_loesch);    
      tmp1=tmp;
      tmp1(:,1:3)=[rele round(aktiv)];
      tmp1(:,4)=concl;
      
      %Reihenfolge drehen für Darstellung
      ind_visu=[length(terme)+1 1:length(terme) length(terme)+2:size(tmp,1)];
      translat9(tmp1(ind_visu,:),par,1,masze(ind_visu,:),texprotokoll);
      if (texprotokoll)
         kopf='rule no. & $Q$ & $Q_P$ & $Q_K$ & $Q_S$ & $Q_G$ &Fehler &Beispiele';
         inhalt='';
         for j=1:size(tmp,1) 
            inhalt=sprintf('%s $R_{%d}^{%d}$ &%4.2f & %4.2f& %4.2f & %4.2f & %4.2f  & %d & %d \n',inhalt,i,j,rele(ind_visu(j)),masze(ind_visu(j),:),round(aktiv(ind_visu(j),:)));
         end;
         textable(kopf,inhalt,'pruning of rules',1);
      end;   
   end;
   
   %beste Regel wird in jedem Pruningschritt in die Regelbasis eingetragen   
   rulebase(i,:)=[rele(ind(1)) round(aktiv(ind(1),:)) concl(ind(1)) tmp(ind(1),5:size(tmp,2))];
   anz_veraend=anz_veraend+size(tmp,1);
   
   %Welche Regel ist die beste, die die Minimalanforderungen erfüllt -> merken
   %Mindestanforderungen: minimale Klarheit UND statistische Absicherung UND positive Relevanz
   wahr_ind_mindest= (masze(:,2)>=(min_klarheit/100)) & (masze(:,3)>0) & (rele>0); % Coderevision: &/| checked!
   if sum(wahr_ind_mindest)
      ind_mindest=ind(find(wahr_ind_mindest(ind)));
      rule_mindest=[rele(ind_mindest(1)) round(aktiv(ind_mindest(1),:)) concl(ind_mindest(1)) tmp(ind_mindest(1),5:size(tmp,2))];
   end;
   
   %wenn die beste Regel bereits in den aufgenommenen Regeln steht, dann weg damit
   if fastcheck 
      chzz=chzz+1;
   else      
      chzz=i;
      chzzmax=i-1;
   end;   
   
   check_ueb(chzz)=rulebase(i,4:size(rulebase,2))*check_rand;
   if (chzz>1) 
      if max(check_ueb(chzz)==check_ueb(1:chzzmax)) 
         rulebase(i,:)=[];
         ind(1)=-1;
         ind_doppelt=ind_doppelt+1; 
         rule_mindest=[];
         fboth(fmon,'Rule twice!\n');
      end;
   end;
   
   %wenn urspruengliche Regel (steht unabhängig vom Verfahren bei 
   %length(terme)+1) ersetzt wird, dann weiter nach oben
   %Bedingungen: nicht die beste Regel von vorhin 
   if (ind(1)~=length(terme)+1)
      rule_verbesserung(i)=1;
      i=i-1; 
   else   
      %ursprüngliche Regel ist die beste, aber erfült sie auch die Mindestanforderunngen ?
      %wenn nicht, gibt es eine verworfene, die das erfüllt - dann nehmen wir die zum Weiterprunen
      if sum(wahr_ind_mindest)
         if (ind_mindest(1)==length(terme)+1) 
            %Darf ich alle Generalisierungen ablehnen? 
            %alle nicht-ablehnbaren, generalisierten Regeln, die die Mindestanforderungen erfüllen 
            %ACHTUNG - Generalisierbarkeit wird in relemas auch nur für die Regeln vor der 
            %speziellsten Regel berechnet !
            ind_mindest=find( (masze(1:length(terme),4)==1) & wahr_ind_mindest(1:length(terme)) ); % Coderevision: &/| checked!
            
            %alles bestens, beste Regel gefunden 
            %rule_mindest brauchen wir für die nächste Regel wieder
            if isempty(ind_mindest) 
               rule_mindest=[];
               %für Löschen der Doppelregeln
               chzzmax=chzz;
            else         %wenn nicht, nehme die beste Generalisierung
               [xxx,ind]=sort(-rele(ind_mindest));
               ind=ind_mindest(ind);
               rulebase(i,:)=[rele(ind(1)) round(aktiv(ind(1),:)) concl(ind(1)) tmp(ind(1),5:size(tmp,2))];
               i=i-1;
            end; %if ~isempty(rule_mindest)
         else  %wenn nicht, ist mit der besten gültigen Regel noch was rauszuholen, wenn 
            %man weiterprunt?
            rulebase(i,:)=rule_mindest;
            i=i-1;
         end; %  if (ind_mindest(1)==length(terme)+1) 
      else %keine gültige Regel, die Mindestanforderungen erfüllt, mehr auf Lager      
         %aber wenn es auch keine verworfene Regel mehr gibt, hatten wir schon mal eine?       
         if ~isempty(rule_mindest) 
            rulebase(i,:)=rule_mindest;
            %Feierabend, da geht nichts !
         else                   
            rulebase(i,:)=[];
            i=i-1;
            ind_loesch=ind_loesch+1;
            fboth(fmon,'Rule hurt minimum requirements!\n');
            
         end; %if ~isempty(rule_mindest)
         rule_mindest=[];
      end;  %if sum(wahr_ind_mindest)
   end; %if (ind(1)~=length(terme)+1)
end; %while 1 (Regelbasis!)

%Protokoll geprunte Regeln    
if ~isempty(rulebase) 
   %keine zusammengestrichenen Merkmalskombis!!
   if ~isempty(L) 
      L.ind_merkmal=ind_merkmal;
   end;
   
   if anzeige
      fprintf('\nRulebase prior logistic reduction\n');
      [rele,concl,masze,aktiv]=relemas3(rulebase(:,ind_aktiv),yfuz,d_fuz,par_red,faktor,typ_regelmatrix,0,stat_absich,0,weights,L,schaetzung_einzelregel);   
      translat9(rulebase,par,1,masze);
      fprintf('\nRulebase after logistic reduction\n');
   end;    
   
   %redundante Regeln löschen   
   %doppelte über Checksummen identifizieren   
   check_ueb=rulebase(:,4:size(rulebase,2))*check_rand;
   [tmp,ind_check]=sort(check_ueb);
   ind_loesch=ind_check(~diff(tmp));
   %... und rauswerfen
   if ~isempty(ind_loesch) 
      rulebase(ind_loesch,:)=[];
   end;
   
   %Logische Reduktion
   if logred_pruning 
      rulebase=logred(rulebase,par);
   end;
   
   
   [rele,concl,masze,aktiv]=relemas3(rulebase(:,ind_aktiv),yfuz,d_fuz,par_red,faktor,typ_regelmatrix,0,stat_absich,0,weights,L,schaetzung_einzelregel);   
   rulebase(:,[2 3])=aktiv;
   
   %Regeln sortieren
   [tmp,pos]=sort(-rele);
   rulebase=rulebase(pos,:);
   masze=masze(pos,:);
   
   if (parameter_regelsuche.anzeige_details) 
      translat9(rulebase,par,1,masze);
   end;
   rulebase(:,1)=rulebase(:,1)+1E-6;
   fboth(fmon,'\nStill remaining %d rules(n). \n',size(rulebase,1));
   fboth(fmon,'Complete ... \n');
   
else   
   fprintf('Not any rule achieve minimum requirements!\n');
end; %isempty

