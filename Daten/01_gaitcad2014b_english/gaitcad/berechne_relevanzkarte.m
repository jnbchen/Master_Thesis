% Script berechne_relevanzkarte
%
% Berechnet Merkmalsrelevanzen für ausgewählte Zeitreihen.
% rk.zr_rel_mode = 1: ANOVA
% rk.zr_rel_mode = 2: Klassifikationsgüten
% rk.zr_rel_mode = 3: MANOVA mit vorausgewählten Merkmalen.
% Welche Zeitreihen sind ausgewählt?
% zrs = get(uihd(11,13), 'value');
% Auswahl wird erst einmal gestrichen. Sieht beim Plotten mit surf
% einfach doof aus. Vielleicht später mal...
%
% The script berechne_relevanzkarte is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

rk.zrs = [1:size(d_orgs,3)];
if (~isfield(rk, 'plot_only'))
   rk.plot_only = 0;
end;

if (~rk.plot_only)
   rk.minmax = [];
   switch rk.zr_rel_mode
      case 1
         parameter.gui.merkmale_und_klassen.ind_zr = rk.zrs;
         % Verwendet ein gekapseltes Skript, welches nur dann neu berechnet, wenn sich die Auswahl
         % verändert hat. Daher müssen wir ihn hier ein wenig zwingen...
         clear zr_rel;
         zr_rel_mode = 1;
         berechne_zr_rel;
         
         % berechne_zr_rel speichert seine Ergebnisse in zr_rel. Die werden kopiert.
         rk.zr_rel = zr_rel.anova.alleMerk';
         
         rk.minmax(1) = min(rk.zr_rel(:));
         rk.minmax(2) = max(rk.zr_rel(:));
         rk.minmax_str = 'Absolute minimal and maximal values:';
         rk.verf_str = 'ANOVA';
      case 2
         % Neuen Speichern anlegen
         rk.zr_rel = zeros(length(rk.zrs), size(d_orgs,2));
         %rk.multivariat_wrapper = 1;
         if (rk.multivariat_wrapper)
            rk.preselection = parameter.gui.merkmale_und_klassen.ind_zr;
            if (size(rk.preselection, 1) > 1)
               rk.preselection = rk.preselection';
            end;
         else
            rk.preselection = [];
         end;
         % Nur ausgewählte Merkmale für die Klassifikation verwenden.
         mauswahl = parameter.gui.klassifikation.merkmalsauswahl;
         parameter.gui.klassifikation.merkmalsauswahl = 2;
         inGUIIndx = 'CE_Klassifikation_Merkmalsauswahl'; inGUI;
         ber_rel_kar_merk_red_save = parameter.gui.klassifikation.merk_red;
         if (rk.multivariat_wrapper)
            % Zunächst die Anzahl auf die vorausgewählten Merkmale setzen
            parameter.gui.klassifikation.merk_red = length(rk.preselection);
            inGUIIndx = 'CE_Anzahl_Merkmale'; inGUI;
            % Dann die vorausgewählten Merkmale eintragen:
            parameter.gui.merkmale_und_klassen.ind_zr = rk.preselection;
            % Und den Klassifikator ausführen
            if (~isfield(rk, 'code_entwurf') || isempty(rk.code_entwurf) || ~isfield(rk, 'code_anwendung') || isempty(rk.code_anwendung))
               callback_klassifikation_zr_en;
               callback_klassifikation_zr_an;
            else
               fprintf(1, 'Select features for design\n');
               ind_auswahl = find(code_alle(:, rk.code_entwurf(1)) == rk.code_entwurf(2));
               callback_klassifikation_zr_en;
               fprintf(1, 'Select features for application\n');
               ind_auswahl = find(code_alle(:, rk.code_anwendung(1)) == rk.code_anwendung(2));
               callback_klassifikation_zr_an;
            end;
            % Das Ergebnis in einer temporären Variablen speichern
            zuf_entscheidung = 1 - 1/length(klass_single(1).klasse.angelernt);
            tmp_zr_rel = 1 - ( (fehl_proz ./ 100) ./ zuf_entscheidung );
            
            % Jetzt die Anzahl auszuwählender Merkmale auf eins mehr als vorausgewählt sind setzen.
            parameter.gui.klassifikation.merk_red = length(rk.preselection) + 1;
            inGUIIndx = 'CE_Anzahl_Merkmale'; inGUI;
         else
            % Anzahl auszuwählender Merkmale auf 1 setzen
            parameter.gui.klassifikation.merk_red = 1;
            inGUIIndx = 'CE_Anzahl_Merkmale'; inGUI;
         end;
         
         for br_zr = rk.zrs
            % Nur berechnen, wenn diese Merkmale nicht vorausgewählt sind
            % (oder keine multivariate Güte berechnet werden soll)
            if (~(rk.multivariat_wrapper && ismember(br_zr, rk.preselection)))
               % Zeitreihe auswählen
               if (rk.multivariat_wrapper)
                  parameter.gui.merkmale_und_klassen.ind_zr = [rk.preselection br_zr];
               else
                  parameter.gui.merkmale_und_klassen.ind_zr = br_zr;
               end;
               % Klassifikation, Entwurf und Anwendung
               plot_mode = 0;
               % Sollen für den Entwurf und die Anwendung verschiedene Auswahlen verwendet werden?
               if (~isfield(rk, 'code_entwurf') || isempty(rk.code_entwurf) || ~isfield(rk, 'code_anwendung') || isempty(rk.code_anwendung))
                  callback_klassifikation_zr_en;
                  callback_klassifikation_zr_an;
               else
                  fprintf(1, 'Select features for design\n');
                  ind_auswahl = find(code_alle(:, rk.code_entwurf(1)) == rk.code_entwurf(2));
                  callback_klassifikation_zr_en;
                  fprintf(1, 'Select features for application\n');
                  ind_auswahl = find(code_alle(:, rk.code_anwendung(1)) == rk.code_anwendung(2));
                  callback_klassifikation_zr_an;
               end;
               % Werte sollen zwischen 0 und 1 liegen
               % Es muss zusätzlich berücksichtigt werden, dass ein Fehler von z.B. 50% bei
               % einem 2-Klassen-Problem einer Relevanz von 0 entspricht!
               zuf_entscheidung = 1 - 1/length(klass_single(1).klasse.angelernt);
               rk.zr_rel(br_zr, :) = 1 - ( (fehl_proz ./ 100) ./ zuf_entscheidung );
               indx = find(rk.zr_rel(br_zr, :) < 0);
               rk.zr_rel(br_zr, indx) = 0;
            end;
         end; % for(br_zr = rk.zrs)
         
         if (rk.multivariat_wrapper)
            tmp_zr_rel = myResizeMat(tmp_zr_rel, size(rk.zr_rel, 1), 1);
            rk.zr_rel = (rk.zr_rel - tmp_zr_rel) ./ (1 - tmp_zr_rel);
            rk.zr_rel(rk.zr_rel < 0) = 0;
            % Setze die Verbesserung der vorausgewählten Merkmale auf 0
            rk.zr_rel(rk.preselection, :) = 0;
         end;
         parameter.gui.klassifikation.merk_red = ber_rel_kar_merk_red_save;
         inGUIIndx = 'CE_Anzahl_Merkmale'; inGUI;
         parameter.gui.klassifikation.merkmalsauswahl = mauswahl;
         inGUIIndx = 'CE_Klassifikation_Merkmalsauswahl'; inGUI;
         clear ber_rel_kar_merk_red_save mauswahl;
         rk.verf_str = 'Classification accuracy';
         if (rk.multivariat_wrapper)
            rk.verf_str = sprintf('%s, Preselection %s', rk.verf_str, num2str(rk.preselection));
         end;
         
         rk.minmax(1) = min(rk.zr_rel(:));
         rk.minmax(2) = max(rk.zr_rel(:));
         rk.minmax_str = 'Absolute minimal and maximal values:';
         
         clear tmp_zr_rel;
      case 3
         % Speichere die vorausgewählten Zeitreihen
         % Es ist wichtig, sie in rk.preselection zu speichern. Auf diese Variable wird in
         % callback_anzeige_zrmanova abgefragt!
         rk.preselection = parameter.gui.merkmale_und_klassen.ind_zr;
         % Setze Auswahl nun auf alle Merkmale
         parameter.gui.merkmale_und_klassen.ind_zr = rk.zrs;
         clear zr_rel;
         zr_rel_mode = 2;
         % Speichere die bisher eingestellte Anzahl auszuwählender Merkmale
         ber_rel_kar_merk_red_save = parameter.gui.klassifikation.merk_red;
         % Setze die Anzahl auszuwählender Merkmale zunächst auf die Anzahl vorausgewählter Merkmale
         parameter.gui.klassifikation.merk_red = length(rk.preselection);
         inGUIIndx = 'CE_Anzahl_Merkmale'; inGUI;
         berechne_zr_rel;
         tmp_zr_rel = zr_rel.manova.alleMerk(:, rk.preselection)';
         tmp_zr_rel = tmp_zr_rel(end, :);
         % Setze nun die Anzahl auszuwählender Merkmale auf eins mehr als die Anzahl vorausgewählter Merkmale
         parameter.gui.klassifikation.merk_red = length(rk.preselection)+1;
         inGUIIndx = 'CE_Anzahl_Merkmale'; inGUI;
         % Und berechne erneut die Relevanzen über der Zeit:
         clear zr_rel; zr_rel_mode = 2;
         berechne_zr_rel;
         neu_zr_rel = zr_rel.manova.alleMerk';
         % Bei den vorausgewählten Merkmalen wird zu der eigentlichen Relevanz noch ein Integer addiert,
         % um eine Sortierung zu erreichen. Dies muss hier korrigiert werden:
         
         %u.U. Numerik-Probleme
         neu_zr_rel = rem(abs(neu_zr_rel), 1);
         rk.minmax(1) = min(neu_zr_rel(:));
         rk.minmax(2) = max(neu_zr_rel(:));
         rk.minmax_str = 'Absolute minimal and maximal values:';
         % Nun berechne die relative Verbesserung auf dem Weg zum absoluten relevanten Merkmal:
         tmp_zr_rel = myResizeMat(tmp_zr_rel, size(neu_zr_rel, 1), 1);
         rk.zr_rel = (neu_zr_rel - tmp_zr_rel) ./ (1 - tmp_zr_rel);
         % Setze die Verbesserung der vorausgewählten Merkmale auf 0
         rk.zr_rel(rk.preselection, :) = 0;
         
         clear tmp_zr_rel neu_zr_rel;
         
         % Setze nun die Anzahl auszuwählender Merkmale wieder auf den gespeicherten Wert
         parameter.gui.klassifikation.merk_red = ber_rel_kar_merk_red_save;
         inGUIIndx = 'CE_Anzahl_Merkmale'; inGUI; clear ber_rel_kar_merk_red_save;
         rk.verf_str = sprintf('Relative improvement for MANOVA, preselection: %s', num2str(rk.preselection));
   end; % switch(rk.zr_rel_mode)
end; % if (~rk.plot_only)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeige sie an
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Für die Anzeige soll die Funktion berechneSpektogramm verwendet
% werden, die auch eine "Nur-Anzeigen" Option besitzt.
% Dafür müssen die Daten in ein cell-Array kopiert werden und evtl. die Achsen
% umbenannt werden. Das Format des cell-Array ist:
% plot_spect: #Datentupel x #Zeitreihen x 3 (Betrag des Spektogramms, Frequenzen, Zeit)
% Übersetzt auf diese Anwendung:
% plot_spect: 1 x 1 x 3 (Relevanz der Zeitreihen, Nummer der Zeitreihe, Zeit)
% Abtastfrequenz
param.fA 						= parameter.gui.zeitreihen.abtastfrequenz;
% Welche Colormap?
param.colormap					= parameter.gui.zeitreihen.colormap;
% Soll die Kennlinie angezeigt werden?
param.kennlinie_anzeigen 	= 0;
param.kennlinie_art 			= 1;
param.kennlinie_name 		= '';
param.colorbar_anzeigen		= parameter.gui.zeitreihen.plot_colorbar;
% Automatische Farbachsenskalierung?
if (parameter.gui.zeitreihen.caxis)
   param.caxis = [0 1];
else
   param.caxis = parameter.gui.zeitreihen.caxis_vec;
end;
% Zeitachse bestimmen:
switch(parameter.gui.zeitreihen.anzeige)
   case 'Percental'
      zv = [0:size(rk.zr_rel,2)-1]*100./(size(rk.zr_rel,2)-1);
      param.x_beschrift = 'Percental visualization';
   case 'Sample points'
      zv = [1:size(rk.zr_rel,2)];
      param.x_beschrift = 'Sample points';
   case 'Time'
      zv = [1:size(rk.zr_rel,2)]./param.fA;
      param.x_beschrift = ['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
   otherwise
      zv = [1:size(rk.zr_rel,2)];
      param.x_beschrift = 'Sample points';
end;
param.y_beschrift='No. time series';

% Reduziere die Anzahl an Abtastpunkten, um die Grafiken etwas kleiner
% zu bekommen:
red_sample = parameter.gui.zeitreihen.red_sample;
plot_spect = cell(1, 1, 3);
plot_spect{1,1,1} = rk.zr_rel(:, 1:red_sample:end); % Relevanz der Zeitreihen
plot_spect{1,1,2} = [rk.zrs];  % Nr der Zeitreihe
plot_spect{1,1,3} = zv(1:red_sample:end); % Zeit
berechneSpektogramm([], param, -1, [], [], 0, plot_spect);
title(sprintf('Maps of feature relevances - %s (abs. Min/Max: %0.3f, %0.3f)', rk.verf_str, rk.minmax(1), rk.minmax(2)));
set(gcf, 'Name', sprintf('%d: map of feature relevances', get_figure_number(gcf)));
enmat = enable_menus(parameter, 'enable', 'MI_MKarten_Plot');
% DIESES LÖSCHEN IST SEHR WICHTIG!!!
rk.preselection = [];

