% Script visu_som_results
%
% The script visu_som_results is part of the MATLAB toolbox Gait-CAD. 
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

switch mode
   case 1
      %extract neuron positions
      temp = som_structure.net.IW{1};
      
      figure;
      set(gcf,'numbertitle','off','name',sprintf('%d: SOM positions and training data',get_figure_number(gcf)));
      hold on;
      grid on;
      switch size(som_plot.d,1)
         case 1
            plot(1,som_plot.d(1,:),'g.');
            plot(1,temp(:,1),'bo');
            xlabel(som_structure.inputs{1});
         case 2
            plotsompos(som_structure.net,som_plot.d);
         otherwise
            plot3(som_plot.d(1,:),som_plot.d(2,:),som_plot.d(3,:),'g.');
            plot3(temp(:,1),temp(:,2),temp(:,3),'bo');
            view(45,45);
            xlabel(som_structure.inputs{1});
            ylabel(som_structure.inputs{2});
            zlabel(som_structure.inputs{3});
      end;
   case 2
      % %plot SOM figure
      figure;
      plotsomhits(som_structure.net,som_plot.d);    
      set(gcf,'numbertitle','off','name',sprintf('%d: SOM positions and training data',get_figure_number(gcf)));
      hold on;
      grid on;      
      
      
end;