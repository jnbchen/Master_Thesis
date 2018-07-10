  function [bez_code, zgf_y_bez, code_alle]=ausgang_kombi(bez_code, zgf_y_bez, code_alle, ind_ausg)
% function [bez_code, zgf_y_bez, code_alle]=ausgang_kombi(bez_code, zgf_y_bez, code_alle, ind_ausg)
%
% Kombiniert Ausgangsklassen mittels find_code_alle
%
% The function ausgang_kombi is part of the MATLAB toolbox Gait-CAD. 
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

bez_code=char(bez_code,kill_lz(sprintf('AND: %s ',bez_code(ind_ausg,:)')));
%neue_klass=find_code_alle(code_alle(:,ind_ausg));
[temp,temp,neue_klass]=unique(code_alle(:,ind_ausg),'rows');

code_alle=[code_alle neue_klass];
for i=generate_rowvector(findd(neue_klass)) % für neuen zusammengehängten zgf_y_bez 
   tmp_ind=find(code_alle(:,size(code_alle,2))==i); % sucht Zeile der betreffenden Ausgangsklasse 
   tmp_ind=tmp_ind(1);
   tmp_name='';
   for j=1:length(ind_ausg)
      tmp_name=sprintf('%s %s ',tmp_name, zgf_y_bez(ind_ausg(j),code_alle(tmp_ind,ind_ausg(j))).name);
   end
   zgf_y_bez(size(code_alle,2),i).name=kill_lz(tmp_name);
end 
