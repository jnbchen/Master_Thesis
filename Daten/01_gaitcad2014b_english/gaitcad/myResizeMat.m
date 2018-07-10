  function new_mat = myResizeMat(mat, c_zeilen, c_spalten)
% function new_mat = myResizeMat(mat, c_zeilen, c_spalten)
%
% 
%  Kopiert eine Matrix oder einen Vektor mat, zeilen-mal
%  untereinander  und spalten-mal nebeneinander.
% 
%
% The function myResizeMat is part of the MATLAB toolbox Gait-CAD. 
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

if(nargin < 2)
   c_zeilen = 1;
end;
if (nargin < 3)
   c_spalten = 1;
end;

[zeilen, spalten] = size(mat);
% Erzeuge die Zeilenindizes
indx_zeilen  = rem([0:(zeilen  * c_zeilen  - 1)],  zeilen) + 1;
% Erzeuge die Spaltenindizes
indx_spalten = rem([0:(spalten * c_spalten - 1)], spalten) + 1;
new_mat = mat(indx_zeilen, indx_spalten);