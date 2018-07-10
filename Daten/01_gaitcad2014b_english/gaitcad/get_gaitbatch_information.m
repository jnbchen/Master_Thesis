% Script get_gaitbatch_information
%
% The script get_gaitbatch_information is part of the MATLAB toolbox Gait-CAD. 
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

if isfield(parameter.projekt,'datei')
   gaitbatch_state.myproject = parameter.projekt.datei;
else
   gaitbatch_state.myproject = '';
end;
if exist('gaitcad_extern','var') && isfield(gaitcad_extern,'path')
   gaitbatch_state.path = gaitcad_extern.path;
else
   gaitbatch_state.path = pwd;
end;

try
   if exist('makro_datei','var');
      if isempty(makro_datei)
         gaitbatch_state.makro_datei = '-';
      else
         [temp,gaitbatch_state.makro_datei,gaitbatch_state.extension] = fileparts(makro_datei);
         if isempty(gaitbatch_state.extension)
            gaitbatch_state.makro_datei = [gaitbatch_state.makro_datei '.makrog'];
         else
            gaitbatch_state.makro_datei = [gaitbatch_state.makro_datei extension];
         end;
      end;
   end;
catch
   gaitbatch_state.makro_datei = '-';
end;