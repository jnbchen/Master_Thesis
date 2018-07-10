  function [string,info,callback]=ruleauswahl_text(fuzzy_system,mode)
% function [string,info,callback]=ruleauswahl_text(fuzzy_system,mode)
%
% mode=1 KAFKA Regelgrafik
% mode=2 KAFKA  bzw. Gait-CAD Regel löschen
% mode=3 Gait-CAD Regelgrafík
% mode=4 Regelbasis manuell zusammenstellen
% 
%
% The function ruleauswahl_text is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

info(1,:)='Rule selection';

%sonst wird sortiert!!
fuzzy_system.rulebase(:,1)=1;
fuzzy_system.rulebase=fuzzy_system.rulebase(find(max(fuzzy_system.rulebase(:,5:end)')),:);
if isempty(fuzzy_system.rulebase) 
   myerror('No rules!');
end;
tmp=translat9(fuzzy_system.rulebase,fuzzy_system.par_kafka,0,[],0,fuzzy_system.dorgbez_rule);
string(1,:)=tmp(2:length(tmp));

callback=sprintf('mode=%d;callback_ruleauswahl;',mode);
