% Script callback_ausgkl_einz_text
%
% The script callback_ausgkl_einz_text is part of the MATLAB toolbox Gait-CAD. 
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

for d_org_wahl = parameter.gui.merkmale_und_klassen.ind_em
   h=figure; % Erzeugung eines Bildes für pl_2d, dadurch kann Größe hier eingestellt werden
   set(h,'position',[50 150 750 530]);
   ausg_klass = parameter.gui.merkmale_und_klassen.ausgangsgroesse;
   
   % Nur als Histogramm anzeigen:
   plothist(d_org(ind_auswahl,d_org_wahl), code_alle(ind_auswahl,ausg_klass), char(sprintf('%d-%s', d_org_wahl, dorgbez(d_org_wahl,:)), bez_code(ausg_klass,:)), zgf_y_bez(ausg_klass,:), [], h, parameter.gui.anzeige);
end;
clear dat d_org_wahl ausg_klass
