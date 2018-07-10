% Script callback_association_rules
%
% 
% ignore output variables with many terms to avoid huge number of items
% parameter.gui.association_rules.ignore_numerous_output_terms = 10;
%
% The script callback_association_rules is part of the MATLAB toolbox Gait-CAD. 
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

ind_outputs = find(par.anz_ling_y<=parameter.gui.association_rules.ignore_numerous_output_terms);

association.number_of_items = sum(par.anz_ling_y(ind_outputs));

association.matrix = zeros(par.anz_dat,association.number_of_items);
association.labels = cell(association.number_of_items,1);

output_counter = 0;
for i_output = generate_rowvector(ind_outputs)
    for i_term = 1:par.anz_ling_y(i_output)
        association.labels{output_counter+i_term} = ...
            strcat(deblank(bez_code(i_output,:)),':',zgf_y_bez(i_output,i_term).name);
    end;
    
    association.matrix(:,output_counter+[1:par.anz_ling_y(i_output)]) = ...
        code_alle(:,i_output)*ones(1,par.anz_ling_y(i_output)) ...
        == (ones(par.anz_dat,1)*(1:par.anz_ling_y(i_output)));
    output_counter = output_counter + par.anz_ling_y(i_output);
    
end;

% parameter.gui.association_rules.minSup = 0.1;
% parameter.gui.association_rules.minConf = 0.7;
% parameter.gui.association_rules.nRules = 100;
% parameter.gui.association_rules.sortFlag = 1;

[association_results.Rules,association_results.FreqItemsets] = findRules(association.matrix, ...
    parameter.gui.association_rules.minSup, ...
    parameter.gui.association_rules.minConf, ...
    parameter.gui.association_rules.nRules, ...
    parameter.gui.association_rules.sortFlag, ...
    association.labels, ...
    [parameter.projekt.datei '_association']);

%show file
viewprot([parameter.projekt.datei '_association' '.txt']);
fprintf('Ready! ...\n');

