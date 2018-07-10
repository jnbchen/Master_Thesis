  function exportiere_daten(daten, ziel, ausgangsgroessen, bez, optionen)
% function exportiere_daten(daten, ziel, ausgangsgroessen, bez, optionen)
%
%  daten: enthält die Matrix mit zu exportierenden Daten. Ist eine Nxs Matrix für
%  Einzelmerkmale und eine NxKxs Matrix für Zeitreihen (N = 1 ist erlaubt).
%  Zur Unterscheidung muss zuätzlich optionen.inhalt auf 1 (für Zeitreihen) oder
%  2 (für Einzelmerkmale) gesetzt sein.
%  ziel: Ordner bzw. Dateiname für das Exportieren der Daten.
%  ausgangsgroessen: Strukt mit folgendem Inhalt:
%  .code: enthält alle Klassencodes der Datentupel (Nxy-Matrix)
%  .zgf_y_bez: Strukt, der für jede Ausgangsgröße alle linguistischen Terme enthält
%  ausgangsgroessen darf nur dann leer sein, wenn Einzelmerkmale exportiert werden
%  oder wenn eine 1xKxs-Zeitreihenmatrix vorliegt.
%  bez: Bezeichner der Merkmale (default: [])
% 
%  optionen: Strukt mit:
%  optionen.klassentrennzeichen.ordner: Wie werden die Klassen aus den Ordnern
%  extrahiert? (default: '')
%  optionen.klassentrennzeichen.datei: Wie werden die Klassen aus den Dateinamen
%  extrahiert? (default: '')
%  optionen.dezimaltrennzeichen: Wie werden Dezimalzahlen getrennt?
%  (default: '.')
%  optionen.spaltentrennzeichen: Welches Zeichen trennt die Spalten?
%  (default: ' ')
%  optionen.inhalt: ZR (=1), EM (=2)
%  optionen.firstline_bez: Bezeichner der Merkmale stehen in der ersten Zeile
%  1 = ja, 0 = nein (default: 0)
%  optionen.ordner_rekursiv: Ordner werden rekursiv nach Dateien durchsucht
%  1 = ja, 0 = nein (default: 1)
%  optionen.dateiendung: Nach welchen Dateien soll gesucht werden? (default: '.txt')
%  optionen.ziel_ist_datei: Gibt an, ob das Ziel eine Datei (== 1) oder ein Ordner (== 0) ist
%  (default: 0)
% 
%
% The function exportiere_daten is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 5)
   optionen = [];
end;
optionen = set_defaults(optionen);

if (nargin < 2)
   myerror('Undefined target for data!');
   return;
end;
if (nargin < 3)
   if (optionen.inhalt == 2 || (optionen.inhalt == 1 && size(daten,1) == 1))
      ausgangsgroessen = [];
   else
      myerror('Error! Missing names for files and directories. Please define output variables.');
      return;
   end;
end;
if (nargin < 4)
   if (optionen.firstline_bez)
      mywarning('No names found for export.');
   end;
   bez = [];
   optionen.firstline_bez = 0;
end;
% Prüfe, ob die Anzahl an Bezeichnern mit der Anzahl an Zeitreihen oder
% Einzelmerkmalen übereinstimmt.
if (~isempty(bez))
   if (optionen.inhalt == 1)
      dim = 3;
   else
      dim = 2;
   end;
   if (size(bez,1) ~= size(daten, dim))
      mywarning('Number of variable names does not fit number of features! Removing waste names....');
      bez = [];
      optionen.firstline_bez = 0;
   else
      % Die gewählten Trennzeichen aus den Bezeichnern entfernen:
      trennzeichen = char(' ', '_', '-');
      ind = ismember(optionen.spaltentrennzeichen, trennzeichen);
      if (ind + 1 < size(trennzeichen,1))
         ind = ind + 1;
      else
         ind = 1;
      end;
      optionen.tauschen = trennzeichen(ind);
   end;
end;
% Prüfen, ob in einen Ordner geschrieben werden soll und ob es das Ziel gibt.
if (optionen.ziel_ist_datei == 0)
   if ~exist(ziel, 'dir')
      try 
         succ = mkdir(ziel);
         if succ == 0
            myerror('Please correct the directory and file names.\n');
            return;
         end;
      catch
         myerror('The target does not exist!');
         return;
      end;
   else
      if isempty(ziel)
         myerror('The target directory should not be empty!');
      end;
      
      if (ziel(end) ~= '\')
         ziel(end+1) = '\';
      end;
   end;
end;
% Zeitreihen können nur in eine einzelne Datei geschrieben werden,
% wenn es nur ein Datentupel gibt.
if (optionen.inhalt == 1 && optionen.ziel_ist_datei && size(daten,1) > 1)
   myerror('Too many data points for an import of time series in one file.');
   return;
end;
if (optionen.inhalt == 2 && size(daten,3) > 1)
   myerror('Export of single features was expected!');
   return;
end;

% Die folgende Funktion füllt zunächst ein Strukt mit den verschiedenen
% Ausgangsgroessen
if ~isempty(ausgangsgroessen)
   ordner = set_ordner_hierarchie(ausgangsgroessen);
else
   ordner = [];
end;
% Wenn es nur eine Ausgangsgröße gibt.
if (size(ordner,2) == 1)
   optionen.ordner_rekursiv = 0;
end;

% Nun durch die Daten gehen und sie an die korrekte Stelle schreiben
% Dabei sind bei Einzelmerkmalen und Zeitreihen verschiedene Dimensionen
% zu beachten.
% Zeitreihen exportieren
if (optionen.inhalt == 1)
   for i = 1:size(daten,1)
      schreiben = squeeze(daten(i, :, :));
      hierarchie = {ordner{i, :}};
      
      %repair invalid filenames if necessary 
      for i_hier = 1:length(hierarchie) 
         hierarchie{i_hier} = repair_dosname(hierarchie{i_hier});
      end;
      
      if (optionen.ziel_ist_datei)
         write_to_ascii(schreiben, bez, ziel, optionen);
      else
         if (optionen.ordner_rekursiv)
            % Hier werden alle bis auf die letzte Ausgangsklassen
            % in Ordnern eingebunden.
            % Die letzte Ausgangsklasse steckt im Dateinamen.
            optionen.klassentrennzeichen.datei = '\';
            exp_file = [ziel filesep hierarchie{1}];
            if (~exist(exp_file, 'dir'))
               mkdir(ziel, hierarchie{1});
            end;
                        
            % Gehe durch die restlichen Hierarchiestufen durch
            for h = 2:length(hierarchie)-1
               tmp = [exp_file optionen.klassentrennzeichen.datei hierarchie{h}];
               if (~exist(tmp, 'dir'))
                  mkdir(exp_file, hierarchie{h});
               end;
               exp_file = tmp;
            end; % for(h = 2:length(hierarchie))
            exp_file = [exp_file optionen.klassentrennzeichen.datei hierarchie{end} optionen.dateiendung];
         else
            exp_file = [ziel hierarchie{1}];
            for h = 2:length(hierarchie)
               exp_file = [exp_file optionen.klassentrennzeichen.datei hierarchie{h}];
            end;
            exp_file = [exp_file optionen.dateiendung];
         end;
         write_to_ascii(schreiben, bez, exp_file, optionen);
      end; % if (optionen.ziel_ist_datei)
   end; % for(i = 1:size(daten,1))
else
   % Einzelmerkmale exportieren
   % Die Einzelmerkmale werden nur in eine einzige Datei exportiert,
   % nicht in verschiedene Dateien in verschiedenen Ordnern.
   optionen.verlauf_anzeige = 1;
   write_to_ascii(daten, bez, ziel, optionen);
end; % if (optionen.inhalt == 1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EINIGE UNTERFUNKTIONEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function write_to_ascii(daten, bez, file, optionen)
% Zunächst einmal kontrollieren, ob Spaltentrennzeichen auf Leerzeichen
% steht und als Dezimalzeichen in Punkt eingetragen ist. Dann kann man
% einfach die Matlab save... -ascii Funktion benutzen. Die ist vermutlich
% relativ schnell.
if (optionen.dezimaltrennzeichen == '.' && optionen.spaltentrennzeichen == ' ' && ...
      (~optionen.firstline_bez || isempty(bez)))
   fprintf(1, sprintf('Export data in %s...\n', strrep(file, '\', '\\')));
   save(file, 'daten', '-ascii');
else
   % Sonst schreibe mit fprintf gezielt in die Datei.
   fid = fopen(file, 'wt');
   if (fid ~= -1)
      fprintf(1, sprintf('Export data in %s...\n', strrep(file, '\', '\\')));
      % Zuerst die Bezeichner (wenn gewünscht)
      if (optionen.firstline_bez)
         for i = 1:size(bez,1)
            fprintf(fid, '%s%s', strrep(deblank(bez(i,:)), optionen.spaltentrennzeichen, optionen.tauschen), optionen.spaltentrennzeichen);
         end;
         fprintf(fid, '\n');
      end; % if (optionen.firstline_bez)
      if optionen.verlauf_anzeige
         verlauf = waitbar(0, 'Export data');
      end;
      % Nun die Daten
      for i = 1:size(daten,1)
         % Bereite die Zeichenkette zunächst vor.
         str = sprintf('%g', daten(i,1));
         for j = 2:size(daten,2)
            % Hier wird num2str benutzt, da sonst eine feste Anzahl an Nachkommastellen verwendet wird.
            str = sprintf('%s%s%g', str, optionen.spaltentrennzeichen, daten(i,j));
         end;
         % Eventuell das Dezimaltrennzeichen anpassen
         if (optionen.dezimaltrennzeichen == ',')
            str = strrep(str, '.', ',');
         end;
         % Dann den kompletten String schreiben
         fprintf(fid, '%s\n', str);
         % Anzeige des Fortschritts?
         if (optionen.verlauf_anzeige)
            waitbar(i/size(daten,1), verlauf);
         end;
      end;
      if (optionen.verlauf_anzeige)
         close(verlauf);
      end;
      fclose(fid);
   else
      mywarning(sprintf('No permission to write in file %s .\n', file));
   end;
end;


function ordner = set_ordner_hierarchie(ausgangsgroessen)
ordner = cell(0);
% Für jeden Datentupel
for i = 1:size(ausgangsgroessen.code,1)
   % Und jede Ausgangsgröße
   for j = 1:size(ausgangsgroessen.code, 2)
      ind = ausgangsgroessen.code(i, j);
      %im Zweifelsfall Doppelpunkte weg, sonst bekommt Windows Probleme
      ordner{i, j} = strrep(ausgangsgroessen.zgf_y_bez(j, ind).name,':','');
   end;
end; % for(i = 1:size(ausgangsgroessen.code,1))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setzt die Default-Werte des Strukts.
function optionen = set_defaults(optionen)
if (~isfield(optionen, 'klassentrennzeichen'))
   optionen.klassentrennzeichen.ordner = '';
   optionen.klassentrennzeichen.datei = '';
end;
if (~isfield(optionen.klassentrennzeichen, 'ordner'))
   optionen.klassentrennzeichen.ordner = '';
end;
if (~isfield(optionen.klassentrennzeichen, 'datei'))
   optionen.klassentrennzeichen.datei = '';
end;
if (~isfield(optionen, 'dezimaltrennzeichen'))
   optionen.klassentrennzeichen.ordner = '.';
end;
if (~isfield(optionen, 'spaltentrennzeichen'))
   optionen.spaltentrennzeichen = ' ';
end;
if (~isfield(optionen, 'inhalt'))
   optionen.inhalt = 1;
end;
if (~isfield(optionen, 'firstline_bez'))
   optionen.firstline_bez = 0;
end;
if (~isfield(optionen, 'ordner_rekursiv'))
   optionen.ordner_rekursiv = 1;
end;
if (~isfield(optionen, 'dateiendung'))
   optionen.dateiendung = '.txt';
end;
if (optionen.dateiendung(1) ~= '.')
   optionen.dateiendung = ['.' optionen.dateiendung];
end;
optionen.verlauf_anzeige = 0;