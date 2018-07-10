% Script protokoll_cv_class_dist_cv
%
% protocol file for class-wise crossvalidation and a variety of distance
% measures (uses cvmnakro)
% 
%
% The script protokoll_cv_class_dist_cv is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

if exist('relevanz_cv_alle','var') && isfield(relevanz_cv_alle,'regr_dist_eval')
   
   %Protocol file
   if parameter.gui.anzeige.tex_protokoll == 0
      myfilename = [parameter.projekt.datei '_cv_dist_eval_' deblank(bez_code(parameter.gui.validierung.cvoutputselect,:)) '.txt'];
   else
      myfilename = [parameter.projekt.datei '_cv_dist_eval_' deblank(bez_code(parameter.gui.validierung.cvoutputselect,:)) '.tex'];
   end;
   f_dist = fopen(myfilename,'wt');
   
   table_kopf = sprintf('Linguistic term\t Median regression error\t Median distance \tNumber of near neighbors\t Interpolation indicator');
   
   for i_feat = 1:size(regr_single.merkmalsextraktion.var_bez,1)
      table_kopf = strcat(table_kopf,sprintf('\t Median distance %s\t Number of near neighbors %s',...
         deblank(regr_single.merkmalsextraktion.var_bez(i_feat,:)),...
         deblank(regr_single.merkmalsextraktion.var_bez(i_feat,:))));
   end;
   table_kopf = [table_kopf sprintf('\n')];
   
   if parameter.gui.anzeige.tex_protokoll == 0
      fprintf(f_dist,table_kopf);
   end;
   
   table_text ='';
   
   for i_classes = 1:size(relevanz_cv_alle.regr_dist_eval,2)
      temp_string = sprintf('%s \t %2g \t %2g \t %1g \t %2g',zgf_y_bez(parameter.gui.validierung.cvoutputselect,relevanz_cv_alle.active_output_terms(i_classes)).name, ...
         relevanz_cv_alle.regr_dist_eval(1,i_classes).median_error, ...
         relevanz_cv_alle.regr_dist_eval(1,i_classes).mydist, ...
         relevanz_cv_alle.regr_dist_eval(1,i_classes).number_of_near_neighbors, ...
         relevanz_cv_alle.regr_dist_eval(1,i_classes).total_interpolation_indicator);
      if parameter.gui.anzeige.german_decimal_numbers ==1
         %correct German Excel format if necessary
         temp_string = strrep(temp_string,'.',',');
      end;
      
      for i_feat = 1:size(regr_single.merkmalsextraktion.var_bez,1)
         temp_string = strcat(temp_string,sprintf('\t %2g\t %1g',...
            relevanz_cv_alle.regr_dist_eval(1,i_classes).mydist_feat(i_feat), ...
            relevanz_cv_alle.regr_dist_eval(1,i_classes).number_of_near_neighbors_feat(i_feat)));
         if parameter.gui.anzeige.german_decimal_numbers ==1
            %correct German Excel format if necessary
            temp_string = strrep(temp_string,'.',',');
         end;         
      end;
               
      if parameter.gui.anzeige.tex_protokoll == 0
         fprintf(f_dist,'%s\n',temp_string);
      else
         table_text = [table_text temp_string sprintf('\n')];
      end; 
      
   end;
   
   
end;

if parameter.gui.anzeige.tex_protokoll == 1
   textable(strrep(table_kopf,sprintf('\t'),'&'),strrep(table_text,sprintf('\t'),'&'),'Validation measures',f_dist,0);
end;
fclose(f_dist);
