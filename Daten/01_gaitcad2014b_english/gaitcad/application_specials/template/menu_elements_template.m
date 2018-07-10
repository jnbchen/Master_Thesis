  function elements = menu_elements_template(parameter)
% function elements = menu_elements_template(parameter)
%
% 
% 
%  defines the menu items for the extension package Template
% 
%  Function menu_elements_template is part of the extension package Template
%  Copyright (C) 200x  [Template Author Name]
%  This package was integrated in the MATLAB Toolbox Gait-CAD
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister].
% 
%  This program is free software; you can redistribute it and/or modify,
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation; either version 2 of the License, or any later version.
% 
%  This program is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License along with this program;
%  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
% add the new entry at a new column of the handle list
%
% The function menu_elements_template is part of the MATLAB toolbox Gait-CAD. 
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

newcolumn = parameter.allgemein.uihd_column;
mc = 1;

%main element in the menu
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
%the tag must be unique
elements(mc).tag = 'MI_Template';
%name in the menu
elements(mc).name = 'Template';
%list of the functions in the menu, -1 is a separator
elements(mc).menu_items = {'MI_Template_Function1',-1,'MI_Template_Function2'};
%is always enabled if a project exists
%further useful option: elements(mc).freischalt = {'1'}; %is always enabled
elements(mc).freischalt = {'~isempty(par)'}; 

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Template_Function 1';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_template_function1;';
elements(mc).tag = 'MI_Template_Function1';
%is enabled if at least one time series exist
elements(mc).freischalt = {'~isempty(par) && par.anz_merk > 0'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Template_Function 2';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_template_function2;';
elements(mc).tag = 'MI_Template_Function2';
%is enabled if at least one single feature exist
elements(mc).freischalt = {'~isempty(par) && par.anz_einzel_merk > 0'};

