% Script one_against_x_an
%
% The script one_against_x_an is part of the MATLAB toolbox Gait-CAD. 
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

typ = kp.mehrklassen - 1;
svm_md = [];

% Fehlt eventuell eine benötigte Variable in klass_single?
if (typ == 1 && (~isfield(klass_single(1), 'one_against_all') || isempty(klass_single(1).one_against_all)))
   error('No one-against-all classifier given! Cancel!');
end;
if (typ == 2 && (~isfield(klass_single(1), 'one_against_one') || isempty(klass_single(1).one_against_one)))
   error('No one-against-one classifier given! Cancel!');
end;

% Lege Speicher an für die Klassifikatorentscheidung
prz_oax = zeros(length(ind_auswahl), kp.anz_class);
md_oax  = zeros(length(ind_auswahl), kp.anz_class);
% Auch noch mal die einzelnen Klassifikatorentscheidungen direkt speichern.
% Falls nicht eine Entscheidung über die einzelnen prz fallen soll, sondern
% direkt die häufigste Wahl. Der Unterschied: knappe Entscheidungen fallen bei
% der Analyse von prz weniger ins Gewicht. Bei der Verwendung der direkten Entscheidung
% spielt die Sicherheit der Entscheidung keine Rolle.
pos_ges = zeros(length(ind_auswahl), kp.anz_class);

global global_plot_off;
global_plot_off = 1;
% Den Fortschritt für die Gesamtzahl an Klassifikatoren anzeigen:
if (~exist('one_against_x_waitbar', 'var'))
   one_against_x_waitbar = 1;
end;
hwb.laenge = length(klass_single);
if (one_against_x_waitbar)
   hwb.handle = waitbar(0, 'Apply classifiers');
end;
for ks_count = 1:length(klass_single)
   %aggregierte Merkmale zusammenstellen
   d=erzeuge_datensatz_an(d_org,klass_single(ks_count).merkmalsextraktion);
   
   % Den aktuellen Klassifikator anwenden:
   [temp_pos, temp_md, temp_prz, temp_svm_md] = klassifizieren_an(klass_single(ks_count), d(ind_auswahl,:), kp);
   % one_against_all
   if (typ == 1)
      akt_klasse = klass_single(ks_count).one_against_all.angelernt;
      % Jeweils nur die erste Spalte in prz und md verwenden!
      prz_oax(:, akt_klasse)   = temp_prz(:, 1);
      md_oax (:, akt_klasse)   = temp_md (:, 1);
      % Hier kann pos_ges nicht direkt verwendet werden, da als Entscheidung immer eine 1 oder 2 herauskommt.
      % Bei der 2 ("alle anderen") wird dann in pos_ges eine Null gelassen und nur bei einer Entscheidung für 1
      % die aktuell betrachtete Klasse verwendet:
      temp = find(temp_pos == 1);
      pos_ges(temp, akt_klasse) = pos_ges(temp, akt_klasse) + 1;
      
      % Aus Kompatibilitätsgründen zu anderen Funktionen muss bei der SVM ein svm_md herauskommen.
      % In svm_md sind die Abstände zu den verschiedenen Klassengrenzen gespeichert.
      if (strcmp(kp.klassifikator, 'svm'))
         svm_md(akt_klasse).ypred = temp_svm_md(1,2).ypred;
      end; % if (strcmp(kp.klassifikator, 'svm'))
   else % one_against_one
      % Welche beiden Klassen werden vom Klassifikator unterschieden?
      akt_klassen = klass_single(ks_count).one_against_one.angelernt;
      % Zu großem prz addieren (aus turnierklass_an aus DaveDesign):
      prz_oax(:, akt_klassen) = temp_prz(:, akt_klassen) + prz_oax(:, akt_klassen);
      md_oax (:, akt_klassen) = temp_md (:, akt_klassen) + md_oax (:, akt_klassen);
      
      % Bei pos_ges hochzählen, auf welche Klasse die Entscheidung gefallen ist:
      indx = sub2ind(size(pos_ges), [1:size(pos_ges,1)]', temp_pos);
      pos_ges(indx) = pos_ges(indx) + 1;
      
      % s.o.
      if (strcmp(kp.klassifikator, 'svm'))
         svm_md(akt_klassen(1), akt_klassen(2)).ypred = temp_svm_md(1,2).ypred;
      end; % if (strcmp(kp.klassifikator, 'svm'))
   end; % if (typ == 1)
   % Anzeige des Fortschritts?
   if (one_against_x_waitbar)
      waitbar(ks_count/hwb.laenge, hwb.handle);
   end;
end; % for(ks_count = 1:length(klass_single))

% Nun gibt es zwei Möglichkeiten. Entweder wird prz als Entscheidung verwendet. Das bedeutete, dass
% die Sicherheit einzelner Entscheidungen in die endgültige Entscheidung einbezogen wird.
% Die andere Möglichkeit ist, sich für die Klasse zu entscheiden, die am häufigsten gewählt wurde:
%aus maximalen "Klassifizierungswahrscheinlichkeiten" die zugehörigen
%Klassen finden und in pos schreiben
% Bei one-against-one der SVM wird anhand von pos_ges entschieden!
if (typ == 1 || ~strcmp(kp.klassifikator, 'svm'))
   [prz_max,pos_oax]=max(prz_oax,[],2);
   pos(ind_auswahl) = pos_oax;
else
   % Herausfinden, welche Klasse am häufigsten vorgekommen ist
   
   [dummy, pos(ind_auswahl)] = max(pos_ges, [], 2);
   clear dummy;
end;
if (one_against_x_waitbar)
   close(hwb.handle);
end;
clear hwb one_against_x_waitbar;
clear global global_plot_off;