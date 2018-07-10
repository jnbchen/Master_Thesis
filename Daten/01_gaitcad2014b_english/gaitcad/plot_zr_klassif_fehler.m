  function plot_zr_klassif_fehler(fehl_proz, parameter, fig)
% function plot_zr_klassif_fehler(fehl_proz, parameter, fig)
%
% The function plot_zr_klassif_fehler is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 3)
   fig = figure;
else
   figure(fig);
end;

% Wenn die verwendete Zeitreihe vor der Klassifikation aggregiert wurde, sind in
% dem Klassifikationsergebnis Lücken enthalten. Dann verwende nicht die plot-Funktion,
% sondern stem.
if (max(diff(find(~isnan(fehl_proz)))>1))
   tf  = parameter.gui.zeitreihen.abtastfrequenz;
   tmp = parameter.gui.zeitreihen.anzeige;
   switch(tmp)
   case 'Percental' % Prozentuale Anzeige?
      pa = 1;
   case 'Sample points' % Samplepunkte anzeigen
      pa = 2;
   case 'Time' % Zeit anzeigen
      pa = 3;
   otherwise
      pa = 2;
   end; % switch(tmp)
   if pa == 1
      time=[parameter.gui.zeitreihen.segment_start-1:parameter.gui.zeitreihen.segment_ende-1]*100./(size(d_orgs,2)-1);
      x_beschrift = 'Percent';
   elseif pa == 2
      time=[parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende];
      x_beschrift = 'Sample points';
   else 
      %Zeitachse setzen
      x_beschrift=['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
      time=[parameter.gui.zeitreihen.segment_start-1:parameter.gui.zeitreihen.segment_ende-1]/tf;   
   end;
   
   h=stem(time, fehl_proz, 'k');
   set(h(1), 'Marker', '.', 'MarkerSize', 15);
   xlabel(x_beschrift); ylabel('Classifier error [%]');
   grid on;
else
   visu_zeitreihe(fehl_proz, 1, 'Classifier error [%]', [], parameter, parameter.par, [], [], [], 0, [], 0, 1);
end;
set(fig, 'Name', sprintf('%d: Result of time series classification [%%]', get_figure_number(fig)));
