  function fuzzy_system=fuzzy_en(d,code,klasse,mode,dorgbez_rule,parameter_regelsuche)
% function fuzzy_system=fuzzy_en(d,code,klasse,mode,dorgbez_rule,parameter_regelsuche)
%
% entwirft ein Fuzzy-System auf Basis eines beliebigen aggregierten Merkmalsraums in d
% 
% klasse sind die Strukturinfos aus klass_single.klasse
%
% The function fuzzy_en is part of the MATLAB toolbox Gait-CAD. 
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

ind_auswahl=1:size(d,1);

%alle Merkmale werden ausgewählt
merkmal_auswahl_rule=1:size(d,2);

par_d_org=[length(ind_auswahl) size(d,2) 1 max(code)]; 

%Name Ausgangsklasse noch anhängen
dorgbez_rule=char(dorgbez_rule,klasse.bez);

%[rulebase,masze,par,dorgbez_rule,dorgbez_rule_nr,d_fuz,d_quali,yfuz,zgf,zgf_bez,indr_merkmal,temp,anz_fuzzy] =ruleaut4(d,code,dorgbez_rule,klasse.bez,klasse.zgf_bez,par_d_org,ind_auswahl,merkmal_auswahl_rule,[],3,0);

switch mode
case 'fuzzy_system' 
   mode_ruleaut=3;   
case 'dec_tree' 
   mode_ruleaut=4;
end;
     
fuzzy_system=ruleaut4(d,code,dorgbez_rule,klasse.bez,klasse.zgf_bez,par_d_org,ind_auswahl,merkmal_auswahl_rule,[],mode_ruleaut,0,parameter_regelsuche);


