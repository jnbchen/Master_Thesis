  function [ausreisser, f] = lp_ausreisser_detection_an(daten, lp_detect, schwelle)
% function [ausreisser, f] = lp_ausreisser_detection_an(daten, lp_detect, schwelle)
%
%  Sucht mit Hilfe einer Art SVM-Optimierung nach Ausreißern innerhalb
%  eines Datensatzes.
%  Für den Algorithmus siehe Campbell 2000, "A Linear Programming Approach
%  to Novelty Detection", Proc. Neural Information Processing Systems Conference
% 
%  Berechnet f(z) = sum_i( a_i * K(z, x_i) + b) auf den übergebenen Daten,
%  die x_i sind die Lerndaten.
% 
%  Eingaben:
%  daten: Datenmatrix, in der nach Ausreißern gesucht werden soll.
%  Dimension #Beispiele x #Merkmale. Es muss gelten:
%  size(daten,2) == size(lp_detect.lerndaten,2)
%  lp_detect: Durch die Funktion lp_ausreisser_detection_en zurückgegebenes Strukt
%  schwelle: Ausreißer sind definiert durch f(z) < schwelle, mit schwelle <= 0 (default: 0)
% 
%  Ausgaben:
%  ausreisser: Indizes mit f(ausreisser) < schwelle
%  f: Ergebnis von f(z) = sum_i( a_i * K(z, x_i) + b)
% 
%
% The function lp_ausreisser_detection_an is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 2)
   error('Too few parameters!');
end;
if (nargin < 3)
   schwelle = 0;
end;
if ~isfield(lp_detect,'lerndaten')
   mywarning('Error in outlier detection: No training data found!');
   ausreisser =[];
   f=[];
   return;
end;
if (size(daten,2) ~= size(lp_detect.lerndaten,2))
   mywarning('Unequal number of features in data and training data');
   return;
end;

% Daten normieren:
daten = matrix_normieren(daten, lp_detect.normierung.typ, lp_detect.normierung.par1, lp_detect.normierung.par2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erst einmal die Kernel-Matrix zusammenbauen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = berechne_kernel_matrix(daten, lp_detect.lerndaten, lp_detect.kernel, lp_detect.kernel_parameter);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Koeffizienten in Abbildung einsetzen
f = K * lp_detect.a + myResizeMat(length(lp_detect.a)*lp_detect.b, size(K,1), 1);
ausreisser = find(f < schwelle);