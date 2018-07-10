  function [mgenerierung_plugins, einzuege_plugins, string, info, callback] = liesMGenerierungPlugins(var_bez, par, parameter)
% function [mgenerierung_plugins, einzuege_plugins, string, info, callback] = liesMGenerierungPlugins(var_bez, par, parameter)
%
%  Liest die Plugins aus dem Verzeichnis [parameter.allgemein.pfad_gaitcad '\plugins\mgenerierung'] aus und gibt eine Liste zurück
%  (mgenerierung_plugins).
%  In diesem Verzeichnis dürfen gerne weitere Funktionen sein, allerdings wird von der Funktion als erstes
%  Kriterium für "ist plugin" die Anzahl der Ein- und Ausgabevariablen verwendet. Stimmt die Anzahl der Parameter
%  überein (2 Eingabe, 3 Ausgabe), wird die Funktion aufgerufen, um die nötigen Informationen auszulesen.
%  An dieser Stelle kann es zum Absturz kommen, wenn Funktionen im Verzeichnis vorhanden sind, die nicht die ent-
%  sprechenden Informationen zur Verfügung stellen.
%  Ein Abfangen mit Hilfe eines try/catch-Blocks ist wegen des Debuggers entfernt worden...
%  Skripte dürfen _nicht_ im Verzeichnis vorhanden sein, da die Abfrage auf die Anzahl der Parameter bei einem
%  Skript mit error beendet wird.
%  Desweiteren werden die Vorhandenen einzüge im aktuellen Pfad ausgelesen und eine Liste der Einzüge zurückgegeben
%  (einzuege_plugins).
%  Der Suchpfad für die Einzüge wird in parameter.allgemein.pfad_einzug erwartet.
%  string, info, callback sind für die Erzeugung eines Auswahlfensters mit new_menu_af(...).
%  Als Parameter müssen die Bezeichner der Zeitreihen, sowie das par-Strukt und das parameter-Strukt übergeben werden.
%
% The function liesMGenerierungPlugins is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

if parameter.allgemein.no_update_reading == 1
   mgenerierung_plugins = [];
   einzuege_plugins =[];
   string = [];
   info = [];
   callback =[];
   return;
end;

dat_pfad  = getsubdir([parameter.allgemein.pfad_gaitcad strrep('\plugins\mgenerierung','\',filesep)],'plugin_*.m',0);

if ~isempty(parameter.allgemein.appl_specials) && ~isempty(parameter.allgemein.appl_specials.name)
   appl_pfad = getsubdir(strcat(parameter.allgemein.pfad_gaitcad,filesep,'application_specials',filesep,...
      parameter.allgemein.appl_specials.name,strrep('\plugins\mgenerierung','\',filesep)),'plugin_*.m',0);
else
   appl_pfad ='';
end;

if isfield(parameter.allgemein,'gaitcad_searchpath') && ~isempty(parameter.allgemein.gaitcad_searchpath)
   user_searchpath = getsubdir(parameter.allgemein.gaitcad_searchpath,'plugin_*.m',0);
else
   user_searchpath ='';
end;


if isfield(parameter.allgemein,'macro_searchpath') && ~isempty(parameter.allgemein.macro_searchpath)
   user_searchpath =  [user_searchpath getsubdir(parameter.allgemein.macro_searchpath,'plugin_*.m',0)];
end;


pwd_pfad = getsubdir(pwd,'plugin_*.m',0);
if ~isempty(pwd_pfad) || ~isempty(appl_pfad) || ~isempty(user_searchpath)
   dat_pfad=[dat_pfad pwd_pfad appl_pfad user_searchpath];
   % Sind die Pfade ungünstig verteilt, kommen einige Pfade doppelt vor. Die
   % müssen entfernt werden.
   tmp = unique({dat_pfad.name});
   % Das Ergebnis ist jetzt ein Cell-Array. Wieder in Strukt schreiben.
   dat_pfad = [];
   for i = 1:length(tmp)
      dat_pfad(i).name = tmp{i};
   end;
end;



%m_files = dat_pfad.name;

mgenerierung_plugins.funktionsnamen = [];
mgenerierung_plugins.info = [];
paras.par = par;
paras.parameter = parameter;

% Lies alle Merkmalgenerierungs-Plug-Ins aus...
%for(i = m_files')
for i = 1:length(dat_pfad)
   % Schneide die letzten beiden Zeichen ab ('.m')
   %name = i{1}(1:end-2);
   [plugindir,name]=fileparts(dat_pfad(i).name);
   if exist(dat_pfad(i).name,'file')
      
      % Untersuche die Anzahl der Eingaben und Ausgaben.
      try 
          nIn = nargin(name);
          nOut = nargout(name);
      catch 
          nIn = 0;
          nOut = 0;
          str=' Internal error in the Plug-In';
          fprintf(1, 'Ignore %s.m; Error: %s\n------------------------------------\n', name, str);
      end;
      
      % Richtige Anzahl Parameter vorhanden?
      str = '';
      if (nIn == 2 && nOut == 3)
         % ÄNDERUNG RALF:
         % try/catch wurde wieder eingeschaltet, verwirrt aber bei Debugger-Einstellung
         % "stop if error".
         
         % Hole die Informationen
         try
            [dummy, ret, plugin_info_raw] = eval([name '(paras)']);
            
            if isfield(ret,'ungueltig') && ret.ungueltig==1
               str=' Internal error in the Plug-In';
            else
               [plugin_info,str] = check_plugin_info(plugin_info_raw);
            end;
            
            if isempty(str)
               mgenerierung_plugins.funktionsnamen = strvcatnew(mgenerierung_plugins.funktionsnamen, name);
               
               mgenerierung_plugins.info = [mgenerierung_plugins.info; plugin_info];
               fprintf(1, 'Plug-in found: %s.m\n------------------------------------\n', name);
            else
               fprintf(1, 'Ignore %s.m; Error: %s\n------------------------------------\n', name, str);
            end; % if isempty(str)
         catch
            str = 'Program error inside a plugin (e.g. non existing variable)';
            fprintf(1, 'Ignore %s.m; Error: %s\n------------------------------------\n', name, str);
         end;
         
         
      else
         fprintf(1, 'Ignore %s.m; Invalid plugin\n------------------------------------\n', name);
      end; % if (nIn == 2 && nOut == 3)
   end;
end;
% Sortiere die Plug-Ins nach Kategorien
% Eine Sortierung nach Namen hat durch das "what" schon stattgefunden.
% Wird jetzt zus. nach Kategorien sortiert, bleibt innerhalb der
% Kategorien die Sortierung nach Namen erhalten.
[temp_wert,ind_sort]=unique([strvcatnew(mgenerierung_plugins.info.typ) strvcatnew(mgenerierung_plugins.info.beschreibung)],'rows');
mgenerierung_plugins.funktionsnamen = mgenerierung_plugins.funktionsnamen(ind_sort, :);
mgenerierung_plugins.info = mgenerierung_plugins.info(ind_sort);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bereite Strings für das Auswahlfenster vor...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Zeitreihen
tmp=poplist_popini(var_bez(1:par.anz_merk,:));
string(1,1:length(tmp))=tmp;
tmp='Original data (Time series)';
info(1,1:length(tmp))=tmp;

%Neue Merkmalstypen
% Kleine Problematik: Plug-Ins, die mehr als eine ZR/EM erstellen, müssen gesondert behandelt werden, da sie
% auch mehrere Bezeichner übergeben. => String muss in for-Schleife erzeugt werden.
% Da diese Funktion nur einmal beim Starten aufgerufen werden soll, ist es kein großes Problem, aber bei
% mehrfachem Aufrufen sollte die Geschwindigkeit kontrolliert werden.
% Auf der anderen Seite: es wird keine Millionen Plug-Ins geben...
merkmalsstring = '';
akt_typ = '';

i_typ_beschr = 0;

for i = 1:length(mgenerierung_plugins.info)
   if (strcmp(akt_typ, mgenerierung_plugins.info(i).typ) == 0)
      akt_typ = mgenerierung_plugins.info(i).typ;
      einf = '-------------------------';
      einf(2:length(akt_typ)+1) = akt_typ;
      
      i_typ_beschr = i_typ_beschr +1;
      % Nr Plugin
      mgenerierung_plugins.typ_beschreibung.plugin(i_typ_beschr) = 0;
      % Quelle: ZR EM IM
      switch akt_typ
         case 'TS'
            mgenerierung_plugins.typ_beschreibung.source(i_typ_beschr,:) = [1 0 0];
            mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:) = [1 0 0];
         case 'SF'
            mgenerierung_plugins.typ_beschreibung.source(i_typ_beschr,:) = [1 0 0];
            mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:) = [0 1 0];
         case 'IM'
            mgenerierung_plugins.typ_beschreibung.source(i_typ_beschr,:) = [0 0 1];
            mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:) = [0 0 1];
         case 'IMSlice'
            mgenerierung_plugins.typ_beschreibung.source(i_typ_beschr,:) = [0 0 Inf];
            mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:) = [0 0 1];
         case 'IMTime'
            mgenerierung_plugins.typ_beschreibung.source(i_typ_beschr,:) = [0 0 Inf];
            mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:) = [0 0 Inf];
         case 'IMOutput'
            mgenerierung_plugins.typ_beschreibung.source(i_typ_beschr,:) = [0 0 Inf];
            mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:) = [1 0 0];
      end;
      
      if (i == 1)
         merkmalsstring = [merkmalsstring einf];
      else
         merkmalsstring = [merkmalsstring '|' einf];
      end;
   end;
   merkmalsstring = [merkmalsstring '|' mgenerierung_plugins.info(i).beschreibung ' '];
   
   i_typ_beschr = i_typ_beschr +1;
   % Nr Plugin
   mgenerierung_plugins.typ_beschreibung.plugin(i_typ_beschr) = i;
   % Quelle: ZR EM IM
   mgenerierung_plugins.typ_beschreibung.source(i_typ_beschr,:) = [mgenerierung_plugins.info(i).anz_benoetigt_zr mgenerierung_plugins.info(i).anz_benoetigt_em mgenerierung_plugins.info(i).anz_benoetigt_im];
   mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:) = [mgenerierung_plugins.info(i).anz_zr mgenerierung_plugins.info(i).anz_em mgenerierung_plugins.info(i).anz_im];
   mgenerierung_plugins.typ_beschreibung.funktionsnamen (i_typ_beschr,:) = mgenerierung_plugins.funktionsnamen(i,:);
   
   %Bezeichnerstring
   merkmalsstring = [merkmalsstring '(' deblank(mgenerierung_plugins.info(i).bezeichner(1,:))];
   if any(any(isnan(mgenerierung_plugins.typ_beschreibung.dest(i_typ_beschr,:)) | isinf(mgenerierung_plugins.typ_beschreibung.dest(i_typ_beschr,:)) | mgenerierung_plugins.typ_beschreibung.dest  (i_typ_beschr,:)>1 ))  % Coderevision: &/| checked!
      %Probleme bei unbestimmter Anzahl von Ausgangswertenendlich vielen Ausgabewerten
      merkmalsstring = [merkmalsstring ',...'];
   end;
   %String abschließen
   merkmalsstring = [merkmalsstring ')'];
end;

%list of plugins for visualization
mgenerierung_plugins.typ_beschreibung.show_now = 1:length(mgenerierung_plugins.typ_beschreibung.plugin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Neue Version: Einzüge einlesen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hier wird zwar zwischen Links und Rechts unterschieden, es wird aber davon ausgegangen,
% dass die Bezeichner identisch sind...
% Etwas unschön, aber es soll ja erst mal wieder funktionieren.
if isempty(parameter.allgemein.pfad_einzug)
   return;
end;

verzeichnis = strvcatnew(parameter.allgemein.pfad_einzug, pwd);
if (parameter.gui.ganganalyse.einzug_links_rechts)
   einzuege_plugins.links = plugin_einzugausdatei(paras, verzeichnis, 'leinzug');
   einzuege_plugins.rechts = plugin_einzugausdatei(paras, verzeichnis, 'reinzug');
   if ( length(einzuege_plugins.links) ~= length(einzuege_plugins.rechts))
      warning('Different number of code side specific time segments!');
   end;
   tmp=poplist_popini(char(einzuege_plugins.links.bezeichner));
else
   einzuege_plugins = plugin_einzugausdatei(paras, verzeichnis);
   tmp=poplist_popini(char(einzuege_plugins.bezeichner));
end;

%define strings for visualization in selection windows
string(2,1:length(tmp))=tmp;
tmp='Interval';
info(2,1:length(tmp))=tmp;

string(3,1:length(merkmalsstring))=merkmalsstring;
tmp='New features';
info(3,1:length(tmp))=tmp;

callback = 'callback_mgenerierung_plugins;';

%start with 6 blanks for compatibility!!!!!
temp = ['------' deblank(char(merkmalsstring))];
indx = find(temp == '|');
for i = 1:length(indx)
   % Es gibt Felder, die beginnen mit '-' und das muss so bleiben!
   if (temp(indx(i)+1) ~= '-')
      
      %works for not more than 9999 plugins
      temp = [temp(1:indx(i)) sprintf('%4d',i+1) '- ' temp(indx(i)+1:end)];
   else
      temp = [temp(1:indx(i)) '------' temp(indx(i)+1:end)];
   end;
   %length of new term: number of sigits +2
   indx = indx + 6;
end;

hndl = findobj('tag','CE_Auswahl_Plugins');
if ~isempty(hndl)
   repair_popup(hndl,temp,get(hndl,'value'));
   mgenerierung_plugins.full_string = get(hndl,'string');
end;
