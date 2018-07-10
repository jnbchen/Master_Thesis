  function [rele,concl,masze,aktiv,r_alle,erg,bewertungs_details] = relemas3(rules,Y,U,par,faktor,rtype,protokoll,stat_absich,nr_spez,weights,L,schaetzung_einzelregel)
% function [rele,concl,masze,aktiv,r_alle,erg,bewertungs_details] = relemas3(rules,Y,U,par,faktor,rtype,protokoll,stat_absich,nr_spez,weights,L,schaetzung_einzelregel)
%
% 
%   masze=[Relevanz Fehler Beispiele Anz.DS Summe Akt. Prognosefehler (2mal: offene o. fix. Koklusionen)
%          rel. Prognosefehler (2mal) Klarheit(offen) Klarheit(fixiert)]
%   wie rele,mas, aber mit mehr Infos
%   faktor       - Wichtung zwischen Klarheit und Prognosegüte, je größer, desto wichtiger Klarheit
%   rtype        - =1: Regel wird als Regel mit offenen Konklusionen eingesetzt, alle Konklusionen möglich
%                  =2: Regel wird als Regel mit offenen Konklusionen eingesetzt, aber nur Konklusion + Komplement
%                  =3: Regel wird mit fester Konklusion eingesetzt -> Klarheit 1, aber schlechtere Prognosegüte
%                  >3: Entscheidungstheorie...
%   protokoll    - Detailinformationen über Regel anzeigen
% 
%   welche Regeln werden verworfen, obwohl sie im Sinne einer Pareto-Optimalität
%   bei Merkmalskosten und rtype=7 (ET Pareto Merkmalskosten) sinnvoll sind?
%   muss bei allen anderen Typen leer bleiben!!!
% 
%
% The function relemas3 is part of the MATLAB toolbox Gait-CAD. 
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

bewertungs_details.suboptimal_verworfen=[];

%Notaussprünge bei sinnlosen Regelbasen ...
if min(size(rules)==[1 4]) 
   rele=0;
   concl=rules(1,4);
   aktiv=[0 0];
   masze=[0 0 0 0];
   r_alle=[];
   erg=[];
   return;
end;
if isempty(rules) 
   rele=[];
   concl=[];
   masze=[];
   aktiv=[];
   r_alle=[];
   erg=[];
   return;
end; 

masze=zeros(size(rules,1),4);
concl=zeros(size(rules,1),1);
aktiv=zeros(size(rules,1),2);
erg=zeros(size(rules,1),8);

%Einsetzen der Regel mit 
if (nargin<6) 
   rtype=1;
end;

%Regelprotokoll?
if (nargin<7) 
   protokoll=0;
end;

%Faktor Statistische Absicherung
if (nargin<8) 
   stat_absich=0.0;
end;

%Nummer der speziellsten Regel - beim Prunen: vorher gefundene Regel
if (nargin<9) 
   nr_spez=0.0;
end;

%Gewichtung Lerndaten
if (nargin<10)
   weights=[];
end;

%Gewichtung Lerndaten
if (nargin<11) 
   L=[];
end;

%Schätzvorschrift in regopt
if (nargin<12) 
   schaetzung_einzelregel=1;
end;

Y=Y';
%für den Trick mit der Rückweisungsregel:
if (max(rules(:,4))>size(Y,1)) 
   Y=[Y;zeros(1,size(Y,2))];
end; 


%Regelbasis, aber ohne Ergebnisse und -statistik (Regelprämissen)
praemisse=rules(:,5:size(rules,2));
anz_fuzzy=size(praemisse,2)/par(2);
[ind_aktiv,ind_merkmal]=findaktiv(praemisse,anz_fuzzy);
if ~isempty(L) 
   L.ind_merkmal=L.ind_merkmal(ind_merkmal);
end;

%nur die Werte in ind_aktiv werden gebraucht
U=U(:,ind_aktiv);
praemisse=praemisse(:,ind_aktiv);   

%Default-Regeln (müssen nicht klar sein !) und Fehler einer Regelbasis mit Prämisse 1
%als Vergleichsmaßstab 
%bei Konklusion + Negation hängt f0 von der Konklusion ab -> hier die der ersten Regel!! 
%weil Prognosefehler von Konklusion abhängt! 
%wenn unterschiedliche Konklusionen (z.B. bei Aufruf nicht aus Pruning einer Regel, dann
%spätere Neuberechnung erforderlich (neu_Y1==1)
neu_Y1=max(diff(rules(:,4))~=0);
Y1=[Y(rules(1,4),:); 1-Y(rules(1,4),:)];
if (rtype~=2)
   [tmp1,tmp2,f0]=regopt1(ones(1,size(U,1)),Y,weights,schaetzung_einzelregel);
else      
   [tmp1,tmp2,f0]=regopt1(ones(1,size(U,1)),Y1,weights,schaetzung_einzelregel);
end;


%zum Vergleich beim Generalisieren wird stets die Prämisse mit der speziellsten Regel
%benötigt
if nr_spez 
   rule_praem_ausw_nr_spez=praemausw(U,praemisse(nr_spez,:),anz_fuzzy);  
else 
   stat_gen=0;
end;

for i=1:size(rules,1)

   %Messages for bigger rulebases
   if size(rules,1)>20
      if i==1
      fprintf('Evaluating rules ...\n');
      end;
      if i==size(rules,1)
      fprintf('Complete!\n');
      end;
      if rem(i,10) == 0 
      fprintf('%d of %d\n',i,size(rules,1));
      end;
   end;
   
   %Regelprämissen
   if (i~=nr_spez) 
      rule_praem_ausw=praemausw(U,praemisse(i,:),anz_fuzzy);  
   else         
      rule_praem_ausw=rule_praem_ausw_nr_spez;    
   end;
   
   %Ergänzung um negierte Regelprämissen
   P=[rule_praem_ausw;1-rule_praem_ausw];
   concl(i)=rules(i,4);
   
   
   if (rtype==1) %Regel wird als Regel mit offenen Konklusionen eingesetzt
      %Klarheit wird separat durch tmp1o(concl(i),1) bewertet
      [r,tmp2,foffen]=regopt1(P,Y,weights,schaetzung_einzelregel);
      %statistische Relevanz, die entsprechende Konklusionszeile in der R-Matrix
      [tmp,concl(i)]=max(r(:,1));
      stat_rele=intervall(r(concl(i),:),compute_aktiv(P),stat_absich/100);
      %Generalisierungsrelevanz gegenüber der nr_spez-ten Regel, nur für Regeln mit weniger 
      %Termen interessant
      if i<nr_spez 
         %3 Regeln: spezialisierte Regel, Differenz generalisierte-spezialisierte, Rest
         %und wieder in der passenden rgen-Zeile (R-Matrix für diesen Fall) nachsehen
         P_spez=[rule_praem_ausw_nr_spez;P(1,:)-rule_praem_ausw_nr_spez;P(2,:)];
         rgen=regopt1(P_spez,Y,weights,schaetzung_einzelregel);
         stat_gen=intervall(rgen(concl(i),1:2),compute_aktiv(P_spez,1:2),stat_absich/100);
      else 
         stat_gen=0;
      end;
      masze(i,:)=[1-foffen/max(f0,1E-10) r(concl(i),1) stat_rele(1) 1-abs(stat_gen(1))];
   end;
   if (rtype==2) %Regel wird als Regel mit offenen Konklusionen eingesetzt
      %Konklusion ist aber vorgegebene Konklusion und ihr Komplement
      
      %Berechnung R-Matrix
      %unterschiedliche Konklusionen in rules -> Neuberechnung Y1 notwendig ?
      if neu_Y1 
         Y1=[Y(rules(i,4),:); 1-Y(rules(i,4),:)];
         [tmp1,tmp2,f0]=regopt1(ones(1,size(U,1)),Y1,weights,schaetzung_einzelregel);
      end;
      [r,tmp2,foffen]=regopt1(P,Y1,weights,schaetzung_einzelregel);
      
      %statistische Relevanz, die entsprechende Konklusionszeile in der R-Matrix
      stat_rele=intervall(r(1,:),compute_aktiv(P),stat_absich/100);
      if i<nr_spez 
         %3 Regeln: spezialisierte Regel, Differenz generalisierte-spezialisierte, Rest
         %und wieder in der 1.  rgen-Zeile (R-Matrix für diesen Fall) nachsehen
         P_spez=[rule_praem_ausw_nr_spez;P(1,:)-rule_praem_ausw_nr_spez;P(2,:)];
         rgen=regopt1(P_spez,Y1,weights,schaetzung_einzelregel);
         stat_gen=intervall(rgen(1,1:2),compute_aktiv(P_spez,1:2),stat_absich/100);
      else 
         stat_gen=0;
      end;
      masze(i,:)=[1-foffen/max(f0,1E-10) r(1,1) stat_rele(1) 1-abs(stat_gen(1))];
   end;
   if (rtype==3) %Regel wird als klare Regel mit der entsprechenden Konklusion eingesetzt
      %unterschiedliche Konklusionen in rules -> Neuberechnung Y1 notwendig ?
      if neu_Y1 
         Y1=[Y(rules(i,4),:); 1-Y(rules(i,4),:)];
      end;
      
      tmp2=sum((Y.* (ones(size(Y,1),1)*P(2,:)) )');
      if sum(tmp2)~=0 
         tmp2=tmp2/sum(tmp2);
      end;
      r=[[1:size(Y,1)==concl(i)];tmp2]';
      ydach=r*P;
      foffen=norm(Y-ydach,'fro');  % Frobeniusnorm der Matrix der Fehler (Prognosefehler)
      
      %für Relevanz brauchen wir aber trotzdem eine r-Matrix 
      %dazu nehmen wir die mit Regel + Konklusion, damit wir keine falsche Regel einsammeln
      r=regopt1(P,Y1,weights,schaetzung_einzelregel);
      stat_rele=intervall(r(1,:),compute_aktiv(P),stat_absich/100);
      %Generalisierungsrelevanz gegenüber der nr_spez-ten Regel
      if i<nr_spez 
         %3 Regeln: spezialisierte Regel, Differenz generalisierte-spezialisierte, Rest
         %und wieder in der passenden rgen-Zeile (R-Matrix für diesen Fall) nachsehen
         P_spez=[rule_praem_ausw_nr_spez;P(1,:)-rule_praem_ausw_nr_spez;P(2,:)];
         rgen=regopt1(P_spez,Y1,weights,schaetzung_einzelregel);
         stat_gen=intervall(rgen(1,1:2),compute_aktiv(P_spez,1:2),stat_absich/100);
      else 
         stat_gen=0;
      end;
      
      masze(i,:)=[1-foffen/max(f0,1E-10) 1 stat_rele(1) 1-abs(stat_gen(1))];                            
   end;
   
   if rtype>3 && rtype<8 
      %Entscheidungstheoretische Bewertung:
      %Prämisse und Negation, alle Konklusionen offen, Konklusion wird aber u.U. geändert!
      [r,tmp2,foffen]=regopt1(P,Y,weights,schaetzung_einzelregel);
      
      %welche Merkmale ?
      [tmp,ind_merkmal]=findaktiv(praemisse([i i],:),anz_fuzzy); 
      feature_aktiv=L.ind_merkmal(ind_merkmal); 
      
      [decision,foffen,relevanz]=decision_opt_cost(L,3,r,sum(P')/sum(sum(P)),feature_aktiv,[rules(i,4),0]);
      if rtype==4 
         rele_decision=relevanz.guete_relativ; 
      end;
      if rtype==5 
         rele_decision=relevanz.guete_relativ_merkmale; 
      end;
      if rtype==6 
         rele_decision=0;
         errormsg('Not implemented method for rule evaluation!');
      end;
      %Vorbereitung Pareto, zunächst wie ET ohne Merkmalskosten
      if rtype==7 
         rele_decision=relevanz.guete_relativ; 
         rele_decision_subopt(i)=relevanz.guete_relativ_merkmale;
      end;
      
      %statistische Relevanz, die entsprechende Konklusionszeile in der R-Matrix
      concl(i)=decision(1);
      stat_rele=intervall(r(concl(i),:),compute_aktiv(P),stat_absich/100);
      %Generalisierungsrelevanz gegenüber der nr_spez-ten Regel, nur für Regeln mit weniger 
      %Termen interessant
      if i<nr_spez 
         %3 Regeln: spezialisierte Regel, Differenz generalisierte-spezialisierte, Rest
         %und wieder in der passenden rgen-Zeile (R-Matrix für diesen Fall) nachsehen
         P_spez=[rule_praem_ausw_nr_spez;P(1,:)-rule_praem_ausw_nr_spez;P(2,:)];
         rgen=regopt1(P_spez,Y,weights,schaetzung_einzelregel);
         stat_gen=intervall(rgen(concl(i),1:2),compute_aktiv(P_spez,1:2),stat_absich/100);
      else 
         stat_gen=0;
      end;
      masze(i,:)=[rele_decision r(concl(i),1) stat_rele(1) 1-abs(stat_gen(1))];
   end;   
   
   %Fehler der klaeren Regel ergibt sich aus dem Vergleich der Aktivierungen (P(1,:)) und 
   %der ZGF der fuzzifizierten Ausgangsgröße              
   if (protokoll~=-1) 
      aktiv(i,1:2)=[ sum(round(1-Y(concl(i),:)).*round(P(1,:))) sum(round(P(1,:)))];
   end;
   
   r_alle(i).r=r;    
   if (protokoll>0)
      fprintf(1,'\n\nDetailde estimation of rule %d-th rule\n',i);
      translat9(rules(i,:),par);
      fprintf(1,'P matrix:\n');
      disp(r);
      fprintf(1,'Prediction error             Fp    : %5.3f\n',foffen);
      fprintf(1,'Prediction error, zero rule  Fp0   : %5.3f\n',f0);
      fprintf(1,'Prediction accuracy          Qp    : %5.3f\n',masze(i,1));
      fprintf(1,'Clearness                     Qk    : %5.3f\n',masze(i,2));
      fprintf(1,'Clearness complementary rule  Qk    : %5.3f\n',max(r(:,2)));
      fprintf(1,'Statistical covering against NOT P  : %5.3f\n',stat_rele(1));
      fprintf(1,'Total performance (factor beta=%2.0f)    : %5.3f\n',faktor,masze(i,1).*masze(i,2).^faktor);
      
      %Farb-Matrix
      cc=[1 0 0;0 1 0;0 0 1;0 1 1;  1 0 1;1 1 0;   0 1 1;0 0 0];
      cc=[cc;0.5*cc(1:7,:)];
      
      if rtype>3 && rtype<8 
         if (i==1) 
            figure; 
         end;
         far(1)=plot(relevanz.p_premise_bed_konklusion(2,2),relevanz.p_premise_bed_konklusion(1,1),'.');
         if (i==1) 
            hold on; 
            xlabel('p(neg. P_r|z \neq z(C_r))'); 
            ylabel('p(P_r|z(C_r))');	
         end;
         far(2)=text(relevanz.p_premise_bed_konklusion(2,2),relevanz.p_premise_bed_konklusion(1,1),sprintf('  %d',i));
         far(3)=plot([0 1],[1 1-relevanz.steig],':');
         far(4)=plot([0 1],[relevanz.steig 0],'-.');
         set(far,'color',cc(1+rem(relevanz.decision_all(1,1)-1,size(cc,1)),:));
         axis([0 1 0 1]);
      end;
   end;
   erg(i,:)=[foffen f0 masze(i,:) masze(i,1).*masze(i,2).^faktor max(r(:,2))];
end; %i

%Relevanzmaß wird wieder zusammengestellt, daß Prognosegüte und Klarheit zusammenfaßt
rele=masze(:,1).*masze(:,2).^faktor;

%SEBASTIAN
if (rtype==7)
   if isfield(L,'concl_gedreht')
      if isfield(L,'urspungs_regel_pruning') && (~L.concl_gedreht)
         [x,opt_ohne_merkkost]=max(rele);
         bewertungs_details.suboptimal_verworfen =find(rele_decision_subopt(1:min(size(rele_decision_subopt,2),L.urspungs_regel_pruning-1))>rele_decision_subopt(opt_ohne_merkkost));  
      end; %if isfield
   end; %if isfield
end;


%------------------------------------------------------------------------

function aktiv=compute_aktiv(P,ind)
%berechnet Aktivierung der einzelnen Prämissen

if nargin<2 
   ind=1:size(P,1);
end;

%Maximum
aktiv=sum((P==ones(size(P,1),1)*max(P))');
aktiv=aktiv(ind);

