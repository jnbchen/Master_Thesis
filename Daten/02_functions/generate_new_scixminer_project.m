  function generate_new_scixminer_project(project_name,output_variable,output_variable_names,output_variable_term_names,single_features,single_features_names,time_series,time_series_names,images_struct,events_struct,additional_project_information,version_style)
% function generate_new_scixminer_project(project_name,output_variable,output_variable_names,output_variable_term_names,single_features,single_features_names,time_series,time_series_names,images_struct,event_struct,additional_project_information,version_style)
%
% 
%  function generate_new_scixminer_project(project_name,output_variable,output_variable_names,output_variable_term_names,single_features,single_features_names,time_series,time_series_names,images_struct,additional_project_information,version_style)
%  generates a new SciXMiner project from existing variables:
%  Variable name                     Dimension       Meaning  
%  project_name                      1 x ANY         String with the name of the new SciXMiner project
%  output_variable                   1 x sy          Matrix of all existing output variables, classes must be coded
%                                                    as serial integer values between 1 and my code contains a redundant
%                                                    copy for the selected output
%                                                    (value []: will be replaced by standard values)
%  output_variable_names             sy x ANY        String array containing the names of the output variables 
%                                                    (value []: will be replaced by standard values)
%  output_variable_term_names        sy x my         Term names in output_variable_term_names(i,j).name
%                                                    (value []: will be replaced by standard values)
%  single_features                   N x s           Matrix containing single features   
%                                                    (value []: will be replaced by standard values)
%  single_features_names             s x ANY         String array containing the names of the single features
%                                                    (value []: will be replaced by standard values)
%  time_series                       N x K x sz      Three-dimensional matrix coontainting time series
%                                                    (value []: will be replaced by standard values)
%  time_series_names                 sz x ANY        String array containing the names of the time series
%                                                    (value []: will be replaced by standard values)
%  images_struct                     1               Struct with special data structure for image file names, see SciXMiner documentation 
%                                                    (value []: will be replaced by standard values)
%  events_struct                     1               Struct with special data structure for time-discrete events, see SciXMiner documentation 
%                                                   (value []: will be replaced by standard values)
%  additional_project_information    1               Struct containing project related information
%  version_style                     1               File format for MAT-files (default -v7.3) 
% 
%  Dimensions
%  K       - length of time series
%  N       - number of data points (examples)
%  s       - number of single features 
%  sy      - number of output variables
%  sz      - number of time series
%  my      - maximal number of output terms (classes)
% 
%  Examples:
%  single_features = rand(20,2); var_bez = char('Variable 1','Variable 2');generate_new_scixminer_project('temp_sf.prjz',[],[],[],single_features,var_bez,[],[],[],[],'-v7.3');
%  time_series     = rand(20,100,2); var_bez = char('Time series 1','Time series 2');generate_new_scixminer_project('temp_ts.prjz',[],[],[],[],[],time_series,var_bez,[],[],'-v7.3');
% 
% 
%  The function generate_new_scixminer_project is part of the MATLAB toolbox SciXMiner. 
%  Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]
% 
%  Last file change: 10-Aug-2016 14:11:24
%  
%  This program is free software; you can redistribute it and/or modify,
%  it under the terms of the GNU General Public License as published by 
%  the Free Software Foundation; either version 2 of the License, or any later version.
%  
%  This program is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of 
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%  
%  You should have received a copy of the GNU General Public License along with this program;
%  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
%  
%  You will find further information about SciXMiner in the manual or in the following paper:
%  
%  Online available: https://sourceforge.net/projects/gait-cad/files/mikut08biosig_gaitcad.pdf/download
%  
%  Please refer to this paper, if you use SciXMiner for your scientific work.
% 
%
% The function generate_new_scixminer_project is part of the MATLAB toolbox SciXMiner. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]

if nargin<12 
    version_style = '-v7.3';
end;

N = [size(output_variable,1) size(single_features,1) size(time_series,1)];

N = N(find(N));

if length(unique(N))>1
   myerror('The number of data points must be equal!');
end;

if isempty(project_name)
   project_name = 'scixminer_project.prjz';
end;

if ~isempty(output_variable)
   code_alle = output_variable;
else
   code_alle = ones(N,1);
end;

%look for the directory and create it if it not exists
[project_name_dir,project_name_file] = fileparts(project_name);
if ~isempty(project_name_dir) && ~exist(project_name_dir,'dir')
   mkdir_gaitcad(project_name_dir);
end;    
    
save(project_name,'code_alle',version_style);

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

if exist('events_struct','var') && ~isempty(events_struct)
	d_events = events_struct;
	save(project_name,'d_events','-append');
end

if exist('additional_project_information','var') && ~isempty(additional_project_information) 
   projekt = additional_project_information;
   save(project_name,'projekt','-append');
end;

if exist('output_variable_term_names','var') && ~isempty(output_variable_term_names) 
   zgf_y_bez = output_variable_term_names;
   save(project_name,'zgf_y_bez','-append');
end;



