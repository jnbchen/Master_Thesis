% Script callback_bayes2c
%
% exports the recent Bayes classifier into a C file
% 
%
% The script callback_bayes2c is part of the MATLAB toolbox Gait-CAD. 
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

clear phi_last 

if klass_single.merkmalsextraktion.norm_merkmale.type~= 0 || klass_single.merkmalsextraktion.norm_aggregation.type~= 0
   myerror('C export with normalization is not implemented.')
end;


if ~isempty(klass_single.merkmalsextraktion.phi_aggregation) 
   %a feature transformation (e.g. PCA, discriminant analysis) is necessary
   %phi_last(klass_single.merkmalsextraktion.merkmal_auswahl,:) = klass_single.merkmalsextraktion.phi_aggregation
   phi_last = klass_single.merkmalsextraktion.phi_aggregation;   
else
   %only selected features 
   %phi_last(klass_single.merkmalsextraktion.merkmal_auswahl,:) = eye(length(klass_single.merkmalsextraktion.merkmal_auswahl));
   phi_last = eye(length(klass_single.merkmalsextraktion.merkmal_auswahl));
end;

temp_dorgbez = dorgbez(klass_single.merkmalsextraktion.merkmal_auswahl,:);

%export function to generate 
export_ansi_c_bayes(parameter.projekt.datei,phi_last,klass_single.bayes.kl, temp_dorgbez, klass_single.bayes.s, ...
   klass_single.bayes.s_invers, klass_single.bayes.log_s, klass_single.bayes.su, 3, 0, 0, klass_single.klasse.zgf_bez);

clear phi_last temp_dorgbez;