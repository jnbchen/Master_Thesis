  function [info] = plugin_einzugausdatei(paras, verzeichnis, endungString)
% function [info] = plugin_einzugausdatei(paras, verzeichnis, endungString)
%
%  Liest aus dem angegebenen Verzeichnis alle Dateien mit der Endung "endungString" (darf den Punkt nicht enthalten!).
%  Wird endungString nicht übergeben, wird die Standard-Endung ".einzug" verwendet.
%  Die Datei muss das folgende Format haben:
%  Bezeichner Kurzbezeichner  Start Stop
%  Datum1.1   Datum1.2    Datum1.3    Datum1.4
%  Datum2.1   Datum2.2    Datum2.3    Datum2.4
% 
%  Die Überschriften ("Bezeichner", "Kurzbezeichner", "Start", "Stop") müssen für
%  ein reibungsloses Funktionieren in der Datei in der ersten Zeile enthalten sein!
%  Als Trennzeichen zwischen den einzelnen Spalten gilt das Tabulatorzeichen, die Zeilen
%  werden durch einen Zeilenumbruch  getrennt.
%  In Datum1.1, ..., Datum1.4, usw. stehen die tatsächlichen Daten.
%  Für "Start", "Stop" können sowohl Zahlen (die Abtastpunkte, die verwendet werden sollen,
%  beginnend bei 1 (!)), als auch Merkmalsbezeichner (z.B. [MeanLeftFootOff]) stehen.
%  Ebenfalls sind Formeln (z.B. ([MeanLeftFootOff] - [MeanLeftOppositeFootContact])/2) erlaubt.
%  Die Merkmalsbezeichner müssen genau so geschrieben sein, wie sie in dem Projekt vorhanden sind.
%  Dieses Plug-In kontrolliert aber nicht, ob es diese Merkmale gibt. Für die Umrechung
%  der Indizes für die Einzüge steht das Plug-In plugin_einzugausmerkmalen zur Verfügung.
%  Als weitere Möglichkeit steht "-1" für das Ende einer Zeitreihe (macht natürlich nur Sinn
%  bei "Stop").
%  Werden keine Dateien gefunden, wird das Struct von plugin_standardeinzug übergeben.
% 
%  Eingaben:
%  paras: Parameter-Strukt; enthält:
%         - par (Parameter-Vektor aus Gait-CAD)
%  endungString: s.o.
%  Ausgaben:
%  info: Strukt mit folgenden Informationen (Feldern) Größe: 1 x Anzahl Zeilen in Datei
%         - ueberschrift (enthält den Dateinamen der .einzug-Datei)
%         - beschreibungen (enthält die Beschreibungen der Einzüge, Bsp: "Ganze Zeitreihe (0..100)")
%         - kurzbezeichner (enthält die Kurzbezeichner der Einzüge, werden an neue Merkmale angehängt, Bsp: "STRI")
%         - einzug (enthält die Indizes der Einzüge; wurden Merkmale angegeben, stehen die Bezeichner der Merkmale in der Variablen)
%             o start (Startindex oder Merkmal)
%             o stop (Stopindex oder Merkmal)
% 
%
% The function plugin_einzugausdatei is part of the MATLAB toolbox Gait-CAD. 
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

info = [];
if (nargin < 3)
   endungString = 'einzug';
end;

% Lade Standard-Einzüge:
info = plugin_standardeinzug(paras);

% Lädt aus dem angegebenen Verzeichnis die Einzugs-Dateien (*.einzug)
einz_gef = 0;

dat_pfad  = getsubdir([paras.parameter.allgemein.pfad_gaitcad strrep('\plugins\einzuggenerierung','\',filesep)],['*.' endungString],0);
if ~isempty(paras.parameter.allgemein.appl_specials) && ~isempty(paras.parameter.allgemein.appl_specials.name)
   appl_pfad = getsubdir(strcat(paras.parameter.allgemein.pfad_gaitcad,'\application_specials\',...
      paras.parameter.allgemein.appl_specials.name,strrep('\plugins\einzuggenerierung','\',filesep)),['*.' endungString],0);
else
   appl_pfad ='';
end;

pwd_pfad = getsubdir(pwd,['*.' endungString]',0);
if ~isempty(pwd_pfad) || ~isempty(appl_pfad)
   dat_pfad=[dat_pfad pwd_pfad appl_pfad];
   % Sind die Pfade ungünstig verteilt, kommen einige Pfade doppelt vor. Die
   % müssen entfernt werden.
   tmp = unique({dat_pfad.name});
   % Das Ergebnis ist jetzt ein Cell-Array. Wieder in Strukt schreiben.
   dat_pfad = [];
   for i = 1:length(tmp)
      dat_pfad(i).name = tmp{i};
   end;
end;
if isempty(dat_pfad)
   warning(sprintf('No time segment files found (*.%s). Use standard time segments', endungString));
   return;
end;

for i=1:length(dat_pfad)
   gueltige_datei(i)=~isempty(which(dat_pfad(i).name));
end;
if isempty(find(gueltige_datei))
   warning(sprintf('No time segment files found (*.%s). Use standard time segments', endungString));
   return;
end;
dat_pfad=dat_pfad(gueltige_datei);

% Setze den nächsten Index
enzCount =  length(info)+1;
for ind_pfad=1:length(dat_pfad)
   %      fprintf(1, 'Read time segments from %s...\n', [akt_verz '\' d.name]);
   % Benutze die getdata-Funktion. Bedingung ist:
   % In der ersten Zeile müssen die Bezeichner stehen, sonst funktioniert diese Funktion nicht.
   % Die Datei hat ein Format wie oben angegeben.
   try
      fprintf('Reading file %s\n',dat_pfad(ind_pfad).name);
      [data, d_org, bez] = getdata(dat_pfad(ind_pfad).name, 1, 0, 0, [9 10],0,0);
      
      % Entferne die Bezeichner und kürze d_org auf das Interessante
      data = data(2:end,:);
      d_org = d_org(:,3:4);
      
      % Wenn in der letzten Zeile der Datei keine Zahl vorkommt, fehlt diese Zeile in d_org.
      % Das führt hier aber dummerweise zum Absturz. Diese Zeile dann hinzufügen (mit 0)
      %if (size(d_org,1) < size(data,1))
      %   d_org = [d_org; zeros(size(data,1)-size(d_org,1), size(d_org,2))];
      %end;
      
      for j = 1:size(data, 1) %i = data')
         i = data(j,:)';
         info(enzCount).ueberschrift = dat_pfad(ind_pfad).name;
         info(enzCount).bezeichner = [i(1,1).text ' (' i(2,1).text ')'];
         info(enzCount).kurzbezeichner = i(2,1).text;
         if (isnan(d_org(j,1)) || d_org(j, 1) == 0)
            info(enzCount).einzug.start = i(3,1).text;
         else
            info(enzCount).einzug.start = d_org(j,1);
         end;
         if (isnan(d_org(j,2)) || d_org(j, 2) == 0)
            info(enzCount).einzug.stop = i(4,1).text;
         else
            info(enzCount).einzug.stop = d_org(j,2);
         end;
         enzCount = enzCount + 1;
         einz_gef = 1;
         
      end;
   catch
      fprintf('Error in %s\n',dat_pfad(ind_pfad).name);
   end; % for(j = 1:size(data, 1))
end; % for(d = D')
%end; % for(ver = size(verzeichnis, 1))
