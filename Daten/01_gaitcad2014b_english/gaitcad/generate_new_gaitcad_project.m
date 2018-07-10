  function generate_new_gaitcad_project(project_name,output_variable,output_variable_names,output_variable_term_names,single_features,single_features_names,time_series,time_series_names,images_struct,additional_project_information)
% function generate_new_gaitcad_project(project_name,output_variable,output_variable_names,output_variable_term_names,single_features,single_features_names,time_series,time_series_names,images_struct,additional_project_information)
%
% 
% function generate_new_gaitcad_project(project_name,output_variable,output_variable_names,output_variable_term_names,single_features,single_features_names,time_series,time_series_names,images_struct)
% 
% Examples:
% 
% 
% 
%
% The function generate_new_gaitcad_project is part of the MATLAB toolbox Gait-CAD. 
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

N = [size(output_variable,1) size(single_features,1) size(time_series,1)];

N = N(find(N));

if length(unique(N))>1
   myerror('The number of data points must be equal!');
end;

if isempty(project_name)
   project_name = 'gaitcad_project.prjz';
end;

if ~isempty(output_variable)
   code_alle = output_variable;
else
   code_alle = ones(N,1);
end;
save(project_name,'code_alle');

if ~isempty(output_variable_names)
   bez_code = output_variable_names;
   save(project_name,'bez_code','-append');
end;

if ~isempty(single_features)
   d_org = single_features;
   save(project_name,'d_org','-append');
end;

if exist('single_features_names','var') && ~isempty(single_features_names)
   dorgbez = single_features_names;
   save(project_name,'dorgbez','-append');
end;

if exist('time_series','var') && ~isempty(time_series)
   d_orgs = time_series;
   save(project_name,'d_orgs','-append');
end;

if exist('time_series_names','var') && ~isempty(time_series_names)
   var_bez = time_series_names;
   save(project_name,'var_bez','-append');
end;

if exist('images_struct','var') && ~isempty(images_struct) 
   d_image = images_struct;
   save(project_name,'d_image','-append');
end;

if exist('additional_project_information','var') && ~isempty(additional_project_information) 
   projekt = additional_project_information;
   save(project_name,'projekt','-append');
end;

if exist('output_variable_term_names','var') && ~isempty(output_variable_term_names) 
   zgf_y_bez = output_variable_term_names;
   save(project_name,'zgf_y_bez','-append');
end;



