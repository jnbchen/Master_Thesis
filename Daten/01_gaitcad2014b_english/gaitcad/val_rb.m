  function [masze,konklusion,relevanz] = val_rb(rules,regel_im_satz,U,Y,par,f0,c2_neu,praemisse_neu,protokoll,fixed_default,weights,L,parameter_regelsuche)
% function [masze,konklusion,relevanz] = val_rb(rules,regel_im_satz,U,Y,par,f0,c2_neu,praemisse_neu,protokoll,fixed_default,weights,L,parameter_regelsuche)
%
% Hilfsfunktion zur Validierung von Regelbasen aus Einzelregeln,
% berechnet Guetemaß masze und die Konklusion der Default-Regel
% c2_neu und praemisse_neu sind optional und werden bei Bedarf neu gerechnet
% 
% c2-Matrix?
%
% The function val_rb is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<7 
   c2_neu=[];
end;

%interne Anzeige P
if nargin<9 
   protokoll=0;
end;

%Gewichte?
if nargin<11 
   weights=ones(1,size(U,1));
end;

%Entscheidungstheorie?
if nargin<12 
   L=[];
end;
if isempty(L) 
   relevanz=[];
end;

%Vorinitialisierung Maße - Anzahl sollte möglichst zu parameter_reglsuche.bewertung_regelbasis passen :-)
masze=zeros(1,6);

%keine Regeln?
if isempty(rules) || isempty(regel_im_satz) 
   konklusion=fixed_default;
   if ~isempty(L)
      r=regopt1(ones(1,size(Y,2)),Y,weights,parameter_regelsuche.schaetzung_regelbasis);
      [tmp,tmp,relevanz]=decision_opt_cost(L,1,r,1,[],fixed_default);
   end;
   return;
end;

%Berechnen der neuen c2-Matrix 
if isempty(c2_neu) 
   if (parameter_regelsuche.schaetzung_wahrscheinlichkeiten==1)
      [c2_neu,praemisse_neu]=c2_compp(rules(regel_im_satz,5:size(rules,2)),par,0);
   else
      praemisse_neu=rules(regel_im_satz,5:size(rules,2));
   end;
end;

%Prämissenauswertung
rule_praem_ausw=sparse(size(praemisse_neu,1),size(U,1));
anz_fuzzy=size(praemisse_neu,2)/par(2);
praemisse_neu_nv=plav2pla(praemisse_neu,par,anz_fuzzy);
for j=1:size(praemisse_neu,1) 
   rule_praem_ausw(j,:)=praemausw(U,praemisse_neu_nv(j,:),anz_fuzzy);
end;

%Berechnung der korrigierten Regelaktivierungen
switch parameter_regelsuche.schaetzung_wahrscheinlichkeiten
case 1 % JGM 
   P=c2_neu*rule_praem_ausw;
case 2 %Maximum-Inferenz
   %Regeln mit maximaler Aktivierung raussuchen?
   rule_praem_ausw_max=full(rule_praem_ausw==(ones(size(rule_praem_ausw,1),1)*max(rule_praem_ausw,[],1)));
   %durch Anzahl Teilen
   rule_praem_ausw_max=rule_praem_ausw_max./(ones(size(rule_praem_ausw,1),1)*sum(rule_praem_ausw_max,1));
   %denen die Summe der max. Aktivierungen zuweisen -> damit bleibt Raum für die Default-Regel
   P=rule_praem_ausw_max.*(ones(size(rule_praem_ausw,1),1)*min(1,sum(rule_praem_ausw,1)));
otherwise
   myerror('Not implemented option in parameter_regelsuche.schaetzung_wahrscheinlichkeiten');
end;

%c1_Matrix aus Regelkonklusionen aufstellen
concl=rules(regel_im_satz,4);

%!!!!ACHTUNG - MATLAB Bug, kann nicht mit einer Form c1(:,[1 1]) umgehen !!!
%deshalb so umständlich
%GEHT bei 2,2-Matrizen nicht, wenn Konklusionen gleich: c1=eye(par(4));c1=c1(:,concl);
c1=full(sparse(concl,1:length(concl),1,par(4),length(concl)));

%offene Konklusionen
%else-Term: wenn Restregel nicht aktiviert wird, wird auf Eins gesetzt
if (sum(1-sum([P;zeros(1,size(P,2))]))>.01*size(U,1))
   [tmp1o,tmp2,foffen]=regopt1(1-sum([P;zeros(1,size(P,2))]),Y-c1*P,weights,parameter_regelsuche.schaetzung_regelbasis);
else tmp1o=zeros(size(Y,1),1);tmp1o(1)=1;
end

if protokoll && parameter_regelsuche.anzeige_details 
   [r,tmp2]=regopt1(full([P;1-sum(P,1)]),Y,weights,parameter_regelsuche.schaetzung_regelbasis);
   fprintf(1,'\nRules: \n');
   fprintf(1,'%d ',regel_im_satz);
   fprintf(1,'+ Default\nR-Matrix:\n');  
   disp(r);
end;

%Restregel, auf klare Regel gesetzt, entweder vorgegeben oder die beste
[xxx,decision_default_best]=max(tmp1o,[],1);
if (fixed_default) 
   ind=fixed_default;
else           
   ind=decision_default_best;
end;
tmp1o=zeros(size(tmp1o));
tmp1o(ind)=1;
konklusion=ind;

%Frobeniusnorm der Matrix der Fehler (Prognosefehler)
foffen=norm((Y-[c1 tmp1o]*[P;1-sum([P;zeros(1,size(P,2))])]).*sqrt((ones(size(Y,1),1)*weights)),'fro');

%NUMERIK-Modifikation 16.6.04: max-Operation bei P, sonst u.U. negative Werte
r=regopt1(max(0,full([P;1-sum(P,1)])),Y,weights,parameter_regelsuche.schaetzung_regelbasis);
p_P=full(sum([P;1-sum(P,1)]'));

%Entscheidungstheoretische Betrachtung
anz_fuzzy=(size(rules,2)-4)/par(2);   
[tmp,ind_merkmal]=findaktiv(rules(regel_im_satz,5:size(rules,2)),anz_fuzzy);
if ~isempty(L) 
   [tmp,tmp,relevanz]=decision_opt_cost(L,4,r,p_P/sum(p_P),L.ind_merkmal(ind_merkmal),[rules(regel_im_satz,4);fixed_default],full([P;1-sum(P,1)]),Y);
end;

%Evidenz
if (ismember(parameter_regelsuche.bewertung_regelbasis,[3,4])) && parameter_regelsuche.evidenz
   glaub_roh=full(rule_praem_ausw(1:length(regel_im_satz),:));
   [tmp,konkl_evidenz]=max(r);
   [tmp,code]=max(Y);
   par(4)=par(4)-1; % Evidenzinferenz muss mit RW gerufen werden! Dann wird Anz_klassen (par(4)) allerdings um 1 erhöht. Daher hier -1.
   % Ruft die Inferenz_Inferenz:
   [pos,mu_y_dempster,w_dempster]=evidenzinfer2(konkl_evidenz',par,glaub_roh,1);
   % Wertet die Kosten aus:
   [konf,fehl_proz,fehl_kost,feat_kost,relevanz_klass]=klass9([],code',pos,[],-1,1,0,0,[],[],L,relevanz.feature_aktiv,1);
   %Evidenz nur Kosten
   relevanz.guete_relativ=relevanz_klass.evidenz_cost;
   % Evidenz Merkmalskosten
   relevanz.guete_relativ_merkmale=relevanz_klass.evidenz_cost_feat;
end;

%potenzielle Masze zur Übergabe
masze(1:2)=[1-foffen/f0];
if ~isempty(L) 
   masze(3)=relevanz.guete_relativ;
   masze(4)=relevanz.guete_relativ_merkmale;
end;
