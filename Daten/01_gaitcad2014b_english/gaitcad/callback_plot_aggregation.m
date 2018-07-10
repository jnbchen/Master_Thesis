% Script callback_plot_aggregation
%
% The script callback_plot_aggregation is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('klass_single', 'var') || ~isfield(klass_single(1), 'merkmalsextraktion') || ...
      isempty(klass_single(1).merkmalsextraktion) || ~isfield(klass_single(1).merkmalsextraktion, 'phi_aggregation') || ...
      isempty(klass_single(1).merkmalsextraktion.phi_aggregation))
   fprintf(1, 'No information about aggregated features found\n');
   return;
end;

plot_trans = NaN*ones(size(d_org,2), size(klass_single(1).merkmalsextraktion.phi_aggregation,2));
plot_trans(klass_single(1).merkmalsextraktion.merkmal_auswahl, :) = klass_single(1).merkmalsextraktion.phi_aggregation;

title = klass_single(1).merkmalsextraktion.phi_text;
plot_aggregation(plot_trans, title, parameter.gui.anzeige.aktuelle_figure, mode-1);
clear plot_trans title;