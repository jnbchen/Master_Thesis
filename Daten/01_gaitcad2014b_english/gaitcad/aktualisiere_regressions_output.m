% Script aktualisiere_regressions_output
%
%  In Auswahlfenster für die Regression eintragen:
%
% The script aktualisiere_regressions_output is part of the MATLAB toolbox Gait-CAD. 
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

if (strcmp(parameter.gui.regression.merkmalsklassen, 'Time series (TS)') == 1)
   [el_handle, temp] = get_element_handle(parameter, 'CE_Regression_Output', 'CE');
   if (par.anz_merk == 0)
      parameter.gui.regression.merkmalsklassen = 'Single features';
      inGUIIndx = 'CE_Regression_ZREM'; inGUI;
      eval(get(el_handle, 'Callback'));
   else
      repair_popup(el_handle, poplist_popini(deblank(var_bez(1:par.anz_merk,:))), parameter.gui.regression.output, 1);
   end;
else
   [el_handle, temp] = get_element_handle(parameter, 'CE_Regression_Output', 'CE');
   if (par.anz_einzel_merk == 0)
      parameter.gui.regression.merkmalsklassen = 'Time series (TS)';
      inGUIIndx = 'CE_Regression_ZREM'; inGUI;
      eval(get(el_handle, 'Callback'));
   else
      repair_popup(el_handle, poplist_popini(deblank(dorgbez(1:par.anz_einzel_merk,:))), parameter.gui.regression.output, 1);
   end;
end;


