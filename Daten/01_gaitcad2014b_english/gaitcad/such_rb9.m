  function [rule_base,masze,relevanz,relevanz_kandidaten,relevanz_rb,regel_im_satz] = such_rb9(rule_set,code_fuz,U,par,parameter_regelsuche,weights,L)
% function [rule_base,masze,relevanz,relevanz_kandidaten,relevanz_rb,regel_im_satz] = such_rb9(rule_set,code_fuz,U,par,parameter_regelsuche,weights,L)
%
%   stellt aus den Regeln von rule_set eine Regelbasis rule_base zusammen
%   rule_set Regelmenge
%   code_fuz fuzzifizierte Ausgangsgr��e
%   d_fuz fuzzifizierte Eingangsgr��en
%   anz_regel_pro_satz max. Anzahl von Regel
%   fixed_default Nummer der festen Default Regel
%   default_status (==1 automatisch, ==2 fixed_default wird verwendet, ==3 R�ckweisung)
%   faktor Wichtungsfaktor Klarheit
%   stat_absich Ma� f�r stat. Absicherung
%   relevanz             - ET-Relevanz der letzten Regelbasis
%   relevanz_kandidaten  - ET-Relevanz aller Regelbasen im letzten Suchschritt (ausgew�hlte RB + abgelehnte Regeln einzeln)
%   relevanz_rb(i)       - ET-Relevanz aller schrittweise ausgew�hlten Regelbasen mit i-Regeln
%   regel_im_satz           - enth�lt die Nummern der Regeln die ausgew�hlt werden.
%
% The function such_rb9 is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

if (nargin<6) 
   weights=[];
end;
if (nargin<7) 
   L=[];
end;
if isempty(L) 
   relevanz_kandidaten=[];
   relevanz_rb=[];
   relevanz_kandidaten=[];
   relevanz_rb=[];
end;

%Anzeigen auf Bildschrim - je nach Fortschritt
fmon=[1 parameter_regelsuche.anzeige_details];

%File zum Debuggen
fkriterium=0;
rule_base=[0 0 0 parameter_regelsuche.fixed_default zeros(1,size(U,2))];
masze=[0 0 0 0];

if isempty(rule_set) 
   relevanz=[];
   warning('No rules! Apply conclusion for determined default-rule!'); 
   return;
end;

%minimale Verbesserungsschranke in Abh�ngigkeit von 
%Anzahl der Datentupel und geforderter statistischer Absicherung
min_d_fitness=(parameter_regelsuche.stat_absich/100)*0.45^log(size(U,1));

%Umgang mit Default Regeln...
fixed_default=parameter_regelsuche.fixed_default;
%keine feste Default-Regel (Element wird �berschrieben)
if (parameter_regelsuche.art_default~=2) 
   fixed_default=0;
end;
%R�ckweisung ist Default
rueckweisung=(parameter_regelsuche.art_default==3);

% Wenn Inferenz �ber Evidenztheorie, dann R�ckweisung Pflicht!
if ((parameter_regelsuche.art_default~=3) && (parameter_regelsuche.evidenz))
   warning('The use of evidence theory requires a rejection for uncertain decisions -> The rejection was activated!');
   rueckweisung=1;
   fixed_default=0;
end;

%Bewertung Einzelregeln
if ~isempty(L) 
   L.ind_merkmal=1:par(2);
end;
[rele,concl,masze_einzel,aktiv] = relemas3(rule_set,code_fuz,U,par,parameter_regelsuche.faktor,parameter_regelsuche.typ_regelmatrix,0,parameter_regelsuche.stat_absich,0,weights,L,parameter_regelsuche.schaetzung_einzelregel);
%GANZ,ganz wichtig - Relevanzen aktualisieren!!
rule_set(:,1)=rele;

%R�ckweisung
if rueckweisung
   %im Lerndatensatz Spalte anh�ngen, die Sollwerte f�r R�ckweisung angibt
   code_fuz=[code_fuz zeros(size(code_fuz,1),1)];
   if ((par(4)+1)~=size(code_fuz,2))
      warning('Number of initial fuzzy-amount does not match with number of classes!');
   end;
   
   %und die wird Sollausgangsklasse
   par(4)=size(code_fuz,2);
   
   %...und Defaultregel
   fixed_default=par(4);
   
   L.rw_cost_typ=1;
   %in Entscheidungsmatrix erg�nzen, wenn notwendig
   if ~isempty(L) 
      %Sebastian #4 Kosten f�r R�ckweisung als H�lfte des Minimums der anderen Entscheidung �ber alle Klassen:
      if isfield(L,'rw_cost_typ')
         %Sebastian #4 Kosten f�r R�ckweisung als H�lfte des Minimums der anderen Entscheidung �ber alle Klassen:
         if (L.rw_cost_typ==1) 
            % Berechnung der Zustandsverteilung aus code_fuz
            [tmp, code2]=max(code_fuz');
            for i=1:par(4)-1 
               p(i)=size(find(code2==i),2)/length(code2); 
            end;
            L_def=min(L.ld*p');
            temp=sort(L.ld);
            
            L.ld(par(4),:)=ones(1,size(L.ld,2))*min(temp(2,:))*0.5;
            L.rueckweisung=par(4);
            L.ld(par(4),:)=L_def;
         else
            temp=sort(L.ld);
            L.ld(par(4),:)=temp(2,:)*0.5;
            L.rueckweisung=par(4);
         end;
      else
         %Sebastian #3 Kosten f�r R�ckweisung als H�lfte des Minimums der anderen Entscheidung je Klasse:
         temp=sort(L.ld);
         L.ld(par(4),:)=temp(2,:)*0.5;
         L.rueckweisung=par(4);
      end;
   end;
end;

einzel_regel_anteil=0.5;

Y=code_fuz(:,1:par(4))';
zgf=ones(1,size(Y,1));

%Regelbasis, aber ohne Ergebnisse und -statistik (Regelpr�missen)
praemisse=rule_set(:,5:size(rule_set,2));
anz_fuzzy=size(praemisse,2)/par(2);
rules=pla2plav(rule_set,par);

%Rausstreichen aller irrelevanter Teile aus U und rules
if (size(praemisse,1)>1)
   [ind_aktiv,ind_merkmal]=findaktiv(rule_set(:,5:size(rule_set,2)),anz_fuzzy);
   if ~isempty(L) 
      L.ind_merkmal=ind_merkmal;
   end;
   U=U(:,ind_aktiv);
   rules=rules(:,[1 2 3 4 4+ind_aktiv]);
   praemisse=praemisse(:,ind_aktiv);
   par_red=[par(1) length(ind_merkmal) par(3:4) par(4+ind_merkmal)];
else 
   par_red=par;   
end;

%ACHTUNG - letzte Regel mu� nicht Default-Regel sein
default_regel=[1E-6 zeros(1,max(par(5:length(par)))*par(2)+3)];

%Vergleichsma�stab (Trivialsch�tzung) f0
[tmp1o,tmp2,f0]=regopt1(ones(1,size(U,1)),Y,weights,parameter_regelsuche.schaetzung_regelbasis);
[xxx,ind]=max(tmp1o);
%%DECTHEORY!!

%Konklusion der Default-Regel wird auf EINEN
%optimalen Term festgesetzt
tmp1o=zeros(size(tmp1o));
if (fixed_default) 
   default_regel(4)=fixed_default;
else            
   default_regel(4)=ind;
end;
tmp1o(default_regel(4))=1;

%keine Regeln? - dann Default-Regel eintragen und zur�ck 
if isempty(rule_set)  
   rule_base=default_regel;
   masze=[];
   return;
end;

masze=zeros(size(rule_set,1),1);
concl=rule_set(:,4);

% Frobeniusnorm der Matrix der Fehler (Prognosefehler)
f0=norm((Y-tmp1o*ones(1,size(U,1))).*(ones(size(Y,1),1)*weights),'fro');

%1. Regel sucht sich passenden Satz zusammen
regel_im_satz=[];
fitness=0;
c2=1;
c2_neu=1;
konklusion=zeros(size(rules,1),1);

for i=1:parameter_regelsuche.anz_regel
   
   switch parameter_regelsuche.kandidaten_regelbasis
   case {1,4}         
      %alle Regeln ausser den bereits ausgew�hlten
      tmp=ones(1,size(rule_set,1));
      tmp(regel_im_satz)=0;
      regel_nicht_im_satz=find(tmp);
   case 2
      %alle Regeln mit Plausibilit�t gr��er Null
      if (~rueckweisung) || i==1 || parameter_regelsuche.bewertung_regelbasis>2 
         %ACHTUNG  ver�nderte Passage (28.4.03, sonst Indexfehler m�glich f�r regel_nicht_im_satz)
         tmp=rules(:,1);
         tmp(regel_im_satz)=0;
         regel_nicht_im_satz=find(tmp)';
      else 
         %ACHTUNG!!! Ver�nderter Suchablauf -   
         %ab der 2. Runde und bei R�ckweisung werden nur noch die Regeln getestet,
         %die in der vorherigen Runde eine G�teverbesserung gebracht h�tten, die besser als 
         %die geforderte minimale Verbesserung ist, die aber nicht genommen wurden 
         %(stehen in ind_v_alle)
         %macht aber nur dann sind, wenn Entscheidungstheorie nicht im Spiel ist - 
         % da k�nnen zun�chst unattraktive Regel mit zus�tzlichen Merkmalskosten wieder attraktiv werden
         %wenn Merkmal durch andere Regel ohnehin drin ist!
         regel_nicht_im_satz=ind_v_all(2:length(ind_v_all))';
      end;
   otherwise
      myerror('Not implemented so far');
   end;
   
   %wenn optionaler Eingang
   if fixed_default && parameter_regelsuche.kandidaten_regelbasis~=4
      ind=find(rule_set(regel_nicht_im_satz,4)==fixed_default);
      regel_nicht_im_satz(ind)=[];
   end;
   
   %alle Regeln aufgebraucht 
   if isempty(regel_nicht_im_satz)
      break;
   end;
   
   for k=regel_nicht_im_satz
      fboth(fmon,'%s','.');
      
      %Berechne der neuen c2-Matrix (Hinzuf�gen einer neuen Regel)
      if ~isempty(regel_im_satz)
         if parameter_regelsuche.schaetzung_wahrscheinlichkeiten==1  
            %bei JGM-Inferenz brauchen wir eine C2-Matrix 
            [c2_neu,praemisse_neu]=c2update(c2,praemisse,rules(k,5:size(rules,2)),par_red);
         else
            %sonst nicht...
            praemisse_neu=rules([regel_im_satz k],5:size(rules,2));c2_neu=[];
         end; %if parameter.regelsuche...
      else 
         praemisse_neu=rules(k,5:size(rules,2));
      end
      
      %Berechnung der Guete
      [guete,konkl,relevanz]=val_rb(rules,[regel_im_satz k],U,Y,par_red,f0,c2_neu,praemisse_neu,0,fixed_default,weights,L,parameter_regelsuche);
      if ~isempty(L) 
         relevanz_kandidaten(k)=relevanz;
      end;
      
      %bei ET koennen sich Konklusionen drehen!!!
      konklusion(k)=konkl;      
      masze(k,i)=guete(parameter_regelsuche.bewertung_regelbasis);
   end;
   
   %Approximationsg�te     
   kriterium=masze(:,i);       
   %die L�schen, die Mindestanforderung nicht schaffen
   ind_z=find(kriterium<(fitness+min_d_fitness));
   kriterium(ind_z)=zeros(length(ind_z),1);
   
   %aber auch Bevorzugung guter Einzelregeln nach Relevanz Einzelregel
   if (parameter_regelsuche.bewertung_regelbasis==2) 
      kriterium=(kriterium-fitness).*max(rules(:,1),0);
   end;     
   
   %Entscheidung
   [xx,ind]=sort(-kriterium);
   
   %nur zum Debuggen: Zwischenkriterien
   if (i==1) 
      fkriterium=fopen('kriterium.txt','wt');
   end;
   if (parameter_regelsuche.anzeige_details) 
      translat9(rule_set,par,fkriterium);
   end;
   fprintf(fkriterium,'Selected rules:'); 
   fprintf(fkriterium,'%d ',regel_im_satz);
   fprintf(fkriterium,' \n Individual evaluation of candidates:');
   for i_anzeige=1:size(masze,1) 
      fprintf(fkriterium,'\n %d: %+5.3f %+5.3f',i_anzeige,masze(i_anzeige,i),full(kriterium(i_anzeige)));
   end;
   fprintf(fkriterium,'\n\n');
   
   %wenn Regelbasis bereits manuell ausgew�hlt wird, sollen in der Reihenfolge alle Regeln in die 
   %Regelbasis, deswegen bekommen sie einen Bonuspunkt und alle ausgew�hlten werden sicherheitshalber nochmal auf 
   %Null gesetzt, dann weiter wie bisher
   if (parameter_regelsuche.kandidaten_regelbasis==4) 
      kriterium=kriterium+1;
      kriterium(regel_im_satz)=0;   
      [xx,ind]=sort(-kriterium);  
   end;     
   ind_v=find(kriterium(ind)>0);
   
   %die verbesserten mit Einzelregelanteil bewerten
   if ~isempty(ind_v)
      
      %alle besseren Regeln als in Stufe vorher        
      ind_v_all=ind(ind_v);
      
      %Nr. der besten Regel
      ind_v=ind_v_all(1);      
      
      %beste Regel zu rule_base hinzuf�gen, c2-Matrix berechnen
      fitness=masze(ind_v,i);
      if ~isempty(L) 
         relevanz_rb(i)=relevanz_kandidaten(ind_v);
         clear relevanz_kandidaten; 
      end;
      
      %C2-Matrix f�r weitere Suche berechnen 
      if parameter_regelsuche.schaetzung_wahrscheinlichkeiten==1  
         if ~isempty(regel_im_satz)
            [c2,praemisse]=c2update(c2,praemisse,rules(ind_v,5:size(rules,2)),par_red);
         else 
            praemisse=rules(ind_v,5:size(rules,2));
         end
         save erg_rb c2 praemisse regel_im_satz
      end;
      regel_im_satz=[regel_im_satz ind_v]; 
      fboth(fmon,'\n Selected %d rules(n): \n',i);
      fboth(fmon,'%4d',regel_im_satz);
      fboth(fmon,'\n Performance: %5.3f\n',fitness);
      
      %Restregel
      default_regel(4)=konklusion(ind_v);
      
      if (parameter_regelsuche.anzeige_details) 
         translat9([rule_set(regel_im_satz,:);default_regel],par,1);
      end;
   else %Fertig, keine Verbesserung mehr !
      break;
   end;
end;

%Verbesserung durch rausstreichen?
if parameter_regelsuche.ueberfluessige_regeln_loeschen==1
   i=1;
   fboth(fmon,'\nCheck for needless rules\n');
   
   while 1 %keine Regeln mehr ? 
      
      if (i>length(regel_im_satz)) 
         break;
      end;
      
      ind=regel_im_satz;
      ind(i)=[];
      
      %keine Regeln mehr ? 
      if isempty(ind) 
         break;
      end;
      
      %gek�rzte Regelbasis �berpr�fen
      [guete,konkl,relevanz]=val_rb(rules,ind,U,Y,par_red,f0,[],[],0,fixed_default,weights,L,parameter_regelsuche);
      guete=guete(parameter_regelsuche.bewertung_regelbasis);
      
      if (guete>=fitness) 
         guete=fitness;
         regel_im_satz=ind;
         i=1;
         default_regel(4)=konkl;
         fboth(fmon,'\nRule %d canceled\n',i);
         %damit sind nat�rlich auch alle Zwischenbewertungen aus ET hinf�llig ...
         relevanz_kandidaten=[];
         relevanz_rb=[];
      else            
         i=i+1; 
      end;%if
   end;%while
end;% if parameter_regelsuche


%Ma�e f�r reduzierten Regelsatz berechnen (wird f�r sp�tere Auswertung gebraucht)        
default_regel_red=[default_regel(1:4) zeros(1,size(rules,2)-4)];
masze=[masze_einzel(regel_im_satz,:);zeros(1,size(masze_einzel,2))];

%ganz zum Schluss immer ohne fixed_defualt R�ckweisung...
if (rueckweisung) 
   fixed_default=0;
end;
[guete,konkl,relevanz]=val_rb(rules,regel_im_satz,U,Y,par_red,f0,[],[],1,fixed_default,weights,L,parameter_regelsuche);
guete=guete(parameter_regelsuche.bewertung_regelbasis);

if guete<0
   fprintf('Stop');
end;

%immer plotten!
fprintf('\n Search for rulebase: %d selected rules(n): \n',i);
fprintf('%4d',regel_im_satz);
fprintf('\n Performance: %5.3f\n',guete);

%Vollst�ndige Regelbasis:
rule_base=[rule_set(regel_im_satz,:);default_regel];

%die finalen Konklusionen in Regelbasis eintragen 
if (parameter_regelsuche.bewertung_regelbasis<3) 
   rule_base(size(rule_base,1),4)=konkl;
else                                             
   rule_base(:,4)=relevanz.decision_all(:,1);
   if isfield(L,'rueckweisung') % Bei R�ckweisung kann diese noch in der sonst Regel stehen.
      rule_base(size(rule_base,1),4)=relevanz.decision_default_best;   
   end;   
end;

%kann passieren, dass bei letzter verf�gbarer Regel relevanz_kandidaten gel�scht werden, 
%dann wird leere Matrix zur�ckgegeben
if ~exist('relevanz_kandidaten', 'var')
   relevanz_kandidaten=[];
end;

%...nochmal anzeigen
if (parameter_regelsuche.anzeige_details) 
   translat9(rule_base,par,1);
end;

%nur zum Debuggen: File schlie�en
if fkriterium 
   fclose(fkriterium);
end;
