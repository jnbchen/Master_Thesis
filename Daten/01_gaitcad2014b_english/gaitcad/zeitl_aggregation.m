% Script zeitl_aggregation
%
% The script zeitl_aggregation is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

fprintf(1, 'Time aggregation of classification results...\n');
clear filtererg;
%x_TE - darf im Moment nur einmal vorkommen!!!!
te = kp.triggerevent.start;
te_end = kp.triggerevent.start + kp.triggerevent.kmax - 1;
if (te_end > size(d_orgs,2))
   te_end = size(d_orgs,2);
end;

%Beim K2 muss noch aggregiert werden. Und zwar die umgerechneten Abstände.
%bei allen anderen ist nichts zu tun...
if (kp.klassi_typ.typ == 2)
   %Reengineering Abstände
   abst_k2 = -2 * (log(md_all) - log(0.5));
   abst = zeros(size(pos_all, 1), length([1:size(d_orgs,2)]), 2);
   for(i = te:size(abst_k2, 2))
      for(kl = 1:size(abst_k2, 3))
         tmp_abst = squeeze(abst_k2(:, te:i, kl));
         tmp_abst = sum(tmp_abst, 2);
         abst(:, i, kl) = tmp_abst;
      end;
   end;
   %Klassenschätzung eintragen - eigentlich interessiert aber nur der letzte Wert, 
   %alles andere sind nur Zwischenergebnisse
   md_fil = abst;
   [temp, pos_all] = min(abst, [], 3);
end;

% Soll gefiltert werden?
filter_typ = get(uihd(11,138), 'value');
if (filter_typ > 1 && kp.klassi_typ.typ ~= 2)
   % Was soll gefiltert werden?
   if (filter_typ ~= 4)
      % Hier wird ein kleiner "Trick" angewendet. md_all und pos_all werden nur dann kopiert, wenn sie in der
	   % Funktion verändert werden. Ansonsten werden quasi "Zeiger" übergeben. Werden die Variablen hier im Skript
   	% umherkopiert, werden sie real kopiert, was zu Speicherproblemen führen kann...
	   if (get(uihd(11,139), 'value') == 2)
         [filtererg] = filtere_klassif_ergebnis(md_all, get(uihd(11,138), 'value'), parameter, te, te_end, klass_zr);
      else % if (get(uihd(11,139), 'value') == 2)
         % Bei einer SVM (aber nur bei 2-Klassen-Problem) muss ein weiterer Vorverarbeitungsschritt
         % durchgeführt werden. Dazu wird die gleiche Formel wie in Dortmund (Heuristik) angewendet:
         if (strcmp(kp.klassifikator, 'svm') && length(unique(code(ind_auswahl))) == 2)
            heuristik_param = 3;
            prz_all_neu = zeros(size(prz_all));
            for(sp = te:te_end)
               % Da in prz in allen Spalten das gleiche steht, nehmen wir nur die erste.
               indx = find(prz_all(ind_auswahl, sp, 1) <= 0);
               prz_all_neu(ind_auswahl(indx), sp, 2) = 0.5 + 0.5 * exp(heuristik_param * 1./prz_all(ind_auswahl(indx), sp, 1));
               prz_all_neu(ind_auswahl(indx), sp, 1) = 1 - prz_all_neu(ind_auswahl(indx), sp, 2);
               
               indx = find(prz_all(ind_auswahl, sp, 1) > 0);
               prz_all_neu(ind_auswahl(indx), sp, 1) = 0.5 + 0.5 * exp(-heuristik_param * 1./prz_all(ind_auswahl(indx), sp, 1));
               prz_all_neu(ind_auswahl(indx), sp, 2) = 1 - prz_all_neu(ind_auswahl(indx), sp, 1);
            end; % for(sp = te:te_end)
            %filtersig = prz_all_neu;
            [filtererg] = filtere_klassif_ergebnis(prz_all_neu, get(uihd(11,138), 'value'), parameter, te, te_end, klass_zr);
         else % if (strcmp(kp.klassifikator, 'svm') && length(unique(code(ind_auswahl))) == 2)
            [filtererg] = filtere_klassif_ergebnis(prz_all, get(uihd(11,138), 'value'), parameter, te, te_end, klass_zr);
         end;
      end; % if (get(uihd(11,139), 'value') == 2)
      if (isempty(filtererg))
         warning('Error by computing. Cancel.');
         return;
      end;
      % pos neu berechnen:
      %Unterscheidung Abstand gegen Klassenzugehörigkeiten nötig, um Ergebnisse zu berechnen
      switch (get(uihd(11,139), 'value'))
      case 1 % prz wurde überarbeitet
         %prz_fil = filtererg;
         [dummy, pos_all] = max(filtererg, [], 3);         
      case 2 % md wurde überarbeitet
         %md_fil = filtererg;
         % Ob min oder max gesucht ist, hängt vom Klassifikator ab.
         if (strcmp(kp.klassifikator, 'bayes') || strcmp(kp.klassifikator, 'knn'))
            [dummy, pos_all] = max(filtererg, [], 3);
         else %alle anderen Klassifikatoren (?) 
            [dummy, pos_all] = min(filtererg, [], 3);
         end;
      end; % switch (get(uihd(11,139), 'value'))
   else % if (filter_typ ~= 4)
      % Hier wird in pos_all nach der häufigsten Entscheidung innerhalb eines Fensters gesucht
      % Die Fenstergröße wird durch parameter.gui.zr_klassifikation.fenstergroesse angegeben.
      % Am Anfang werden immer so viele Abtastpunkte verwendet, wie vorhanden sind
      % Verwende die originale Entscheidung, nicht eine eventuell bereits gefilterte.
      tmp = pos_all_orig;
      for(i = 2:size(pos_all,2))
         if (i < parameter.gui.zr_klassifikation.fenstergroesse)
            pos_all(:, i) = max(tmp(:, 1:i), [], 2);
         else
            pos_all(:, i) = max(tmp(:, i-parameter.gui.zr_klassifikation.fenstergroesse+1:i), [], 2);
         end;
      end;
      % md_fil und prz_fil dürfen nicht existieren!
      clear md_fil prz_fil;
   end; % if (filter_typ ~= 4)
else % if (get(uihd(11,138), 'value') > 1 && kp.klassi_typ.typ ~= 2)
   % Der K2 wird anders gefiltert. Bei dem also das Ergebnis nicht löschen!
   if (kp.klassi_typ.typ ~= 2)
      clear md_fil prz_fil;
   end;
end; % if (filter_typ > 1 && kp.klassi_typ.typ ~= 2)

% Unbedingt Speicher freigeben! filtererg und filtersig können ganz schön groß werden!
clear filtersig; % filtererg;
