  function saveprj_g_fullts(d_org, d_orgs_full,code_alle, dorgbez, var_bez, zgf_y_bez, bez_code, parameter, par,interpret_merk, L)
% function saveprj_g_fullts(d_org, d_orgs_full,code_alle, dorgbez, var_bez, zgf_y_bez, bez_code, parameter, par,interpret_merk, L)
%
% 
% 
% saveprj_g_fullts(d_org, d_orgs,code_alle, dorgbez, var_bez, zgf_y_bez, bez_code, parameter, par,interpret_merk, L)
% 
% 
%
% The function saveprj_g_fullts is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

parameter.gui.allgemein.max_save = 1E6;

if par.laenge_zeitreihe> parameter.gui.allgemein.max_save

k=1;
for i_save = 1:parameter.gui.allgemein.max_save:par.laenge_zeitreihe
   i_save_end = min(i_save+parameter.gui.allgemein.max_save-1,par.laenge_zeitreihe); 
   d_orgs = d_orgs_full(:,i_save:i_save_end,:);
   
   datei = strcat([parameter.projekt.pfad '\' parameter.projekt.datei],sprintf('_part%02d',k));
   
   save([datei '.prjz'], 'd_org', 'd_orgs', 'code_alle', 'dorgbez', 'var_bez', 'zgf_y_bez', 'bez_code', 'interpret_merk', 'L',...
      '-mat',char(parameter.gui.allgemein.liste_save_mode_matlab_version(parameter.gui.allgemein.save_mode_matlab_version)));
   k = k+1;   
end;

   delete([parameter.projekt.pfad '\' parameter.projekt.datei '.prjz']);
end;
