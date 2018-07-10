  function [ausreisser] = ausreisser_detektion_an(daten, parameter, klass_single)
% function [ausreisser] = ausreisser_detektion_an(daten, parameter, klass_single)
%
% The function ausreisser_detektion_an is part of the MATLAB toolbox Gait-CAD. 
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
   if (parameter.schwelle > 0)
      warning('The one class methods assume a threshold < 0! The threshold will be multiplied by -1.');
      schwelle = -parameter.schwelle;
   else
      schwelle = parameter.schwelle;
   end;
   [indx, werte] = lp_ausreisser_detection_an(daten, klass_single(1).ausreisser.one_class, schwelle);
case 2 % Distanzbasiertes Verfahren
   if (parameter.schwelle < 0)
      warning('Negative distances are impossible!');
      parameter.schwelle = -parameter.schwelle;
   end;
   [indx, werte] = dist_ausreisser_an(daten, klass_single(1).ausreisser.distanz, abs(parameter.schwelle));
case 3 % Dichtebasiertes Verfahren
   [indx, werte] = dichte_ausreisser_an(daten, klass_single(1).ausreisser.dichte, parameter.dichte, parameter.schwelle);
end;

ausreisser.indx = indx;
ausreisser.werte = werte;
