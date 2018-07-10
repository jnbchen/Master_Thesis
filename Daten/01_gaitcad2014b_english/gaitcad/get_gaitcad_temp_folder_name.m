  function m_sFolderOfTemp = get_gaitcad_temp_folder_name(parameter)
% function m_sFolderOfTemp = get_gaitcad_temp_folder_name(parameter)
%
% 
% returns the name of temp file for Gait-CAD, if the optional parameter is
% unknown (e.g. by a call from a plugin, the name is reconstructed from the
% position of the function gaitvad_gui
% 
%
% The function get_gaitcad_temp_folder_name is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

if nargin == 0
   %temporary directory - exact Gait-CAD directory must be reconstructed from
   %the which folder, but not known as a parameter
   %old solution on c:\temp can be a problem with file permissions
   m_sFolderOfTemp = [fileparts(which('gaitcad_gui')) filesep 'temp'];
else
   m_sFolderOfTemp = parameter.allgemein.pfad_temp;
end;

if ~exist(m_sFolderOfTemp,'dir')
   mkdir(m_sFolderOfTemp);
end;