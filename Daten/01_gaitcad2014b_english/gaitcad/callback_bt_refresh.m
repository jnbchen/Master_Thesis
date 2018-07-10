% Script callback_bt_refresh
%
% The script callback_bt_refresh is part of the MATLAB toolbox Gait-CAD. 
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

clf;

%plot!
pl_2d(d_org(ind_auswahl,myselection.ind_em(get_figure_number(gcf),1:2)),code(ind_auswahl),1,parameter.gui.anzeige,[],dorgbez(myselection.ind_em(get_figure_number(gcf),1:2),:),...
   zgf_y_bez(par.y_choice,:),[],[],[],ind_auswahl);

%mark selected data points
hold on;
ind_temp = intersect(ind_auswahl,myselection.ind_selection);
if ~isempty(ind_temp)
   plot(d_org(ind_temp,myselection.ind_em(get_figure_number(gcf),1)),d_org(ind_temp,myselection.ind_em(get_figure_number(gcf),2)),'o');
end;

%standard name for figure - but without menubar
set(myselection.fig_name(get_figure_number(gcf)),'numbertitle','off','name',sprintf('%d: %s',get_figure_number(gcf),get(get(gca,'ylabel'),'string')),'menubar','none');
