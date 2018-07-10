  function fuzzy_system = call_relemas3(fuzzy_system,d,code,parameter_regelsuche,L)
% function fuzzy_system = call_relemas3(fuzzy_system,d,code,parameter_regelsuche,L)
%
% 
% alternative call of rule evaluation using parameter struct
% 
% 
% fuzzification of inputs 
%
% The function call_relemas3 is part of the MATLAB toolbox Gait-CAD. 
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

[d_fuz,u] = fuzz(d(:,fuzzy_system.indr_merkmal),fuzzy_system.zgf(:,1:fuzzy_system.anz_fuzzy));

%fuzzification of outputs for classification
yfuz      = fuzz(code,1:max(code));

%evaluations 
[rele,concl,masze,aktiv]=relemas3(fuzzy_system.rulebase,yfuz,d_fuz,fuzzy_system.par_kafka,parameter_regelsuche.faktor,parameter_regelsuche.typ_regelmatrix,...
    0,parameter_regelsuche.stat_absich,0,[],L,parameter_regelsuche.schaetzung_einzelregel);

%examples and errors
fuzzy_system.rulebase(:,1:3)=[rele aktiv];

%set relevance of statistically non-significant rules to zero
ind_non_significant = find(masze(:,3) == 0);
if ~isempty(ind_non_significant)
   fuzzy_system.rulebase(ind_non_significant,1) = 0; 
end;

%rule evaluation
fuzzy_system.masze           = masze;

%avoid zero evaluation 
ind_zero = find(fuzzy_system.rulebase(:,1)==0);
if ~isempty(ind_zero)
    fuzzy_system.rulebase(ind_zero,1) = fuzzy_system.rulebase(ind_zero,1)+1E-6;
end;