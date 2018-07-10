% Script callback_ausreisser_an
%
% Callback-Funktion für die Anwendung von Ausreißer-Detektion
%
% The script callback_ausreisser_an is part of the MATLAB toolbox Gait-CAD. 
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

aufloesung = parameter.gui.anzeige.anz_gitterpunkte;

erzeuge_parameterstrukt;
% Daten noch mal erzeugen:
d=erzeuge_datensatz_an(d_org,klass_single(1).merkmalsextraktion);
% Algorithmus anwenden.
ausreisser = ausreisser_detektion_an(d(ind_auswahl, :), kp.ausreisser, klass_single(1));

fprintf('%d outliers found for %d data points.\n',length(ausreisser.indx),length(ind_auswahl));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Das folgende ist nur noch zum Zeichnen!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (parameter.gui.ausreisser.anzeige && size(d,2) == 2)
   fprintf(1, 'Plot results\n');
   if (~exist('plot_params', 'var'))
      plot_params = [];
   end;
   if (~isfield(plot_params, 'nnf') || ~plot_params.nnf)
      figure;
      set(gcf,'numbertitle','off','name',[sprintf('%d: ',get_figure_number(gcf)) 'Detected outliers']);
   end;
   
   farbig = (get(uihd(11,26), 'value') <= 2);
   % Das dichtebasierte Verfahren liefert diskrete Werte. Damit hat contour ein wenig
   % Schwierigkeiten und denkt sich einfach einige Werte aus. Lieber parametrieren und abfangen...
   if (kp.ausreisser.verfahren == 3)
      plot_params.diskret = 1;
   else
      plot_params.diskret = 0;
   end;
   plot_lp_detection(d(ind_auswahl,:), klass_single, ausreisser, kp.ausreisser, plot_params, parameter.gui.ausreisser.anzeige-1, farbig, aufloesung);
   clear p_ausreisser;
else
   if (parameter.gui.ausreisser.anzeige && size(d,2) ~= 2)
      fprintf(1, 'The feature space is not two-dimensional! No figure will be generated.\n');
   end;
end; % if (plot_erg)

f = ausreisser.werte;
ausreisser.werte = zeros(size(d, 1), 1);
ausreisser.indx = ind_auswahl(ausreisser.indx);
if (~isempty(f))
   ausreisser.werte(ind_auswahl) = f;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Soll das Ergebnis als Klasse gespeichert werden?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (parameter.gui.ausreisser.speichern_in_klasse > 1)
   temp = get(get_element_handle(parameter, 'CE_Ausreisser_Verfahren'), 'string');
   newcodename = sprintf('Outlier %s', deblank(temp(parameter.gui.ausreisser.verfahren, :)));
   
   % Erst mal alle auf Eins setzen. Die Klassencodierung darf in Gaitcad nur Werte > 0 enthalten!
   newcode = ones(size(d_org, 1), 1);
   % Klasse 1 werden die Klassenzugehörigen, Klasse 2 die Ausreißer:
   newcode(ausreisser.indx) = 2;
   % Nun noch die einzelnen linguistischen Terme verändern. Wir müssen uns eigentlich nur
   % um 1 und 2 kümmern. Wenn im Rest etwas steht, stört es nicht...
   newtermname(1,1).name = 'Class';
   newtermname(1,2).name = 'Outlier';
   
   % Soll eine Klasse ersetzt werden, wird hier die Nummer der zu ersetzenden Klasse bestimmt:
   temp = getfindstr(bez_code,newcodename,'exact'); %temp = strmatch(newcodename, bez_code);
      
   % Wurde eine Klasse gefunden?
   if (parameter.gui.ausreisser.speichern_in_klasse == 3 && ~isempty(temp))
      % Wenn die Klasse gefunden wurde, nicht löschen, sondern die Daten nur ersetzen
      code_alle(:, temp) = newcode;
      zgf_y_bez(temp, 1).name = 'Class';
      zgf_y_bez(temp, 2).name = 'Outlier';
   else
      % Klasse existiert nicht nicht
      [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,newcodename,newtermname);
      aktparawin;
   end; % if (parameter.gui.ausreisser.speichern_in_klasse == 3 && ~isempty(temp))
end;

% Einigen Speicher wieder freigeben.
clear newcode newcodename newtermname temp klasse_alt;