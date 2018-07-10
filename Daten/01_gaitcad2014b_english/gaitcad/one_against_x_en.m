% Script one_against_x_en
%
% The script one_against_x_en is part of the MATLAB toolbox Gait-CAD. 
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

orig.ind_auswahl 	= ind_auswahl;
orig.code 			= code;

% Welche Klassen kommen in den Daten vor?
codes = unique(orig.code(ind_auswahl))';
% Zählvariable für klass_single
count = 1;

typ = kp.mehrklassen - 1;

klass_single_cell = {};

% Schalte die allgemeine Anzeige aus.
global globat_plot_off;
global_plot_off = 1;
warning off;
% Aber den Fortschritt für die Gesamtzahl an Klassifikatoren noch anzeigen:
if (~exist('one_against_x_waitbar', 'var'))
   one_against_x_waitbar = 1;
end;
% Für alle Klassen durchgehen:
if (typ == 1)
   hwb.laenge = length(codes);
else
   hwb.laenge = length(codes)*(length(codes)-1)/2;
end;
if (one_against_x_waitbar)
   hwb.handle = waitbar(0, 'Design classifiers');
end;
for c_count = 1:length(codes)
   c = codes(c_count);
   
   code = orig.code;
   
   fprintf('%d of %d\n',c_count,length(codes));
   
   % one-against-all
   if (typ == 1)
		% Suche die Datentupel, die zu der Klasse gehören.
      ind_code = find(orig.code == c);
      % Suche die Datentupel, die nicht zu dieser Klasse gehören
      ind_code_nicht = find(orig.code ~= c);
      % Passe die realen Klassencodes an one-against-all an:
      % An dieser Stelle muss auf ind_auswahl noch keine Rücksicht genommen werden!
      code(ind_code) = 1;
      code(ind_code_nicht) = 2;
      
      one_against_x_indx = count;
      if (one_against_x_erzeuge_ds)
         erzeuge_datensatz; 
      end;
		%alle Schritte von Merkmalsauswahl bis -aggregation
		%bei Mehrfachklassifikatoren steht die (derzeit) einheitliche Info beim 1. Klassifikator
		d=erzeuge_datensatz_an(d_org,klass_single(count).merkmalsextraktion);
      
      clear klass_temp;
      klass_temp.merkmalsextraktion = klass_single(count).merkmalsextraktion;
      klass_temp.klasse.nr  	 = par.y_choice;
      klass_temp.klasse.bez 	 = deblank(bez_code(par.y_choice,:));
      klass_temp.klasse.zgf_bez = zgf_y_bez(par.y_choice, 1:size(zgf_y_bez,2));
      klass_temp = klassifizieren_en(klass_temp, kp, d(ind_auswahl,:), code(ind_auswahl));
      klass_single_cell{count} = klass_temp;
      % Vermerke im Klassifikationsstrukt, dass es sich um einen one-against-all
      % Klassifikator handelt:
      klass_single_cell{count}.one_against_all.angelernt = c;
      klass_single_cell{count}.one_against_one = [];
      % Passe klass_single.klasse.angelernt an. Dieser Wert muss statisch für alle klass_singles identisch sein!
      klass_single_cell{count}.klasse.angelernt = codes;
      % Erhöhe den Zähler für den nächsten Klassifikator
      count = count + 1;
      
      % Anzeige des Fortschritts?
      if (one_against_x_waitbar)
         waitbar(count/hwb.laenge, hwb.handle);
      end;
   else % one-against-one
      % Hier muss eine weitere for-Schleife verwendet werden, um
      % alle Klassenkombinationen zu testen:
      for(c_count2 = c_count+1:length(codes))
         ind_auswahl = orig.ind_auswahl;
         c2 = codes(c_count2);
         % In diesem Fall dürfen die Klassenwerte bestehen bleiben, aber es werden
         % nur die Datentupel übergeben, die zu den entsprechenden Klassen gehören:
         ind_code = find(orig.code == c | orig.code == c2); % Coderevision: &/| checked!
         % Aus ind_code müssen diejenigen entfernt werden, die nicht in ind_auswahl stehen:
         ind_code(find(~ismember(ind_code, orig.ind_auswahl))) = [];
         % Nun setze die Auswahl um und erzeuge den Datensatz:
         ind_auswahl = ind_code;
         one_against_x_indx = count;
         if (one_against_x_erzeuge_ds)
   	      erzeuge_datensatz; 
	      end;
			%alle Schritte von Merkmalsauswahl bis -aggregation
			%bei Mehrfachklassifikatoren steht die (derzeit) einheitliche Info beim 1. Klassifikator
			d=erzeuge_datensatz_an(d_org,klass_single(count).merkmalsextraktion);
         
         clear klass_temp;
         klass_temp.merkmalsextraktion = klass_single(count).merkmalsextraktion;
         klass_temp.klasse.nr  	 = par.y_choice;
         klass_temp.klasse.bez 	 = deblank(bez_code(par.y_choice,:));
         klass_temp.klasse.zgf_bez = zgf_y_bez(par.y_choice, 1:size(zgf_y_bez,2));
         klass_temp = klassifizieren_en(klass_temp, kp, d(ind_auswahl,:), code(ind_auswahl));
         klass_single_cell{count} = klass_temp;
         klass_single_cell{count}.one_against_one.angelernt = [c c2];
         klass_single_cell{count}.one_against_all = [];
         % Passe klass_single.klasse.angelernt an. Dieser Wert muss statisch für alle klass_singles identisch sein!
	      klass_single_cell{count}.klasse.angelernt = codes;
         count = count + 1;
         % Anzeige des Fortschritts?
	      if (one_against_x_waitbar)
   	      waitbar(count/hwb.laenge, hwb.handle);
      	end;
      end; % for(c_count2 = c_count+1:length(codes))
   end; % if (typ == 1)
end; % for(c = 1:length(codes))

klass_single = klass_single_cell{1};
for(i = 2:length(klass_single_cell))
   klass_single(i) = klass_single_cell{i};
end;

ind_auswahl = orig.ind_auswahl;
code 			= orig.code;
warning on;
% Dieser Aufruf ist nötig, um in alle vorhandenen Klassifikatoren einige Variablen für die
% Namensgebung eintragen zu lassen (z.B. klass_single.klasse.zgf_bez)
aktparawin;

if (one_against_x_waitbar)
   close(hwb.handle);
end;
clear orig hwb klass_single_cell;
clear global global_plot_off;