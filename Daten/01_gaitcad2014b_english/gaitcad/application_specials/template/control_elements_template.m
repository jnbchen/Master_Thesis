  function els = control_elements_template(parameter)
% function els = control_elements_template(parameter)
%
% 
% function els = control_elements_template
% defines all control elements (checkboxes, listboxes, edit boxes for the package)
% the visualization is done later by optionen_felder_package
% 
% 
%
% The function control_elements_template is part of the MATLAB toolbox Gait-CAD. 
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

els = [];

%number of the handle - added as the last column for the handle matrix 
newcolumn = parameter.allgemein.uihd_column;

%%%%%%%%%%%%%%%%%%%%%%%
% Template for the first control element (here: a checkbox)
ec = 1; 
%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_Template_Check1';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Element_Check1';
%example for a checkbox
els(ec).style = 'checkbox';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.template.check1';
%default value at the start
els(ec).default = 0;
%help text in the context menu
els(ec).tooltext = 'Help text for check 1';
%callback for any action at the element, can be empty
%the function should be exist tn the path of the template package
els(ec).callback = 'callback_template_check1;';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text, not neceessary for
%checkboxes
els(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% Template for the second control element (here: a edit field for numbers)
ec = ec+1; 
%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_Template_Edit1';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Element_Edit1';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.template.element_1';
%default value at the start
els(ec).default = 5;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 1;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {1, Inf};
%help text in the context menu
els(ec).tooltext = 'Help text for edit 1';
%callback for any action at the element, can be empty
%the function should be exist in the path of the template package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% Template for the third control element (here: a popup field)
ec = ec+1; 
%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_Template_Popup1';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Element_Popup1';
%example for a checkbox
els(ec).style = 'popupmenu';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.template.popup1';
%default value at the start
els(ec).default = 3;
%defines the entries of the popup
els(ec).listen_werte = 'Option A (red)|Option B (green)|Option C (blue)';
%help text in the context menu
els(ec).tooltext = 'Help text for popup 1';
%callback for any action at the element, can be empty
%the function should be exist tn the path of the template package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 250;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;




