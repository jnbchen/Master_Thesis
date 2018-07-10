  function [datenOut, ret, info] = plugin_filter(paras, datenIn)
% function [datenOut, ret, info] = plugin_filter(paras, datenIn)
%
% Berechnet eine gefilterte Zeitreihe.
% Liest diverse Parameter aus der Oberfläche.
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_filter is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

anz_zr = 1;
info = struct('beschreibung', 'Filtering', 'bezeichner', 'FIL', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation       = 'filters a time series. ';
info.explanation_long  = 'A \textindex{Butterworth filter} is used.';
info.explanation_long  = strcat(info.explanation_long,'This plugin needs the Signal Processing Toolbox of Matlab. \index{Highpass filter}\index{Lowpass filter}');
info.explanation_long  = strcat(info.explanation_long,'The Bode plot can be shown under Show - Time series.');


info.commandline.description{1} = 'Filter type';
info.commandline.parameter_commandline{1} = 2;
info.commandline.popup_string{1} = 'High pass|Lowpass|Bandpass';
info.commandline.tooltext{1} = 'determines the filter characteristics in the frequency domain.';

info.commandline.description{2} = 'Frequencies';
info.commandline.parameter_commandline{2} = [1 1];
info.commandline.tooltext{2} = strcat('defines the critical frequencies for the filter using the unit of the sample frequency (e.g. in Hz).',' The second parameter is only used for bandpass filters.');
info.commandline.wertebereich{2} = {0, 'parameter.gui.zeitreihen.abtastfrequenz/2'};

info.commandline.description{3} = 'Filter order (FIL)';
info.commandline.parameter_commandline{3} = 1;
info.commandline.tooltext{3} = 'determines the order of a filter.';
info.commandline.wertebereich{3} =  {1 Inf };
info.commandline.ganzzahlig{3} = 1;

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

%read parameters
filtertyp = paras.parameter_commandline{1};
stopfreq = paras.parameter_commandline{2};
filterordnung = paras.parameter_commandline{3};

switch filtertyp
case 1 %'Hochpass'
   ret.bezeichner = sprintf('HPass %3.1f', stopfreq(1));
case 2 %'Tiefpass'
   ret.bezeichner = sprintf('LPass %3.1f', stopfreq(1));
case 3 %'Bandpass'
   ret.bezeichner = sprintf('BPass %3.1f->%3.1f', stopfreq(1), stopfreq(2));
end;

fA = paras.parameter.gui.zeitreihen.abtastfrequenz; % Abtastintervall = 1/fA

%switch(paras.parameter.gui.zeitreihen.filter)
%case 1 % Butterworth
filter = 'butter';
%end;
% ACHTUNG: Die normale Filterfunktion arbeitet
% Spaltenweise bei Matrizen. Diese Matrix enthält in den Spalten aber die
% verschiedenen Realisierungen, in den Zeilen stehen die Daten einzelner
% Realisierungen. Also transponieren und Ergebnis wieder zurück drehen...
datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, anz_zr);
datenOut.dat_zr = signalFiltern(datenIn.dat', fA, stopfreq, filter, filtertyp, filterordnung)';
ret.ungueltig = 0;

   