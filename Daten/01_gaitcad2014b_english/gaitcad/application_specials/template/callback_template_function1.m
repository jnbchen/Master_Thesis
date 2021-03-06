% Script callback_template_function1
%
% calls a customized function
% 
% selected data points
%
% The script callback_template_function1 is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:04
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

ind_data_point = ind_auswahl;

%selected time segment
ind_time = parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende;

%indices of the selected time series
ind_selected_time_series = parameter.gui.merkmale_und_klassen.ind_zr;

%further useful variables
%
%names of the selected time series  
%var_bez(ind_selected_time_series,:)
%
%names of the selected output variable  
%bez_code(par.y_choice,:)

%calls a customized function
template_function1(d_orgs(ind_data_point,ind_time,ind_selected_time_series),var_bez(ind_selected_time_series,:),parameter)
