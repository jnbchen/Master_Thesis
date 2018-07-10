% Script read_categories
%
% The script read_categories is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('Read category files\n');

%alle Kategorien-Pfade suchen:
%im Plugin-Ordner, in allen Anwendungsspezifischen Erweiterungen und im aktuellen Arbeitsverzeichnis
dat_pfad=getsubdir({[parameter.allgemein.pfad_gaitcad filesep 'plugins'], [parameter.allgemein.pfad_gaitcad filesep 'application_specials']},'*.categories',1);
temp_pfad=getsubdir(pwd,'*.categories',0);
if ~isempty(temp_pfad)
   dat_pfad=[dat_pfad temp_pfad];
   % Sind die Pfade ungünstig verteilt, kommen einige Pfade doppelt vor. Die
   % müssen entfernt werden.
   tmp = unique({dat_pfad.name});
   % Das Ergebnis ist jetzt ein Cell-Array. Wieder in Strukt schreiben.
   dat_pfad = [];
   for i = 1:length(tmp)
      dat_pfad(i).name = tmp{i};
   end;
end;

%Kategorien leersetzen
categories.category_description='';
%auch für Ganganalyse
subplot_parameter=[];

for i_file=1:length(dat_pfad)
   
   %Kategorien-File zeilenweise auslesen
   try 
      fprintf('Reading file %s\n',dat_pfad(i_file).name);
      
      %inhalt_file=textread(dat_pfad(i_file).name,'%s','delimiter','\n','whitespace','');
      myfile = fopen(dat_pfad(i_file).name,'rt');
      temp=textscan(myfile,'%s','delimiter','\n','whitespace','');
      fclose(myfile);
      inhalt_file = temp{1};

      %Hochkommas entsorgen (nur für Übersetzung!)
      %inhalt_file=strrep(inhalt_file,'''','');
      
      %wo stehen neue Kategorien?
      ind_cat=[getfindstr(inhalt_file,'#CategoryName')'  length(inhalt_file)+1]; %ind_cat=[strmatch('#CategoryName',inhalt_file)'  length(inhalt_file)+1];
      
      if isempty(ind_cat)
         warning(strcat(sprintf('The category file %s must contain at least one category!',dat_pfad(i_file).name), ' The file will be ignored'));
      else
         %über alle enthaltenen Kategorien-Beschreibungen
         for i_cat=1:length(ind_cat)-1
            
            %alles zusammensuchen, was zur Kategorie gehört
            inhalt_cat=inhalt_file(ind_cat(i_cat):ind_cat(i_cat+1)-1);
            categories.category_description(end+1).name=strrep(deblank(strrep(inhalt_cat(1),'#CategoryName ','')),'''','');      
            
            %Namen Default-Term ergänzen
            ind_defaultterm = getfindstr(inhalt_cat,'#DefaultTermName'); %ind_defaultterm = strmatch('#DefaultTermName',inhalt_cat);
            
            if isempty(ind_defaultterm)
               categories.category_description(end).default_term='unknown';      
            else               
               categories.category_description(end).default_term=strrep(deblank(strrep(inhalt_cat(ind_defaultterm(1)),'#DefaultTermName ','')),'''','');      
               inhalt_cat{ind_defaultterm(1)}='';
            end;
            
            
            %über alle Terme
            ind_term=[getfindstr(inhalt_cat,'#TermName')' length(inhalt_cat)+1] ;%ind_term=[strmatch('#TermName',inhalt_cat)' length(inhalt_cat)+1] ;
            
            for i_term=1:length(ind_term)-1
               %alles zusammensuchen, was zum Term gehört
               inhalt_term=inhalt_cat(ind_term(i_term):ind_term(i_term+1)-1);
               categories.category_description(end).term(i_term).name=strrep(deblank(strrep(inhalt_term(1),'#TermName ','')),'''','');       
               
               %A-Priori Relevanz auslesen
               ind_relevanz = getfindstr(inhalt_term,'#TermRelevance'); %ind_relevanz = strmatch('#TermRelevance',inhalt_term);
               if isempty(ind_relevanz)
                  categories.category_description(end).term(i_term).relevance=1;      
               else               
                  categories.category_description(end).term(i_term).relevance=str2num(char(strrep(inhalt_term(ind_relevanz(1)),'#TermRelevance ','')));      
                  inhalt_term{ind_relevanz(1)}='';
               end;
               
               
               %alle Synonyme für die Bezeichner auslesen (nicht leere Bezeichner außer dem Termnamen, der auf Position 1 steht)
               ind_synonyme=find([0 ~cellfun('isempty',inhalt_term(2:end))']);
               categories.category_description(end).term(i_term).synonym=strrep(deblank(inhalt_term(ind_synonyme)),'''','');    
            end;      
            
            %Nummer Default-Term kennzeichnen
            categories.category_description(end).number_default_term=length(categories.category_description(end).term)+1;
         end;
      end;
   catch 
      %wenn alles schief geht: File ignorieren
      warning(strcat(sprintf('Error during reading category file %s!',dat_pfad(i_file).name), 'The file will be ignored'));        
   end;   
end;

fprintf('Ready\n');