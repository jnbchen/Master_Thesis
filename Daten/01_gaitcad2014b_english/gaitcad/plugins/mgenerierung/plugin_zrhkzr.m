  function [datenOut, ret, info] = plugin_zrhkzr(paras, datenIn)
% function [datenOut, ret, info] = plugin_zrhkzr(paras, datenIn)
%
% Transformiere die übergebenen Zeitreihen durch HKA in weniger Zeitreihen.
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_zrhkzr is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:07
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

if isfield(paras,'parameter_commandline')
   anz_zr = paras.parameter_commandline{1};
else
   anz_zr = 2;
end;

if (nargin < 2)
   datenIn = [];
end;

% Eigentlich nicht ganz korrekt, denn in datenIn.dat können weniger Zeitreihen übergeben werden!
% Aber mit paras.anz_gew_merk kann es geprüft werden. Das Feld gibt es aber nicht zwingend!!!
if (anz_zr > paras.par.anz_merk) || (isfield(paras,'anz_gew_merk') && anz_zr > paras.anz_gew_merk)
   % Nur warnen, wenn ausgeführt wird.
   if (~isempty(datenIn))
      warning('The number of PCA features will be reduced (too few time series).');
   end;
   if (isfield(paras, 'anz_gew_merk'))
      anz_zr = paras.anz_gew_merk;
   else
      anz_zr = paras.par.anz_merk;
   end;
end;
bezeichner = strcat('PCTS', num2str([1:anz_zr]'));
info = struct('beschreibung', 'TS->PC TS', 'bezeichner', bezeichner, 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0;
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = Inf;

info.explanation = 'computes new time series by means of a Principal Component Analysis of time series (Transformation number of time series $s_z$ -> $s_d$).';

info.commandline.description{1} = 'Number of aggregated PCA features';
info.commandline.parameter_commandline{1} = 2;
info.commandline.tooltext{1} = 'Number s_d of principal components computed of a time series';
info.commandline.wertebereich{1} =  {1 Inf };

info.commandline.description{2} = 'Normalize standard deviations';
info.commandline.parameter_commandline{2} = 2;
info.commandline.popup_string{2} = 'yes|none';
info.commandline.tooltext{2} = 'defines the normalization for the variances of the sample points';

info.commandline.description{3} = 'Transformation matrix';
info.commandline.parameter_commandline{3} = 1;
info.commandline.popup_string{3} = 'individal for each data point|same for all data points';
info.commandline.tooltext{3} = 'Use the same transformation matrix (e.g. PCA) for time series reduction of all data points';



if (isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

normierung = 2-paras.parameter_commandline{2};

datenOut.dat_zr = zeros(size(datenIn.dat,1), size(datenIn.dat,2), anz_zr);

% Es gibt zwei Möglichkeiten: für jeden Datensatz einzeln die Zeitreihen
% zu verringern oder alle Datensätze untereinander zu hängen und anschließend
% bei allen Datensätzen die gleiche Transformationsvorschrift zu verwenden.
if paras.parameter_commandline{3} == 1
   % Zunächst wird nur das erste gemacht:
   for i = 1:size(datenIn.dat,1)
      daten = squeeze(datenIn.dat(i, :, :));
      % Hauptkomponenten berechnen:
      [phi_hkm,hkvp,sigma]=hauptk_ber(daten, normierung);
      phi_hk=phi_hkm(:,1:anz_zr);
      
      datenOut.dat_zr(i, :, :) = daten * phi_hk;
   end;
else
   daten = [];
   % Hier nur die ausgewählten Daten verwenden!
   for i=1:length(paras.ind_auswahl)
      daten = [daten; squeeze(datenIn.dat(paras.ind_auswahl(i),:,:))];
   end;
   % Hauptkomponenten berechnen:
   [phi_hkm,hkvp,sigma]=hauptk_ber(daten, normierung);
   phi_hk=phi_hkm(:,1:anz_zr);
   
   % Jeden Datensatz transformieren
   % Bei der anschließenden Transformation müssen alle verwendet werden!
   for i = 1:size(datenIn.dat,1)
      datenOut.dat_zr(i, :, :) = squeeze(datenIn.dat(i, :, :)) * phi_hk;
   end;
end;

% Bezeichner in Cellstring kopieren. Da werden die Leerzeichen etwas besser behandelt.
gew_bez = cellstr(paras.var_bez(paras.ind_zr_merkmal,:));
% Der erste Bezeichner wird in der Generierungsdatei eingetragen. Hier weg.
gew_bez(1) = [];
merks = [' with ' sprintf('%s ', gew_bez{:})];
ret.bezeichner = strcat('PCTS ', num2str([1:anz_zr]'), merks);
ret.ungueltig = 0;
