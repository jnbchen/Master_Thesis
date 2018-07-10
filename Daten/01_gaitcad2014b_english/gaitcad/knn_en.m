  function [knn_dat] = knn_en(dat, code, knn_param, knn_dat)
% function [knn_dat] = knn_en(dat, code, knn_param, knn_dat)
%
%  dat: Datenmatrix der Größe #Beobachtungen x #Merkmale
%  code: Klassenzugehörigkeiten #Beobachtungen x 1
%  knn_param: Strukt mit Feldern:
%  - normieren: Gibt an, ob die Daten auf den Bereich [0,1] normiert werden sollen
%  (default: 1)
%  knn_dat: Strukt, das von knn_en zurückgegeben wird. Enthält Daten nach dem Anlernen
%  des Klassifikators.
%
% The function knn_en is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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
   knn_param = [];
end;
if (~isfield(knn_param, 'normieren'))
   knn_param.normieren = 1;
end;

knn_dat = knn_param;
if (knn_param.normieren)
	[dat, knn_dat.min, knn_dat.diff] = matrix_normieren(dat, 2);
else
	knn_dat.min = [];
	knn_dat.diff = [];
end;
%Daten für Klassifikator speichern
knn_dat.dat = dat;
knn_dat.code= code;
   
