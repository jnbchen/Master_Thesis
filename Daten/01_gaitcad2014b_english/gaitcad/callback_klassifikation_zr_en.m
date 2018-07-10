% Script callback_klassifikation_zr_en
%
% The script callback_klassifikation_zr_en is part of the MATLAB toolbox Gait-CAD. 
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

anz_klassen_auswahl=length(unique(code(ind_auswahl)));
if anz_klassen_auswahl<2
   warnstring=sprintf('The selected data points have only %d output classes.\n',anz_klassen_auswahl);
   warnstring=strcat(warnstring,'Consequently, a classifier design is not possible.');
   warnstring=strcat(warnstring,' Please verify the selection of data points and the selected output variable.');
   mywarning(warnstring);
   clear anz_klassen_auswahl warnstring;
   return;  
end;
clear anz_klassen_auswahl kp klass_zr;



%alle Parameter retten 
my_zr_save.parameter.gui = parameter.gui;

mode_berechne_triggerzr = 1;
erzeuge_parameterstrukt;

% Sollen die Merkmale zeitlich aggregiert werden?
if (parameter.gui.zr_klassifikation.aggregation_verfahren > 1)
   % Sicherstellen, dass die Parameter für die zeitliche Aggregation der Merkmale
   % auch neu eingelesen werden:
   klass_zr.zeitliche_aggregation_merk = [];
   % Wurde in eigenes Skript ausgelagert, da auch im Anwende-Skript das Gleiche durchgeführt werden muss
   zeitliche_aggregation_merk;
   
   % Es muss vermieden werden, dass die Bewertung aller Abtastpunkte noch vorliegt.
   % Also zr_rel löschen
   clear zr_rel;
end; % if (parameter.gui.zr_klassifikation.aggregation_verfahren > 1)

global global_plot_off;
global_plot_off = 1;

% Erstelle die Klassifikatoren
parameter.allgemein.no_aktparawin = 1;
klassifizieren_zr_en;
parameter.allgemein.no_aktparawin = 0;
aktparawin;

% Nun die alten Variablen wieder herstellen
if (parameter.gui.zr_klassifikation.aggregation_verfahren > 1)
   d_orgs = save_var.d_orgs; 
   set(uihd(11,134), 'value', save_var.triggerzr); 
   eval(get(uihd(11,134), 'Callback'));
   clear save_var;
   
   aktparawin;
   % Werte merken
   klass_zr.zeitliche_aggregation_merk.fenstergroesse = parameter.gui.zr_klassifikation.fenstergroesse;
	klass_zr.zeitliche_aggregation_merk.fenster_schrittweite  = parameter.gui.zr_klassifikation.fenster_schrittweite;
   klass_zr.zeitliche_aggregation_merk.aggregation_verfahren = parameter.gui.zr_klassifikation.aggregation_verfahren;
   klass_zr.zeitliche_aggregation_merk.abtastpunkte = abtastpunkte;
else % if (parameter.gui.zr_klassifikation.aggregation_verfahren > 1)
   klass_zr.zeitliche_aggregation_merk = [];
end;

global_plot_off = 0;

%alle Parameter retten 
parameter.gui = my_zr_save.parameter.gui;
inGUI;