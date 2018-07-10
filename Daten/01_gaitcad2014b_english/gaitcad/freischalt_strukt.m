  function strukt = freischalt_strukt(parameter)
% function strukt = freischalt_strukt(parameter)
%
% 
% 
%
% The function freischalt_strukt is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 1)
   strukt = [];
   return;
end;


% Erst einmal alle zusammenfassen
tmp = {parameter.gui.menu.elements.freischalt};

% In eine neue Matrix kopieren. Hier ist wichtig, dass der Zusammenhang
% zwischen Menüelement und Bedingungen nicht verlorengeht.
% Schneller wäre myCellArray2Matrix zu verwenden, aber dann geht genau
% dieser Zusammenhang verloren
bedingungen.indx = [];
bedingungen.bedingung = {};
for i = 1:length(tmp)
   if (~iscell(tmp))
      tmp = {tmp};
   end;
   for j = 1:length(tmp{i})
      bedingungen.indx(end+1) = i;
      bedingungen.bedingung(end+1).string = char(tmp{i}(j));
   end;
end;

% Nun die einheitlichen raussuchen
[B, I, J] = unique({bedingungen.bedingung.string});
% Nun soll der ganze Kram andersherum gespeichert werden.
% Zu jeder Bedingung werden die betroffenen Einträge gesichert.
for i = 1:length(B)
   strukt(i).bedingung = deblank(char(B(i)));
   tmp = find(J == i);
   strukt(i).elemente  = bedingungen.indx(tmp)';
end;
