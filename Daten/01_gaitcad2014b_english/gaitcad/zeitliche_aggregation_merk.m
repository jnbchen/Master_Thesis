% Script zeitliche_aggregation_merk
%
% 
%  Speichere die alten Daten
%
% The script zeitliche_aggregation_merk is part of the MATLAB toolbox Gait-CAD. 
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

save_var.d_orgs = d_orgs;
% Existieren gespeicherte Werte?
if (exist('klass_zr', 'var') && isfield(klass_zr, 'zeitliche_aggregation_merk') && ~isempty(klass_zr.zeitliche_aggregation_merk))
   fprintf(1, 'Reducing the number of sample points using the saved options...\n');
   % Nicht aus der Oberfläche, sondern aus dem Speicher
   fensterlaenge = klass_zr.zeitliche_aggregation_merk.fenstergroesse;
   schrittweite  = klass_zr.zeitliche_aggregation_merk.fenster_schrittweite;
   verfahren     = klass_zr.zeitliche_aggregation_merk.aggregation_verfahren;
   abtastpunkte  = klass_zr.zeitliche_aggregation_merk.abtastpunkte;
else
   fprintf(1, 'Reducing the number of sample points using the parameters in the control elements...\n');
   % Parameter aus der Oberfläche abfragen:
	fensterlaenge = parameter.gui.zr_klassifikation.fenstergroesse;
   schrittweite  = parameter.gui.zr_klassifikation.fenster_schrittweite;
   verfahren	  = parameter.gui.zr_klassifikation.aggregation_verfahren;
	% Neue Abtastpunkte bestimmen: Wichtig: Nicht in die Zukunft schauen, sondern
	% höchstens in die Vergangenheit!
	% Und auch erst ab Triggerereignis beginnen!
	abtastpunkte = [kp.triggerevent.start+fensterlaenge-1:schrittweite:kp.triggerevent.start+kp.triggerevent.kmax-1];   
end; % if (exist('klass_zr', 'var') && isfield(klass_zr, 'zeitliche_aggregation_merk') && ~isemtpy(klass_zr.zeitliche_aggregation_merk))
   

% Lege Speicher für das neue d_orgs an
d_orgs = zeros(size(d_orgs,1), length(abtastpunkte), size(d_orgs,3));
% und berechne für jeden neuen Abtastpunkt die zusammengefassten Merkmale
for i = 1:length(abtastpunkte)
   % Hier werden die Verfahren unterschieden. Mittelwert ist wohl das übliche
   switch (verfahren)
   case 2 % Mittelwert
      d_orgs(:, i, :) = mean(save_var.d_orgs(:, abtastpunkte(i)-fensterlaenge+1:abtastpunkte(i), :), 2);
   case 3 % Minimum
      d_orgs(:, i, :) = min(save_var.d_orgs(:, abtastpunkte(i)-fensterlaenge+1:abtastpunkte(i), :), [], 2);
   case 4 % Maximum
      d_orgs(:, i, :) = max(save_var.d_orgs(:, abtastpunkte(i)-fensterlaenge+1:abtastpunkte(i), :), [], 2);
   case 5 % ROM
      d_orgs(:, i, :) = max(save_var.d_orgs(:, abtastpunkte(i)-fensterlaenge+1:abtastpunkte(i), :), [], 2) - min(save_var.d_orgs(:, abtastpunkte(i)-fensterlaenge+1:abtastpunkte(i), :), [], 2);
   end; % switch (parameter.gui.zr_klassifikation.aggregation_verfahren)
end; % for(i = 1:length(abtastpunkte))
% Sicherheitshalber aktparawin aufrufen. Die Länge der Zeitreihen ist in irgendwelchen
% Parametervariablen vermerkt.
aktparawin;

% Parameter für Triggerzeitreihe verstellen. Kommt sonst Müll raus!
save_var.triggerzr = parameter.gui.zr_klassifikation.triggerzr;
parameter.gui.zr_klassifikation.triggerzr = 1;
inGUIIndx = 'CE_ZRKlassi_Trigger'; inGUI;
% Erneut die Parameter für die Klassifikation auslesen:
mode_berechne_triggerzr = 1;
erzeuge_parameterstrukt;