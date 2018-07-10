  function h = plot_zr_merk(klass_zr, kp, parameter, f)
% function h = plot_zr_merk(klass_zr, kp, parameter, f)
%
% 
%  Plottet die verwendeten Merkmale eines Zeitreihen-Klassifikators
%  in ein Bild. x-Achse: Zeit, y-Achse: Merkmale.
%  Verwendete Merkmale werden durch ein Symbol markiert.
% 
%  klass_zr: Struct des Zeitreihen-Klassifikators
%  kp: Einstellungen des Klassifikators (benötigt für Triggerzeitreihe)
%  parameter: Gait-CAD-Parameter Struct
%  f: wenn übergeben, wird in die figure mit Handle f gezeichnet.
% 
%
% The function plot_zr_merk is part of the MATLAB toolbox Gait-CAD. 
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

kp = klass_zr.kp;

if (nargin < 3)
   fprintf(1, 'Too few parameters.\n');
   return;
end;
if nargin < 4 || isempty(f)
   f = figure;
end;

[col, sty] = color_style(parameter.gui.anzeige.farbvariante);
K  = parameter.par.laenge_zeitreihe;
N  = parameter.par.anz_merk;
fA = parameter.gui.zeitreihen.abtastfrequenz;
switch(parameter.gui.zeitreihen.anzeige)
case 'Percental' % Prozentuale Anzeige?
   time = [0:K-1]*100 ./ (K-1);
   x_beschrift = 'Percent';
case 'Sample points' % Samplepunkte anzeigen
   time = [1:K];
   x_beschrift = 'Sample points';
case 'Time' % Zeit anzeigen
   %Zeitachse setzen
   x_beschrift =['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
   time = [0:K-1]./fA;
otherwise
   time = [1:K];
   x_beschrift = 'Sample points';
end; % switch(tmp)
% parameter.gui.zeitreihen.red_sample;

% Nun das Zeichnen vorbereiten:
anzeige = NaN * ones(N, K);
anz_rest = NaN * ones(N, K);
% Beim TSK-Fuzzy sind z.T. mehr als ein Klassifikator aktiv. Der zweite Klassifikator ist allerdings
% meist schwächer gewichtet. Daher führe in so einem Fall eine zweite Anzeige ein:
if (kp.klassi_typ.typ ~= 6)
   for i = 1:size(klass_zr.aktiv,1)
      if ~isempty( klass_zr.klass_single{klass_zr.aktiv(i,1)})
         anzeige(klass_zr.klass_single{klass_zr.aktiv(i,1)}.merkmalsextraktion.merkmal_auswahl, i + kp.triggerevent.start-1) = klass_zr.klass_single{klass_zr.aktiv(i,1)}.merkmalsextraktion.merkmal_auswahl;
      end;
   end;
else
   for i = 1:size(klass_zr.aktiv,1)
      % Suche die Klassifikatoren, die eine Gewichtung größer als 0.5 haben.
      wichtiger = find(klass_zr.wichtung(i, :) >= 0.5);
      % Hier kommt der Rest
      unwichtiger = setxor([1:size(klass_zr.wichtung,2)], wichtiger);
      unwichtiger(klass_zr.wichtung(i, unwichtiger) == 0) = [];
      % Nun kopiere die Geschichte in die zugehörigen Matrizen
      for j = 1:length(wichtiger)
         anzeige(klass_zr.klass_single{klass_zr.aktiv(i,wichtiger(j))}.merkmalsextraktion.merkmal_auswahl, i + kp.triggerevent.start-1) = klass_zr.klass_single{klass_zr.aktiv(i,wichtiger(j))}.merkmalsextraktion.merkmal_auswahl;
      end;
      for j = 1:length(unwichtiger)
         anz_rest(klass_zr.klass_single{klass_zr.aktiv(i,unwichtiger(j))}.merkmalsextraktion.merkmal_auswahl, i + kp.triggerevent.start-1) = klass_zr.klass_single{klass_zr.aktiv(i,unwichtiger(j))}.merkmalsextraktion.merkmal_auswahl;
      end;
   end; % for (i = 1:size(klass_zr.aktiv,1))
end; % if (kp.klassi_typ.typ ~= 6)
% Unwichtigere Klassifikatoren ebenfalls plotten. Aber mit einem anderen Marker
if (kp.klassi_typ.typ == 6)
   hold on;
   p2 = plot(time, anz_rest, 'k.');
   set(p2, 'Marker', 'x', 'Color', [.5 .5 .5]);
end; % if (kp.klassi_typ.typ == 6)
p = plot(time, anzeige, 'k.');
set(p,  'Marker', '.');
if (kp.klassi_typ.typ == 6)
   legend([p(1) p2(1)], strvcatnew('Classifier with weight > 0.5', 'Classifier with weight  < 0.5'));
end;

title('Used features of the time series classifier');
set(gcf, 'Name', sprintf('%d: Used feature for the time series classifier', get_figure_number(gcf)), 'NumberTitle', 'off');
xlabel(x_beschrift);
ylabel('No. time series');

xlim([time(1) time(end)]);
ylim([1 N]);
ytick = get(gca, 'YTick');
ytick(rem(ytick, 1) ~= 0) = [];
set(gca, 'YTick', ytick);