% Script callback_append_class_features
%
% for all selected features ...
%
% The script callback_append_class_features is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

switch mode
   %for all selected features ...
   case 1
      for i_feature = parameter.gui.merkmale_und_klassen.ind_em
         
         % five new features for each single feature number (of examples),
         % minimum, maximum, mean, median of the selected data points
         d_org(:,end +[1:5]) = zeros(size(d_org,1),5);
         
         dorgbez = strvcatnew(dorgbez(1:par.anz_einzel_merk,:),...
            sprintf('NUMB DP %s %s',kill_lz(dorgbez(i_feature,:)),kill_lz(bez_code(par.y_choice,:))),...
            sprintf('MIN DP %s %s',kill_lz(dorgbez(i_feature,:)),kill_lz(bez_code(par.y_choice,:))),...
            sprintf('MEAN DP %s %s',kill_lz(dorgbez(i_feature,:)),kill_lz(bez_code(par.y_choice,:))),...
            sprintf('MEDIAN DP %s %s',kill_lz(dorgbez(i_feature,:)),kill_lz(bez_code(par.y_choice,:))),...
            sprintf('MAX DP %s %s',kill_lz(dorgbez(i_feature,:)),kill_lz(bez_code(par.y_choice,:))));
         
         for i_code = generate_rowvector(unique(code_alle(ind_auswahl,par.y_choice)))
            
            ind_temp = ind_auswahl(find(code_alle(ind_auswahl,par.y_choice) == i_code));
            
            %handling of nans (delete nan if possible) 
            ind_temp_nonan = ind_temp(~isnan(d_org(ind_temp,i_feature))); 
            if isempty(ind_temp_nonan) 
                ind_temp_nonan =ind_temp;
            end;
            
            d_org(ind_temp,end-4) = length(ind_auswahl);
            d_org(ind_temp,end-3) = min(d_org(ind_temp_nonan,i_feature));
            d_org(ind_temp,end-2) = mean(d_org(ind_temp_nonan,i_feature));
            d_org(ind_temp,end-1) = median(d_org(ind_temp_nonan,i_feature));
            d_org(ind_temp,end)   = max(d_org(ind_temp_nonan,i_feature));
            
         end;
         
         aktparawin;
         
      end;
   case 2
      %for the selected output variable(s)
      if exist('figure_handle','var') && ~isempty(figure_handle)
         ind_ausg=get(figure_handle(2,1),'value');   % Zeilenvektor mit allen ausgewählten (zu löschenden) Ausgklassen  d_org(:,ind_merkmale)=[];',tmp);
      else
         return;         
      end;
      
          
      for i_feature = ind_ausg
         
         %values for the new output
         newcode = code;
         newcodename = sprintf('MAXFREQ DP %s %s',kill_lz(bez_code(i_feature,:)),kill_lz(bez_code(par.y_choice,:)));
         newtermname = zgf_y_bez(ind_ausg,1:par.anz_ling_y(ind_ausg));
         
         for i_code = generate_rowvector(unique(code_alle(ind_auswahl,par.y_choice)))
            
            %look for all data points belonging to one class
            ind_temp = ind_auswahl(find(code_alle(ind_auswahl,par.y_choice) == i_code));
            %lokk for the term histograms
            termhist = hist(code_alle(ind_temp,i_feature),1:par.anz_ling_y(ind_ausg));
            %use the most ferquent term
            [temp,most_frequent_term] = max(termhist);
            newcode(ind_temp)   = most_frequent_term;            
         end;
         
         [code_alle,zgf_y_bez,bez_code,L]=new_output(code_alle,zgf_y_bez,bez_code,L,newcode,newcodename,newtermname);
         aktparawin;
         
      end;
end;

clear ind_temp mode i_feature;