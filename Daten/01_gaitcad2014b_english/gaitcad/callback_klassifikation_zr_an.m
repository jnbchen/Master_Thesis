% Script callback_klassifikation_zr_an
%
% The script callback_klassifikation_zr_an is part of the MATLAB toolbox Gait-CAD. 
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

my_zr_save.parameter.gui = parameter.gui;


mode_berechne_triggerzr = 1;
erzeuge_parameterstrukt;

%GANZ, GANZ wichtig: bei der Anwendung beziehen wir uns auf denm entworfenen Klassifkiator!!!!!!!
kp.triggerevent = klass_zr.kp.triggerevent;
kp.triggerzr    = klass_zr.kp.triggerzr;
kp.klassi_typ   = klass_zr.kp.klassi_typ;


% Sollen die Merkmale zeitlich aggregiert werden?
if (parameter.gui.zr_klassifikation.aggregation_verfahren > 1)
   % Hier werden die Variablen aber nicht gespeichert, sondern nur noch verwendet!
   zeitliche_aggregation_merk;
else
   % Wenn nicht aggregiert werden soll, das Strukt zur Aggregation aber existiert, liegt
   % ein falsch angelernter Klassifikator vor. Breche mit Fehlermeldung ab!
   if (isfield(klass_zr, 'zeitliche_aggregation_merk') && ~isempty(klass_zr.zeitliche_aggregation_merk))
      myerror('The time series classifier was designed on an aggregated feature set! Please activate aggregation or start a redesign.');
   end; % if (isfield(klass_zr, 'zeitliche_aggregation_merk') && ~isempty(klass_zr.zeitliche_aggregation_merk))
end; % if (parameter.gui.zr_klassifikation.aggregation_verfahren > 1)


%Klassifikator anwenden (gemäß Auswahl in kp.klassifikator)
clear pos_all_orig pos_all md_all prz_all;  

global global_plot_off;
global_plot_off = 1;

% Altes pos, prz und klass_single merken und hinterher wieder herstellen:
ckzr.pos = pos;
ckzr.prz = prz;
ckzr.klass_single = klass_single;

%Klassifikatoren anwenden
parameter.allgemein.no_aktparawin = 1;
klassifizieren_zr_an;
parameter.allgemein.no_aktparawin = 0;
aktparawin;

% Originale Ergebnisse zwischenspeichern.
pos_all_orig = pos_all;

%zeitliche Aggregation
zeitl_aggregation;

global_plot_off = 0;

% Fehler berechnen:
% Wird auch schon mal in klassifizieren_zr_an gemacht. Hat folgenden Sinn:
% Bei der Berechnung der Filtergewichte bei Filterung über Klassifikationsfehler
% wird statt des callbacks direkt klassifizieren_zr_an gerufen. Insbesondere, um die zeitliche
% Aggregation zu vermeiden, die dann erst ausgeschaltet werden müsste. Der Klassifikationsfehler
% soll aber als Gewicht verwendet werden, also muss klassifizieren_zr_an ebenfalls einen Fehler berechnen.
code_all=code*ones(1,size(d_orgs,2));
temp=mean(pos_all(ind_auswahl,:)==code_all(ind_auswahl,:));
fehl_proz = 100*(1-temp);

%Visualisierung Ergebnisse
% Klassifkationsergebnis vor Trigger auf undefiniert setzen.
if (kp.triggerevent.start > 1)
   fehl_proz(1:kp.triggerevent.start-1) = NaN;
end;

%if (~exist('plot_mode', 'var'))
%   plot_mode = 1;
%end;

% zeitl_aggregation freigeben.
%enmat = enable_menus(parameter, 'enable', {'MI_ZRKlassi_ZeitlAggr','MI_ZRKlassi_ZeitlAggrPlot', 'MI_Anzeige_ZRKlassi'});
% Nun die alten Variablen wieder herstellen
if (parameter.gui.zr_klassifikation.aggregation_verfahren > 1)
   d_orgs = save_var.d_orgs;
	parameter.gui.zr_klassifikation.triggerzr = save_var.triggerzr;
	inGUIIndx = 'CE_ZRKlassi_Trigger'; inGUI;
  
   % Baue fehl_proz um! Die Klassifikation ist nun nicht zu jedem Abtastpunkt
   % durchgeführt worden (zumindest nicht zwingend)
   fprintf(1, 'Reconstruct sample points for rough data\n');
   fensterlaenge = klass_zr.zeitliche_aggregation_merk.fenstergroesse;
   schrittweite  = klass_zr.zeitliche_aggregation_merk.fenster_schrittweite;
   %abtastpunkte = [kp.triggerevent.start+fensterlaenge-1:schrittweite:kp.triggerevent.start+kp.triggerevent.kmax-1];
   abtastpunkte  = klass_zr.zeitliche_aggregation_merk.abtastpunkte;
   tmp = fehl_proz;
   fehl_proz = NaN*ones(1,size(save_var.d_orgs,2),1);
   fehl_proz(abtastpunkte) = tmp;
   
   clear save_var;
end;

%Plotten
%if (plot_mode)
%   plot_zr_klassif_fehler(fehl_proz, parameter);
%end;
%clear plot_mode;

% Hier die alten Klassifikationsgeschichten zurückschreiben:
pos = ckzr.pos;
prz = ckzr.prz;
klass_single = ckzr.klass_single;
clear ckzr;

% Zum Teil geht die Aktualisierung des Einzelmerkmalfensters verloren. Hier noch mal aufrufen...
%alle Parameter retten 
parameter.gui = my_zr_save.parameter.gui;
inGUI;
aktparawin;
