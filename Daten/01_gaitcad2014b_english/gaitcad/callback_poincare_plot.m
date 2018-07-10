% Script callback_poincare_plot
%
% The script callback_poincare_plot is part of the MATLAB toolbox Gait-CAD. 
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

if length(ind_auswahl)*length(parameter.gui.merkmale_und_klassen.ind_zr) >20
   mywarning(sprintf('Really show Poincare plots for %d data points and %d time series?',...
      length(ind_auswahl),length(parameter.gui.merkmale_und_klassen.ind_zr),...
      length(ind_auswahl)*length(parameter.gui.merkmale_und_klassen.ind_zr)));
end;

%Connect line or not 
visumode = parameter.gui.anzeige.poincare_line+1;
visutype{1} = '.';
visutype{2} = '.-';

for i=generate_rowvector(ind_auswahl)
   for j=generate_rowvector(parameter.gui.merkmale_und_klassen.ind_zr)
      figure;
      switch mode
         case 1
            plot(squeeze(d_orgs(i,parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende-1,j)),squeeze(d_orgs(i,parameter.gui.zeitreihen.segment_start+1:parameter.gui.zeitreihen.segment_ende,j)),visutype{visumode});
            xlabel([deblank(var_bez(j,:)) '[k]']);
            ylabel([deblank(var_bez(j,:)) '[k+1]']);
            grid on;
            figurename=sprintf('%d: Poincareplot (2D) %s (DT %d)',get_figure_number(gcf),var_bez(j,:),i);            
         case 2
            plot3(d_orgs(i,parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende-2,j),...
               d_orgs(i,parameter.gui.zeitreihen.segment_start+1:parameter.gui.zeitreihen.segment_ende-1,j),...
               d_orgs(i,parameter.gui.zeitreihen.segment_start+2:parameter.gui.zeitreihen.segment_ende,j),visutype{visumode});
            xlabel([deblank(var_bez(j,:)) '[k]']);
            ylabel([deblank(var_bez(j,:)) '[k+1]']);
            zlabel([deblank(var_bez(j,:)) '[k+2]']);
            grid on;
            figurename=sprintf('%d: Poincareplot (3D) %s (DT %d)',get_figure_number(gcf),var_bez(j,:),i);            
      end;
      set(gcf,'numbertitle','off','name',kill_lz(figurename));
   end;
   
end;

clear visumode visutype