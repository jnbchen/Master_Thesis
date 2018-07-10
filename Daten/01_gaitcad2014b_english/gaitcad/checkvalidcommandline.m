  function [mycommandline] = checkvalidcommandline(plugins,parameter)
% function [mycommandline] = checkvalidcommandline(plugins,parameter)
%
% 
% 
% empty return value: no valid commandline found
%
% The function checkvalidcommandline is part of the MATLAB toolbox Gait-CAD. 
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

mycommandline = {};

%check for existence of a valid sequence and a related commandline
switch plugins.sequence_field
   case 0
      %check for existence of a valid sequence and a related commandline
      %step-wise check to avoid version compatibility problems with | and ||
      %for nonexisting fields
      if length(plugins.ind_listbox)~=1 || plugins.ind_listbox == 0
         return;
      end;
      
      if  isempty(plugins.mgenerierung_plugins.info(plugins.ind_listbox(1)).commandline) || ...
            isempty(plugins.mgenerierung_plugins.info(plugins.ind_listbox(1)).commandline.description)
         return;
      else
         mycommandline   = plugins.mgenerierung_plugins.info(plugins.ind_listbox(1)).commandline;
      end;
      
   case 1
      %check for existence of a valid sequence and a related commandline
      %step-wise check to avoid version compatibility problems with | and ||
      %for nonexisting fields
      if length(plugins.mgenerierung_plugins.sequence.pos)~=1 || plugins.mgenerierung_plugins.sequence.pos==0
         return;
      end;
      if ~isfield(plugins.mgenerierung_plugins.sequence,'command_line') || isempty(plugins.mgenerierung_plugins.sequence.command_line)
         return;
      end;
      if isempty(plugins.mgenerierung_plugins.sequence.command_line{plugins.mgenerierung_plugins.sequence.pos(1)}) || ...
            isempty(plugins.mgenerierung_plugins.sequence.command_line{plugins.mgenerierung_plugins.sequence.pos(1)}.description)
         return;
      else
         mycommandline   = plugins.mgenerierung_plugins.sequence.command_line{plugins.mgenerierung_plugins.sequence.pos(1)};
      end;
end;

