  function [code_features, zgf_feature_bez]=compute_categories(categories,featurenames,mode)
% function [code_features, zgf_feature_bez]=compute_categories(categories,featurenames,mode)
%
% 
% [code_zr,zgf_zr_bez]=compute_categories(categories,var_bez(1:par.anz_merk,:),'ZR')
% [code_em,zgf_em_bez]=compute_categories(categories,dorgbez(1:par.anz_einzel_merk,:),'EM')
% 
%
% The function compute_categories is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


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

fprintf('Assignment of features to categories\n');

%hinten noch Leerzeichen anhängen, um Problem mit Zuordnung bei Variablen mit längsten Namen zu überwinden
featurenames(:,end+1)=32;

switch mode
case 'TS'
   feature_categories=categories.zr;
case 'SF'
   feature_categories=categories.em;   
otherwise
   myerror('Unknown option!');
end;

%Code-Vektor für die Kategorien leer vorinitialisieren
code_features=zeros(size(featurenames,1),length(categories.category_description));
zgf_feature_bez=[];

%Plugins und Einzüge vorinitialisieren
fprintf('Assignment using plugins and segments\n');

%über alle Kategorien
for i_cat = 1:length(categories.category_description)
   %über alle Terme 
   for i_term = 1:length(categories.category_description(i_cat).term)
      
      %Löschvorbereitung vorinitialisieren
      loesch_ind_synonym=[];
      
      %über alle Synonyme
      for i_synonym = 1:length(categories.category_description(i_cat).term(i_term).synonym)
         akt_synonym=char(categories.category_description(i_cat).term(i_term).synonym(i_synonym));
         
         %Zuordnung über Plugins
         if getfindstr(akt_synonym,'plugin_') %if strmatch('plugin_',akt_synonym)
            
            %Das Synonym wird dann nicht mehr gebraucht, zum Löschen vorbereiten!!!
            %gleich löschen geht nicht, sonst kommt der Zähler durcheinander
            loesch_ind_synonym=[loesch_ind_synonym i_synonym];
            
            for i_mehrfach_plugins=1:size(feature_categories,2)
               ind_match = strcmp(akt_synonym,char(feature_categories(:,i_mehrfach_plugins).plugin));
               if ~isempty(ind_match) 
                  code_features(ind_match,i_cat)=i_term;
                  break;
               end;
            end;              
         end;      
         
         %Zuordnung über Einzüge
         if getfindstr(akt_synonym,'einzug_') %if strmatch('einzug_',akt_synonym)
            
            %Das Synonym wird dann nicht mehr gebraucht, zum Löschen vorbereiten!!!
            %gleich löschen geht nicht, sonst kommt der Zähler durcheinander
            loesch_ind_synonym=[loesch_ind_synonym i_synonym];
            
            for i_mehrfach_plugins=1:size(feature_categories,2)
               ind_match = strcmp(akt_synonym,char(feature_categories(:,i_mehrfach_plugins).einzug));
               if ~isempty(ind_match) 
                  code_features(ind_match,i_cat)=i_term;
                  break;
               end;
            end;            
         end;    
      end;            
      %Die Synonyme werden dann nicht mehr gebraucht, jetzt Löschen !!!
      if ~isempty(loesch_ind_synonym)
         categories.category_description(i_cat).term(i_term).synonym(unique(loesch_ind_synonym))=[];
      end;      
   end;
end;


%und jetzt der Weg über die Bezeichner über alle Merkmale
fprintf('Assignment using variable names\n');
for i_merk=1:size(featurenames,1)
   
   akt_featurename=featurenames(i_merk,:);
   
   %über alle Kategorien, die noch nicht ausgewertet wurden!
   for i_cat = find(code_features(i_merk,:)==0)
      
      %über alle Terme
      for i_term = 1:length(categories.category_description(i_cat).term)
         
         %[i_merk i_cat i_term]
         %über alle Synonyme
         for i_synonym = 1:length(categories.category_description(i_cat).term(i_term).synonym)
            if ~isempty(strfind(akt_featurename,char(categories.category_description(i_cat).term(i_term).synonym(i_synonym))))
               code_features(i_merk,i_cat)=i_term;
               break;
            end;
         end;            
      end;
   end;
end;

liste_aktive_kategorien=[];
%Anzahl Relevanzterme
maxrel=0;

%über alle Kategorien:   existierende Terme eintragen und umnummerieren, 
for i_cat = 1:length(categories.category_description)
   
   %Null-Terme gegen Default-Term ersetzen
   code_features(find(code_features(:,i_cat)==0),i_cat)=categories.category_description(i_cat).number_default_term;
   %Term-Namen default Term anhängen (nur hier und temporär!!!)
   categories.category_description(i_cat).term(end+1).name=categories.category_description(end).default_term;
   %Default-Terme haben immer Relevanz 1 !
   categories.category_description(i_cat).term(end).relevance=1;
      
   %welche Terme existieren in der Kategorie? 
   [ind_term,temp,new_term_numbers ]= unique(code_features(:,i_cat));
   
   %existierende Terme eintragen und umnummerieren, 
   if length(ind_term)>1
      %existierende Terme eintragen und umnummerieren, 
      code_features(:,i_cat)= new_term_numbers;   
      for i_term=1:length(ind_term)
         zgf_feature_bez(i_cat,i_term).name=char(categories.category_description(i_cat).term(ind_term(i_term)).name);
         zgf_feature_bez(i_cat,i_term).relevance=categories.category_description(i_cat).term(ind_term(i_term)).relevance;
         maxrel=max(maxrel,length(zgf_feature_bez(i_cat,i_term).relevance));
      end;      
      zgf_feature_bez(i_cat,1).auswahl=1:length(ind_term);
      liste_aktive_kategorien=[liste_aktive_kategorien i_cat];
   end;   
end;

%nur aktive Kategorien übernehmen
code_features=code_features(:,liste_aktive_kategorien);
zgf_feature_bez=zgf_feature_bez(liste_aktive_kategorien,:);

%Kategorie Namen eintragen
zgf_feature_bez(1,1).katbez=[];
for i_kat=1:length(liste_aktive_kategorien)
   zgf_feature_bez(1,1).katbez=strvcatnew(zgf_feature_bez(1,1).katbez,char(categories.category_description(liste_aktive_kategorien(i_kat)).name));
end;
zgf_feature_bez(1,1).maxrel=maxrel;



fprintf('Ready\n');



