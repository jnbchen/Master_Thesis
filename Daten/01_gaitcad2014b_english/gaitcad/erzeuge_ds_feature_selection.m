  function [d,klass_single] = erzeuge_ds_feature_selection(d_org,code,kp)
% function [d,klass_single] = erzeuge_ds_feature_selection(d_org,code,kp)
%
% 
% 
%
% The function erzeuge_ds_feature_selection is part of the MATLAB toolbox Gait-CAD. 
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

parameter.gui.klassifikation.merk_red = size(d_org,2);
one_against_x_indx = 1;
parameter.gui.merkmale_und_klassen.ind_em = 1:size(d_org,2);
ind_auswahl = [1:size(d_org,1)]';
klass_single = kp.klass_single;

parameter.gui.klassifikation = kp.klassifikation;

%no additional feature selection 
parameter.gui.klassifikation.merkmalsauswahl = 2;


dorgbez = char(abs('x')*ones(size(d_org,2),2));

erzeuge_datensatz;