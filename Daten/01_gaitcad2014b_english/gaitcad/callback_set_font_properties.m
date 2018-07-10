  function callback_set_font_properties(parameter_allgemein)
% function callback_set_font_properties(parameter_allgemein)
%
% 
% function callback_set_font_properties(parameter.gui.allgemein)
% 
% get all axis objects
%
% The function callback_set_font_properties is part of the MATLAB toolbox Gait-CAD. 
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

list_of_axes_objects = findobj('type','axes');

if ~isfield(parameter_allgemein,'standard_font')
    parameter_allgemein.standard_font = 'Helvetica';
end;

if ~isfield(parameter_allgemein,'standard_size')
    parameter_allgemein.standard_size = 10;
end;

for i_list = 1:length(list_of_axes_objects)
    
    %original axis objets
    set(list_of_axes_objects(i_list),'FontName',parameter_allgemein.standard_font);
    set(list_of_axes_objects(i_list),'FontSize',parameter_allgemein.standard_size);
    
    %x,y,z labels and axes ticks
    set(get(list_of_axes_objects(i_list),'XLabel'),'FontName',parameter_allgemein.standard_font);
    set(get(list_of_axes_objects(i_list),'XLabel'),'FontSize',parameter_allgemein.standard_size);
    set(get(list_of_axes_objects(i_list),'YLabel'),'FontName',parameter_allgemein.standard_font);
    set(get(list_of_axes_objects(i_list),'YLabel'),'FontSize',parameter_allgemein.standard_size);
    set(get(list_of_axes_objects(i_list),'ZLabel'),'FontName',parameter_allgemein.standard_font);
    set(get(list_of_axes_objects(i_list),'ZLabel'),'FontSize',parameter_allgemein.standard_size);
end;