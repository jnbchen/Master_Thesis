% Script klassifizieren_zr_en
%
% Einzelmerkmale und ihre Namen retten
%
% The script klassifizieren_zr_en is part of the MATLAB toolbox Gait-CAD. 
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

d_org_rett=d_org;
dorgbez_rett=dorgbez;
%neue Einzelmerkmale haben die Namen der Zeitreihen
dorgbez=var_bez;

klass_zr.i = 0;
klass_zr.klass_single = [];

% Nur ausgewählte Zeitreihen für die Klassifikation verwenden?
if parameter.gui.klassifikation.merkmalsauswahl == 2
   if (kp.klassi_typ.typ == 4)
      mywarning('Only one selected feature for K4-type classifier! It is equivalent to a restricted K3!');
   end;
   % Bei ausgewählten Zeitreihen darf auf keinen Fall die alte ANOVA-Bewertung für die Bestimmung des
   % Abtastpunktes verwendet werden! Es sei denn, es wird ein K3 verwendet
   if (kp.klassi_typ.typ ~= 3)
      clear zr_rel;
   end;
   gew_zr = parameter.gui.merkmale_und_klassen.ind_zr;
else
   gew_zr = [1:size(d_orgs,3)];
   parameter.gui.merkmale_und_klassen.ind_zr   = [1:size(d_orgs,3)];
end;
% Auch für die Relevanzbewertung der Zeitreihen nur die gewählten verwenden.
zrs = gew_zr;
%evtl. vorhandene Trigger-ZR wird NICHT ausgewählt
if (kp.triggerzr > 0)
   if (ismember(kp.triggerzr, zrs))
      zrs(kp.triggerzr) = [];
   end;
end;
% Reduziere die Anzahl maximaler Merkmale im Falle "ausgewählter Merkmale".
% Problem: bei der Bestimmung des besten Abtastpunktes kommt es sonst zur Warnung, dass mehr
% Merkmale ausgewählt werden sollen als vorliegen. Diese Warnung wird mit der Reduktion der
% Anzahl auszuwählender Merkmale vermieden.
if (parameter.gui.klassifikation.merkmalsauswahl == 2)
   parameter.gui.klassifikation.merk_red = length(zrs);
end;

% Setze die Auswahl in die Oberfläche. Ist wichtig, da einige Funktionen auf
% das Oberflächenelement zugreifen!
inGUIIndx='CE_Auswahl_ZR';
inGUI;
%set(uihd(11,13), 'value', zrs); eval(get(uihd(11,13), 'callback'));

% Wichtig! Die ind_auswahl muss hier schon gesetzt sein. Sonst werden evtl.
% Merkmalsrelevanzen auch in Testdaten berechnet!
bestimme_anlernpunkte;

% In klass_zr.samples stehen die Abtastpunkte, zu denen angelernt wird.
% Aber vorsicht: die Abtastpunkte sind relativ zum Triggereignis!
te = kp.triggerevent.start;

%Triggerevents retten
triggerevent_rett = kp.triggerevent;

% Ein K5 sieht völlig anders aus.
% Die Zeitreihen werden in EM zerlegt und die Zeit als Merkmal angehängt.
if (kp.klassi_typ.typ == 5)
   % Zunächst einige geeignete Merkmale auswählen:
   % Zeitreihen,über ANOVA (ausgew. Datens. und ZR)
   %zr_rel_mode = 1;
   %berechne_zr_rel;
   %temp = max(alleMerk, [], 1);
   
   %Mindest-ANOVA-Wert, um eine ZR überhaupt mit einzubeziehen
   %schwelle = 0.1;
   %merkmal_auswahl_ = find(temp >= schwelle);
   merkmal_auswahl_ = [1:size(d_orgs,3)];
   merkmal_auswahl_(merkmal_auswahl_ == kp.triggerzr) = [];
   
   % Jeder wievielte Abtastpunkt soll betrachtet werden?
   samples = [te:kp.klassi_typ.x_abtast:te+kp.triggerevent.kmax-1];
   
   %nur für K5 separates Retten notwendig!!
   code_rett = code;
   ind_auswahl_rett = ind_auswahl;
   
   % Baue ein neues d_org, bei dem die Zeitpunkte als Realisierungen betrachtet werden.
   d_org = zeros(length(ind_auswahl)*length(samples), length(merkmal_auswahl_)+1);
   dorgbez = strcat('x',num2str([1:size(d_org,2)]'));
   code  = myResizeMat(code_rett(ind_auswahl), length(samples), 1);
   for i = 1:length(samples)
      sp = samples(i);
      start = (i-1)*length(ind_auswahl) + 1;
      ende  = start + length(ind_auswahl) - 1;
      d_org(start:ende, :) = [squeeze(d_orgs(ind_auswahl, sp, merkmal_auswahl_)) myResizeMat(sp, length(ind_auswahl), 1)];
   end;
   
   klass_zr.samples  = [1:kp.triggerevent.kmax];
   %immer nur der 1. Klassifikator
   klass_zr.aktiv    = ones(kp.triggerevent.kmax,1);
   %crisp statt fuzzy
   klass_zr.wichtung = ones(kp.triggerevent.kmax,1);
   
   ind_auswahl = [1:size(d_org,1)];
   % Für den Klassifikator "ausgewählte Merkmale" einstellen:
   %parameter.gui.klassifikation.merkmalsauswahl = 1;
   if (parameter.gui.klassifikation.merkmalsauswahl == 2)
      % Bei "ausgewählte Merkmale" diejenigen Einzelmerkmale auswählen, die auch als Zeitreihe
      % markiert waren. Zusätzlich die Zeit anhängen.
      parameter.gui.merkmale_und_klassen.ind_em = [zrs size(d_org,2)];
   else
      % Sollen nicht die ausgewählten Merkmale verwendet werden, hänge die
      % Zeit als vorausgewähltes Merkmal an. Bei univariaten Verfahren
      % wird die Vorauswahl allerdings ignoriert!
      if (parameter.gui.klassifikation.merkmalsauswahl ~= 3)
         % Preselection einstellen:
         parameter.gui.klassifikation.preselection_merkmale = 1;
         % Zeit als Preselection-Merkmal wählen.
         parameter.gui.merkmale_und_klassen.ind_em = size(d_org,2);
         % Anzahl zu wählender Merkmale um eins erhöhen:
         if (parameter.gui.klassifikation.merk_red < size(d_org,2))
            parameter.gui.klassifikation.merk_red = parameter.gui.klassifikation.merk_red + 1;
         end;
      end;
   end;
   dorgbez = strvcatnew(dorgbez(merkmal_auswahl_,:),'Time');
   
   % Außerdem die Merkmalsauswahl auf die gewählten + die Zeit setzen:
   %parameter.gui.merkmale_und_klassen.ind_em = [merkmal_auswahl_ size(d_org,2)];
   
   % Klassifikation,Entwurf
   callback_klassifikator_en;
   %Triggerevents retten
   kp.triggerevent = triggerevent_rett;
   
   
   %Trigger-Zeit als letztes Merkmal anhängen, die eigentliche Operation machen wir später
   %klass_single.merkmalsextraktion.merkmal_auswahl = [merkmal_auswahl_ size(d_orgs,3)+1];
   
   %Klassifikator merken...
   klass_zr.i = 1;
   % Muss hier als Cell-Array, da klass_single selbst auch ein Array sein kann!
   klass_zr.klass_single{klass_zr.i} = klass_single;
   
   % code wiederherstellen:
   code = code_rett; clear code_rett;
   ind_auswahl = ind_auswahl_rett;
end;

% Der K2 und K3-Klassifikator benötigen eine Extra-Behandlung:
% Zunächst für den besten Samplepunkt alles bestimmen (evtl. inkl. Aggregation):
if (kp.klassi_typ.typ == 3 || kp.klassi_typ.typ == 2)
   
   %Anlern-Zeitpunkt bestimmen, Indexrechnerei!!
   ind_sample = klass_zr.samples(1) + te - 1;
   %Eintragen als Einzelmerkmal
   d_org = zeros(size(d_orgs,1),size(d_orgs,3));
   d_org(ind_auswahl,:)=d_orgs(ind_auswahl,ind_sample,:);
   dorgbez = strcat('x',num2str([1:size(d_org,2)]'));
   
   % HACK: Für den Klassifikator K2 wird eine Diskriminanzanalyse auf 1 Merkmal durchgeführt:
   if (kp.klassi_typ.typ == 2)
      parameter.gui.klassifikation.anz_hk = 1;
      parameter.gui.klassifikation.merkmalsaggregation = 2;
      parameter.gui.klassifikation.klassifikator = 1;
      parameter.gui.klassifikation.bayes.metrik = 1;
      parameter.gui.klassifikation.mehrklassen = 1;
   end;
   % Wenn nur die ausgewählten Zeitreihen verwendet werden sollen, müssen diese im Auswahlfenster
   % eingestellt werden:
   
   %   set(uihd(11,14), 'value', gew_zr); eval(get(uihd(11,14), 'callback'));
   parameter.gui.merkmale_und_klassen.ind_em = gew_zr;
   inGUIIndx='CE_Auswahl_EM';
   inGUI;
   
   % Klassifikation,Entwurf
   callback_klassifikator_en;
   %Triggerevents retten
   kp.triggerevent = triggerevent_rett;
   
   
   % Originalwerte wiederherstellen, Klassifikator und Metrik kommen später
   if (kp.klassi_typ.typ == 2)
      parameter.gui.klassifikation.anz_hk = my_zr_save.parameter.gui.klassifikation.anz_hk;
      parameter.gui.klassifikation.merkmalsaggregation = my_zr_save.parameter.gui.klassifikation.merkmalsaggregation;
      inGUI;
   end;
   
   % Die Existenz von k3_single wird in callback_klassifikator_en abgefragt und der Entwurf verändert.
   % Der Datensatz wird nur einmal anhand der vorhandenen klass_single-Einstellungen erzeugt und
   % anschließend der Klassifikator entworfen.
   % WICHTIG: k3_single muss am Ende dieses Callbacks entfernt werden!
   k3_single = klass_single;
   % Dann einstellen, dass jeder Zeitpunkt behandelt wird:
   klass_zr.samples  = [1:kp.triggerevent.kmax];
   %jeder Trigger-Zeitpunkt ist eigener Klassifikator
   klass_zr.aktiv    = [1:kp.triggerevent.kmax]';
   %aber crisp!
   klass_zr.wichtung = ones(kp.triggerevent.kmax,1);
   % Weiter geht es ganz normal!
end;

%Einstellungen speichern (braucht man für Visualisierung und Anwendung)
klass_zr.kp = kp;

%eigentliche ZR-Klassifikator außer K5
if (kp.klassi_typ.typ ~= 5)
   zr_en_count = 1;
   
   
   for ind_sample_loop = klass_zr.samples
      %Index ausrechnen
      ind_sample = ind_sample_loop + te - 1;
      d_org = zeros(size(d_orgs,1),size(d_orgs,3));
      dorgbez = strcat('x',num2str([1:size(d_org,2)]'));
      %Merkmal aus ZR in EM schreiben
      d_org(ind_auswahl,:)=d_orgs(ind_auswahl,ind_sample,:);
      
      %Einmalig Gaitcad-Fenster aktualisieren
      %if first_sample_aktparawin == 1
      %aktparawin;
      %set(uihd(11,14), 'value', 1); eval(get(uihd(11,14), 'callback'));
      %first_sample_aktparawin = 0;
      %parameter.gui.merkmale_und_klassen.ind_em = 1;
      %end;
      % Wenn nur die ausgewählten Zeitreihen verwendet werden sollen, müssen diese im Auswahlfenster
      % eingestellt werden:
      %set(uihd(11,14), 'value', gew_zr); eval(get(uihd(11,14), 'callback'));
      parameter.gui.merkmale_und_klassen.ind_em = gew_zr;
      
      if (kp.klassi_typ.typ == 3 || kp.klassi_typ.typ == 2) % s.o.
         klass_single = k3_single;
      end;
      one_against_x_waitbar = 0;
      % Klassifikation,Entwurf
      callback_klassifikator_en;
      %Triggerevents retten
      kp.triggerevent = triggerevent_rett;
      
      
      %Klassifikatoren merken...
      klass_zr.i = klass_zr.i+1;
      klass_zr.klass_single{klass_zr.i} = klass_single;
      
      % Kurze Statusmeldung ausgeben
      fprintf(1, 'Classifier: %d of %d generated.\n', zr_en_count, length(klass_zr.samples));
      zr_en_count= zr_en_count + 1;
   end;
end;

%Einzelmerkmale und ihre Namen wiederherstellen
d_org=d_org_rett;
dorgbez=dorgbez_rett;
aktparawin;

% Falls über den Klassifikationsfehler zeitlich aggregiert werden soll, hier
% einmal den Klassifikator anwenden und dann die Filtergewichte speichern:
if (get(uihd(11,138), 'value') == 3 && kp.klassi_typ.typ ~= 2)
   % Bestimme die Gewichte für den Fehler:
   fprintf(1, 'Apply the classifier to training data to compute filter weights...');
   klassifizieren_zr_an;
   
   klass_zr.theta_fusion = fehl_proz;
   clear fehl_proz;
   fprintf(1, 'ready\n');
else
   clear klass_zr.theta_fusion;
end;


%aktparawin;
%set(uihd(11,14), 'value', 1); eval(get(uihd(11,14), 'callback'));

% Ist wichtig!!! Sonst kann es Probleme mit Einzelmerkmalsklassifikatoren geben!
% Dieses Strukt schaltet den Entwurf der Merkmalsauswahl ab. Nur wenn es nicht vorhanden ist,
% wird der vollständige Entwurf durchgeführt. Daher hier löschen!!!
clear k3_single;





