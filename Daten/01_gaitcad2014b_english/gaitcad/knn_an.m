  function [pos, md, prz] = knn_an(dat, knn_param, knn_dat)
% function [pos, md, prz] = knn_an(dat, knn_param, knn_dat)
%
%  dat: Datenmatrix der Größe #Beobachtungen x #Merkmale
%  knn_param: Strukt mit Feldern:
%  - normieren: Gibt an, ob die Daten auf den Bereich [0,1] normiert werden sollen
%  (default: 1)
%  - metrik: Metrik für Distanzmatrix, siehe pdist für Möglichkeiten (default: euclid)
%  - k: wie viele Nachbarn sollen betrachtet werden (default: 1)
%  - region: sollen alle Nachbarn in einer Region betrachtet werden? (default: [])
%  Gibt die Grenze der Region vom betrachteten Tupel an. Wenn nicht gewünscht,
%  weglassen oder leer.
%  - wichtung: Gibt an, ob die Nachbarn nach ihren Abständen gewichtet werden sollen
%  0: keine Wichtung, 1: linear von 0 bis 1 (default), 2: 1/Abstand, 3: exp(-a*Abstand^b)
%  - knn_param.max_abstand: Wenn alle zu betrachtenden Nachbarn außerhalb des Abstandes
%  knn_param.max_abstand liegen, wird für diesen Tupel keine Entscheidung  getroffen und für
%  pos ein NaN zurückgegeben.
%  - knn_param.max_abstand_anz: Option, um für obiges Vorgehen Ausnahmen zuzulassen. Wenn nicht mindestens
%  knn_param.max_abstand_anz Nachbarn innerhalb des maximalen Abstandes liegen, wird für das betrachtete
%  Datentupel keine Entscheidung getroffen und NaN in pos eingetragen.
%  knn_dat: Strukt, das von knn_en zurückgegeben wird. Enthält Daten nach dem Anlernen
%  des Klassifikators.
%  Rückgaben:
%  pos: geschätztes Klassenlabel des Datentupels
%  prz: relative Anzahl an Nachbarn verschiedener Klassen (Dimension: #Anzahl Datentupel x max. Klasse)
%  md: Nur aus Kompatibiltätsgründen. Enthält das Gleiche wie prz (Dimension: #Anzahl Datentupel x max. Klasse)
% 
%
% The function knn_an is part of the MATLAB toolbox Gait-CAD. 
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
   knn_param = [];
end;
if (~isfield(knn_param, 'normieren'))
   knn_param.normieren = 1;
end;
if (~isfield(knn_param, 'metrik'))
   knn_param.metrik = 'euclid';
end;
if (~isfield(knn_param, 'k'))
   knn_param.k = 1;
end;
if (~isfield(knn_param, 'region'))
   knn_param.region = [];
end;
if (~isfield(knn_param, 'wichtung'))
   knn_param.wichtung = 0;
end;
if (~isfield(knn_param, 'max_abstand'))
   knn_param.max_abstand = [];
end;
if (~isfield(knn_param, 'max_abstand_anz') || isempty(knn_param.max_abstand_anz))
   knn_param.max_abstand_anz = knn_param.k;
end;
if (~isfield(knn_param, 'regression'))
   knn_param.regression = 0;
end;

if (nargin < 3)
   mywarning('Error! Nearest neighbor classifier not yet designed!');
   return;
end;

if (~isempty(knn_param.max_abstand) && ~isempty(knn_param.region) && knn_param.max_abstand < knn_param.region)
   knn_param.max_abstand = knn_param.region;
end;

code = knn_dat.code;
[N, s_z] = size(dat);
klassen = unique(code);
anz_klassen = length(klassen);

% Zu klassifizierende Daten normieren. Entweder, wenn der "Schalter" auf 1 ist,
% oder, wenn die Lerndaten normiert wurden.
if (knn_param.normieren || knn_dat.normieren)
   [dat] = matrix_normieren(dat,2, knn_dat.min, knn_dat.diff);
end;
if (strcmp(knn_param.metrik, 'euclid'))
   Y = som_eucdist2(knn_dat.dat, dat);
   Y = Y';
   % s.o.
   Y = sqrt(Y);
else
   % Zunächst die Lern- und Testdaten zusammen in eine Matrix
   try
      Y = pdist([knn_dat.dat; dat], knn_param.metrik);
      % Auf quadratische Form bringen.
      Y = squareform(Y);
      % Nur die Abstände der Test- zu den Lerndaten betrachten.
      Y = Y(size(knn_dat.dat,1)+1:end, 1:size(knn_dat.dat,1));
   catch
      myerror('This function needs the Statistics Toolbox. Please chose the Euclidean distance.');
      return;
   end;
end;

% Sortiere die Abstände.
[Y, Y_indx]=sort(Y, 2);
% Erzeuge eine Matrix, die eine Null enthält, wenn der Abstand zum Nachbarn
% größer ist als knn_param.region, ansonsten eine 1.
map = zeros(size(Y));
if (~isempty(knn_param.region))
   map(find(Y < knn_param.region)) = 1;
end;
% Es sollen aber mindestens knn_param.k Nachbarn betrachtet werden.
map(:, 1:knn_param.k) = 1;

% Sollen alle Nachbarn in einem bestimmten Gebiet betrachtet werden?
% Dadurch kann die Dichte an Realisierungen in einem Gebiet besser
% berücksichtigt werden.
if (~isempty(knn_param.region))
   % Die Nachbarn, die innerhalb der Region liegen werden in nachbarn
   % gespeichert.
   nachbarn = map .* Y_indx;
   nachbarn_klassen = zeros(size(nachbarn));
   % Speicher die Klassen der Nachbarn innerhalb einer Region.
   indx = find(nachbarn ~= 0);
   nachbarn_klassen(indx) = knn_dat.code(nachbarn(indx));
   
   % Die Abstände der k nächsten Nachbarn
   nachbarn_abst = map .* Y;
   wichtung = berechneWichtung(nachbarn_abst, knn_param.wichtung, knn_param.k);
   % Sollen zu große Abstände entfernt werden?
   if (~isempty(knn_param.max_abstand))
      [wichtung_max_abstand, rueck] = berechneWichtung(nachbarn_abst, -1, knn_param.k, knn_param.max_abstand, knn_param.max_abstand_anz);
      % In wichtung_max_abstand steht nun entweder eine 1, oder eine null. Einfach mit der  bisherigen
      % Wichtung multiplizieren, schon ist die Geschichte fertig:
      wichtung = wichtung .* wichtung_max_abstand;
   end;
   
     
   if knn_param.regression == 0
      %Klassifikation!!
      e = zeros(N, anz_klassen);
      
      % Ab hier mit for-Schleife. Es muss zeilenweise gezählt werden,
      % wie viele Beispiele für die verschiedenen Klassen vorhanden sind.
      for n = 1:size(nachbarn_klassen,1)
         vek = nachbarn_klassen(n, :);
         for i = 1:anz_klassen
            tmp_kl = (vek == klassen(i));
            tmp_kl = tmp_kl .* wichtung(n, :);
            e(n, i) = sum(tmp_kl);
         end; % for(i = 1:anz_klassen)
      end; % for(n = 1:size(nachbarn_klassen,1))
   end;
   
   
else % if (~isempty(knn_param.region))
   % Besorge die k nächsten Nachbarn...
   nachbarn = Y_indx(:, 1:knn_param.k);
   % und speichere die Klassencodes.
   nachbarn_klassen = knn_dat.code(nachbarn);
   
   % Die Abstände der k nächsten Nachbarn
   nachbarn_abst = Y(:, 1:knn_param.k);
   wichtung = berechneWichtung(nachbarn_abst, knn_param.wichtung, knn_param.k);
   % Sollen zu große Abstände entfernt werden?
   if (~isempty(knn_param.max_abstand))
      % Der zweite Parameter gibt die Anzahl der Nachbarn an, die einen größeren Abstand haben, als
      % erlaubt.
      [wichtung_max_abstand, rueck] = berechneWichtung(nachbarn_abst, -1, knn_param.k, knn_param.max_abstand, knn_param.max_abstand_anz);
      % In wichtung_max_abstand steht nun entweder eine 1, oder eine null. Einfach mit der  bisherigen
      % Wichtung multiplizieren, schon ist die Geschichte fertig:
      wichtung = wichtung .* wichtung_max_abstand;
   end;
   if knn_param.regression == 0
      %Klassifikation!!
      e = zeros(N, anz_klassen);
      % Bestimme die Anzahl der Nachbarn für eine Klasse.
      for i = 1:anz_klassen
         tmp_kl = (nachbarn_klassen == klassen(i));
         tmp_kl = tmp_kl .* wichtung;
         e(:, i) = sum(tmp_kl, 2);
      end;
   end;  
   
end; % if (~isempty(knn_param.region))

if knn_param.regression == 0
   %Klassifikation!!
   
   % In e stehen nun die Anzahlen der Vertreter einer Klasse. Für die Entscheidung wird
   % die häufigste verwendet.
   % Bei gleichhäufigen Klassen wird zufällig eine der Klassen ausgewählt.
   % Bringe die Klassen in eine zufällige Reihenfolge.
   % Gibt es nur ein Maximum, wird es trotzdem gefunden. Klassen mit gleichvielen
   % Vertretern werden auf die Weise aber zufällig gewählt.
   perm = randperm(anz_klassen);
   e_orig = e;
   e = e(:, perm);
   [dummy, pos] = max(e, [], 2);
   % Bestimme die gewählte Klasse (ist Index in perm)
   pos = perm(pos);
   pos = klassen(pos);
   e = e_orig;
   sum_e = sum(e,2);
   prz = zeros(size(e));
   % Die Summe ist nur null, wenn der maximale Abstand zu einem Nachbarn eingeschränkt wird!
   indx = find(sum_e ~= 0);
   if (~isempty(indx))
      prz(indx,:) = e(indx,:) ./ myResizeMat(sum_e(indx), 1, anz_klassen);
   end;
   % Die, bei denen die Summe 0 ist, werden auf NaN gesetzt und die prz auf die Anzahl an Nachbarn, die
   % zu große Abstände hatten:
   indx = find(sum_e == 0);
   if (~isempty(indx))
      pos(indx) = NaN;
      prz(indx,:) = myResizeMat(rueck(indx), 1, size(prz,2));
   end;
   knn_dat.e = e;
   
   % Aus Kompatiblitätsgründen zu anderen Klassifikatoren werden in prz nicht nur die übergebenen Klassen
   % gespeichert, sondern alle bis zur maximalen Klasse:
   if nargout>1
      prz_neu = zeros(N, max(klassen));
      for i = 1:length(klassen)
         prz_neu(:, klassen(i)) = prz(:,i);
      end;
      prz = prz_neu;
      
      % Nur aus Kompatibilitätsgründen!
      md = prz;
   end;
else
   %Regression
   %vorbeugende Normalisierung
   wichtung=wichtung+1E-10;
      
   %Umgang mit Nachbarn 0 geht nicht!!
   wichtung (nachbarn == 0) = 0;
   nachbarn (nachbarn == 0) = 1;

   %Wichtungsumme 1
   wichtung = wichtung./(sum(wichtung,2)*ones(1,size(wichtung,2)));  

   
   pos = sum(wichtung .* knn_dat.code(nachbarn),2);
   prz=[];
   md =[];
end;   

% Subfunktion für die Berechnung von Wichtungsfaktoren.
% Bestimmt auch Ausreißer anhand von zu wenigen Nachbarn, innerhalb 
% eines definierten Abstands haben (typ = -1).
function [wichtung, rueck] = berechneWichtung(nachbarn_abst, typ, k, a, b)
if (nargin < 4)
   if (typ == 3)
      warning('Unknown parameter!');
   end;
   a = 1;
end;
if (nargin < 5)
   if (typ == 3)
      warning('Unknown parameter!');
   end;
   b = 1;
end;

wichtung = ones(size(nachbarn_abst));
switch (typ)
case -1
   % -1 ist nicht aus der Oberfläche wählbar.
   % Hier werden diejenigen Datentupel gesucht, die zu wenig Lerndatenbeispiele in der näheren Umgebung
   % (innerhalb von knn_param.max_abstand) haben. Dann werden alle Nachbarn mit null gewichtet.
   rueck = sum(nachbarn_abst(:, 1:k) <= a, 2);
   indx = find(rueck < b);
   wichtung(indx, :) = 0;
   
   % Entferne alle Datentupel außerhalb von a, aber nur bei den Beobachtungen,
   % die genau k Datentupel betrachten (das sind dann die, die innerhalb der ersten
   % Region zu wenig hatten).
   %indx = find(rueck >= b & rueck <= k); % Coderevision: &/| checked!
   %for(i = 1:length(indx))
   %   tmp = find(nachbarn_abst(indx(i), :) > a);
   %   wichtung(indx(i), tmp) = 0;
   %end;
   % Für die verschiedenen Wichtungen siehe Daelemans01, Daelemans02   
case 1
   dk = max(nachbarn_abst, [], 2);
   d1 = min(nachbarn_abst, [], 2);
   faktor = dk-d1;
   faktor(faktor == 0) = NaN;
   wichtung = (myResizeMat(dk, 1, size(nachbarn_abst,2))-nachbarn_abst) ./ myResizeMat(faktor, 1, size(nachbarn_abst,2));
   wichtung(isnan(wichtung)) = 1;
case 2
   istnull = find(nachbarn_abst == 0);
   %neu: Abstand Null wird in der Wichtung auf den kleinsten Nicht-Null-Abstand gesetzt 
   temp_nachbarn_abst = nachbarn_abst;
   %Nullen auf den größten Wert setzen
   temp_nachbarn_abst(istnull) = max(max(nachbarn_abst));
   temp_nachbarn_abst = min(temp_nachbarn_abst,[],2)*ones(1,size(temp_nachbarn_abst,2));

   %nachbarn_abst(istnull) = nachbarn_abst(istnull) + 1e-10;
   nachbarn_abst(istnull) = temp_nachbarn_abst(istnull);
   wichtung = 1 ./ nachbarn_abst;
case 3
   nachbarn_abst = nachbarn_abst .^ b;
   nachbarn_abst = nachbarn_abst .* a;
   wichtung = exp(-nachbarn_abst);
end;


