% Script callback_anzeige_fft
%
% Zunächst nur für die Anzeige verwenden.
% Unterschiedlich lange Zeitreihen sind noch nicht erlaubt...
% Ausgewählte Zeitreihen besorgen
%
% The script callback_anzeige_fft is part of the MATLAB toolbox Gait-CAD. 
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

zuviele = 10;
if (length(ind_auswahl) > zuviele)
   antwort = questdlg(sprintf('Compute FFT for %d data points?', length(ind_auswahl)), 'Question', 'Yes', 'No', 'No');
   if (strcmp(antwort,'No'))
      return;
   end;
end;

ind_zr = get(uihd(11,13), 'value');

% Eingegebene Abtastfrequenz auslesen und in Abtastzeit umrechnen
ta = 1/sscanf(get(uihd(11,52), 'String'), '%g');

% Plot-Art auslesen:
plopt = get(uihd(11,53), 'value') + 1;


zr_max_exp=floor(log2(parameter.gui.zeitreihen.segment_ende+1-parameter.gui.zeitreihen.segment_start));
zr_max=2^zr_max_exp;
fprintf('Only the first %d sample points are used (higher computational efficiency for FFT)\n',zr_max);

einheit.zeit     = ['[' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
einheit.frequenz = ['[' char(parameter.gui.zeitreihen.einheit_abtastfrequenz_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];


for i = ind_auswahl'
   for j = ind_zr
      figure;
      lastfft.time = parameter.gui.zeitreihen.segment_start+[0 zr_max-1];
      lastfft.zr = j;
      lastfft.dt = i;
      [lastfft.fc,lastfft.f]=myfft(d_orgs(i, parameter.gui.zeitreihen.segment_start+[0:zr_max-1], j), plopt, ta,[],[],[],[],einheit);
      set(gcf, 'Name', sprintf('%d: FFT Data point %d, %s', get_figure_number(gcf), i, deblank(var_bez(j,:))), 'NumberTitle', 'off');
   end;
end;

clear zr_max zr_max_exp einheit;