  function [daten, bezeichner] = zeitreihen2einzelmerkmale(zr, zrbez, parameter)
% function [daten, bezeichner] = zeitreihen2einzelmerkmale(zr, zrbez, parameter)
%
%  function [daten, bezeichner] = zeitreihen2einzelmerkmale(zr, zrbez)
%  zr: NxKxz Matrix mit allen Zeitreihen, die in Einzelmerkmale umgewandelt
%  werden sollen. zrbez sind die zugehörigen Bezeichner.
%  Die Ausgabe ist eine neue Matrix der Dimension und NxK*z neuen K*z
%  Bezeichnern für die Einzelmerkmale.
% 
%
% The function zeitreihen2einzelmerkmale is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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
   namenskonvention = 1;
else
   namenskonvention = parameter.gui.anzeige.namenskonvention;
end;
if (nargin < 2)
   zrbez = [];
end;
if (nargin < 1)
   error('No time series found. Cancel.');
   return;
end;
bezeichner = [];
N = size(zr,1);
K = size(zr,2);
z = size(zr,3);
daten = zeros(N, K*z);

% Gehe durch jede Zeitreihe durch
for zr_i = 1:z
   start = (K*(zr_i-1)) + 1;
   ende  = start + K - 1;
   daten(:, start:ende) = squeeze(zr(:, :, zr_i));
   if (namenskonvention == 1)
      bezeichner = strvcatnew(bezeichner, [myResizeMat(deblank(zrbez(zr_i,:)), K, 1) myResizeMat(' SP', K, 1) num2str([1:K]')]);
   else
      bezeichner = strvcatnew(bezeichner, [myResizeMat(deblank(zrbez(zr_i,:)), K, 1) myResizeMat('_SP', K, 1) num2str([1:K]')]);
   end;
end;