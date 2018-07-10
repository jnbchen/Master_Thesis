  function klass_single = ausreisser_detektion_en(daten, parameter, klass_single)
% function klass_single = ausreisser_detektion_en(daten, parameter, klass_single)
%
% Entwirft Entscheidungsregeln für die Detektion von Ausreißern in Daten
% daten: Matrix mit den Daten, in denen gesucht werden soll. Dimension:
% #Datentupel x #Merkmale
% parameter: Strukt mit folgenden Parametern:
% parameter.verfahren:
% 1: one-class-Verfahren,
% 2: distanzbasiert mit Mahalanobis-Distanz,
% 3: dichtebasiert mit k-NN
% parameter.schwelle: Schwellwert für die Trennung von Ausreißer und wirklicher Klassenzugehörigkeit
% parameter.one_class: Parameter für das one-class-Verfahren, siehe lp_ausreisser_detection_en.m
% klass_single: klass_single-Strukt aus Gait-CAD (oder leer)
%
% The function ausreisser_detektion_en is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

switch(parameter.verfahren)
case 1 % one-class Klassifikatoren:
   [klass_single.ausreisser.one_class] = lp_ausreisser_detection_en(daten, parameter.one_class);
case 2 % Distanzbasiert
   [klass_single.ausreisser.distanz] = dist_ausreisser_en(daten);
case 3 % Dichtebasiert
   [klass_single.ausreisser.dichte] = dichte_ausreisser_en(daten);
end;
