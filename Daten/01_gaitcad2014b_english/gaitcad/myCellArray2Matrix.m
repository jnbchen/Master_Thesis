  function mat = myCellArray2Matrix(cell_array)
% function mat = myCellArray2Matrix(cell_array)
%
% 
% 
% 
%
% The function myCellArray2Matrix is part of the MATLAB toolbox Gait-CAD. 
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

mat = [];

if (isempty(cell_array))
   return;
end;

% Wenn das Cell-Array nur aus einem Wert besteht, kann der einfach
% zurückgegegen werden:
if (size(cell_array,1) == 1 && size(cell_array,2) == 1)
   mat = cell_array{1};
   return;
end;
% Wenn das Cell-Array nur aus einer Spalte besteht, wird der Inhalt einfach
% untereinander gehängt
if (size(cell_array, 2) == 1)
   zeilen = size(cell_array,1);
   mat = cell(1, zeilen);
   for i = 1:zeilen
      mat{i} = [cell_array{i}]';
   end;
   mat = [mat{:}]';
else
   % Ansonsten muss etwas komplizierter kopiert werden:
   zeilen = size(cell_array,1);
   spalten = size(cell_array,2);
   mat = cell(1, zeilen);
   
   for i = 1:zeilen
      mat{i} = [cell_array{i, [1:spalten]}]';
   end;
   mat = [mat{1,[1:zeilen]}]';
end; % if (size(cell_array, 2) == 1)
