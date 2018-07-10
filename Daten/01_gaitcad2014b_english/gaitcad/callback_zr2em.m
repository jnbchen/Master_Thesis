% Script callback_zr2em
%
% The script callback_zr2em is part of the MATLAB toolbox Gait-CAD. 
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

if (isempty(parameter.gui.merkmale_und_klassen.ind_zr))
   mywarning('No time series selected. Cancel.\n');
   return;
end;
% Berechne die neuen Daten
zr2em_ind_zr = parameter.gui.merkmale_und_klassen.ind_zr;
[daten, bezeichner] = zeitreihen2einzelmerkmale(d_orgs(:, :, zr2em_ind_zr), deblank(var_bez(zr2em_ind_zr,:)), parameter);
% Hänge die Daten an d_org an:
d_org = [d_org daten];
dorgbez = strvcatnew(dorgbez, bezeichner);
clear zr2em_ind_zr daten bezeichner;
aktparawin;