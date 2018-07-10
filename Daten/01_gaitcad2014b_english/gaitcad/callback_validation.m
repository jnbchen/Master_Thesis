% Script callback_validation
%
% Add the user-specific macros (if necessary)
%
% The script callback_validation is part of the MATLAB toolbox Gait-CAD. 
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

if mode_eigene_makros == 0
   switch cvmakro_mode
      case 0
         %classification of single features
         makro_lern='em_klassi_en.makrog';
         makro_test='em_klassi_an.makrog';

      case 1
         %classification of time series
         makro_lern='zr_klassi_en.makrog';
         makro_test='zr_klassi_an.makrog';
      case 2
         %regression of single features
         makro_lern='regr_em_en.makrog';
         makro_test='regr_em_an.makrog';
         
         case 3
         %regression of single features
         makro_lern='regr_em_hierarchical_en.makrog';
         makro_test='regr_em_hierarchical_an.makrog';
   end;
end;

%function for macro-based validation
[konf,relevanz_cv_alle,makro_lern,makro_test] = cvmakro (uihd, enmat, d_org, [], [], code, code_alle, ...
   zgf_y_bez, [], [], bez_code, par, datei, [], zgf_bez, var_bez, merkmal_auswahl, [], [], ...
   interpret_merk, interpret_merk_rett, [], L, makro_lern, makro_test, 0, d_orgs, plugins, ...
   dorgbez, parameter, ref, ind_auswahl,cvmakro_mode);

%clean up
clear mode_eigene_makros cv_makro_mode
makro_lern=[];
makro_test=[];

aktparawin;