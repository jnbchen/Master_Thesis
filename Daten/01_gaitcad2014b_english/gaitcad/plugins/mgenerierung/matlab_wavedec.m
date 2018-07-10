  function [waves, bez] = matlab_wavedec(daten, wave_typ, max_level, params)
% function [waves, bez] = matlab_wavedec(daten, wave_typ, max_level, params)
%
%  daten ist eine Matrix des Formats #Abtastpunkte x #Kanäle
%  wave_typ: String mit gewünschtem Wavelet (z.B. 'db4')
%  max_level: Maximaler zu berechnender Level
%  params: Strukt mit Feldern:
%  params.fA: Abtastfrequenz, wird nur für Bezeichner benötigt (optional)
%  params.iir_fil: Gleichrichtung und IIR-Filtern? Wenn nein: [], sonst Angabe des IIR-Filter-Parameters
%  params.bez: Bezeichner der übergebenen Kanäle (optional)
%  Rückgabe:
%  waves: Matrix der Größe #Abtastpunkte x #Kanäle*(max_level+1)
%  Kanalweise erst TP, dann max_level-viele HPs,
%  also z.B. Ch1 TP max_level, Ch1 HP Level 1, ... Ch1 HP Level max_level,
%            Ch2 TP max_level, Ch2 HP Level 1, ...
%  bez: Bezeichner von waves. Benötigt dafür params.fA
%  Falls Bezeichner für die übergebenen Kanäle vorhanden sind, können die in params.bez übergeben werden.
%
% The function matlab_wavedec is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 4)
   params.iir_fil = [];
end;

if ~isfield(params, 'iir_fil')
   params.iir_fil = [];
end;
if ~isfield(params, 'fA')
   fA = 100;
else
   fA = params.fA;
end;
if (~isfield(params, 'bez'))
   params.bez = [];
end;

P = size(daten,1);
anz_kanaele = size(daten,2);

waves = zeros(size(daten,1), anz_kanaele*(max_level + 1));
bez = [];
for ii = 1:anz_kanaele
   [C,L] = wavedec(daten(:,ii), max_level, wave_typ);
   
   appC = appcoef(C, L, wave_typ, max_level); % in app steht der Tiefpaß-Anteil
   Q = length(appC);
   % resample schmiert irgendwann (rekonstruierbar) mit stack fault ab.
   % Keine Ahnung warum.
   %waves(:, (ii-1)*(max_level+1)+1) = resample(appC, P, Q);
   % interp funktioniert! Dann müssen die Signale aber evtl. etwas abgeschnitten werden...
   % Problem: bei ungeraden Längen des Orinalsignals gibt es Rundungsfehler beim Teilen. Daher keine direkten
   % Vielfachen. Es handelt sich aber nur um einige Abtastpunkte ganz am Ende. Das sollte zu verschmerzen sein...
   temp = interp(appC, ceil(P/Q));
   waves(:, (ii-1)*(max_level+1)+1) = temp(1:P);
   
   if (isempty(params.bez))
      bez = strvcatnew(bez, sprintf('Ch %d %s App %d (0 - %3.1f %s)', ii,  wave_typ, max_level, fA/(2^(max_level+1)), params.einheit));
   else
      bez = strvcatnew(bez, sprintf('%s %s App %d (0 - %3.1f %s)', deblank(params.bez(ii,:)),  wave_typ, max_level, fA/(2^(max_level+1)), params.einheit)     );
   end;
   
   for j=1:max_level
      detC = detcoef(C, L, j); % Besorge die Hochpassteile...
      Q = length(detC);
      %waves(:, (ii-1)*(max_level+1)+j) = resample(detC, P, Q);
      % Der Matlab-Algorithmus liefert weniger Abtastpunkte als das Originalsignal. Durch Interpolation korrigieren.
      temp = interp(detC, ceil(P/Q));
      waves(:, (ii-1)*(max_level+1)+j+1) = temp(1:P);
      
      bounds = [fA/(2^(j+1))  fA/(2^j)];
      if (isempty(params.bez))
         bez = strvcatnew(bez, sprintf('Ch %d %s Det %d (%3.1f - %3.1f %s)', ii, wave_typ, j, bounds(1), bounds(2),  params.einheit));
      else
         bez = strvcatnew(bez, sprintf('%s %s Det %d (%3.1f - %3.1f %s)', deblank(params.bez(ii,:)), wave_typ, j, bounds(1), bounds(2),params.einheit));
         
      end;
   end;
end;
if ~isempty(params.iir_fil)
   % Gleichrichten
   waves = waves .* waves;
   % TP-Filtern
   waves = IIRFilter(waves, params.iir_fil, waves(1,:));
end;