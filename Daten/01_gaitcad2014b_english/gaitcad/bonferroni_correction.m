  function [p_krit_bonf,prottext] = bonferroni_correction(b,parameter,number_of_tests,symmetric_test_type)
% function [p_krit_bonf,prottext] = bonferroni_correction(b,parameter,number_of_tests,symmetric_test_type)
%
% 
% 
% performs a Bonferroni (parameter.gui.statistikoptionen.bonferroni = 2) or Bonferroni-Holm correction (parameter.gui.statistikoptionen.bonferroni = 3) for p-values in matrix b
% if number_of_tests idependent tests were performed
% if symmetric_test_type == 1, a symmetric b matrix is assumed and the
% coocuurence of equal p-values values is compensated
% It returns in p_krit_bonf the critical alpha values for each element in b
% 
% 
%
% The function bonferroni_correction is part of the MATLAB toolbox Gait-CAD. 
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

switch parameter.gui.statistikoptionen.bonferroni
    case 1
        %without Bonferroni correction
        prottext = sprintf('\nwithout Bonferroni correction');
        p_krit_bonf = parameter.gui.statistikoptionen.p_krit * ones(size(b));
    case 2
        %without Bonferroni correction, divide by the number of tests
        p_krit_bonf = parameter.gui.statistikoptionen.p_krit * ones(size(b))/number_of_tests;
        prottext = sprintf('\nBonferroni-corrected values, alpha_crit_1 = %g',...
            parameter.gui.statistikoptionen.p_krit/number_of_tests);
    case 3
        %without Bonferroni-Holm correction, divide by the number of tests
        %for the best value, number of tests - 1 for the second,number of tests - 2 for the third, etc.
        [tempa,tempb] = sort(b(:));
        p_krit_bonf = parameter.gui.statistikoptionen.p_krit * ones(size(b));
        prottext = sprintf('\nBonferroni-Holm-corrected values, alpha_crit_1 = %g',...
            parameter.gui.statistikoptionen.p_krit/number_of_tests);
        
        
        ranking_matrix = ones(size(b));
        
        switch symmetric_test_type
            case 1
                %correct the test pairs, matrix is only a upper or lower diagonal one
                ranking_matrix(tempb) = ceil([1:length(tempb)]/2);
                if parameter.gui.anzeige.show_corr_selected == 1
                    last_valid_value      = min(find(tempa(1:number_of_tests) > (parameter.gui.statistikoptionen.p_krit./[number_of_tests:-1:1])'))-1;
                else
                    last_valid_value      = min(find(tempa(1:2:2*number_of_tests) > (parameter.gui.statistikoptionen.p_krit./[number_of_tests:-1:1])'))-1;
                    
                end;
            case 0
                %ranking
                ranking_matrix(tempb) = 1:length(tempb);
                last_valid_value      = min(find(tempa(1:number_of_tests) > (parameter.gui.statistikoptionen.p_krit./[number_of_tests:-1:1])'))-1;
                
        end;
        
        %implementation trick:
        %1. sort all p_values in increasing order
        %2. test with a_krit/(number_of_tests - sorting_order + 1)
        %3. stop all following tests if the first test in 2. is not valid
        %   (last_valid_value+1)
        if ~isempty(last_valid_value)
            ranking_matrix = min(ranking_matrix,last_valid_value);
        end;
        
        
        p_krit_bonf = parameter.gui.statistikoptionen.p_krit./max(1,(number_of_tests+1-ranking_matrix));
end;
