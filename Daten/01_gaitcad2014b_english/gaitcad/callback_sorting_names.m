% Script callback_sorting_names
%
% sorts variable names in defined order
% (default: alphabetically, if variables ind_order and next_function_parameter not exist or empty)
% Remark: very useful for project fusion for heterogenous projects
% 
%
% The script callback_sorting_names is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(next_function_parameter)
   ind_order = next_function_parameter;
end;

if ~exist('ind_order','var') || isempty(ind_order)
   %% Deletes duplicates
   eval(gaitfindobj_callback('MI_Loeschen_doppelt'));
   
   %write names in temporary variable
   switch mode_sort
      case 1
         %Single features
         temp = string2cell(dorgbez(1:par.anz_einzel_merk,:));
      case 2
         %Time series
         temp = string2cell(var_bez(1:par.anz_merk,:));
      case 3
         %Output variables
         temp = string2cell(bez_code);
      case 4
         %Images
         temp = string2cell(d_image.names);
   end;
   
   %sort alphabetically
   [temp,ind_order] = unique(temp);
end;

%convert to new order
switch mode_sort
   case 1
      %Single features
      dorgbez = dorgbez(ind_order,:);
      d_org   = d_org(:,ind_order);
      
      %feature extraction bases on feature numbers, results become invalid!
      regr_single  = [];
      regr_plot    = [];
      klass_single = [];
            
      %delete invalid parts in aktparawin
      par.anz_einzel_merk = 0;
      
   case 2
      %Time series
      var_bez  = var_bez(ind_order,:);
      d_orgs   = d_orgs(:,:,ind_order);
      
      %feature extraction bases on feature numbers, results become invalid!
      regr_single  = [];
      regr_plot    = [];
            
      %delete invalid parts in aktparawin
      par.anz_merk =0;
      
   case 3
      %Output variables
      bez_code    = bez_code(ind_order,:);
      code_alle   = code_alle(:,ind_order);
      zgf_y_bez   = zgf_y_bez(ind_order,:);
      
      %feature extraction bases on feature numbers, results become invalid!
      klass_single = [];
            
      %delete invalid parts in aktparawin
      par.y_choice = 0;
      
   case 4
      %Images
      d_image.data     = d_image.data(:,ind_order,:,:);
      d_image.names    = d_image.names(ind_order,:);
      
end;

clear mode_sort
aktparawin;