% Script callback_multidimensional
%
%  Creates the makro to show the section of a function
% 
%
% The script callback_multidimensional is part of the MATLAB toolbox Gait-CAD. 
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

clear eingabe;

if isfield(kp,'gitter_start')
   eingabe.tupel_end = min(kp.gitter_start-1,size(d,1));
else
   eingabe.tupel_end = size(d,1);
end;

local_regression_plot_d       = regr_plot.d_without_norm_and_aggregation;
local_var_bez                 = regr_single.merkmalsextraktion.var_bez_without_norm_and_aggregation;

f = fopen('multiD.makrog','w');

fprintf(f,'%%*********************************************************** \n');
fprintf(f,'%% Only the parameters for a projection of the function are defined in this file.\n \n');

fprintf(f,'%% Please add the values.\n');
fprintf(f,'%% Please write a constant value or a ''x'' (in quotes) for a variable after the term ''x = ''.\n');
fprintf(f,'%% Write a constant after ''y = '' or an ''y'' (in quotation marks) for a variable. \n');
fprintf(f,'%% Close the command line with  '';''. \n');

fprintf(f,'clear eingabe;\n');

fprintf(f,'%% Features: \n');


fprintf(f,'%% x_%d %s: \n eingabe.x{%i} = ''%s'';                   %% (%s %g %s %g %s %g)',...
   regr_single.merkmalsextraktion.feature_generation.input(1),...
   deblank(local_var_bez(1,:)),1, 'x',...
   'min:', min(local_regression_plot_d(1:eingabe.tupel_end,1)),'mean', mean(local_regression_plot_d(1:eingabe.tupel_end,1)), 'max' , max(local_regression_plot_d(1:eingabe.tupel_end,1)));
fprintf(f,'\n');

if size(local_regression_plot_d,2)>1
   fprintf(f,'%% %s: \n eingabe.x{%i} = ''%s'';                   %% (%s %g %s %g %s %g)',...
      deblank(local_var_bez(2,:)),2, 'y',...
      'min:', min(local_regression_plot_d(1:eingabe.tupel_end,2)),'mean', mean(local_regression_plot_d(1:eingabe.tupel_end,2)), 'max' , max(local_regression_plot_d(1:eingabe.tupel_end,2)));
   fprintf(f,'\n');
end;

for i_d=3:size(local_regression_plot_d,2)
   fprintf(f,'%% %s: \n eingabe.x{%i}  = %g;                   %% (%s %g %s %g %s %g)',...
      deblank(local_var_bez(i_d,:)),i_d,  mean(local_regression_plot_d(1:eingabe.tupel_end,i_d)),...
      'min:', min(local_regression_plot_d(1:eingabe.tupel_end,i_d)),'mean', mean(local_regression_plot_d(1:eingabe.tupel_end,i_d)), 'max' , max(local_regression_plot_d(1:eingabe.tupel_end,i_d)));
   
   fprintf(f,'\n');
end;

fprintf(f,'%%*********************************************************** \n');
fprintf(f,'\n');
fprintf(f,'%% Do you want the show only the points near the constant? \n');
fprintf(f,'%% Please set  ''eingabe.range.true = 1'' and include the minimum and maximum value in parantheses. \n');
fprintf(f,'%% Warnung: Only values of constants will be considered.\n');
fprintf(f,'eingabe.range_true = 0; \n');

for i_range=1:size(local_regression_plot_d,2)
   fprintf(f,'%% %s: \n eingabe.range(%i,:)  = [%g %g];',...
      deblank(local_var_bez(i_range,:)), i_range, min(local_regression_plot_d(1:eingabe.tupel_end,i_range)) , max(local_regression_plot_d(1:eingabe.tupel_end,i_range)));
   
   fprintf(f,'\n');
end;
fprintf(f,'\n');
fprintf(f,'%%*********************************************************** \n');
fprintf(f,'%% Please does not change lines from here! \n');
fprintf(f,'%% values will be verified and macro will be executed\n');
fprintf(f,'execute_multid_gui_eingabe;\n');
fclose(f);
edit multiD.makrog
