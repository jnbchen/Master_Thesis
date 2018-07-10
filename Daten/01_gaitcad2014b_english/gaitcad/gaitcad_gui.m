% Script gaitcad_gui
%
%   wichtige Datenstrukturen:
% 
%   uihd - Matrix von Menü- und Schalter-Handles
%   Zeilen:  Hauptmenüpunkte (außer 11: alle Schaltelemente)
%   Spalten: Untermenüpunkte (von 11: Nr. des Schaltelements)
%
% The script gaitcad_gui is part of the MATLAB toolbox Gait-CAD. 
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

close all; clear all;

%MATLAB-Version auslesen
[temp,parameter.allgemein.matlab_version]=ismatlabversion;
if parameter.allgemein.matlab_version>6
   warning('off','MATLAB:dispatcher:InexactMatch');
end;
clear temp;

%look for statistic toolbox
if isempty(which('ttest.m'))
   parameter.allgemein.isstat = 0;
else
   parameter.allgemein.isstat = 1;
end;

%state of parallel workers
try
   mode = 2;callback_matlab_parallel;
catch
   parameter.allgemein.parallel = 0;
end;
%look for additional search path
callback_read_gaitcad_search_path;


% Wird in ldprj_g vom Laden ausgeschlossen, um nicht im Projekt enthalten zu sein!!!
% Das parameter.allgemein-Strukt wird beim Laden _nicht_ überschrieben.
% Das heißt, dass alle Werte, die hier eingetragen werden, auch nach dem Laden
% erhalten bleiben!!!
parameter.allgemein.version = sprintf('%g%c',2014,'b');
%parameter.allgemein.version = sprintf('%g%c alpha',2014,'b');

%Extrahiert den Gait-CAD-Hauptpfad - hoffentlich zumindest
plugins.pfad=fileparts(which('gaitcad_gui'));
%neu - für den allgemeinen Umgang mit autodoku
parameter.allgemein.program_name_intern = 'gaitcad';
parameter.allgemein.name_optionfile     = 'standard_options_english.uihdg';
parameter.allgemein.name_internfile     = 'einstellungen_intern_deutsch.uihdg';
parameter.allgemein.name_favoritefile   = 'favoriten_english.dat';

% Auch im Hauptstrukt der Optionen speichern.
parameter.allgemein.pfad_gaitcad = plugins.pfad;

%Prepare a temporary path for intermediate results

%backup: use Gait-CAD path (but not a good idea in case of missing writing
%rights)
parameter.allgemein.pfad_temp = parameter.allgemein.pfad_gaitcad;
parameter.allgemein.userpath  = fileparts(which('gaitcad'));

try
   %define temporary directory
   if isdir(tempdir)
      parameter.allgemein.pfad_temp = tempdir;
   end;
   
   %define user directory (for all local definitions)
   if isdir(userpath)
      parameter.allgemein.userpath = userpath;
   else
      temp = userpath;
      if isdir(temp(1:end-1))
         %sometimes problems with ';'
         
         parameter.allgemein.userpath = temp(1:end-1);
      end;
   end;
   
   %subdir for gaitcad
   if isdir(parameter.allgemein.userpath)
      if ~isdir([parameter.allgemein.userpath filesep 'gaitcad'])
         mkdir([parameter.allgemein.userpath filesep 'gaitcad']);
      end;
      parameter.allgemein.userpath = [parameter.allgemein.userpath filesep 'gaitcad'];
   end;
end;


% debug_mode 1 schaltet die try...catch-Klausel bei Menübefehlen aus. Dadurch wird der Fehler vom Debugger komplett
% (inklusive Datei und Zeile) angezeigt. Bei debug_mode == 0 erscheint nur noch die Fehlermeldung, ohne Angabe der Datei
% und Zeile.
parameter.allgemein.debug_mode = 1;
parameter.projekt = [];

%Fensternamen
figure(1);
pos=get(0,'Screensize');
%Fenster in die x-Richtung Mitte, ziemlich weit hoch mit Reserven für Toolbar und mit fest definierter Breite
set(1,'Position',[(pos(3)-770)/2 round(pos(4)-570)-100 770 570]);
%Versuch für mehr Robustheit...
set(1,'busyaction','cancel');
clear pos;
parameter.allgemein.figure_background_color = get(1,'Color');

axis([0 1 0 1]);
hold on;
axis off; %erschwert schreiben in Fenster1
set(1,'MenuBar','None','Resize','off', 'CloseRequestFcn', 'callback_beenden');

program_name=sprintf('Gait-CAD - Version %s',parameter.allgemein.version);
set(1,'Name',program_name,'NumberTitle','off');

if (exist([parameter.allgemein.userpath  filesep 'anaus.dat'], 'file'))
   try
      aktiv = load([parameter.allgemein.userpath filesep 'anaus.dat'], '-mat');
      aktiv = aktiv.aktiv;
      
      %Template immer ausschalten, wenn es existiert
      if ~isempty(aktiv)
         ind_temp = find(ismember({aktiv.name},'template'));
         if ~isempty(ind_temp)
            aktiv(ind_temp).an=0;
         end;
      end;
      
   catch
      aktiv=[];
   end;
else
   aktiv = [];
end;
if (exist([ parameter.allgemein.pfad_gaitcad filesep 'application_specials'], 'dir'))
   [parameter.allgemein.appl_specials, aktiv] = search_application_special(parameter.allgemein.pfad_gaitcad, aktiv);
   try
      save([ parameter.allgemein.userpath filesep 'anaus.dat'], 'aktiv', '-mat');
   end;
else
   parameter.allgemein.appl_specials={};
end;
parameter.allgemein.aktiv = aktiv;
%Menü
% Erzeuge die Menüelemente. Funktioniert wie control_elements: schreibt ein Strukt in parameter.gui.
menu_elements;
menu_elements_appl;
% Dieses Strukt wird dann verwendet, um das Menü aufzubauen:
[parameter.gui.menu.elements, uihd] = createMenuElements(parameter.gui.menu.main_menu, parameter.gui.menu.elements, [], 1, parameter.allgemein.debug_mode);
% Berechne die verschiedenen Bedingungen zum Freischalten der Menüpunkte.
parameter.gui.menu.freischalt = freischalt_strukt(parameter);
parameter.gui.menu.hm_freischalt = freischalt_hm(parameter);

% Initialisieren von Schaltelementen
% Erst nach den Menüelementen, damit uihd schon initialisiert wurde.
control_elements;
control_elements_appl;

%Tooltexte dazuladen
load_tooltext;
%load_tooltips_appl;

% Die Felder definieren:
optionen_felder;
optionen_felder_appl;

% Die Kontroll-Elemente erzeugen
% Da die Bedingungen für die Subfelder nun Zeichenketten sind, gibt es bei der Umwandlung Probleme.
% Es muss also einmal eine Schleife durchlaufen werden:
subfeldbedingungen = '';
for i = 1:length(parameter.gui.optionen_felder)
   if (~isempty(parameter.gui.optionen_felder(i).subfeldbedingung))
      subfeldbedingungen = char(subfeldbedingungen, parameter.gui.optionen_felder(i).subfeldbedingung);
   end;
end;
[parameter.gui.control_elements, uihd] = createElements(parameter.gui.control_elements, uihd, subfeldbedingungen, 1);
clear subfeldbedingungen;

%hier werden die Statistik-Elemente vorinitialisiert
for i_stat =1:9
   uihd(10,i_stat) = uicontrol('style','edit','parent',1,'visible','off','tag',sprintf('IN_%d',i_stat));
end;
clear i_stat;


% Um eine erhöhte Wiederverwendbarkeit der Funktion readpar1_g zu erreichen, die sehr speziellen
% Variablen lieber hier setzen.
parameter.allgemein.pfad_gaitcad = fileparts(which('gaitcad_gui'));
parameter.allgemein.pfad_einzug = [parameter.allgemein.pfad_gaitcad filesep 'plugins' filesep 'einzuggenerierung'];
readpar1_g;

% Zuletzt geöffnete Dateien
callback_lastopened;
% Favoriten-Menü initialisieren.
init_favoriten_ausschluss;
% Änderung Ole: lieber im Gait-CAD-Hauptpfad speichern und von da auch laden!
eval(sprintf('save(''%s%s%s'', ''-mat'')', parameter.allgemein.userpath,filesep,parameter.allgemein.name_internfile));
set_empty_variables;
par = [];
d_orgs = [];
d_org = [];
code_alle = [];
ind_auswahl = [];
menu_freischalten(parameter, parameter.gui.menu.freischalt);

%register temporary path and user path
gaitcad_extern.tempdir  = parameter.allgemein.pfad_temp;
gaitcad_extern.userpath = parameter.allgemein.userpath;

%sonst kracht es u.U. mit alten MATLABs, wenn eine falsche Option eingestellt ist
callback_savemode;