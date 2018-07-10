% Script manage_help_tag
%
% The script manage_help_tag is part of the MATLAB toolbox Gait-CAD. 
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

if parameter.gui.allgemein.kontexthilfe == 1 && parameter.allgemein.makro_ausfuehren == 0
   
   %parameter.gui.allgemein.hndl_kontext_window = msgbox(parameter.gui.menu.elements(act_help_tag).tooltext,parameter.gui.menu.elements(act_help_tag).name);
   set(gaitfindobj('CE_Menu_Text'),'string',sprintf('Menu help ''%s'':%s',parameter.gui.menu.elements(act_help_tag).name,parameter.gui.menu.elements(act_help_tag).tooltext),'HorizontalAlignment','left','FontName', 'Courier New', 'FontSize', 9);
else
   
   %help function for the supervision of automated tests
   try
      if ~isempty(strfind(pwd,'validierungsmakros'))
         filename_validation_tag = [parameter.allgemein.pfad_gaitcad filesep 'develop' filesep 'validierungsmakros' filesep 'validation_tag.mat'];
         if ~exist(filename_validation_tag,'file')
            validation_tag = zeros(length(parameter.gui.menu.elements),1);
            validation_tag_code = {parameter.gui.menu.elements.tag};
            save(filename_validation_tag,'validation_tag','validation_tag_code');
         else
            load(filename_validation_tag,'validation_tag','validation_tag_code');
         end;
         if strcmp(parameter.gui.menu.elements(act_help_tag).tag,validation_tag_code(act_help_tag))
            validation_tag(act_help_tag) = validation_tag(act_help_tag)+1;
         end;
         
         save(filename_validation_tag,'validation_tag','validation_tag_code');
      end;
   end;
end;

