% Script callback_show_clustergram
%
% show 2D cluster for selected single features and data points
% 
%
% The script callback_show_clustergram is part of the MATLAB toolbox Gait-CAD. 
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

d = d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em);

switch(parameter.gui.clustern.abstandsmass)
case 1
   c_dist = 'euclid';
case 2
   d = matrix_normieren(d,1);
   c_dist = 'euclid';
case 3
   c_dist = 'mahal';
otherwise
   myerror('This distance measure is not implemented in the Statistic Toolbox'); 
end;

%Fusion für Cluster
switch(parameter.gui.clustern.fusion)
case 1
   fusion = 'single';
case 2
   fusion = 'complete';
case 3
   fusion = 'average';
case 4
   fusion = 'centroid';
case 5
   fusion = 'ward';
end;

temp_cg = clustergram(d,'RowPDist', c_dist, 'Linkage', fusion);
set(temp_cg, 'RowLabels', string2cell([num2str(ind_auswahl) ones(length(ind_auswahl),1)*': ' deblank(char(zgf_y_bez(par.y_choice,code(ind_auswahl)).name))]), ...
    'ColumnLabels', string2cell(deblank(dorgbez(parameter.gui.merkmale_und_klassen.ind_em,:))));
set(gcf,'numbertitle','off');


clear temp_cg fusion c_dist;