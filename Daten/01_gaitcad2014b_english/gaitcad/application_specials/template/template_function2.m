  function template_function2(selected_single_feature,single_feature_name,output_variable,output_variable_name,parameter)
% function template_function2(selected_single_feature,single_feature_name,output_variable,output_variable_name,parameter)
%
% 
% 
% new figure
%
% The function template_function2 is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:04
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

figure;
%Gait-CAD style of figure names
set(gcf,'numbertitle','off','name',sprintf('%d: Template function 2',get_figure_number(gcf)));

%plots the first seleted single feature vs. the actual output variable,
%checkbox in the GUI turns x- and y-axis
switch parameter.gui.template.check1
    case 0
        plot(selected_single_feature(:,1),output_variable,'*');
        xlabel(single_feature_name(1,:));
        ylabel(output_variable_name);
    case 1
        plot(output_variable,selected_single_feature(:,1),'*');
        xlabel(output_variable_name);
        ylabel(single_feature_name(1,:));
end;



%