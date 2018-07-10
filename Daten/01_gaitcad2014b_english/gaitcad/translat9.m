  function rule_return=translat9(rulebase,par,datei_name,masze,protokoll,var_bez,zgf_bez,rule_detail,zgf,einheit_bez,rule_detail_et,regel_im_satz,rule_detail_cor,rule_detail_abgelehnt,sort_mode)
% function rule_return=translat9(rulebase,par,datei_name,masze,protokoll,var_bez,zgf_bez,rule_detail,zgf,einheit_bez,rule_detail_et,regel_im_satz,rule_detail_cor,rule_detail_abgelehnt,sort_mode)
%
% druckt Regelbasis rulebase in Datei file
% datei_name=1 oder fehlend: Anzeige auf Bildschirm
% datei_name=-1 Anzeige in Editorfenster
% z.B.
% translat9(rulebase,par,1,masze,1,var_bez,zgf_bez,rule_detail,zgf) mit Anzeige in File/Bildschirm
% rule_return=translat9(rulebase,par,1,masze,1,var_bez,zgf_bez,rule_detail,zgf) OHNE Anzeige in File/Bildschirm mit Rückgabe in popini-Fenster
% wenn rule_return angefordert wird, erfolgt KEINE Ausgabe in File oder auf Monitor, sondern nur zugeschnitten auf Listboxen
% protokoll= 0: TXT-orintiert deutsch
%            1: TEX-orientiert deutsch
%            2: TXT-orientiert englisch
%            3: TXT-orientiert Erklärungstext deutsch
%            4: TXT-orientiert Erklärungstext englisch
%            5: TXT-orientiert Entscheidungstheorie deutsch
%            6: TXT-orientiert Entscheidungstheorie englisch
%  rule_detail_cor: Korrelationen der Regeln nach dem Pruning
%
% The function translat9 is part of the MATLAB toolbox Gait-CAD. 
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

global zgf_intern zgf_bez_intern oderstring zgf_bez_intern_ohnezahlen par_intern zwischen kleiner_als groesser_als bisstring protokoll_intern


rule_return=[];
%Relativhäufigkeiten auschalten?
haeufvergleich_reset=1;

%ohne Fileparameter: Druck auf Bildschirm
if nargin<3 
   datei_name=1;
end;

%Protokolleinstellungen
if nargin<5 
   protokoll=0;
end;
if protokoll==1 
   texprotokoll=1;
   extension='tex';
else 
   texprotokoll=0;
   extension='txt';
end;

if datei_name==-1  
   datei_name=sprintf('test.%s',extension);
end;
if length(datei_name)>1 
   file=fopen(sprintf('%s.%s',datei_name,extension),'wt');
else 
   file=max(1,datei_name);
end; %wenn FILE ID übergeben wird (>1), wird die auch verwendet

if nargin<4 
   masze=[];
end;
protokoll_intern=protokoll;

if nargin<6 
   var_bez=[];
end;
%wenn keine Bezeichnungen oder nur unvollständige Bezeichnungen übergeben werden, 
%dann diese automatisch zusammenbauen
if isempty(var_bez)
   %Variablennamen
   %mit Leerzeichen initialisieren 
   var_bez=char(32*ones(par(2),5));
   for i=1:par(2) 
      if texprotokoll 
         tmp=sprintf('$x_{%d}$',i);
      else            
         tmp=sprintf('x%d',i);
      end;
      var_bez(i,1:length(tmp))=tmp;
   end;%i
end;%isempty
if (size(var_bez,1)==par(2)) 
   if texprotokoll 
      var_bez(par(2)+1,1:3)='$y$';
   else            
      var_bez(par(2)+1,1)='y';
   end;   
end;

if nargin<7 
   zgf_bez=[];
end;

if nargin<8 
   rule_detail=[];
end;

if isempty(rule_detail)
   if protokoll>2 
      protokoll=0;
   end;
else     
   if size(rule_detail,2)~=size(rulebase,1) 
      myerror('Incorrect detail estimation of rules!');
   end;
end;

if nargin<9 
   zgf=[];
end;

%Einheiten-Bezeichner von Tobi
if nargin<10 
   einheit_bez=[];
end;
if isempty(einheit_bez)||(size(einheit_bez,1)~=size(zgf_bez,1)) 
   einheit_bez=char(zeros(size(zgf_bez,1),1));
end; 

if nargin<11 
   rule_detail_et=[];
end;

if nargin<12 
   regel_im_satz=[];
end;

if nargin<15
   %default:absteigend
   sort_mode =1;
end;

klammer_auf='(';
klammer_zu=')';
merkmalstext='';
ruletext_bsp2='';

%ET-benötigt unsortierte Felder von rule_detail!
rule_detail_unsrt=rule_detail;

%TEX-orientiert deutsch 
if protokoll==1 
   oderstring='$\cup$';
   undstring='$\cap$';
   sonststring='ELSE '; 
   wennstring='IF ';
   dannstring='& THEN'; 
   zeilenende=' \\';
   isstring='=';
   notstring=' NOT ';
   praemissenstring_ableit=' (%s=%s%s) ';
   praemissenstring_primaer=' %s=%s ';
   bisstring='to'; 
end;
%TXT-orientiert deutsch 
if protokoll==0 
   oderstring=' OR ';
   undstring=' AND ';
   sonststring='ELSE '; 
   wennstring='IF ';
   dannstring=' THEN '; 
   zeilenende='';
   isstring='=';
   notstring='NOT';
   
   praemissenstring_ableit=' (%s=%s%s) ';
   praemissenstring_primaer=' %s=%s ';
   bisstring='to'; 
end;

%TXT-orientiert englisch 
if protokoll==2 
   oderstring=' OR ';
   undstring=' AND ';
   sonststring=''; 
   wennstring='IF ';
   dannstring=' THEN '; 
   zeilenende=';';
   isstring=' IS ';
   notstring=' NOT ';
   
   praemissenstring_ableit=' (%s %s%s)';
   praemissenstring_primaer=' %s %s ';
   
   bisstring='to'; 
end;

%TXT-Erklärungstext deutsch                
if (protokoll==3)||(protokoll-2==3) 
   oderstring='or';
   undstring=' and';
   undstring_solo='and';
   
   sonststring='If no premise is fulfilled'; 
   wennstring='If';
   dannstring=', follows'; 
   zeilenende='.\n';
   isstring=' ';
   notstring='not';
   klammer_auf='';
   klammer_zu='';
   
   praemissenstring_ableit=' %s %s%s is';
   praemissenstring_primaer=' %s %s is';
   
   haeufigkeitsstring_bestandteile=char('never','rarely','sometimes ','usually','mostly','always');
   
   string_vergleich=char('larger than','smaller than','different from');
   
   
   haeufigkeitsstring_auftreten_bestandteile=char('None','few','some','many','most','all');
   
   %mit Vergleichsoperatoren!
   %1. Merkmal
   merkmalsstring_v='The samples for %s %s are characterized by %s. This feature is %s %s otherwise (%s).\n';
   %2. und folgende Merkmale
   merkmalsstring_v2='In addition, these samples can be described by %s. It is %s %s (%s).\n';
   
   kleiner_als='%s (smaller than %g%s)';
   zwischen='%s (between %g%s and %g%s)';   % 1 Beispiele, wort(35).de=';
   groesser_als='%s (more than %g%s)';
   
   haeufigkeitsstring_auftreten='This rule describes %s cases for %s %s.\n';
   haeufigkeitsstring_auftreten2='From this dependencies follows a rule to describe %s cases for %s %s.\n';
   
   bisstring='to'; 
end;

%TXT-Erklärungstext englisch                
if (protokoll==4)||(protokoll-2==4) 
   oderstring='or';
   undstring=' and';
   undstring_solo='and';
   
   sonststring='If no premise is activated'; 
   wennstring='If';
   dannstring=' follows'; 
   zeilenende='.\n';
   isstring=' ';
   notstring='not';
   klammer_auf='';
   klammer_zu='';
   
   praemissenstring_ableit=' %s is %s%s';
   praemissenstring_primaer=' %s is %s';
   
   haeufigkeitsstring_bestandteile=char('never','rarely','sometimes ','usually','mostly ','always');
   haeufigkeitsstring_vergleich=char(' and significantly more rarely than otherwise ','',' and significantly more frequently than otherwise  ');
   haeufigkeitsstring_auftreten_bestandteile=char('none','few','some','many','most','all');
   string_vergleich=char('larger than','smaller than','different from');
   
   
   %mit Vergleichsoperatoren!
   %1. Merkmal
   merkmalsstring_v='The samples for %s %s are characterized by %s. This feature is %s %s otherwise (%s).\n';
   %2. und folgende Merkmale
   merkmalsstring_v2='In addition, these samples can be described by %s. It is %s %s (%s).\n';
   
   haeufigkeitsstring_auftreten ='This rule describes %s cases for %s %s.\n';
   haeufigkeitsstring_auftreten2='From this dependencies follows a rule to describe %s cases for %s %s.\n';
   
   kleiner_als='%s (smaller than %g%s)';
   zwischen='%s (between %g%s and %g%s)';
   groesser_als='%s (more than %g%s)';
   bisstring='to'; 
   
end;

%Entscheidungstheorie (Erklärung Regelbasis mit Alternativen...) deutsch 
if (protokoll==5)
   nun_string='now';
   iststring_sing='is';
   iststring_plur='are';
   default_string1='The best default-decision without rule selection for this problem is';
   default_string2='This decision causes an expected average cost per decision of';
   feature_string='Feature cost have %s been considered during rule base selection.';
   feature_string2=' incl. feature cost';
   feature_string_use='The costs for the feature used for the selected rules%s are %0.3g.';
   feature_string_use2='The costs for the features used for the selected rules%s are %0.3g.';
   feature_string_use3='No additional feature is necessary.';
   feature_total_cost='Thus the total cost per decision is %0.3g.';   
   art_default_string='To determine the cost for examples that are not covered by a premise a %s was used.';
   art_default_string1='default decision automatically fixed for each search step';
   art_default_string2='fixed default decision';
   art_default_string3='rejection class with the cost';
   art_default_string4='Thus the rule base selection starts with expected cost per decision of';
   auswahlstring_regel='Rule Nr. %d was selected, because it reduces the expected cost for misclassification  from %0.3g to %0.3g per decision.';
   auswahlstring_regel2='For the examples that are not covered by a premise the decision with the lowest costs is %s %s.';
   auswahlstring_regel3=' As expected cost per decision%s follows %0.3g.';
   cost_differenz_string='The difference to the estimated cost in the last search step is due to the cost of the rejection class.';
   abdeckung_string='Rule Nr. %d covers ca. %2.0f percent of class %s.';   
   correl_string1='  Rule Nr. %d is correlated to Rule Nr. %d with %2.1f.';  
   abgelehnt_string1='Rule Nr. %d was not selected, because';
   abgelehnt_string2=' the reduction of the expected cost for misclassifications of %0.3g is too low.';
   abgelehnt_string3a=' the additional feature %s';
   abgelehnt_string3b=' the additional features %s';
   abgelehnt_string4=' causing costs of %0.3g per decision %s more expensive, then the reduction of the expected cost for misclassifications of %0.3g.';
   kostred_string='The designed classifier reduces the expected cost per decision by %2.0f percent.';
end;

%Entscheidungstheorie (Erklärung Regelbasis mit Alternativen...) englisch 
if (protokoll==6) 
   nun_string='now';
   iststring_sing='is';
   iststring_plur='are';
   default_string1='The best default-decision without rule selection for this problem is';
   default_string2='This decision causes an expected average cost per decision of';
   feature_string='Feature cost have %s been considered during rule base selection.';
   feature_string2=' incl. feature cost';
   feature_string_use='The costs for the feature used for the selected rules%s are %0.3g.';
   feature_string_use2='The costs for the features used for the selected rules%s are %0.3g.';
   feature_string_use3='No additional feature is necessary.';
   feature_total_cost='Thus the total cost per decision is %0.3g.';
   art_default_string='To determine the cost for examples that are not covered by a premise a %s was used.';
   art_default_string1='default decision automatically fixed for each search step';
   art_default_string2='fixed default decision';
   art_default_string3='rejection class with the cost';
   art_default_string4='Thus the rule base selection starts with expected cost per decision of';
   auswahlstring_regel='Rule Nr. %d was selected, because it reduces the expected cost for misclassification  from %0.3g to %0.3g per decision.';
   auswahlstring_regel2='For the examples that are not covered by a premise the decision with the lowest costs is %s %s.';
   auswahlstring_regel3=' As expected cost per decision%s follows %0.3g.';
   cost_differenz_string='The difference to the estimated cost in the last search step is due to the cost of the rejection class.';
   abdeckung_string='Rule Nr. %d covers ca. %2.0f percent of class %s.';   
   correl_string1=' Rule Nr. %d is correlated to Rule Nr. %d with %2.1f.'; 
   abgelehnt_string1='Rule Nr. %d was not selected, because';
   abgelehnt_string2=' the reduction of the expected cost for misclassifications of %0.3g is too low.';
   abgelehnt_string3a=' the additional feature %s';
   abgelehnt_string3b=' the additional features %s';
   abgelehnt_string4=' causing costs of %0.3g per decision %s more expensive, then the reduction of the expected cost for misclassifications of %0.3g.';
   kostred_string='The designed classifier reduces the expected cost per decision by %2.0f percent.';
end;


%ZGF-Namen
if isempty(zgf_bez)
   for i=1:par(2) 
      for j=1:par(4+i)
         if (texprotokoll) 
            zgf_bez(i,j).name=sprintf('$A_{%d,%d}$',i,j);
         else              
            zgf_bez(i,j).name=sprintf('%d',j);
         end;%if
      end;%forj
   end;%fori
end;%isempty

%ZGF-Name y
if (size(zgf_bez,1)==par(2)) 
   for j=1:par(4) 
      if (texprotokoll) 
         zgf_bez(par(2)+1,j).name=sprintf('$B_{%d}$',j);
      else              
         zgf_bez(par(2)+1,j).name=sprintf('%d',j);
      end;%if
      %Rückweisung      
      zgf_bez(par(2)+1,par(4)+1).name='REJ';      
   end;%for
end; %if

%ZGF mit Zahlen
zgf_bez_intern=zgf_bez;
zgf_bez_intern_ohnezahlen=zgf_bez;
par_intern=par;
zgf_intern=zgf;
if (protokoll>2) 
   for i=1:size(zgf_bez,1)-1 
      %hier werden die Intervallbezeichner angehängt, dazu brauchen wir immer die Mittelwerte der ZGF-Stützpunkte 
      %des linken und rechten Terms, macht alles nur Sinn, wenn es mehr als einen gibt
      if par(4+i)>1
         zgf_bez_intern(i,1).name=sprintf(kleiner_als,zgf_bez(i,1).name,mean(zgf(i,1:2)),einheit_bez(i,:));
         for j=2:par(4+i)-1 
            zgf_bez_intern(i,j).name=sprintf(zwischen,zgf_bez(i,j).name,mean(zgf(i,[j-1 j])),einheit_bez(i,:),mean(zgf(i,[j j+1])),einheit_bez(i,:));
         end;
         zgf_bez_intern(i,par(4+i)).name=sprintf(groesser_als,zgf_bez(i,par(4+i)).name,mean(zgf(i,par(4+i)-[0 1])),einheit_bez(i,:));
      end; %if par
   end; % for i
end; % if protokoll

if isempty(rulebase) 
   fprintf('No rules !\n');
   return;
end;

switch sort_mode 
    case 1
        %1 descending
[wert,pos]=sort(-rulebase(:,1));
    case 2 
        %ascending
        [wert,pos]=sort(rulebase(:,1));
    case 3
        %unsorted
        pos = 1:size(rulebase,1);
        wert = rulebase(:,1); 
end;
        

%Regeln nach Relevanz sortieren!!
rulebase=rulebase(pos,:);
if (nargin>7) && ~isempty(rule_detail)
   rule_detail=rule_detail(pos);
end;
if ~isempty(masze) 
   masze=masze(pos,:);
end;

if isempty(rulebase) 
   fprintf('No rules !\n');
   return;
end;

if (texprotokoll)  
   fprintf(file,'\n\\begin{small}\n\\tablehead{}\n\\tabletail{}\n\\tablelasttail{}\n\\begin{supertabular}{lp{.7\\textwidth}l}\n');
end;

%--------------------------------------------------------------------------------------------------------------------
% Ab hier ET-Erklärungstext zur Entstehung der Regelbasis
%--------------------------------------------------------------------------------------------------------------------
% Wird aktiviert wenn protokoll = 5 oder 6.
if (protokoll==5)||(protokoll==6)    
   %--------------------------------------------------------------------------------------------------------------------
   %Satz über Defaultentscheidung ohne Regel (beste Enscheidung und Kosten)
   %----------------------------------------------------------------------------------------------------
   defaulttext='';
   % Bezeichnung der Entscheidung
   var_bez_akt=var_bez(par(2)+1,:);
   var_bez_akt=var_bez_akt(find((var_bez_akt~=32)+(diff(double([var_bez_akt 32]))~=0)));   
   defaulttext=strcat(defaulttext,sprintf('%s %s%s%s.',default_string1,var_bez_akt,isstring,...
      get_zgfname(par(2)+1,rule_detail_et(1).decision_0_best)));
   % Kosten ohne Regel:
   default_cost=rule_detail_et(1).cost_0;
   % Default Kosten bei RW sind nicht gleich cost_0 !!!
   if rule_detail_et(1).art_default==3 % art_default=1: Auto-default; =2: fixed-default; =3: RW
      default_cost=rule_detail_et(1).cost_0_ohne_rw; 
   end;
   
   % Text zusammenbasteln und ab auf den Bildschirm
   defaulttext=strcat(defaulttext,sprintf('%s%s %0.3g.',isstring,default_string2,default_cost));
   if (~nargout)
      fprintf(file,'%s\n',defaulttext);
   end;
   % Default Kosten für späteren Vergleich merken!
   cost_ohne_klass=default_cost;
   
   %-------------------------------------------------------------------------------------------
   %Satz über Parameter der Regelsuche
   %-----------------------------------------------------------------------------------------
   art_default_text='';
   
   switch rule_detail_et(1).art_default
   case 1
      art_default_text=art_default_string1;
   case 2
      art_default_text=strcat(art_default_text,sprintf('%s %s%s%s',...
         art_default_string2,var_bez_akt,isstring,get_zgfname(par(2)+1,rule_detail_et(1).decision_0)));
      % Kosten für Start der Regelsuche weichen hier von den KOsten für die beste Entscheidung ohne Regel ab.
      default_cost=rule_detail_et(1).cost_norm;
   case 3
      art_default_text=strcat(art_default_text,sprintf('%s %s',art_default_string3,mat2str(rule_detail_et(1).L_rw)));
      % Kosten für Start der Regelsuche weichen hier von den KOsten für die beste Entscheidung ohne Regel ab.
      default_cost=rule_detail_et(1).cost_norm;
   end;
   art_default_text=sprintf(art_default_string,art_default_text);
   if (~nargout) 
      fprintf(file,'%s\n',art_default_text);
   end;
   
   %-------------------------------------------------------------------------------------------------
   % Satz über Startkosten der Regelsuche (nur wenn nicht Autodefault aktiviert ist. 
   %Bei Autodefault sind startkosten identisch den Kosten der Default Entscheidung)
   %-------------------------------------------------------------------------------------------------
   if rule_detail_et(1).art_default~=1 
      if (~nargout) 
         fprintf(file,'%s %0.3g.\n',art_default_string4,default_cost);
      end;
   end;
   
   %-----------------------------------------------------------------------------------------------
   % Satz über Feature Kosten 
   %-----------------------------------------------------------------------------------------------
   featuretext='';
   if rule_detail_et(1).featcost_aktiv % Dann sind feature Kosten bei der Regelbasissuche berücksichtig worden
      if (~nargout) 
         fprintf(file,'%s\n',kill_lz(sprintf(feature_string,'')));
      end;
   else % sonst nicht.
      if (~nargout) 
         fprintf(file,'%s\n',sprintf(feature_string,notstring));
      end;
   end;
   
   %------------------------------------------------------------------------------------------
   % Hier beginnt Schleife für den Text zu den einzelnen Regeln
   %------------------------------------------------------------------------------------------
   
   % Default Entscheidung für Rest merken...
   decision_rest_alt=rule_detail_et(1).decision_0_best;
   % Feld für die Konklusionen der Regeln (für Auswertung von Korrelationen) 
   %Hier steht drin, wie oft jede Conklusion bereits vorgekommen ist.
   concl_merk=zeros(1,par(4));
   % Matrix in der die Regelnummern der einzelnen Conlusionen geschrieben werden
   concl_rules=[];
   % Aktive Merkmale des letzten Suchschrittes
   feature_aktiv_alt=[];
   
   for j=1:(size(rulebase,1)-1) 
      %Text für jede Regel in String ruletext
      if j==1
         % Im ersten Suchschritt Vergleichskosten für Kostenreduktion auf Startkosten setzeen
         cost_alt=default_cost; 
      else
         % Vergleichskosten auf Kosten des letzten Suchschrittes setzen
         cost_alt=rule_detail_et(j-1).cost;
      end;   
      ruletext='';
      ruletext=strcat(ruletext,sprintf(auswahlstring_regel,regel_im_satz(j),cost_alt,rule_detail_et(j).cost));
      
      %Abfrage ob Merkmalskosten Aktiv, wenn ja dann Erweiterung des Textes:
      if rule_detail_et(1).featcost_aktiv
         % Absatz
         ruletext=sprintf('%s\n',ruletext);
         % alle aktuellen Merkmale zu einem String basteln (wenn MErkmale hinzugekommen sind):
         if size(feature_aktiv_alt,2)<size(rule_detail_et(j).feature_aktiv,2)
            %gekapselte Berechnung des Merkmalstrings dadurch felxibler einsetzbar!
            feat_aktiv_string=fas(rule_detail_et(j).feature_aktiv,isstring,var_bez,undstring);
            
            % Feature String einfügen:
            if size(rule_detail_et(j).feature_aktiv)==1 
               % Einzahl
               ruletext=strcat(ruletext,sprintf(feature_string_use,feat_aktiv_string,...
                  rule_detail_et(j).feature_cost));
            else
               % Mehrzahl
               ruletext=strcat(ruletext,sprintf(feature_string_use2,feat_aktiv_string,...
                  rule_detail_et(j).feature_cost));
            end;
         else
            % String für keine zusätzlichen Mermale
            ruletext=strcat(ruletext,feature_string_use3);  
         end;
         % Cost-Complete String einfügen für Kosten pro Entscheidugn incl Merkmalskosten:
         ruletext=strcat(ruletext,sprintf('%s%s',isstring,...
            sprintf(feature_total_cost,rule_detail_et(j).cost_complete)));         
         feature_aktiv_alt=rule_detail_et(j).feature_aktiv;
         % Merken der Prognostizierten Kosten für Vergleich am Ende der Klassifikation 
         %(Bei Rückweisung können die Kosten abweichen).
         cost_prognose=rule_detail_et(j).cost_complete;
      else
         % Wenn feature Kosten nicht aktiv dann, dann entspricht die aktuelle
         %cost_prognose den Entschiedungskosten.
         cost_prognose=rule_detail_et(j).cost;
      end;
      
      %-----------------------------------------------------------------------------------------------------
      % Satz über Klassenabdeckung der Prämisse und Korrelationen mit anderen Regeln in der Regelbasis
      %-----------------------------------------------------------------------------------------------------
      abdeckung_text='';
      % Satz über die Abdeckung der Conclusion der Regel
      abdeckung_text=sprintf(abdeckung_string,regel_im_satz(j),rule_detail_unsrt(j).erklaer*100,...
         sprintf('%s%s%s',var_bez_akt,isstring,get_zgfname(par(2)+1,rule_detail_unsrt(j).concl)));
      
      ruletext=strcat(ruletext,sprintf('\n%s',abdeckung_text));
      % Correlationen für alle Regeln derselben Klasse:
      correl_text='';
      % Schleife über alle conclusionen, die bereits aufgetreten sind
      for k=1:concl_merk(rule_detail_unsrt(j).concl)
         % Aus concl_rules kommen jetzt die Nummern der Regeln mit der selben Konklusion, 
         %die bereits ausgewählt wurden.
         correl_text=strcat(correl_text,sprintf(correl_string1,regel_im_satz(j),...
            concl_rules(rule_detail_unsrt(j).concl,k),...
            rule_detail_cor.sigma_ruleprun(regel_im_satz(j),concl_rules(rule_detail_unsrt(j).concl,k))));
      end;
      % Update von concl_merk und concl_rules
      concl_merk(rule_detail_unsrt(j).concl)=concl_merk(rule_detail_unsrt(j).concl)+1;
      concl_rules(rule_detail_unsrt(j).concl,concl_merk(rule_detail_unsrt(j).concl))=regel_im_satz(j);
      
      %Update Regeltext
      ruletext=strcat(ruletext,correl_text);
      
      %--------------------------------------------------------------------------------------------------------
      % Info über beste Entscheidung für Restprämisse
      % Wenn Autodefault oder letzte Regel, dann Info
      %---------------------------------------------------------------------------------------------------------
      
      % Die beste Entscheidung für die Restprämisse kann sich ändern, aber nur bei Auto-Default. 
      % Beste Entscheidung für Restprämisse soll aber auch bei RW nach dem letzten Suchschritt ausgegeben werden.
      if (rule_detail_et(1).art_default==1)||(j==(size(rulebase,1)-1)) 
         sonst_text='';
         % Wenn Autodefault dann Ausgabe, aber nur wenn sich Rest-Entschiedung geändert hat, 
         %oder wenn es die letzte Regel ist.
         if rule_detail_et(1).art_default==1 && ...
               (rule_detail_et(j).decision_rest~=decision_rest_alt)||(rule_detail_et(1).art_default==1&&...
               (j==(size(rulebase,1)-1))) 
            sonst_text=sprintf(auswahlstring_regel2,nun_string,...
               sprintf('%s%s%s',var_bez_akt,isstring,get_zgfname(par(2)+1,rule_detail_et(j).decision_rest)));
            ruletext=strcat(ruletext,sprintf('\n%s',sonst_text)); 
            decision_rest_alt=rule_detail_et(j).decision_rest;
            % Wenn nicht Autodefault dann letzte Regel, hier aber nur bei RW: bei fixed default ist sonst
            %Entscheidung bekannt!   
         elseif rule_detail_et(1).art_default==3
            sonst_text=sprintf(auswahlstring_regel2,'',sprintf('%s%s%s',var_bez_akt,isstring,...
               get_zgfname(par(2)+1,rule_detail_et(j).decision_rest)));
            % Bei RW noch tatsächliche erwartete KOsten angeben! Achtung Feature Kosten ja/nein!!!
            if rule_detail_et(1).featcost_aktiv
               cost_compl=rule_detail_et(j).cost_ohne_rw+rule_detail_et(j).feature_cost;
            else
               % Hinweis, das Merkmalskosten aktiviert sind löschen
               feature_string2='';
               cost_compl=rule_detail_et(j).cost_ohne_rw;              
            end;
            % Text weiterbauen
            sonst_text=strcat(sonst_text,sprintf(auswahlstring_regel3,feature_string2,cost_compl));
            ruletext=strcat(ruletext,sprintf('\n%s',sonst_text));
            % Wenn die Kostenprognose bei RW im letzten Schritt von der nach festlegen 
            %der Defaultentschiedung für Restprämisse ändert -> Erklärung.
            if cost_compl~=cost_prognose 
               ruletext=strcat(ruletext,sprintf('\n%s',cost_differenz_string));
            end;
         end;  
      end;
      
      %HIER WIRD Regel-TEXT FINAL AUSGEGEBEN - ABER NUR WENN KEINE LISTBOXEN - Ausgabe (erkennbar an nargout)
      if (~nargout) 
         fprintf(file,'%s\n',kill_lz(ruletext));
      end;
   end;
   %--------------------------------------------------------------------------------------------------------------------
   % Ende der Schleife zu den einzelnen Regeln 
   %--------------------------------------------------------------------------------------------------------------------
   % Satz über Kostenreduktion des Klassifikators (nur wenn mindestens eine Regel ausgewählt wurde...)
   if size(rulebase,1)>1
      if (~nargout) 
         fprintf(file,'%s\n',sprintf(kostred_string,(cost_ohne_klass-cost_compl)/cost_ohne_klass*100));
      end;
   end;
   
   %--------------------------------------------------------------------------------------------------------------------
   % Teil über abgelehnte Regeln
   %--------------------------------------------------------------------------------------------------------------------
   % Erstmal eine Leerzeile...
   
   if (~nargout) 
      fprintf(file,'\n');
   end;
   
   % Zuerst wird die Schwelle identifiziert bei der Regeln aufgrund zu geringer Kostenverbesserung 
   %eine Regel nicht asugewählt wurde:
   cost_red_min=0;
   for k=1:size(rule_detail_abgelehnt,2)
      % Die der abgelehnten Regel ist dann interessant, wenn die Gleichen MErkmale verwendet wurden, 
      %oder feature Kosten nicht aktiv sind.
      if isempty(rule_detail_abgelehnt(k).add_feature)||~rule_detail_et(1).featcost_aktiv
         cost_red_min=max(cost_red_min,rule_detail_et(size(rulebase,1)-1).cost-rule_detail_abgelehnt(k).cost);
      end;
   end;
   
   for k=1:size(rule_detail_abgelehnt,2)
      % Stringaufbau beginnt immer mit Regel Nr. wurde nicht....
      abgelehnt_text=sprintf(abgelehnt_string1,rule_detail_abgelehnt(k).rule_nr);
      abgelehnt_grund='';
      % Kostenreduktion der nicht ausgewählten Regel bestimmen:
      cost_red=rule_detail_et(size(rulebase,1)-1).cost-rule_detail_abgelehnt(k).cost;
      % Wenn die Kostenreduktion kleiner ist, als die Kosten für zusätzliche Merkmale, 
      %und die Kostenreduktion größer ist, als die schwelle, dann 
      % Begründung über zusätzliche Merkmale.
      if (cost_red<rule_detail_abgelehnt(k).add_feature_cost)&&(cost_red>cost_red_min)
         if size(rule_detail_abgelehnt(k).add_feature,2)==1 %Singular?
            iststring=iststring_sing;
            abgelehnt_grund=sprintf(abgelehnt_string3a,fas(rule_detail_abgelehnt(k).add_feature,...
               isstring,var_bez,undstring));
         else % Plural!
            iststring=iststring_plur;
            abgelehnt_grund=sprintf(abgelehnt_string3b,fas(rule_detail_abgelehnt(k).add_feature,...
               isstring,var_bez,undstring));
         end;
         abgelehnt_text=strcat(abgelehnt_text,abgelehnt_grund);
         % Und noch den Rest vom Satz...
         abgelehnt_text=strcat(abgelehnt_text,sprintf(abgelehnt_string4,...
            rule_detail_abgelehnt(k).add_feature_cost,iststring,cost_red));
      else   
         % Sonst Begründung über zu geringe Kostenreduktion.
         abgelehnt_text=strcat(abgelehnt_text,sprintf(abgelehnt_string2,cost_red));
      end;
      % Und raus auf die Matscheibe....   
      if (~nargout) 
         fprintf(file,'%s\n',kill_lz(abgelehnt_text));
      end;
   end;
   % Und noch ein Return um den folgenden Text abzusetzen
   if (~nargout) 
      fprintf(file,'\n');
   end;
end; %Ende ET-Erklärungstext


%--------------------------------------------------------------------------------------------------------------------
% Ab hier Erklärungstext der Regelbasis
%--------------------------------------------------------------------------------------------------------------------

for j=1:size(rulebase,1)
   %Text für jede Regel in String ruletext
   ruletext='';
   
   %Regelbasis auslesen
   m=pla2mas(rulebase(j,:),par);
   for i=1:par(2) 
      %neue Variable
      if (m(i,1)) 
         if isempty(ruletext) 
            %Protokoll=0, Masze unbekannt - da muss man kuerzen und ab direkt auf Bildschirm/File
            if  isempty(masze) && (~protokoll) && (~nargout) 
               fprintf(file,'%4d. Rule (Q=%+4.3f, %3d Err./%3d Exam.): ',pos(j),full(rulebase(j,1:3)));
            end;
            %Protokoll=0, Masze bekannt - da muss man kuerzen...
            if ~isempty(masze)&&(~protokoll) 
               ruletext=strcat(ruletext,...
                  sprintf('%4d. Rule (Q=%+4.3f, Qp=%+4.3f, Qk=%3.2f, Qs=%3.2f, Qg=%3.2f, %3d Err./%3d Exam.): ',...
                  pos(j),full(rulebase(j,1)),masze(j,:),full(rulebase(j,2:3))));
            end;
            
            if (protokoll==1) 
               ruletext=strcat(ruletext,sprintf('$R_{%d}$: &  ',pos(j)));
            end;
            
            if (protokoll==2) 
               ruletext=strcat(ruletext,sprintf('      RULE %d:',pos(j)));
            end;
            
            ruletext=sprintf('%s%s',ruletext,wennstring);
         else  
            ruletext=strcat(ruletext,sprintf('%s',undstring));
         end; 
         
         %Endleerzeichen und mehrfache Mittelleerzeichen löschen   
         var_bez_akt=var_bez(i,:);
         var_bez_akt=var_bez_akt(find((var_bez_akt~=32)+(diff(double([var_bez_akt 32]))~=0)));   
      end;
      
      %0==beliebig, wird weggelassen
      
      %Primärterm
      if (m(i,1)>0) 
         ruletext=strcat(ruletext,sprintf(praemissenstring_primaer,var_bez_akt,get_zgfname(i,m(i,1))));
      end;
      
      %ODER-verknüpfte Primärterme
      if (m(i,1)==-1) 
         ind=find(m(i,2:par(4+i)+1));
         
         %es fehlt nur ein Term, also besser negieren
         if (length(ind)==(par(4+i)-1)) 
            ind=find(~m(i,2:par(4+i)+1));
            negstatus=sprintf('%s ',notstring); 
         else 
            negstatus='';
         end;
         
         %kurzer Term
         tmp='';
         if (protokoll~=2) 
            ruletext=strcat(ruletext,sprintf(praemissenstring_ableit,var_bez_akt,negstatus,get_zgfname(i,ind)));
            
         else 
            for k=ind 
               tmp=sprintf('%s%s%s%s%s %s ',tmp,var_bez_akt,isstring,negstatus,get_zgfname(i,k),oderstring);
            end;
            if length(ind)>1 
               ruletext=strcat(ruletext,sprintf(' %s%s%s ',...
                  klammer_auf,tmp(1:length(tmp)-length(oderstring)-2),klammer_zu));
            else          
               ruletext=strcat(ruletext,sprintf(' %s ',tmp(1:length(tmp)-length(oderstring)-2)));
            end;
         end; %if protokoll   
      end;%if m
   end;%i
   
   %Sonst-Regel
   if isempty(ruletext) 
      ruletext=strcat(ruletext,sprintf('%s ',sonststring));
   end;
   
   %Endleerzeichen und mehrfache Mittelleerzeichen bei y-Bezeichnung löschen   
   var_bez_akt=var_bez(par(2)+1,:);
   var_bez_akt=var_bez_akt(find((var_bez_akt~=32)+(diff(double([var_bez_akt 32]))~=0)));   
   if (protokoll<3) 
      ruletext=strcat(ruletext,sprintf('%s %s%s%s%s',dannstring,var_bez_akt,...
         isstring,get_zgfname(par(2)+1,rulebase(j,4)),zeilenende));
   end;
   
   %wenn rule_return angefordert wird, erfolgt KEINE Ausgabe in File oder auf Monitor, 
   %sondern nur zugeschnitten auf Listboxen
   if (nargout) 
      rule_return=strcat(rule_return,sprintf('|R%d: %s',j,ruletext));
   end;
   
   
   %Erweiterter Sektor
   if (protokoll>2) 
      ruletext=strcat(ruletext,sprintf('%s %s %s%s%s%s',...
         dannstring,haeufigkeitsstring_bestandteile(rule_detail(j).fehler_klasse,:),...
         var_bez_akt,isstring,get_zgfname(par(2)+1,rulebase(j,4)),zeilenende));
      %Beispiele
      ruletext_bsp=sprintf(haeufigkeitsstring_auftreten,...
         haeufigkeitsstring_auftreten_bestandteile(rule_detail(j).erklaer_klasse,:),...
         var_bez_akt,get_zgfname(par(2)+1,rulebase(j,4)));
      ruletext_bsp2=sprintf(haeufigkeitsstring_auftreten2,...
         haeufigkeitsstring_auftreten_bestandteile(rule_detail(j).erklaer_klasse,:),...
         var_bez_akt,get_zgfname(par(2)+1,rulebase(j,4)));
      
      %Einzelkritik Merkmale evtl. nur dann notwendig, wenn mehrere aktiviert ?
      merkmalstext='';
      for i_merk=1:length(rule_detail(j).ind_merkmal)  
         tmp='';
         %die wirkliche Merkmals-Nummer
         merk_ind=rule_detail(j).ind_merkmal(i_merk);
         
         %Häufigkeitsaussagen und ling. Terme zusammenbasteln
         
         %nach Werten sortiert
         ind_iterm=1:par(4+merk_ind);
         
         %alle außer nie und selten, nach Häufigkeit sortiert
         [tmpanz,ind_iterm]=sort(-rule_detail(j).merk(i_merk).crisp.haeufmerk');
         ind_iterm_anzeige=ind_iterm(find(tmpanz<-2));
         
         for i_term=ind_iterm_anzeige
            
            %die eigentlichen Terme mit Häufigkeiten in tmp-String...
            tmp_term=sprintf('%s%s %s',...
               haeufigkeitsstring_bestandteile(rule_detail(j).merk(i_merk).crisp.haeufmerk(i_term),:),...
               get_zgfname(merk_ind,i_term));    
            if i_term~=ind_iterm_anzeige(length(ind_iterm_anzeige)) 
               tmp=sprintf('%s%s; ',tmp,tmp_term(1:length(tmp_term)-1));
            else  %letzter Satzteil, wenn mehrere Bestandteile, dann mit und verbunden
               if length(ind_iterm_anzeige)==1 
                  tmp=sprintf('%s',tmp_term);
               else                            
                  tmp=sprintf('%s %s %s',tmp(1:length(tmp)-2),undstring_solo,tmp_term);
               end; %if length
            end; %if i_term~=
         end;  %if i_term
         
         
         % der entstehende Satz mit Vergleich - unterschiedlich, ob 1. oder folgendes Merkmal!
         if (i_merk==1) 
            merkmalstext=strcat(merkmalstext,sprintf(merkmalsstring_v, var_bez_akt,...
               get_zgfname(par(2)+1,rulebase(j,4)),...
               var_bez(rule_detail(j).ind_merkmal(i_merk),:),...
               haeufigkeitsstring_bestandteile(rule_detail(j).merk(i_merk).crisp.haeuf_wertung,:),....
               string_vergleich(rule_detail(j).merk(i_merk).crisp.term_wertung,:),tmp));                   
         else
            merkmalstext=strcat(merkmalstext,sprintf(merkmalsstring_v2,...
               var_bez(rule_detail(j).ind_merkmal(i_merk),:),...
               haeufigkeitsstring_bestandteile(rule_detail(j).merk(i_merk).crisp.haeuf_wertung,:),...
               string_vergleich(rule_detail(j).merk(i_merk).crisp.term_wertung,:),tmp));                   
         end;         
      end; %i_merk
   end; %if 
   
   %sonst kommen Warnungen!   
   if ~isempty(merkmalstext) 
      merkmalstext=kill_lz(merkmalstext);
   end;   
   
   
   %Option Merkmal - Überleitungssatz Beispiele - Regel
   %HIER WIRD TEXT FINAL AUSGEGEBEN - ABER NUR WENN KEINE LISTBOXEN - Ausgabe (erkennbar an nargout)
   if (~nargout) 
      fprintf(file,'%s%s%s\n',merkmalstext,kill_lz(ruletext_bsp2),kill_lz(ruletext));
   end;      
end; %j -Regeln

if (texprotokoll) 
   fprintf(file,'\\end{supertabular}\n\\end{small}\n\n');
   if ~isempty(masze)
      kopf='Rule-No. & $B_k$ & $Q$ & $Q_P$ & $Q_K$ & $Q_S$ & $Q_G$ &Errors &Samples';
      tabtext='';
      name='Rule evaluation';
      for j=1:size(rulebase,1) 
         tabtext=sprintf('%s $R_{%d}$ &$B_{%d}$ &%4.2f & %4.2f& %4.2f & %4.2f & %4.2f  & %d & %d \n',...
            tabtext,pos(j),full(rulebase(j,4)),full(rulebase(j,1)),masze(j,:),full(rulebase(j,2:3)));
      end;
      textable(kopf,tabtext,name,file,1); 
   end;     
end;

if length(datei_name)>1 
   fclose(file);
   if texprotokoll 
      datei_name=strcat(datei_name,'.tex');
   else 
      datei_name=strcat(datei_name,'.txt');
   end;
   viewprot(datei_name);
end;    
%-----------------------------------------------------------------------------------------------------------------
function feat_aktiv_string=fas(feat_akt,isstring,var_bez,undstring)
%function feat_aktiv_string=fas(feat_akt,isstring,var_bez,undstring)
%Diese Funktion verknüpft die Aktiven Merkmale zu einem Aufzählungsstring. 

feat_aktiv_string='';
for k=1:size(feat_akt,2) 
   switch size(feat_akt,2)-k
   case 0
      fuell_string='';
   case 1
      fuell_string=undstring;
   otherwise
      fuell_string=',';
   end;
   feat_aktiv_string=strcat(feat_aktiv_string,sprintf('%s%s',isstring,var_bez(feat_akt(k),:)),fuell_string); 
end;             
%--------------------------------------------------------------------------------------------------   

function text=get_zgfname(i,ind)
%function text=get_zgfname(i,ind)
%Hilfsfunktion zum Zusammenbastelen von ZGF Bezeichnungen 
% i -Nr. Merkmal, ind - Nr. Terme (u.U. mehrere !!)
%mit und ohne Intervallangaben z.B. (<7.5) und zusammgesetzte Terme 

global zgf_intern zgf_bez_intern oderstring zgf_bez_intern_ohnezahlen par_intern zwischen 
global kleiner_als groesser_als bisstring einheit_bez protokoll_intern

if length(ind)==1  
   if ind==0 
      text=[];
      return;
   end;
   
   text=zgf_bez_intern(i,ind).name;
end;
if length(ind)>1  
   tmp='';
   
   %alte Form mit ODER-Verknüpfungen !
   if protokoll_intern<2
      for k=ind 
         tmp=sprintf('%s%s %s ',tmp,zgf_bez_intern(i,k).name,oderstring);
      end;    
      text=tmp(1:length(tmp)-length(oderstring)-2);
      %neue Formung mit von bis und Intervallen   
   else 
      if ind(1)==1 
         wertestring=sprintf(kleiner_als,'',mean(zgf_intern(i,max(ind)+[0 1])),einheit_bez);
      else    
         if max(ind)==par_intern(4+i) 
            wertestring=sprintf(groesser_als,'',mean(zgf_intern(i,min(ind)-[0 1])),einheit_bez);
         else   
            wertestring=sprintf(zwischen,'',mean(zgf_intern(i,min(ind)-[0 1])),...
               einheit_bez,mean(zgf_intern(i,max(ind)+[0 1])),einheit_bez);
         end; 
      end;
      text=sprintf('%s %s %s%s',zgf_bez_intern_ohnezahlen(i,ind(1)).name,bisstring,....
         zgf_bez_intern_ohnezahlen(i,ind(length(ind))).name,wertestring);
   end; %if protokoll
end; %if length
