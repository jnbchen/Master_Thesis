  function [mydata, bez, ausgangsgroessen] = importiere_daten(quelle, optionen)
% function [mydata, bez, ausgangsgroessen] = importiere_daten(quelle, optionen)
%
% 
%  optionen.klassentrennzeichen.ordner: Wie werden die Klassen aus den Ordnern
%  extrahiert? (default: '')
%  optionen.klassentrennzeichen.datei: Wie werden die Klassen aus den Dateinamen
%  extrahiert? (default: '')
%  optionen.dezimaltrennzeichen: Wie werden Dezimalzahlen getrennt?
%  (default: '.')
%  optionen.spaltentrennzeichen: Welches Zeichen trennt die Spalten?
%  (default: ' ')
%  optionen.inhalt: EM / ZR
%  optionen.firstline_bez: Bezeichner der Merkmale stehen in der ersten Zeile
%  1 = ja, 0 = nein (default: 0)
%  optionen.ordner_rekursiv: Ordner werden rekursiv nach Dateien durchsucht
%  1 = ja, 0 = nein (default: 1)
%  optionen.dateiendung: Nach welchen Dateien soll gesucht werden? (default: '.txt')
%  optionen.gleiche_laenge: Wie sollen Daten mit unterschiedlich vielen Abtastpunkten
%  behandelt werden?
%  'resample': auf maximale Länge resamplen,
%  'zeros': mit Nullen auffüllen (default)
%  'last_value': letzten Wert beibehalten
%  optionen.importfct: Wie sollen die Daten importiert werden?
%  'fgetl': Zeilenweises einlesen mit fgetl (default)
%  'rewrite': Text aus Datei entfernen, neue Datei schreiben und mit load -ascii laden
%  'getdata': mit Hilfe der Funktion getdata.
%  optionen.ignore_firstlines: Anzahl an Zeilen, die zu Beginn einer Datei ignoriert werden sollen.
%  (default: 0)
%  optionen.ignoriere_zeilen_mit: Zeichen, das zu ignorierende Zeilen definiert.
%  (default: [])
% 
%  Zunächst die Default-Werte setzen
%
% The function importiere_daten is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 2)
   optionen = [];
end;
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
if (~isfield(optionen, 'gleiche_laenge'))
   optionen.gleiche_laenge = 'zeros';
end;
if (~isfield(optionen, 'importfct'))
   optionen.importfct = 'fgetl';
end;
if (~isfield(optionen, 'ignore_firstlines'))
   optionen.ignore_firstlines = [];
end;
if isempty(optionen.ignore_firstlines)
   optionen.ignore_firstlines = 0;
end;

if (~isfield(optionen, 'ignoriere_zeilen_mit'))
   optionen.ignoriere_zeilen_mit = [];
end;

% Zunächst unterscheiden, ob eine Datei oder ein Ordner angegeben wurde.
mydata = [];
ausgangsgroessen = [];
bez = [];
if (exist(quelle, 'dir'))
   if (quelle(end) == '\')
      quelle = quelle(1:length(quelle)-1);
   end;
   % Suche nach Dateien, die eingelesen werden können
   fprintf(1, 'Searching for files...');
   try
      filelist = getsubdir(quelle,['*' optionen.dateiendung],optionen.ordner_rekursiv);
      filelist = char(filelist.name);
      fprintf(1, 'ready\n');
      cd(quelle);
   catch
      myerror('Error by reading from file (e.g. no files found).');
   end;
   
   % und extrahiere die Klassenbezeichnungen
   anz_codes = [];
   if optionen.separate_projects == 0
      code = cell(0);
      fprintf(1, 'Extract output variable...');
      
      %unterschiedliche Pfadlänge für Ausgangsgrößen?
      max_classen_o = 0;
      
      for i = 1:size(filelist,1)
         string = deblank(filelist(i,:));
         % Entferne die Quelle. Die hat nichts mit den Klassenbezeichnern zu tun.
         string = strrep(string, [quelle '\'], '');
         % Nun den Pfad zerlegen und anschließend den Dateinamen
         [pfad, datei] = fileparts(string);
         
         %bei Pfad fileseprator und Trennzeichen erkennen!!
         pfad_name = pfad;
         if ~isempty(optionen.klassentrennzeichen.ordner)
            pfad_name = strrep(pfad,optionen.klassentrennzeichen.ordner,'*');
         end;
         pfad_name = strrep(pfad_name,filesep,'*');
         
         klassen_o = get_klassen(pfad_name, '*');
         klassen_d = get_klassen(datei, optionen.klassentrennzeichen.datei);
         % Merke zum einen die Bezeichner, zum anderen aber auch die Anzahl, um verschiedene
         % Hierarchiestufen erkennen zu können.
         % Die Klassen-Klassen können leer sein (wenn der Pfad leer ist),
         if (~isempty(klassen_o))
            code(i, 1:length(klassen_o)) = klassen_o;
         end;
         
         %Handling unterschiedlich tief verschachtelter Pfade - muss ja nicht gleich abstürzen
         max_classen_o = max(max_classen_o,length(klassen_o));
         if max_classen_o > length(klassen_o)
            for i_cl = length(klassen_o)+1 : max_classen_o
               code(i, 1:length(klassen_o)) = 'unknown';
            end;
         end;
         
         % die Datei-Klassen nicht!
         code(i, max_classen_o+[1:length(klassen_d)]) = klassen_d;
         anz_codes(i) =length(klassen_d);
      end; % for(i = 1:size(filelist,1))
      anz_codes = anz_codes+max_classen_o;
      
      fprintf(1, 'ready\n');
      fprintf(1, 'Evaluating output variables...\n');
      % Um konsistente Ausgangsgrößen zu haben, müssen alle eingelesenen Dateien die gleiche Hierarchiestufen enthalten.
      % Sind also verschiedene Anzahlen vorhanden, stimmt etwas nicht.
      [anzs, I, J] = unique(anz_codes);
      if (length(anzs) ~= 1)
         fehlerstring= sprintf('Error! Different class numbers found.\n');
         for i = 1:length(anzs)
            fehlerstring=strcat(fehlerstring,sprintf('%d files with  %d output variables\n', length(find(J==i)), anzs(i)));
         end;
         fehlerstring=strcat(fehlerstring,'Possible reason: A file with the same extension but with different an incompatible content exist (e.g. a text file explanations).');
         fehlerstring=strcat(fehlerstring,sprintf('Please correct the directory and file names.\n'));
         mydata = [];
         code = [];
         bez = [];
         myerror(fehlerstring);
         return;
      end; % if (length(anzs) ~= 1)
   end;
   
   % Nun noch die Dateien einlesen...
   cdata = cell(0);
   max_samples = -Inf;
   anz_zr = 0;
   fprintf(1, 'Read data.\n');
   for i = 1:size(filelist,1)
      try
         [ndata, bez,ausgangsgroessen_temp] = get_single_data(deblank(filelist(i,:)), optionen);
         % Merke die Anzahl an Zeitreihen
         if (anz_zr == 0)
            anz_zr = size(ndata,2);
         end;
         % Prüfe, ob die Anzahl korrekt ist. Ansonsten ignoriere diese Daten.
         if (anz_zr ~= size(ndata,2)) && (optionen.separate_projects == 0 )
            fprintf(1, 'Error by importing data from %s. Different number of time series in the chosen files! \n', deblank(filelist(i,:)));
            %Ausgangsgröße entsorgen
            code(size(cdata,1)+1,:) = [];
         else
            cdata{end+1, 1} = ndata;
            if optionen.separate_projects == 1
               if optionen.inhalt == 2
                  d_org = squeeze(ndata);
                  dorgbez = bez;
                  if isempty(ausgangsgroessen_temp)
                     code    = ones(size(d_org,1),1);
                     eval(sprintf('save(''%s'',''d_org'',''code'',''dorgbez'',''-mat'')',strrep(filelist(i,:),optionen.dateiendung,'.prjz')));
                  else
                     code_alle = ausgangsgroessen_temp.code;
                     zgf_y_bez = ausgangsgroessen_temp.zgf_y_bez;
                     bez_code  = ausgangsgroessen_temp.bez_code;
                     code = code_alle(:,1);
                     eval(sprintf('save(''%s'',''d_org'',''code'',''dorgbez'',''code'',''code_alle'',''zgf_y_bez'',''bez_code'',''-mat'')',strrep(filelist(i,:),optionen.dateiendung,'.prjz')));
                  end;
               else
                  clear d_orgs;
                  d_orgs(1,:,:) = ndata;
                  var_bez = bez;
                  code = 1;
                  eval(sprintf('save(''%s'',''d_orgs'',''code'',''var_bez'',''-mat'')',strrep(filelist(i,:),optionen.dateiendung,'.prjz')));
               end;
            end;
            fprintf(1, '%s successfully read... (%d remaining files)\n', deblank(filelist(i,:)), size(filelist,1)-i);
         end;
         % Und merke die maximale Anzahl an Abtastpunkten.
         if(size(ndata,1) > max_samples)
            max_samples = size(ndata,1);
         end;
      catch
         
         
         
         if optionen.separate_projects == 0
            code(size(cdata,1)+1,:) = [];
         end;
         if optionen.ignore_warnings == 0 && isempty(strfind(get(0,'errormessage'),'Interrupt'))
            mywarning(sprintf('Error by reading from file  %s',deblank(filelist(i,:))));
         end;
         error_message_batch(pwd,deblank(filelist(i,:)),'Reading error');
      end;
      
   end; % for(i = 1:size(filelist,1))
   
   if optionen.separate_projects == 1
      mydata = [];
      bez  = [];
      ausgangsgroessen =[];
      code =[];
      
   else
      % Hier einmal testen, ob die resample-Funktion zur Verfügung steht:
      
      try
         % Die Rückgabe interessiert nicht. Aber die Ausführung stürzt ab und gelangt in den catch-Teil,
         % wenn die Funktion nicht verwendet werden kann.
         dummy = resample(1,1,1);
      catch
         mywarning('Resampling not possible without MATLAB Signal Processing Toolbox! Filling with zeros...');
         optionen.gleiche_laenge = 'zeros';
      end;
      
      % Nun wird eine Matrix gefüllt, die die späteren d_orgs-Dimensionen hat.
      % Die Frage ist nun, ob bei unterschiedlich langen Zeitreihen ein resampling gemacht werden soll, oder einfach
      % nur nullen angehängt werden, oder der letzte Wert bestehen bleibt.
      mydata = zeros(size(cdata,1), max_samples, anz_zr);
      fprintf(1, '\nCopy data in final matrix...');
      for i = 1:size(cdata,1)
         daten = cdata{i,1};
         if (size(daten,1) ~= max_samples)
            switch(optionen.gleiche_laenge)
               case 'resample'
                  mydata(i, :, :) = resample(daten, max_samples, size(daten,1));
               case 'zeros'
                  mydata(i, 1:size(daten,1), :) = daten;
               case 'last_value'
                  mydata(i, 1:size(daten,1), :) = daten;
                  mydata(i, size(daten,1)+1:end, :) = myResizeMat(daten(end, :), size(mydata,2)-size(daten,1), 1);
               case 'nan'
                  mydata(i, 1:size(daten,1), :) = daten;
                  mydata(i, size(daten,1)+1:end, :) = NaN;
            end; % switch(optionen.gleiche_laenge)
         else
            mydata(i, :, :) = daten;
         end; % if (size(daten,1) ~= max_laenge)
      end; % for(i = 1:size(cdata,1))
   end;
   fprintf(1, 'ready\n');
   % Nun umwandeln in Variablen, die Gait-CAD versteht.
   ausgangsgroessen = code2ausgangsgroessen(code);
   
else
   % Prüfen, ob die angegebene Datei existiert
   if (exist(quelle, 'file'))
      fprintf(1, 'Import file %s...\n', quelle);
      [mydata, bez,ausgangsgroessen] = get_single_data(quelle, optionen);
      fprintf(1, 'ready\n');
   else
      myerror(sprintf('File %s not found.\n', quelle));
   end;
end;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EINIGE UNTERFUNKTIONEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wandelt die verschiedenen Zeichenketten in code
% in zgf_y_bez und code um.
function [ausgangsgroessen] = code2ausgangsgroessen(code)
ausgangsgroessen.zgf_y_bez = [];
ausgangsgroessen.code = [];
count = 1;
for i = 1:size(code,2)
   namen = char(code{:, i});
   [B, I, J] = unique(namen, 'rows');
   % Wenn mehr als eine Ausgangsgröße vorhanden ist und sich einige nicht ändern,
   % dann entferne diese Ausgangsgröße.
   if ((size(code,2) > 1) && size(B,1) == 1)
      fprintf(1, 'Output variable %s is always the same. Removing output variable...\n', deblank(B(1,:)));
   else
      for j = 1:size(B,1)
         ausgangsgroessen.zgf_y_bez(count,j).name = deblank(B(j, :));
      end;
      ausgangsgroessen.code(:, count) = J;
      count = count + 1;
   end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Liest die Daten einer einzelnen Datei ein.
function [data, bez,ausgangsgroessen] = get_single_data(quelle, optionen)

ausgangsgroessen = [];

switch(optionen.importfct)
   case 'getdata'
      [data, bez,ausgangsgroessen] = import_getdata(quelle, optionen);
      
      if isempty(data) && ~isempty(ausgangsgroessen) && isfield(ausgangsgroessen,'code') && ~isempty(ausgangsgroessen.code)
         %only output variables found, add a dummy data variable
         data = ones(size(ausgangsgroessen.code,1),1);
         bez = 'dummy';
      end;
      
   case 'fgetl'
      [data, bez] = import_fgetl(quelle, optionen);
   case 'rewrite'
      [data, bez] = import_rewrite(quelle, optionen);
   case 'turbo'
      [data, bez] = import_turbomodus(quelle, optionen);
   case 'ascii'
      [data, bez] = import_standard_ascii(quelle);
   case 'importdata'
      [data, bez,ausgangsgroessen] = import_importdata(quelle,optionen);
end; % switch(optionen.importfct)

fprintf(1,'Import %s (%s)\n',quelle,optionen.importfct);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Daten über fgetl importieren.
function [mydata, bez] = import_fgetl(quelle, optionen)

mydata = [];
new_data = [];
% Datei öffnen und erste Zeile lesen.
fid = fopen(quelle, 'rt');

[bez,linecount] = ignore_first_lines(fid,optionen);
line = fgetl(fid);

% Die Daten werden zunächst in einem Cell-Array gespeichert. Da geht die Speicherallokation deutlich schneller
cdata = cell(0);
% Isempty(line) wird explizit erlaubt, da Leerzeilen in einer Datei vorkommen können!
while ischar(line)
   nein = 0;
   anz_zeilen=size(cdata,1);
   if (rem(anz_zeilen,100)==0)
      fprintf('%d\n',anz_zeilen);
   end;
   
   % Leere Zeilen werden ignoriert.
   if (isempty(line))
      nein = 1;
   end;
   % Zeilen, die mit optionen.ignoriere_zeilen_mit beginnen, werden ebenfalls ignoriert.
   if (~nein && ~isempty(optionen.ignoriere_zeilen_mit))
      tmp = line(end:-1:1); deblank(tmp); line = tmp(end:-1:1);
      if (line(1) == optionen.ignoriere_zeilen_mit)
         nein = 1;
      end;
   end;
   if (~nein)
      % Dezimalzeichen korrigieren?
      if (strcmp(optionen.dezimaltrennzeichen, ','))
         line = strrep(line, ',', '.');
      end; % if (strcmp(optionen.dezimaltrennzeichen, ','))
      % Spaltentrennzeichen sind bei str2num kein großes Problem. Leerzeichen, Komma, Tabulator funktionieren ohne Probleme.
      % Aber ; - _ sollten korrigiert werden. Also "Positiv-Liste" erzeugen und evtl. ersetzen:
      liste = {' ', ',', sprintf('\t')};
      if (~ismember(optionen.spaltentrennzeichen, liste))
         line = strrep(line, optionen.spaltentrennzeichen, ' ');
      end; % if (~ismember(optionen.spaltentrennzeichen, liste))
      new_data = str2num(line);
      if (isempty(new_data))
         mywarning(sprintf('Error in row %d! Cannot convert data into a number.\n', linecount));
      else % if (isempty(new_data))
         cdata{end+1, 1} = new_data;
      end; % if (isempty(new_data))
   end;
   line = fgetl(fid);
   linecount = linecount + 1;
end;
% Schließen der zu lesenden Datei
fclose(fid);
% Umwandeln der Daten in eine Matrix.
% myCellArray2Matrix schmiert oft mal mit Out-Of-Memory ab.
%data = myCellArray2Matrix(data);
% for-Schleife dauert zwar länger, ist aber ein wenig robuster.
if ~isempty(new_data)
   mydata = zeros(size(cdata,1), size(new_data,2));
   for i = 1:size(cdata,1)
      mydata(i, :) = cdata{i,1};
   end;
end;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zunächst alle Zeilen am Anfang entfernen, die
% keine Daten enthalten, dann Datei schreiben und
% über load -ascii auslesen
function [mydata, bez] = import_rewrite(quelle, optionen)

fid = fopen(quelle, 'rt');
[bez,linecount] = ignore_first_lines(fid,optionen);
line = fgetl(fid);
linecount = linecount+1;

dont_write = 1;
% Temporäre Datei öffnen
fid_neu = fopen('sakjdh123hasd.dat', 'wt');
while ischar(line)
   nein = 0;
   % Leere Zeilen werden ignoriert.
   if (isempty(line))
      nein = 1;
   end;
   % Zeilen, die mit optionen.ignoriere_zeilen_mit beginnen, werden ebenfalls ignoriert.
   if (~nein && ~isempty(optionen.ignoriere_zeilen_mit))
      tmp = line(end:-1:1); deblank(tmp); line = tmp(end:-1:1);
      if (line(1) == optionen.ignoriere_zeilen_mit)
         nein = 1;
      end;
   end;
   
   if (~nein)
      % Dezimaltrennzeichen korrigieren?
      if (strcmp(optionen.dezimaltrennzeichen, ','))
         line = strrep(line, ',', '.');
      end; % if (strcmp(optionen.dezimaltrennzeichen, ','))
      % Spaltentrennzeichen sind bei str2num kein großes Problem. Leerzeichen, Komma, Tabulator funktionieren ohne Probleme.
      % Aber ; - _ sollten korrigiert werden. Also "Positiv-Liste" erzeugen und evtl. ersetzen:
      liste = {' ', ',', sprintf('\t')};
      if (~ismember(optionen.spaltentrennzeichen, liste))
         line = strrep(line, optionen.spaltentrennzeichen, ' ');
         optionen.spaltentrennzeichen = ' ';
      end;
      % Solange die Datei keine Zeichen enthält, werden die Daten ignoriert
      if (dont_write && ~isempty(str2num(line)))
         dont_write = 0;
      end;
      % Diese Daten werden in eine neue Datei geschrieben, die anschließend über load -ascii geladen werden kann.
      if (~dont_write)
         fprintf(fid_neu, '%s\n', line);
      end;
   end; % if (~nein)
   line = fgetl(fid);
end;
fclose(fid);
fclose(fid_neu);
% Anschließend die Daten einfach auslesen
mydata = dlmread('sakjdh123hasd.dat', optionen.spaltentrennzeichen);
delete('sakjdh123hasd.dat');

if isempty(mydata) 
   fehlerstring = strcat('Error by loading from file!',' Source file:',quelle,' The ASCII file might be invalid.!');
   mywarning(fehlerstring);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zunächst alle Zeilen am Anfang entfernen, die
% keine Daten enthalten, dann Datei schreiben und
function [sakjdh123hasd, bez] = import_turbomodus(quelle, optionen)

fid = fopen(quelle, 'rt');

bez = ignore_first_lines(fid,optionen);

fprintf('Read data.\n');
% Temporäre Datei öffnen
fprintf('Load temporary file.\n');
fid_neu = fopen('sakjdh123hasd.dat', 'wt');

anz_mb=0;
while 1
   inhalt=fscanf(fid,'%c',10E6);
   if isempty(inhalt)
      break;
   end;
   if (optionen.dezimaltrennzeichen~='.')
      inhalt(inhalt==optionen.dezimaltrennzeichen)='.';
   end;
   if (optionen.spaltentrennzeichen~=' ')
      inhalt(inhalt==optionen.spaltentrennzeichen)=' ';
   end;
   fprintf(fid_neu,'%c', inhalt);
   %Fortschrittsanzeige
   anz_mb=anz_mb+1;
   fprintf('%d MB\n',10*anz_mb);
end;

fclose(fid);

fprintf('Close temporary file.\n');
fclose(fid_neu);

% Anschließend die Daten einfach auslesen
try
   load sakjdh123hasd.dat -ascii
   fehlerstate = 0;
catch
   fehlerstate = 1;   
end;
delete('sakjdh123hasd.dat');
fprintf('Temporary file deleted.\n');

if fehlerstate == 1 || isempty(sakjdh123hasd)
   fehlerstring = strcat('Error by loading from file!',' Source file:',quelle,' The ASCII file might be invalid.!');
   mywarning(fehlerstring);   
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mydata, bez] = import_standard_ascii(quelle)

bez = [];
mydata = [];
fprintf('Read data.\n');
try
   mydata = load(quelle, '-ascii');   
   fehlerstate = 0;
catch
   fehlerstate = 1;   
end;
fprintf('Ready\n');

if fehlerstate == 1 || isempty(mydata)
   fehlerstring = strcat('Error by loading from file!',' Source file:',quelle,' The ASCII file might be invalid.!');
   mywarning(fehlerstring);   
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Daten mit getdata importieren
function [mydata, bez,ausgangsgroessen] = import_getdata(quelle, optionen)

[temp,mydata,bez,ausgangsgroessen.code,ausgangsgroessen.zgf_y_bez,ausgangsgroessen.bez_code]=getdata(quelle, optionen.ignore_firstlines+1, 0, 0, [optionen.spaltentrennzeichen 10],strcmp(optionen.dezimaltrennzeichen, ','));

%cannot handle output variables for time series
if optionen.inhalt == 1
   ausgangsgroessen = [];
end;

if isfield(ausgangsgroessen,'code') && isempty(ausgangsgroessen.code)
   ausgangsgroessen = [];
end;

if isempty(mydata) && isempty(ausgangsgroessen)
   fehlerstring = strcat('Error by loading from file!',' Source file:',quelle,' The ASCII file might be invalid.!');
   mywarning(fehlerstring);
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Daten mit importdata importieren
function [mydata, bez,ausgangsgroessen] = import_importdata(quelle, optionen)

if (optionen.dezimaltrennzeichen~='.')
   fid = fopen(quelle, 'rt');
   fprintf('Read data.\n');
   % Temporäre Datei öffnen
   fprintf('Load temporary file.\n');
   fid_neu = fopen('sakjdh123hasd.dat', 'wt');
   anz_mb=0;
   while 1
      inhalt=fscanf(fid,'%c',10E6);
      if isempty(inhalt)
         break;
      end;
      if (optionen.dezimaltrennzeichen~='.')
         inhalt(inhalt==optionen.dezimaltrennzeichen)='.';
      end;
      fprintf(fid_neu,'%c', inhalt);
      %Fortschrittsanzeige
      anz_mb=anz_mb+1;
      fprintf('%d MB\n',10*anz_mb);
   end;
   fclose(fid);
   myresults = importdata('sakjdh123hasd.dat',optionen.spaltentrennzeichen);
else
   myresults = importdata(quelle,optionen.spaltentrennzeichen);
end;

%numbers
if ~isfield(myresults,'data')
   myerror(sprintf('Function importdata did not found data in the file %s.',quelle));
else
   mydata = myresults.data;
end;

%be careful if information is also in colheaders, trust them more 
if isfield(myresults,'textdata') && isfield(myresults,'colheaders')
   myresults.textdata = myresults.colheaders;
end;

if optionen.firstline_bez
   %interpret first line as variable names
   try
      %check output variables
      i_output = 1;
      datarow = [];
      ausgangsgroessen = [];
      for i_row=1:size(myresults.textdata,2)
         if (size(myresults.textdata,1)>optionen.ignore_firstlines+1) && ~isempty(myresults.textdata{optionen.ignore_firstlines+2,i_row})
            %column is a string
            ausgangsgroessen.code(1:size(mydata,1),i_output) = [1:size(mydata,1)]';
            for i_column = 1:size(mydata,1)
               ausgangsgroessen.zgf_y_bez(i_output,i_column).name = char(myresults.textdata(optionen.ignore_firstlines+1+i_column,i_row));
            end;
            if ~isfield(ausgangsgroessen,'bez_code')
               ausgangsgroessen.bez_code = myresults.textdata{optionen.ignore_firstlines+1,i_row};
            else
               ausgangsgroessen.bez_code = strvcatnew(ausgangsgroessen.bez_code,myresults.textdata{optionen.ignore_firstlines+1,i_row});
            end;
            i_output = i_output+1;
         else
            %column is a number
            datarow = [datarow i_row];
         end;
      end;
      %collect names of rows that are numbers
      bez = char(myresults.textdata(optionen.ignore_firstlines+1,datarow));
   catch
      bez = '';
   end;
else
   bez = '';
end;


if isempty(mydata) 
   fehlerstring = strcat('Error by loading from file!',' Source file:',quelle,' The ASCII file might be invalid.!');
   mywarning(fehlerstring);
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bez,linecount] = ignore_first_lines(fid,optionen)

%initialize without names
bez = [];
linecount = 0;

for i_ignore = 1: optionen.ignore_firstlines
   if i_ignore==1
      fprintf('Ignore %d rows.\n',optionen.ignore_firstlines);
   end;
   line = fgetl(fid);
   linecount = linecount+1;   
end;

% Bezeichner extrahieren (wenn vorhanden)
if (optionen.firstline_bez)
   
   line = fgetl(fid);
   linecount = linecount+1;
   if ~isempty(optionen.ignoriere_zeilen_mit) 
      while 1
         if ~isempty(line) && line(1) ==  optionen.ignoriere_zeilen_mit(1)
            line = fgetl(fid);
             linecount = linecount+1;   
         else
            break;
         end;         
      end;
   end;
   
   [t,r] = strtok(line, optionen.spaltentrennzeichen);
   while(~isempty(r))
      bez = strvcatnew(bez, t);
      [t, r] = strtok(r, optionen.spaltentrennzeichen);
   end; % while(~isempty(r))
   bez = strvcatnew(bez, t);
   
end; % if (optionen.firstline_bez)
