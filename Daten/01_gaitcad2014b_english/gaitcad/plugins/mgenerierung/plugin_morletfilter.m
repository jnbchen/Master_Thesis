  function [datenOut, ret, info] = plugin_morletfilter(paras, datenIn)
% function [datenOut, ret, info] = plugin_morletfilter(paras, datenIn)
%
% Berechnet eine gefilterte Zeitreihe. Verwendet ein komplexes Morlet-Wavelet
% Liest diverse Parameter aus der Oberfläche.
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_morletfilter is part of the MATLAB toolbox Gait-CAD. 
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
info = struct('beschreibung', 'Filtering with Morlet wavelet', 'bezeichner', 'Morl', 'anz_zr', anz_zr, 'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.commandline.description{1} = 'Morlet wavelet: frequency';
info.commandline.parameter_commandline{1} = 10;
info.commandline.tooltext{1} = 'This frequency describes the center of the region which is not damped by the Morlet-Wavelet.';
info.commandline.wertebereich{1} =  {0.0000001 Inf};

info.commandline.description{2} = 'Morlet wavelet: frequency';
info.commandline.parameter_commandline{2} = 10;
info.commandline.tooltext{2} = 'The width of the region is defined by the eigenfrequency of the Morlet wavelet';
info.commandline.wertebereich{2} =  {1 Inf};

info.commandline.description{3} = 'Causal Morlet wavelet';
info.commandline.parameter_commandline{3} = 1;
info.commandline.popup_string{3} = 'yes|none';
info.commandline.tooltext{3} = 'Use the same transformation matrix (e.g. PCA) for time series reduction of all data points';




if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

fA = paras.parameter.gui.zeitreihen.abtastfrequenz;
f  = paras.parameter_commandline{1};
w0 = paras.parameter_commandline{2};
kausal = 2-paras.parameter_commandline{3};

datenOut.dat_zr = zeros(paras.par.anz_dat, paras.par.laenge_zeitreihe, anz_zr);
for i = 1:size(datenIn.dat,1)
   sig = datenIn.dat(i, :);
   fil = morlet_filterung(sig, fA, f, w0, kausal);
   datenOut.dat_zr(i, :) = fil;
end;
ret.bezeichner = sprintf('Morl (%3.1f, %d)', f, w0);
ret.ungueltig = 0;

   