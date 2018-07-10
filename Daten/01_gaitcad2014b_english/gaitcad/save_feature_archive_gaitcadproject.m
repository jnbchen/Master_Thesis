% Script save_feature_archive_gaitcadproject
%
% save the current feature set to a separate Gait-CAD project
%
% The script save_feature_archive_gaitcadproject is part of the MATLAB toolbox Gait-CAD. 
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

if exist('merk_archiv_all','var') && iscell(merk_archiv_all)
   
   %prepare variable with feature relevances for all single features
   single_features = nan(length(merk_archiv_all{1}.merk),length(merk_archiv_all));
   single_features_names = [];
   
   %add saved archives (be careful, the names of the features are not
   %evaluated
   for i=1:length(merk_archiv_all)
      temp = merk_archiv_all{i}.merk;
      coordinated_length = max(length(temp),size(single_features,1));
      single_features(1:coordinated_length,i) = temp(1:coordinated_length);
      single_features_names = strvcatnew(single_features_names,merk_archiv_all{i}.verfahren);
   end;
   
   %prepare output variable and terms
   output_variable = [1:size(single_features,1)]';
   output_variable_names = 'Single features';
   for i=1:size(single_features,1)
      output_variable_term_names(1,i).name = kill_lz(dorgbez(i,:));
   end;
   
   %save Gait-CAD project
   generate_new_gaitcad_project ([parameter.projekt.datei '_feature_relevances.prjz'],...
      output_variable,output_variable_names,output_variable_term_names,single_features,single_features_names,[])
end;

