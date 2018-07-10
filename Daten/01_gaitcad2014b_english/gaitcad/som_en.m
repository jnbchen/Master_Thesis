% Script som_en
%
% 
% 
% Input variables
%
% The script som_en is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

d= d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em)';

%initialize the net
clear som_structure;
som_structure.net  = selforgmap(...
    parameter.gui.klassifikation.ann.som.number_of_neurons*ones(1,parameter.gui.klassifikation.ann.som.dimension));
som_structure.net.trainParam.showWindow = parameter.gui.klassifikation.ann.showWindow;
som_structure.net.trainParam.epochs     = parameter.gui.klassifikation.ann.mlp.lernepochen;
som_structure.net  = configure(som_structure.net,d);
%save parameters
som_structure.parameters = parameter.gui.klassifikation.ann.som;

%save inputs
for i = 1:length(parameter.gui.merkmale_und_klassen.ind_em) 
    som_structure.inputs{i} = deblank(dorgbez(parameter.gui.merkmale_und_klassen.ind_em(i),:));  
end;

%save training data for visualization
som_plot.d = d;

%Train the net
som_structure.net  = train(som_structure.net,d);




