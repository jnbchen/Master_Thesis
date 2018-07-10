  function plot_aggregation (phi_trans, name, new_figure, vek)
% function plot_aggregation (phi_trans, name, new_figure, vek)
%
% 
% 
%
% The function plot_aggregation is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

if (nargin < 3 || new_figure == 0)
   fig = figure;
end;
% vek schaltet zwischen 2D-Darstellung und eine mehrdimensionalen Darstellung um,
% bei der die Vektoreinträge untereinander geplottet werden.
if (nargin < 4)
   vek = 0;
end;

%bei 2d-Anzeige gibt es mehr als 2 Faktoren...
if (vek && size(phi_trans,2)>2)
   warning('More than 2 factors! Only the first 2 factors will be displayed');
   phi_trans=phi_trans(:,1:2);
end;

%bei 2d-Anzeige gibt es mehr als 2 Faktoren...
if (vek && size(phi_trans,2)<2)
   warning('Less than 2 factors! Switch visualization.');
   vek=0;
end;


zoom on;
if (~vek)
	plot(phi_trans, '.');
   axis([1 size(phi_trans,1) min([-1,1.05*min(phi_trans(:))]) max([1 1.05*max(phi_trans(:))])]);   
   xlabel('Features');
   ylabel(name);
   set(get(get(gcf,'children'),'children'), 'Marker','s');
   % x-Achsen-Beschriftung ändern:
   set(gca, 'XTick', [1:size(phi_trans,1)]);
else
   indx = find(~isnan(phi_trans(:,1)));
   plot(phi_trans(indx,1), phi_trans(indx,2), '.');
   str = [myResizeMat(' ', length(indx), 1) num2str(indx)];
   text(phi_trans(indx,1), phi_trans(indx,2), str);
   grid on;
   
   %mins = min([min(phi_trans(indx, 1)) min(phi_trans(indx,2))]);
   %mins = 1.05*mins;
   %maxs = max([max(phi_trans(indx, 1)) max(phi_trans(indx,2))]);
   %maxs = 1.05*maxs;
   axis([-1 1 -1 1]);
   xlabel('1st factor loading (element of 1st transformation vector)');
   ylabel('2nd factor loading (element of 2nd transformation vector)');
end;

set(gcf,'numbertitle','off','name',sprintf('%d: %s',get_figure_number(gcf), name));
title(name);

