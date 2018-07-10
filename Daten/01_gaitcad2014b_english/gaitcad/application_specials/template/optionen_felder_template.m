  function felder = optionen_felder_template
% function felder = optionen_felder_template
%
% 
% 
%
% The function optionen_felder_template is part of the MATLAB toolbox Gait-CAD. 
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

fc = 1;
felder(fc).name = 'Template';
felder(fc).subfeld = [];
felder(fc).subfeldbedingung = [];
felder(fc).visible = [];
felder(fc).in_auswahl = 1;

% BEGIN: DO NOT CHANGE THIS%PART%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Element: Optionen  
felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_Optionen';
felder(fc).visible(end).pos = [300 510];
felder(fc).visible(end).bez_pos_rel = [-280 -3];
% END: DO NOT CHANGE THIS%PART%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Element: Optionen
felder(fc).visible(end+1).i_control_elements = 'CE_Template_Check1';
%relative position in the window here: 300 points from left and 30 from the bottom 
felder(fc).visible(end).pos = [300 30];
felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_Template_Edit1';
felder(fc).visible(end).pos = [300 60];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_Template_Popup1';
felder(fc).visible(end).pos = [300 90];
felder(fc).visible(end).bez_pos_rel = [-280 -3];



