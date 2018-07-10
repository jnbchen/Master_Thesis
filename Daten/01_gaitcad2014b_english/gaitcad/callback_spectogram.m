% Script callback_spectogram
%
% Berechnet und plottet das Spektogramm für die ausgewählten Zeitreihen.
% 
% ind_auswahl gibt die ausgewählten Datentupel an.
% Warnung, falls viele Datentupel angezeigt werden sollen
%
% The script callback_spectogram is part of the MATLAB toolbox Gait-CAD. 
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
if (spectyp < 2 && length(ind_auswahl) > zuviele)
   antwort = questdlg(sprintf('Compute spectrogram for %d data points', length(ind_auswahl)), 'Question', 'Yes', 'No', 'No');
   if (strcmp(antwort,'No'))
      return;
   end;
end;


switch(spectyp)
case 2
   anzeige = 0;
case 1
   anzeige = 1;
case 0
   anzeige = -1;
end;
% Wenn nur angezeigt werden soll, muss das berechnet Spektogramm existieren:
if (anzeige == -1 && (~exist('spect', 'var') || isempty(spect) ) )
   spect = [];
   anzeige = 1;
end;
param.fA 						= parameter.gui.zeitreihen.abtastfrequenz;
param.fensterLaenge 			= parameter.gui.zeitreihen.fenstergroesse;
param.colormap					= parameter.gui.zeitreihen.colormap;
param.kennlinie_art 			= parameter.gui.zeitreihen.kennlinie;
param.phasengang  			= parameter.gui.zeitreihen.phasengang;
param.x_beschrift          = ['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
param.y_beschrift          = ['Frequency [' char(parameter.gui.zeitreihen.einheit_abtastfrequenz_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];

if parameter.gui.anzeige.aktuelle_figure && gcf~=1 
   special_figure = gcf;
else
   special_figure = [];
end;


if (param.kennlinie_art == 2)
   param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_wurzel;
elseif (param.kennlinie_art == 3)
   param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_exp;
end;
param.kennlinie_name 		= deblank(parameter.gui.zeitreihen.kennlinie_name(param.kennlinie_art,:));
param.colorbar_anzeigen		= parameter.gui.zeitreihen.plot_colorbar;
param.zeitverschiebung     = (parameter.gui.zeitreihen.segment_start-1)/parameter.gui.zeitreihen.abtastfrequenz;
% Automatische Farbachsenskalierung?
if (parameter.gui.zeitreihen.caxis)
   param.caxis = [];
else
   param.caxis = parameter.gui.zeitreihen.caxis_vec;
end;
if (anzeige < 0)
   berechneSpektogramm([], param, anzeige, param_spect.var_bez, [], 0, spect);
else
   spect = berechneSpektogramm(d_orgs(ind_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, parameter.gui.merkmale_und_klassen.ind_zr), param, anzeige, deblank(var_bez(parameter.gui.merkmale_und_klassen.ind_zr,:)), num2str(ind_auswahl),special_figure);
   param_spect.ind_auswahl = ind_auswahl;
   param_spect.var_bez = deblank(var_bez(parameter.gui.merkmale_und_klassen.ind_zr,:));
end;

fprintf(1, 'Complete!\n');
