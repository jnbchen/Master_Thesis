  function               [konf,relevanz_cv_alle,makro_lern,makro_test]=cvmakro(uihd,enmat,d_org,d_fuz,d_quali,code,code_alle,zgf_y_bez,yfuz,ykont,bez_code,par,datei,zgf,zgf_bez,var_bez,merkmal_auswahl,merkmal_anzeige,merkmal_auswahl_preselection,interpret_merk,interpret_merk_rett,wichtung,L, makro_lern,makro_test,kafka,d_orgs,plugins,dorgbez,parameter,ref,ind_auswahl,cvmakro_mode,d_image)
% function               [konf,relevanz_cv_alle,makro_lern,makro_test]=cvmakro(uihd,enmat,d_org,d_fuz,d_quali,code,code_alle,zgf_y_bez,yfuz,ykont,bez_code,par,datei,zgf,zgf_bez,var_bez,merkmal_auswahl,merkmal_anzeige,merkmal_auswahl_preselection,interpret_merk,interpret_merk_rett,wichtung,L, makro_lern,makro_test,kafka,d_orgs,plugins,dorgbez,parameter,ref,ind_auswahl,cvmakro_mode,d_image)
%
% KAFKA  -RUF: function  [konf,relevanz_cv_alle,makro_lern,makro_test]=cvmakro(uihd,enmat,d_org,d_fuz,d_quali,code,code_alle,zgf_y_bez,yfuz,ykont,bez_code,par,datei,zgf,zgf_bez,var_bez,merkmal_auswahl,merkmal_anzeige,merkmal_auswahl_preselection,interpret_merk,interpret_merk_rett,wichtung,L, makro_lern,makro_test,1    )
% Gait-CAD-RUF: function [konf,relevanz_cv_alle,makro_lern,makro_test]=cvmakro(uihd,enmat,d_org,[]   ,[]     ,code,code_alle,zgf_y_bez,[]  ,[]   ,bez_code,par,datei,[] ,zgf_bez,var_bez,merkmal_auswahl,[]             ,[]                          ,interpret_merk,interpret_merk_rett,[]      ,[],makro_lern,makro_test,0    ,d_orgs,plugins,dorgbez,parameter,ref,ind_auswahl,zr_klassif)
% konf - letzte Konfusionsmatrix über Testdaten
% fehl_proz_alle - Fehler über alle Versuche der Crossvalidierung
% 
% nimmt Suchpfade für Makros mit auf!
%
% The function cvmakro is part of the MATLAB toolbox Gait-CAD. 
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

pfad_start=matlabpath;

%temporary switch off for Gait-CAD release 1.7
parameter.gui.validierung.heterogen_dist_check_cv = 0;

parameter.allgemein.cvmakro = 1;

%do not ignore a-priori relevances by resetting in empty variables
save_interpret_merk      = interpret_merk;
save_interpret_merk_rett = interpret_merk_rett;

projekt_temp = parameter.projekt;
set_empty_variables;
parameter.projekt = projekt_temp;

interpret_merk      = save_interpret_merk;
interpret_merk_rett = save_interpret_merk_rett;


if ~exist('d_image','var')
   d_image.data  = zeros(size(d_org,1),0);
   d_image.names = '';
   d_image.filelist = cell(0,0);
   
end;


%Gait-CAD!!!!!!!!!
par_kafka=[par.anz_dat par.anz_merk 1 par.anz_ling_y(par.y_choice)];
program_name='Gait-CAD';
% Wurde eine ind_auswahl übergeben?
if(nargin < 32)
   ind_auswahl=1:par.anz_dat;
end;
% Wird eine Zeitreihen-Klassifikation oder eine "normale" Klassifikation durchgeführt?
if (nargin < 33)
   cvmakro_mode = 0;
end;
plot_mode = 0;

versuch_cv = parameter.gui.validierung.versuch_cv;
anz_cv = parameter.gui.validierung.anz_cv;
cvhandle=parameter.gui.validierung.typ;
name_validierung='Cross-validation macro';


%Auswahl Lerndaten fuer Crossvalidierung zufaellig?
zufaellig=1;

%Leave on out - jedes Datentupel ist einmal Testdatenttupel
if parameter.gui.validierung.typ==2
   anz_cv=length(ind_auswahl);
   versuch_cv=1;
   
end;

%bei Bootstrap gibt es immer nur einen Durchlauf im Gegensatz zu einer anz_cv-fachen Crossvalidierung!!!
if parameter.gui.validierung.typ==3
   anz_cv=1;
   name_validierung='Bootstrap macro';
end;

%Crossvalidation with output class
if parameter.gui.validierung.typ==4
   versuch_cv=1;
   active_output_terms = unique(code_alle(ind_auswahl,parameter.gui.validierung.cvoutputselect));
   anz_cv = length(active_output_terms);
   zufaellig = 0;
   relevanz_cv_alle.active_output_terms = active_output_terms;
end;

makro_endung = '*.makrog';

% Makros über Auswahlfelder auswählen lassen, aber nur, wenn kein Dateiname übergeben wurde.
if isempty(makro_lern)
   [makro_lern,pfad]=uigetfile(makro_endung,'Load macro for design');
   if (makro_lern==0)
      konf=[];
      relevanz_cv_alle=[];
      makro_lern=[];
      makro_test=[];
      return;
   end;
   addpath(pfad);
   makro_lern=which(makro_lern);
end;
if isempty(makro_test)
   [makro_test,pfad]=uigetfile(makro_endung,'Load macro for test');
   if (makro_test==0)
      konf=[];
      relevanz_cv_alle=[];
      makro_lern=[];
      makro_test=[];
      return;
   end;
   addpath(pfad);
   makro_test=which(makro_test);
end;





%alle Parameter aus Menü einlesen...
%texprotokoll=get(uihd(11,27),'value');

fprintf([name_validierung sprintf('\n')]);

%wenn keine Variablenbezeichnung, dann Leerzeichen
if isempty(var_bez)
   var_bez=char(32*ones(par_kafka(2),1));
end;


% bisherige ind_auswahl sichern...
ind_auswahl_save = ind_auswahl;
%versuch_cv mal die ganze Prozedur
for versuch_cv_nr=1:versuch_cv
   if (versuch_cv_nr > 1)
      parameter.allgemein.no_aktparawin = 1;
   end;
   
   %zufällige Reihenfolge ?
   % Änderung Ole: ind_auswahl berücksichtigen, nicht alle Datentupel verwenden:
   if (zufaellig )
      ind_auswahl = ind_auswahl_save;
      permutation = randperm(length(ind_auswahl));
      ind_zuf = ind_auswahl(permutation);
   else
      ind_zuf = ind_auswahl_save;
   end;
   
   %Vorbereitung Erfassung Testdaten
   switch cvmakro_mode
      case {0,3}
         %Einzelmerkmals-Klassifikation
         konf_cv=zeros(par_kafka(4),par_kafka(4));
         pos_cv=zeros(size(code));
         pos=zeros(size(code));
         mode_prot_cv = 2;
         if cvmakro_mode == 3
            kp.anz_class = par.anz_ling_y(par.y_choice);
         end;            
      case 1
         %Zeitreihen-Klassifikation
         konf_cv=zeros(par_kafka(4),par_kafka(4));
         pos_cv=zeros(size(code));
         pos=zeros(size(code));
         pos_cv_all = zeros(size(d_orgs,1), size(d_orgs,2));
         mode_prot_cv = 2;
      case 2
         %Regression
         ydach_cv = zeros(parameter.par.anz_dat,1);
         ydach    = zeros(parameter.par.anz_dat,1);
         konf =[];
         mode_prot_cv = 3;
   end;
   
   %Initialisierung des Feldes, das die aktiven Merkmale mitschreibt.
   feat_aktiv_cv=zeros(1,par_kafka(2));
   
   %Ablauf Crossvalidierung
   for anz_cv_nr=1:anz_cv
      %Auswahl der Indices der Lerndaten bei anz_cv Lern- und Testdatensätzen
      %pro Klasse alle ausser den Testdaten
      %Testdaten: 1. Datensatz, (1+anz_cv).-ter Datensatz, (1+2*anz_cv).-ter Datensatz, ...
      %Testdaten: 2. Datensatz, (2+anz_cv).-ter Datensatz, (2+2*anz_cv).-ter Datensatz, ...
      %damit ist in den Lerndaten eine ausgewogene Klassengroesse erreicht, die Anzahl
      %der Lerndaten schwankt allerdings etwas
      
      if (cvhandle==1)
         %Crossvalidierung: Zusammenstellung Lerndaten%%%%%%%%%%%%%%%%%%%%%
         ind_cv=[];
         for j=1:par_kafka(4)
            ind_j=find(code(ind_zuf)==j);
            %Sonderlösung bei 1 - alle Daten sind Lerndaten !!
            if anz_cv>1
               ind_j(anz_cv_nr:anz_cv:length(ind_j))=[];
            end;
            ind_cv=[ind_cv ind_j'];
         end;
      end;
      
      %Leave on out - alle außer einem
      if (cvhandle==2)
         ind_cv=1:length(ind_zuf);
         ind_cv(anz_cv_nr)=[];
      end;
      
      %Bootstrap: Zusammenstellung Lerndaten%%%%%%%%%%%%%%%%%%%%%
      if (cvhandle==3)
         ind_cv=1+floor(length(ind_zuf)*rand(1,length(ind_zuf)));
         regr_single =[];
      end;
      
      %Crossvalidation with output class
      if (cvhandle==4)
         ind_cv= 1:length(ind_zuf);
         
         %exclude all data points belonging to the selected term
         ind_cv (code_alle(ind_zuf,parameter.gui.validierung.cvoutputselect) ...
            == active_output_terms(anz_cv_nr)) =[];
         regr_single =[];
         regr_plot = [];
      end;
      
      %Zusammenstellung aktuelle Lerndaten:
      ind_auswahl=sort(ind_zuf(ind_cv));
      
      %Lernen - dazu Makro ausführen
      makro_datei=makro_lern;
      makro_ausfuehren;
      
      %prepare data for heterogenity statistics in regression
      if cvmakro_mode == 2 && parameter.gui.validierung.heterogen_dist_check_cv == 1
         %% apply regression model
         if isempty(regr_plot)
            eval(gaitfindobj_callback('MI_Regression_Anwendung'));
         end;
         regr_plot_design = regr_plot;
      end;
      
      %PLOTTEN ERST NACH DEM 1. LERNMAKRO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      if (versuch_cv_nr==1) && (anz_cv_nr==1)
         %Datei anlegen - mit Protokollkopf
         [tmp,makro_lern_ohnepfad]=fileparts(makro_lern);
         f_cv=get_datei(uihd,sprintf('%d',anz_cv),name_validierung,parameter);
         
         %Standardkopf mit Parametern usw.
         tmp=which(makro_lern);
         tmp=dir(tmp);
         tmp.name(find(tmp.name=='\'))='/';
         fprintf(f_cv,'Learning data: %s %s\n',tmp.name,tmp.date);
         tmp=which(makro_test);
         tmp=dir(tmp);
         tmp.name(find(tmp.name=='\'))='/';
         fprintf(f_cv,'Test data set: %s %s\n',tmp.name,tmp.date);
         clear tmp;
      end;
      %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      
      %Testdaten zusammenstellen
      ind_test = ind_zuf;
      %alles Lerndaten rauslöschen, CV nur bei anz_cv>1 (keine Abarbeitung voller Datensatz!!), bei Bootstrap immer
      if (anz_cv>1) || (cvhandle>1)
         ind_test = setxor(ind_zuf, ind_auswahl);
      end;
      ind_auswahl=ind_test;
      
      % Vor dem Testen bei der Zeitreihen-Klassifikation die Anzeige noch mal abschalten:
      if (cvmakro_mode == 1)
         plot_mode = 0;
      end;
      %Testen - dazu Makro ausführen
      makro_datei=makro_test;
      makro_ausfuehren;
      
      
      %Teilergebnis (nur wenn keine Zeitreihenklassifikation):
      if parameter.gui.anzeige.tex_protokoll==0
         switch cvmakro_mode
            case {0,3}
               %Klassifikation
               fprintf(f_cv,'Confusion matrix %d-fold %s - %d-th data set:\n',anz_cv,name_validierung,anz_cv_nr);
               klass9([],code(ind_auswahl),pos(ind_auswahl),zeros(length(ind_auswahl),par_kafka(4)),0,f_cv,var_bez,[],L);
            case 1
               fprintf(1, '\n\nMinimal classification error: iteration %d of %d: %f\n\n', anz_cv_nr, anz_cv, min(fehl_proz));
            case 2
               %Regression
               [fitness_corrcoef_run,fehl_proz_run] = regression_statistics(regr_plot);
               if cvhandle == 4
                  temp_string = [', ' deblank(zgf_y_bez(parameter.gui.validierung.cvoutputselect,active_output_terms(anz_cv_nr)).name)];
                  
               else
                  temp_string = '';
               end;
               if anz_cv_nr == 1
                  fboth(f_cv,'\n');
               end;
               fboth(f_cv,'%s (%d-fold, %d. dataset, %d. data point%s):\n',name_validierung,anz_cv,anz_cv_nr,length(ind_test),temp_string);
               fboth(f_cv,'Error:%g\n',fehl_proz_run);
               fboth(f_cv,'Correlation coefficient:%g\n',fitness_corrcoef_run);
               
         end;
      end;
      
      %-------------------------------------------------------------------------------------------------------------------------------------------
      % Protkollierung Merkmalskosten, wenn L vorhanden, aber nur bei Klassifikation!!!
      %-------------------------------------------------------------------------------------------------------------------------------------------
      if ~isempty(L) && cvmakro_mode~=2
         if isfield(relevanz_klass,'feat_kost')
            feat_kost_versuch(anz_cv_nr)=feat_kost*length(ind_auswahl);
         end; %exist(feat_kost)
         % Vorbereitung zur Abwandlung der Berechnung der Merkmalskosten. Alle Merkmale die auch nur einmal verwendet wurden voll berechnen.
         if isfield(relevanz_klass,'feature_aktiv')
            % An den Stellen im Feld an denen die verwendeten Merkmale stehen um eins hochzählen!!!!
            if isfield(relevanz_klass,'feature_anteil')
               feature_anteil=relevanz_klass.feature_anteil;
            else
               feature_anteil=ones(1,par_kafka(2));
            end;
            feat_aktiv_cv(relevanz_klass.feature_aktiv)=feat_aktiv_cv(relevanz_klass.feature_aktiv)+feature_anteil(relevanz_klass.feature_aktiv);
            feat_anzahl_versuch(anz_cv_nr)=length(relevanz_klass.feature_aktiv);
         end; %exist(feat_kost)
         if isfield(relevanz_klass,'anz_ebene')
            anz_ebene(anz_cv_nr)=relevanz_klass.anz_ebene;
         end;
      end; %isempty(L)
      
      %Gesamt-Klassifikation Testdaten archivieren
      if ~isempty(pos)
         pos_cv(ind_auswahl)=pos(ind_auswahl);
      end;
      
      if (cvmakro_mode == 1)
         % Bei zeitlicher Aggregation der Merkmal ändert sich die Größe von pos_all.
         % Das muss hier berücksichtigt werden:
         if (~all(size(pos_cv_all) == size(pos_all)))
            clear pos_cv_all;
            pos_cv_all = zeros(size(d_orgs,1), size(pos_all, 2));
         end;
         pos_cv_all(ind_auswahl, :) = pos_all(ind_auswahl, :);
      end;
      
      if (cvmakro_mode == 2)
         %Regression
         ydach_cv(ind_auswahl)=regr_plot.ydach_regr;
         
               
         if parameter.gui.validierung.heterogen_dist_check_cv == 1
            regr_dist_eval.test_data_points = ind_test;
            regr_dist_eval.regr_plot_design = regr_plot_design;
            regr_dist_eval.test_data_enable_gui = 0;
            if exist('callback_distances_for_regression','file')
                callback_distances_for_regression;
            end;
            
            %keyboard;
            %compute descriptors
            relevanz_cv_alle.regr_dist_eval(versuch_cv_nr,anz_cv_nr).mydist = median(regr_dist_eval.mydist);
            relevanz_cv_alle.regr_dist_eval(versuch_cv_nr,anz_cv_nr).mydist_feat = median(regr_dist_eval.mydist_feat);
            relevanz_cv_alle.regr_dist_eval(versuch_cv_nr,anz_cv_nr).number_of_near_neighbors = median(regr_dist_eval.number_of_near_neighbors);
            relevanz_cv_alle.regr_dist_eval(versuch_cv_nr,anz_cv_nr).number_of_near_neighbors_feat = median(regr_dist_eval.number_of_near_neighbors_feat);
            relevanz_cv_alle.regr_dist_eval(versuch_cv_nr,anz_cv_nr).median_error = median(abs(regr_plot.ydach_regr-regr_plot.ytrue_regr));
            relevanz_cv_alle.regr_dist_eval(versuch_cv_nr,anz_cv_nr).total_interpolation_indicator = regr_dist_eval.interpolation_indicator_total;
         end;
      end;
   end; %anz_cv_nr
   
   %-------------------------------------------------------------------------------------------------------------------------------------------
   % Variablenchecks, für die Steuerung der Ausgabe
   %-------------------------------------------------------------------------------------------------------------------------------------------
   % Ist evidenz-aktiv?
   if exist('parameter_regelsuche', 'var')
      evidenz_aktiv=parameter_regelsuche.evidenz;
   else
      evidenz_aktiv=0;
   end;
   
   %Gesamtergebnis:
   %Bei der Crossvalidierung gibt es für jedes Datentupel ein Testergebnis, bei der Bootstrap-Methode nur für die Werte in ind_auswahl!!
   if (cvhandle<3) || (cvhandle == 4)
      ind_auswahl=ind_zuf;
   else %codiert Bootstrap!!!!!
      anz_cv_nr=0;
   end;
   
   switch cvmakro_mode
      case {0,3}
         
         [fehl_proz,fehl_kost,konf_test,relevanz_klass]=protokoll_crossvalidierung(code(ind_auswahl),pos_cv(ind_auswahl),[],versuch_cv,versuch_cv_nr,anz_cv,anz_cv_nr,0,par_kafka,L,parameter.gui.anzeige.tex_protokoll,f_cv,1,[],evidenz_aktiv);
         
         relevanz_cv_alle.fehl_proz_alle(versuch_cv_nr)=fehl_proz;
         relevanz_cv_alle.fehl_kost_alle(versuch_cv_nr)=fehl_kost;
         if exist('feat_kost_versuch', 'var')
            relevanz_cv_alle.feat_kost_alle(versuch_cv_nr)=sum(feat_kost_versuch)/length(pos_cv);
            relevanz_cv_alle.gesamt_kost_alle(versuch_cv_nr)=relevanz_cv_alle.fehl_kost_alle(versuch_cv_nr)+relevanz_cv_alle.feat_kost_alle(versuch_cv_nr);
            relevanz_cv_alle.feature_aktiv_alle(versuch_cv_nr,:)=feat_aktiv_cv;
            relevanz_cv_alle.feature_anzahl_alle(versuch_cv_nr)=mean(feat_anzahl_versuch);
            %relevanz_cv_alle.feature_names{versuch_cv_nr} = regr_single.merkmalsextraktion.var_bez;
         end;
      case 1
         % Der Klassifikationsfehler muss hier einmal neu berechnet werden. Macht sonst protokoll_crossvalidierung, bei Zeitreihen
         % funktioniert die Funktion aber nicht.
         code_all=code*ones(1, size(pos_cv_all,2));
         temp=mean(pos_cv_all(ind_auswahl_save,:)==code_all(ind_auswahl_save,:));
         fehl_proz = 100*(1-temp);
         
         relevanz_cv_alle.fehl_proz_alle(versuch_cv_nr) = min(fehl_proz);
         relevanz_cv_alle.fehl_kost_alle(versuch_cv_nr) = 0;
         relevanz_cv_alle.zr_fehl_proz(versuch_cv_nr, :) = fehl_proz;
         
      case 2
         regr_plot.ydach_regr = ydach_cv(ind_auswahl);
         regr_plot.ytrue_regr = d_org(ind_auswahl,regr_single.designed_regression.output);
         regr_plot.anzeige_erg = 1;
         [relevanz_cv_alle.fitness_corrcoef(versuch_cv_nr),relevanz_cv_alle.fehl_proz_alle(versuch_cv_nr)] = ...
            regression_statistics(regr_plot);
         
   end; % switch (cvmakro_mode)
   
   if exist('anz_ebene', 'var')
      relevanz_cv_alle.anz_ebene(versuch_cv_nr)=mean(anz_ebene);
   end;
   
end; %versuch_cv_nr

automatik=0;


protokoll_crossvalidierung([],[],relevanz_cv_alle,versuch_cv,versuch_cv_nr,anz_cv,anz_cv_nr,0,[],L,parameter.gui.anzeige.tex_protokoll,f_cv,mode_prot_cv,[],0,var_bez);

%special protocol for distances and class-wise CV
if cvmakro_mode == 2 && parameter.gui.validierung.heterogen_dist_check_cv == 1
   
   protokoll_cv_class_dist_cv;
end;

if (cvmakro_mode == 1)
   fprintf(1, 'Classification accuracy for all sample points in relevanz_cv_alle.zr_fehl_proz\n');
end; % if (~cvmakro_mode)

%File schliessen, aber nicht Bildschirm!
if f_cv~=1
   fclose(f_cv);
end;

%MATLABPATH wiederherstellen
matlabpath(pfad_start);

%Makros zurücksetzen
makro_lern=[];
makro_test=[];


fprintf('End of validation\n');

