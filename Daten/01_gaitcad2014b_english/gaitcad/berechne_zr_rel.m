% Script berechne_zr_rel
%
% The script berechne_zr_rel is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('zr_rel_mode', 'var'))
   zr_rel_mode = 1;
end;

if (zr_rel_mode == 1)
   if (exist('zr_rel', 'var') && isfield(zr_rel, 'anova') 			&& ...
         all(size(zr_rel.anova.ind_auswahl) == size(ind_auswahl)) && ... 
         all(zr_rel.anova.ind_auswahl == ind_auswahl) 				&& ...
         size(zr_rel.anova.alleMerk,1) == size(d_orgs,2))
      gueteMerk = zr_rel.anova.gueteMerk;
      alleMerk = zr_rel.anova.alleMerk;
   else
      mode=1;
      plot_mode=0;
      callback_anzeige_zrmanova;
      zr_rel.anova.gueteMerk = gueteMerk;
      zr_rel.anova.alleMerk = alleMerk;
      zr_rel.anova.ind_auswahl = ind_auswahl;
   end;
else
   if (exist('zr_rel', 'var') && isfield(zr_rel, 'manova') 				&& ...
         all(size(zr_rel.manova.ind_auswahl) == size(ind_auswahl)) 	&& ...
         all(zr_rel.manova.ind_auswahl == ind_auswahl)  				   && ...
         size(zr_rel.manova.alleMerk,1) == size(d_orgs,2))
      gueteMerk = zr_rel.manova.gueteMerk;
      alleMerk = zr_rel.manova.alleMerk;
   else
      mode=2; plot_mode=0; callback_anzeige_zrmanova;
      zr_rel.manova.gueteMerk = gueteMerk;
      zr_rel.manova.alleMerk = alleMerk;
      zr_rel.manova.ind_auswahl = ind_auswahl;
   end;
end;
