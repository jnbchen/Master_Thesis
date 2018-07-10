% Script callback_loeschen_doppelte_merk
%
% löscht doppelte Einzelmerkmale und Zeitreihen
% Problem: es bleiben die hinteren neuen Merkmale übrig, nicht die vorderen!
%
% The script callback_loeschen_doppelte_merk is part of the MATLAB toolbox Gait-CAD. 
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

try
   [tmp,ind_merkmale]=unique(dorgbez,'rows','last');
catch
   %for compatibility reasons with older 
   [tmp,ind_merkmale]=unique(dorgbez,'rows');
end;
ind_merkmale=setdiff(1:par.anz_einzel_merk,generate_rowvector(sort(ind_merkmale)));
callback_em_loeschen;

try
   [tmp,ind_zr]=unique(var_bez(1:size(var_bez,1)-1,:),'rows','last');
catch
   [tmp,ind_zr]=unique(var_bez(1:size(var_bez,1)-1,:),'rows');
end;
ind_zr=setdiff(1:par.anz_merk,generate_rowvector(sort(ind_zr)));
callback_zr_loeschen;

try
   [tmp,ind_ausg]=unique(bez_code(1:par.anz_y,:),'rows','last');
catch
   [tmp,ind_ausg]=unique(bez_code(1:par.anz_y,:),'rows');
end;
ind_ausg=setdiff(1:par.anz_y,generate_rowvector(sort(ind_ausg)));
callback_ausgangloeschen;
