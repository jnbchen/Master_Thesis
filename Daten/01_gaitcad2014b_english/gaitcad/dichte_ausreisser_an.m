  function [indx, werte] = dichte_ausreisser_an(d, knn_dat, parameter, schwelle)
% function [indx, werte] = dichte_ausreisser_an(d, knn_dat, parameter, schwelle)
%
% The function dichte_ausreisser_an is part of the MATLAB toolbox Gait-CAD. 
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

knn_param.normieren = 1;
knn_param.metrik = 'euclid';
knn_param.region = [];
knn_param.wichtung = 0;

% Maximalen Abstand und Anzahl Nachbarn aus den gewählten Parametern übernehmen
knn_param.max_abstand = parameter.max_abstand;
% Gleitkommazahlen sind nicht erlaubt!
if (rem(schwelle, 1) ~= 0)
   warning('The threshold must be an integer value. Rounding threshold...!');
   schwelle = round(schwelle);
end;
% Die Schwelle gibt an, wie viele Nachbarn innerhalb eines Radius enthalten sein müssen.
% Daher darf die Gesamtzahl an betrachteten Nachbarn mit der Schwelle übereinstimmen.
knn_param.k = schwelle;
% Weniger als 1 Nachbar macht keinen Sinn. Erst recht keine negativen Zahlen!
if (knn_param.k < 1)
   warning('At least one neighbor was expected in the environment. Set threshold to 1!');
   knn_param.k = 1;
end;
knn_param.max_abstand_anz = schwelle;

% k-NN Anwenden:
[pos, md, prz] = knn_an(d, knn_param, knn_dat);

% Die Datentupel mit isnan(pos) sind Ausreißer
indx = find(isnan(pos));
% Die Werte sind die Anzahl an Nachbarn, die innerhalb einer Region liegen.
% Sind es zu wenig, wird die Entscheidung zurückgewiesen.
werte = schwelle*ones(size(pos,1),1);
werte(indx) = prz(indx);
