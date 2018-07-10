  function template_function1(selected_time_series,selected_time_series_names,parameter)
% function template_function1(selected_time_series,selected_time_series_names,parameter)
%
% 
% 
% plots the first data point of the first seleted time series, color is tuned by the popup element
% of the template package in the GUI
% 
% new figure
%
% The function template_function1 is part of the MATLAB toolbox Gait-CAD. 
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
set(gcf,'numbertitle','off','name',sprintf('%d: Template function 1',get_figure_number(gcf)));

%plots the first data point of the first seleted time series, color is tuned by the popup element
%of the template package in the GUI 
switch parameter.gui.template.popup1
    case 1
        plot(selected_time_series(1,:,1),'r');
    case 2
        plot(selected_time_series(1,:,1),'g');
    case 3
        plot(selected_time_series(1,:,1),'b');
end;

%axis label
ylabel(selected_time_series_names(1,:));
