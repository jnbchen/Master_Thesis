  function translat9struct(fuzzy_system,parameter,mode)
% function translat9struct(fuzzy_system,parameter,mode)
%
% 
% 
% alternative (and simpler) call of translat9 using struct-based information
% be careful - restricted functionality!
% 
%
% The function translat9struct is part of the MATLAB toolbox Gait-CAD. 
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

rulebase          = fuzzy_system.rulebase;
par               = fuzzy_system.par_kafka;
datei_name        = sprintf('%s_rule_base',parameter.projekt.datei);
masze             = fuzzy_system.masze;
protokoll         = parameter.gui.anzeige.tex_protokoll; 
if mode == 1
    var_bez       = fuzzy_system.dorgbez_rule;
else 
    var_bez       = fuzzy_system.dorgbez_rule_nr;
end;

zgf_bez           = fuzzy_system.zgf_bez;
rule_detail       = [];
zgf               = [];
einheit_bez       = [];
rule_detail_et    = [];
regel_im_satz     = [];
rule_detail_cor   = [];
rule_detail_abgelehnt = [];
non_sorted        = parameter.gui.anzeige.list_sorting; 

translat9(rulebase,par,datei_name,masze,protokoll,var_bez,zgf_bez,rule_detail,zgf,einheit_bez,rule_detail_et,regel_im_satz,rule_detail_cor,rule_detail_abgelehnt,non_sorted);