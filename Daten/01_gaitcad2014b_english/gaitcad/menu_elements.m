% Script menu_elements
%
%  Dieses Skript definiert die Menüelemente, die dann an createMenuElements übergeben werden
%  können.
% 
%  Die Definition der Menüelemente ist wie folgt:
%  .uihd_code: (1x2)-Vektor; enthält die Indizes für die UIHD-Matrix
%  .handle: leer oder weglassen. Wird durch createMenuElements mit dem Handle gefüllt.
%  .name: Zeichenkette; enthält den Namen des Menüeintrags
%  .delete_pointerstatus: 0 oder 1; keine Ahnung, wofür das gut ist. Im Zweifel auf 0 setzen :)
%  .callback: Zeichenkette; enthält den Callback, der bei einem Klick auf das Element ausgeführt wird.
%  .tag: Zeichenkette; wird als Tag in das Element eingetragen und dient zur
%  Identifikation der Menüelemente
%  .menu_af: leer oder Zeichenkette; wenn das Element das Öffnen eines Auswahlfensters erfordert,
%  muss dieses Feld mit einer Zeichenkette als Namen für das Fenster gefüllt sein. Ist dieses Feld
%  gesetzt, wird von createMenuElements new_menu_af anstelle von new_menu verwendet.
%  .callback_af: Zeichenkette; der Callback, der an new_menu_af übergeben wird. Wird ein Callback
%  in .callback geschrieben, wird dieser an den Callback, der von new_menu_af erzeugt wird, angehängt.
%  .menu_items: Vektor; enthält alle Unterelemente des Menüeintrags. Die Unterelemente werden durch die
%  Indizes im Strukt identifiziert. Trennlinien können durch -1 angegeben werden.
%  Z.B.: elements(mc).menu_items = [4 13 2 8 14 -1 11 12 -1 5 6 7 -1 9 10 -1 3];
% 
% 
%
% The script menu_elements is part of the MATLAB toolbox Gait-CAD. 
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

parameter.gui.menu = [];
parameter.gui.menu.main_menu = {'MI_Datei', 'MI_Bearbeiten', 'MI_Ansicht', 'MI_DataMining', 'MI_Extras', 'MI_Favoriten', 'MI_Fenster', 'MI_Hilfe'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Datei
mc = 1;
elements(mc).uihd_code = [1 1];
elements(mc).handle = [];
elements(mc).name = 'File';
elements(mc).tag = 'MI_Datei';
elements(mc).menu_items = {'MI_Laden', 'MI_Speichern', 'MI_SpeichernUnter', 'MI_SaveMeanAggregation','MI_Export_ASCII', 'MI_Import_ASCII', 'MI_Project_Fusion',-1, ...
      'MI_Gaitbatch', 'MI_GaitbatchDebug', 'MI_GaitbatchDebugStep', -1, ...
      'MI_Datei_Norm', -1, ...
      'MI_Datei_DataMining', -1, ...      
      'MI_Datei_Einstellungen', -1, ...       
      'MI_Beenden'};
elements(mc).freischalt = {'1'};
elements(mc).freischalt_c = 0;


mc = mc+1;
elements(mc).uihd_code = [1 39];
elements(mc).handle = [];
elements(mc).name = 'Normative data';
elements(mc).tag = 'MI_Datei_Norm';
elements(mc).menu_items = {'MI_ImportNorm', 'MI_ExportNorm', 'MI_Mittelwert_zu_Norm'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

mc = mc+1;
elements(mc).uihd_code = [1 40];
elements(mc).handle = [];
elements(mc).name = 'Options';
elements(mc).tag = 'MI_Datei_Einstellungen';
elements(mc).menu_items = {'MI_Einstellungen_laden', 'MI_Einstellungen_speichern','MI_StandardEinstellungen_speichern',-1,'MI_Frequenzliste_Laden'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Data-Mining
mc = mc+1;
elements(mc).uihd_code = [1 36];
elements(mc).handle = [];
elements(mc).name = 'Data mining';
elements(mc).tag = 'MI_Datei_DataMining';
elements(mc).menu_items = {'MI_Fuzzy_RUBImport',  'MI_Fuzzy_RUBImportMBF', 'MI_Fuzzy_RUBExport','MI_Fuzzy2C',-1,...
      'MI_Classifier_Import',  'MI_Classifier_Export','MI_Bayes2C',-1,...
      'MI_Regression_Import',  'MI_Regression_Export',-1};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Bearbeiten
mc = mc+1; %
elements(mc).uihd_code = [2 19];
elements(mc).handle = [];
elements(mc).name = 'Edit';
elements(mc).tag = 'MI_Bearbeiten';
elements(mc).menu_items = {'MI_Auswaehlen', 'MI_Extrahieren', 'MI_Transformieren', 'MI_Loeschen', 'MI_Sortieren', 'MI_Ausreisser','MI_Kategorie', -1, ...
      'MI_Umbenennen', -1, ...
      'MI_Erstelle_Trigger', ...
      'MI_Bearbeite_Trigger',-1, ...
      'MI_Anzeige_FehlDaten'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Auswählen
mc = mc+1; %
elements(mc).uihd_code = [2 20];
elements(mc).handle = [];
elements(mc).name = 'Select';
elements(mc).tag = 'MI_Auswaehlen';
elements(mc).menu_items = {'MI_Datenauswahl_Alle', 'MI_Datenauswahl_Klassen', 'MI_Datenauswahl_Nr','MI_Datenauswahl_GUI','MI_Datenauswahl_PercDataPoints','MI_Datenauswahl_FreqCode', 'MI_Datenauswahl_ValueSelection',...
   'MI_Datenauswahl_NonInfZR', 'MI_Datenauswahl_NonInfEM',-1,...
      'MI_Zeitreihen_Alle', -1, 'MI_Einzelmerkmal_Alle' };
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Extrahieren
mc = mc+1; %
elements(mc).uihd_code = [2 25];
elements(mc).handle = [];
elements(mc).name = 'Extract';
elements(mc).tag = 'MI_Extrahieren';
elements(mc).menu_items = {'MI_Extraktion_ZRZR', 'MI_Extraktion_ZRZR_Kombi', 'MI_Extraktion_EMEMA','MI_ExtrStatSFTerm','MI_TermStat_Klasse',-1,...
   'MI_Extraktion_Segment2Einzug'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Transformieren
mc = mc+1; %
elements(mc).uihd_code = [2 27];
elements(mc).handle = [];
elements(mc).name = 'Convert';
elements(mc).tag = 'MI_Transformieren';
elements(mc).menu_items = {'MI_EM_Klasse', 'MI_Trans_EM2ZR', 'MI_Trans_DSEM2ZR','MI_Trans_DSDTEM2ZR', -1, 'MI_DT2Feat', -1,'MI_Trans_ZR2EM', 'MI_Trans_ZR2EM_SampleTupel', 'MI_ZR2DT',-1,  ...
      'MI_Extraktion_Teile_ZR','MI_Kuerze_ZR','MI_ZR2PTS',-1,'MI_Trans_Klasse2EM','MI_Trans_Klasse2EMZ', 'MI_Trans_Class2PathDirclasses', ...
      'MI_Trans_Class2PathDirExclasses', 'MI_Trans_POS2Y','MI_Trans_POS2EM', 'MI_Trans_PRZ2EM', 'MI_AddClassAll', 'MI_Kl_Kl_Oder', 'MI_Kl_Kl_Und', 'MI_Trans_Term_Order',-1,'MI_Trans_CleanUpNames'}; 
%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen
mc = mc+1; %
elements(mc).uihd_code = [2 29];
elements(mc).handle = [];
elements(mc).name = 'Delete';
elements(mc).tag = 'MI_Loeschen';
elements(mc).menu_items = {'MI_Loeschen_Datentupel','MI_Loeschen_Datentupel_NonSel', -1, ...
      'MI_Loeschen_doppelt', -1, ...
      'MI_Loesche_ZR', 'MI_Loeschen_iZR', 'MI_Loeschen_Kselect', -1, ...
      'MI_Loeschen_alleEM', 'MI_Loesche_EM', 'MI_Loesche_iEM', -1, ...
      'MI_Loeschen_Klasse','MI_Loeschen_NonExTerms',-1,'MI_Nullzr_loeschen'};
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen
mc = mc+1; %
elements(mc).uihd_code = [2 83];
elements(mc).handle = [];
elements(mc).name = 'Sorting';
elements(mc).tag = 'MI_Sortieren';
elements(mc).menu_items = {'MI_Sortieren_SingleFeatures','MI_Sortieren_TimeSeries','MI_Sortieren_OutputVariables','MI_Sortieren_Images'};
  %%%%%%%%%%%%%%%%%%%%%%%%%
  
% Ansicht
mc = mc+1; %
elements(mc).uihd_code = [2 30];
elements(mc).handle = [];
elements(mc).name = 'View';
elements(mc).tag = 'MI_Ansicht';
elements(mc).menu_items = {'MI_Anzeige_Datentupel', 'MI_Anzeige_Terms', -1, ...
      'MI_Zeitreihen', 'MI_Einzelmerkmale', 'MI_Anzeige_Klassifikation', 'MI_Anzeige_Regression','MI_Ansicht_Aggregation', 'MI_Ausgangsgroessen', -1, ...
      'MI_Spektrogramm', 'MI_MorletSpektro', 'MI_KKFAKF', 'MI_FFTAll', -1, ...
      'MI_Ansicht_Fuzzy', 'MI_Ansicht_Ebaum','MI_Ansicht_Clustern', 'MI_Ansicht_SOM','MI_Ansicht_PairDistDat',-1, ...
      'MI_Projektreport', 'MI_Umkodierung'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Hilfe
mc = mc+1; %
elements(mc).uihd_code = [2 32];
elements(mc).handle = [];
elements(mc).name = 'Help';
elements(mc).tag = 'MI_Hilfe';
elements(mc).menu_items = {'MI_Hilfe_PDF', -1, 'MI_Hilfe_About', 'MI_Hilfe_Lizenz'};
elements(mc).freischalt = {'1'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekt speichern unter...
mc = mc+1; % (2)
elements(mc).uihd_code = [1 4];
elements(mc).handle = [];
elements(mc).name = 'Save project as...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'saveprj_g;';
elements(mc).tag = 'MI_SpeichernUnter';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Beenden
mc = mc+1; % (3)
elements(mc).uihd_code = [1 5];
elements(mc).handle = [];
elements(mc).name = 'Exit';
elements(mc).delete_pointerstatus = 1;
elements(mc).callback = 'callback_beenden;';
elements(mc).tag = 'MI_Beenden';
elements(mc).freischalt = {'1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekt laden
mc = mc+1; % (4)
elements(mc).uihd_code = [1 6];
elements(mc).handle = [];
elements(mc).name = 'Load project';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ldprj_g;if datei eval(get(uihd(2,4),''callback'')); eval(get(figure_handle(size(figure_handle,1),1),''callback''));end;';
elements(mc).tag = 'MI_Laden';
elements(mc).freischalt = {'isempty(teach_modus)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Normkurven importieren
mc = mc+1; % (5)
elements(mc).uihd_code = [1 7];
elements(mc).handle = [];
elements(mc).name = 'Load normative data';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_normdaten_laden;';
elements(mc).tag = 'MI_ImportNorm';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Normkurven exportieren
mc = mc+1; % (6)
elements(mc).uihd_code = [1 8];
elements(mc).handle = [];
elements(mc).name = 'Save normative data';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_normdaten_speichern;';
elements(mc).tag = 'MI_ExportNorm';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(ref)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Mittelwert zu Normdaten
mc = mc+1; % (7)
elements(mc).uihd_code = [1 12];
elements(mc).handle = [];
elements(mc).name = 'Mean value to normative data';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_mw2norm;';
elements(mc).tag = 'MI_Mittelwert_zu_Norm';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ASCII-Export (ausgewählte Einzelmerkmale und Datentupel)
mc = mc+1; % (8)
elements(mc).uihd_code = [1 17];
elements(mc).handle = [];
elements(mc).name = 'Export data';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = [];
elements(mc).tag = 'MI_Export_ASCII';
elements(mc).menu_items = {'MI_Export_Ordner', 'MI_Export_Datei'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% aus Ordner
mc = mc+1; % (14)
elements(mc).uihd_code = [1 37];
elements(mc).handle = [];
elements(mc).name = 'Time series in multiple files...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'modus = 2; callback_export;';
elements(mc).tag = 'MI_Export_Ordner';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% aus einer Datei
mc = mc+1; % (14)
elements(mc).uihd_code = [1 38];
elements(mc).handle = [];
elements(mc).name = 'Single features in a file...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'modus = 1; callback_export;';
elements(mc).tag = 'MI_Export_Datei';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Optionen aus UIHDG-Datei laden
mc = mc+1; % (9)
elements(mc).uihd_code = [1 21];
elements(mc).handle = [];
elements(mc).name = 'Load options';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_load_options;';
elements(mc).tag = 'MI_Einstellungen_laden';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Optionen in UIHDG-Datei speichern
mc = mc+1; % (10)
elements(mc).uihd_code = [1 22];
elements(mc).handle = [];
elements(mc).name = 'Save options';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_save_options;';
elements(mc).tag = 'MI_Einstellungen_speichern';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekt speichern
mc = mc+1; % (13)
elements(mc).uihd_code = [1 25];
elements(mc).handle = [];
elements(mc).name = 'Save project';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'cd(parameter.projekt.pfad);datei_save=[parameter.projekt.datei ''.prjz''];saveprj_g;';
elements(mc).tag = 'MI_Speichern';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Daten importieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 27];
elements(mc).handle = [];
elements(mc).name = 'Import data';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = [];
elements(mc).tag = 'MI_Import_ASCII';
elements(mc).menu_items = {'MI_Import_Ordner', 'MI_Import_Datei', 'MI_Import_DateiIntAktMATLAB', -1, 'MI_Datei_ImportiereZRBezeichner', 'MI_Datei_ImportiereEMBezeichner'};
elements(mc).freischalt = {'isempty(teach_modus)'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% aus Ordner
mc = mc+1; % (14)
elements(mc).uihd_code = [1 28];
elements(mc).handle = [];
elements(mc).name = 'From a directory...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'modus = 2; callback_import;';
elements(mc).tag = 'MI_Import_Ordner';
elements(mc).freischalt = {'isempty(teach_modus)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% aus einer Datei
mc = mc+1; % (14)
elements(mc).uihd_code = [1 29];
elements(mc).handle = [];
elements(mc).name = 'From a file...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'modus = 1; callback_import;';
elements(mc).tag = 'MI_Import_Datei';
elements(mc).freischalt = {'isempty(teach_modus)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% aus einer Datei
mc = mc+1; % (14)
elements(mc).uihd_code = [1 30];
elements(mc).handle = [];
elements(mc).name = 'interactice from a file';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'import_matlab_data_tool;';
elements(mc).tag = 'MI_Import_DateiIntAktMATLAB';
elements(mc).freischalt = {'isempty(teach_modus)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% aus einer Datei
mc = mc+1; % (neu)
elements(mc).uihd_code = [1 34];
elements(mc).handle = [];
elements(mc).name = 'Load classifier';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikator_laden;';
elements(mc).tag = 'MI_Classifier_Import';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% aus einer Datei
mc = mc+1; % (14)
elements(mc).uihd_code = [1 35];
elements(mc).handle = [];
elements(mc).name = 'Save classifier';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikator_save;';
elements(mc).tag = 'MI_Classifier_Export';
elements(mc).freischalt = {'~isempty(klass_single)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% aus einer Datei
mc = mc+1; % (neu)
elements(mc).uihd_code = [1 41];
elements(mc).handle = [];
elements(mc).name = 'Load regression model';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_regressor_laden;';
elements(mc).tag = 'MI_Regression_Import';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% aus einer Datei
mc = mc+1; % (14)
elements(mc).uihd_code = [1 42];
elements(mc).handle = [];
elements(mc).name = 'Save regression model';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_regressor_speichern;';
elements(mc).tag = 'MI_Regression_Export';
elements(mc).freischalt = {'~isempty(regr_single)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekte fusionieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 43];
elements(mc).handle = [];
elements(mc).name = 'Fusion of projects';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_items = {'MI_Project_Fusion_ZREM','MI_Project_Fusion_DT', 'MI_Project_Fusion_ZREMTol', 'MI_Project_Fusion_ZREMTolNaN'};
elements(mc).tag = 'MI_Project_Fusion';
elements(mc).freischalt = {'1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekte fusionieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 44];
elements(mc).handle = [];
elements(mc).name = 'Additional time series and single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_new_project=1;project_fusion;';
elements(mc).tag = 'MI_Project_Fusion_ZREM';
elements(mc).freischalt = {'1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekte fusionieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 45];
elements(mc).handle = [];
elements(mc).name = 'Additional data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_new_project=2;project_fusion;';
elements(mc).tag = 'MI_Project_Fusion_DT';
elements(mc).freischalt = {'1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; % (9)
elements(mc).uihd_code = [1 46];
elements(mc).handle = [];
elements(mc).name = 'Load frequency list';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_load_freq;';
elements(mc).tag = 'MI_Frequenzliste_Laden';
elements(mc).freischalt = {'1'};

mc = mc+1; % (9)
elements(mc).uihd_code = [1 47];
elements(mc).handle = [];
elements(mc).name = 'Apply Gait-CAD batch file';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'gaitdebug = 0;gaitbatch;';
elements(mc).tag = 'MI_Gaitbatch';
elements(mc).freischalt = {'isempty(teach_modus)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Optionen in UIHDG-Datei speichern
mc = mc+1; % (10)
elements(mc).uihd_code = [1 48];
elements(mc).handle = [];
elements(mc).name = 'Save standard options';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ausGUI; save_options(parameter.gui.control_elements, [parameter.allgemein.userpath filesep parameter.allgemein.name_optionfile],plugins);';
elements(mc).tag = 'MI_StandardEinstellungen_speichern';

%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekte fusionieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 49];
elements(mc).handle = [];
elements(mc).name = 'Additional time series and single features (tolerant for the selected output variable and data points, NaNs are deleted)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_new_project=3;project_fusion;';
elements(mc).tag = 'MI_Project_Fusion_ZREMTol';
elements(mc).freischalt = {'1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekte fusionieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 50];
elements(mc).handle = [];
elements(mc).name = 'Additional time series and single features (tolerant for the selected output variable and data points, NaNs are retained)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_new_project=4;project_fusion;';
elements(mc).tag = 'MI_Project_Fusion_ZREMTolNaN';
elements(mc).freischalt = {'1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekte fusionieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 51];
elements(mc).handle = [];
elements(mc).name = 'Export ANSI C Code of the Bayes classifier';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_bayes2c;';
elements(mc).tag = 'MI_Bayes2C';
elements(mc).freischalt = {'~isempty(klass_single) && isfield(klass_single(1), ''bayes'') && length(klass_single)==1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Projekte fusionieren
mc = mc+1; % (14)
elements(mc).uihd_code = [1 52];
elements(mc).handle = [];
elements(mc).name = 'Export ANSI-C-Code fuzzy rulebase';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_fuzzy2c;';
elements(mc).tag = 'MI_Fuzzy2C';
elements(mc).freischalt = {'~isempty(fuzzy_system) && isfield(fuzzy_system,''rulebase'') && ~isempty(fuzzy_system.rulebase)'};

mc = mc+1; % (9)
elements(mc).uihd_code = [1 53];
elements(mc).handle = [];
elements(mc).name = 'Apply Gait-CAD batch file (debug mode)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'gaitdebug = 1; gaitbatch;';
elements(mc).tag = 'MI_GaitbatchDebug';
elements(mc).freischalt = {'isempty(teach_modus)'};

mc = mc+1; % (9)
elements(mc).uihd_code = [1 54];
elements(mc).handle = [];
elements(mc).name = 'Apply Gait-CAD batch file (step and debug mode)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'gaitdebug = 2; gaitbatch;';
elements(mc).tag = 'MI_GaitbatchDebugStep';
elements(mc).freischalt = {'isempty(teach_modus)'};
 
mc = mc+1; % (9)
elements(mc).uihd_code = [1 55];
elements(mc).handle = [];
elements(mc).name = 'Mean value project (based on the selected output variable)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_mean_aggregation;';
elements(mc).tag = 'MI_SaveMeanAggregation';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
 


%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen: ZR (manuell)...
mc = mc+1; % (16)
elements(mc).uihd_code = [2 3];
elements(mc).handle = [];
elements(mc).name = 'Selected time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_zr = parameter.gui.merkmale_und_klassen.ind_zr;callback_zr_loeschen;';
elements(mc).tag = 'MI_Loesche_ZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Datenauswahl ...
mc = mc+1; % (17)
elements(mc).uihd_code = [2 4];
elements(mc).handle = [];
elements(mc).name = 'Data points using classes ...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.dat';
elements(mc).callback_af = '[string,info,callback]=datenauswahl_text(bez_code,zgf_y_bez,code_alle,par); par.anz_ind_auswahl=0;';
elements(mc).tag = 'MI_Datenauswahl_Klassen';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen: EM (manuell)...
mc = mc+1; % (18)
elements(mc).uihd_code = [2 5];
elements(mc).handle = [];
elements(mc).name = 'Selected single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_merkmale = parameter.gui.merkmale_und_klassen.ind_em;callback_em_loeschen;';
elements(mc).tag = 'MI_Loesche_EM';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen: EM (manuell, inverse Auswahl)
mc = mc+1; % (19)
elements(mc).uihd_code = [2 6];
elements(mc).handle = [];
elements(mc).name = 'Unselected single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_merkmale = setdiff(1:par.anz_einzel_merk,parameter.gui.merkmale_und_klassen.ind_em);callback_em_loeschen;';
elements(mc).tag = 'MI_Loesche_iEM';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Datenauswahl anzeigen
mc = mc+1; % (20)
elements(mc).uihd_code = [2 7];
elements(mc).handle = [];
elements(mc).name = 'Classes for selected data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'show_datenauswahl(parameter,code_alle,ind_auswahl,bez_code,zgf_y_bez);';
elements(mc).tag = 'MI_Anzeige_Datentupel';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Datenauswahl anzeigen
mc = mc+1; % (20)
elements(mc).uihd_code = [2 8];
elements(mc).handle = [];
elements(mc).name = 'Number of terms for selected data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'show_terms(parameter,code_alle,ind_auswahl,bez_code,zgf_y_bez);';
elements(mc).tag = 'MI_Anzeige_Terms';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
% Automatische Null-Zeitreihenreduktion (Datentupel löschen)
mc = mc+1; % (22)
elements(mc).uihd_code = [2 9];
elements(mc).handle = [];
elements(mc).name = 'Missing data';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'aut_zr_loesch;';
elements(mc).tag = 'MI_Nullzr_loeschen';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen: doppelte EM und ZR
mc = mc+1; % (23)
elements(mc).uihd_code = [2 10];
elements(mc).handle = [];
elements(mc).name = 'Double single features, time series, and output variables';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_loeschen_doppelte_merk;';
elements(mc).tag = 'MI_Loeschen_doppelt';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraktion neuer Zeitreihen oder Einzelmerkmale aus Zeitreihen
mc = mc+1; % (24)
elements(mc).uihd_code = [2 11];
elements(mc).handle = [];
elements(mc).name = 'Time series -> Time series, Time series -> Single features...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.gen';
elements(mc).callback_af = 'mode_selection=2;callback_anzeige_plugins;[string,info,callback,auswahl] = callback_extract_features(plugins,parameter,auswahl);';
elements(mc).callback = '';
elements(mc).tag = 'MI_Extraktion_ZRZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUSTER Berechnung ...
mc = mc+1; % (25)
elements(mc).uihd_code = [2 12];
elements(mc).handle = [];
elements(mc).name = 'Design and apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_cluster=1;cluster_okay;';
elements(mc).tag = 'MI_Cluster_Ber';
elements(mc).freischalt = {'~isempty(par) && (par.anz_merk > 0 || par.anz_einzel_merk > 0)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Manuelle Datenauswahl ...
mc = mc+1; % (26)
elements(mc).uihd_code = [2 13];
elements(mc).handle = [];
elements(mc).name = 'Data points using numbers ...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.ind_auswahl';
elements(mc).callback_af = 'auswahl.dat = []; if(~parameter.allgemein.makro_ausfuehren) auswahl.ind_auswahl=ind_auswahl''; end;[string,info,callback]=callback_ds_auswahl_manuell(par);';
elements(mc).tag = 'MI_Datenauswahl_Nr';
%%%%%%%%%%%%%%%%%%%%%%%%%
% EM -> Klasse (Auswahl EM)
mc = mc+1; % (27)
elements(mc).uihd_code = [2 14];
elements(mc).handle = [];
elements(mc).name = 'Selected single features -> Output variables';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_em_trans;';
elements(mc).tag = 'MI_EM_Klasse';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen: Ausgangsgröße ...
mc = mc+1; % (28)
elements(mc).uihd_code = [2 15];
elements(mc).handle = [];
elements(mc).name = 'Output variable ...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.ausgloesch';
elements(mc).callback_af = 'info(1,:)=''Output variable'';string=poplist_popini(bez_code);if(~parameter.allgemein.makro_ausfuehren) auswahl.ausgloesch=par.y_choice; end;callback=''callback_ausgangloeschen;'';';
elements(mc).tag = 'MI_Loeschen_Klasse';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_y > 1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraktion neuer Einzelmerkmale aus Einzelmerkmalen
mc = mc+1; % (29)
elements(mc).uihd_code = [2 53];
elements(mc).handle = [];
elements(mc).name = 'Single features -> Single features (with the selected feature aggregation from Options-Data Mining: Classification of single features)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_em2aem;';
elements(mc).tag = 'MI_Extraktion_EMEMA';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen: ZR (manuell, inverse Auswahl)
mc = mc+1; % (30)
elements(mc).uihd_code = [2 17];
elements(mc).handle = [];
elements(mc).name = 'Unselected time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_zr = setdiff(1:par.anz_merk,parameter.gui.merkmale_und_klassen.ind_zr);callback_zr_loeschen;';
elements(mc).tag = 'MI_Loeschen_iZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klasse -> Klasse: Terme vereinen (ODER-Verknüpfung mit Datenauswahl, Beschriftung aktuelle Klasse)
mc = mc+1; % (32)
elements(mc).uihd_code = [2 22];
elements(mc).handle = [];
elements(mc).name = 'Class -> Class: Combine terms (OR-operation with data point selection, name of the current output variable)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = '[code_alle, zgf_y_bez, bez_code]=ausgkl_zusfuegen(par, ind_auswahl, code_alle, zgf_y_bez, bez_code);aktparawin;';
elements(mc).tag = 'MI_Kl_Kl_Oder';
%elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(ind_auswahl) && ~isempty(ausgkl_zusfuegen_indrest(code_alle,ind_auswahl,par))'};
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(ind_auswahl)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Datentupel löschen ... (aus Datenauswahl)
mc = mc+1; % (33)
elements(mc).uihd_code = [2 23];
elements(mc).handle = [];
elements(mc).name = 'Selected data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_ds = ind_auswahl;callback_ds_loeschen;';
elements(mc).tag = 'MI_Loeschen_Datentupel';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_dat > 1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Löschen: alle EM
mc = mc+1; % (34)
elements(mc).uihd_code = [2 24];
elements(mc).handle = [];
elements(mc).name = 'All single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_merkmale = 1:par.anz_einzel_merk;callback_em_loeschen;';
elements(mc).tag = 'MI_Loeschen_alleEM';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klasse -> Klasse: Ausgangsgrößen kombinieren (UND-Verknüpfung Ausgangsgrößen) ...
mc = mc+1; % (35)
elements(mc).uihd_code = [2 26];
elements(mc).handle = [];
elements(mc).name = 'Class -> Class: conjunction (AND) of output variables ...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.ausgkombi';
elements(mc).callback_af = '[string,info,callback]=ausgang_kombi_text(bez_code);';
elements(mc).tag = 'MI_Kl_Kl_Und';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Kombinierte Extraktion (Plugins aus Hauptfenster)...
mc = mc+1; % (36)
elements(mc).uihd_code = [2 45];
elements(mc).handle = [];
elements(mc).name = 'Time series -> Time series, Time series -> Single features (via plugin sequence)...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.ausgkombi';
elements(mc).menu_af_manu = 1;
elements(mc).callback_af = 'string=plugins.mgenerierung_plugins.string([1:2],:);info=plugins.mgenerierung_plugins.info_auswahlfenster([1:2],:);callback=''callback_mgenerierung_kombi'';';
elements(mc).tag = 'MI_Extraktion_ZRZR_Kombi';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihensegment als Einzug übernehmen
mc = mc+1; % 
elements(mc).uihd_code = [2 62];
elements(mc).handle = [];
elements(mc).name = 'Save time series segment for feature extraction';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_segment2einzug;';
elements(mc).tag = 'MI_Extraktion_Segment2Einzug';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab Cluster Berechnung (STAT-Toolbox)
mc = mc+1; % (37)
elements(mc).uihd_code = [2 46];
elements(mc).handle = [];
elements(mc).name = 'Design and apply (Statistic Toolbox)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_cluster=2; cluster_okay;';
elements(mc).tag = 'MI_Cluster_matlab';
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 '};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Mittelwert und Streuung
mc = mc+1; % (39)
elements(mc).uihd_code = [4 2];
elements(mc).handle = [];
elements(mc).name = 'Mean and standard deviation';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'showrange=0;callback_mwstreuung;';
elements(mc).tag = 'MI_Anzeige_MW_Streu';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Korrelationskoeffizienten
mc = mc+1; % (40)
elements(mc).uihd_code = [4 3];
elements(mc).handle = [];
elements(mc).name = 'Correlation coefficients (Pearson)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'temp_corr_mode = 1; callback_corr_aut;';
elements(mc).tag = 'MI_Anzeige_EM_Korr';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Absolute Werte
mc = mc+1; % (41)
elements(mc).uihd_code = [4 4];
elements(mc).handle = [];
elements(mc).name = 'Absolute values';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'em_aut(code_alle(ind_auswahl,:),zgf_y_bez,bez_code,d_org(ind_auswahl,:),dorgbez,ind_auswahl,parameter);';
elements(mc).tag = 'MI_Anzeige_EM_Abs';
%%%%%%%%%%%%%%%%%%%%%%%%%
% T-Test berechnen (nur mit STAT-Toolbox!)
mc = mc+1; % (42)
elements(mc).uihd_code = [4 5];
elements(mc).handle = [];
elements(mc).name = 'Compute T-test (with Statistics Toolbox!)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'paired=0;callback_ttest;';
elements(mc).tag = 'MI_TTest';
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 '};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Gepaarten T-Test berechnen (nur mit STAT-Toolbox!)
mc = mc+1; % (43)
elements(mc).uihd_code = [4 6];
elements(mc).handle = [];
elements(mc).name = 'Paired T-Test (with Statistics Toolbox!)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'paired=1;callback_ttest;';
elements(mc).tag = 'MI_Paired_TTest';
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 '};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Mittelwert, Streuung, Minimum, Maximum
mc = mc+1; % (45)
elements(mc).uihd_code = [4 8];
elements(mc).handle = [];
elements(mc).name = 'Mean, standard deviation, minimum, maximum';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'showrange=1;callback_mwstreuung;';
elements(mc).tag = 'MI_Anzeige_EM_Min_Max';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Spearmankorrelationskoeffizienten
mc = mc+1; % (46)
elements(mc).uihd_code = [4 9];
elements(mc).handle = [];
elements(mc).name = 'Correlation coefficients (Spearman)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'temp_corr_mode = 2; callback_corr_aut;';
elements(mc).tag = 'MI_Anzeige_EM_Spear';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klassifikationsgüte
mc = mc+1; % (47)
elements(mc).uihd_code = [4 10];
elements(mc).handle = [];
elements(mc).name = 'Classification accuracy';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 6; mode_univariat=2;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_Klassifikation';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Fuzzy-Klassifikationsgüte
mc = mc+1; % (48)
elements(mc).uihd_code = [4 11];
elements(mc).handle = [];
elements(mc).name = 'Fuzzy classification accuracy';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 7; mode_univariat=2;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_Fuzzy';
%%%%%%%%%%%%%%%%%%%%%%%%%
% mod. Fuzzy-Klassifikationsgüte
mc = mc+1; % (49)
elements(mc).uihd_code = [4 12];
elements(mc).handle = [];
elements(mc).name = 'Weighted fuzzy classification accuracy';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 8; mode_univariat=2;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_ModFuzzy';
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [4 13];
elements(mc).handle = [];
elements(mc).name = 'Regression accuracy (univariate)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 11; mode_univariat=1;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_RegKomplUni';
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [4 14];
elements(mc).handle = [];
elements(mc).name = 'Regression accuracy (multivariate)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 12; mode_univariat=2;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_RegKomplMulti';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Median, Minimum, Maximum
mc = mc+1; % (45)
elements(mc).uihd_code = [4 15];
elements(mc).handle = [];
elements(mc).name = 'Median, Minimum, Maximum';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'showrange=2;callback_mwstreuung;';
elements(mc).tag = 'MI_Anzeige_EM_Med_Min_Max';
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; % (43)
elements(mc).uihd_code = [4 16];
elements(mc).handle = [];
elements(mc).name = 'Compute Wilcoxon ranksum test (with Statistics Toolbox!)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'paired=2;callback_ttest;';
elements(mc).tag = 'MI_Wilcoxon';
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 '};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [4 17];
elements(mc).handle = [];
elements(mc).name = 'Regression accuracy via improvement of the mean error (univariate)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 13; mode_univariat=1;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_RegKomplUniMeanErr';
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [4 18];
elements(mc).handle = [];
elements(mc).name = 'Regression accuracy via improvement of the mean error (multivariate)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 14; mode_univariat=2;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_RegKomplMultiMeanErr';

% Spearmankorrelationskoeffizienten
mc = mc+1; % (46)
elements(mc).uihd_code = [4 19];
elements(mc).handle = [];
elements(mc).name = 'Correlation coefficients (Kendall)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'temp_corr_mode = 3; callback_corr_aut;';
elements(mc).tag = 'MI_Anzeige_EM_Kendall';

mc = mc+1; % (43)
elements(mc).uihd_code = [4 20];
elements(mc).handle = [];
elements(mc).name = 'Chi-Square test output variable vs. discrete-valued single feature';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'paired=3;callback_ttest;';
elements(mc).tag = 'MI_ChiSquareCrosstabOutSingle';
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 && par.anz_einzel_merk > 0'};

mc = mc+1; % (43)
elements(mc).uihd_code = [4 21];
elements(mc).handle = [];
elements(mc).name = 'Chi-Square test for contingency tables of output variables';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'paired=4;callback_ttest;';
elements(mc).tag = 'MI_ChiSquareCrosstabAllOut';
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 && par.anz_y>1'};


mc = mc+1; % (43)
elements(mc).uihd_code = [4 22];
elements(mc).handle = [];
elements(mc).name = 'Test of normal distribution';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_normtest(d_org(ind_auswahl,:),dorgbez,code(ind_auswahl),zgf_y_bez,bez_code,par,parameter,uihd);';
elements(mc).tag = 'MI_NormTest';
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Originaldaten
mc = mc+1; % (51)
elements(mc).uihd_code = [5 2];
elements(mc).handle = [];
elements(mc).name = 'Original time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1; callback_visuzeitreihe;';
elements(mc).tag = 'MI_Anzeige_ZR_Orig';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Mittelwertszeitreihen
mc = mc+1; % (52)
elements(mc).uihd_code = [5 3];
elements(mc).handle = [];
elements(mc).name = 'Mean time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2; callback_visuzeitreihe;';
elements(mc).tag = 'MI_Anzeige_ZR_MW';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Streuungszeitreihen
mc = mc+1; % (53)
elements(mc).uihd_code = [5 4];
elements(mc).handle = [];
elements(mc).name = 'Standard deviation time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=3; callback_visuzeitreihe;';
elements(mc).tag = 'MI_Anzeige_ZR_STD';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Mittelwerts- und Streuungszeitreihen
mc = mc+1; % (54)
elements(mc).uihd_code = [5 5];
elements(mc).handle = [];
elements(mc).name = 'Mean and standard deviation time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=4; callback_visuzeitreihe;';
elements(mc).tag = 'MI_Anzeige_ZR_MWSTD';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Umkodierungstabelle
mc = mc+1; % (55)
elements(mc).uihd_code = [5 6];
elements(mc).handle = [];
elements(mc).name = 'Recoding table';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'viewprot(''dekod.prot'');';
elements(mc).tag = 'MI_Umkodierung';
elements(mc).freischalt = {'~isempty(parameter.projekt) && isfield(parameter.projekt, ''umkodierung'') && parameter.projekt.umkodierung'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ANOVA, univariat
mc = mc+1; % (56)
elements(mc).uihd_code = [5 7];
elements(mc).handle = [];
elements(mc).name = 'ANOVA, univariate';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung = 3; callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_ANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Einzelmerkmale anzeigen
mc = mc+1; % (58)
elements(mc).uihd_code = [5 9];
elements(mc).handle = [];
elements(mc).name = 'Single features vs. single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visu_einzel_ausf;';
elements(mc).tag = 'MI_Anzeige_EM';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster schließen
mc = mc+1; % (59)
elements(mc).uihd_code = [5 10];
elements(mc).handle = [];
elements(mc).name = 'Close figures';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_close_windows;';
elements(mc).tag = 'MI_Schliessen';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Merkmalsrelevanzen anzeigen (Tabelle,sortiert)
mc = mc+1; % (60)
elements(mc).uihd_code = [5 11];
elements(mc).handle = [];
elements(mc).name = 'Show feature relevances (sorted table)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_anzeige_merkrele;';
elements(mc).tag = 'MI_Anzeige_EM_Relevanzen';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0', '~isempty(merk) || ~isempty(merk_archiv_regr)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Merkmalsrelevanzen anzeigen (Tabelle,unsortiert)
mc = mc+1; % (61)
elements(mc).uihd_code = [5 18];
elements(mc).handle = [];
elements(mc).name = 'Show a priori feature relevances (unsorted table)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;callback_anzeige_merkrele;';
elements(mc).tag = 'MI_Anzeige_EM_APriori';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0', '~isempty(interpret_merk)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Merkmalsrelevanzen anzeigen (Tabelle,unsortiert)
mc = mc+1; % (62)
elements(mc).uihd_code = [5 20];
elements(mc).handle = [];
elements(mc).name = 'Show feature relevances (unsorted table)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=0;callback_anzeige_merkrele;';
elements(mc).tag = 'MI_Anzeige_EM_Relevanzen_un';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0', '~isempty(merk) || ~isempty(merk_archiv_regr)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Einzelmerkmale gegen Ausgangsklassen
mc = mc+1; % (63)
elements(mc).uihd_code = [5 21];
elements(mc).handle = [];
elements(mc).name = 'Single features vs. output classes';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_ausgkl_einz_text;';
elements(mc).tag = 'MI_Anzeige_EM_Klasse';
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D-Histogramm, Wertediskrete EM gegen Ausgangsklassen
mc = mc+1; % (64)
elements(mc).uihd_code = [5 22];
elements(mc).handle = [];
elements(mc).name = 'Discrete single features (2D histogram)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;callback_2dhist;';
elements(mc).tag = 'MI_Anzeige_EM_Hist';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Informationstheoretische Maße
mc = mc+1; % (65)
elements(mc).uihd_code = [5 27];
elements(mc).handle = [];
elements(mc).name = 'Information theoretic measures';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung=5;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_Inform';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Projektreport
mc = mc+1; % (66)
elements(mc).uihd_code = [5 28];
elements(mc).handle = [];
elements(mc).name = 'Project report';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_projektreport;';
elements(mc).tag = 'MI_Projektreport';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% MANOVA, multivariat
mc = mc+1; % (67)
elements(mc).uihd_code = [5 29];
elements(mc).handle = [];
elements(mc).name = 'MANOVA, multivariate';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_bewertung=4;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_MANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnis
mc = mc+1; % (69)
elements(mc).uihd_code = [5 35];
elements(mc).handle = [];
elements(mc).name = 'Result';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'uicall = 8; anz_klasserg_neu;';
elements(mc).tag = 'MI_Anzeige_Klassi_Erg';
elements(mc).freischalt = {'exist(''pos'', ''var'') && ~isempty(pos)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D Klassifikation mit Kovarianzmatrizen
mc = mc+1; % (70)
elements(mc).uihd_code = [5 36];
elements(mc).handle = [];
elements(mc).name = '2D classification with covariance matrixes';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'uicall = 15; anz_klasserg_neu;';
elements(mc).tag = 'MI_Anzeige_Klassi_Kova';
elements(mc).freischalt = {'exist(''pos'', ''var'') && ~isempty(pos)', '~isempty(klass_single) && isfield(klass_single(1), ''bayes'') && length(klass_single)==1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR-Klassifikationsfehler über der Zeit
mc = mc+1; % (71)
elements(mc).uihd_code = [5 37];
elements(mc).handle = [];
elements(mc).name = 'Time series classification error vs. time';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'if exist(''fehl_proz'', ''var'') plot_zr_klassif_fehler(fehl_proz, parameter); end;';
elements(mc).tag = 'MI_Anzeige_ZRKlassi';
elements(mc).freischalt = {'exist(''fehl_proz'', ''var'') && ~isempty(fehl_proz)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D-Klassifikation mit SVMs
mc = mc+1; % (72)
elements(mc).uihd_code = [5 38];
elements(mc).handle = [];
elements(mc).name = '2D plot classifier with support vectors';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'uicall=41; anz_klasserg_neu;';
elements(mc).tag = 'MI_Anzeige_Klassi_SVM';
elements(mc).freischalt = {'exist(''pos'', ''var'') && ~isempty(pos)', '~isempty(klass_single) && isfield(klass_single(1), ''svm_system'')'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihen
mc = mc+1; % (73)
elements(mc).uihd_code = [5 39];
elements(mc).handle = [];
elements(mc).name = 'Time series (TS)';
elements(mc).tag = 'MI_Zeitreihen';
elements(mc).menu_items = {'MI_Anzeige_ZR_Orig', 'MI_Anzeige_ZR_MW', 'MI_Anzeige_ZR_STD', 'MI_Anzeige_ZR_MWSTD', -1, ...
      'MI_Anzeige_ZRScatterplot','MI_Anzeige_ZRPoincare2D','MI_Anzeige_ZRPoincare3D',-1, 'MI_Anzeige_ExtractedFeaturesPlugpar','MI_Anzeige_BodeFilterPlugin', -1, 'MI_Anzeige_ZRRelevanz', 'MI_Anzeige_ZRRelevanz_un'};
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Einzelmerkmale
mc = mc+1; % (74)
elements(mc).uihd_code = [5 40];
elements(mc).handle = [];
elements(mc).name = 'Single features';
elements(mc).tag = 'MI_Einzelmerkmale';
elements(mc).menu_items = {'MI_Anzeige_EM_Klasse', 'MI_Anzeige_EM', 'MI_Anzeige_SpecialSelection', 'MI_Anzeige_EM_Hist', 'MI_Wertediskrete_Merkmale', -1, ...
      'MI_Anzeige_MW_Streu', 'MI_Anzeige_EM_Min_Max', 'MI_Anzeige_EM_Med_Min_Max', 'MI_Anzeige_EM_Abs', 'MI_Anzeige_Gaitboxplot' -1, ...
      'MI_Anzeige_ZGF', 'MI_Anzeige_ZGF_Gesamthistogramm', 'MI_Anzeige_ZGF_Klassenhistogramm', 'MI_Anzeige_Entropie',-1, ...
      'MI_Anzeige_EM_Korr', 'MI_Anzeige_EM_Spear', 'MI_Anzeige_EM_Kendall', 'MI_Korrelationsvisualisierung', -1, ...
      'MI_Anzeige_EM_Relevanzen_Grafik','MI_Anzeige_EM_Relevanzen', 'MI_Anzeige_EM_Relevanzen_un', 'MI_Anzeige_EM_APriori',-1,'MI_Anzeige_AddToFeatArchive','MI_Anzeige_SaveFeatArchive'};
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klassifikation
mc = mc+1; % (77)
elements(mc).uihd_code = [5 43];
elements(mc).handle = [];
elements(mc).name = 'Classification';
elements(mc).tag = 'MI_Anzeige_Klassifikation';
elements(mc).menu_items = {'MI_Anzeige_Klassi_Erg', 'MI_Anzeige_Klassi_Kova', 'MI_Anzeige_Klassi_SVM', 'MI_Anzeige_Klassi_ROC', -1, ...
      'MI_Anzeige_ZRKlassi', 'MI_Anzeige_ZRMerkAuswahl'};
elements(mc).freischalt = {'~isempty(klass_single) && isfield(klass_single(1), ''klasse'') && isfield(klass_single(1).klasse,''angelernt'') || (exist(''fehl_proz'', ''var'') && ~isempty(fehl_proz)) || (exist(''klass_zr'', ''var'') && ~isempty(klass_zr))'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zugehörigkeitsfunktion
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 44];
elements(mc).handle = [];
elements(mc).name = 'Membership function';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_anzeige_zgf(d_org(ind_auswahl,:),code(ind_auswahl),var_bez,dorgbez,parameter,par,[],fuzzy_system,1,1);';
elements(mc).tag = 'MI_Anzeige_ZGF';
elements(mc).freischalt = {'1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zugehörigkeitsfunktion und Gesamthistogramm
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 45];
elements(mc).handle = [];
elements(mc).name = 'Membership function and total histogram';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_anzeige_zgf(d_org(ind_auswahl,:),code(ind_auswahl),var_bez,dorgbez,parameter,par,[],fuzzy_system,1,2);';
elements(mc).tag = 'MI_Anzeige_ZGF_Gesamthistogramm';
elements(mc).freischalt = {'1'};
% Zugehörigkeitsfunktion und Klassenhistogramm
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 46];
elements(mc).handle = [];
elements(mc).name = 'Membership function and class histogram';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_anzeige_zgf(d_org(ind_auswahl,:),code(ind_auswahl),var_bez,dorgbez,parameter,par,[],fuzzy_system,1,3);';
elements(mc).tag = 'MI_Anzeige_ZGF_Klassenhistogramm';
elements(mc).freischalt = {'1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zugehörigkeitsfunktion
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 47];
elements(mc).handle = [];
elements(mc).name = 'Membership function';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_anzeige_zgf(d(ind_auswahl,:),code(ind_auswahl),var_bez,[],parameter,par,klass_single.merkmalsextraktion,klass_single.fuzzy_system,2,1);';
elements(mc).tag = 'MI_Anzeige_ZGFAggr';
elements(mc).freischalt = {'exist(''klass_single'', ''var'') && ~isempty(klass_single) && isfield(klass_single, ''fuzzy_system'')'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zugehörigkeitsfunktion und Gesamthistogramm
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 48];
elements(mc).handle = [];
elements(mc).name = 'Membership function and total histogram';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_anzeige_zgf(d(ind_auswahl,:),code(ind_auswahl),var_bez,[],parameter,par,klass_single.merkmalsextraktion,klass_single.fuzzy_system,2,2);';
elements(mc).tag = 'MI_Anzeige_ZGFAggr_Gesamthistogramm';
elements(mc).freischalt = {'exist(''klass_single'', ''var'') && ~isempty(klass_single) && isfield(klass_single, ''fuzzy_system'')'};
% Zugehörigkeitsfunktion und Klassenhistogramm
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 49];
elements(mc).handle = [];
elements(mc).name = 'Membership function and class histogram';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_anzeige_zgf(d(ind_auswahl,:),code(ind_auswahl),var_bez,[],parameter,par,klass_single.merkmalsextraktion,klass_single.fuzzy_system,2,3);';
elements(mc).tag = 'MI_Anzeige_ZGFAggr_Klassenhistogramm';
elements(mc).freischalt = {'exist(''klass_single'', ''var'') && ~isempty(klass_single) && isfield(klass_single, ''fuzzy_system'')'};
% ROC
mc = mc+1; % 
elements(mc).uihd_code = [5 54];
elements(mc).handle = [];
elements(mc).name = 'ROC curve...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.roc';
elements(mc).callback_af = '[string,info,callback]=callback_roc(zgf_y_bez,par);';
elements(mc).tag = 'MI_Anzeige_Klassi_ROC';
elements(mc).freischalt = {'exist(''prz'', ''var'') && ~isempty(prz)'};
% Entropie
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 55];
elements(mc).handle = [];
elements(mc).name = 'Entropy';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visuent(d_org,code,dorgbez,bez_code,fuzzy_system,par,parameter);';
elements(mc).tag = 'MI_Anzeige_Entropie';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Merkmalsrelevanzen anzeigen (grafisch)
mc = mc+1; % (60)
elements(mc).uihd_code = [5 56];
elements(mc).handle = [];
elements(mc).name = 'Show feature relevances (graphic)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_vis_manova;';
elements(mc).tag = 'MI_Anzeige_EM_Relevanzen_Grafik';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0', '~isempty(merk_archiv) && ~isempty(merk)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Scatterplot Zeitreihen
mc = mc+1; % (57)
elements(mc).uihd_code = [5 57];
elements(mc).handle = [];
elements(mc).name = 'Scatterplot time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_timeseries_scatter;';
elements(mc).tag = 'MI_Anzeige_ZRScatterplot';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 58];
elements(mc).handle = [];
elements(mc).name = 'Linear regression coefficients (univariate)';
elements(mc).delete_pointerstatus = 0;
%elements(mc).callback = 'mode_callback_regression_en = 3; callback_regression_en;callback_save_feat;';
elements(mc).callback = 'mode_bewertung = 15; mode_univariat=1;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_RegrUni';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 59];
elements(mc).handle = [];
elements(mc).name = 'Linear regression coefficients (multivariate)';
elements(mc).delete_pointerstatus = 0;
%elements(mc).callback = 'mode_callback_regression_en = 5; callback_regression_en;callback_save_feat;';
elements(mc).callback = 'mode_bewertung = 16; mode_univariat=2;callback_feature_selection;';
elements(mc).tag = 'MI_EMAusw_RegrMulti';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 60];
elements(mc).handle = [];
elements(mc).name = 'Linear regression coefficients (univariate)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_callback_regression_en = 2; callback_regression_en;';
elements(mc).tag = 'MI_ZRAusw_RegrUni';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (Neu)
elements(mc).uihd_code = [5 61];
elements(mc).handle = [];
elements(mc).name = 'Linear regression coefficients (multivariate)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_callback_regression_en = 4; callback_regression_en;';
elements(mc).tag = 'MI_ZRAusw_RegrMulti';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Regression
mc = mc+1;
elements(mc).uihd_code = [5 62];
elements(mc).handle = [];
elements(mc).name = 'Regression';
elements(mc).tag = 'MI_DataMining_Regression';
elements(mc).menu_items = {'MI_Regression_Entwurf', 'MI_Regression_Anwendung', 'MI_Regression_EnAn'};
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = [];
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Entwurf
mc = mc+1;
elements(mc).uihd_code = [5 63];
elements(mc).handle = [];
elements(mc).name = 'Design';
elements(mc).tag = 'MI_Regression_Entwurf';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_callback_regression_en=1;callback_regression_en;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Anwendung
mc = mc+1;
elements(mc).uihd_code = [5 64];
elements(mc).handle = [];
elements(mc).name = 'Apply';
elements(mc).tag = 'MI_Regression_Anwendung';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_regression_an;';
elements(mc).freischalt = {'~isempty(parameter.projekt)', 'exist(''regr_single'', ''var'') && ~isempty(regr_single)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Entwurf und Anwendung
mc = mc+1;
elements(mc).uihd_code = [5 65];
elements(mc).handle = [];
elements(mc).name = 'Design and apply';
elements(mc).tag = 'MI_Regression_EnAn';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_callback_regression_en=1;callback_regression_en; callback_regression_an;regr_dist_eval.regr_plot_design = regr_plot;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
% 
mc = mc+1;
elements(mc).uihd_code = [5 66];
elements(mc).handle = [];
elements(mc).name = 'Output variable and estimation';
elements(mc).tag = 'MI_Anzeige_Regression_y_ydach';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_visu_regression=1; callback_visu_regression;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot)'};
%
mc = mc+1;
elements(mc).uihd_code = [5 67];
elements(mc).handle = [];
elements(mc).name = 'Input variable(s), output variable, and regression function (2D resp. 3D)';
elements(mc).tag = 'MI_Anzeige_Regression_x_y_2D3D';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_visu_regression=2; callback_visu_regression;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot) &&  (size(regr_plot.d,2) == 1 || size(regr_plot.d,2) == 2)'};
%
mc = mc+1;
elements(mc).uihd_code = [5 68];
elements(mc).handle = [];
elements(mc).name = 'Input variable(s), output variable, and regression function (top view 3D)';
elements(mc).tag = 'MI_Anzeige_Regression_x_y_Draufsicht';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_visu_regression=3; callback_visu_regression;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot) && (size(regr_plot.d,2) == 2)'};
%
mc = mc+1;
elements(mc).uihd_code = [5 88];
elements(mc).handle = [];
elements(mc).name = 'Generate macro for multidimensional visualization';
elements(mc).tag = 'MI_Erzeuge_Regression_Multi_Dimensional';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_multidimensional;';
%elements(mc).callback = 'mode_visu_regression=5; callback_visu_regression;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot)'};
%
mc = mc+1;
elements(mc).uihd_code = [5 89];
elements(mc).handle = [];
elements(mc).name = 'Apply macro for multidimensional visualization';
elements(mc).tag = 'MI_Anzeige_Regression_Multi_Dimensional';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_multidimensional_makro;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot)'};
%
mc = mc+1;
elements(mc).uihd_code = [5 90];
elements(mc).handle = [];
elements(mc).name = 'GUI for multidimensional visualization';
elements(mc).tag = 'MI_GUI_Regression_Multi_Dimensional';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'multiD_GUI;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot) '};
% 
mc = mc+1; % (95)
elements(mc).uihd_code = [5 91];
elements(mc).handle = [];
elements(mc).name = 'Clustergram';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_show_clustergram;';
elements(mc).tag = 'MI_Ansicht_Clustergramm';
elements(mc).freischalt = {'exist(''clustergram'',''file'')'};
% 
% 
% temporary switch off for Gait-CAD release 1.7
% mc = mc+1; % (95)
% elements(mc).uihd_code = [5 92];
% elements(mc).handle = [];
% elements(mc).name = 'Feature distances for regression';
% elements(mc).delete_pointerstatus = 0;
% elements(mc).callback = 'callback_distances_for_regression;';
% elements(mc).tag = 'MI_Anzeige_Regression_Distances';
% elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot) && ~isempty(regr_single)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [5 93];
elements(mc).handle = [];
elements(mc).name = 'Poincare plot time series (2D)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1; callback_poincare_plot;';
elements(mc).tag = 'MI_Anzeige_ZRPoincare2D';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [5 94];
elements(mc).handle = [];
elements(mc).name = 'Poincare plot time series (3D)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 2; callback_poincare_plot;';
elements(mc).tag = 'MI_Anzeige_ZRPoincare3D';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [5 95];
elements(mc).handle = [];
elements(mc).name = 'Add feature relevances to an archive';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'add_to_feature_archive;';
elements(mc).tag = 'MI_Anzeige_AddToFeatArchive';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0', '~isempty(merk) || ~isempty(merk_archiv_regr)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; 
elements(mc).uihd_code = [5 96];
elements(mc).handle = [];
elements(mc).name = 'Save archive with feature relevances';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'save_feature_archive_gaitcadproject;';
elements(mc).tag = 'MI_Anzeige_SaveFeatArchive';
elements(mc).freischalt = {'exist(''merk_archiv_all'',''var'')'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; %
elements(mc).uihd_code = [5 97];
elements(mc).handle = [];
elements(mc).name = 'Self Organizing Maps...';
elements(mc).tag = 'MI_Ansicht_SOM';
elements(mc).menu_items = {'MI_Ansicht_SOMPos','MI_Ansicht_SOMHits'};
elements(mc).freischalt = {'exist(''som_structure'',''var'') && ~isempty(som_structure)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; %
elements(mc).uihd_code = [5 98];
elements(mc).handle = [];
elements(mc).name = 'Positionen';
elements(mc).tag = 'MI_Ansicht_SOMPos';
elements(mc).callback = 'mode = 1; visu_som_results;';
elements(mc).freischalt = {'exist(''som_structure'',''var'') && ~isempty(som_structure)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; %
elements(mc).uihd_code = [5 99];
elements(mc).handle = [];
elements(mc).name = 'Hits';
elements(mc).tag = 'MI_Ansicht_SOMHits';
elements(mc).callback = 'mode = 2; visu_som_results;';
elements(mc).freischalt = {'exist(''som_structure'',''var'') && ~isempty(som_structure)'};

% 
mc = mc+1;
elements(mc).uihd_code = [5 100];
elements(mc).handle = [];
elements(mc).name = 'Protocol regression model application into file';
elements(mc).tag = 'MI_Anzeige_RegrStatFile';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_regression_statistics;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot)'};


mc = mc+1;
elements(mc).uihd_code = [5 69];
elements(mc).handle = [];
elements(mc).name = 'Regression';
elements(mc).tag = 'MI_Anzeige_Regression';
elements(mc).menu_items = {'MI_Anzeige_Regression_y_ydach', 'MI_Anzeige_Regression_y_Fehler','MI_Anzeige_Regression_x_y_2D3D',...
   'MI_Anzeige_Regression_x_y_Draufsicht','MI_Anzeige_RegrStatFile',-1,'MI_GUI_Regression_Multi_Dimensional','MI_Erzeuge_Regression_Multi_Dimensional','MI_Anzeige_Regression_Multi_Dimensional',-1,'MI_Anzeige_Koeff_Polynom','MI_Anzeige_MLP','MI_RSTools'};
%temporary switch off for Gait-CAD release 1.7   
%'MI_Anzeige_Regression_x_y_Draufsicht',-1,'MI_Anzeige_Regression_Distances',-1,'MI_GUI_Regression_Multi_Dimensional','MI_Erzeuge_Regression_Multi_Dimensional','MI_Anzeige_Regression_Multi_Dimensional',-1,'MI_Anzeige_Koeff_Polynom','MI_Anzeige_MLP','MI_RSTools'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%
mc = mc+1;
elements(mc).uihd_code = [5 70];
elements(mc).handle = [];
elements(mc).name = 'Output variable and error';
elements(mc).tag = 'MI_Anzeige_Regression_y_Fehler';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_visu_regression=4; callback_visu_regression;';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_plot)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; % (95)
elements(mc).uihd_code = [5 71];
elements(mc).handle = [];
elements(mc).name = 'Dendrogram (Statistic Toolbox)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visu_cluster_zgh(cluster_ergebnis,parameter.gui.anzeige,[],3,code);';
elements(mc).tag = 'MI_Ansicht_ClusterZGH_Dendro';
elements(mc).freischalt = {'~isempty(cluster_ergebnis) && isfield(cluster_ergebnis,''linkage'')'};
%
mc = mc+1;
elements(mc).uihd_code = [5 72];
elements(mc).handle = [];
elements(mc).name = 'Coefficients of the polynomial model';
elements(mc).tag = 'MI_Anzeige_Koeff_Polynom';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'show_polynom_results(regr_single,parameter,uihd);';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_single) && isfield(regr_single,''polynom'')'};
%
mc = mc+1;
elements(mc).uihd_code = [5 73];
elements(mc).handle = [];
elements(mc).name = 'Structure of the MLP net';
elements(mc).tag = 'MI_Anzeige_MLP';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'plot_mlp(regr_single.ann.net,1,regr_single.merkmalsextraktion.var_bez,regr_single.designed_regression.output_name);';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(regr_single) && isfield(regr_single,''ann'') && (regr_single.ann.net_param.type == 1 || regr_single.ann.net_param.type == 3) '};

% 
mc = mc+1; 
elements(mc).uihd_code = [5 74];
elements(mc).handle = [];
elements(mc).name = 'Manual class assignment via single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_callback =''callback_bt_refresh;'';callback_special_selection;';
elements(mc).tag = 'MI_Anzeige_SpecialSelection';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0 && length(parameter.gui.merkmale_und_klassen.ind_em)==2' };
% 
mc = mc+1; 
elements(mc).uihd_code = [5 75];
elements(mc).handle = [];
elements(mc).name = 'Boxplot (with Statistics Toolbox!)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_gaitboxplot;';
elements(mc).tag = 'MI_Anzeige_Gaitboxplot';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0' };
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 '};

mc = mc+1; 
elements(mc).uihd_code = [5 76];
elements(mc).handle = [];
elements(mc).name = 'Transformations vectors for feature extraction';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_show_feature_extraction;';
elements(mc).tag = 'MI_Anzeige_ExtractedFeaturesPlugpar';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0 && exist([parameter.projekt.pfad ''\'' parameter.projekt.datei ''.plugpar''],''file'')' };

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 77];
elements(mc).handle = [];
elements(mc).name = 'Pair-wise distances for dendrogram (STAT toolbox)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_show_dist;';
elements(mc).tag = 'MI_Ansicht_ClusterZGH_DendroDistPair';
elements(mc).freischalt = {'~isempty(cluster_ergebnis) && isfield(cluster_ergebnis,''pdist'')'};

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 78];
elements(mc).handle = [];
elements(mc).name = 'Multidimensional response surface (RSM, with Statistics Toolbox)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_rstools;';
elements(mc).tag = 'MI_RSTools';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0 && parameter.allgemein.isstat == 1 '};

mc = mc+1; 
elements(mc).uihd_code = [5 79];
elements(mc).handle = [];
elements(mc).name = 'Bode plot for filter in plugin';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'display_filter_bode(parameter,plugins);';
elements(mc).tag = 'MI_Anzeige_BodeFilterPlugin';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0' };


%%%%%%%%%%%%%%%%%%%%%%%%%
% Ansicht, Clustern
mc = mc+1; %
elements(mc).uihd_code = [5 80];
elements(mc).handle = [];
elements(mc).name = 'Data point distances';
elements(mc).tag = 'MI_Ansicht_PairDistDat';
elements(mc).menu_items = {'MI_Ansicht_PairDistDatCompInd','MI_Ansicht_PairDistDatCompManu','MI_Ansicht_PairDistDatCompNeighb','MI_Ansicht_PairDistSortVAT','MI_Ansicht_PairDistDatVect','MI_Ansicht_PairDistDatMat','MI_Ansicht_PairDistDatNeighb'};
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0' };

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 81];
elements(mc).handle = [];
elements(mc).name = 'Compute (selected data points)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mydist = compute_dt_distance(d_org,dorgbez,ind_auswahl,ind_auswahl,parameter,0);';
elements(mc).tag = 'MI_Ansicht_PairDistDatCompInd';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0' };


%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 82];
elements(mc).handle = [];
elements(mc).name = 'Compute (selected data points vs. manual selection)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mydist = compute_dt_distance(d_org,dorgbez,ind_auswahl,parameter.gui.allgemein.datentupel,parameter,0);';
elements(mc).tag = 'MI_Ansicht_PairDistDatCompManu';
elements(mc).freischalt ={'~isempty(par) && par.anz_einzel_merk > 0' };

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 83];
elements(mc).handle = [];
elements(mc).name = 'Compute (searching for neighbors of the first element of the manual selection)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mydist = compute_dt_distance(d_org,dorgbez,ind_auswahl,parameter.gui.allgemein.datentupel(1),parameter,length(ind_auswahl));';
elements(mc).tag = 'MI_Ansicht_PairDistDatCompNeighb';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0' };

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 84];
elements(mc).handle = [];
elements(mc).name = 'Show vector';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 2; callback_showmydatdist;';
elements(mc).tag = 'MI_Ansicht_PairDistDatVect';
elements(mc).freischalt = {'~isempty(mydist)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 85];
elements(mc).handle = [];
elements(mc).name = 'Show matrix';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1; callback_showmydatdist;';
elements(mc).tag = 'MI_Ansicht_PairDistDatMat';
elements(mc).freischalt = {'~isempty(mydist)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 86];
elements(mc).handle = [];
elements(mc).name = 'Show neighbors';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 3; callback_showmydatdist;';
elements(mc).tag = 'MI_Ansicht_PairDistDatNeighb';
elements(mc).freischalt = {'~isempty(mydist) && isfield(mydist,''list_neighbor'')'};

%%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; 
elements(mc).uihd_code = [5 87];
elements(mc).handle = [];
elements(mc).name = 'Sort (VAT algorithm)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_vat;';
elements(mc).tag = 'MI_Ansicht_PairDistSortVAT';
elements(mc).freischalt = {'~isempty(mydist)'};


%%%%%"-%%%%%%%%%%%%%%%%%%%
% Fuzzy-Modelle
mc = mc+1; % (90)
elements(mc).uihd_code = [7 1];
elements(mc).handle = [];
elements(mc).name = 'Fuzzy systems';
elements(mc).tag = 'MI_Fuzzy';
elements(mc).menu_items = {'MI_Fuzzy_Einzelregel', 'MI_Fuzzy_Basis', 'MI_Fuzzy_Loeschen', 'MI_Fuzzy_DesignMBF', -1, 'MI_FUZZY2KLASS','MI_KLASS2FUZZY','MI_REGR2FUZZY'};
elements(mc).freischalt = {'~isempty(par)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Regelbasis aus RUB-Datei importieren
mc = mc+1; % (91)
elements(mc).uihd_code = [7 2];
elements(mc).handle = [];
elements(mc).name = 'Load fuzzy system';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1; callback_load_fuzzy_system;';
elements(mc).tag = 'MI_Fuzzy_RUBImport';
elements(mc).freischalt = {'~isempty(parameter.projekt)  && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Regelbasis in RUB-Datei exportieren
mc = mc+1; % (92)
elements(mc).uihd_code = [7 3];
elements(mc).handle = [];
elements(mc).name = 'Save fuzzy system';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_save_fuzzy_system;';
elements(mc).tag = 'MI_Fuzzy_RUBExport';
elements(mc).freischalt = {'~isempty(fuzzy_system)  && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwerfen (Einzelregeln)
mc = mc+1; % (93)
elements(mc).uihd_code = [7 4];
elements(mc).handle = [];
elements(mc).name = 'Design (single rules)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;ruleaut_callback;';
elements(mc).tag = 'MI_Fuzzy_Einzelregel';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Regeln anzeigen (mit Variablenbezeichnung)
mc = mc+1; % (94)
elements(mc).uihd_code = [7 5];
elements(mc).handle = [];
elements(mc).name = 'Show rules (with variable names)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_fullnames = 1;callback_show_rules;';
elements(mc).tag = 'MI_Fuzzy_Anzeige_Bez';
elements(mc).freischalt = {'~isempty(fuzzy_system) && isfield(fuzzy_system,''rulebase'') && ~isempty(fuzzy_system.rulebase)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Regeln anzeigen (mit Variablennummer)
mc = mc+1; % (95)
elements(mc).uihd_code = [7 6];
elements(mc).handle = [];
elements(mc).name = 'Show rules (with variable numbers)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_fullnames = 2;callback_show_rules;';
elements(mc).tag = 'MI_Fuzzy_Anzeige_Nr';
elements(mc).freischalt = {'~isempty(fuzzy_system) && isfield(fuzzy_system,''rulebase'') && ~isempty(fuzzy_system.rulebase)'};

% Regelbasis aus RUB-Datei importieren
mc = mc+1; % (91)
elements(mc).uihd_code = [7 12];
elements(mc).handle = [];
elements(mc).name = 'Load fuzzy system (only membership functions)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 2; callback_load_fuzzy_system;';
elements(mc).tag = 'MI_Fuzzy_RUBImportMBF';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

% Regelbasis aus RUB-Datei importieren
mc = mc+1; % (91)
elements(mc).uihd_code = [7 13];
elements(mc).handle = [];
elements(mc).name = 'Design membership functions for single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_zgfen_allfeatures;';
elements(mc).tag = 'MI_Fuzzy_DesignMBF';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

% Fuzzy-System aus Klassifikator importieren
mc = mc+1;
elements(mc).uihd_code = [7 14];
elements(mc).handle = [];
elements(mc).name = 'Import fuzzy system from regression model';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 2;callback_klass_single2fuzzy;';
elements(mc).tag = 'MI_REGR2FUZZY';
elements(mc).freischalt = {'isfield(regr_single,''fuzzy_system'') && ~isempty(regr_single.fuzzy_system) && ~isempty(regr_single.fuzzy_system.rulebase)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Regeln anzeigen (mit Variablennummer)
mc = mc+1; %
elements(mc).uihd_code = [5 51];
elements(mc).handle = [];
elements(mc).name = 'Cluster memberships (sorted by clusters)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visu_cluster_zgh(cluster_ergebnis,parameter.gui.anzeige,[],1);';
elements(mc).tag = 'MI_Ansicht_ClusterZGH_sortiert';
elements(mc).freischalt = {'exist(''cluster_ergebnis'',''var'') && ~isempty(cluster_ergebnis)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Regeln anzeigen (mit Variablennummer)
mc = mc+1; % (95)
elements(mc).uihd_code = [5 52];
elements(mc).handle = [];
elements(mc).name = 'Cluster memberships (sorted by data points)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visu_cluster_zgh(cluster_ergebnis,parameter.gui.anzeige,cluster_ergebnis.ind_auswahl,2);';
elements(mc).tag = 'MI_Ansicht_ClusterZGH_unsortiert';
elements(mc).freischalt = {'exist(''cluster_ergebnis'',''var'') && ~isempty(cluster_ergebnis)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Regeln löschen
mc = mc+1; % (96)
elements(mc).uihd_code = [7 7];
elements(mc).handle = [];
elements(mc).name = 'Delete rules';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.rule';
elements(mc).callback_af = '[string,info,callback]=ruleauswahl_text(fuzzy_system,2);';
elements(mc).tag = 'MI_Fuzzy_Loeschen';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0', '~isempty(fuzzy_system) && isfield(fuzzy_system,''rulebase'') && ~isempty(fuzzy_system.rulebase)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Regeln anzeigen (mit Grafik)
mc = mc+1; % (97)
elements(mc).uihd_code = [7 8];
elements(mc).handle = [];
elements(mc).name = 'Show rules (figure)';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.rule';
elements(mc).callback_af = '[string,info,callback]=ruleauswahl_text(fuzzy_system,3);';
elements(mc).tag = 'MI_Fuzzy_Grafik';
elements(mc).freischalt = {'~isempty(fuzzy_system) && isfield(fuzzy_system,''rulebase'') && ~isempty(fuzzy_system.rulebase)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwerfen (Regelbasis)
mc = mc+1; % (99)
elements(mc).uihd_code = [7 10];
elements(mc).handle = [];
elements(mc).name = 'Design (rule base)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=3;ruleaut_callback;';
elements(mc).tag = 'MI_Fuzzy_Basis';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Makro Aufzeichnung beenden
mc = mc+1; % (102)
elements(mc).uihd_code = [8 3];
elements(mc).handle = [];
elements(mc).name = 'Stop macro record';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;callback_teachmodus;';
elements(mc).tag = 'MI_Makro_Beenden';
elements(mc).freischalt = {'exist(''teach_modus'', ''var'') && ~isempty(teach_modus)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Makro ausführen
mc = mc+1; % (103)
elements(mc).uihd_code = [8 4];
elements(mc).handle = [];
elements(mc).name = 'Play macro...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'makro_ausfuehren;';
elements(mc).tag = 'MI_Makro_Ausfuehren';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~exist(''teach_modus'', ''var'') || isempty(teach_modus) '};
%%x%%%%%%%%%%%%%%%%%%%%%%%
% Makro aufzeichnen (simultan ausführen)
mc = mc+1; % (104)
elements(mc).uihd_code = [8 5];
elements(mc).handle = [];
elements(mc).name = 'Record macro...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_teachmodus;';
elements(mc).tag = 'MI_Makro_Simultan';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~exist(''teach_modus'', ''var'') || isempty(teach_modus)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Makro aufzeichnen (simultan ausführen)
mc = mc+1; % (Neu)
elements(mc).uihd_code = [8 9];
elements(mc).handle = [];
elements(mc).name = 'Reset macro names';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_reset_makro;';
elements(mc).tag = 'MI_Makro_Loeschen';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~exist(''teach_modus'', ''var'') || isempty(teach_modus)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Umbenennen und Werte ändern...
mc = mc+1; % (105)
elements(mc).uihd_code = [8 6];
elements(mc).handle = [];
elements(mc).name = 'Rename...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.umbenennen';
elements(mc).callback_af = '[string,info,callback]=callback_umbenennen_teil1;';
elements(mc).callback = 'set(figure_handle(6,1),''userdata'',0);callback_umbenennen_teil2(uihd,dorgbez,var_bez,bez_code,zgf_bez,zgf_y_bez,figure_handle,[],par);';
elements(mc).tag = 'MI_Umbenennen';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Makro bearbeiten
mc = mc+1; % (106)
elements(mc).uihd_code = [8 7];
elements(mc).handle = [];
elements(mc).name = 'Edit macro...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1; callback_makro_bearbeiten;';
elements(mc).tag = 'MI_Makro_Bearb';
elements(mc).freischalt = {'1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige fehlende Daten
mc = mc+1; % (107)
elements(mc).uihd_code = [8 8];
elements(mc).handle = [];
elements(mc).name = 'Looking for missing data';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'plotmodus=1;callback_anzeige_fehldaten;';
elements(mc).tag = 'MI_Anzeige_FehlDaten';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Makro bearbeiten
mc = mc+1; % (106)
elements(mc).uihd_code = [8 10];
elements(mc).handle = [];
elements(mc).name = 'Edit Gait-CAD batch file ...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 3; callback_makro_bearbeiten;';
elements(mc).tag = 'MI_GaitbatchBearb';
elements(mc).freischalt = {'1'};

% Makro ausführen
mc = mc+1; % (103)
elements(mc).uihd_code = [8 11];
elements(mc).handle = [];
elements(mc).name = 'Play macro (debug mode)...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'makro_ausfuehren_mfile;';
elements(mc).tag = 'MI_Makro_ExecuteMakroMFile';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~exist(''teach_modus'', ''var'') || isempty(teach_modus) '};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Makro ausführen
mc = mc+1; % (103)
elements(mc).uihd_code = [8 12];
elements(mc).handle = [];
elements(mc).name = 'Execute M-file...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mfile_ausfuehren;';
elements(mc).tag = 'MI_MFile_Ausfuehren';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Makro bearbeiten
mc = mc+1; % (106)
elements(mc).uihd_code = [8 13];
elements(mc).handle = [];
elements(mc).name = 'Edit M-file...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode =2; callback_makro_bearbeiten;';
elements(mc).tag = 'MI_MFile_Bearb';
elements(mc).freischalt = {'1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Extras
mc = mc+1; % (109)
elements(mc).uihd_code = [9 1];
elements(mc).handle = [];
elements(mc).name = 'Extras';
elements(mc).tag = 'MI_Extras';
elements(mc).menu_items = {'MI_Makro_Ausfuehren', 'MI_Makro_ExecuteMakroMFile', -1, ...
      'MI_Makro_Simultan', 'MI_Makro_Beenden', 'MI_Makro_Bearb','MI_Makro_Loeschen', -1, 'MI_MFile_Ausfuehren','MI_MFile_Bearb',-1,'MI_GaitbatchBearb', -1,'MI_Extras_Autoreport', -1, ...
      'MI_Extras_Erweiterungen', 'MI_Extra_AddSearchPath',-1, 'MI_Extra_Parallel'};
elements(mc).freischalt = {'1'};


mc = mc+1; % (107)
elements(mc).uihd_code = [9 2];
elements(mc).handle = [];
elements(mc).name = 'Generate PDF project report (needs  Latex)';
elements(mc).menu_items = {'MI_Extras_AutoreportProjekt','MI_Extras_AutoreportPath'};
elements(mc).tag = 'MI_Extras_Autoreport';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

mc = mc+1; % (107)
elements(mc).uihd_code = [9 3];
elements(mc).handle = [];
elements(mc).name = 'for the current project';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_autoreport = 1;callback_autoreport;';
elements(mc).tag = 'MI_Extras_AutoreportProjekt';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

mc = mc+1; % (107)
elements(mc).uihd_code = [9 4];
elements(mc).handle = [];
elements(mc).name = 'for all projects in the directory';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_autoreport = 2;callback_autoreport;';
elements(mc).tag = 'MI_Extras_AutoreportPath';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Extras
mc = mc+1; % (109)
elements(mc).uihd_code = [9 5];
elements(mc).handle = [];
elements(mc).name = 'Matlab Parallel';
elements(mc).tag = 'MI_Extra_Parallel';
elements(mc).menu_items = {'MI_Extra_StartParallel','MI_Extra_StopParallel'};
elements(mc).freischalt = {'1'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (186)
elements(mc).uihd_code = [9 6];
elements(mc).handle = [];
elements(mc).name = 'Start';
elements(mc).tag = 'MI_Extra_StartParallel';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1;callback_matlab_parallel;';
elements(mc).freischalt = {'1'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (186)
elements(mc).uihd_code = [9 7];
elements(mc).handle = [];
elements(mc).name = 'Stop';
elements(mc).tag = 'MI_Extra_StopParallel';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 0;callback_matlab_parallel;';
elements(mc).freischalt = {'1'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Extras
mc = mc+1; % (109)
elements(mc).uihd_code = [9 8];
elements(mc).handle = [];
elements(mc).name = 'Search path for m-files and plugins';
elements(mc).tag = 'MI_Extra_AddSearchPath';
elements(mc).menu_items = {'MI_Extra_AddSearchPathPerm','MI_Extra_AddSearchPathTemp', 'MI_Extra_AddSearchPathResetPerm','MI_Extra_AddSearchPathResetTemp'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (186)
elements(mc).uihd_code = [9 9];
elements(mc).handle = [];
elements(mc).name = 'Permanent';
elements(mc).tag = 'MI_Extra_AddSearchPathPerm';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_searchpath = 1;callback_add_gaitcad_search_path;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (186)
elements(mc).uihd_code = [9 10];
elements(mc).handle = [];
elements(mc).name = 'Temporary for the session';
elements(mc).tag = 'MI_Extra_AddSearchPathTemp';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_searchpath = 2;callback_add_gaitcad_search_path;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (186)
elements(mc).uihd_code = [9 11];
elements(mc).handle = [];
elements(mc).name = 'Reset (permanent search path)';
elements(mc).tag = 'MI_Extra_AddSearchPathResetPerm';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_searchpath = 4;callback_add_gaitcad_search_path;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1; % (186)
elements(mc).uihd_code = [9 12];
elements(mc).handle = [];
elements(mc).name = 'Reset (only temporarly for the session)';
elements(mc).tag = 'MI_Extra_AddSearchPathResetTemp';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_searchpath = 3;callback_add_gaitcad_search_path;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Spektrogramm
mc = mc+1; % (110)
elements(mc).uihd_code = [13 2];
elements(mc).handle = [];
elements(mc).name = 'Spectrogram';
elements(mc).tag = 'MI_Spektrogramm';
elements(mc).menu_items = {'MI_Spektrogramm_BerAnz', 'MI_Spektrogramm_Ber', 'MI_Spektrogramm_Anz', -1, 'MI_Spektrogramm_PCA', -1, ...
      'MI_Spektrogramm_DSMitteln', 'MI_Spektrogramm_KlMitteln'};
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnen und Anzeigen
mc = mc+1; % (111)
elements(mc).uihd_code = [13 3];
elements(mc).handle = [];
elements(mc).name = 'Compute and show';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'spectyp=1;callback_spectogram;clear spectyp;';
elements(mc).tag = 'MI_Spektrogramm_BerAnz';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeigen
mc = mc+1; % (112)
elements(mc).uihd_code = [13 4];
elements(mc).handle = [];
elements(mc).name = 'Show';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'spectyp=0;callback_spectogram;clear spectyp;';
elements(mc).tag = 'MI_Spektrogramm_Anz';
elements(mc).freischalt = {'exist(''spect'', ''var'') && (~isempty(spect)) '};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Kreuz-/Autokorrelationsfunktion
mc = mc+1; % (113)
elements(mc).uihd_code = [13 5];
elements(mc).handle = [];
elements(mc).name = 'Separately for each data point';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.kreuzkorr';
elements(mc).callback_af = '[string,info,callback]=callback_kreuzkorr(var_bez, par,1);';
elements(mc).tag = 'MI_AKFKKF_Anzeige';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige FFT (ausgewählte Datentupel und ZR)
mc = mc+1; % (114)
elements(mc).uihd_code = [13 6];
elements(mc).handle = [];
elements(mc).name = 'Compute and show FFT  (selected data points and time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_anzeige_fft;';
elements(mc).tag = 'MI_FFT';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnen
mc = mc+1; % (115)
elements(mc).uihd_code = [13 7];
elements(mc).handle = [];
elements(mc).name = 'Compute';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'spectyp=2;callback_spectogram;clear spectyp;';
elements(mc).tag = 'MI_Spektrogramm_Ber';
%%%%%%%%%%%%%%%%%%%%%%%%%
% MANOVA, verwendet ZR->EM Samplepunkt
mc = mc+1; % (116)
elements(mc).uihd_code = [13 8];
elements(mc).handle = [];
elements(mc).name = 'MANOVA (with sample point for Time series -> Single feature)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;callback_merkmalsrelevanzen_zr;';
elements(mc).tag = 'MI_ZRAusw_MANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% ANOVA, verwendet ZR->EM Samplepunkt
mc = mc+1; % (117)
elements(mc).uihd_code = [13 9];
elements(mc).handle = [];
elements(mc).name = 'ANOVA (with sample point for Time series -> Single feature)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_merkmalsrelevanzen_zr;';
elements(mc).tag = 'MI_ZRAusw_ANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Merkmalsrelevanzen anzeigen (Tabelle,sortiert)
mc = mc+1; % (118)
elements(mc).uihd_code = [13 10];
elements(mc).handle = [];
elements(mc).name = 'Show all feature relevances (sorted table)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_anzeige_merkrele_zr;';
elements(mc).tag = 'MI_Anzeige_ZRRelevanz';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0', '~isempty(merk_zr) || ~isempty(merk_archiv_regr)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Merkmalsrelevanzen anzeigen (Tabelle,unsortiert)
mc = mc+1; % (119)
elements(mc).uihd_code = [13 11];
elements(mc).handle = [];
elements(mc).name = 'Show all feature relevances (unsorted table)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=0;callback_anzeige_merkrele_zr;';
elements(mc).tag = 'MI_Anzeige_ZRRelevanz_un';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0', '~isempty(merk_zr) || ~isempty(merk_archiv_regr)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Besten Samplepunkt bestimmen...
mc = mc+1; % (120)
elements(mc).uihd_code = [13 12];
elements(mc).handle = [];
elements(mc).name = 'Compute best sample points';
elements(mc).tag = 'MI_BestAbtast';
elements(mc).menu_items = {'MI_BestAbtast_ANOVA', 'MI_BestAbtast_MANOVA', 'MI_BestAbtast_ANOVA_Anz', 'MI_BestAbtast_MANOVA_Anz'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% über ANOVA  (ausgewählte Datentupel und ZR)
mc = mc+1; % (121)
elements(mc).uihd_code = [13 13];
elements(mc).handle = [];
elements(mc).name = 'using ANOVA  (selected data points and time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;plot_mode=0;callback_anzeige_zrmanova;';
elements(mc).tag = 'MI_BestAbtast_ANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% über MANOVA (ausgewählte Datentupel und ZR)
mc = mc+1; % (122)
elements(mc).uihd_code = [13 14];
elements(mc).handle = [];
elements(mc).name = 'using MANOVA (selected data points and time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;plot_mode=0;callback_anzeige_zrmanova;';
elements(mc).tag = 'MI_BestAbtast_MANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR-Klassifikation
mc = mc+1; % (123)
elements(mc).uihd_code = [13 15];
elements(mc).handle = [];
elements(mc).name = 'Time series classification (selected macros)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_eigene_makros = 1; cvmakro_mode = 1;callback_validation;';
elements(mc).tag = 'MI_CV_ZR';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% über ANOVA und anzeigen (ausgewählte Datentupel und ZR)
mc = mc+1; % (124)
elements(mc).uihd_code = [13 16];
elements(mc).handle = [];
elements(mc).name = 'using ANOVA and show results (selected data points and time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;plot_mode=1;callback_anzeige_zrmanova;';
elements(mc).tag = 'MI_BestAbtast_ANOVA_Anz';
%%%%%%%%%%%%%%%%%%%%%%%%%
% über MANOVA und anzeigen (ausgewählte Datentupel und ZR)
mc = mc+1; % (125)
elements(mc).uihd_code = [13 17];
elements(mc).handle = [];
elements(mc).name = 'using MANOVA and show results (selected data points and time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;plot_mode=1;callback_anzeige_zrmanova;';
elements(mc).tag = 'MI_BestAbtast_MANOVA_Anz';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Kurzzeit Kreuz-/Autokorrelationsfunktion (ausgewählte Datentupel und ZR)
mc = mc+1; % (126)
elements(mc).uihd_code = [13 18];
elements(mc).handle = [];
elements(mc).name = 'Separately for selected data points (Short-time analysis)';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.kreuzkorr';
elements(mc).callback_af = '[string,info,callback]=callback_kreuzkorr(var_bez, par,4);';
elements(mc).tag = 'MI_AKFKKF_Kurzzeit';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnen und Anzeigen (mitteln über ausgewählte Datentupel)
mc = mc+1; % (127)
elements(mc).uihd_code = [13 19];
elements(mc).handle = [];
elements(mc).name = 'Compute and show (mean for selected data points)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ds_mitteln=1; callback_mean_spektogram;clear ds_mitteln;';
elements(mc).tag = 'MI_Spektrogramm_DSMitteln';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0 && par.anz_ind_auswahl>1'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnen und Anzeigen (mitteln über ausgewählte Klassen)
mc = mc+1; % (128)
elements(mc).uihd_code = [13 20];
elements(mc).handle = [];
elements(mc).name = 'Compute and show (mean for selected class)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ds_mitteln=0; callback_mean_spektogram;clear ds_mitteln;';
elements(mc).tag = 'MI_Spektrogramm_KlMitteln';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0 && par.anz_ind_auswahl>1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Kreuz-/Autokorrelation
mc = mc+1; % (129)
elements(mc).uihd_code = [13 21];
elements(mc).handle = [];
elements(mc).name = 'Cross and Auto Correlation Functions';
elements(mc).tag = 'MI_KKFAKF';
elements(mc).menu_items = {'MI_AKFKKF_Anzeige', 'MI_AKFKKF_Kurzzeit', -1, ...
      'MI_KKFAKF_MWDaten', 'MI_KKFAKF_MWKlassen', -1, ...
      'MI_KKFAKF_ZR_MWDaten', 'MI_KKFAKF_ZR_MWKlassen', ...
   	-1, 'MI_KKF_Datentupel','MI_KKF_Datentupel_Mean', 'MI_KKoeff_Datentupel', 'MI_KKoeff_Datentupel_Mean'};
%elements(mc).menu_items = {'MI_AKFKKF_Anzeige', 'MI_AKFKKF_Kurzzeit', 'MI_KKFAKF_ZR_MWDaten', 'MI_KKFAKF_ZR_MWKlassen'};
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Korrelationskoeffizienten berechnen (ausgewählte ZR, Tau aus GUI, mitteln über ausgewählte Datentupel)
mc = mc+1; % (130)
elements(mc).uihd_code = [13 22];
elements(mc).handle = [];
elements(mc).name = 'Mean values of correlation coefficients (defined time shift)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ds_mitteln=1; callback_mean_corrcoef; clear ds_mitteln;';
elements(mc).tag = 'MI_KKFAKF_MWDaten';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Korrelationskoeffizienten berechnen (ausgewählte ZR, Tau aus GUI, mitteln über ausgewählte Klassen)
mc = mc+1; % (131)
elements(mc).uihd_code = [13 23];
elements(mc).handle = [];
elements(mc).name = 'Class mean values of correlation coefficients (with defined time shift)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ds_mitteln=0; callback_mean_corrcoef; clear ds_mitteln;';
elements(mc).tag = 'MI_KKFAKF_MWKlassen';
%%%%%%%%%%%%%%%%%%%%%%%%%
% AKF/KKF ausgewählte ZR berechnen (mitteln über Datentupel)
mc = mc+1; % (133)
elements(mc).uihd_code = [13 25];
elements(mc).handle = [];
elements(mc).name = 'Mean for selected data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.kreuzkorr';
elements(mc).callback_af = '[string,info,callback]=callback_kreuzkorr(var_bez, par,2);';
elements(mc).tag = 'MI_KKFAKF_ZR_MWDaten';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0 && par.anz_ind_auswahl>1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% AKF/KKF ausgewählte ZR berechnen (mitteln über Klassen)
mc = mc+1; % (134)
elements(mc).uihd_code = [13 26];
elements(mc).handle = [];
elements(mc).name = 'Mean for classes';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.kreuzkorr';
elements(mc).callback_af = '[string,info,callback]=callback_kreuzkorr(var_bez, par,3);';
elements(mc).tag = 'MI_KKFAKF_ZR_MWKlassen';
elements(mc).freischalt = {'exist(''code'',''var'') && length(unique(code(ind_auswahl)))>1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Gemittelte KKF anzeigen
%mc = mc+1; % (135)
%elements(mc).uihd_code = [13 27];
%elements(mc).handle = [];
%elements(mc).name = 'Show mean CCF';
%elements(mc).delete_pointerstatus = 0;
%elements(mc).callback = 'callback_anzeige_mean_xcorrzr;';
%elements(mc).tag = 'MI_AKFKKF_Anzeige_MWKKF';
%elements(mc).freischalt = {'exist(''mcxcoeff'', ''var'') && isfield(mcxcoeff, ''mcxcorr'')'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% EM-Klassifikation
mc = mc+1; % (136)
elements(mc).uihd_code = [13 28];
elements(mc).handle = [];
elements(mc).name = 'Classification of single features (selected macros)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_eigene_makros = 1; cvmakro_mode = 0;callback_validation;';
elements(mc).tag = 'MI_CV_EM';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Merkmalskarten (alle Zeitreihen, ausgewählte Datentupel)
mc = mc+1; % (137)
elements(mc).uihd_code = [13 29];
elements(mc).handle = [];
elements(mc).name = 'Feature maps (all time series, selected data points)';
elements(mc).tag = 'MI_MKarten';
elements(mc).menu_items = {'MI_MKarten_ANOVA', 'MI_MKarten_MANOVA', 'MI_MKarten_Klassi', 'MI_MKarten_MKlassi', 'MI_MKarten_Plot'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ANOVA-Werte
mc = mc+1; % (138)
elements(mc).uihd_code = [13 30];
elements(mc).handle = [];
elements(mc).name = 'ANOVA values';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'rk.zr_rel_mode = 1; rk.plot_only = 0; berechne_relevanzkarte;';
elements(mc).tag = 'MI_MKarten_ANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klassifikationsgüte des ZR-Klassifikators
mc = mc+1; % (139)
elements(mc).uihd_code = [13 31];
elements(mc).handle = [];
elements(mc).name = 'Classification accuracy of the time series classifier';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'rk.zr_rel_mode = 2; rk.multivariat_wrapper = 0; rk.plot_only = 0; berechne_relevanzkarte;';
elements(mc).tag = 'MI_MKarten_Klassi';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Multivariate Klassifikationsgüte des ZR-Klassifikators
mc = mc+1; % (139)
elements(mc).uihd_code = [13 40];
elements(mc).handle = [];
elements(mc).name = 'Multivariate classification accuracy (additional to the existing time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'rk.zr_rel_mode = 2; rk.multivariat_wrapper = 1; rk.plot_only = 0; berechne_relevanzkarte;';
elements(mc).tag = 'MI_MKarten_MKlassi';
%%%%%%%%%%%%%%%%%%%%%%%%%
% nur plotten
mc = mc+1; % (140)
elements(mc).uihd_code = [13 32];
elements(mc).handle = [];
elements(mc).name = 'Plot only';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'rk.zr_rel_mode = 2; rk.plot_only = 1; berechne_relevanzkarte;';
elements(mc).tag = 'MI_MKarten_Plot';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Morlet-Spektrogramm
mc = mc+1; % (141)
elements(mc).uihd_code = [13 33];
elements(mc).handle = [];
elements(mc).name = 'Morlet spectrogram';
elements(mc).tag = 'MI_MorletSpektro';
elements(mc).menu_items = {'MI_MorletSpektro_BerAnz', 'MI_MorletSpektro_MWKlassen', 'MI_MorletSpektro_Anz'};
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnen und Anzeigen (ausgewählte Datensätze und Zeitreihen)
mc = mc+1; % (142)
elements(mc).uihd_code = [13 34];
elements(mc).handle = [];
elements(mc).name = 'Compute and show (selected data points and time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ms_mode = 1; callback_morlet_spektrogramm;';
elements(mc).tag = 'MI_MorletSpektro_BerAnz';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnen und Anzeigen (mitteln über ausgewählte Klassen)
mc = mc+1; % (143)
elements(mc).uihd_code = [13 35];
elements(mc).handle = [];
elements(mc).name = 'Compute and show (mean for selected class)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ms_mode = 2; callback_morlet_spektrogramm;';
elements(mc).tag = 'MI_MorletSpektro_MWKlassen';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Nur anzeigen
mc = mc+1; % (144)
elements(mc).uihd_code = [13 36];
elements(mc).handle = [];
elements(mc).name = 'Plot only';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ms_mode = -1; callback_morlet_spektrogramm;';
elements(mc).tag = 'MI_MorletSpektro_Anz';
elements(mc).freischalt = {'exist(''morlet_plot_spect'', ''var'') && ~isempty(morlet_plot_spect)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% MANOVA-Werte (zusätzlich zu ausgewählten Zeitreihen
mc = mc+1; % (145)
elements(mc).uihd_code = [13 37];
elements(mc).handle = [];
elements(mc).name = 'MANOVA values (in addition to the pre-selected time series)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'rk.zr_rel_mode = 3; rk.plot_only = 0; berechne_relevanzkarte;';
elements(mc).tag = 'MI_MKarten_MANOVA';
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1; % (145)
elements(mc).uihd_code = [13 41];
elements(mc).handle = [];
elements(mc).name = 'Principal component analysis for spectrograms';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'spectrogram_pca;';
elements(mc).tag = 'MI_Spektrogramm_PCA';
elements(mc).freischalt = {'~isempty(spect)'};

%
mc = mc+1; 
elements(mc).uihd_code = [13 42];
elements(mc).handle = [];
elements(mc).name = 'FFT';
elements(mc).tag = 'MI_FFTAll';
elements(mc).menu_items = {'MI_FFT', 'MI_FFT_HitlistSortAmp','MI_FFT_HitlistSortFreq'};
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
elements(mc).freischalt_c = 1;
%
mc = mc+1;
elements(mc).uihd_code = [13 43];
elements(mc).handle = [];
elements(mc).name = 'Show dominant frequencies (sorted by amplitude)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1;callback_frequencyhitlist;';
elements(mc).tag = 'MI_FFT_HitlistSortAmp';
elements(mc).freischalt = {'~isempty(lastfft)'};
%
mc = mc+1;
elements(mc).uihd_code = [13 44];
elements(mc).handle = [];
elements(mc).name = 'Show dominant frequencies (sorted by frequency)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 0;callback_frequencyhitlist;';
elements(mc).tag = 'MI_FFT_HitlistSortFreq';
elements(mc).freischalt = {'~isempty(lastfft)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Data-Mining
mc = mc+1; % (146)
elements(mc).uihd_code = [14 1];
elements(mc).handle = [];
elements(mc).name = 'Data mining';
elements(mc).tag = 'MI_DataMining';
elements(mc).menu_items = {'MI_Bewertung_EM', 'MI_Bewertung_ZR', 'MI_Bewertung_Output',-1, ...
      'MI_EM_Klassifikation', 'MI_ZR_Klassifikation', -1, ...
      'MI_Hierar_Klassi', 'MI_Fuzzy', 'MI_Clustern', 'MI_Association_Rules','MI_Som', -1, 'MI_DataMining_Regression', -1, ...
      'MI_Validierung'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klassifizieren
mc = mc+1; % (147)
elements(mc).uihd_code = [14 6];
elements(mc).handle = [];
elements(mc).name = 'Classification';
elements(mc).tag = 'MI_EM_Klassifikation';
elements(mc).menu_items = {'MI_EMKlassi_En', 'MI_EMKlassi_An', 'MI_EMKlassi_EnAn'};
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Hierarchischer Bayes-Klassifikator
mc = mc+1; % (148)
elements(mc).uihd_code = [14 7];
elements(mc).handle = [];
elements(mc).name = 'Hierarchical Bayes classifier';
elements(mc).tag = 'MI_Hierar_Klassi';
elements(mc).menu_items = {'MI_EMHierchKlassi_En', 'MI_EMHierchKlassi_An', 'MI_EMHierchKlassi_EnAn'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwurf
mc = mc+1; % (149)
elements(mc).uihd_code = [14 8];
elements(mc).handle = [];
elements(mc).name = 'Design';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikator_en;';
elements(mc).tag = 'MI_EMKlassi_En';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anwendung
mc = mc+1; % (150)
elements(mc).uihd_code = [14 9];
elements(mc).handle = [];
elements(mc).name = 'Apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikator_an;';
elements(mc).tag = 'MI_EMKlassi_An';
elements(mc).freischalt = {'~isempty(klass_single) && isfield(klass_single, ''merkmalsextraktion'') && ~isempty(klass_single(1).merkmalsextraktion)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwurf und Anwendung
mc = mc+1; % (151)
elements(mc).uihd_code = [14 10];
elements(mc).handle = [];
elements(mc).name = 'Design and apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikator_en;callback_klassifikator_an;';
elements(mc).tag = 'MI_EMKlassi_EnAn';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwurf
mc = mc+1; % (152)
elements(mc).uihd_code = [14 12];
elements(mc).handle = [];
elements(mc).name = 'Design';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_klass_hierch;';
elements(mc).tag = 'MI_EMHierchKlassi_En';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anwendung
mc = mc+1; % (153)
elements(mc).uihd_code = [14 13];
elements(mc).handle = [];
elements(mc).name = 'Apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;callback_klass_hierch; ';
elements(mc).tag = 'MI_EMHierchKlassi_An';
elements(mc).freischalt = {'exist(''klass_hierch_bayes'', ''var'') && ~isempty(klass_hierch_bayes)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwurf und Anwendung
mc = mc+1; % (154)
elements(mc).uihd_code = [14 14];
elements(mc).handle = [];
elements(mc).name = 'Design and apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=3;callback_klass_hierch;';
elements(mc).tag = 'MI_EMHierchKlassi_EnAn';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR-Klassifikation
mc = mc+1; % (155)
elements(mc).uihd_code = [14 15];
elements(mc).handle = [];
elements(mc).name = 'Time series classification';
elements(mc).tag = 'MI_ZR_Klassifikation';
elements(mc).menu_items = {'MI_ZRKlassi_En', 'MI_ZRKlassi_An', 'MI_ZRKlassi_EnAn', 'MI_ZRKlassi_ZeitlAggr', 'MI_ZRKlassi_ZeitlAggrPlot'};
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwurf
mc = mc+1; % (156)
elements(mc).uihd_code = [14 16];
elements(mc).handle = [];
elements(mc).name = 'Design';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikation_zr_en;';
elements(mc).tag = 'MI_ZRKlassi_En';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anwendung
mc = mc+1; % (157)
elements(mc).uihd_code = [14 17];
elements(mc).handle = [];
elements(mc).name = 'Apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikation_zr_an;';
elements(mc).tag = 'MI_ZRKlassi_An';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0', '~isempty(klass_zr) && isfield(klass_zr, ''klass_single'') && ~isempty(klass_zr.klass_single)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwurf und Anwendung
mc = mc+1; % (158)
elements(mc).uihd_code = [14 18];
elements(mc).handle = [];
elements(mc).name = 'Design and apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassifikation_zr_en; callback_klassifikation_zr_an;';
elements(mc).tag = 'MI_ZRKlassi_EnAn';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitliche Aggregation
mc = mc+1; % (159)
elements(mc).uihd_code = [14 21];
elements(mc).handle = [];
elements(mc).name = 'Time aggregation';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'plot_mode = 0; callback_zeitl_aggregation;';
elements(mc).tag = 'MI_ZRKlassi_ZeitlAggr';
elements(mc).freischalt = {'(exist(''md_all'', ''var'') && ~isempty(md_all)) || (exist(''prz_all'', ''var'') && ~isempty(prz_all))'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitliche Aggregation und Ergebnis plotten
mc = mc+1; % (160)
elements(mc).uihd_code = [14 22];
elements(mc).handle = [];
elements(mc).name = 'Time aggregation with result plot';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'plot_mode = 1; callback_zeitl_aggregation;';
elements(mc).tag = 'MI_ZRKlassi_ZeitlAggrPlot';
elements(mc).freischalt = {'(exist(''md_all'', ''var'') && ~isempty(md_all)) || (exist(''prz_all'', ''var'') && ~isempty(prz_all))'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausreißerdetektion
mc = mc+1; % (161)
elements(mc).uihd_code = [14 23];
elements(mc).handle = [];
elements(mc).name = 'Outlier detection';
elements(mc).tag = 'MI_Ausreisser';
elements(mc).menu_items = {'MI_Ausreisser_DatenEn', -1, ...
      'MI_Ausreisser_En', 'MI_Ausreisser_An', 'MI_Ausreisser_EnAn', 'MI_Ausreisser_AlleKlassen'};
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwerfen (ausgewählte Datentupel, entworfener Datensatz)
mc = mc+1; % (162)
elements(mc).uihd_code = [14 24];
elements(mc).handle = [];
elements(mc).name = 'Design (selected data points, designed data set)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_ausreisser_en;';
elements(mc).tag = 'MI_Ausreisser_En';
elements(mc).freischalt = {'~isempty(klass_single) && isfield(klass_single, ''merkmalsextraktion'') && ~isempty(klass_single(1).merkmalsextraktion)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anwenden (ausgewählte Datentupel, entworfener Datensatz)
mc = mc+1; % (163)
elements(mc).uihd_code = [14 25];
elements(mc).handle = [];
elements(mc).name = 'Apply (selected data points, designed data set)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_ausreisser_an;';
elements(mc).tag = 'MI_Ausreisser_An';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0', '~isempty(klass_single) && isfield(klass_single, ''ausreisser'')'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Entwurf und Anwendung (ausgewählte Datentupel, entworfener Datensatz)
mc = mc+1; % (164)
elements(mc).uihd_code = [14 26];
elements(mc).handle = [];
elements(mc).name = 'Design and apply (selected data points, designed data set)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_ausreisser_en; callback_ausreisser_an;';
elements(mc).tag = 'MI_Ausreisser_EnAn';
elements(mc).freischalt = {'~isempty(klass_single) && isfield(klass_single, ''merkmalsextraktion'') && ~isempty(klass_single(1).merkmalsextraktion)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Bestimme alle Klassengrenzen (ausgewählte Datentupel, entworfener Datensatz)
mc = mc+1; % (165)
elements(mc).uihd_code = [14 27];
elements(mc).handle = [];
elements(mc).name = 'Compute class discriminant functions (selected data points, designed data set)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_klassengrenzen;';
elements(mc).tag = 'MI_Ausreisser_AlleKlassen';
elements(mc).freischalt = {'~isempty(klass_single) && isfield(klass_single, ''merkmalsextraktion'') && ~isempty(klass_single(1).merkmalsextraktion)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Datensatz entwerfen (ausgewählte Datentupel, Optionen aus Klassifikation)
mc = mc+1; % (166)
elements(mc).uihd_code = [14 28];
elements(mc).handle = [];
elements(mc).name = 'Design data set (selected data points, options from classification)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'erzeuge_datensatz;';
elements(mc).tag = 'MI_Ausreisser_DatenEn';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Clustern
mc = mc+1; % (167)
elements(mc).uihd_code = [14 29];
elements(mc).handle = [];
elements(mc).name = 'Clustering';
elements(mc).tag = 'MI_Clustern';
elements(mc).menu_items = {'MI_Cluster_Ber', 'MI_Cluster_matlab'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl und Bewertung von Einzelmerkmalen
mc = mc+1; % (168)
elements(mc).uihd_code = [14 30];
elements(mc).handle = [];
elements(mc).name = 'Selection and evaluation of single features';
elements(mc).tag = 'MI_Bewertung_EM';
elements(mc).menu_items = {'MI_EMAusw_ANOVA', 'MI_EMAusw_MANOVA', 'MI_EMAusw_Inform', -1, ...
      'MI_EMAusw_Klassifikation', 'MI_Merkausklassuni','MI_EMAusw_Fuzzy', 'MI_Merkausklassuniunsch','MI_EMAusw_ModFuzzy', 'MI_Merkausklassunigewunsch', -1, ...
      'MI_TTest', 'MI_Paired_TTest','MI_Wilcoxon', 'MI_NormTest','MI_ChiSquareCrosstabOutSingle', -1,...
      'MI_EMAusw_RegrUni','MI_EMAusw_RegrMulti','MI_EMAusw_RegKomplUni','MI_EMAusw_RegKomplMulti','MI_EMAusw_RegKomplUniMeanErr','MI_EMAusw_RegKomplMultiMeanErr'};
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Bewertung von Zeitreihen
mc = mc+1; % (169)
elements(mc).uihd_code = [14 32];
elements(mc).handle = [];
elements(mc).name = 'Evaluation of time series';
elements(mc).tag = 'MI_Bewertung_ZR';
elements(mc).menu_items = {'MI_ZRAusw_ANOVA', 'MI_ZRAusw_MANOVA', 'MI_BestAbtast', 'MI_MKarten', -1,...
      'MI_ZRAusw_RegrUni','MI_ZRAusw_RegrMulti'};
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
elements(mc).freischalt_c = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% Validierung
mc = mc+1; % (170)
elements(mc).uihd_code = [14 33];
elements(mc).handle = [];
elements(mc).name = 'Validation';
elements(mc).tag = 'MI_Validierung';
elements(mc).menu_items = {'MI_CV_EM_Standard', 'MI_CV_EM', 'MI_CV_EMHier_Standard', -1, 'MI_CV_ZR_Standard', 'MI_CV_ZR',-1,'MI_CV_RegrEM_Standard','MI_CV_RegrEM'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [5 32];
elements(mc).handle = [];
elements(mc).name = 'Window';
elements(mc).tag = 'MI_Fenster';
elements(mc).menu_items = {'MI_Schliessen','MI_Fenster_Anordnen','MI_Fenster_Log','MI_Fenster_TexReset','MI_Fenster_FontNameSize','MI_Fenster_Datei'};
elements(mc).callback = 'callback_fenster_liste;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Aggregierte Merkmale
mc = mc+1;
elements(mc).uihd_code = [1 33];
elements(mc).handle = [];
elements(mc).name = 'Aggregated features';
elements(mc).tag = 'MI_Ansicht_Aggregation';
elements(mc).menu_items = {'MI_Ansicht_Aggregation_HD', 'MI_Ansicht_Aggregation_LD',-1,...
      'MI_Anzeige_ZGFAggr', 'MI_Anzeige_ZGFAggr_Gesamthistogramm', 'MI_Anzeige_ZGFAggr_Klassenhistogramm'};
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0', '~isempty(klass_single) && isfield(klass_single,''merkmalsextraktion'') && ~isempty(klass_single(1).merkmalsextraktion.phi_aggregation)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% HD-Anzeige
mc = mc+1;
elements(mc).uihd_code = [2 40];
elements(mc).handle = [];
elements(mc).name = 'Eigenvectors and transformation vectors';
elements(mc).tag = 'MI_Ansicht_Aggregation_HD';
elements(mc).callback = 'mode=1;callback_plot_aggregation;clear mode;';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0', '~isempty(klass_single) && isfield(klass_single,''merkmalsextraktion'') && ~isempty(klass_single(1).merkmalsextraktion.phi_aggregation)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% LD-Anzeige
mc = mc+1;
elements(mc).uihd_code = [2 41];
elements(mc).handle = [];
elements(mc).name = 'Factor loadings (2D eigenvectors or transformation vectors)';
elements(mc).tag = 'MI_Ansicht_Aggregation_LD';
elements(mc).callback = 'mode=2; callback_plot_aggregation; clear mode;';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0', '~isempty(klass_single) && isfield(klass_single,''merkmalsextraktion'') && ~isempty(klass_single(1).merkmalsextraktion.phi_aggregation)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klassifikationsgüte (univariat)
mc = mc+1; %
elements(mc).uihd_code = [2 33];
elements(mc).handle = [];
elements(mc).name = 'Classification accuracy (univariate)';
elements(mc).tag = 'MI_Merkausklassuni';
elements(mc).callback = 'mode_bewertung=6;mode_univariat=1;callback_feature_selection;';
elements(mc).menu_items = [];
%%%%%%%%%%%%%%%%%%%%%%%%%
% Unscharfe Klassifikationsgüte (univariat)
mc = mc+1; %
elements(mc).uihd_code = [2 34];
elements(mc).handle = [];
elements(mc).name = 'Fuzzy classification accuracy (univariate)';
elements(mc).tag = 'MI_Merkausklassuniunsch';
elements(mc).callback = 'mode_bewertung=7;mode_univariat=1;callback_feature_selection;';
elements(mc).menu_items = [];
%%%%%%%%%%%%%%%%%%%%%%%%%
% Gewichtete unscharfe Klassifikationsgüte (univariat)
mc = mc+1; %
elements(mc).uihd_code = [2 35];
elements(mc).handle = [];
elements(mc).name = 'Weighted fuzzy classification accuracy (univariate)';
elements(mc).tag = 'MI_Merkausklassunigewunsch';
elements(mc).callback = 'mode_bewertung=8;mode_univariat=1;callback_feature_selection;';
elements(mc).menu_items = [];
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ansicht, Fuzzy-Modelle
mc = mc+1; %
elements(mc).uihd_code = [2 36];
elements(mc).handle = [];
elements(mc).name = 'Fuzzy systems';
elements(mc).tag = 'MI_Ansicht_Fuzzy';
elements(mc).menu_items = {'MI_Fuzzy_Anzeige_Bez', 'MI_Fuzzy_Anzeige_Nr', 'MI_Fuzzy_Grafik'};
elements(mc).freischalt = {'exist(''fuzzy_system'', ''var'') && ~isempty(fuzzy_system)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ansicht, Fuzzy-Modelle
mc = mc+1; %
elements(mc).uihd_code = [5 53];
elements(mc).handle = [];
elements(mc).name = 'Decision tree (LaTeX)';
elements(mc).tag = 'MI_Ansicht_Ebaum';
elements(mc).callback = 'protokoll_ebaum(klass_single.dec_tree.dec_tree,datei);';
elements(mc).freischalt = {'~isempty(klass_single) && isfield(klass_single,''dec_tree'')'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ansicht, Clustern
mc = mc+1; %
elements(mc).uihd_code = [5 50];
elements(mc).handle = [];
elements(mc).name = 'Clustering';
elements(mc).tag = 'MI_Ansicht_Clustern';
elements(mc).menu_items = {'MI_Ansicht_ClusterZGH_sortiert','MI_Ansicht_ClusterZGH_unsortiert','MI_Ansicht_ClusterZGH_Dendro','MI_Ansicht_ClusterZGH_DendroDistPair','MI_Ansicht_Clustergramm'};
elements(mc).freischalt = {'~isempty(cluster_ergebnis) || exist(''clustergram'',''file'')'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ansicht, Ausgangsgrößen
mc = mc+1; %
elements(mc).uihd_code = [2 37];
elements(mc).handle = [];
elements(mc).name = 'Output variables';
elements(mc).tag = 'MI_Ausgangsgroessen';
elements(mc).menu_items = {'MI_Qual_Ausgangsgroessen','MI_Ansicht_Ausgang2D',-1,'MI_Ansicht_OutputTerms'};
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ansicht, Ausgangsgrößen, Qualitative Ausgangsgrößen
mc = mc+1; %
elements(mc).uihd_code = [2 38];
elements(mc).handle = [];
elements(mc).name = 'Qualitative output variables';
elements(mc).tag = 'MI_Qual_Ausgangsgroessen';
elements(mc).callback = 'callback_qual_ausgangs;';
elements(mc).menu_items = [];
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ansicht, Einzelmerkmale, Korrelationsvisualisierung
mc = mc+1; %
elements(mc).uihd_code = [2 39];
elements(mc).handle = [];
elements(mc).name = 'Show correlation coefficients';
elements(mc).tag = 'MI_Korrelationsvisualisierung';
elements(mc).callback = 'callback_correlation_visualization;';
elements(mc).menu_items = [];

%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR-Klassifikation
mc = mc+1; % (123)
elements(mc).uihd_code = [13 38];
elements(mc).handle = [];
elements(mc).name = 'Time series classification';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_eigene_makros = 0; cvmakro_mode = 1;callback_validation;';
elements(mc).tag = 'MI_CV_ZR_Standard';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% EM-Klassifikation
mc = mc+1; % (136)
elements(mc).uihd_code = [13 39];
elements(mc).handle = [];
elements(mc).name = 'Classification of single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_eigene_makros = 0; cvmakro_mode = 0;callback_validation;';
elements(mc).tag = 'MI_CV_EM_Standard';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR-Klassifikation
mc = mc+1; % (123)
elements(mc).uihd_code = [13 45];
elements(mc).handle = [];
elements(mc).name = 'Regression';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_eigene_makros = 0; cvmakro_mode = 2;callback_validation;';
elements(mc).tag = 'MI_CV_RegrEM_Standard';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% EM-Klassifikation
mc = mc+1; % (136)
elements(mc).uihd_code = [13 46];
elements(mc).handle = [];
elements(mc).name = 'Regression (own macros)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_eigene_makros = 1; cvmakro_mode = 2;callback_validation;';
elements(mc).tag = 'MI_CV_RegrEM';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%

% EM-Klassifikation
mc = mc+1; % (136)
elements(mc).uihd_code = [13 47];
elements(mc).handle = [];
elements(mc).name = 'Hierarchical Bayes Classifier for single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_eigene_makros = 0; cvmakro_mode = 3;callback_validation;';
elements(mc).tag = 'MI_CV_EMHier_Standard';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

% Ansicht, Einzelmerkmale, Korrelationsvisualisierung
mc = mc+1; %
elements(mc).uihd_code = [2 47];
elements(mc).handle = [];
elements(mc).name = 'Discrete single features (2D histogram with output classes)';
elements(mc).tag = 'MI_Wertediskrete_Merkmale';
elements(mc).callback = 'mode=1;callback_2dhist;';
elements(mc).menu_items = [];
%%%%%%%%%%%%%%%%%%%%%%%%%
% Adobe-PDF Hilfedatei anzeigen
mc = mc+1; %
elements(mc).uihd_code = [2 42];
elements(mc).handle = [];
elements(mc).name = 'Show Adobe-PDF Help file';
elements(mc).tag = 'MI_Hilfe_PDF';
elements(mc).callback = 'gaitcad_hilfe(1, parameter);';
elements(mc).menu_items = [];
%%%%%%%%%%%%%%%%%%%%%%%%%
% Adobe-PDF Hilfedatei anzeigen
mc = mc+1; %
elements(mc).uihd_code = [2 43];
elements(mc).handle = [];
elements(mc).name = 'About Gait-CAD';
elements(mc).tag = 'MI_Hilfe_About';
elements(mc).callback = 'gaitcad_hilfe(2, parameter);';
elements(mc).menu_items = [];

%%%%%%%%%%%%%%%%%%%%%%%%%
% Teile Zeitreihen
mc = mc+1; % (36)
elements(mc).uihd_code = [2 44];
elements(mc).handle = [];
elements(mc).name = 'Separate time series with trigger events...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_teile_zeitreihe;';
elements(mc).tag = 'MI_Extraktion_Teile_ZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Kürze Zeitreihen
mc = mc+1; % (36)
elements(mc).uihd_code = [2 58];
elements(mc).handle = [];
elements(mc).name = 'Shorten time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).tag = 'MI_Kuerze_ZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
elements(mc).menu_items = {'MI_Kuerze_ZR_Fenster', 'MI_Kuerze_ZR_JederXte', 'MI_Kuerze_ZR_AufKuerzeste'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Kürze Zeitreihen: In Fenster
mc = mc+1; % (36)
elements(mc).uihd_code = [2 64];
elements(mc).handle = [];
elements(mc).name = 'Shortening by window methods';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1; callback_zeitreihe_kuerzen;';
elements(mc).tag = 'MI_Kuerze_ZR_Fenster';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Kürze Zeitreihen: Jeder x.te Abtastpunkt
mc = mc+1; % (36)
elements(mc).uihd_code = [2 65];
elements(mc).handle = [];
elements(mc).name = 'Use only each x-th sample point';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 2; callback_zeitreihe_kuerzen;';
elements(mc).tag = 'MI_Kuerze_ZR_JederXte';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Kürze Zeitreihen: Resampling auf kürzeste Zeitreihe
mc = mc+1; % (36)
elements(mc).uihd_code = [2 66];
elements(mc).handle = [];
elements(mc).name = 'Match time series lengths (use 0 and NaN as undefined values)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 3; callback_zeitreihe_kuerzen;';
elements(mc).tag = 'MI_Kuerze_ZR_AufKuerzeste';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Datentupel auswählen
mc = mc+1;
elements(mc).uihd_code = [2 67];
elements(mc).handle = [];
elements(mc).name = 'Data point from GUI';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_auswahl = parameter.gui.allgemein.datentupel'';auswahl.dat = []; aktparawin;';
elements(mc).tag = 'MI_Datenauswahl_GUI';

%%%%%%%%%%%%%%%%%%%%%%%%%
% Datentupel löschen ... (aus Datenauswahl)
mc = mc+1; % (33)
elements(mc).uihd_code = [2 68];
elements(mc).handle = [];
elements(mc).name = 'Unselected data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_ds = setdiff(1:par.anz_dat,ind_auswahl);callback_ds_loeschen;';
elements(mc).tag = 'MI_Loeschen_Datentupel_NonSel';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_dat > 1'};



%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Datentupel auswählen
mc = mc+1;
elements(mc).uihd_code = [2 48];
elements(mc).handle = [];
elements(mc).name = 'All data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'ind_auswahl = [1:par.anz_dat]''; auswahl.dat = []; aktparawin;';
elements(mc).tag = 'MI_Datenauswahl_Alle';

%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihe -> Einzelmerkmale
mc = mc+1;
elements(mc).uihd_code = [2 49];
elements(mc).handle = [];
elements(mc).name = 'Selected time series: Sample points -> Single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_zr2em;';
elements(mc).tag = 'MI_Trans_ZR2EM';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Einzelmerkmale -> Zeitreihe
mc = mc+1;
elements(mc).uihd_code = [2 51];
elements(mc).handle = [];
elements(mc).name = 'Selected single features -> Time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_ems2zr;';
elements(mc).tag = 'MI_Trans_EM2ZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk >= par.laenge_zeitreihe'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihe -> Einzelmerkmale
mc = mc+1;
elements(mc).uihd_code = [2 52];
elements(mc).handle = [];
elements(mc).name = 'All time series: Sample points -> Data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_abtast2tupel;';
elements(mc).tag = 'MI_Trans_ZR2EM_SampleTupel';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Einzelmerkmale -> Zeitreihe
mc = mc+1;
elements(mc).uihd_code = [2 54];
elements(mc).handle = [];
elements(mc).name = 'Choose application-specific extension packages...';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_verwalte_specials;';
elements(mc).tag = 'MI_Extras_Erweiterungen';
elements(mc).freischalt = {'~isempty(parameter.allgemein.aktiv)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Datentupel auswählen
mc = mc+1;
elements(mc).uihd_code = [2 55];
elements(mc).handle = [];
elements(mc).name = 'All time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'eval(get(findobj(''Tag'',''CE_Alle_ZR''),''callback''));';
elements(mc).tag = 'MI_Zeitreihen_Alle';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Datentupel auswählen
mc = mc+1;
elements(mc).uihd_code = [2 56];
elements(mc).handle = [];
elements(mc).name = 'All single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'eval(get(findobj(''Tag'',''CE_Alle_EM''),''callback''));';
elements(mc).tag = 'MI_Einzelmerkmal_Alle';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Geschätzte Ausgangsgröße -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 57];
elements(mc).handle = [];
elements(mc).name = 'Estimated output variable -> Single feature';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;callback_klasse2em;';
elements(mc).tag = 'MI_Trans_POS2EM';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(pos)'};
%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klasse -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 50];
elements(mc).handle = [];
elements(mc).name = 'Selected output variable -> Single feature';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_klasse2em;';
elements(mc).tag = 'MI_Trans_Klasse2EM';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};


%%%%%%%%%%%%%%%
% Geschätzte Ausgangsgröße -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 69];
elements(mc).handle = [];
elements(mc).name = 'Estimated output variable -> Output variable';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=3;callback_klasse2em;';
elements(mc).tag = 'MI_Trans_POS2Y';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(pos)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Klasse -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 70];
elements(mc).handle = [];
elements(mc).name = 'Selected output variable -> Single features (requires digits in term names)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=4;callback_klasse2em;';
elements(mc).tag = 'MI_Trans_Klasse2EMZ';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Klasse -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 71];
elements(mc).handle = [];
elements(mc).name = 'Selected time series -> Project-specific time scale';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_project_timescale;';
elements(mc).tag = 'MI_ZR2PTS';
elements(mc).freischalt = {'~isempty(parameter.projekt) && par.anz_merk > 0 '};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Klasse -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 72];
elements(mc).handle = [];
elements(mc).name = 'Term number of output variable';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_output_report;';
elements(mc).tag = 'MI_Ansicht_OutputTerms';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 73];
elements(mc).handle = [];
elements(mc).name = 'Selected output variable (with filenames) -> Multiple output variables (path components, file)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=1;callback_separate_fileterms;';
elements(mc).tag = 'MI_Trans_Class2PathDirclasses';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 74];
elements(mc).handle = [];
elements(mc).name = 'Selected output variable (with filenames) -> Multiple output variables (path components, file, extension)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=2;callback_separate_fileterms;';
elements(mc).tag = 'MI_Trans_Class2PathDirExclasses';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 75];
elements(mc).handle = [];
elements(mc).name = 'Deleted selected sample points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_k_loeschen;';
elements(mc).tag = 'MI_Loeschen_Kselect';
elements(mc).freischalt = {'~isempty(par) && par.laenge_zeitreihe > 1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 76];
elements(mc).handle = [];
elements(mc).name = 'Data points via most frequent terms';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_select_frequent_dt;';
elements(mc).tag = 'MI_Datenauswahl_FreqCode';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 77];
elements(mc).handle = [];
elements(mc).name = 'Deselect missing values for selected single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_nan_inf = ''SF'';deselect_missing_dp;';
elements(mc).tag = 'MI_Datenauswahl_NonInfEM';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 78];
elements(mc).handle = [];
elements(mc).name = 'Deselect missing values for selected time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_nan_inf = ''TS'';deselect_missing_dp;';
elements(mc).tag = 'MI_Datenauswahl_NonInfZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 79];
elements(mc).handle = [];
elements(mc).name = 'Resort linguistic terms (order from GUI)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_change_term_order;';
elements(mc).tag = 'MI_Trans_Term_Order';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 80];
elements(mc).handle = [];
elements(mc).name = 'Statistics for single features for linguistic terms of the selected output variable';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1;callback_append_class_features;';
elements(mc).tag = 'MI_ExtrStatSFTerm';
elements(mc).freischalt = {'~isempty(parameter.projekt) && par.anz_einzel_merk>0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
%
mc = mc+1; % (28)
elements(mc).uihd_code = [2 81];
elements(mc).handle = [];
elements(mc).name = 'Term statistics for output variable...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.ausgtermstat';
elements(mc).callback_af = 'info(1,:)=''Output variable'';string=poplist_popini(bez_code);callback=''mode = 2; callback_append_class_features;'';';
elements(mc).tag = 'MI_TermStat_Klasse';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_y > 1'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 82];
elements(mc).handle = [];
elements(mc).name = 'Random data points (defined percentage of selected data points)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_select_dt_randperc;';
elements(mc).tag = 'MI_Datenauswahl_PercDataPoints';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 84];
elements(mc).handle = [];
elements(mc).name = 'Single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_sort = 1 ; callback_sorting_names;';
elements(mc).tag = 'MI_Sortieren_SingleFeatures';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 1'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 85];
elements(mc).handle = [];
elements(mc).name = 'Time series (TS)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_sort = 2 ; callback_sorting_names;';
elements(mc).tag = 'MI_Sortieren_TimeSeries';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 1'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 86];
elements(mc).handle = [];
elements(mc).name = 'Output variables';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_sort = 3 ; callback_sorting_names;';
elements(mc).tag = 'MI_Sortieren_OutputVariables';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_y > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 87];
elements(mc).handle = [];
elements(mc).name = 'Images';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_sort = 4 ; callback_sorting_names;';
elements(mc).tag = 'MI_Sortieren_Images';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_image > 1'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 88];
elements(mc).handle = [];
elements(mc).name = 'Remove all variable names (end blanks)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_cleanup_names;';
elements(mc).tag = 'MI_Trans_CleanUpNames';


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 89];
elements(mc).handle = [];
elements(mc).name = 'Data points -> Single features and Single features -> Data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_features2datapoints;';
elements(mc).tag = 'MI_DT2Feat';

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 90];
elements(mc).handle = [];
elements(mc).name = 'Add output with identical term for all data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_class_all;';
elements(mc).tag = 'MI_AddClassAll';

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [2 91];
elements(mc).handle = [];
elements(mc).name = 'Time series  -> Data points';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_zr2dt;';
elements(mc).tag = 'MI_ZR2DT';

%%%%%%%%%%%%%%%%%%%%%%%%%
% Geschätzte Ausgangsgröße -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 92];
elements(mc).handle = [];
elements(mc).name = 'Estimated output variable (percental) -> Single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode=5;callback_klasse2em;';
elements(mc).tag = 'MI_Trans_PRZ2EM';
elements(mc).freischalt = {'~isempty(parameter.projekt) && ~isempty(prz)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Geschätzte Ausgangsgröße -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 93];
elements(mc).handle = [];
elements(mc).name = 'Data points via values of single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_value_selection;';
elements(mc).tag = 'MI_Datenauswahl_ValueSelection';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Geschätzte Ausgangsgröße -> Einzelmerkmal
mc = mc+1;
elements(mc).uihd_code = [2 94];
elements(mc).handle = [];
elements(mc).name = 'Non-existing terms of the output variable';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_cleanup_output_terms;';
elements(mc).tag = 'MI_Loeschen_NonExTerms';
elements(mc).freischalt = {'~isempty(par)'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Adobe-PDF Hilfedatei anzeigen
mc = mc+1; %
elements(mc).uihd_code = [2 59];
elements(mc).handle = [];
elements(mc).name = 'License information';
elements(mc).tag = 'MI_Hilfe_Lizenz';
elements(mc).callback = 'gaitcad_hilfe(3, parameter);';
elements(mc).menu_items = [];

%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihe -> Einzelmerkmale
mc = mc+1;
elements(mc).uihd_code = [2 60];
elements(mc).handle = [];
elements(mc).name = 'All single features: Data point  -> Time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_dsem2zr;';
elements(mc).tag = 'MI_Trans_DSEM2ZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihe -> Einzelmerkmale
mc = mc+1;
elements(mc).uihd_code = [2 61];
elements(mc).handle = [];
elements(mc).name = 'All single features: Data point -> Time series (class-wise)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_dsdtem2zr;';
elements(mc).tag = 'MI_Trans_DSDTEM2ZR';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D Histogramm Ausgangsgröße ...
mc = mc+1; % (28)
elements(mc).uihd_code = [2 63];
elements(mc).handle = [];
elements(mc).name = '2D histogram...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.output2d';
elements(mc).callback_af = '[string,info,callback]=callback_2dhist_output_gui(bez_code,code_alle(ind_auswahl,:),par);';
elements(mc).tag = 'MI_Ansicht_Ausgang2D';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_y > 1'};
%%%%%%%%%%%%%%%%%%%%%%%%%

% Fuzzy-System aus Klassifikator importieren
mc = mc+1;
elements(mc).uihd_code = [7 9];
elements(mc).handle = [];
elements(mc).name = 'Import fuzzy system from classifier';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode = 1;callback_klass_single2fuzzy;';
elements(mc).tag = 'MI_KLASS2FUZZY';
elements(mc).freischalt = {'isfield(klass_single,''fuzzy_system'') && ~isempty(fuzzy_system) && isfield(fuzzy_system,''rulebase'') && ~isempty(fuzzy_system.rulebase)'};


% Fuzzy-System aus Klassifikator importieren
mc = mc+1;
elements(mc).uihd_code = [7 11];
elements(mc).handle = [];
elements(mc).name = 'Export fuzzy system to classifier';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_fuzzy2klass_single;';
elements(mc).tag = 'MI_FUZZY2KLASS';
elements(mc).freischalt = {'isfield(klass_single,''fuzzy_system'') && ~isempty(fuzzy_system) && isfield(fuzzy_system,''rulebase'') && ~isempty(fuzzy_system.rulebase)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR-Klassifikationsfehler über der Zeit
mc = mc+1; % (71)
elements(mc).uihd_code = [5 41];
elements(mc).handle = [];
elements(mc).name = 'Used features of the time series classifier';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'plot_zr_merk(klass_zr, kp, parameter);';
elements(mc).tag = 'MI_Anzeige_ZRMerkAuswahl';
elements(mc).freischalt = {'exist(''klass_zr'', ''var'') && ~isempty(klass_zr) && isfield(klass_zr, ''klass_single'') && ~isempty(klass_zr.klass_single)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Erstellen der Triggerzeitreihe
mc = mc+1;
elements(mc).uihd_code = [14 34];
elements(mc).handle = [];
elements(mc).name = 'Generating trigger time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_trigger=1;callback_zr_navi;';
elements(mc).tag = 'MI_Erstelle_Trigger';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Bearbeitung der Triggerzeitreihe
mc = mc+1;
elements(mc).uihd_code = [14 35];
elements(mc).handle = [];
elements(mc).name = 'Edit trigger time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'mode_trigger=2;callback_zr_navi;';
elements(mc).tag = 'MI_Bearbeite_Trigger';
elements(mc).freischalt = {'~isempty(parameter.projekt)', '~isempty(par) && par.anz_merk > 0 '};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Kreuzkorrelationsfunktion, verschiedene Datentupel, gleiche Zeitreihen
mc = mc+1;
elements(mc).uihd_code = [14 36];
elements(mc).handle = [];
elements(mc).name = 'Correlation function for different data points and selected time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.kreuzkorr_dt';
elements(mc).callback_af = 'liste = datentupelliste(code_alle, zgf_y_bez); string(1:2, :) = [liste; liste]; info = strvcatnew(''Reference data point'', ''Comparison data point''); callback=''mode=0;callback_kreuzkorr_dt;'';';
elements(mc).tag = 'MI_KKF_Datentupel';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Kreuzkorrelationsfunktion, verschiedene Datentupel, gleiche Zeitreihen und mitteln
mc = mc+1;
elements(mc).uihd_code = [14 37];
elements(mc).handle = [];
elements(mc).name = 'Correlation function for different data points and selected time series (mean value)';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.kreuzkorr_dt';
elements(mc).callback_af = 'liste = datentupelliste(code_alle, zgf_y_bez); string(1:2, :) = [liste; liste]; info = strvcatnew(''Reference data point'', ''Comparison data point''); callback=''mode=1;callback_kreuzkorr_dt;'';';
elements(mc).tag = 'MI_KKF_Datentupel_Mean';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Kreuzkorrelationsfunktion, verschiedene Datentupel, gleiche Zeitreihen und mitteln
mc = mc+1;
elements(mc).uihd_code = [14 38];
elements(mc).handle = [];
elements(mc).name = 'Correlation coefficients selected data point and time series (pre-defined time-shift Tau)';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'plot_mode = 1; mode = 1; callback_korrkoeff_dt;';
elements(mc).tag = 'MI_KKoeff_Datentupel';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Kreuzkorrelationsfunktion, verschiedene Datentupel, gleiche Zeitreihen und mitteln
mc = mc+1;
elements(mc).uihd_code = [14 39];
elements(mc).handle = [];
elements(mc).name = 'Mean correlation coefficients over time series for selected data points and time series (defined time shift Tau)';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'plot_mode = 1; mode = 2; callback_korrkoeff_dt;';
elements(mc).tag = 'MI_KKoeff_Datentupel_Mean';
%%%%%%%%%%%%%%%%%%%%%%%%%
% Import von Zeitreihenbezeichnern aus Datei
mc = mc+1;
elements(mc).uihd_code = [14 40];
elements(mc).handle = [];
elements(mc).name = 'Import of time series names from file';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'mode = 1; callback_import_bezeichner;';
elements(mc).tag = 'MI_Datei_ImportiereZRBezeichner';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Import von Einzelmerkmalsbezeichnern aus Datei
mc = mc+1;
elements(mc).uihd_code = [14 41];
elements(mc).handle = [];
elements(mc).name = 'Import of single feature names from file';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'mode = 2; callback_import_bezeichner;';
elements(mc).tag = 'MI_Datei_ImportiereEMBezeichner';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Favoriten
mc = mc+1;
elements(mc).uihd_code = [14 42];
elements(mc).handle = [];
elements(mc).name = 'Favorites';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'favoriten_freischalt;';
elements(mc).menu_items = {'MI_Manuelle_Favoriten', 'MI_Loesche_Favoriten'};
elements(mc).tag = 'MI_Favoriten';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Bearbeite benutzerdefinierte Favoriten
mc = mc+1;
elements(mc).uihd_code = [14 43];
elements(mc).handle = [];
elements(mc).name = 'Edit user-defined favorites';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = '[parameter, favoriten_gui] = bearbeite_benutzerfavoriten(parameter);';
elements(mc).tag = 'MI_Manuelle_Favoriten';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Lösche alle Favoriten
mc = mc+1;
elements(mc).uihd_code = [14 44];
elements(mc).handle = [];
elements(mc).name = 'Delete all favorites';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'callback_loesche_favoriten;';
elements(mc).tag = 'MI_Loesche_Favoriten';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

mc = mc+1; % (169)
elements(mc).uihd_code = [14 45];
elements(mc).handle = [];
elements(mc).name = 'Evaluation of output variables';
elements(mc).tag = 'MI_Bewertung_Output';
elements(mc).menu_items = {'MI_ChiSquareCrosstabAllOut'};
elements(mc).freischalt = {'~isempty(par) && parameter.allgemein.isstat == 1 '};
elements(mc).freischalt_c = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%
% 
mc = mc+1;
elements(mc).uihd_code = [14 46];
elements(mc).handle = [];
elements(mc).name = 'Association analysis';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'callback_association_rules;';
elements(mc).tag = 'MI_Association_Rules';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

mc = mc+1;
elements(mc).uihd_code = [14 47];
elements(mc).handle = [];
elements(mc).name = 'Design';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'som_en;';
elements(mc).tag = 'MI_SomEn';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

mc = mc+1;
elements(mc).uihd_code = [14 48];
elements(mc).handle = [];
elements(mc).name = 'Apply';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = [];
elements(mc).callback = 'som_an;';
elements(mc).tag = 'MI_SomAn';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

% Klassifizieren
mc = mc+1; % (147)
elements(mc).uihd_code = [14 49];
elements(mc).handle = [];
elements(mc).name = 'Self Organizing Maps';
elements(mc).tag = 'MI_Som';
elements(mc).menu_items = {'MI_SomEn', 'MI_SomAn'};
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};


%%%%%%%%%%%%%%%%%%%%%%%%%
% Kategorie
mc = mc+1; % (78)
elements(mc).uihd_code = [6 16];
elements(mc).handle = [];
elements(mc).name = 'Category';
elements(mc).tag = 'MI_Kategorie';
elements(mc).menu_items = {'MI_Kategorie_EMAusw', 'MI_Kategorie_EMBer', ...
    'MI_AprioriBer', 'MI_AprioriEdit', -1,    ...
    'MI_Kategorie_ZRAusw', 'MI_Kategorie_ZRBer', -1, ...
    'MI_Suche_ZR_zu_EM'};
% EM Auswahl ...
mc = mc+1; % (79)
elements(mc).uihd_code = [6 2];
elements(mc).handle = [];
elements(mc).name = 'Select single features ...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.katem';
elements(mc).callback_af = '[string,info,callback]=kat_auswahl_text(zgf_em_bez, code_em,2);';
elements(mc).tag = 'MI_Kategorie_EMAusw';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0', 'exist(''code_em'', ''var'') && ~isempty(code_em)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% EM berechnen
mc = mc+1; % (80)
elements(mc).uihd_code = [6 3];
elements(mc).handle = [];
elements(mc).name = 'Compute single features';
elements(mc).delete_pointerstatus = 0;
%elements(mc).callback = '[code_em, zgf_em_bez]=kat_ber(dorgbez,zgf_y_bez,par,bez_code,0);[code_em, zgf_em_bez]=kat_aut_losch(code_em, zgf_em_bez);zgf_em_bez(1,1).istzeitreihe=0; enmat = enable_menus(parameter, ''enable'', {''MI_Kategorie_EMAusw'',''MI_Kategorie_EMPausch'',''MI_Kategorie_Liste'',''MI_AprioriBer''});';
elements(mc).callback = 'read_categories; [code_em,zgf_em_bez]=compute_categories(categories,dorgbez(1:par.anz_einzel_merk,:),''SF'');';
elements(mc).tag = 'MI_Kategorie_EMBer';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR Auswahl ...
mc = mc+1; % (81)
elements(mc).uihd_code = [6 4];
elements(mc).handle = [];
elements(mc).name = 'Selection of time series ...';
elements(mc).delete_pointerstatus = 0;
elements(mc).menu_af = 'auswahl.katzr';
elements(mc).callback_af = '[string,info,callback]=kat_auswahl_text(zgf_zr_bez, code_zr,1);';
elements(mc).tag = 'MI_Kategorie_ZRAusw';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0', 'exist(''code_zr'', ''var'') && ~isempty(code_zr)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% ZR berechnen
mc = mc+1; % (82)
elements(mc).uihd_code = [6 5];
elements(mc).handle = [];
elements(mc).name = 'Compute time series';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'read_categories; [code_zr,zgf_zr_bez]=compute_categories(categories,var_bez(1:par.anz_merk,:),''TS'');';
elements(mc).tag = 'MI_Kategorie_ZRBer';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};
% A-Priori-Relevanzen berechnen
mc = mc+1; % (85)
elements(mc).uihd_code = [6 10];
elements(mc).handle = [];
elements(mc).name = 'Compute a priori relevances';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'interpret_merk_rett=interpret_einzelmerk(zgf_em_bez,code_em,parameter_kategorien);mode=0;callback_apriori_edit; aktparawin;';
elements(mc).tag = 'MI_AprioriBer';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0', 'exist(''code_em'', ''var'') && ~isempty(code_em)'};
%%%%%%%%%%%%%%%%%%%%%%%%%
% Suche ZR zu ausgewählten EM
mc = mc+1; % (86)
elements(mc).uihd_code = [6 11];
elements(mc).handle = [];
elements(mc).name = 'Search time series related to the selected single features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_suche_zr_von_em;';
elements(mc).tag = 'MI_Suche_ZR_zu_EM';
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0 && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Relevanzen ausgewählter Merkmale...
mc = mc+1; % (87)
elements(mc).uihd_code = [6 12];
elements(mc).handle = [];
elements(mc).name = 'A priori relevances of selected features...';
elements(mc).tag = 'MI_AprioriEdit';
elements(mc).menu_items = {'MI_Apriori_AufEins', 'MI_Apriori_AufNull','MI_Apriori_AufBestimmtenWert'};
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% auf 1 setzen
mc = mc+1; % (88)
elements(mc).uihd_code = [6 13];
elements(mc).handle = [];
elements(mc).name = 'set to one';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'wert_apriori=1;mode=1;callback_apriori_edit;aktparawin;';
elements(mc).tag = 'MI_Apriori_AufEins';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% auf 0 setzen
mc = mc+1; % (89)
elements(mc).uihd_code = [6 14];
elements(mc).handle = [];
elements(mc).name = 'set to zero';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'wert_apriori=0;mode=1;callback_apriori_edit;aktparawin;';
elements(mc).tag = 'MI_Apriori_AufNull';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

% auf bestimmten Wert setzen
mc = mc+1; % (89)
elements(mc).uihd_code = [6 15];
elements(mc).handle = [];
elements(mc).name = 'set to a fix value (from GUI)';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'wert_apriori=parameter.gui.merkmale_und_klassen.bestimmter_wert;mode=1;callback_apriori_edit;aktparawin;';
elements(mc).tag = 'MI_Apriori_AufBestimmtenWert';
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 17];
elements(mc).handle = [];
elements(mc).name = 'Arrange figures';
elements(mc).tag = 'MI_Fenster_Anordnen';
elements(mc).menu_items = {'MI_Fenster_Anordnen_Horizontal','MI_Fenster_Anordnen_Vertikal','MI_Fenster_Anordnen_Kaskade','MI_Fenster_Anordnen_LetztesBild'};
elements(mc).callback = '';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 18];
elements(mc).handle = [];
elements(mc).name = 'Horizontal';
elements(mc).tag = 'MI_Fenster_Anordnen_Horizontal';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_arrange_all_figures(2);';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 19];
elements(mc).handle = [];
elements(mc).name = 'Vertical';
elements(mc).tag = 'MI_Fenster_Anordnen_Vertikal';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_arrange_all_figures(3);';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 20];
elements(mc).handle = [];
elements(mc).name = 'Cascade';
elements(mc).tag = 'MI_Fenster_Anordnen_Kaskade';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_arrange_all_figures(1);';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 21];
elements(mc).handle = [];
elements(mc).name = 'Plot all figures as images in files';
elements(mc).tag = 'MI_Fenster_Datei';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_plot_all_figures(parameter);';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 22];
elements(mc).handle = [];
elements(mc).name = 'Position of the current figure';
elements(mc).tag = 'MI_Fenster_Anordnen_LetztesBild';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_arrange_all_figures(4);';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 23];
elements(mc).handle = [];
elements(mc).name = 'Update font and font size in figures';
elements(mc).tag = 'MI_Fenster_FontNameSize';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_set_font_properties(parameter.gui.allgemein);';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 24];
elements(mc).handle = [];
elements(mc).name = 'Logarithmic scaling of current figures';
elements(mc).tag = 'MI_Fenster_Log';
elements(mc).menu_items = {'MI_Fenster_Logx','MI_Fenster_Logy','MI_Fenster_Logxy'};
elements(mc).callback = '';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 25];
elements(mc).handle = [];
elements(mc).name = 'only x axis';
elements(mc).tag = 'MI_Fenster_Logx';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'log_mode = ''log_x'';callback_last_figure_logarithmic;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 26];
elements(mc).handle = [];
elements(mc).name = 'only y-axis';
elements(mc).tag = 'MI_Fenster_Logy';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'log_mode = ''log_y'';callback_last_figure_logarithmic;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 27];
elements(mc).handle = [];
elements(mc).name = 'x- and y axis';
elements(mc).tag = 'MI_Fenster_Logxy';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'log_mode = ''log_xy'';callback_last_figure_logarithmic;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster
mc = mc+1; % (186)
elements(mc).uihd_code = [6 28];
elements(mc).handle = [];
elements(mc).name = 'Remove Latex codes in MATLAB figures';
elements(mc).tag = 'MI_Fenster_TexReset';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_window_texreset;';
elements(mc).freischalt = {'~isempty(parameter.projekt)'};
%%%%%%%%%%%%%%%%%%%%%%%%



parameter.gui.menu.elements = elements;
clear elements;
