% Script optionen_felder
%
% Dieses Skript definiert die zu generierenden Fenster mit den verschiedenen Kontroll-Elementen. Hier werden zunächst
% alle Felder eingetragen, einzelne können über optionen_subversion ausgeschaltet werden. Das Ausschalten wurde aus
% dieser Datei herausgehalten, da es einen Editor gibt, der diese Datei automatisiert generieren kann.
% 
% Die verschiedenen Fenster werden in einem Strukt gespeichert, das folgende Felder enthält:
% .name: Enthält den Namen des Fenster. Dieser wird im Auswahlmenü angezeigt
% .subfeld: Enthält die Kontroll-Elemente, die nur angezeigt werden sollen, wenn eine bestimmte
% Option gewählt wurde. Das Beispiel weiter unten macht die Sache klar.
% .subfeldbedingung: Dieses Feld enthält das Kontroll-Element, das für das Umschalten zwischen den subfeldern zuständig ist.
% .visible: enthält alle sichtbaren Kontroll-Elemente. Ist leer oder ein Strukt wie unten beschrieben.
% .in_auswahl: Gibt an, ob das Feld in der Auswahlliste angezeigt werden soll oder nicht. Bei nachträglich deaktivierten
% Feldern wird diese Variable auf 0 gesetzt.
% 
% Strukt visible: ist ein Array mit folgenden Elementen (also visible(i).i_control_elements, ...)
% .i_control_elements: Enthält den Index des Kontroll-Elements, das angezeigt wird.
% .pos: Enthält die Position des Kontroll-Elements in der GUI
% .bez_pos_rel: Wenn das Kontroll-Element einen Bezeichner enthält, wird hierdurch die relative Position des Bezeichners zum
% Kontroll-Element angegeben.
% 
% Beispiel:
% Das folgende Beispiel zeigt ein Feld mit drei Kontroll-Elementen und verschiedenen Subfeldern
% (mit den Nummern 14, 15, 18, 19, 20). Die Subfelder werden durch das Element 73 gesteuert und
% entsprechend der Wahl angezeigt. Die Subfelder selbst sind normale Felder, die wie dieses Beispiel
% definiert werden. Allerdings ist .in_auswahl auf 0 gesetzt, da es nicht in der Auswahlliste erscheinen soll.
% Das Element 97 besitzt keinen Bezeichner, daher ist die relative Position des Bezeichners leer.
% fc = 1;
% parameter.gui.optionen_felder(fc).name = 'Klassifikation';
% parameter.gui.optionen_felder(fc).subfeld = [14 15 18 19 20];
% parameter.gui.optionen_felder(fc).subfeldbedingung = 73;
% parameter.gui.optionen_felder(fc).visible = [];
% parameter.gui.optionen_felder(fc).in_auswahl = 1;
% % Element: Optionen
% parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 18;
% parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
% parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 0];
% %%%%%%%%%%%%%%%%%%
% % Element: Grafische Auswertung Klassifikationsergebnis
% parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 97;
% parameter.gui.optionen_felder(fc).visible(2).pos = [480 260];
% parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];
% %%%%%%%%%%%%%%%%%%
% % Element: Klassifikatoren
% parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 73;
% parameter.gui.optionen_felder(fc).visible(3).pos = [300 290];
% parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 0];
%
% The script optionen_felder is part of the MATLAB toolbox Gait-CAD. 
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

fc = 1;
parameter.gui.optionen_felder(fc).name = 'Project overview';
parameter.gui.optionen_felder(fc).tag = 'CEO_Projekt';
parameter.gui.optionen_felder(fc).subfeld = {'Subfeld: MenuHelp'};
parameter.gui.optionen_felder(fc).subfeldbedingung = 'CE_Anzeige_Menutips';
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Projektübersicht
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Projektuebersicht';
parameter.gui.optionen_felder(fc).visible(2).pos = [30 50];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Zeitreihen - Eigenschaften
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (2)
parameter.gui.optionen_felder(fc).name = 'Time series: General options';
parameter.gui.optionen_felder(fc).tag = 'CEO_ZRAllg';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Abtastfrequenz Zeitreihe [Hz]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_Abtastfreq';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 380];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: Abtastfrequenz Zeitreihe [Hz]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_Einheit_Abtastfreq';
parameter.gui.optionen_felder(fc).visible(end).pos = [450 380];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-90 -3];
%%%%%%%%%%%%%%%%%%
% Element: Auswahl Zeitreihe (ZR)
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_ZR';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 100];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 250];
%%%%%%%%%%%%%%%%%%
% Element: ZR-Auswahl Editfeld
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_EditAuswahl_ZR';
parameter.gui.optionen_felder(fc).visible(end).pos = [30 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: ALLE
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Alle_ZR';
parameter.gui.optionen_felder(fc).visible(end).pos = [30 325];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Auswahl Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_Ausgangsgroesse';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element: Auswahl Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_Segment_Start';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 70];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element: Auswahl Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_Segment_Ende';
parameter.gui.optionen_felder(fc).visible(end).pos = [425 70];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-40 -3];

% Element: Auswahl Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_Segment_Komplett';
parameter.gui.optionen_felder(fc).visible(end).pos = [30 70];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element: Auswahl Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_TimeSeriesForbidLength1';
parameter.gui.optionen_felder(fc).visible(end).pos = [535 70];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: -- Merkmalsextraktion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (3)
parameter.gui.optionen_felder(fc).name = 'Time series: Extraction - Parameters';
parameter.gui.optionen_felder(fc).tag = 'CEO_ZRExtrPara';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Parameter IIR-Filter
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Parameter_IIR';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: IIR-Parameter (aS, aL, aSigma)
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Parameter_aSaLaSigma';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: ZR->EM Samplepunkt
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_ZR_EM_Abtastpunkt';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Filterordnung (FIL)
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_ZR_Filterordnung';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Hoch-
parameter.gui.optionen_felder(fc).visible(6).i_control_elements = 'CE_ZR_Filtertyp_Hoch';
parameter.gui.optionen_felder(fc).visible(6).pos = [490 290];
parameter.gui.optionen_felder(fc).visible(6).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Tief-
parameter.gui.optionen_felder(fc).visible(7).i_control_elements = 'CE_ZR_Filtertyp_Tief';
parameter.gui.optionen_felder(fc).visible(7).pos = [540 290];
parameter.gui.optionen_felder(fc).visible(7).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Bandpass
parameter.gui.optionen_felder(fc).visible(8).i_control_elements = 'CE_ZR_Filtertyp_Band';
parameter.gui.optionen_felder(fc).visible(8).pos = [590 290];
parameter.gui.optionen_felder(fc).visible(8).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Frequenzen (FIL, Morlet-Spektrogramm)
parameter.gui.optionen_felder(fc).visible(9).i_control_elements = 'CE_ZR_Filterfreq';
parameter.gui.optionen_felder(fc).visible(9).pos = [300 260];
parameter.gui.optionen_felder(fc).visible(9).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Wavelet
parameter.gui.optionen_felder(fc).visible(10).i_control_elements = 'CE_Wavelets_Wavelet';
parameter.gui.optionen_felder(fc).visible(10).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(10).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Wavelets: Anzahl Level
parameter.gui.optionen_felder(fc).visible(11).i_control_elements = 'CE_Wavelets_Level';
parameter.gui.optionen_felder(fc).visible(11).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(11).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Matlab-Waveletdekomposition
parameter.gui.optionen_felder(fc).visible(12).i_control_elements = 'CE_Wavelets_MatlabWavelet';
parameter.gui.optionen_felder(fc).visible(12).pos = [490 210];
parameter.gui.optionen_felder(fc).visible(12).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Morlet-Wavelet: Frequenz
parameter.gui.optionen_felder(fc).visible(13).i_control_elements = 'CE_MorletWavelet_Freq';
parameter.gui.optionen_felder(fc).visible(13).pos = [300 150];
parameter.gui.optionen_felder(fc).visible(13).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Morlet-Wavelet: Eigenfrequenz
parameter.gui.optionen_felder(fc).visible(14).i_control_elements = 'CE_MorletWavelet_Eigenfreq';
parameter.gui.optionen_felder(fc).visible(14).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(14).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Kausales Morlet-Wavelet
parameter.gui.optionen_felder(fc).visible(15).i_control_elements = 'CE_MorletWavelet_Kausal';
parameter.gui.optionen_felder(fc).visible(15).pos = [490 150];
parameter.gui.optionen_felder(fc).visible(15).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Kürzen der Zeitreihe: Fensterbreite
parameter.gui.optionen_felder(fc).visible(16).i_control_elements = 'CE_Umwandeln_Fensterbreite';
parameter.gui.optionen_felder(fc).visible(16).pos = [300 80];
parameter.gui.optionen_felder(fc).visible(16).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Kürzen der Zeitreihe: Verfahren
parameter.gui.optionen_felder(fc).visible(17).i_control_elements = 'CE_Umwandeln_Verfahren';
parameter.gui.optionen_felder(fc).visible(17).pos = [300 50];
parameter.gui.optionen_felder(fc).visible(17).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Angleichen an
parameter.gui.optionen_felder(fc).visible(18).i_control_elements = 'CE_Umwandeln_NormierteLaenge';
parameter.gui.optionen_felder(fc).visible(18).pos = [300 20];
parameter.gui.optionen_felder(fc).visible(18).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_FilePlugins';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 450];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Plugin-Auswahl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (16)
parameter.gui.optionen_felder(fc).name = 'Plugin sequence';
parameter.gui.optionen_felder(fc).tag = 'CEO_ZRExtrPlug';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Bei Zeitreihenreduktion gleiche Transformationsmatrix für Datentupel verwenden
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_ZR_GlTrans';
parameter.gui.optionen_felder(fc).visible(2).pos = [20 30];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Auswahl Plugins
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Auswahl_Plugins';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 100];
%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_Edit_Auswahl_Plugins';
parameter.gui.optionen_felder(fc).visible(4).pos = [20 410];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Kombination von Plugins auf gewählte ZR ausführen. Nur Endergebnis bleibt erhalten. Eintragen in Editfeld => Reihenfolge wird beachtet
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_Plugins_Text';
parameter.gui.optionen_felder(fc).visible(5).pos = [20 340];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Plugins_Anzeige';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 470];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListAdd';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 440];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_PluginsList';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 150];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListUp';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 270];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListDown';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 240];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListDel';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 210];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListDelAll';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 180];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListLoad';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 150];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListSave';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 120];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_PluginsCommandLine';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Plugins_ParameterNumber';
parameter.gui.optionen_felder(fc).visible(end).pos = [600 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-35 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Plugins_IgnoreIntermediates';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 90 ];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-140 -3];

% performance log settings popupmenu
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Plugins_PerformanceLogSettings';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 60 ];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-240 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListUpdate';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 410];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListShowPar';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 90];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugListExec';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 60];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PlugShowTxt';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 380];

if isfield(parameter.gui,'image') && isfield(parameter.gui.image,'first_image_double')
   parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ImVid_FirstImageDouble';
   parameter.gui.optionen_felder(fc).visible(end).pos = [500 60];
end;

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_XPIWITPipelineCall';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 240];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Einzelmerkmale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (4)
parameter.gui.optionen_felder(fc).name = 'Single features';
parameter.gui.optionen_felder(fc).tag = 'CEO_EM';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: EM-Auswahl Editfeld
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_EditAuswahl_EM';
parameter.gui.optionen_felder(fc).visible(2).pos = [30 340];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Auswahl Einzelmerkmal (EM)
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Auswahl_EM';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 140];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 250];
%%%%%%%%%%%%%%%%%%
% Element: ALLE
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_Alle_EM';
parameter.gui.optionen_felder(fc).visible(4).pos = [30 365];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Anzahl Terme für EM->Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_EM_Ausgangs';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 100];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Alle Werte
parameter.gui.optionen_felder(fc).visible(6).i_control_elements = 'CE_EM_Ausgangs_Alle';
parameter.gui.optionen_felder(fc).visible(6).pos = [370 100];
parameter.gui.optionen_felder(fc).visible(6).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Auswahl Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(7).i_control_elements = 'CE_Auswahl_Ausgangsgroesse';
parameter.gui.optionen_felder(fc).visible(7).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(7).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: A-Priori-Merkmalsrelevanzen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_A_Priori';
parameter.gui.optionen_felder(fc).visible(end).pos = [35 70];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: A-Priori-Merkmalsrelevanzen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_A_Priori_Alpha';
parameter.gui.optionen_felder(fc).visible(end).pos = [615 70];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: A-Priori-Merkmalsrelevanzen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_A_Priori_Beta';
parameter.gui.optionen_felder(fc).visible(end).pos = [615 40];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: A-Priori-Merkmalsrelevanzen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_A_Priori_BestimmterWert';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 40];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Datenvorverarbeitung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (9)
parameter.gui.optionen_felder(fc).name = 'Data preprocessing';
parameter.gui.optionen_felder(fc).tag = 'CEO_Datenvor';
parameter.gui.optionen_felder(fc).subfeld = {'Subfeld: Verfahren one-class', 'Subfeld LEER', 'Subfeld: Verfahren dichtebasiert'};
parameter.gui.optionen_felder(fc).subfeldbedingung = 'CE_Ausreisser_Verfahren';
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Schwelle für Ausreißer
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Ausreisser_Schwelle';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Verfahren
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Ausreisser_Verfahren';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Ergebnis in Klasse speichern
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_Ausreisser_InKlasse';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Ausreißer manuell markieren
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_Ausreisser_Manuell';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Schwellwert für ZR löschen [Proz. fehlende Daten]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Nullzr_Schwellwert';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 90];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Select_MinDtClass';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_DatapointValueSelection';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 60];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Visualisierung - EM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (10)
parameter.gui.optionen_felder(fc).name = 'View: Single features';
parameter.gui.optionen_felder(fc).tag = 'CEO_Ans_EM';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: EM Anzeige x-y-Tausch
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_XYTausch';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element: EM Anzeige x-y-Tausch
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZR_ShowInverseClassOrder';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element: EM Anzeige x-y-Tausch
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_RelSelFeat';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element: Farb/Style Wahl
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_FarbStyle';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Anzeige Nr. Datentupel
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_NrDatentupel';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Anzeige Grafiken
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Grafiken';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 450];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Anzeige Legende
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Legende';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 240];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Termnames';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_UsrDefCol';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_UsrDefSym';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_DifferentClass';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_VisuNoise';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 210];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_VisuNoiseValue';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Hist';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_HistAuto';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 180];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_FeatureNumber';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 150];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_FeatureNumberCheck';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 150];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_ListSorting';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_GermanNumbers';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 120];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Output4EM';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 90];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AllgFontName';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 60];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AllgFontSize';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 60];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-130 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MarkerSize';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 30];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: -- ZR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (11)
parameter.gui.optionen_felder(fc).name = 'View: Time series';
parameter.gui.optionen_felder(fc).tag = 'CEO_Ans_ZR';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Prozentuale Anzeige (Abtastfreq. wird ignoriert)
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_ZRAnzeige_Proz';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Abtastpunkte
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZRAnzeige_Abtastpkt';
parameter.gui.optionen_felder(fc).visible(end).pos = [280 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Zeit [s]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZRAnzeige_Zeit';
parameter.gui.optionen_felder(fc).visible(end).pos = [380 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Zeit [s]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZRAnzeige_Projekt';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Anzeige Grafiken
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Grafiken';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 450];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Linienstärke
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Linienstaerke';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Zeitreihen in Subplots zeichnen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_Subplots';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_ZRImagePlot';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Farb/Style Wahl
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_FarbStyle';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Anzeige Legende
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Legende';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Anzeige Nr. Datentupel
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_NrDatentupel';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
% Element: 
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_PoincareLine';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element: Anzeige Normdaten
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Normdaten';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 240];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Normdaten in den Vordergrund
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Normdaten_Vordergrund';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZRAnzeige_Log';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: Farb/Style Wahl
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_UsrDefCol';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: Farb/Style Wahl
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_UsrDefSym';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_ZRImagePlotClassSort';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AllgFontName';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 150];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AllgFontSize';
parameter.gui.optionen_felder(fc).visible(end).pos = [580 150];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-130 -3];


%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: -- Spektrogramme, FFT, KKF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (12)
parameter.gui.optionen_felder(fc).name = 'View: Spectrogram, FFT, CCF';
parameter.gui.optionen_felder(fc).tag = 'CEO_Ans_SFK';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Grenzen für Farbachse
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Anzeige_Farbachse';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 60];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Colormap
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Anzeige_Colormap';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 90];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Kennlinie für Farbeinteilung
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_Kennlinie';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 200];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Potenz für Exp (Exp.-Kennlinie)
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Kennlinie_Exp';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 170];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Grad der Wurzel (Wurzelkennlinie)
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Kennline_Sqrt';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Colorbar anzeigen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Colorbar';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 230];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Automatisch (empfohlen für Wurzel- oder Exp-Kennlinie!)
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZRAnzeige_CAxis';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 60];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Reduktion Abtastpunkte Morlet-Spektrogramm
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_RedAbtast';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: FFT über Periodendauer plotten (sonst über Frequenz)
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_FFTPeriode';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 30];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Fenstergröße [Abtastpkt.]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Zeitreihen_Fenstergroesse';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 470];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element: Fenstergröße [Abtastpkt.]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ScaleOptCrossCorr';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 440];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Tau [SP]
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZR_Tau';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 410];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Morlet-Spektrogramm: Frequenz-Schrittweite
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MorletSpekt_FreqSchritt';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 380];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Frequenzen (FIL, Morlet-Spektrogramm)
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZR_Filterfreq';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 350];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Morlet-Spektrogramm relativ zu Baseline
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MorletSpekt_Relativ';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 320];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Abtastpunkte Baseline
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MorletSpekt_Baseline';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 320];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Phasengang anzeigen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Phasengang';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 230];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
% Element: Spektrogramm PCA
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_PCA_Spektrogramm';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 260];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_FFT_AnzFreq';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 30];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZR_ParKorrWorkspace';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 440];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ZR_ShowFigKorr';
parameter.gui.optionen_felder(fc).visible(end).pos = [480 410];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: -- Klassifikation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (13)
parameter.gui.optionen_felder(fc).name = 'View: Classification and regression';
parameter.gui.optionen_felder(fc).tag = 'CEO_Ans_Kl';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Klassenanzeige Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Anzeige_Klassenanzeige';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Trennflächen anzeigen
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Anzeige_Trennflaechen';
parameter.gui.optionen_felder(fc).visible(2).pos = [580 420];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Gitterpunkte für Trennfläche
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_Anzeige_Gitterpunkte';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Visualisierung Ausreißerdetektion
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_Anzeige_Ausreisser';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 330];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_DifferentClass';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Trennflächen anzeigen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_RegrInputNormAggr';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];



%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Klassifikation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (5)
parameter.gui.optionen_felder(fc).name = 'Data mining: Classification of single features';
parameter.gui.optionen_felder(fc).tag = 'CEO_DM_Grund';
parameter.gui.optionen_felder(fc).subfeld = {'Subfeld LEER', 'Subfeld LEER', 'Subfeld: Aggregation optimierte Diskriminanz'};
parameter.gui.optionen_felder(fc).subfeldbedingung = 'CE_Klassifikation_Merkmalsaggregation';
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Anzahl aggregierter Merkmale
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Anzahl_Aggregiert';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 200];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Merkmalsauswahl
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Klassifikation_Merkmalsauswahl';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Merkmalsaggregation
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_Klassifikation_Merkmalsaggregation';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 230];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: aktueller Klassifikator
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_Klassifikation_Klassifikator';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Normierung aggregierte Merkmale
parameter.gui.optionen_felder(fc).visible(6).i_control_elements = 'CE_Normierung_Aggregiert';
parameter.gui.optionen_felder(fc).visible(6).pos = [300 170];
parameter.gui.optionen_felder(fc).visible(6).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Mehrklassenprobleme
parameter.gui.optionen_felder(fc).visible(7).i_control_elements = 'CE_Klassifikation_Mehrklassen';
parameter.gui.optionen_felder(fc).visible(7).pos = [300 90];
parameter.gui.optionen_felder(fc).visible(7).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Normierung Merkmale
parameter.gui.optionen_felder(fc).visible(8).i_control_elements = 'CE_Normierung_Merkmale';
parameter.gui.optionen_felder(fc).visible(8).pos = [300 310];
parameter.gui.optionen_felder(fc).visible(8).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Anzahl auszuwählender Merkmale
parameter.gui.optionen_felder(fc).visible(9).i_control_elements = 'CE_Anzahl_Merkmale';
parameter.gui.optionen_felder(fc).visible(9).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(9).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Konfusionsmatrix in Datei speichern
parameter.gui.optionen_felder(fc).visible(10).i_control_elements = 'CE_Konfusion_Datei';
parameter.gui.optionen_felder(fc).visible(10).pos = [20 40];
parameter.gui.optionen_felder(fc).visible(10).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Grafische Auswertung Klassifikationsergebnis
parameter.gui.optionen_felder(fc).visible(11).i_control_elements = 'CE_Anzeige_KlassiErg';
parameter.gui.optionen_felder(fc).visible(11).pos = [300 40];
parameter.gui.optionen_felder(fc).visible(11).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Preselection Merkmale
parameter.gui.optionen_felder(fc).visible(12).i_control_elements = 'CE_Klassifikation_Preselection';
parameter.gui.optionen_felder(fc).visible(12).pos = [300 280];
parameter.gui.optionen_felder(fc).visible(12).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Rückstufung korrelierter Merkmale
parameter.gui.optionen_felder(fc).visible(14).i_control_elements = 'CE_Klassifikation_Rueckstufung';
parameter.gui.optionen_felder(fc).visible(14).pos = [460 280];
parameter.gui.optionen_felder(fc).visible(14).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Auswahl Ausgangsgröße
parameter.gui.optionen_felder(fc).visible(13).i_control_elements = 'CE_Auswahl_Ausgangsgroesse';
parameter.gui.optionen_felder(fc).visible(13).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(13).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: ZR-Klassifikation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (7)
parameter.gui.optionen_felder(fc).name = 'Data mining: Classification of time series';
parameter.gui.optionen_felder(fc).tag = 'CEO_DM_ZRKlass';
parameter.gui.optionen_felder(fc).subfeld = {'Subfeld LEER', 'Subfeld LEER', 'Subfeld LEER', 'Subfeld LEER', ...
   'Subfeld: ZR-Typ K5', 'Subfeld: ZR-Typ TSK-Fuzzy'};
parameter.gui.optionen_felder(fc).subfeldbedingung = 'CE_ZRKlassi_Typ';
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Triggerzeitreihe
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_ZRKlassi_Trigger';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Klassifikator-Typ
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_ZRKlassi_Typ';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Ergebnisse zeitlich filtern
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_ZRKlassi_Filter';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Ergebniswahl für die Filterung
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_ZRKlassi_Filtererg';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 270];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Parameter für IIR-Filter
parameter.gui.optionen_felder(fc).visible(6).i_control_elements = 'CE_ZRKlassi_IIR';
parameter.gui.optionen_felder(fc).visible(6).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(6).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: ZR-Relevanzen zeitl. gewichten
parameter.gui.optionen_felder(fc).visible(7).i_control_elements = 'CE_ZRKlassi_Rel_gewichten';
parameter.gui.optionen_felder(fc).visible(7).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(7).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Zeitliche Aggregation: Fenstergröße
parameter.gui.optionen_felder(fc).visible(8).i_control_elements = 'CE_ZRKlassi_Aggregation_Groesse';
parameter.gui.optionen_felder(fc).visible(8).pos = [300 160];
parameter.gui.optionen_felder(fc).visible(8).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Zeitliche Aggregation der Merkmale
parameter.gui.optionen_felder(fc).visible(9).i_control_elements = 'CE_ZRKlassi_Aggregation';
parameter.gui.optionen_felder(fc).visible(9).pos = [300 190];
parameter.gui.optionen_felder(fc).visible(9).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Zeitliche Aggregation: Schrittweite
parameter.gui.optionen_felder(fc).visible(10).i_control_elements = 'CE_ZRKlassi_Aggregation_Schritt';
parameter.gui.optionen_felder(fc).visible(10).pos = [300 130];
parameter.gui.optionen_felder(fc).visible(10).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (35)
parameter.gui.optionen_felder(fc).name = 'Data mining: Regression';
parameter.gui.optionen_felder(fc).tag = 'CEO_DM_Regr';
parameter.gui.optionen_felder(fc).subfeld = {'Regression: Subfeld Zeitreihe', 'Subfeld LEER'};
parameter.gui.optionen_felder(fc).subfeldbedingung = 'CE_Regression_ZREM';
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
%%%%%%%%%%%%%%%%%%
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Regression: Merkmalsklasse
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_ZREM';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression: Merkmalsauswahl
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Merkmalsauswahl';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression: Anzahl Merkmale
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_AnzahlMerkmale';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: Regression: Normierung
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Normierung_Merkmale';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: Regression: Aggregation
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Merkmalsaggregation';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression: Anzahl aggregierter Merkmale
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Anzahl_Aggregiert';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression: Normierung aggregierter Merkmale
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Normierung_Aggregiert_Regr';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression: Output
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Output';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression: Typ
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Typ';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Preselection';
parameter.gui.optionen_felder(fc).visible(end).pos = [380 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Clustern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (14)
parameter.gui.optionen_felder(fc).name = 'Data mining: Clustering';
parameter.gui.optionen_felder(fc).tag = 'CEO_DM_Clustern';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
%%%%%%%%%%%%%%%%%%
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Merkmalsklassen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Merkmalsklassen';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Anzahl Cluster
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_AnzCluster';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Iterationsschritte
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_AnzSchritte';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Abstandsmaß
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Abtandsmass';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Method';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Factor';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Cluster-Startzentren berechnen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Startzentren';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Cluster als Ausgangsgröße anhängen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Anhaengen';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Video
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Video';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 150];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Original-ZR einzeichnen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_OrigZR';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Iterationsschritte unbegrenzt
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_UnendlichSchritte';
parameter.gui.optionen_felder(fc).visible(end).pos = [370 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
% Element: Fuzzifier für Clustern
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzifier';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: Fuzzifier für Clustern
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Cluster_Fusionierung';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 90];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Klassifikatoreinstellungen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (6)
parameter.gui.optionen_felder(fc).name = 'Data mining: Special methods';
parameter.gui.optionen_felder(fc).tag = 'CEO_DM_Klass';
parameter.gui.optionen_felder(fc).subfeld = {'Subfeld: Klassifikator Bayes', 'Subfeld: Klassifikator Neuronale Netze', ...
   'Subfeld: Klassifikator SVM', 'Subfeld: Klassifikator k-Nearest Neighbour', ...
   'Subfeld: Klassifikator k-Nearest Neighbour (Toolbox)', 'Subfeld: Fuzzy-Klassifikator','Subfeld: Entscheidungsbaum','Subfeld: Polynom',...
   'Subfeld: Kurvenfit (MATLAB)','Subfeld: Assoziationsanalyse'};
parameter.gui.optionen_felder(fc).subfeldbedingung = 'CE_Spezielle_Verfahren';
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: aktueller Klassifikator
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Spezielle_Verfahren';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Statistikoptionen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (17)
parameter.gui.optionen_felder(fc).name = 'Data mining: Statistical options';
parameter.gui.optionen_felder(fc).tag = 'CEO_DM_Stat';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: p-Wert für t-Test
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_P_Wert';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Kritischer Korrelationskoeffizient
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Krit_Koeff';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Alle anzeigen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Krit_Koeff_Alle';
parameter.gui.optionen_felder(fc).visible(end).pos = [400 390];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Kritischer Korrelationskoeffizient
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Corr_Type';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 450];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Corr_Bonferroni';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_CorrPValues';
parameter.gui.optionen_felder(fc).visible(end).pos = [400 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_CorrSelFeature';
parameter.gui.optionen_felder(fc).visible(end).pos = [400 420];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Normtest';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_DatDistNorm';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 270];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Validierung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (8)
parameter.gui.optionen_felder(fc).name = 'Data mining: Validation';
parameter.gui.optionen_felder(fc).tag = 'CEO_DM_Vali';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: n-fache Crossvalidierung
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_CV_n';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Versuchsanzahl
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_CV_Versuche';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Validierungstyp
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_CV_Typ';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Auswertung in Datei
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_Auswertung_Datei';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 310];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_CVOutputSelect';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 280];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];



%
% parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Validierung_HeterogenDist';
% parameter.gui.optionen_felder(fc).visible(end).pos = [300 250];
% parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Allgemeine Optionen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (19)
parameter.gui.optionen_felder(fc).name = 'General options';
parameter.gui.optionen_felder(fc).tag = 'CEO_Allg';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 1;
% Element: Optionen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Auswahl_Optionen';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 510];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: TEX-Protokoll
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Tex_Protokoll';
parameter.gui.optionen_felder(fc).visible(2).pos = [20 450];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Neue Merkmale speicherschonend einfügen
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_Speicherschonen';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 450];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Namenskonventionen Merkmalsgenerierung
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_Namenskonventionen';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Zahlenformat für Ausgaben
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_Anzeige_Zahlenformat';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 270];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Tooltips anzeigen
parameter.gui.optionen_felder(fc).visible(6).i_control_elements = 'CE_Anzeige_Tooltips';
parameter.gui.optionen_felder(fc).visible(6).pos = [300 420];
parameter.gui.optionen_felder(fc).visible(6).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Detailanzeige Funktions-Interna
parameter.gui.optionen_felder(fc).visible(7).i_control_elements = 'CE_Anzeige_Interna';
parameter.gui.optionen_felder(fc).visible(7).pos = [20 390];
parameter.gui.optionen_felder(fc).visible(7).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(8).i_control_elements = 'CE_Optionen_Speichern';
parameter.gui.optionen_felder(fc).visible(8).pos = [20 420];
parameter.gui.optionen_felder(fc).visible(8).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(9).i_control_elements = 'CE_Aktuelle_Figure';
parameter.gui.optionen_felder(fc).visible(9).pos = [300 360];
parameter.gui.optionen_felder(fc).visible(9).bez_pos_rel = [];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Makro_Stop_Error';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Show_ShortProtocol';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 360];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Allgemein_FileTypeImage';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_Menutips';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 390];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Select_DataPoints';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Savemode';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 150];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ProjectNamesFusion';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 330];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_LoadPluginStart';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 120];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_ShowFewTermsFirst';
parameter.gui.optionen_felder(fc).visible(end).pos = [20 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_OpenFilesInEditor';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 300];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Anzeige_OrderofTerms';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 90];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AllgParConfig';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 60];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Select_PercDataPoints';
parameter.gui.optionen_felder(fc).visible(end).pos = [700 180];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-180 -3];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Klassifikator Bayes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (20)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Klassifikator Bayes';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: Metrik Bayes-Klassifikator
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Bayes_Metrik';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: A-Priori-Wahrscheinlichkeiten verwenden
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Bayes_Apriori';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Klassifikator Neuronale Netze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (21)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Klassifikator Neuronale Netze';
parameter.gui.optionen_felder(fc).subfeld = {'Subsubfeld: Neuronale Netze MLP', 'Subsubfeld: Neuronale Netze RBF','Subsubfeld: Neuronale Netze Feedforward','Subsubfeld: Neuronale Netze SOM'};
parameter.gui.optionen_felder(fc).subfeldbedingung = 'CE_NN_Typ';
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: Neuronales Netz: Typ
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_NN_Typ';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subsubfeld: Neuronale Netze MLP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (22)
parameter.gui.optionen_felder(fc).name = 'Subsubfeld: Neuronale Netze MLP';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;

% Element: MLP: Anzahl Ausgangsneuronen
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_MLP_Ausgang';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%


% Element: MLP: Anzahl Neuronen pro Schicht
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Neuronen_Schicht';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: MLP: Lernalgorithmus
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Lern';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 260];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: MLP: Neuronentyp Eingangsschicht
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Eingangsschicht';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 230];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: MLP: Eingangswichtung
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Eingangswichtung';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 200];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: MLP: Eingangsfunktion
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Eingangsfunktion';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 170];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Errorgoal';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 140];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: MLP: Anzahl Lernepochen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Lernepochen';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 110];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Zeichnen';
parameter.gui.optionen_felder(fc).visible(end).pos = [400 80];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_ShowGUI';
parameter.gui.optionen_felder(fc).visible(end).pos = [500 80];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Internal_Stepwidth';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 80];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subsubfeld: Neuronale Netze RBF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (23)
parameter.gui.optionen_felder(fc).name = 'Subsubfeld: Neuronale Netze RBF';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: RBF: Spreizung
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_RBF_Spreizung';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 230];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Errorgoal';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 260];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% Element: : Anzahl Neuronen pro Schicht
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Neuronen_Schicht';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subsubfeld: Neuronale Netze Feedforardnet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (22)
parameter.gui.optionen_felder(fc).name = 'Subsubfeld: Neuronale Netze Feedforward';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;

% Element: MLP: Anzahl Neuronen pro Schicht
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_MLP_Neuronen_Schicht';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: MLP: Lernalgorithmus
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Lern';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 260];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Errorgoal';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 140];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: MLP: Anzahl Lernepochen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Lernepochen';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 110];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Zeichnen';
parameter.gui.optionen_felder(fc).visible(end).pos = [400 80];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_ShowGUI';
parameter.gui.optionen_felder(fc).visible(end).pos = [500 80];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Internal_Stepwidth';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 80];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Neuronen_NumberofLayers';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 320];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subsubfeld: Neuronale Netze SOM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (23)
parameter.gui.optionen_felder(fc).name = 'Subsubfeld: Neuronale Netze SOM';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: RBF: Spreizung
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_SomDimension';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 230];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_SomNeurons';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 260];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

% Element
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_ShowGUI';
parameter.gui.optionen_felder(fc).visible(end).pos = [500 200];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [];

% Element: MLP: Anzahl Lernepochen
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MLP_Lernepochen';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 200];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Klassifikator SVM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (24)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Klassifikator SVM';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: Kernel
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_SVM_Kernel';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 320];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Ordnung Kernel
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_SVM_Ordnung';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Strafterm Fehlklassifikation C
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_SVM_Strafterm';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 260];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: SVM-internes one-against-one oder one-against-all verwenden
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_SVM_intern_oax';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Klassifikator k-Nearest Neighbour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (25)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Klassifikator k-Nearest Neighbour';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: k
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_kNN_k';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Metrik k-NN
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_kNN_Metrik';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 320];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Größe der Region
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_kNN_Region';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Alle Nachbarn in einer Region verwenden
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_kNN_AlleNachbarn';
parameter.gui.optionen_felder(fc).visible(4).pos = [400 240];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Abstandswichtung
parameter.gui.optionen_felder(fc).visible(5).i_control_elements = 'CE_kNN_Wichtung';
parameter.gui.optionen_felder(fc).visible(5).pos = [300 290];
parameter.gui.optionen_felder(fc).visible(5).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Mindestanzahl an Nachbarn prüfen
parameter.gui.optionen_felder(fc).visible(6).i_control_elements = 'CE_kNN_NachbarnPruefen';
parameter.gui.optionen_felder(fc).visible(6).pos = [400 210];
parameter.gui.optionen_felder(fc).visible(6).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: max. Abstand
parameter.gui.optionen_felder(fc).visible(7).i_control_elements = 'CE_kNN_MaxAbstand';
parameter.gui.optionen_felder(fc).visible(7).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(7).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Mindestanzahl an Nachbarn innerhalb max. Abstand
parameter.gui.optionen_felder(fc).visible(8).i_control_elements = 'CE_kNN_Mindestzahl_Nachbarn';
parameter.gui.optionen_felder(fc).visible(8).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(8).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Klassifikator k-Nearest Neighbour (Toolbox)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (26)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Klassifikator k-Nearest Neighbour (Toolbox)';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: k
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_kNN_k';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Verfahren one-class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (27)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Verfahren one-class';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: Ordnung Kernel
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_SVM_Ordnung';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 210];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Strafterm Lambda (bei weichen Grenzen)
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_OneClass_Strafterm';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 180];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Cityblock-Distanz verwenden
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_OneClass_Cityblock';
parameter.gui.optionen_felder(fc).visible(3).pos = [450 210];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Klassengrenzen bestimmen
parameter.gui.optionen_felder(fc).visible(4).i_control_elements = 'CE_OneClass_HartWeich';
parameter.gui.optionen_felder(fc).visible(4).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(4).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Verfahren dichtebasiert
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (28)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Verfahren dichtebasiert';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: max. Abstand
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_kNN_MaxAbstand';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 240];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: ZR-Typ TSK-Fuzzy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (29)
parameter.gui.optionen_felder(fc).name = 'Subfeld: ZR-Typ TSK-Fuzzy';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: Anzahl Cluster bei TSK-Fuzzy
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_ZRKlassi_TSK_Anz';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 80];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Cluster-ZGH anzeigen
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_ZRKlassi_TSK_ZGH';
parameter.gui.optionen_felder(fc).visible(2).pos = [530 80];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%
% Element: Schwellwert für Fuzzy-Cluster
parameter.gui.optionen_felder(fc).visible(3).i_control_elements = 'CE_ZRKlassi_TSK_Schwellwert';
parameter.gui.optionen_felder(fc).visible(3).pos = [300 50];
parameter.gui.optionen_felder(fc).visible(3).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: ZR-Typ K5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (30)
parameter.gui.optionen_felder(fc).name = 'Subfeld: ZR-Typ K5';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: K5: jeden x.te Abtastpunkt verwenden
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_ZRKlassi_K5JederXTe';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 80];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld LEER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (31)
parameter.gui.optionen_felder(fc).name = 'Subfeld LEER';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Aggregation optimierte Diskriminanz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (32)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Aggregation optimierte Diskriminanz';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
% Element: Kriterium für optimierte DA
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Klassifikation_OptDA';
parameter.gui.optionen_felder(fc).visible(1).pos = [500 200];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-140 -3];
%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Fuzzy-Klassifikator und Baum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (35)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Fuzzy-Klassifikator';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
%%%%%%%%%%%%%%%%%%
% Element: Typ Entscheidungsbaum
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Fuzzy_TypeZGF';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_AnzLingTerme';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_Entscheidungsbaum';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 280];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_Baum_klassenspezifisch';
parameter.gui.optionen_felder(fc).visible(end).pos = [600 280];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_Klarheit';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 250];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_Inferenz';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 220];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_NumberRulesRulebase';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 190];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_StatRele';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 160];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_MBF_Fix';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 310];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_RuleBaseSearch';
parameter.gui.optionen_felder(fc).visible(end).pos = [400 190];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Entscheidungsbaum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (35)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Entscheidungsbaum';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
%%%%%%%%%%%%%%%%%%
% Element: Typ Entscheidungsbaum
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Fuzzy_TypeZGF';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_AnzLingTerme';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_Entscheidungsbaum';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 310];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Fuzzy_StatRele';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 280];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feld: Subfeld: Polynom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (35)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Polynom';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
%%%%%%%%%%%%%%%%%%
% Element: Grad Polynom
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Regression_GradPolynom';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression:
parameter.gui.optionen_felder(fc).visible(2).i_control_elements = 'CE_Regression_AnzahlPolyMerkmale';
parameter.gui.optionen_felder(fc).visible(2).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(2).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression:
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_PolynomWeighting';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 310];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];

fc=fc+1;
% Element: Projektübersicht
parameter.gui.optionen_felder(fc).name = 'Subfeld: MenuHelp';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
%%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Menu_Text';
parameter.gui.optionen_felder(fc).visible(1).pos = [30 10];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fc = fc + 1; % (35)
parameter.gui.optionen_felder(fc).name = 'Regression: Subfeld Zeitreihe';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
%%%%%%%%%%%%%%%%%%
% Element: Regression: Abtastpunkte
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Regression_Abtastpunkte';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 140];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];


% Feld: Subfeld: Kurvenfit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (35)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Kurvenfit (MATLAB)';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
%%%%%%%%%%%%%%%%%%
% Element: Regression Typ
parameter.gui.optionen_felder(fc).visible(1).i_control_elements = 'CE_Regression_Fit';
parameter.gui.optionen_felder(fc).visible(1).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(1).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression Typ
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Fit_Par1';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
%%%%%%%%%%%%%%%%%%
% Element: Regression Typ
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_Regression_Fit_Par2';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 310];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];


% Feld: Subfeld: Association
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = fc + 1; % (35)
parameter.gui.optionen_felder(fc).name = 'Subfeld: Assoziationsanalyse';
parameter.gui.optionen_felder(fc).subfeld = [];
parameter.gui.optionen_felder(fc).subfeldbedingung = [];
parameter.gui.optionen_felder(fc).visible = [];
parameter.gui.optionen_felder(fc).in_auswahl = 0;
%%%%%%%%%%%%%%%%%%
% Element: 
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AssociationIgnoreFrequent';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 370];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% %%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AssociationNRules';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 340];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% %%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AssociationMinSupp';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 310];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% %%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AssociationMinKonf';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 280];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];
% %%%%%%%%%%%%%%%%%%
parameter.gui.optionen_felder(fc).visible(end+1).i_control_elements = 'CE_AssociationSorting';
parameter.gui.optionen_felder(fc).visible(end).pos = [300 250];
parameter.gui.optionen_felder(fc).visible(end).bez_pos_rel = [-280 -3];





clear fc;


parameter.gui.waehlbare_felder = find(myCellArray2Matrix({parameter.gui.optionen_felder.in_auswahl}));
str = '';
for i = 1:length(parameter.gui.waehlbare_felder)
   str = [str parameter.gui.optionen_felder(parameter.gui.waehlbare_felder(i)).name '|'];
end;
str(end) = [];
tags = {parameter.gui.control_elements.tag};
indx = getfindstr(tags, 'CE_Auswahl_Optionen', 'exact'); %indx = strmatch('CE_Auswahl_Optionen', tags, 'exact');
if (~isempty(indx))
   parameter.gui.control_elements(indx).listen_werte = str;
end;
