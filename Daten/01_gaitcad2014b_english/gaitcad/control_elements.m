% Script control_elements
%
%   Folgende Felder definierten ein Kontrollelement:
%   parameter.gui.control_elements(ec).uihd_code: ((1,2)-Vektor): Index für uihd-Element
%   parameter.gui.control_elements(ec).handle = []: kann man auch weglassen. Wird automatisch bei der Erzeugung der Elemente erstellt.
%   parameter.gui.control_elements(ec).name: (Zeichenkette). Name, der in den Bezeichner eingetragen wird
%   parameter.gui.control_elements(ec).style: (Zeichenkette) Stil des Kontroll-Elements. Entspricht der normalen Matlab-Style-Option
% 
%   Für radiobutton-Felder können folgende weiteren Felder definiert werden:
%   parameter.gui.control_elements(ec).radiogroup: (Vektor) welche weiteren Kontroll-Elemente gehören zu einer Gruppe von Radiobuttons?
%   parameter.gui.control_elements(ec).radioval: (Zeichenkette) welche Zeichenkette soll in der Variablen (siehe nächstes Feld) gespeichert werden
% 
%   Bei Edit-Feldern kann ein Wertebereich angegeben werden, der für das Feld gültig ist:
%   parameter.gui.control_elements(ec).wertebereich: (1,2)-cell-Array. Es sind sowohl skalare Werte als auch Zeichenketten erlaubt, die dann
%   vor dem Test ausgeführt werden (zum Beispiel {1, 'size(d_orgs,2)'} definiert einen Wertebereich, der nach unten durch 1 und nach oben
%   durch die Anzahl an vorhandenen Abtastpunkten begrenzt ist).
% 
%   Für den Fall einer Listbox muss angegeben werden, ob mehrere Auswahlen erlaubt sind
%   parameter.gui.control_elements(ec).multilistbox: (1 oder 0)
%   und man kann sich aussuchen, ob die Zeichenkette oder der Index in die Variable eingetragen werden soll (gilt auch für Popupmenu):
%   parameter.gui.control_elements(ec).save_as_string: (1 oder 0)
%   Die Werte, die in die Listbox oder in das Popupmenu eingetragen werden sollen stehen in
%   parameter.gui.control_elements(ec).listen_werte: (Zeichenkette) Mit '|' getrennte Zeichenkette mit den Namen der Auswahlmöglichkeiten.
%   Wichtig! Eine Stringmatrix funktioniert nicht!
% 
%   parameter.gui.control_elements(ec).variable: (Zeichenkette): Name der Variablen, in der der Wert des GUI-Elements gespeichert wird
%   parameter.gui.control_elements(ec).default: (Skalar) default-Wert, der beim Einrichten der Elemente eingestellt wird
%   parameter.gui.control_elements(ec).tooltext: (Zeichenkette) Tooltext, der beim Halten der Maus über dem Element angezeigt wird
%   parameter.gui.control_elements(ec).callback: (Zeichenkette) callback-Funktion
%   WICHTIG:
%   Der Callback ist derjenige, der extra ausgeführt werden soll!
%   Bei Edit-Feldern wird _immer_ ein Bereichscheck der Werte durchgeführt. Aus allen Feldern wird _immer_
%   das Kopieren des neuen Wertes in die Variable durchgeführt.
%   Bei radiobuttons wird zusätzlich dafür gesorgt, dass die anderen in der Gruppe enthaltenen
%   Elemente zurückgesetzt werden.
%   In callback müssen also nur weitere auszuführende Befehle eingetragen werden.
% 
%   parameter.gui.control_elements(ec).breite: (Skalar) Breite des Elements
%   parameter.gui.control_elements(ec).hoehe: (Skalar) Höhe des Elements
%   parameter.gui.control_elements(ec).bezeichner: Strukt für den Bezeichner des Elements.
%   Ist leer, wenn kein extra-Bezeichner nötig ist (z.B. bei Checkbox). Enthält sonst:
%         parameter.gui.control_elements(ec).bezeichner.uihd_code: ((1,2)-Vektor) wie oben;
%         parameter.gui.control_elements(ec).bezeichner.handle: wird automatisch gesetzt
%         parameter.gui.control_elements(ec).bezeichner.breite: (Skalar);
%         parameter.gui.control_elements(ec).bezeichner.hoehe: (Skalar)
% 
%   parameter.gui.control_elements(ec).userdata:
%   ACHTUNG! Das Feld UserData wird intern verwendet! Wird es hier angegegen, sind
%   eventuell Funktionalitäten deaktiviert. Ein erlaubtes Schlüsselwort ist "ignore".
%   Dieses Wort wird z.B. bei der Generierung der Dokumentation verarbeitet.
%   Dieses Feld wird unverändert in das Kontrollelement eingetragen. Wenn es leer ist, kommt
%   der Bezeichner in dieses Feld. Das ist u.a. für die Makros und die Dokumentation wichtig!
%
% The script control_elements is part of the MATLAB toolbox Gait-CAD. 
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

ec = 1;
%%%%%%%%%%%%%%%%%%%%%%%
% EM Anzeige x-y-Tausch
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_XYTausch';
parameter.gui.control_elements(ec).uihd_code = [11 4];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'SF display x-y-turn';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.em_anzeige_xy_tausch';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Anzahl Terme für EM->Ausgangsgröße
ec = ec + 1; % (4)
parameter.gui.control_elements(ec).tag = 'CE_EM_Ausgangs';
parameter.gui.control_elements(ec).uihd_code = [11 6];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of terms for Single feature->Output variable';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.anz_em_klasse';
parameter.gui.control_elements(ec).default = '5 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1, Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 6];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Alle Werte
ec = ec + 1; % (5)
parameter.gui.control_elements(ec).tag = 'CE_EM_Ausgangs_Alle';
parameter.gui.control_elements(ec).uihd_code = [11 7];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'All values';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.alle_werte';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Linienstärke
ec = ec + 1; % (6)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Linienstaerke';
parameter.gui.control_elements(ec).uihd_code = [11 8];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Linewidth';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.linienstaerke';
parameter.gui.control_elements(ec).default = '1 ';
parameter.gui.control_elements(ec).ganzzahlig = 0;
parameter.gui.control_elements(ec).wertebereich = {1, Inf};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 8];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Farb/Style Wahl
ec = ec + 1; % (7)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_FarbStyle';
parameter.gui.control_elements(ec).uihd_code = [11 9];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Color style';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.farbvariante';
parameter.gui.control_elements(ec).listen_werte = 'Style 1|Style 2|Style 3|Style 4|Style 5 (Gray values)|Style 6|Style 7|User-defined (color or symbol)|User-defined (color and symbol)|Color and symbol (1./other output variable)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 9];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Zulässige Anzahl Merkmale (Merkmalsreduktion)
ec = ec + 1; % (8)
parameter.gui.control_elements(ec).tag = 'CE_Anzahl_Merkmale';
parameter.gui.control_elements(ec).uihd_code = [11 10];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of selected features';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.merk_red';
parameter.gui.control_elements(ec).default = '10 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1, 'max(par.anz_merk, par.anz_einzel_merk)'};
parameter.gui.control_elements(ec).callback = 'if parameter.gui.klassifikation.merk_red>length(merkmal_auswahl) merkmal_auswahl=[];else merkmal_auswahl=merkmal_auswahl(1:parameter.gui.klassifikation.merk_red);end;';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 10];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl Ausgangsgröße
ec = ec + 1; % (9)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_Ausgangsgroesse';
parameter.gui.control_elements(ec).uihd_code = [11 12];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Selection of output variable';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.ausgangsgroesse';
parameter.gui.control_elements(ec).listen_werte = 'None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'aktparawin; ';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 12];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl Zeitreihe (ZR)
ec = ec + 1; % (10)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_ZR';
parameter.gui.control_elements(ec).uihd_code = [11 13];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Selection of time series (TS)';
parameter.gui.control_elements(ec).style = 'listbox';
parameter.gui.control_elements(ec).multilistbox = 1;
parameter.gui.control_elements(ec).immer_auswahl = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.ind_zr';
parameter.gui.control_elements(ec).listen_werte = 'None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_control_zrauswahl;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 270;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 13];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl Einzelmerkmal (EM)
ec = ec + 1; % (11)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_EM';
parameter.gui.control_elements(ec).uihd_code = [11 14];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Selection of single feature(s) (SF)';
parameter.gui.control_elements(ec).style = 'listbox';
parameter.gui.control_elements(ec).multilistbox = 1;
parameter.gui.control_elements(ec).immer_auswahl = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.ind_em';
parameter.gui.control_elements(ec).listen_werte = 'None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_control_emauswahl;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 270;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 14];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% ALLE
ec = ec + 1; % (12)
parameter.gui.control_elements(ec).tag = 'CE_EditAuswahl_ZR';
parameter.gui.control_elements(ec).uihd_code = [11 15];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Edit field for TS selection';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = '';
parameter.gui.control_elements(ec).userdata = 'ignore';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'ind_listbox=round(str2num(get(uihd(11,15),''string''))); ind_listbox(find((ind_listbox<1)|(ind_listbox>par.anz_merk)))=[];ind_listbox=findd_unsort(ind_listbox);if isempty(ind_listbox) ind_listbox=1;end;set(uihd(11,13),''value'',ind_listbox);eval(get(uihd(11,13),''callback'')); ';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% ALLE
ec = ec + 1; % (13)
parameter.gui.control_elements(ec).tag = 'CE_EditAuswahl_EM';
parameter.gui.control_elements(ec).uihd_code = [11 16];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Edit field single feature selection';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = '';
parameter.gui.control_elements(ec).userdata = 'ignore';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = ' ind_listbox=round(str2num(get(uihd(11,16),''string''))); ind_listbox(find((ind_listbox<1)|(ind_listbox>par.anz_einzel_merk)))=[]; ind_listbox=findd_unsort(ind_listbox);if isempty(ind_listbox) ind_listbox=1;end;set(uihd(11,14),''value'',ind_listbox);eval(get(uihd(11,14),''callback'')); ';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Nr. Datentupel
ec = ec + 1; % (14)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_NrDatentupel';
parameter.gui.control_elements(ec).uihd_code = [11 18];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show data point number';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.anzeige_nr_datentupel';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (14)
parameter.gui.control_elements(ec).tag = 'CE_TimeSeriesForbidLength1';
parameter.gui.control_elements(ec).uihd_code = [11 19];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Forbid segments of length 1';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.forbid_length1';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% p-Wert für t-Test
ec = ec + 1; % (20)
parameter.gui.control_elements(ec).tag = 'CE_AllgFontName';
parameter.gui.control_elements(ec).uihd_code = [11 20];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Font';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.standard_font';
parameter.gui.control_elements(ec).default = 'Helvetica';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 20];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;%%%%%%%%%%%%%%%%%%%%%%%

% p-Wert für t-Test
ec = ec + 1; % (20)
parameter.gui.control_elements(ec).tag = 'CE_AllgFontSize';
parameter.gui.control_elements(ec).uihd_code = [11 21];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Font size';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.standard_size';
parameter.gui.control_elements(ec).default = '10';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 20};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 21];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 100;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (14)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_GermanNumbers';
parameter.gui.control_elements(ec).uihd_code = [11 22];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Decimal symbol in German format (comma)';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.german_decimal_numbers';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

% p-Wert für t-Test
ec = ec + 1; % (20)
parameter.gui.control_elements(ec).tag = 'CE_AllgParConfig';
parameter.gui.control_elements(ec).uihd_code = [11 23];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Configuration name for MATLAB parallel';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.parallel_configuration';
parameter.gui.control_elements(ec).default = 'local';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 21];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Grafiken
ec = ec + 1; % (15)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Grafiken';
parameter.gui.control_elements(ec).uihd_code = [11 26];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show figures';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.anzeige_grafiken';
parameter.gui.control_elements(ec).listen_werte = 'Colored|Class No.|Black-and-white symbol';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 26];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% TEX-Protokoll
ec = ec + 1; % (16)
parameter.gui.control_elements(ec).tag = 'CE_Tex_Protokoll';
parameter.gui.control_elements(ec).uihd_code = [11 27];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'TEX protocol';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.tex_protokoll';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];




%%%%%%%%%%%%%%%%%%%%%%%
% Optionen
ec = ec + 1; % (18)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_Optionen';
parameter.gui.control_elements(ec).uihd_code = [11 29];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Options';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.gew_fenster';
parameter.gui.control_elements(ec).listen_werte = 'Features and classes|View options|Statistical options|Data preprocessing|Time series (TS)|View time series|Gait-specific|Validation|Classification|TS classification|Feature generation|Export|Outlier detection';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_option_switch;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
%parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 29];
%parameter.gui.control_elements(ec).bezeichner.handle = [];
%parameter.gui.control_elements(ec).bezeichner.breite = 250;
%parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige Legende
ec = ec + 1; % (19)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Legende';
parameter.gui.control_elements(ec).uihd_code = [11 30];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show legend';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.legende';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% p-Wert für t-Test
ec = ec + 1; % (20)
parameter.gui.control_elements(ec).tag = 'CE_P_Wert';
parameter.gui.control_elements(ec).uihd_code = [11 31];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'p-value for t test';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.statistikoptionen.p_krit';
parameter.gui.control_elements(ec).default = '0.050';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 31];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Kritischer Korrelationskoeffizient
ec = ec + 1; % (21)
parameter.gui.control_elements(ec).tag = 'CE_Krit_Koeff';
parameter.gui.control_elements(ec).uihd_code = [11 32];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Threshold for correlation coefficient';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.statistikoptionen.c_krit';
parameter.gui.control_elements(ec).default = '0.700';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 32];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (30)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Hist';
parameter.gui.control_elements(ec).uihd_code = [11 33];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Centers for histogram bins';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.histvalue';
parameter.gui.control_elements(ec).default = '0:10:100';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 33];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Automatisch (empfohlen für Wurzel- oder Exp-Kennlinie!)
ec = ec + 1; % (121)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_HistAuto';
parameter.gui.control_elements(ec).uihd_code = [11 34];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Automatic';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.histauto';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 300;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (30)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_FeatureNumber';
parameter.gui.control_elements(ec).uihd_code = [11 35];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Shown feature relevances in lists';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.feature_number';
parameter.gui.control_elements(ec).default = '10';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1, 'max(1,size(d_org,2))'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 35];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Automatisch (empfohlen für Wurzel- oder Exp-Kennlinie!)
ec = ec + 1; % (121)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_FeatureNumberCheck';
parameter.gui.control_elements(ec).uihd_code = [11 36];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'All';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.featurenumber_list_check';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 300;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Zahlenformat für Ausgaben
ec = ec + 1; % (24)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Output4EM';
parameter.gui.control_elements(ec).uihd_code = [11 37];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Output variables protocol files absolute values';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.output4em';
parameter.gui.control_elements(ec).listen_werte = 'All|Selected|None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 37];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Zahlenformat für Ausgaben
ec = ec + 1; % (24)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_ListSorting';
parameter.gui.control_elements(ec).uihd_code = [11 38];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sorting of lists';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.list_sorting';
parameter.gui.control_elements(ec).listen_werte = 'Descending|Ascending|Unsorted';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 38];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Alle anzeigen
ec = ec + 1; % (22)
parameter.gui.control_elements(ec).tag = 'CE_ProjectNamesFusion';
parameter.gui.control_elements(ec).uihd_code = [11 39];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Project names as part of the variable names';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.project_names_fusion';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (30)
parameter.gui.control_elements(ec).tag = 'CE_Select_MinDtClass';
parameter.gui.control_elements(ec).uihd_code = [11 40];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Minimal number of data points in one class';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.datenvorverarbeitung.min_dt_number';
parameter.gui.control_elements(ec).default = '10';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1, 'par.anz_dat'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 40];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Alle anzeigen
ec = ec + 1; % (22)
parameter.gui.control_elements(ec).tag = 'CE_ShowFewTermsFirst';
parameter.gui.control_elements(ec).uihd_code = [11 41];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Output variable: few terms first';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.show_few_terms_first';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];



%%%%%%%%%%%%%%%%%%%%%%%
% Alle anzeigen
ec = ec + 1; % (22)
parameter.gui.control_elements(ec).tag = 'CE_OpenFilesInEditor';
parameter.gui.control_elements(ec).uihd_code = [11 42];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Open files in MATLAB editor';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.open_files_in_editor';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Alle anzeigen
ec = ec + 1; % (30)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_OrderofTerms';
parameter.gui.control_elements(ec).uihd_code = [11 43];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Order of linguistic terms';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.order_of_terms';
parameter.gui.control_elements(ec).default = '1 2';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1, 'par.anz_ling_y(par.y_choice)'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_order_of_terms;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 43];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Namenskonventionen Merkmalsgenerierung
ec = ec + 1; % (23)
parameter.gui.statistikoptionen.type_liste = {'Pearson','Spearman','Kendall'};
parameter.gui.control_elements(ec).tag = 'CE_Corr_Type';
parameter.gui.control_elements(ec).uihd_code = [11 44];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Type for correlation parameters';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.statistikoptionen.corr_type';
parameter.gui.control_elements(ec).listen_werte = 'Pearson|Spearman|Kendall';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 47];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Select_PercDataPoints';
parameter.gui.control_elements(ec).uihd_code = [11 45];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Percent for selection';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.allgemein.percentage_data_points';
parameter.gui.control_elements(ec).default = '10';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 100};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 45];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 150;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Alle anzeigen
ec = ec + 1; % (22)
parameter.gui.control_elements(ec).tag = 'CE_Krit_Koeff_Alle';
parameter.gui.control_elements(ec).uihd_code = [11 46];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show all';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.statistikoptionen.alle_anzeigen';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Namenskonventionen Merkmalsgenerierung
ec = ec + 1; % (23)
parameter.gui.control_elements(ec).tag = 'CE_Namenskonventionen';
parameter.gui.control_elements(ec).uihd_code = [11 47];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Name conventions for feature generation';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.namenskonvention';
parameter.gui.control_elements(ec).listen_werte = 'Blank|Underscore';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 47];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Zahlenformat für Ausgaben
ec = ec + 1; % (24)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Zahlenformat';
parameter.gui.control_elements(ec).uihd_code = [11 48];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number format for result plots';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.zahlenformat';
parameter.gui.control_elements(ec).listen_werte = '%g|%6.2g|%5.3f|%7.1f|%1.2f|%.5g';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 48];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Preselection Merkmale
ec = ec + 1; % (95)
parameter.gui.control_elements(ec).tag = 'CE_Regression_Preselection';
parameter.gui.control_elements(ec).uihd_code = [11 49];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Preselection of features';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.preselection_merkmale';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 180;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Schwellwert für ZR löschen [Proz. fehlende Daten]
ec = ec + 1; % (26)
parameter.gui.control_elements(ec).tag = 'CE_Nullzr_Schwellwert';
parameter.gui.control_elements(ec).uihd_code = [11 50];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Threshold for deleting [Perc. missing data]';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.datenvorverarbeitung.schwellwert_zr_loeschen';
parameter.gui.control_elements(ec).default = '20 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 100};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 50];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Fenstergröße [Abtastpkt.]
ec = ec + 1; % (27)
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_Fenstergroesse';
parameter.gui.control_elements(ec).uihd_code = [11 51];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Window size [sample points]';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.fenstergroesse';
parameter.gui.control_elements(ec).default = '64 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1, 'max(1,size(d_orgs,2))'};
parameter.gui.control_elements(ec).callback = 'parameter.gui.zeitreihen.fenstergroesse=2^floor(log2(parameter.gui.zeitreihen.fenstergroesse));set(uihd(11,51),''String'',num2str(parameter.gui.zeitreihen.fenstergroesse));';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 51];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Abtastfrequenz Zeitreihe
ec = ec + 1; % (28)
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_Abtastfreq';
parameter.gui.control_elements(ec).uihd_code = [11 52];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sampling frequency of time series';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.abtastfrequenz';
parameter.gui.control_elements(ec).default = '100.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1E-10 Inf};
parameter.gui.control_elements(ec).ganzzahlig = 0;
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 52];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Abtastfrequenz Zeitreihe
%ACHTUNG! Sonderbehandlung - jede neue Einheit muss 3x eingetragen werden inkl. ihrere inversen
%außerdem leichte Missnutzung von parameter.gui. ...
ec = ec + 1; % (28)
parameter.gui.zeitreihen.einheit_abtastfrequenz_liste={'Hz','kHz','MHz','GHz','per minute','per hour','per day','per months','per year','per sample'};
parameter.gui.zeitreihen.einheit_abtastzeit_liste={'s','msec','µs','nsec','Minutes','Hours','Days','Months','Years','Sample point'};
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_Einheit_Abtastfreq';
parameter.gui.control_elements(ec).uihd_code = [11 200];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Unit';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.einheit_abtastfrequenz';
parameter.gui.control_elements(ec).listen_werte = 'Hz|kHz|MHz|GHz|per minute|per hour|per day|per months|per year|per sample';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_abtast_einheit;';
parameter.gui.control_elements(ec).breite = 100;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 200];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 60;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihensegment Start
ec = ec + 1; % (28)
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_Segment_Start';
parameter.gui.control_elements(ec).uihd_code = [11 197];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Time series segment from';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.segment_start';
parameter.gui.control_elements(ec).default = '1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {'1', 'max(1,min(parameter.gui.zeitreihen.segment_ende-parameter.gui.zeitreihen.forbid_length1,par.laenge_zeitreihe))'};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 75;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 197];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihensegment Ende
ec = ec + 1; % (28)
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_Segment_Ende';
parameter.gui.control_elements(ec).uihd_code = [11 198];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'to';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.segment_ende';
parameter.gui.control_elements(ec).default = '1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {'max(1,parameter.gui.zeitreihen.segment_start+parameter.gui.zeitreihen.forbid_length1)', 'par.laenge_zeitreihe'};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 75;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 198];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 20;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Ganze Zeitreihe
ec = ec + 1; % (145)
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_Segment_Komplett';
parameter.gui.control_elements(ec).uihd_code = [12 199];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Complete time series';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'parameter.gui.zeitreihen.segment_start=1;parameter.gui.zeitreihen.segment_ende=par.laenge_zeitreihe;inGUI;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% FFT über Periodendauer plotten (sonst über Frequenz)
ec = ec + 1; % (29)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_FFTPeriode';
parameter.gui.control_elements(ec).uihd_code = [11 53];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Plot FFT vs. period length (instead of frequency)';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.fft_periode';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 280;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Grenzen für Farbachse
ec = ec + 1; % (30)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Farbachse';
parameter.gui.control_elements(ec).uihd_code = [11 54];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Limits for color axis';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.caxis_vec';
parameter.gui.control_elements(ec).default = '0  1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 54];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Colormap
ec = ec + 1; % (31)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Colormap';
parameter.gui.control_elements(ec).uihd_code = [11 55];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Colormap';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.colormap';
parameter.gui.control_elements(ec).listen_werte = 'Jet|Gray values|1-Gray values|hsv|hot|bone|copper|pink|flag|lines|colorcube|vga|prism|cool|autumn|spring|winter|summer|Light gray';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 55];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Kennlinie für Farbeinteilung
ec = ec + 1; % (32)
parameter.gui.control_elements(ec).tag = 'CE_Kennlinie';
parameter.gui.control_elements(ec).uihd_code = [11 56];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Function for color bar';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.kennlinie';
parameter.gui.zeitreihen.kennlinie_name = char('Linear', 'Root-', 'umg. Exponentielle','Logarithmic');
parameter.gui.control_elements(ec).listen_werte = 'Linear|Root correction|Inverse exponential|Logarithmic';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 56];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Anzeigen
ec = ec + 1; % (33)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_ZRImagePlot';
parameter.gui.control_elements(ec).uihd_code = [11 57];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Imageplot Time series (Color coding)';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.image_plot';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Potenz für Exp (Exp.-Kennlinie)
ec = ec + 1; % (34)
parameter.gui.control_elements(ec).tag = 'CE_Kennlinie_Exp';
parameter.gui.control_elements(ec).uihd_code = [11 58];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Exponent for exponential function';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.exponent_exp';
parameter.gui.control_elements(ec).default = '3 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 20};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 58];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Parameter IIR-Filter
ec = ec + 1; % (35)
parameter.gui.control_elements(ec).tag = 'CE_Parameter_IIR';
parameter.gui.control_elements(ec).uihd_code = [11 59];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Parameter IIR filter';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.iirfilter';
parameter.gui.control_elements(ec).default = '0.980';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 59];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% IIR-Parameter (aS, aL, aSigma)
ec = ec + 1; % (36)
parameter.gui.control_elements(ec).tag = 'CE_Parameter_aSaLaSigma';
parameter.gui.control_elements(ec).uihd_code = [11 60];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'IIR parameter (aF, aS, aSigma)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.iirfilter_aS_aL_aSigma';
parameter.gui.control_elements(ec).default = '0.980 0.995 0.995';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 130;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 60];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Grad der Wurzel (Wurzelkennlinie)
ec = ec + 1; % (37)
parameter.gui.control_elements(ec).tag = 'CE_Kennline_Sqrt';
parameter.gui.control_elements(ec).uihd_code = [11 61];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Index of the root';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.exponent_wurzel';
parameter.gui.control_elements(ec).default = '2 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 20};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 61];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Colorbar anzeigen
ec = ec + 1; % (38)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Colorbar';
parameter.gui.control_elements(ec).uihd_code = [11 62];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show color bar';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.plot_colorbar';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 280;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Fuzzifier für Clustern
ec = ec + 1; % (39)
parameter.gui.control_elements(ec).tag = 'CE_Fuzzifier';
parameter.gui.control_elements(ec).uihd_code = [11 63];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Fuzzifier for clustering';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzifier_fcm';
parameter.gui.control_elements(ec).default = '2.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 63];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Fuzzifier für Clustern
ec = ec + 1; % (39)
parameter.gui.control_elements(ec).tag = 'CE_MBF_Fix';
parameter.gui.control_elements(ec).uihd_code = [11 64];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Parameters MBF (fix)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.zgf';
parameter.gui.control_elements(ec).default = '[0 1 2 3]';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {-Inf Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 130;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 64];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% ZR->EM Abtastpunkt
ec = ec + 1; % (41)
parameter.gui.control_elements(ec).tag = 'CE_ZR_EM_Abtastpunkt';
parameter.gui.control_elements(ec).uihd_code = [11 65];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sample point for Time series->Single feature';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.samplepunkt';
parameter.gui.control_elements(ec).default = '1 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1, 'size(d_orgs,2)'};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 65];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% n-fache Crossvalidierung
ec = ec + 1; % (42)
parameter.gui.control_elements(ec).tag = 'CE_CV_n';
parameter.gui.control_elements(ec).uihd_code = [11 66];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'n-fold cross-validation';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.validierung.anz_cv';
parameter.gui.control_elements(ec).default = '5 ';
parameter.gui.control_elements(ec).wertebereich = {1, 'length(ind_auswahl)'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 66];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Versuchsanzahl Crossvalidierung
ec = ec + 1; % (43)
parameter.gui.control_elements(ec).tag = 'CE_CV_Versuche';
parameter.gui.control_elements(ec).uihd_code = [11 67];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of trials';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).variable = 'parameter.gui.validierung.versuch_cv';
parameter.gui.control_elements(ec).default = '1 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 67];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Validierungstyp
ec = ec + 1; % (44)
parameter.gui.control_elements(ec).tag = 'CE_CV_Typ';
parameter.gui.control_elements(ec).uihd_code = [11 68];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Validation strategy';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.validierung.typ';
parameter.gui.control_elements(ec).listen_werte = 'Cross-validation|Leave-one-out|Bootstrap|Crossvalidation (separated by values of output variable)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_validation_type;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 68];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Detailanzeige Funktions-Interna
ec = ec + 1; % (45)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Interna';
parameter.gui.control_elements(ec).uihd_code = [11 69];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Detail plot of function interna';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.validierung.detail_anzeige';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 200;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Auswertung in Datei
ec = ec + 1; % (46)
parameter.gui.control_elements(ec).tag = 'CE_Auswertung_Datei';
parameter.gui.control_elements(ec).uihd_code = [11 70];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Plot in file';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.validierung.auswertung_in_datei';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Neue Merkmale speicherschonend einfügen
ec = ec + 1; % (47)
parameter.gui.control_elements(ec).tag = 'CE_Speicherschonen';
parameter.gui.control_elements(ec).uihd_code = [11 71];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Memory-optimized feature generation';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.speicherschonend_einfuegen';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% MAKRO: neue Bilder
ec = ec + 1; % (48)
parameter.gui.control_elements(ec).tag = 'CE_Aktuelle_Figure';
parameter.gui.control_elements(ec).uihd_code = [11 72];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'For macros: plot always in current figure';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.aktuelle_figure';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 260;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Zeitreihen in Subplots zeichnen
ec = ec + 1; % (49)
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_Subplots';
parameter.gui.control_elements(ec).uihd_code = [11 73];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show time series as subplots';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.zr_in_subplots';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Prozentuale Anzeige (Abtastfreq. wird ignoriert)
ec = ec + 1; % (50)
parameter.gui.control_elements(ec).tag = 'CE_ZRAnzeige_Proz';
parameter.gui.control_elements(ec).uihd_code = [11 74];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Percental (ignore sampling frequency)';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.anzeige';
parameter.gui.control_elements(ec).style = 'radiobutton';
parameter.gui.control_elements(ec).radiogroup = {'CE_ZRAnzeige_Proz', 'CE_ZRAnzeige_Abtastpkt', 'CE_ZRAnzeige_Zeit','CE_ZRAnzeige_Projekt'};
parameter.gui.control_elements(ec).radioval = 'Percental';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = []';
parameter.gui.control_elements(ec).breite = 280;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Anzahl aggregierter Merkmale
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Anzahl_Aggregiert';
parameter.gui.control_elements(ec).uihd_code = [11 75];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of aggregated features';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.anz_hk';
parameter.gui.control_elements(ec).default = '2 ';
parameter.gui.control_elements(ec).wertebereich = {1, 'max(size(d_org,2), size(d_orgs,3))'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 75];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Anzeigen
ec = ec + 1; % (33)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_ZRImagePlotClassSort';
parameter.gui.control_elements(ec).uihd_code = [11 76];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sorting classes for image plot';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.image_plot_classsort';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Bei Zeitreihenreduktion gleiche Transformationsmatrix für Datentupel verwenden
ec = ec + 1; % (52)
parameter.gui.control_elements(ec).tag = 'CE_ZR_GlTrans';
parameter.gui.control_elements(ec).uihd_code = [11 77];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Use the same transformation matrix (e.g. PCA) for time series reduction of all data points';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.gleiche_trans';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 450;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% MAKRO
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Makro_Stop_Error';
parameter.gui.control_elements(ec).uihd_code = [11 79];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'For macros: stop if error';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.makro_stop_error';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 260;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_LoadPluginStart';
parameter.gui.control_elements(ec).uihd_code = [11 80];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Load plugins at start';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.autoload_plugins';
parameter.gui.control_elements(ec).listen_werte = 'Always|Only for time series and images|Never';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 80];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% MAKRO
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_ZR_ParKorrWorkspace';
parameter.gui.control_elements(ec).uihd_code = [11 81];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Copy correlation results to workspace';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.par_korr';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 260;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% MAKRO
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_ZR_ShowFigKorr';
parameter.gui.control_elements(ec).uihd_code = [11 82];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show correlation figures';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.figures_korr';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 260;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% MAKRO
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_ZR_ShowInverseClassOrder';
parameter.gui.control_elements(ec).uihd_code = [11 83];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Inverse plot order terms';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.inverse_class_order';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 260;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Filterfrequenzen
ec = ec + 1; % (59)
parameter.gui.control_elements(ec).tag = 'CE_ZR_Filterfreq';
parameter.gui.control_elements(ec).uihd_code = [11 84];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Frequencies (FIL, Morlet spectrogram)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.filterfreq';
parameter.gui.control_elements(ec).default = '1 1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0, 'parameter.gui.zeitreihen.abtastfrequenz/2'};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 84];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Hoch-
ec = ec + 1; % (60)
parameter.gui.control_elements(ec).tag = 'CE_ZR_Filtertyp_Hoch';
parameter.gui.control_elements(ec).uihd_code = [11 85];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'High-';
parameter.gui.control_elements(ec).style = 'radiobutton';
parameter.gui.control_elements(ec).radiogroup = {'CE_ZR_Filtertyp_Hoch', 'CE_ZR_Filtertyp_Tief',  'CE_ZR_Filtertyp_Band'};
parameter.gui.control_elements(ec).radioval = 'high';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.filtertyp';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Tief-
ec = ec + 1; % (61)
parameter.gui.control_elements(ec).tag = 'CE_ZR_Filtertyp_Tief';
parameter.gui.control_elements(ec).uihd_code = [11 86];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Low-';
parameter.gui.control_elements(ec).style = 'radiobutton';
parameter.gui.control_elements(ec).radiogroup = {'CE_ZR_Filtertyp_Hoch', 'CE_ZR_Filtertyp_Tief',  'CE_ZR_Filtertyp_Band'};
parameter.gui.control_elements(ec).radioval = 'low';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.filtertyp';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Bandpass
ec = ec + 1; % (62)
parameter.gui.control_elements(ec).tag = 'CE_ZR_Filtertyp_Band';
parameter.gui.control_elements(ec).uihd_code = [11 87];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Bandpass';
parameter.gui.control_elements(ec).style = 'radiobutton';
parameter.gui.control_elements(ec).radiogroup = {'CE_ZR_Filtertyp_Hoch', 'CE_ZR_Filtertyp_Tief',  'CE_ZR_Filtertyp_Band'};
parameter.gui.control_elements(ec).radioval = 'band';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.filtertyp';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 80;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Filter
ec = ec + 1; % (63)
parameter.gui.control_elements(ec).tag = 'CE_ZR_Filter';
parameter.gui.control_elements(ec).uihd_code = [11 88];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Filter (FIL)';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.filter';
parameter.gui.control_elements(ec).listen_werte = 'Butterworth';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 88];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Filterordnung
ec = ec + 1; % (64)
parameter.gui.control_elements(ec).tag = 'CE_ZR_Filterordnung';
parameter.gui.control_elements(ec).uihd_code = [11 89];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Filter order (FIL)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.filterordnung';
parameter.gui.control_elements(ec).default = '5 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 89];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl Plugins
ec = ec + 1; % (65)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_Plugins';
parameter.gui.control_elements(ec).uihd_code = [11 90];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Selection of plugins';
parameter.gui.control_elements(ec).style = 'listbox';
parameter.gui.control_elements(ec).multilistbox = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.plugins';
parameter.gui.control_elements(ec).listen_werte = 'None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 1;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 120;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 90];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (66)
parameter.gui.control_elements(ec).tag = 'CE_Edit_Auswahl_Plugins';
parameter.gui.control_elements(ec).uihd_code = [11 91];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = '';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = '';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 2;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (67)
parameter.gui.control_elements(ec).tag = 'CE_Plugins_Text';
parameter.gui.control_elements(ec).uihd_code = [11 92];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Apply plugin combination for selected TS. Discard sub-results. The sequence can be defined by using the edit element';
parameter.gui.control_elements(ec).style = 'text';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 50;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Tau [SP]
ec = ec + 1; % (68)
parameter.gui.control_elements(ec).tag = 'CE_ZR_Tau';
parameter.gui.control_elements(ec).uihd_code = [11 93];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Time shift Tau [SP]';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.tau';
parameter.gui.control_elements(ec).default = '0 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {-Inf, 'size(d_orgs,2)'};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 93];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Abtastpunkte
ec = ec + 1; % (69)
parameter.gui.control_elements(ec).tag = 'CE_ZRAnzeige_Abtastpkt';
parameter.gui.control_elements(ec).uihd_code = [11 94];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sample points';
parameter.gui.control_elements(ec).style = 'radiobutton';
parameter.gui.control_elements(ec).radiogroup = {'CE_ZRAnzeige_Proz', 'CE_ZRAnzeige_Abtastpkt', 'CE_ZRAnzeige_Zeit','CE_ZRAnzeige_Projekt'};
parameter.gui.control_elements(ec).radioval = 'Sample points';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.anzeige';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 100;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Zeit
ec = ec + 1; % (70)
parameter.gui.control_elements(ec).tag = 'CE_ZRAnzeige_Zeit';
parameter.gui.control_elements(ec).uihd_code = [11 95];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Time [Unit]';
parameter.gui.control_elements(ec).style = 'radiobutton';
parameter.gui.control_elements(ec).radiogroup = {'CE_ZRAnzeige_Proz', 'CE_ZRAnzeige_Abtastpkt', 'CE_ZRAnzeige_Zeit','CE_ZRAnzeige_Projekt'};
parameter.gui.control_elements(ec).radioval = 'Time';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.anzeige';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 100;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Merkmalsauswahl
ec = ec + 1; % (71)
parameter.gui.control_elements(ec).tag = 'CE_Klassifikation_Merkmalsauswahl';
parameter.gui.control_elements(ec).uihd_code = [11 96];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Selection of single features';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.merkmalsauswahl';
parameter.gui.control_elements(ec).listen_werte = 'All features|Selected features|ANOVA|MANOVA|Information measure (ID3)|Classification accuracy|Fuzzy classification accuracy|Weighted fuzzy classification accuracy';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 96];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Merkmalsaggregation
ec = ec + 1; % (72)
parameter.gui.control_elements(ec).tag = 'CE_Klassifikation_Merkmalsaggregation';
parameter.gui.control_elements(ec).uihd_code = [11 97];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Feature aggregation';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.merkmalsaggregation';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'No aggregation|Discriminant analysis (DA)|DA with optimization|Principal Component Analysis (PCA)|Independent Component Analysis (ICA)|Mean value|Sum';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_reset_aggregation;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 97];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Klassifikatoren
ec = ec + 1; % (73)
parameter.gui.control_elements(ec).tag = 'CE_Klassifikation_Klassifikator';
parameter.gui.control_elements(ec).uihd_code = [11 98];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Chosen classifier';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.klassifikator';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'Bayes|Artificial Neural Networks|Support Vector Machine|k-nearest-neighbor|k-nearest-neighbor (Toolbox)|Fuzzy classifier|Decision tree|Ensemble (fitensemble)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'erzeuge_parameterstrukt;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 98];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Normierung aggregierte Merkmale
ec = ec + 1; % (74)
parameter.gui.control_elements(ec).tag = 'CE_Normierung_Aggregiert';
parameter.gui.control_elements(ec).uihd_code = [11 99];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Normalization of aggregated features';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.normierung_aggregierte_merkmale';
parameter.gui.control_elements(ec).listen_werte = 'None|Interval [0,1]|MEAN = 0, STD = 1|MEAN = 0, STD unchanged';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = 'Defined a possible normalization of aggregated features.';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 99];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Metrik Bayes-Klassifikator
ec = ec + 1; % (75)
parameter.gui.control_elements(ec).tag = 'CE_Bayes_Metrik';
parameter.gui.control_elements(ec).uihd_code = [11 100];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Metrics of Bayes classifier';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.bayes.metrik';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'Euclidean distance|Mahalanobis distance|Tatsuoka distance|Variance correction (diagonal matrix)|Mean class covariance matrix|Mean diagonal class covariance matrix';
parameter.gui.control_elements(ec).default = 3;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 100];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% k
ec = ec + 1; % (76)
parameter.gui.control_elements(ec).tag = 'CE_kNN_k';
parameter.gui.control_elements(ec).uihd_code = [11 101];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'k';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.k';
parameter.gui.control_elements(ec).default = '3 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 101];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Mehrklassenprobleme
ec = ec + 1; % (77)
parameter.gui.control_elements(ec).tag = 'CE_Klassifikation_Mehrklassen';
parameter.gui.control_elements(ec).uihd_code = [11 102];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Multi-class problems';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.mehrklassen';
parameter.gui.control_elements(ec).listen_werte = 'Pure multiclass problem|One-against-all|One-against-one|Multi-class problem with decision costs';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'erzeuge_parameterstrukt;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 102];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Kernel
ec = ec + 1; % (78)
parameter.gui.control_elements(ec).tag = 'CE_SVM_Kernel';
parameter.gui.control_elements(ec).uihd_code = [11 103];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Kernel';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.svm.kernel';
parameter.gui.control_elements(ec).listen_werte = 'gaussian|poly|polyhomog';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 103];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Ordnung Kernel
ec = ec + 1; % (79)
parameter.gui.control_elements(ec).tag = 'CE_SVM_Ordnung';
parameter.gui.control_elements(ec).uihd_code = [11 104];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Kernel order';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.svm.kerneloption';
parameter.gui.control_elements(ec).default = '1.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 104];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Strafterm Fehlklassifikation C
ec = ec + 1; % (80)
parameter.gui.control_elements(ec).tag = 'CE_SVM_Strafterm';
parameter.gui.control_elements(ec).uihd_code = [11 105];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Penalty term for misclassifications C';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.svm.c_parameter_svm';
parameter.gui.control_elements(ec).default = '1000.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1E-8 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 105];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Anzahl Ausgangsneuronen
ec = ec + 1; % (81)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Ausgang';
parameter.gui.control_elements(ec).uihd_code = [11 106];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'MLP: number of output neurons';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.ausgangsneuronen';
parameter.gui.control_elements(ec).listen_werte = 'One output neuron|One neuron per class';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 106];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Neuronales Netz: Typ
ec = ec + 1; % (82)
parameter.gui.control_elements(ec).tag = 'CE_NN_Typ';
parameter.gui.control_elements(ec).uihd_code = [11 107];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Artificial Neural Network: Type';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.typ';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'MLP|RBF|Feedforwardnet (MLP)|SOM';
parameter.gui.control_elements(ec).default = 3;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 107];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Anzahl Neuronen pro Schicht
ec = ec + 1; % (83)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Neuronen_Schicht';
parameter.gui.control_elements(ec).uihd_code = [11 108];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of neurons per layer';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.layer';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).default = '15 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 108];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Lernalgorithmus
ec = ec + 1; % (84)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Lern';
parameter.gui.control_elements(ec).uihd_code = [11 109];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'MLP: learning algorithm';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.lernalgorithmus';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).listen_werte = 'Levenberg-Marquardt (trainlm)|BFGS Quasi Newton (trainbfg)|RPROP (trainrp)|Gradient descent Backpropagation (traingd)|Adaptive Backpropagation (traingdx)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 109];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Neuronentyp Verdeckte Schicht (ACHTUNG! alter Tag-Name!!)
ec = ec + 1; % (85)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Eingangsschicht';
parameter.gui.control_elements(ec).uihd_code = [11 110];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'MLP: neuron type hidden layer';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.neuronentyp';
parameter.gui.control_elements(ec).listen_werte = 'tansig|logsig|purelin';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 110];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Eingangswichtung
ec = ec + 1; % (86)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Eingangswichtung';
parameter.gui.control_elements(ec).uihd_code = [11 111];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'MLP: input weighting';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.eingangswichtung';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'dotprod';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 111];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Eingangsfunktion
ec = ec + 1; % (87)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Eingangsfunktion';
parameter.gui.control_elements(ec).uihd_code = [11 112];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'MLP: input function';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.eingangsfunktion';
parameter.gui.control_elements(ec).listen_werte = 'netsum';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 112];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Anzahl Lernepochen
ec = ec + 1; % (88)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Lernepochen';
parameter.gui.control_elements(ec).uihd_code = [11 113];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of learning epochs';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.lernepochen';
parameter.gui.control_elements(ec).default = '20 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 113];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Zeichnen
ec = ec + 1; % (89)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Zeichnen';
parameter.gui.control_elements(ec).uihd_code = [11 114];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'MLP: plot';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.zeichnen';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% RBF: Spreizung
ec = ec + 1; % (90)
parameter.gui.control_elements(ec).tag = 'CE_RBF_Spreizung';
parameter.gui.control_elements(ec).uihd_code = [11 115];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'RBF: Spread';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.rbf.spreizung';
parameter.gui.control_elements(ec).default = '10 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).ganzzahlig = 0;
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 115];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Zeichnen
ec = ec + 1; % (89)
parameter.gui.control_elements(ec).tag = 'CE_MLP_ShowGUI';
parameter.gui.control_elements(ec).uihd_code = [11 116];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show training GUI';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.showWindow';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Kriterium für optimierte DA
ec = ec + 1; % (92)
parameter.gui.control_elements(ec).tag = 'CE_Klassifikation_OptDA';
parameter.gui.control_elements(ec).uihd_code = [11 117];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Criterion for optimized DA';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.krit_opt_da';
parameter.gui.control_elements(ec).listen_werte = 'guete_bestklass|guete_bestldf';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 100;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 117];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 125;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Normierung Merkmale
ec = ec + 1; % (93)
parameter.gui.control_elements(ec).tag = 'CE_Normierung_Merkmale';
parameter.gui.control_elements(ec).uihd_code = [11 118];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Normalization of single features';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.normierung_merkmale';
parameter.gui.control_elements(ec).listen_werte = 'None|Interval [0,1]|MEAN = 0, STD = 1|MEAN = 0, STD unchanged';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 118];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Konfusionsmatrix in Datei speichern
ec = ec + 1; % (94)
parameter.gui.control_elements(ec).tag = 'CE_Konfusion_Datei';
parameter.gui.control_elements(ec).uihd_code = [11 119];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Save confusion matrix in file';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.konf_in_datei';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Preselection Merkmale
ec = ec + 1; % (95)
parameter.gui.control_elements(ec).tag = 'CE_Klassifikation_Preselection';
parameter.gui.control_elements(ec).uihd_code = [11 120];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Preselection of features';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.preselection_merkmale';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 180;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Klassenanzeige Ausgangsgröße
ec = ec + 1; % (96)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Klassenanzeige';
parameter.gui.control_elements(ec).uihd_code = [11 121];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Display classes for output variables';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.klassifikations_ergebnis';
parameter.gui.control_elements(ec).listen_werte = 'Only learning data|Only classification|DS-No. misclassification|Class-No. misclassifications|Different output variable';
parameter.gui.control_elements(ec).default = 3;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 121];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Grafische Auswertung Klassifikationsergebnis
ec = ec + 1; % (97)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_KlassiErg';
parameter.gui.control_elements(ec).uihd_code = [11 122];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Graphical evaluation of classification results';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.konf_plot_details';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Metrik k-NN
ec = ec + 1; % (99)
parameter.gui.control_elements(ec).tag = 'CE_ScaleOptCrossCorr';
parameter.gui.control_elements(ec).uihd_code = [11 123];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Normalization for crosscorrelation';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.statistikoptionen.scaleopt_type';
parameter.gui.control_elements(ec).listen_werte = 'biased|biased_mean|biased_detrend|unbiased|unbiased_mean|unbiased_detrend|coeff|coeff_mean|coeff_detrend|none|none_mean|none_detrend|coeff_local';
parameter.gui.control_elements(ec).default = 8;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_scale_opt_crosscorr;';
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 123];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Wahrscheinlichkeiten verwenden
ec = ec + 1; % (98)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_RegrInputNormAggr';
parameter.gui.control_elements(ec).uihd_code = [11 124];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Regression visualization: Normalize and aggregate input features';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.show_normalized_and_aggregated';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 450;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Wahrscheinlichkeiten verwenden
ec = ec + 1; % (98)
parameter.gui.control_elements(ec).tag = 'CE_Bayes_Apriori';
parameter.gui.control_elements(ec).uihd_code = [11 125];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Use a priori probabilities';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.bayes.apriori';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Metrik k-NN
ec = ec + 1; % (99)
parameter.gui.control_elements(ec).tag = 'CE_kNN_Metrik';
parameter.gui.control_elements(ec).uihd_code = [11 126];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Metrics of k-NN';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.metrik';
parameter.gui.control_elements(ec).listen_werte = 'Euclidean|standardized Euklidean|Cityblock|Mahalanobis';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 126];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Größe der Region
ec = ec + 1; % (100)
parameter.gui.control_elements(ec).tag = 'CE_kNN_Region';
parameter.gui.control_elements(ec).uihd_code = [11 127];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Region size';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.groesse_region';
parameter.gui.control_elements(ec).default = '1.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 127];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Alle Nachbarn in einer Region verwenden
ec = ec + 1; % (101)
parameter.gui.control_elements(ec).tag = 'CE_kNN_AlleNachbarn';
parameter.gui.control_elements(ec).uihd_code = [11 128];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Use all neighbors in a region';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.region';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Abstandswichtung
ec = ec + 1; % (102)
parameter.gui.control_elements(ec).tag = 'CE_kNN_Wichtung';
parameter.gui.control_elements(ec).uihd_code = [11 129];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Distance weighting';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.abstandswichtung';
parameter.gui.control_elements(ec).listen_werte = 'None|Inverse linear|Inverse distance|Inverse exponential';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 129];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Varianzen normieren
ec = ec + 1; % (103)
parameter.gui.control_elements(ec).tag = 'CE_Varianzen_Normieren';
parameter.gui.control_elements(ec).uihd_code = [11 130];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Normalize standard deviations';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.varianzen_normieren';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Auf ... Merkmale reduzieren
ec = ec + 1; % (104)
parameter.gui.control_elements(ec).tag = 'CE_Anz_Hk';
parameter.gui.control_elements(ec).uihd_code = [11 131];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Reduce to ... features';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1 20};
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.anz_hk';
parameter.gui.control_elements(ec).default = '5 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 131];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Gitterpunkte für Trennfläche
ec = ec + 1; % (105)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Gitterpunkte';
parameter.gui.control_elements(ec).uihd_code = [11 132];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of grid points';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.anz_gitterpunkte';
parameter.gui.control_elements(ec).default = '100 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {10 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 132];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Trennflächen anzeigen
ec = ec + 1; % (106)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Trennflaechen';
parameter.gui.control_elements(ec).uihd_code = [11 133];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show discriminant functions';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.trennflaechen';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 180;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Triggerzeitreihe
ec = ec + 1; % (107)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Trigger';
parameter.gui.control_elements(ec).uihd_code = [11 134];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Trigger time series';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.triggerzr';
parameter.gui.control_elements(ec).listen_werte = 'Complete length';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 134];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Klassifikator-Typ
ec = ec + 1; % (108)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Typ';
parameter.gui.control_elements(ec).uihd_code = [11 135];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Classifier type';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.typ';
parameter.gui.control_elements(ec).listen_werte = 'K1|K2|K3|K4|K5|TSK-Fuzzy';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 135];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Anzahl Cluster bei TSK-Fuzzy
ec = ec + 1; % (109)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_TSK_Anz';
parameter.gui.control_elements(ec).uihd_code = [11 136];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of clusters for TSK-Fuzzy';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.anz_cluster';
parameter.gui.control_elements(ec).default = '2  3  4  5  6  7  8';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 200;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 136];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Trennflächen anzeigen
ec = ec + 1; % (106)
parameter.gui.control_elements(ec).tag = 'CE_Validierung_HeterogenDist';
parameter.gui.control_elements(ec).uihd_code = [11 137];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Validation statistics heteroegenity';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.validierung.heterogen_dist_check_cv';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 180;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse zeitlich filtern
ec = ec + 1; % (110)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Filter';
parameter.gui.control_elements(ec).uihd_code = [11 138];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Filtering of results';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.ergebnisse_filtern';
parameter.gui.control_elements(ec).listen_werte = 'No|IIR-Filter|Classification error for training data|Most frequent decision in window|IIR filter (identical weights for sample points)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 138];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Ergebniswahl für die Filterung
ec = ec + 1; % (111)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Filtererg';
parameter.gui.control_elements(ec).uihd_code = [11 139];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Results for filtering';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.ergebniswahl_filterung';
parameter.gui.control_elements(ec).listen_werte = 'Relative results (percent)|Absolute distances (md)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 139];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Parameter für IIR-Filter
ec = ec + 1; % (112)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_IIR';
parameter.gui.control_elements(ec).uihd_code = [11 140];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Parameter for IIR filter';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.iir_param';
parameter.gui.control_elements(ec).default = '0.900';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 140];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% K5: jeden x.te Abtastpunkt verwenden
ec = ec + 1; % (113)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_K5JederXTe';
parameter.gui.control_elements(ec).uihd_code = [11 141];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'K5: use each x. sample point';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.x_abtast';
parameter.gui.control_elements(ec).default = '10 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 141];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% ZR-Relevanzen zeitl. gewichten
ec = ec + 1; % (114)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Rel_gewichten';
parameter.gui.control_elements(ec).uihd_code = [11 142];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Time-weighting of time series relevances';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.relevanzen_gewichten';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 220;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Wavelets: Anzahl Level
ec = ec + 1; % (115)
parameter.gui.control_elements(ec).tag = 'CE_Wavelets_Level';
parameter.gui.control_elements(ec).uihd_code = [11 143];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Wavelets: number of levels';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.wavelets.max_level';
parameter.gui.control_elements(ec).default = '4 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 143];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Wavelet
ec = ec + 1; % (116)
parameter.gui.control_elements(ec).tag = 'CE_Wavelets_Wavelet';
parameter.gui.control_elements(ec).uihd_code = [11 144];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Wavelet';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.wavelets.typ';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).listen_werte = 'db1|db2|db3|db4|db5|db6|db7|db8|db9|db10|sym1|sym2|sym3|sym4|sym5|sym6|sym7|sym8|sym9|sym10|coif1|coif2|coif3|coif4|coif5';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 144];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Morlet-Wavelet: Frequenz
ec = ec + 1; % (117)
parameter.gui.control_elements(ec).tag = 'CE_MorletWavelet_Freq';
parameter.gui.control_elements(ec).uihd_code = [11 145];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Morlet wavelet: frequency';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.wavelets.morlet.f';
parameter.gui.control_elements(ec).default = '10.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0.0000001 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 145];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Morlet-Wavelet: Eigenfrequenz
ec = ec + 1; % (118)
parameter.gui.control_elements(ec).tag = 'CE_MorletWavelet_Eigenfreq';
parameter.gui.control_elements(ec).uihd_code = [11 146];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Morlet wavelet: eigenfrequency';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.wavelets.morlet.w0';
parameter.gui.control_elements(ec).default = '10 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 146];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Kausales Morlet-Wavelet
ec = ec + 1; % (119)
parameter.gui.control_elements(ec).tag = 'CE_MorletWavelet_Kausal';
parameter.gui.control_elements(ec).uihd_code = [11 147];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Causal Morlet wavelet';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.wavelets.morlet.kausal';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 200;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Cluster-ZGH anzeigen
ec = ec + 1; % (120)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_TSK_ZGH';
parameter.gui.control_elements(ec).uihd_code = [11 148];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show cluster memberships';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.anzeige_cluster_zgh';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 180;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Automatisch (empfohlen für Wurzel- oder Exp-Kennlinie!)
ec = ec + 1; % (121)
parameter.gui.control_elements(ec).tag = 'CE_ZRAnzeige_CAxis';
parameter.gui.control_elements(ec).uihd_code = [11 149];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Automatic (esp. for root and exponential)';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.caxis';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 300;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Matlab-Waveletdekomposition
ec = ec + 1; % (122)
parameter.gui.control_elements(ec).tag = 'CE_Wavelets_MatlabWavelet';
parameter.gui.control_elements(ec).uihd_code = [11 150];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Matlab wavelet decomposition';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.wavelets.matlab_wavedec';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 200;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl Ausgangsgröße
ec = ec + 1; % (9)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_CVOutputSelect';
parameter.gui.control_elements(ec).uihd_code = [11 151];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Crossvalidation (separated by values of output variable)';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.validierung.cvoutputselect';
parameter.gui.control_elements(ec).listen_werte = 'None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 151];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl Ausgangsgröße
ec = ec + 1; % (9)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_DifferentClass';
parameter.gui.control_elements(ec).uihd_code = [11 152];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Different output variable';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.different_class';
parameter.gui.control_elements(ec).listen_werte = 'None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 152];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Mindestanzahl an Nachbarn prüfen
ec = ec + 1; % (125)
parameter.gui.control_elements(ec).tag = 'CE_kNN_NachbarnPruefen';
parameter.gui.control_elements(ec).uihd_code = [11 153];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Evaluate minimum number of neighbors';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.max_abstand_schalter';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% max. Abstand
ec = ec + 1; % (126)
parameter.gui.control_elements(ec).tag = 'CE_kNN_MaxAbstand';
parameter.gui.control_elements(ec).uihd_code = [11 154];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Max. distance';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.max_abstand';
parameter.gui.control_elements(ec).default = '1.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 154];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Mindestanzahl an Nachbarn innerhalb max. Abstand
ec = ec + 1; % (127)
parameter.gui.control_elements(ec).tag = 'CE_kNN_Mindestzahl_Nachbarn';
parameter.gui.control_elements(ec).uihd_code = [11 155];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Minimum neighbor number in max. distance';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.knn.max_abstand_anz';
parameter.gui.control_elements(ec).default = '2 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 155];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Schwellwert für Fuzzy-Cluster
ec = ec + 1; % (128)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_TSK_Schwellwert';
parameter.gui.control_elements(ec).uihd_code = [11 156];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Threshold for fuzzy cluster';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.schwell_max_fuzzy_cluster';
parameter.gui.control_elements(ec).default = '0.600';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 156];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Morlet-Spektrogramm relativ zu Baseline
ec = ec + 1; % (129)
parameter.gui.control_elements(ec).tag = 'CE_MorletSpekt_Relativ';
parameter.gui.control_elements(ec).uihd_code = [11 157];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Morlet spectrogram (relative to baseline)';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.relativ_zur_baseline';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 280;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Abtastpunkte Baseline
ec = ec + 1; % (130)
parameter.gui.control_elements(ec).tag = 'CE_MorletSpekt_Baseline';
parameter.gui.control_elements(ec).uihd_code = [11 158];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sample points baseline';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.samples_baseline';
parameter.gui.control_elements(ec).default = '1 100';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 158];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Reduktion Abtastpunkte Morlet-Spektrogramm
ec = ec + 1; % (131)
parameter.gui.control_elements(ec).tag = 'CE_Zeitreihen_RedAbtast';
parameter.gui.control_elements(ec).uihd_code = [11 159];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Reduce sampling points for Morlet spectrogram';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.red_sample';
parameter.gui.control_elements(ec).default = '3 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 159];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (133)
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_RuleBaseSearch';
parameter.gui.control_elements(ec).uihd_code = [11 160];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Looking for cooperating rules from rulebase';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.rulebase_search';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%
ec = ec + 1; % (133)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_RelSelFeat';
parameter.gui.control_elements(ec).uihd_code = [11 161];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Evaluate only selected single features';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.relevances_for_selected_features';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Strafterm Lambda (bei weichen Grenzen)
ec = ec + 1; % (132)
parameter.gui.control_elements(ec).tag = 'CE_OneClass_Strafterm';
parameter.gui.control_elements(ec).uihd_code = [11 163];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Penalty term Lambda (for soft limits)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.lambda';
parameter.gui.control_elements(ec).default = '10 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1E-8 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 163];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;



%%%%%%%%%%%%%%%%%%%%%%%
% Cityblock-Distanz verwenden
ec = ec + 1; % (133)
parameter.gui.control_elements(ec).tag = 'CE_Corr_Bonferroni';
parameter.gui.control_elements(ec).uihd_code = [11 164];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Bonferroni correction';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.statistikoptionen.bonferroni';
parameter.gui.control_elements(ec).listen_werte = 'none|Bonferroni|Bonferroni-Holm';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'parameter.gui.statistikoptionen.bonferroni = max(1,parameter.gui.statistikoptionen.bonferroni)';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 164];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Cityblock-Distanz verwenden
ec = ec + 1; % (133)
parameter.gui.control_elements(ec).tag = 'CE_OneClass_Cityblock';
parameter.gui.control_elements(ec).uihd_code = [11 165];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Use cityblock distance';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.cityblock';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Klassengrenzen bestimmen
ec = ec + 1; % (134)
parameter.gui.control_elements(ec).tag = 'CE_OneClass_HartWeich';
parameter.gui.control_elements(ec).uihd_code = [11 166];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Compute class discriminant functions';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.grenzen';
parameter.gui.control_elements(ec).listen_werte = 'Hard limits|Soft limits';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 166];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Anzeige
ec = ec + 1; % (135)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Ausreisser';
parameter.gui.control_elements(ec).uihd_code = [11 167];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show outlier detection';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.anzeige';
parameter.gui.control_elements(ec).listen_werte = 'None|only result|Result with contour plot|only discriminant functions';
parameter.gui.control_elements(ec).default = 3;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 167];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Schwelle für Ausreißer
ec = ec + 1; % (136)
parameter.gui.control_elements(ec).tag = 'CE_Ausreisser_Schwelle';
parameter.gui.control_elements(ec).uihd_code = [11 168];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Threshold for outliers';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.schwelle';
parameter.gui.control_elements(ec).default = '0.000';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 168];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Verfahren
ec = ec + 1; % (137)
parameter.gui.control_elements(ec).tag = 'CE_Ausreisser_Verfahren';
parameter.gui.control_elements(ec).uihd_code = [11 169];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Method';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.verfahren';
parameter.gui.control_elements(ec).listen_werte = 'One-class|Distance based|Density based';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 169];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Morlet-Spektrogramm: Frequenz-Schrittweite
ec = ec + 1; % (138)
parameter.gui.control_elements(ec).tag = 'CE_MorletSpekt_FreqSchritt';
parameter.gui.control_elements(ec).uihd_code = [11 170];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Morlet spectrogram: Frequency stepwidth';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.wavelets.morlet.spektrogramm_schrittweite';
parameter.gui.control_elements(ec).default = '1 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 170];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnis in Ausgangsgröße Klasse speichern
ec = ec + 1; % (139)
parameter.gui.control_elements(ec).tag = 'CE_Ausreisser_InKlasse';
parameter.gui.control_elements(ec).uihd_code = [11 171];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Save result as output variable';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.speichern_in_klasse';
parameter.gui.control_elements(ec).listen_werte = 'No|New output variable|Replace identical output variable';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 171];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Datentupel manuell entfernen
ec = ec + 1; % (140)
parameter.gui.control_elements(ec).tag = 'CE_Ausreisser_Manuell';
parameter.gui.control_elements(ec).uihd_code = [11 172];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Manual selection of outliers';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.ausreisser.manuell_entfernen';
parameter.gui.control_elements(ec).wertebereich = {1, 'size(d_orgs,1)'};
parameter.gui.control_elements(ec).default = '';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 200;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 172];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Zeitliche Aggregation: Fenstergröße
ec = ec + 1; % (141)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Aggregation_Groesse';
parameter.gui.control_elements(ec).uihd_code = [11 173];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Temporal aggregation: Window length';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.fenstergroesse';
parameter.gui.control_elements(ec).default = '20 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 'par.laenge_zeitreihe/10'};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 173];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Zeitliche Aggregation der Merkmale
ec = ec + 1; % (142)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Aggregation';
parameter.gui.control_elements(ec).uihd_code = [11 174];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Temporal aggregation of features';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.aggregation_verfahren';
parameter.gui.control_elements(ec).listen_werte = 'No|Mean value|Minimum|Maximum|ROM';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 174];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Zeitliche Aggregation: Schrittweite
ec = ec + 1; % (143)
parameter.gui.control_elements(ec).tag = 'CE_ZRKlassi_Aggregation_Schritt';
parameter.gui.control_elements(ec).uihd_code = [11 175];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Temporal aggregation: Step width';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.zr_klassifikation.fenster_schrittweite';
parameter.gui.control_elements(ec).default = '1 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 175];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% SVM-internes one-against-one oder one-against-all verwenden
ec = ec + 1; % (144)
parameter.gui.control_elements(ec).tag = 'CE_SVM_intern_oax';
parameter.gui.control_elements(ec).uihd_code = [11 176];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Use SVM-internal one-against-one or one-against-all';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.svm.internes_oax';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 350;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% ALLE (Button des ZR-Auswahl Editfeldes)
ec = ec + 1; % (145)
parameter.gui.control_elements(ec).tag = 'CE_Alle_ZR';
parameter.gui.control_elements(ec).uihd_code = [12 15];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'ALL';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).userdata = 'ignore';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'set(uihd(11,13),''value'',[1:size(d_orgs,3)]);eval(get(uihd(11,13),''callback''));';
parameter.gui.control_elements(ec).breite = 70;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% ALLE (Button des EM-Auswahl Editfeldes)
ec = ec + 1; % (146)
parameter.gui.control_elements(ec).tag = 'CE_Alle_EM';
parameter.gui.control_elements(ec).uihd_code = [12 16];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'ALL';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).userdata = 'ignore';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'set(uihd(11,14),''value'',[1:size(d_orgs,3)]);eval(get(uihd(11,14),''callback''));';
parameter.gui.control_elements(ec).breite = 70;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Projektübersicht
ec = ec + 1; % (147)
parameter.gui.control_elements(ec).tag = 'CE_Projektuebersicht';
parameter.gui.control_elements(ec).uihd_code = [11 177];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Project overview';
parameter.gui.control_elements(ec).style = 'text';
parameter.gui.control_elements(ec).variable = 'parameter.gui.projektuebersicht.text';
parameter.gui.control_elements(ec).nicht_speichern = 1;
parameter.gui.control_elements(ec).default = '';
parameter.gui.control_elements(ec).userdata = 'ignore';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 630;
parameter.gui.control_elements(ec).hoehe = 440;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Tooltips anzeigen
ec = ec + 1; % (148)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Tooltips';
parameter.gui.control_elements(ec).uihd_code = [11 178];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show tool tips';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.tooltips_anzeigen';
parameter.gui.control_elements(ec).nicht_speichern = 0;
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).userdata = '';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'switch_tooltips(parameter.gui.anzeige.tooltips_anzeigen, parameter.gui.control_elements);';
parameter.gui.control_elements(ec).breite = 200;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Hauptkomponenten für ICA
ec = ec + 1; % (149)
parameter.gui.control_elements(ec).tag = 'CE_ICA_Hauptkomponenten';
parameter.gui.control_elements(ec).uihd_code = [11 179];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Principal components for ICA';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1 20};
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.hka_ica';
parameter.gui.control_elements(ec).nicht_speichern = 0;
parameter.gui.control_elements(ec).default = 5;
parameter.gui.control_elements(ec).userdata = '';
parameter.gui.control_elements(ec).tooltext = [];
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 179];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 200;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% max. Abstand
ec = ec + 1; % (150)
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_Entscheidungsbaum';
parameter.gui.control_elements(ec).uihd_code = [11 180];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Type of decision tree';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'ID3 (without correction)|C4.5 (without correction)|ID3 (with correction)|C4.5 (with correction)';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.dectree.baumtyp';
parameter.gui.control_elements(ec).default = 3;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 180];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Cluster - Anzahl Cluster
ec = ec + 1; % (151)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_AnzCluster';
parameter.gui.control_elements(ec).uihd_code = [11 181];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of clusters';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.anzahl_cluster';
parameter.gui.control_elements(ec).default = '2';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {2, Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 181];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Cluster - Iterationsschritte
ec = ec + 1; % (152)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_AnzSchritte';
parameter.gui.control_elements(ec).uihd_code = [11 182];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Iteration steps';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.iterationsschritte';
parameter.gui.control_elements(ec).default = '50';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1, Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 182];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Cluster
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Abtandsmass';
parameter.gui.control_elements(ec).uihd_code = [11 183];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Distance measure';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.abstandsmass';
parameter.gui.control_elements(ec).listen_werte = 'Euclidean distance|Variance correction (diagonal matrix)|Mahalanobis distance|Gustafson-Kessel|Gath Geva|Simplified Gustafson-Kessel (diagonal)|Variance normalization for time series (HD)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 183];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Cluster
ec = ec + 1; % (154)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Startzentren';
parameter.gui.control_elements(ec).uihd_code = [11 184];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Compute start prototypes for clusters';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.clusterstartzentren';
parameter.gui.control_elements(ec).listen_werte = 'Equally distributed|random start cluster|random data points|Data points from GUI';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 184];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Cluster
ec = ec + 1; % (155)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Anhaengen';
parameter.gui.control_elements(ec).uihd_code = [11 185];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Append cluster as output variable';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.clusterausgangsgroesseanhaengen';
parameter.gui.control_elements(ec).listen_werte = 'Always|New cluster number|Never';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 185];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Cluster
ec = ec + 1; % (156)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Video';
parameter.gui.control_elements(ec).uihd_code = [11 186];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Video';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.video';
parameter.gui.control_elements(ec).listen_werte = 'off|On (without breaks)|On (with breaks)|On (key pressed)';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 186];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Cluster
ec = ec + 1; % (157)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_OrigZR';
parameter.gui.control_elements(ec).uihd_code = [11 187];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Plot original TS';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.zeichnenorgzr';
parameter.gui.control_elements(ec).listen_werte = 'All time series|Mean values|None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 187];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Checkbox für unbegrenzte Iterationsschritte
ec = ec + 1; % (158)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_UnendlichSchritte';
parameter.gui.control_elements(ec).uihd_code = [11 188];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Unlimited iteration steps';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.iterationunbegrenzt';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Cluster - Merkmalsklassen
ec = ec + 1; % (159)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Merkmalsklassen';
parameter.gui.control_elements(ec).uihd_code = [11 189];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Feature classes';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.merkmalsklassen';
parameter.gui.control_elements(ec).listen_werte = 'Time series (TS)|Single features|Both simultaneously|Both subsequently';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 189];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_AnzLingTerme';
parameter.gui.control_elements(ec).uihd_code = [11 190];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of linguistic terms';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.anz_fuzzy';
parameter.gui.control_elements(ec).default = '5 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {2 20};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 190];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_TypeZGF';
parameter.gui.control_elements(ec).uihd_code = [11 191];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Type of membership function';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.type_zgf';
parameter.gui.control_elements(ec).listen_werte = 'Median (with interpretability)|Median (without interpretability)|Equal distribution|Clustering|Clustering (with interpretability)|Fix';
parameter.gui.control_elements(ec).default = 4;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_control_fixmbf;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 191];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_Inferenz';
parameter.gui.control_elements(ec).uihd_code = [11 192];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Inference';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.inferenz';
parameter.gui.control_elements(ec).listen_werte = 'SUM-PROD (with overlap correction)|SUM-PROD|MAX-MIN';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 192];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_Baum_klassenspezifisch';
parameter.gui.control_elements(ec).uihd_code = [11 193];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'One-against-all-trees';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.dectree.klassen_spezifisch';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_Klarheit';
parameter.gui.control_elements(ec).uihd_code = [11 194];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Exponent for clearness';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.faktor';
parameter.gui.control_elements(ec).default = '10 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 100};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 194];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Normdaten';
parameter.gui.control_elements(ec).uihd_code = [11 2];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show normative data';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.anzeige_normdaten';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Merkmalsrelevanzen
ec = ec + 1; % (3)
parameter.gui.control_elements(ec).tag = 'CE_A_Priori';
parameter.gui.control_elements(ec).uihd_code = [11 5];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'A priori feature relevances';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.a_priori_relevanzen';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode=0;callback_apriori_edit;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Merkmalsrelevanzen
ec = ec + 1; % (3)
parameter.gui.control_elements(ec).tag = 'CE_A_Priori_Alpha';
parameter.gui.control_elements(ec).uihd_code = [11 201];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Preference exponent alpha (Interpretability)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.a_priori_relevanzen_alpha';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode=0;callback_apriori_edit;';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 201];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Merkmalsrelevanzen
ec = ec + 1; % (3)
parameter.gui.control_elements(ec).tag = 'CE_A_Priori_Beta';
parameter.gui.control_elements(ec).uihd_code = [11 202];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Preference exponent beta (Implementability)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.a_priori_relevanzen_beta';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode=0;callback_apriori_edit;';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 202];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% A-Priori-Merkmalsrelevanzen
ec = ec + 1; % (3)
parameter.gui.control_elements(ec).tag = 'CE_A_Priori_BestimmterWert';
parameter.gui.control_elements(ec).uihd_code = [11 203];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'A priori feature relevances (fix value)';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmale_und_klassen.bestimmter_wert';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 203];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Method';
parameter.gui.control_elements(ec).uihd_code = [11 205];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Distance measure for the noise cluster';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.noise_cluster_method';
parameter.gui.control_elements(ec).listen_werte = 'None|Median distance|Mean value of distances';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 205];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1; % (3)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Factor';
parameter.gui.control_elements(ec).uihd_code = [11 206];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Factor for the distance to the noise cluster';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.noise_cluster_factor';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).wertebereich = {1E-10 Inf};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 206];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;



%%%%%%%%%%%%%%%%%%%%%%%
% Normdaten in den Vordergrund
ec = ec + 1; % (53)
parameter.gui.control_elements(ec).tag = 'CE_Normdaten_Vordergrund';
parameter.gui.control_elements(ec).uihd_code = [11 78];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Normative data in foreground';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.ganganalyse.normdaten_vordergrund';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];



%%%%%%%%%%%%%%%%%%%%%%%
% Optionen beim Speichern sichern
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Optionen_Speichern';
parameter.gui.control_elements(ec).uihd_code = [11 195];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Save options by saving the project';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.optionen_speichern';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Rückstufung korrelierter Einzelmerkmale
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Klassifikation_Rueckstufung';
parameter.gui.control_elements(ec).uihd_code = [11 196];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Downgrading of correlated single features';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.rueckstufung_em';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Anzeigen
ec = ec + 1; % (33)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Phasengang';
parameter.gui.control_elements(ec).uihd_code = [11 207];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show phase response';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.phasengang';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1; % (3)
parameter.gui.control_elements(ec).tag = 'CE_PCA_Spektrogramm';
parameter.gui.control_elements(ec).uihd_code = [11 208];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of principal components for spectrogram';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.num_pca_spect';
parameter.gui.control_elements(ec).default = 3;
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 208];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Anzeigen
ec = ec + 1; % (33)
parameter.gui.control_elements(ec).tag = 'CE_Show_ShortProtocol';
parameter.gui.control_elements(ec).uihd_code = [11 209];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show short protocol';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.short_protocol';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Merkmalsklasse
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_ZREM';
parameter.gui.control_elements(ec).uihd_code = [11 210];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Feature type (input)';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.merkmalsklassen';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).listen_werte = 'Time series (TS)|Single features';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'aktualisiere_regressions_output;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 210];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Merkmalsauswahl
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Merkmalsauswahl';
parameter.gui.control_elements(ec).uihd_code = [11 212];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Feature selection';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.merkmalsauswahl';
parameter.gui.control_elements(ec).save_as_string = 0;
parameter.gui.control_elements(ec).listen_werte = 'All features|Selected features|Linear regression coefficients (univariate, all features)|Linear regression coefficients (univariate, selected features)|Linear regression coefficients (multivariate, all features)|Linear regression coefficients (multivariate, selected features)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 400;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 212];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Output
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Output';
parameter.gui.control_elements(ec).uihd_code = [11 213];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Output variable of regression';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.output';
parameter.gui.control_elements(ec).save_as_string = 0;
parameter.gui.control_elements(ec).listen_werte = '---';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 213];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Typ
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Typ';
parameter.gui.control_elements(ec).uihd_code = [11 214];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Type';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.typ';
parameter.gui.control_elements(ec).save_as_string = 0;
parameter.gui.control_elements(ec).listen_werte = 'Polynom|Artificial Neural Networks|k-nearest-neighbor|Curve fit (MATLAB)|Fuzzy system';
if exist('LMNTrain.m','file')
    parameter.gui.control_elements(ec).listen_werte = [parameter.gui.control_elements(ec).listen_werte '|Lolimot'];
end;
if exist('vsa_en.m','file') && exist('vsa_an.m','file')
    parameter.gui.control_elements(ec).listen_werte = [parameter.gui.control_elements(ec).listen_werte '|Virtual Storage A (energy package)'];
end;
if exist('vsb_en.m','file') && exist('vsb_an.m','file')
    parameter.gui.control_elements(ec).listen_werte = [parameter.gui.control_elements(ec).listen_werte '|Virtual Storage B (energy package)'];
end;
if exist('vsc_en.m','file') && exist('vsc_an.m','file')
    parameter.gui.control_elements(ec).listen_werte = [parameter.gui.control_elements(ec).listen_werte '|Virtual Storage C (energy package)'];
end;
if exist('arx_en.m','file') && exist('arx_an.m','file')
    parameter.gui.control_elements(ec).listen_werte = [parameter.gui.control_elements(ec).listen_werte '|ARX (energy package)'];
end;
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 214];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Normierung Merkmale
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Normierung_Merkmale';
parameter.gui.control_elements(ec).uihd_code = [11 215];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Normalization';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.normierung';
parameter.gui.control_elements(ec).listen_werte = 'None|Interval [0,1]|MEAN = 0, STD = 1|MEAN = 0, STD unchanged';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 215];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Merkmalsaggregation
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Merkmalsaggregation';
parameter.gui.control_elements(ec).uihd_code = [11 216];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Feature aggregation';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.merkmalsaggregation';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'No aggregation|Principal Component Analysis (PCA)|Mean value|Sum';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_reset_aggregation_regr;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 216];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression: Anzahl aggregierter Merkmale
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Anzahl_Aggregiert';
parameter.gui.control_elements(ec).uihd_code = [11 217];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of aggregated features';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.anz_hk';
parameter.gui.control_elements(ec).default = '2 ';
parameter.gui.control_elements(ec).wertebereich = {1, 'max(size(d_org,2), size(d_orgs,3))'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 217];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression: Grad des Polynoms
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Regression_GradPolynom';
parameter.gui.control_elements(ec).uihd_code = [11 218];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Polynomial degree';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.poly_degree';
parameter.gui.control_elements(ec).default = '1';
parameter.gui.control_elements(ec).wertebereich = {1, 100};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 218];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression: Abtastpunkte bei Zeitreihe
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Regression_Abtastpunkte';
parameter.gui.control_elements(ec).uihd_code = [11 219];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sample points';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.sample_points';
parameter.gui.control_elements(ec).default = '-10:0';
parameter.gui.control_elements(ec).wertebereich = {'-par.laenge_zeitreihe', 0};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'parameter.gui.regression.sample_points=unique(parameter.gui.regression.sample_points);inGUIIndx=''CE_Regression_Abtastpunkte'';inGUI;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 219];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression: Anzahl auszuwählender Merkmale
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Regression_AnzahlMerkmale';
parameter.gui.control_elements(ec).uihd_code = [11 220];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of selected features';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.max_number_of_raw_features';
parameter.gui.control_elements(ec).default = '4';
parameter.gui.control_elements(ec).wertebereich = {'1', 'max(par.anz_merk, par.anz_einzel_merk)'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 220];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression: Anzahl auszuwählender Merkmale
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Regression_AnzahlPolyMerkmale';
parameter.gui.control_elements(ec).uihd_code = [11 221];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Maximal number of internal features';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.max_number_of_poly_features';
parameter.gui.control_elements(ec).default = '4';
parameter.gui.control_elements(ec).wertebereich = {'1', 'Inf'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 221];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Normierung aggregierte Merkmale
ec = ec + 1; % (74)
parameter.gui.control_elements(ec).tag = 'CE_Normierung_Aggregiert_Regr';
parameter.gui.control_elements(ec).uihd_code = [11 222];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Normalization of aggregated features';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.normierung_aggregierte_merkmale';
parameter.gui.control_elements(ec).listen_werte = 'None|Interval [0,1]|MEAN = 0, STD = 1|MEAN = 0, STD unchanged';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = 'Defined a possible normalization of aggregated features.';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 222];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Klassifikatoren
ec = ec + 1; % (73)
parameter.gui.control_elements(ec).tag = 'CE_Spezielle_Verfahren';
parameter.gui.control_elements(ec).uihd_code = [11 223];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Method';
parameter.gui.control_elements(ec).variable = 'parameter.gui.verfahren.type';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'Bayes|Artificial Neural Networks|Support Vector Machine|k-nearest-neighbor|k-nearest-neighbor (Toolbox)|Fuzzy classifier|Decision tree|Polynom|Curve fit (MATLAB)|Association analysis';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 223];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Regression, Merkmalsaggregation
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Allgemein_FileTypeImage';
parameter.gui.control_elements(ec).uihd_code = [11 224];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'File type for images';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.file_type_image';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).listen_werte = 'bmp|eps|epsc|epsc2|jpeg|png|tiff|tiffnocompression|pdf';
parameter.gui.control_elements(ec).save_as_string = 1;
parameter.gui.control_elements(ec).default = 4;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 216];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% Tooltips anzeigen
ec = ec + 1; % (148)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Menutips';
parameter.gui.control_elements(ec).uihd_code = [11 225];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show menu tips';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.kontexthilfe';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).userdata = '';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 200;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

ec = ec + 1; % (67)
parameter.gui.control_elements(ec).tag = 'CE_Menu_Text';
parameter.gui.control_elements(ec).uihd_code = [11 226];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = '';
parameter.gui.control_elements(ec).style = 'text';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
%auf Fensterbreite ziehen
temp = get(1,'position');
parameter.gui.control_elements(ec).breite = temp(3)-60;
parameter.gui.control_elements(ec).hoehe = 180;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Cluster
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_Cluster_Fusionierung';
parameter.gui.control_elements(ec).uihd_code = [11 227];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Fusion algorithm (Statistic Toolbox only)';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.clustern.fusion';
parameter.gui.control_elements(ec).listen_werte = 'Single-Linkage|Complete-Linkage|Average-Linkage|Centroid|Ward';
parameter.gui.control_elements(ec).default = 3;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 227];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Fensterbreite
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_Umwandeln_Fensterbreite';
parameter.gui.control_elements(ec).uihd_code = [11 228];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Shortening of time series: Window length or x-th sample point';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.kuerzen_fensterbreite';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).default = '2';
parameter.gui.control_elements(ec).wertebereich = {'2', 'floor(size(d_orgs,2)/2)'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 228];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 25;
%%%%%%%%%%%%%%%%%%%%%%%
% Verfahren
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_Umwandeln_Verfahren';
parameter.gui.control_elements(ec).uihd_code = [11 229];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Shortening of time series: method';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.kuerzen_verfahren';
parameter.gui.control_elements(ec).listen_werte = 'Mean value|Minimum|Maximum|Median';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 229];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
% Verfahren
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_Umwandeln_NormierteLaenge';
parameter.gui.control_elements(ec).uihd_code = [11 230];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Match time series length to:';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.kuerzen_normiertelaenge';
parameter.gui.control_elements(ec).listen_werte = 'Shortest time series|Percent (1-100 Sample points)|Per thousand (1-1000 Sample points)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 230];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (83)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Errorgoal';
parameter.gui.control_elements(ec).uihd_code = [11 231];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Error goal';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.goal';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 0;
parameter.gui.control_elements(ec).default = '0';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 231];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Anzahl Neuronen pro Schicht
ec = ec + 1; % (83)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Internal_Stepwidth';
parameter.gui.control_elements(ec).uihd_code = [11 232];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'MLP: Visualization step width';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.internal_stepwidth';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).default = '10 ';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 232];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Zeit
ec = ec + 1; % (70)
parameter.gui.control_elements(ec).tag = 'CE_ZRAnzeige_Projekt';
parameter.gui.control_elements(ec).uihd_code = [11 233];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Project-specific';
parameter.gui.control_elements(ec).style = 'radiobutton';
parameter.gui.control_elements(ec).radiogroup = {'CE_ZRAnzeige_Proz', 'CE_ZRAnzeige_Abtastpkt', 'CE_ZRAnzeige_Zeit','CE_ZRAnzeige_Projekt'};
parameter.gui.control_elements(ec).radioval = 'Project';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.anzeige';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 100;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
%%%%%%%%%%%%%%%%%%%%%%%
% Verfahren
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_ZRAnzeige_Log';
parameter.gui.control_elements(ec).uihd_code = [11 234];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Logarithmic visualization';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.log';
parameter.gui.control_elements(ec).listen_werte = 'None|only t-axis|only y-axis|t- and y-axes';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 234];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Select_DataPoints';
parameter.gui.control_elements(ec).uihd_code = [11 235];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Manual selection of data points';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.datentupel';
parameter.gui.control_elements(ec).default = '1';
parameter.gui.control_elements(ec).wertebereich = {1,'par.anz_dat'};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'parameter.gui.allgemein.datentupel=unique(parameter.gui.allgemein.datentupel);inGUIIndx=''CE_Select_DataPoints'';inGUI;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 235];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_FFT_AnzFreq';
parameter.gui.control_elements(ec).uihd_code = [11 236];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of dominant frequencies for visualization';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.ffthitliste';
parameter.gui.control_elements(ec).default = '20';
parameter.gui.control_elements(ec).wertebereich = {1,NaN};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 236];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Savemode';
parameter.gui.control_elements(ec).uihd_code = [11 237];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Save mode for MATLAB file';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.save_mode_matlab_version';
parameter.gui.control_elements(ec).listen_werte =      'Standard|-V6|-V7|-V7.3';
parameter.gui.allgemein.liste_save_mode_matlab_version={'','-V6','-V7','-V7.3'};
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_savemode;';
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 237];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_FilePlugins';
parameter.gui.control_elements(ec).uihd_code = [11 238];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Data-dependent feature extraction in plugins';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.zeitreihen.plugin_features_design';
parameter.gui.control_elements(ec).listen_werte =      'compute only|compute and save|load';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 238];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_UsrDefCol';
parameter.gui.control_elements(ec).uihd_code = [11 239];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'User-defined colors';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.user_defined_color';
parameter.gui.control_elements(ec).default = 'bgrcmyk';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 239];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%
ec = ec + 1; % (51)
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_UsrDefSym';
parameter.gui.control_elements(ec).uihd_code = [11 240];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'User-defined symbols';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.user_defined_symbol';
parameter.gui.control_elements(ec).default = '.ox+*sdv^<>ph';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 240];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

% Verfahren
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_Plugins_Anzeige';
parameter.gui.control_elements(ec).uihd_code = [11 241];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show plugins';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.anzeige_plugins';
parameter.gui.control_elements(ec).listen_werte = 'All|Time series->Time series resp. Single features|Image->Image|XPIWIT';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_anz = 1;mode_selection = 0;callback_anzeige_plugins;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 241];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListAdd';
parameter.gui.control_elements(ec).uihd_code = [11 242];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Add';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 3;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListDel';
parameter.gui.control_elements(ec).uihd_code = [11 243];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Delete';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 4;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListUp';
parameter.gui.control_elements(ec).uihd_code = [11 244];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Forward';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 5;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListDown';
parameter.gui.control_elements(ec).uihd_code = [11 245];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Down';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 6;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl Plugins
ec = ec + 1; % (65)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_PluginsList';
parameter.gui.control_elements(ec).uihd_code = [11 246];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Selected plugin sequence';
parameter.gui.control_elements(ec).style = 'listbox';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).listen_werte = '';
parameter.gui.control_elements(ec).multilistbox = 1;
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_commandline = 1; plugins.sequence_field = 1;callback_check_commandline;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 170;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 246];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec + 1; % (6)
parameter.gui.control_elements(ec).tag = 'CE_Auswahl_PluginsCommandLine';
parameter.gui.control_elements(ec).uihd_code = [11 247];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Plugin parameter';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.plug_commandline';
parameter.gui.control_elements(ec).default = '';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_save_commandline_val;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 247];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.tag = 'CE_Auswahl_PluginsCommandLineName';

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListDelAll';
parameter.gui.control_elements(ec).uihd_code = [11 248];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Delete all';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 7;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListLoad';
parameter.gui.control_elements(ec).uihd_code = [11 249];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Load';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 8;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListSave';
parameter.gui.control_elements(ec).uihd_code = [11 250];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Save';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'mode_multi_plugin = 9;callback_auswahl_multi_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
% Verfahren
ec = ec + 1; % (153)
parameter.gui.control_elements(ec).tag = 'CE_Plugins_ParameterNumber';
parameter.gui.control_elements(ec).uihd_code = [11 251];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'No.';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.plug_par_number';
parameter.gui.control_elements(ec).listen_werte = 'None';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_plugin_par_number;';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 251];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 20;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.tag = 'CE_Plugins_ParameterNumberPush';
%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_Plugins_IgnoreIntermediates';
parameter.gui.control_elements(ec).uihd_code = [11 252];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show results';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.ignore_intermediates';
parameter.gui.control_elements(ec).listen_werte = 'Save final result|Show final result|Show and save final result|Save intermediate and final results|Show intermediate and final results|Show and save intermediate and final results';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 252];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 110;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_Plugins_PerformanceLogSettings';
parameter.gui.control_elements(ec).uihd_code = [11 300];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Save performance log file';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.performance_log_settings';
parameter.gui.control_elements(ec).listen_werte = 'Never|Save computing times|Save total time';
parameter.gui.control_elements(ec).default = 2;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 300];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 210;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListUpdate';
parameter.gui.control_elements(ec).uihd_code = [11 253];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Update plugins';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'parameter.allgemein.no_update_reading = 0;callback_update_plugins;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListExec';
parameter.gui.control_elements(ec).uihd_code = [11 254];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Execute';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_button_plugseq;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_NumberRulesRulebase';
parameter.gui.control_elements(ec).uihd_code = [11 255];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of rules for a rulebase';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.anz_regel';
parameter.gui.control_elements(ec).default = '10';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1, Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 255];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Fuzzy_StatRele';
parameter.gui.control_elements(ec).uihd_code = [11 256];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Significance level';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.fuzzy_system.stat_absich';
parameter.gui.control_elements(ec).default = '95';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {50, 99.999999999999999999};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 256];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Allg_ReportTemplate';
parameter.gui.control_elements(ec).uihd_code = [11 257];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Latex template for PDF project report';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.allgemein.report_template.tex';
parameter.gui.control_elements(ec).default = [parameter.allgemein.pfad_gaitcad filesep 'standardmakros' filesep 'report_template.tex'];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 257];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_PolynomWeighting';
parameter.gui.control_elements(ec).uihd_code = [11 258];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Weight matrix';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.poly_weighting';
parameter.gui.control_elements(ec).listen_werte = 'None|inverse proportional to class frequency|individual (parameter.projekt.weight_vector)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 258];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugShowTxt';
parameter.gui.control_elements(ec).uihd_code = [11 259];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show plugin list';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'show_plugintable(plugins);';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_VisuNoise';
parameter.gui.control_elements(ec).uihd_code = [11 260];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Add noise term';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.visu_noise';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_VisuNoiseValue';
parameter.gui.control_elements(ec).uihd_code = [11 261];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Relative ratio noise term';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.visu_noise_value';
parameter.gui.control_elements(ec).default = '0.05';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0, 0.1};
parameter.gui.control_elements(ec).ganzzahlig = 0;
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 261];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;
%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Fit';
parameter.gui.control_elements(ec).uihd_code = [11 262];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Fit';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.fit';
parameter.gui.control_elements(ec).listen_werte = 'weibull|exponential|fourier|gauss|cubicinterp|pchipinterp|poly curve|power|rational|sinus|cubicspline|smoothingspline|biharmonicinterp|poly surface|local linear regr|local quadratic regr';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'callback_fit_parameter;';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 262];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Fit_Par1';
parameter.gui.control_elements(ec).uihd_code = [11 263];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Parameter 1';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.fitpar1';
parameter.gui.control_elements(ec).default = '1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 10};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = 'callback_fit_parameter;';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 263];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_Regression_Fit_Par2';
parameter.gui.control_elements(ec).uihd_code = [11 264];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Parameter 2';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.regression.fitpar2';
parameter.gui.control_elements(ec).default = '1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0, 10};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = 'callback_fit_parameter;';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 264];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_CorrPValues';
parameter.gui.control_elements(ec).uihd_code = [11 265];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show p values for correlation';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.p_values_corr';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_CorrSelFeature';
parameter.gui.control_elements(ec).uihd_code = [11 266];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show correlation only for one selected feature';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.show_corr_selected';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_Termnames';
parameter.gui.control_elements(ec).uihd_code = [11 267];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show term names instead of datapoint numbers';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.show_termnames';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_Normtest';
parameter.gui.control_elements(ec).uihd_code = [11 268];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Test of normal distribution';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.statistikoptionen.normtest';
parameter.gui.control_elements(ec).listen_werte = 'Chi Square Test|Lillie Test|Anderson Darling Test|Jarque Bera Test';
parameter.gui.control_elements(ec).default = 4;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 268];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_DatapointValueSelection';
parameter.gui.control_elements(ec).uihd_code = [11 269];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Feature values for selection';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.datenvorverarbeitung.value_selection';
parameter.gui.control_elements(ec).default = '<10';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 269];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_AssociationIgnoreFrequent';
parameter.gui.control_elements(ec).uihd_code = [11 270];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Ignore output variables with many terms';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.association_rules.ignore_numerous_output_terms';
parameter.gui.control_elements(ec).default = '10';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 270];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_AssociationMinSupp';
parameter.gui.control_elements(ec).uihd_code = [11 271];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Minimum support';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.association_rules.minSup';
parameter.gui.control_elements(ec).default = '0.1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).ganzzahlig = 0;
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 271];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_AssociationMinKonf';
parameter.gui.control_elements(ec).uihd_code = [11 272];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Minimum confidence';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.association_rules.minConf';
parameter.gui.control_elements(ec).default = '0.7';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 1};
parameter.gui.control_elements(ec).ganzzahlig = 0;
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 272];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_AssociationNRules';
parameter.gui.control_elements(ec).uihd_code = [11 273];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of rules';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.association_rules.nRules';
parameter.gui.control_elements(ec).default = '100';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {0 Inf};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 273];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_AssociationSorting';
parameter.gui.control_elements(ec).uihd_code = [11 274];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Sorting';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.association_rules.sortFlag';
parameter.gui.control_elements(ec).listen_werte = 'Support|Confidence';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 274];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_PoincareLine';
parameter.gui.control_elements(ec).uihd_code = [11 275];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Poincare plot: Connect points';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.poincare_line';
parameter.gui.control_elements(ec).default = 0;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_Anzeige_XPIWITPipelineCall';
parameter.gui.control_elements(ec).uihd_code = [11 276];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'XPIWIT: Execute pipeline stepwise';
parameter.gui.control_elements(ec).style = 'checkbox';
parameter.gui.control_elements(ec).variable = 'parameter.gui.merkmalsgenerierung.xpiwit_pipeline';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec + 1;
parameter.gui.control_elements(ec).tag = 'CE_PlugListShowPar';
parameter.gui.control_elements(ec).uihd_code = [11 277];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Show parameters';
parameter.gui.control_elements(ec).style = 'pushbutton';
parameter.gui.control_elements(ec).variable = '';
parameter.gui.control_elements(ec).default = [];
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = 'show_plugins_sequence_parameter;';
parameter.gui.control_elements(ec).breite = 110;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];


%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_SomNeurons';
parameter.gui.control_elements(ec).uihd_code = [11 278];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of neurons';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.som.number_of_neurons';
parameter.gui.control_elements(ec).default = '5';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 278];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_SomDimension';
parameter.gui.control_elements(ec).uihd_code = [11 279];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Dimension';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.som.dimension';
parameter.gui.control_elements(ec).default = '2';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 279];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
ec = ec+1;
parameter.gui.control_elements(ec).tag = 'CE_DatDistNorm';
parameter.gui.control_elements(ec).uihd_code = [11 280];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Norm (Data point distances)';
parameter.gui.control_elements(ec).style = 'popupmenu';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.datdistnorm';
parameter.gui.control_elements(ec).listen_werte = 'Frobenius norm|Frobenius norm (divided by number of features)|1-Norm|1-Norm (divided my number of features)|Inf-Norm|Inf norm (divided by number of features)';
parameter.gui.control_elements(ec).default = 1;
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = '';
parameter.gui.control_elements(ec).breite = 250;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner = [];
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 280];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% MLP: Anzahl Neuronen pro Schicht
ec = ec + 1; % (83)
parameter.gui.control_elements(ec).tag = 'CE_MLP_Neuronen_NumberofLayers';
parameter.gui.control_elements(ec).uihd_code = [11 281];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Number of layers';
parameter.gui.control_elements(ec).variable = 'parameter.gui.klassifikation.ann.mlp.number_of_layers';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).default = '1';
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 50;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 281];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;

% p-Wert für t-Test
ec = ec + 1; % (20)
parameter.gui.control_elements(ec).tag = 'CE_MarkerSize';
parameter.gui.control_elements(ec).uihd_code = [11 282];
parameter.gui.control_elements(ec).handle = [];
parameter.gui.control_elements(ec).name = 'Marker size';
parameter.gui.control_elements(ec).style = 'edit';
parameter.gui.control_elements(ec).variable = 'parameter.gui.anzeige.marker_size';
parameter.gui.control_elements(ec).default = '6';
parameter.gui.control_elements(ec).ganzzahlig = 1;
parameter.gui.control_elements(ec).wertebereich = {1 Inf};
parameter.gui.control_elements(ec).tooltext = '';
parameter.gui.control_elements(ec).callback = [];
parameter.gui.control_elements(ec).breite = 150;
parameter.gui.control_elements(ec).hoehe = 20;
parameter.gui.control_elements(ec).bezeichner.uihd_code = [12 282];
parameter.gui.control_elements(ec).bezeichner.handle = [];
parameter.gui.control_elements(ec).bezeichner.breite = 250;
parameter.gui.control_elements(ec).bezeichner.hoehe = 20;%%%%%%%%%%%%%%%%%%%%%%%


clear ec;
