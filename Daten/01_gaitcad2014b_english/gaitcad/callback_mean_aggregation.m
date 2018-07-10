% Script callback_mean_aggregation
%
% save the mean values based on the selected output variable into a separate
% Gait-CAD project
% 
% compute mean values and standard deviations depending on classes
%
% The script callback_mean_aggregation is part of the MATLAB toolbox Gait-CAD. 
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

[my,mstd,tmp,my_em,mstd_em]=plotmeanstd(d_orgs(ind_auswahl,:,:),code(ind_auswahl),d_org(ind_auswahl,:));

%restore class information in code_alle

%find existing codes 
codeind = findd(code);

%look if these output variables where terms are identical within all new
%datapoints (all datapoints of the mean operation must have the same output
%variable)
for i_code = 1:length(codeind)
   ind_code_i = ind_auswahl(find(code(ind_auswahl) == codeind(i_code))); 
   ind_same = find(max(abs(diff(code_alle(ind_code_i,:)))) == 0);
   code_new(i_code,ind_same) = median(code_alle(ind_code_i,ind_same));
end;
sameoutput = find(all(code_new ~=0));

%save project including single features, time series, and output variables
%with identical terms
project_name = repair_dosname([parameter.projekt.datei sprintf('_mean_%s.prjz',deblank(bez_code(par.y_choice,:)))]); 
generate_new_gaitcad_project(project_name,code_new(:,sameoutput),bez_code(sameoutput,:),zgf_y_bez(sameoutput,1:max(par.anz_ling_y(sameoutput))),my_em,dorgbez,my,var_bez,[]);
