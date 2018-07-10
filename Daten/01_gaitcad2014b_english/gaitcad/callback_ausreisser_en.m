% Script callback_ausreisser_en
%
% Callback für die Bestimmung von Ausreißern Die Parameter werden in das kp-Strukt der
% Klassifikatoren integriert:
%
% The script callback_ausreisser_en is part of the MATLAB toolbox Gait-CAD. 
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

erzeuge_parameterstrukt;

d=erzeuge_datensatz_an(d_org,klass_single(1).merkmalsextraktion);

%klass_single(1) = lp_ausreisser_detection_en(d(ind_auswahl,:), kp.ausreisser, klass_single(1));
tmp_auswahl = ind_auswahl;
if (~isempty(parameter.gui.ausreisser.manuell_entfernen))
   fprintf(1, 'Delete the following data points from the learning data set:\n');
   fprintf(1, '%d ', parameter.gui.ausreisser.manuell_entfernen); fprintf(1, '\n');
   tmp_auswahl(ismember(tmp_auswahl, parameter.gui.ausreisser.manuell_entfernen)) = [];
end;
klass_single = ausreisser_detektion_en(d(tmp_auswahl,:), kp.ausreisser, klass_single(1));

if (kp.ausreisser.verfahren == 1 && isfield(klass_single(1).ausreisser.one_class, 'exitflag') && klass_single(1).ausreisser.one_class.exitflag < 1)
   mywarning('Warning! Suboptimal result (see EXITFLAG from linprog.)');
end;
enmat = enable_menus(parameter, 'enable', 'MI_Ausreisser_An');
fprintf(1, 'Ready\n');

clear daten_orig daten;