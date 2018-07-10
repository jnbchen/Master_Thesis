  function [parameter,uihd] = repair_handles(parameter,uihd)
% function [parameter,uihd] = repair_handles(parameter,uihd)
%
% 
% 
%
% The function repair_handles is part of the MATLAB toolbox Gait-CAD. 
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

fprintf('Updating Gait-CAD handles...\n');
for i_menu =1:length(parameter.gui.menu.elements)
    try
        true_hndl = gaitfindobj(parameter.gui.menu.elements(i_menu).tag);
        parameter.gui.menu.elements(i_menu).handle = true_hndl;
        temp = parameter.gui.menu.elements(i_menu).uihd_code;
        uihd(temp(1),temp(2)) = true_hndl;
    catch
        myerror('Error by reconstructing handles');
    end;
end;

for i_menu =1:length(parameter.gui.control_elements)
    try
        true_hndl = gaitfindobj(parameter.gui.control_elements(i_menu).tag);
        parameter.gui.control_elements(i_menu).handle = true_hndl;
        temp = parameter.gui.control_elements(i_menu).uihd_code;
        uihd(temp(1),temp(2)) = true_hndl;
        
        if ~isempty(parameter.gui.control_elements(i_menu).bezeichner)
            true_hndl = gaitfindobj(parameter.gui.control_elements(i_menu).bezeichner.tag);
            parameter.gui.control_elements(i_menu).bezeichner.handle = true_hndl;
            temp = parameter.gui.control_elements(i_menu).bezeichner.uihd_code;
            uihd(temp(1),temp(2)) = true_hndl;
        end;
        
    catch
        myerror('Error by reconstructing handles');
    end;
end;

%MATLAB 2012B compatibility
if isnumeric(uihd(10,:))
    for ind10 = find(uihd(10,:))
        uihd(10,ind10) = gaitfindobj(sprintf('IN_%d',ind10));
    end;
end;
if isobject(uihd(10,:))
    for ind10 = 1:size(uihd,2)
        if ~isa(uihd(10,ind10),'matlab.graphics.GraphicsPlaceholder')
            uihd(10,ind10) = gaitfindobj(sprintf('IN_%d',ind10));
        end;
    end;
end;

fprintf('Complete!\n');