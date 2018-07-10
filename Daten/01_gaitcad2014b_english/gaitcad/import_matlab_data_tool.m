% Script import_matlab_data_tool
%
% Element 1: File or directory name
%
% The script import_matlab_data_tool is part of the MATLAB toolbox Gait-CAD. 
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

if ~exist('next_function_parameter','var') || isempty(next_function_parameter)
   [filename_import,mypath] = uigetfile('*.*','Load data file');
   if isempty(filename_import) || all(filename_import == 0)
      return;
   end;
   cd(mypath);
   clear mypath
else
   filename_import = next_function_parameter;
   next_function_parameter = '';  
end;


imported_data = uiimport(filename_import);

d_org        = imported_data.data;
code_alle    = ones(size(d_org,1),1);
bez_code = [];
zgf_y_bez = [];

%extract variable names
if isfield(imported_data,'colheaders')
   dorgbez = char(imported_data.colheaders);
else
   fprintf('No names for single features found!\n');
   dorgbez = [];
end;

%extract output variables and term  names - if we get columns with text
if isfield(imported_data,'textdata') && size(imported_data.textdata,1) == size(d_org,1)+1
   bez_code = char(imported_data.textdata{1,:});
   imported_data.textdata(1,:) = [];
   
   for i_output = 1:size(imported_data.textdata,2)
      [temp_name,temp,code_alle(:,i_output)] = unique(imported_data.textdata(:,i_output));
      for i_name = 1:size(temp_name,1)
         zgf_y_bez(i_output,i_name).name = char(temp_name(i_name,:));
      end;
   end;
   
else
   fprintf('No output variables found!\n');
end;


save('imported_data.prjz','-mat','d_org','code_alle','dorgbez','bez_code','zgf_y_bez');
next_function_parameter = 'imported_data.prjz';
ldprj_g;