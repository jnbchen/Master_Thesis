% Script callback_klassifikator_en
%
% The script callback_klassifikator_en is part of the MATLAB toolbox Gait-CAD. 
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
clear anz_klassen_auswahl;

erzeuge_parameterstrukt;

%aktuelle Ausgangsklasse und alle zugehörigen Informationen in den Klassifikator eintragen...
klass_single=[];
klass_single.klasse.nr  	 = par.y_choice;
klass_single.klasse.bez 	 = deblank(bez_code(par.y_choice,:));
klass_single.klasse.zgf_bez = zgf_y_bez(par.y_choice, 1:par.anz_ling_y(par.y_choice));

erzeuge_ds = 1;
% Es gibt eine Ausnahme bei der Klassifikation von Zeitreihen.
% Da sollen z.T. vorhandene Strukturen einfach noch einmal verwendet werden.
% Wird durch die Existenz des Strukts k3_single angezeigt!
if (exist('k3_single', 'var') && ~isempty(k3_single))
   erzeuge_ds = 0;
   % Hier noch mal kopieren. Geht oben sonst verloren...
   klass_single = k3_single;
end;

% Reines Mehrklassenproblem
if kp.mehrklassen == 1 || kp.mehrklassen == 4 || ((strcmp(kp.klassifikator, 'svm') && parameter.gui.klassifikation.svm.internes_oax))
   %ruft Merkmalsauswahl und -aggregation auf (aus der Oberfläche), aber nur bei Entwurf und bei Entwurf mit direkt darauf folgender Anwendung
   if (erzeuge_ds)
      % Folgende Variable kennzeichnet den aktuellen Stand des Entwurfs bei one-against-one oder
      % one-against-all. Die muss hier entfernt werden!
      clear one_against_x_indx;
      erzeuge_datensatz; 
   end;
   
   %alle Schritte von Merkmalsauswahl bis -aggregation
   %bei Mehrfachklassifikatoren steht die (derzeit) einheitliche Info beim 1. Klassifikator
   d=erzeuge_datensatz_an(d_org,klass_single(1).merkmalsextraktion);
   
   klass_single = klassifizieren_en(klass_single, kp, d(ind_auswahl,:), code(ind_auswahl,:));
else
   % Ansonsten entwerfe entweder one-against-one oder one-against-all
   % Wegen des Aufrufs von erzeuge_datensatz ist die Implementierung als Funktion
   % extrem aufwändig. Daher wird hier ein Skript verwendet:
   one_against_x_erzeuge_ds = erzeuge_ds;
   one_against_x_en;
   clear one_against_x_erzeuge_ds;
end; % if (kp.mehrklassen == 1)

%bisherigen Klassifikator merken
for i=1:length(klass_single) 
   klass_single(i).entworfener_klassifikator.typ=kp.klassifikator;
   klass_single(i).entworfener_klassifikator.nummer=parameter.gui.klassifikation.klassifikator;
   klass_single(i).entworfener_klassifikator.mehrklassen=parameter.gui.klassifikation.mehrklassen;
end;


%enmat = enable_menus(parameter, 'enable', 'MI_EMKlassi_An');

%vorsichtshalber Ergebnisse anderer Klassifikatoren löschen
pos=[];
prz=[];
md=[];
aktparawin;
