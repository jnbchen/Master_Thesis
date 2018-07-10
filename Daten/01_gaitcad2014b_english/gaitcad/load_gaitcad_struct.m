  function gaitcad_struct=load_gaitcad_struct(parameter,merkmale_projekt_neu,par,erklaerungsstring,mode,datei)
% function gaitcad_struct=load_gaitcad_struct(parameter,merkmale_projekt_neu,par,erklaerungsstring,mode,datei)
%
% 
% lädt mehr oder weniger
% 
% Namen bestimmen
%
% The function load_gaitcad_struct is part of the MATLAB toolbox Gait-CAD. 
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

oldpath = pwd;

%Merkmale besser in Cellstring umwandeln
merkmale_projekt_neu=cellstr(merkmale_projekt_neu);

if (nargin < 6) || isempty(datei)
   [temp_datei,datei]=fileparts(parameter.projekt.datei);
   
   switch mode
      case 'fuzzy_system'
         extension='.fuzzy';
      case 'klass_single'
         extension='.class';
      case 'regr_single'
         extension='.regression';
      case 'plugin_sequence'
         extension='.plugseq';
   end;
   
   
   %Dateinamen festlegen
   [datei,pfad]=uigetfile([datei extension],erklaerungsstring);
   
else
   %wichtig um Makros laden zu können: datei kann durch ein anderes Skript übergeben werden!!!
   [pfad,datei,extension] = fileparts(datei);
   if ~isempty(pfad)
      cd(pfad);
   end;
   tmp=which([datei extension]);
   if isempty(tmp)
      warning('File %s not found!',datei);
      gaitcad_struct=[];
      cd(oldpath);
      return;
   end;
   [pfad,datei,extension] = fileparts(tmp);
end; % if (nargin < 6)

if datei
   cd(pfad);
   %Speichern
   [muell,datei]=fileparts(datei);
   load([datei extension],'gaitcad_struct','merkmale_projekt','mode','-mat');
else
   gaitcad_struct=[];
   cd(oldpath);
   return;
end;

if strcmp(mode,'regr_single')
   %hier noch sortieren, ob es um Einzelmerkmale oder Zeitreihen geht
   switch gaitcad_struct.designed_regression.merkmalsklassen
      case 'Single features'
         merkmale_projekt_neu = merkmale_projekt_neu{1};
      case 'Time series (TS)'
         merkmale_projekt_neu = merkmale_projekt_neu{2};
   end;
end;


%welche Merkmale kommen in beiden Bezeichnermatrizen vor und wo befinden sie sich
[temp_bez,ind_bez,ind_bez_neu]=intersect(merkmale_projekt,merkmale_projekt_neu);

if size(merkmale_projekt,1) ~= size(unique(merkmale_projekt),1)
   mywarning(strcat('Double feature names in the current project!','This can cause problems for feature matching!'));
end;

if size(merkmale_projekt_neu,1) ~= size(unique(merkmale_projekt_neu),1)
   mywarning(strcat('Double feature names in the project of the loaded system!','This can cause problems for feature matching!'));
end;


umkodierungstabelle=zeros(1,length(merkmale_projekt));
umkodierungstabelle(ind_bez)=ind_bez_neu;

switch mode
   case 'fuzzy_system'
      temp = umkodierungstabelle(gaitcad_struct.indr_merkmal);
      if any(temp==0)
         mywarning('At least one selected feature was not found. The rule base will be deleted!');
         for i_not_found = find(temp==0)
            fprintf('%s\n',char(merkmale_projekt(gaitcad_struct.indr_merkmal(i_not_found))));
         end;
         
         %delete all non-existing features and the rulebase
         ind_undefined_feature = find(temp == 0);
         gaitcad_struct.zgf_all     (ind_undefined_feature,:) = [];
         gaitcad_struct.zgf_bez_all (ind_undefined_feature,:) = [];
         gaitcad_struct.dorgbez_rule(ind_undefined_feature,:) = [];
         gaitcad_struct.rulebase=[];
         gaitcad_struct.par_kafka_all(4+ind_undefined_feature) = [];
         gaitcad_struct.par_kafka_all(2) = gaitcad_struct.par_kafka_all(2)-length(ind_undefined_feature);
         
         %assign features
         gaitcad_struct.indr_merkmal=temp(find(temp));
         gaitcad_struct.zgf     = gaitcad_struct.zgf_all(gaitcad_struct.indr_merkmal,:);
         gaitcad_struct.zgf_bez = gaitcad_struct.zgf_bez_all(gaitcad_struct.indr_merkmal,:);
         
      end;
      %assign features
      gaitcad_struct.indr_merkmal=temp(find(temp));
      
   case 'klass_single'
      for i=1:length(gaitcad_struct)
         temp=umkodierungstabelle(gaitcad_struct(i).merkmalsextraktion.merkmal_auswahl);
         if any(temp==0)
            mywarning('At least one selected features is unknown! The classifier could not be loaded!');
            for i_not_found = find(temp==0)
               fprintf('%s\n',char(merkmale_projekt(gaitcad_struct(i).merkmalsextraktion.merkmal_auswahl(i_not_found,:))));
            end;
            gaitcad_struct=[];
            cd(oldpath);
            return;
         else
            gaitcad_struct(i).merkmalsextraktion.merkmal_auswahl = temp;
         end;
      end;
   case 'regr_single'
      temp=umkodierungstabelle(gaitcad_struct.merkmalsextraktion.feature_generation.input);
      if any(temp==0)
         mywarning('At least one feature was not found! The regression model cannot be loaded!');
         for i_not_found = find(temp==0)
            fprintf('%s\n',char(merkmale_projekt(gaitcad_struct.merkmalsextraktion.merkmal_auswahl(i_not_found,:))));
         end;
         gaitcad_struct=[];
         cd(oldpath);
         return;
      else
         gaitcad_struct.merkmalsextraktion.feature_generation.input=temp;
      end;
      
      %match output variable name
      %Remark: unknown output variable is set to zero
      gaitcad_struct.designed_regression.output=umkodierungstabelle(gaitcad_struct.designed_regression.output);
   case 'plugin_sequence'
      temp=umkodierungstabelle(gaitcad_struct.plugins);
      if any(temp==0)
         mywarning('At least one selected plugin was not found! The plugin sequence was not loaded!');
         for i_not_found = find(temp==0)
            fprintf('%s\n',char(merkmale_projekt(gaitcad_struct.plugins(i_not_found),:)));
         end;
         gaitcad_struct=[];
         cd(oldpath);
         return;
      else
         gaitcad_struct.plugins=temp;
      end;
end;

cd(oldpath);

clear temp_datei


