  function [indx, werte] = dist_ausreisser_an(d, params, schwelle)
% function [indx, werte] = dist_ausreisser_an(d, params, schwelle)
%
% Verwendet die von dist_ausreisser_en übergebenen Werte
% und sucht in d nach Datentupeln, die zu weit von den Klassenmittelwerten
% entfernt sind. Dabei wird der Mahalanobis-Abstand verwendet.
% d ist die Datenmatrix (#Datentupel x #Merkmale)
% params das von dist_ausreisser_en zurückgegebene Strukt
% schwelle der Schwellwert des maximalen Abstands.
%
% The function dist_ausreisser_an is part of the MATLAB toolbox Gait-CAD. 
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

klassen_mw = params.klassen_mw;
klassen_icov = params.klassen_icov;

d_ohnemw = d - myResizeMat(klassen_mw, size(d,1), 1);
% und jedes Beispiel den Abstand berechnen
abst = d_ohnemw * klassen_icov;
abst = sum(abst .* d_ohnemw, 2);
indx = find(abst > schwelle);
werte = abst;