% Script klassifizieren_zr_an
%
% Einzelmerkmale und ihre Namen retten
%
% The script klassifizieren_zr_an is part of the MATLAB toolbox Gait-CAD. 
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

md_all  = zeros(size(d_orgs,1),size(d_orgs,2),kp.anz_class);
prz_all = zeros(size(d_orgs,1),size(d_orgs,2),kp.anz_class);
pos_all = zeros(size(d_orgs,1),size(d_orgs,2));
svm_md_all = [];

%Sonderbehandlung K2
if (kp.klassi_typ.typ == 2)
   parameter.gui.klassifikation.klassifikator = 1;
   parameter.gui.klassifikation.bayes.metrik = 1;
   parameter.gui.klassifikation.mehrklassen = 1;
   inGUI;
end;

clear zr_an_skript;
%durch alle Samples
%dient nur Anzeigezwecken
laengeDurch10 = round(size(d_orgs,2) / 10);
for ind_sample = 1:size(d_orgs,2)
   % Zu welchem Zeitpunkt nach einem Trigger sind wir?
   xtt = kp.triggerevent.zr(ind_sample);
   if (xtt) > 0
      %Merkmale zusammenstellen
      % Der K5 braucht die Triggerzeit als zusätzliche Eingabe:
      if (kp.klassi_typ.typ == 5)
         ind_zr = [1:size(d_orgs,3)];
         % Triggerzeitreihe wieder ausschließen.
         ind_zr(ind_zr == kp.triggerzr) = [];
         d_org=zeros(size(d_orgs,1), length(ind_zr)+1);
         d_org(ind_auswahl,:)=[squeeze(d_orgs(ind_auswahl,ind_sample,ind_zr)) myResizeMat(xtt, length(ind_auswahl), 1)];
      else %K1-K4
         d_org=zeros(size(d_orgs,1),size(d_orgs,3));
         d_org(ind_auswahl,:)=d_orgs(ind_auswahl,ind_sample,:);
      end;
      
      %Einmalig Gaitcad-Fenster aktualisieren
      %if ind_sample==1
      %   set(uihd(11,14), 'value', 1); eval(get(uihd(11,14), 'callback'));
      %   aktparawin;
      %end;
      
      %Triggerevents retten
      triggerevent_rett = kp.triggerevent;
      
      %Aktive Klassifikatoren ermitteln
      for zr_an_skript_i = 1:length(klass_zr.aktiv(xtt,:))
         ind_klass = klass_zr.aktiv(xtt,zr_an_skript_i);
         if (ind_klass > 0)
            %Aktiven Klassifikator einschalten
            klass_single=klass_zr.klass_single{ind_klass};
            
            one_against_x_waitbar = 0;
            
            
            % Klassifikation,Anwendung
            callback_klassifikator_an;
            kp.triggerevent = triggerevent_rett;
            
            % svm_md_all kann sehr groß werden. Bei speicherschonender Option nicht speichern.
            if (~parameter.gui.merkmale_und_klassen.speicherschonend_einfuegen && exist('svm_md', 'var') && ~isempty(svm_md))
               svm_md_all(ind_sample).svm_md = svm_md;
            end;
            
            %Ergebnisse archivieren - mit Fuzzy Wichtung für Inferenz und Defuzzifizierung
            % Hier eine Besonderheit: die SVM-Klassifikatoren haben keine vernünftige md-Ausgabe.
            % Daher wird hier direkt pos vereinigt:
            
            if isempty(pos)
               %set to zero and class 1 if nothing is nown
               pos = zeros(size(pos_all,1),1);
               prz = zeros(size(pos_all,1),1);
               md = zeros(size(pos_all,1),1);
               klass_single(1).klasse.angelernt = 1;
            end;
            
            if (strcmp(kp.klassifikator, 'svm'))
               pos_all(ind_auswahl, ind_sample)  = pos_all(ind_auswahl, ind_sample) + round(klass_zr.wichtung(xtt, zr_an_skript_i) * pos(ind_auswahl));
               prz_all(ind_auswahl,ind_sample,klass_single(1).klasse.angelernt) = squeeze(prz_all(ind_auswahl,ind_sample,klass_single(1).klasse.angelernt)) + klass_zr.wichtung(xtt, zr_an_skript_i)*prz(ind_auswahl,klass_single(1).klasse.angelernt);
            else
               % In klass_single.klasse.angelernt stehen die Klassen für die angelernt wurde
               pos_all(ind_auswahl, ind_sample)  = pos_all(ind_auswahl, ind_sample) + round(klass_zr.wichtung(xtt, zr_an_skript_i) * pos(ind_auswahl));
               % Wenn ind_auswahl nur ein Element enthält, wird die Dimension falsch.
               tmp_val = squeeze(prz_all(ind_auswahl,ind_sample,klass_single(1).klasse.angelernt));
               if (size(tmp_val,1) ~= length(ind_auswahl))
                  tmp_val = tmp_val';
               end;
               prz_all(ind_auswahl,ind_sample,klass_single(1).klasse.angelernt) = tmp_val + klass_zr.wichtung(xtt, zr_an_skript_i)*prz(ind_auswahl,klass_single(1).klasse.angelernt);
               tmp_val = squeeze(md_all (ind_auswahl,ind_sample,klass_single(1).klasse.angelernt));
               if (size(tmp_val,1) ~= length(ind_auswahl))
                  tmp_val = tmp_val';
               end;
               md_all (ind_auswahl,ind_sample,klass_single(1).klasse.angelernt) = tmp_val + klass_zr.wichtung(xtt, zr_an_skript_i)*md (ind_auswahl,klass_single(1).klasse.angelernt);
            end;
         end;
      end;
      if (mod(ind_sample,laengeDurch10) == 0)
         fprintf(1, 'Sample point: %d of %d ready\n', ind_sample, size(d_orgs,2));
      end;
   end;
end;

% scharfe Klassen berechnen
% Aber nicht, wenn SVM oder k-nearest neighbor als Klassifikator verwendet wurden.
% Zwar funktioniert es beim k-NN theoretisch auch, aber die Ausreißerdetektion einzelner Abtastpunkte funktioniert dann nicht mehr.
if (strcmp(kp.klassifikator, 'svm') == 0 && strcmp(kp.klassifikator, 'knn') == 0)
   [tmp,pos_all]=max(prz_all,[],3);
end;

%Einzelmerkmale und ihre Namen wiederherstellen
d_org=d_org_rett;
dorgbez=dorgbez_rett;
%aktparawin;
%set(uihd(11,14), 'value', 1);
%eval(get(uihd(11,14), 'callback'));

% Alte Klassifikationsparameter wiederherstellen
%if (kp.klassi_typ.typ == 2)
%   set(uihd(11,98), 'value', temp_klassi);
%   eval(get(uihd(11,98), 'callback'));
%   set(uihd(11,100), 'value', temp_metrik);
%   set(uihd(11,102), 'value', temp_mehrklassenprobleme);
%end;

klass_single = [];
pos = [];
prz = [];
% Fehler berechnen:
code_all=code*ones(1,size(d_orgs,2));
temp=mean(pos_all(ind_auswahl,:)==code_all(ind_auswahl,:));
fehl_proz = 100*(1-temp);

clear triggerevent_rett;