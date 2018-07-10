  function [mplugins] = aktualisiereMPluginInfos(mplugins, paras)
% function [mplugins] = aktualisiereMPluginInfos(mplugins, paras)
%
% Ruft alle Plug-Ins noch einmal auf, um den Plug-Ins, die Informationen
% aus der Oberfläche benötigen die Chance zu geben, die aktuellen Werte zu übernehmen
% Gibt ein aktualisiertes Strukt der Plug-Ins zurück.
%
% The function aktualisiereMPluginInfos is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

anzPlugins = size(mplugins.info,1);
for i = 1:anzPlugins
   name = deblank(mplugins.funktionsnamen(i, :));
   
   
   if isempty(mplugins.info(i).commandline)
      % Hole die Informationen
      [dummy, dummy, plugin_info] = eval([name '(paras)']);
   else
      %call plugin with the commandline parameters and do not overwrite modified commandline options
      paras.parameter_commandline = mplugins.info(i).commandline.parameter_commandline;
      [dummy, dummy, plugin_info] = eval([name '(paras)']);
      plugin_info.commandline = mplugins.info(i).commandline;
   end;
   
   [plugin_info,str] = check_plugin_info(plugin_info);
   
   mplugins.info(i) = plugin_info;
   
   %mplugins.info(i).anz_zr = plugin_info.anz_zr;
   %mplugins.info(i).anz_em = plugin_info.anz_em;
end;
