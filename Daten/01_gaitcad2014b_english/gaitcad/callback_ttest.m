% Script callback_ttest
%
% ruft callback-String für t-Test auf
%
% The script callback_ttest is part of the MATLAB toolbox Gait-CAD. 
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

switch paired 
    case {0,1,2,3}
        %paired and unpaired t-test, Wilcoxon Ranksum test, Crosstabs
        %Single Features vs. Output variable
        [tmp,ttest_val]=ttest_aut(d_org(ind_auswahl,:),code(ind_auswahl),dorgbez,bez_code(par.y_choice,:),zgf_y_bez(par.y_choice,:),parameter,uihd,paired);
    case {4}
        %Crosstabs for all output variables
        par_temp = parameter;
        for i_output = 1:par.anz_y
            fprintf('%d of %d\n',i_output,par.anz_y);
            par_temp.gui.merkmale_und_klassen.ind_em = [1:i_output-1 i_output+1:par.anz_y];
            [tmp,ttest_val_contingency{i_output}]=ttest_aut(code_alle(ind_auswahl,:),code_alle(ind_auswahl,i_output),bez_code,sprintf('y%d: %s',i_output,bez_code(i_output,:)),zgf_y_bez(i_output,:),par_temp,uihd,paired);
        end;
       clear par_temp;
       save ttest_val_contingency ttest_val_contingency
end;
clear paired;