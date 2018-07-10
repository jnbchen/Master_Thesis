% Script callback_showmydatdist
%
% The script callback_showmydatdist is part of the MATLAB toolbox Gait-CAD. 
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

switch mode 
case 1
   %matrix of distances (for the selected data points!!!!)
   figure;
   imagesc(mydist.dat_dist);
   
   set(gca,'xtick',1:length(mydist.ind_auswahl));
   set(gca,'xticklabel',num2str(mydist.ind_auswahl));
   set(gca,'ytick',1:length(mydist.ind_dist));
   set(gca,'yticklabel',num2str(mydist.ind_dist));
   
   cmap = erzeugeColormap(parameter.gui.zeitreihen.colormap);
   xlabel('Data points');
   ylabel('Data points');
   colormap(cmap);
   colorbar; 
   clear cmap;
   
   figurename=sprintf('%d: Pair-wise distances',get_figure_number(gcf));
   set(gcf,'numbertitle','off','name',kill_lz(figurename));
   
case 2
   figure;
   plot(mydist.ind_auswahl,mydist.dat_dist,'.');  
   figurename=sprintf('%d: Pair-wise distances  (vector)',get_figure_number(gcf));
   set(gcf,'numbertitle','off','name',kill_lz(figurename));   
   
case 3
   fprintf('List of next neighbors:\n');
   for i=1:parameter.gui.klassifikation.knn.k 
      fprintf('%5.3f %6d %s\n',mydist.list_neighbor{1}.dist(i),mydist.ind_auswahl(mydist.list_neighbor{1}.ind(i)),zgf_y_bez(par.y_choice,code(mydist.ind_auswahl(mydist.list_neighbor{1}.ind(i)))).name);
   end;
end;




