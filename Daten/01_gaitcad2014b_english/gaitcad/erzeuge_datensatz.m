% Script erzeuge_datensatz
%
% erzeuge_datensatz
% alles wird neu...
%
% The script erzeuge_datensatz is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('one_against_x_indx', 'var') || isempty(one_against_x_indx))
   one_against_x_indx = 1;
end;

klass_single(one_against_x_indx).merkmalsextraktion=[];
merk_red = parameter.gui.klassifikation.merk_red;

%Merkmalsauswahl
mode_bewertung = parameter.gui.klassifikation.merkmalsauswahl;
switch mode_bewertung
case 1	%alle Merkmale
   merkmal_auswahl = [1:size(d_org,2)];
   phi_text = 'without feature selection';
case 2	%ausgewählte Merkmale
   callback_gewaehlte_merk;
case {3,4,5,6,7,8}
   
   %plaudrige Anzeige ausschalten
   anzeige_details=0;
   
   %save parameter for feature selection (all or selected) in computation
   %of relevances
   save_relevances_for_selected_features = parameter.gui.anzeige.relevances_for_selected_features;
   
   %ignore preselection option for feature selection lists
   parameter.gui.anzeige.relevances_for_selected_features = 0;
      
   callback_feature_selection;
   
   %restore parameter for feature selection (all or selected) in computation
   %of relevances
   parameter.gui.anzeige.relevances_for_selected_features = save_relevances_for_selected_features;
   
   %fürs Plotten der Klassifikation mit Titel
   phi_text = sprintf('Feature reduction from %d to %d features',size(d_org,2),length(merkmal_auswahl));	
end;


%alle Informationen für die spätere Anwendung merken
klass_single(one_against_x_indx).merkmalsextraktion.merkmal_auswahl=merkmal_auswahl;
klass_single(one_against_x_indx).merkmalsextraktion.var_bez = deblank(dorgbez(merkmal_auswahl,:));
%Anwenden...
d=erzeuge_datensatz_an(d_org,klass_single(one_against_x_indx).merkmalsextraktion);

%Normierung der ausgewaehlten Daten
normierung = parameter.gui.klassifikation.normierung_merkmale;

%Anpassung von normierung fuer Funktion matrix_normieren
switch normierung
case 1 
   %keine Normierung
   klass_single(one_against_x_indx).merkmalsextraktion.norm_merkmale.type=0;
case 2
   %[0 - 1 Normierung]
   klass_single(one_against_x_indx).merkmalsextraktion.norm_merkmale.type=2;
case 3
   %MW0 - STD 1
   klass_single(one_against_x_indx).merkmalsextraktion.norm_merkmale.type=1;
case 4
   %MW0 - STD unchanged
   klass_single(one_against_x_indx).merkmalsextraktion.norm_merkmale.type=5;
end
%Normierung berechnen
[temp,klass_single(one_against_x_indx).merkmalsextraktion.norm_merkmale.par1,klass_single(one_against_x_indx).merkmalsextraktion.norm_merkmale.par2]=matrix_normieren(d(ind_auswahl,:),klass_single(one_against_x_indx).merkmalsextraktion.norm_merkmale.type);
%Anwenden macht dann später callback_aggregation

%Merkmalsaggregation (enthält Anwendung!)
aggregation_mode = parameter.gui.klassifikation.merkmalsaggregation - 1;	%Anpassung von aggregation_mode fuer Skript callback_aggregation
callback_aggregation;

%Normierung	der aggregierten Daten
normierung = parameter.gui.klassifikation.normierung_aggregierte_merkmale;
%Anpassung von normierung fuer Funktion matrix_normieren
switch normierung
case 1 
   %keine Normierung
   klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.type=0;
case 2
   %[0 - 1 Normierung]
   klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.type=2;
case 3
   %MW0 - STD 1
   klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.type=1;
case 4
   %MW0 - STD unchanged
   klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.type=5;
end
%Normierung berechnen
[temp,klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.par1,klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.par2]=matrix_normieren(d(ind_auswahl,:),klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.type);
%Anwenden...
d=erzeuge_datensatz_an(d_org,klass_single(one_against_x_indx).merkmalsextraktion);

%aggregation_mode wird in callback_aggregation gekillt 
clear mode merkmal_mode normierung one_against_x_indx;
