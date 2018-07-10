  function   [a,b,ind_code]=ttest_aut(d_org,code,dorgbez,bez_code,zgf_y_bez,parameter,uihd,test_type)
% function   [a,b,ind_code]=ttest_aut(d_org,code,dorgbez,bez_code,zgf_y_bez,parameter,uihd,test_type)
%
% berechnet paarweise t-Tests für die Ausgangsklassen in Daten d_org
% und gibt signifikante Unterschiede in a (3-D Matrix mit Ausgangsklasse i,Ausgangsklasse k, Merkmal j)
% und deren Irrtumswahrscheinlichkeiten b zurück
% beim gepaarten t-Test müssen die Paare in der gleichen Reihenfolge stehen!!
%
% The function ttest_aut is part of the MATLAB toolbox Gait-CAD. 
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

if ~exist('ttest2','file')
   myerror('The function could not been executed because the Statistic Toolbox was not found.');
end;

par(2)=size(d_org,2);
par(4)=max(code);


%Formatstring laden (sucht hintenrum in uihd!!, hat aber Default-Varianten)...
zahlenstring=get_zahlenstring;

switch test_type
   case 0
      prottext=sprintf('T-test for independent data points, normal distribution with unknown, but equal standard deviation\n');
      myextension='_t_test_unpaired';
   case 1
      prottext=sprintf('Paired T-Test, normal distribution\n');
      myextension='_t_test_paired';
   case 2
      prottext=sprintf('Wilcoxon Ranksum Test\n');
      myextension='_wilcoxon';
   case {3,4}
      prottext=sprintf('Chi-Square test for contingency tables\n');
      myextension='_crosstab';
end;


number_of_tests = 0;

switch test_type
   case {0,1,2}
      b=ones(par(4),par(4),size(d_org,2));
      a=zeros(par(4),par(4),size(d_org,2));
      
      %Anzeige ?
      %alle vorkommenden Ausgangsklassen
      ind_code=findd(code);
      
      %alle t-Werte berechnen
      for i=1:length(ind_code)-1
         if test_type~=4
            fprintf('%d\n ',ind_code(i));
         end;
         for k=i+1:length(ind_code)
            for j=parameter.gui.merkmale_und_klassen.ind_em
               %Datentupel für das j-te Merkmal extrahieren
               ind_i = find(code==ind_code(i));
               kl1=d_org(ind_i,j);
               ind_k = find(code==ind_code(k));
               kl2=d_org(ind_k,j);
               
               number_of_tests = number_of_tests + 1;
               
               if std([kl1' kl2'])
                  
                  try
                     
                     switch test_type
                        case 0
                           %paired t-Test,
                           [a(i,k,j),b(i,k,j)]=ttest2(kl1,kl2);
                        case 1
                           %gepaarter t-Test funktioniert nur bei gleicher Anzahl Datentupel!!
                           %sonst Fehler!!
                           if length(kl1)~=length(kl2)
                              myerror('Paired T-Test not possible (different number of data points)');
                           end;
                           [a(i,k,j),b(i,k,j)]=ttest(kl1-kl2);
                        case 2
                           %Ranksum Test
                           if min(length(kl1),length(kl2))<=10
                              %forces the use of exact method for
                              %a small sample of any of the two
                              %terms, otherwise, MATLAB tend to
                              %decide to approximate methods
                              [b(i,k,j),a(i,k,j)]=ranksum(kl1,kl2,parameter.gui.statistikoptionen.p_krit,'method','exact');
                           else
                              [b(i,k,j),a(i,k,j)]=ranksum(kl1,kl2,parameter.gui.statistikoptionen.p_krit);
                           end;
                     end;
                     a(k,i,j)=a(i,k,j);
                     b(k,i,j)=b(i,k,j);
                  catch
                     mywarning('Error by executing a statistical problem. Possibly a license problem?');
                     return;
                  end;
               end;
            end;
         end;
      end;
   case {3,4}
      b=ones(2,2,size(d_org,2));
      a=zeros(2,2,size(d_org,2));
      
      %Anzeige ?
      %alle vorkommenden Ausgangsklassen
      ind_code = 1:2;
      j1_vector  =  1:length(parameter.gui.merkmale_und_klassen.ind_em);
      parfor j1=1:length(j1_vector)
         j = j1_vector(j1);
         [table,chi2,b_temp(j1)] = crosstab(code,d_org(:,j));
         if min(min(table))<5 && size(table,1) == 2 && size(table,2) == 2
            %performing Fisher's exact test - only valid for 2x
            [temp,temp,b_temp(j1)] = fisherextest( table(1),table(3),table(2),table(4) );
         end;
      end;
      b(1,2,j1_vector) = b_temp;
      number_of_tests = length(parameter.gui.merkmale_und_klassen.ind_em);
end;

%tableinh='';

[p_krit_bonf,bonf_name] = bonferroni_correction(b,parameter,number_of_tests,test_type<3);
prottext = strcat(prottext, bonf_name);

switch test_type
   case {0,1,2,3}
      switch parameter.gui.anzeige.tex_protokoll
         case 0
            datei_name=strcat(parameter.projekt.datei,'_',repair_dosname(deblank(bez_code)),myextension,'.txt');
         case 1
            datei_name=strcat(parameter.projekt.datei,'_',repair_dosname(deblank(bez_code)),myextension,'.tex');
      end;
      f=fopen(datei_name,'wt');
      prottail=protkopf(f,uihd,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,prottext);
      
   case {4}
      %crosstabs for all output variables
      switch parameter.gui.anzeige.tex_protokoll
         case 0
            datei_name=strcat(parameter.projekt.datei,myextension,'.txt');
         case 1
            datei_name=strcat(parameter.projekt.datei,myextension,'.tex');
      end;
      if parameter.gui.merkmale_und_klassen.ind_em(1) == 2
         %first entry
         f=fopen(datei_name,'wt');
         prottail=  protkopf(f,uihd,parameter.gui.anzeige.tex_protokoll,parameter.projekt.datei,prottext);
      else
         %all other entries
         f=fopen(datei_name,'at');
         prottail='';
      end;
      fprintf(f,'\n\n');
      last_entry = parameter.gui.merkmale_und_klassen.ind_em(end) == (parameter.par.anz_y-1);
end;

if parameter.gui.anzeige.tex_protokoll == 1
   tablekopf='Feature';
   for i=1:length(ind_code)-1
      for k=i+1:length(ind_code)
         tablekopf=sprintf('%s & %s-%s',tablekopf,zgf_y_bez(ind_code(i)).name,zgf_y_bez(ind_code(k)).name);
      end;
   end;
else
   fprintf(f,'Feature');
   
   if test_type == 4
      fprintf(f,' %s ',deblank(bez_code));
   end;
   
   for i=1:length(ind_code)-1
      for k=i+1:length(ind_code)
         fprintf(f,'\t%s-%s',zgf_y_bez(ind_code(i)).name,zgf_y_bez(ind_code(k)).name);
      end;
   end;
end;

tableinh=char(32*ones(1,100*(length(parameter.gui.merkmale_und_klassen.ind_em)*size(dorgbez,2)+20)));
table_z=1;

if parameter.gui.statistikoptionen.alle_anzeigen == 0
   %nur Merkmale mit relevanten Änderungen anzeigen!
   parameter.gui.merkmale_und_klassen.ind_em=parameter.gui.merkmale_und_klassen.ind_em(find(min(min(b(:,:,parameter.gui.merkmale_und_klassen.ind_em),[],1))<parameter.gui.statistikoptionen.p_krit));
end;

for j=parameter.gui.merkmale_und_klassen.ind_em
   if ~rem(j,20) && test_type~=4
      fprintf(1,'%d\n',j);
   end;
   tablezeile='';
   %Zahlentemplates für Latex bzw. ASCII
   template_txt=sprintf('%%s  \t %s ',zahlenstring);
   template_tex=sprintf('%%s & %s ',zahlenstring);
   template_tex_fett=sprintf('%%s & $\\\\mathbf{%s}$ ',zahlenstring);
   
   %Kombinationen zusammenbauen
   for i=1:length(ind_code)-1
      for k=i+1:length(ind_code)
         if parameter.gui.anzeige.tex_protokoll
            %LaTeX-Ausgabe
            if b(i,k,j)<p_krit_bonf(i,k,j)
               tablezeile=sprintf(template_tex_fett,tablezeile,b(i,k,j));
            else
               if parameter.gui.statistikoptionen.alle_anzeigen
                  tablezeile=sprintf(template_tex,tablezeile,b(i,k,j));
               else
                  tablezeile=sprintf('%s &   -   ',tablezeile);
               end; %if anzeige
               
            end;
         else
            %TXT mit Tabtrennung
            if (b(i,k,j)<p_krit_bonf(i,k,j)) || parameter.gui.statistikoptionen.alle_anzeigen
               %relevanter Unterschied
               tablezeile=sprintf(template_txt,tablezeile,b(i,k,j));
            else
               %irrelevanter Unterschied
               tablezeile=sprintf('%s \t   -   ',tablezeile);
            end; %if b(i,k,j)
         end; %if
      end; %k
   end; %i
   %Merkmalsergebnisse zeilenweise ausgeben
   if parameter.gui.anzeige.tex_protokoll
      tablezeile=sprintf('$x_{%3d}$ (%s) %s\n',j,dorgbez(j,:),tablezeile);
      tableinh(table_z+[1:length(tablezeile)])=tablezeile;
      table_z =table_z+length(tablezeile);
   else
      fprintf(f,'\nFeature %3d (%s) %s',j,dorgbez(j,:),tablezeile);
   end; %j
end;
if parameter.gui.anzeige.tex_protokoll == 1
   %eigentliche Tabelle plotten
   textable(tablekopf,tableinh(1:table_z),prottext,f);
end;

%Parameter
fprintf(f,'%s',prottail);
fclose(f);
switch test_type
   case {0,1,2,3}
      viewprot(datei_name);
   case 4
      if last_entry == 1
         viewprot(datei_name);
      end;
end;