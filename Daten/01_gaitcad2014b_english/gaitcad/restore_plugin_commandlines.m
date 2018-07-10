% Script restore_plugin_commandlines
%
% The script restore_plugin_commandlines is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(plugin_save)
   for i_plug=1:size(plugin_save.funktionsnamen,1)
      try
         plugin_name = '';
         plugin_name = plugin_save.funktionsnamen(i_plug,:);
         ind = find(ismember(plugins.mgenerierung_plugins.funktionsnamen,plugin_name,'rows'));
         
         if length(ind) == 1 && ...
               all(size(plugins.mgenerierung_plugins.info(ind).bezeichner) == size(plugin_save.info(i_plug).bezeichner)) && ... %name dimensions
               all(all(plugins.mgenerierung_plugins.info(ind).bezeichner == plugin_save.info(i_plug).bezeichner)) && ... %names
               length(plugins.mgenerierung_plugins.info(ind).commandline.parameter_commandline) == length(plugin_save.info(i_plug).commandline.parameter_commandline); %number of parameters in commandline
            
            %copy commandline values
            plugins.mgenerierung_plugins.info(ind).commandline.parameter_commandline = plugin_save.info(i_plug).commandline.parameter_commandline;
         end;
      catch
         mywarning(kill_lz(sprintf('Error in plugin %d (%s)\n',i_plug,plugin_name)));
      end;
   end;
end;
