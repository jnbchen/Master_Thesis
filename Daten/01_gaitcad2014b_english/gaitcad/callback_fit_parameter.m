% Script callback_fit_parameter
%
%  callback_fit_parameters
%  
%
% The script callback_fit_parameter is part of the MATLAB toolbox Gait-CAD. 
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

switch parameter.gui.regression.fit
    % 1 Parameter wird benötigt werteberech 1-8
    case {3,4,10}
        enable_controls(parameter, 'enable', 'CE_Regression_Fit_Par1');
        enable_controls(parameter, 'disable', 'CE_Regression_Fit_Par2');
        
        if parameter.gui.regression.fitpar1 < 1
            parameter.gui.regression.fitpar1 = 1;
        elseif parameter.gui.regression.fitpar1 > 8
            parameter.gui.regression.fitpar1 = 8;
        end;
    % 1 Parameter wird benötigt werteberech 1-2    
    case {2,8}
        enable_controls(parameter, 'enable', 'CE_Regression_Fit_Par1');
        enable_controls(parameter, 'disable', 'CE_Regression_Fit_Par2');
        
        if parameter.gui.regression.fitpar1 < 1
            parameter.gui.regression.fitpar1 = 1;
        elseif parameter.gui.regression.fitpar1 > 2
            parameter.gui.regression.fitpar1 = 2;
        end;
    % 1 Parameter wird benötigt werteberech 1-9    
    case 7
        enable_controls(parameter, 'enable', 'CE_Regression_Fit_Par1');
        enable_controls(parameter, 'disable', 'CE_Regression_Fit_Par2');
        
        if parameter.gui.regression.fitpar1 < 1
            parameter.gui.regression.fitpar1 = 1;
        elseif parameter.gui.regression.fitpar1 > 9
            parameter.gui.regression.fitpar1 = 9;
        end;
    % 2 Parameter werden benötigt werteberech 1-5 und 1-5    
    case 14
        enable_controls(parameter, 'enable', {'CE_Regression_Fit_Par1', 'CE_Regression_Fit_Par2'});
        
        if parameter.gui.regression.fitpar1 < 1
            parameter.gui.regression.fitpar1 = 1;
        elseif parameter.gui.regression.fitpar1 > 5
            parameter.gui.regression.fitpar1 = 5;
        end;
        
        if parameter.gui.regression.fitpar2 < 1
            parameter.gui.regression.fitpar2 = 1;
        elseif parameter.gui.regression.fitpar2 > 5
            parameter.gui.regression.fitpar2 = 5;
        end;
    % 2 Parameter werden benötigt werteberech 0-5 und 1-5     
    case 9
        enable_controls(parameter, 'enable', {'CE_Regression_Fit_Par1', 'CE_Regression_Fit_Par2'});
        
        if parameter.gui.regression.fitpar1 < 0
            parameter.gui.regression.fitpar1 = 0;
        elseif parameter.gui.regression.fitpar1 > 5
            parameter.gui.regression.fitpar1 = 5;
        end;
        
        if parameter.gui.regression.fitpar2 < 1
            parameter.gui.regression.fitpar2 = 1;
        elseif parameter.gui.regression.fitpar2 > 5
            parameter.gui.regression.fitpar2 = 5;
        end;
        
    otherwise
        enable_controls(parameter, 'disable', {'CE_Regression_Fit_Par1', 'CE_Regression_Fit_Par2'});
        
end;


inGUIIndx = {'CE_Regression_Fit_Par1','CE_Regression_Fit_Par2'}; inGUI;

% Das verändern je nach Auswahl
% parameter.gui.control_elements(ec).wertebereich = {0, 10};
