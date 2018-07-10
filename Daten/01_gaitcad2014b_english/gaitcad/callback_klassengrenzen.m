% Script callback_klassengrenzen
%
% The script callback_klassengrenzen is part of the MATLAB toolbox Gait-CAD. 
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

if (isempty(klass_single) || ~isfield(klass_single(1), 'merkmalsextraktion') || isempty(klass_single.merkmalsextraktion))
   mywarning('No data set exists. Please firstly design a data set!');
   return;
end;

d=erzeuge_datensatz_an(d_org,klass_single(1).merkmalsextraktion);
ckg.ind_auswahl_save = ind_auswahl;

klassen_grenzen = [];
if (parameter.gui.ausreisser.anzeige > 1 && size(d,2) == 2)
   figure;
   
   % Bestimme die globalen Extremwerte aller ausgewählten Datentupel
   ckg.glob_xmin = min(min(d(ind_auswahl, 1))); 
   ckg.glob_xmin = ckg.glob_xmin - (sign(ckg.glob_xmin))*0.2*ckg.glob_xmin;
   ckg.glob_xmax = max(max(d(ind_auswahl, 1))); 
   ckg.glob_xmax = ckg.glob_xmax + (sign(ckg.glob_xmax))*0.2*ckg.glob_xmax;
   ckg.glob_ymin = min(min(d(ind_auswahl, 2))); 
   ckg.glob_ymin = ckg.glob_ymin - (sign(ckg.glob_ymin))*0.2*ckg.glob_ymin;
   ckg.glob_ymax = max(max(d(ind_auswahl, 2))); 
   ckg.glob_ymax = ckg.glob_ymax + (sign(ckg.glob_ymax))*0.2*ckg.glob_ymax;
   
   %avoid problems with the axis command
   if ckg.glob_xmin>= ckg.glob_xmax
      ckg.glob_xmax = ckg.glob_xmin + 1E-10;
   end;
   if ckg.glob_ymin>= ckg.glob_ymax
      ckg.glob_ymax = ckg.glob_ymin + 1E-10;
   end;
   
   % Teile dem folgenden Callback mit, dass kein neues Fenster erstellt werden soll.
   plot_params.nnf = 1;
   % Teile der Plotfunktion mit, dass nur die Grenzen gezeichnet werden sollen
   plot_params.nur_grenzen = 1;
   % Verwende globale Minima und Maxima für die Klassengrenzen
   plot_params.min = [ckg.glob_xmin ckg.glob_ymin];
   plot_params.max = [ckg.glob_xmax ckg.glob_ymax];
end;
% Gehe durch alle Codes
% Verwende sicherheitshalber par.y_choice in code_alle, falls jemand an code rumspielt...
ckg.klasse_speichern = parameter.gui.ausreisser.speichern_in_klasse;
parameter.gui.ausreisser.speichern_in_klasse = 1;
inGUIIndx = 'CE_Ausreisser_InKlasse'; inGUI;
for c = generate_rowvector(unique(code_alle(ckg.ind_auswahl_save, par.y_choice)))
   ind_auswahl = find(code_alle(ckg.ind_auswahl_save, par.y_choice) == c);
   
   if ~isempty(ind_auswahl)
	   % Und lasse die Grenzen berechnen.
   	callback_ausreisser_en;
	   callback_ausreisser_an;
	   % Sichere die einzelnen Entscheidungsdaten und die Ergebnisse
	   klassen_grenzen(c).lp_detect  = klass_single(1).ausreisser;
      klassen_grenzen(c).ausreisser = ausreisser;
   else
      klassen_grenzen(c).lp_detect = [];
      klassen_grenzen(c).ausreisser = [];
   end;
end; % for(c = code_wahl)
%hold on;

% Stelle die ursprüngliche Auswahl wieder her.
parameter.gui.ausreisser.speichern_in_klasse = ckg.klasse_speichern;
inGUIIndx = 'CE_Ausreisser_InKlasse'; inGUI;
ind_auswahl = ckg.ind_auswahl_save;

if (parameter.gui.ausreisser.speichern_in_klasse > 1)
   temp = get(get_element_handle(parameter, 'CE_Ausreisser_Verfahren'), 'string');
   newcodename = sprintf('Outlier %s', deblank(temp(parameter.gui.ausreisser.verfahren, :)));
   
   % Erst mal alle auf Drei setzen. Die Klassencodierung darf in Gaitcad nur Werte > 0 enthalten!
   newcode = 3*ones(size(d_org, 1), 1);
   % Alle, die hier behandelt wurden, werden schon mal als zur Klasse gehörig eingestuft
   newcode(ind_auswahl) = 1;
   % Klasse 2 werden die Ausreißer:
   for c = 1:length(klassen_grenzen)
      newcode(ind_auswahl(klassen_grenzen(c).ausreisser.indx)) = 2;
   end;
   % Nun noch die einzelnen linguistischen Terme verändern. Wir müssen uns eigentlich nur
   % um 1 und 2 kümmern. Wenn im Rest etwas steht, stört es nicht...
   newtermname(1,1).name = 'Class';
   newtermname(1,2).name = 'Outlier';
   newtermname(1,3).name = 'Unknown';
   
   % Soll eine Klasse ersetzt werden, wird hier die Nummer der zu ersetzenden Klasse bestimmt:
	temp = getfindstr(bez_code,newcodename,'exact'); % temp = strmatch(newcodename, bez_code);
   
   % Wurde eine Klasse gefunden?
   if (parameter.gui.ausreisser.speichern_in_klasse == 3 && ~isempty(temp))
      % Wenn die Klasse gefunden wurde, nicht löschen, sondern die Daten nur ersetzen
      code_alle(:, temp) = newcode;
      zgf_y_bez(temp, 1).name = 'Class';
      zgf_y_bez(temp, 2).name = 'Outlier';
      zgf_y_bez(temp, 3).name = 'Unknown';
   else
      % Klasse existiert nicht nicht
      [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,newcodename,newtermname);
   end; % if (parameter.gui.ausreisser.speichern_in_klasse == 3 && ~isempty(temp))
end;

if (parameter.gui.ausreisser.anzeige > 1 && size(d,2) == 2)
	plotfarb(d(ind_auswahl, :), code(ind_auswahl), 0, parameter.gui.anzeige.anzeige_grafiken, klass_single(1).merkmalsextraktion.var_bez, zgf_y_bez(par.y_choice,:));
   %axis([glob_xmin-(sign(glob_xmin))*0.1*glob_xmin glob_xmax + (sign(glob_xmax))*0.1*glob_xmax glob_ymin - (sign(glob_ymin))*0.1*glob_ymin glob_ymax + (sign(glob_ymax))*0.1*glob_ymax]);
   axis([ckg.glob_xmin ckg.glob_xmax ckg.glob_ymin ckg.glob_ymax]);
   set(gcf, 'NumberTitle', 'off', 'Name', sprintf('%d: All class borders', get_figure_number(gcf)));
end;

aktparawin;
clear plot_params anzeige_save ckg temp newcodename newtermname newcode;