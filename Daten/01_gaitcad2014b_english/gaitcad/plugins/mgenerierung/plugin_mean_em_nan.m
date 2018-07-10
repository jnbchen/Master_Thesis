  function [daten, ret, info] = plugin_mean_em_nan(paras, datenIn)
% function [daten, ret, info] = plugin_mean_em_nan(paras, datenIn)
%
% 
% 
%
% The function plugin_mean_em_nan is part of the MATLAB toolbox Gait-CAD. 
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

info = struct('beschreibung', 'Mean value SF NaN', 'bezeichner', 'MEAN', 'anz_zr', 0, 'anz_em', 1, 'laenge_zr', 0, 'typ', 'SF');
info.einzug_OK = 1; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.explanation = strcat('computes the mean of a time series or a time series segment as single feature.',' NaN values in a time series will be ignored.');


if (nargin < 2 || isempty(datenIn))
   daten = [];
   ret = [];
   return;
end;

%mit NaN vorinitialisieren
daten.dat_em=zeros(size(datenIn.dat,1),1);
daten.dat_em(1:end)=NaN;

for i=1:size(datenIn.dat,1)
   daten.dat_em(i) = mean(datenIn.dat(i,~isnan(datenIn.dat(i,:))));
end;

ret.ungueltig = 0;
