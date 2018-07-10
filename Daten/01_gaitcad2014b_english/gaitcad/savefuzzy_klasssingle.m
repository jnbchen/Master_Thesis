% Script savefuzzy_klasssingle
%
% Fuzzy-Regelbasis in klass_single schreiben
% 
%
% The script savefuzzy_klasssingle is part of the MATLAB toolbox Gait-CAD. 
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

fuzzy_system.rulebase=rulebase;
fuzzy_system.zgf=zgf;
fuzzy_system.zgf_bez=zgf_bez;
fuzzy_system.zgf_all = zgf_all;
fuzzy_system.zgf_bez_all = zgf_all_bez;


if exist('relevanz','var')  
   if isfield(relevanz,'feature_aktiv') 
      fuzzy_system.merkmal_auswahl=relevanz.feature_aktiv;
   end;   
end;
fuzzy_system.par_kafka=par_rule;
fuzzy_system.par_kafka_all=par_rule_all;
fuzzy_system.anz_fuzzy=anz_fuzzy;
fuzzy_system.dorgbez_all=dorgbez_all;
fuzzy_system.dorgbez_rule=dorgbez_rule;
fuzzy_system.dorgbez_rule_nr=dorgbez_rule_nr;

     
%nur qualitative Werte? 
tmp=unique(d_fuz)';
fuzzy_system.qualitativ=0;
if (length(tmp)==2)
   if min(tmp==[0 1]) 
      fuzzy_system.qualitativ=1;
   end;
end; %if length

if ~exist('masze','var')  
   masze=[];
end;

fuzzy_system.masze=masze;
fuzzy_system.indr_merkmal=indr_merkmal;

%save evaluation from design step
fuzzy_system.design_evaluation.masze = fuzzy_system.masze;
fuzzy_system.design_evaluation.rb14  = full(fuzzy_system.rulebase(:,1:4));

fuzzy_system.inferenz=parameter_regelsuche.inferenz;

fprintf('A rulebase with %d rule(s) was saved.\n.',size(rulebase,1));

   
   


