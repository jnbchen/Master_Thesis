% Script callback_morlet_spektrogramm
%
% ind_auswahl gibt die ausgewählten Datentupel an.
% Warnung, falls viele Datentupel angezeigt werden sollen
%
% The script callback_morlet_spektrogramm is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

zuviele = 10;
zuviele_freqs = 100;
if (ms_mode == 1 && length(ind_auswahl) > zuviele)
   antwort = questdlg(sprintf('Compute spectrogram for %d data points', length(ind_auswahl)), 'Question', 'Yes', 'No', 'No');
   if (strcmp(antwort,'No'))
      return;
   end;
end;

clear params;
% Parameter aus Oberfläche holen
params.freqs = [parameter.gui.zeitreihen.filterfreq(1):parameter.gui.zeitreihen.wavelets.morlet.spektrogramm_schrittweite:parameter.gui.zeitreihen.filterfreq(2)];
if (length(params.freqs) == 1)
   mywarning('Only one frequency defined! It can cause visualization problems. Adding frequencies...');
   params.freqs = [params.freqs params.freqs+1];
end;
% Sind zu hohe Frequenzen dabei?
if (parameter.gui.zeitreihen.filterfreq(2) > parameter.gui.zeitreihen.abtastfrequenz)
   mywarning('Upper limit larger than half sampling frequency! Reducing frequency range...');
   param.freqs(params.freqs > floor(parameter.gui.zeitreihen.abtastfrequenz/2)) = [];
end;
   
if (isempty(params.freqs))
   myerror('Empty frequencies!');
   return;
end;
if (length(params.freqs) > zuviele_freqs)
   antwort = questdlg(sprintf('Compute spectrograms for %d frequencies?', length(params.freqs)), 'Question', 'Yes', 'No', 'No');
   if (strcmp(antwort,'No'))
      return;
   end;
end;

params.omega0  	= parameter.gui.zeitreihen.wavelets.morlet.w0;
params.fA 			= parameter.gui.zeitreihen.abtastfrequenz;
params.iir_param 	= parameter.gui.zeitreihen.iirfilter;
params.var_bez 	= deblank(var_bez(parameter.gui.merkmale_und_klassen.ind_zr,:));
params.relativ 	= parameter.gui.zeitreihen.relativ_zur_baseline;
params.baseline 	= parameter.gui.zeitreihen.samples_baseline;
params.red_sample = parameter.gui.zeitreihen.red_sample;


% Parameter für die Anzeige speichern:
params.param.fA						= params.fA;
params.param.colormap				= parameter.gui.zeitreihen.colormap;
params.param.colorbar_anzeigen	= parameter.gui.zeitreihen.plot_colorbar;
%params.param.kennlinie_anzeigen 	= parameter.gui.zeitreihen.plot_kennlinie;
params.param.kennlinie_art 		= parameter.gui.zeitreihen.kennlinie;
params.param.x_beschrift         = ['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
params.param.y_beschrift         = ['Frequency [' char(parameter.gui.zeitreihen.einheit_abtastfrequenz_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];

if (params.param.kennlinie_art == 2)
	params.param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_wurzel;
elseif (params.param.kennlinie_art == 3)
	params.param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_exp;
end;
params.param.kennlinie_name 		= deblank(parameter.gui.zeitreihen.kennlinie_name(params.param.kennlinie_art,:));
if (~parameter.gui.zeitreihen.caxis)
   params.param.caxis				= parameter.gui.zeitreihen.caxis_vec;
else
   params.param.caxis				= [];
end;

% Morlet-Spektrogramm-Funktion ausführen
params.plot_only = (ms_mode < 0);
if (params.plot_only && (~exist('morlet_plot_spect', 'var') || isempty(morlet_plot_spect)))
   myerror('Nothing to show! Function canceled!');
end;
switch(ms_mode)
case 1
   % Für einzelne Daten plotten
   for  i = ind_auswahl'
      daten = d_orgs(ind_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende,  parameter.gui.merkmale_und_klassen.ind_zr);
      params.start_time = parameter.gui.zeitreihen.segment_start;
      morlet_plot_spect = plotte_morlet_spektogramm(daten, code(ind_auswahl), params);
   end;
case 2
   % Über Klassen gemittelt plotten (macht die Funktion intern!)
   daten = d_orgs(ind_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, parameter.gui.merkmale_und_klassen.ind_zr);
   params.start_time = parameter.gui.zeitreihen.segment_start;
   morlet_plot_spect = plotte_morlet_spektogramm(daten, code(ind_auswahl), params);
case -1
   % Nur anzeigen:
   params.morlet_plot_spect = morlet_plot_spect;
   plotte_morlet_spektogramm([], [], params);
   params.morlet_plot_spect = [];
end; % switch(ms_mode)
clear ms_mode;


