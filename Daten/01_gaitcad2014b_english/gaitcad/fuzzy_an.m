  function [pos,md,prz]=fuzzy_an(d,fuzzy_system)
% function [pos,md,prz]=fuzzy_an(d,fuzzy_system)
%
%  wendet ein Fuzzy-System (steht üblicherweise in klass_single.fuzzy) auf Daten in d an
% 
%  Fuzzifizieren - über alle, nicht nur über ausgewählte Beispiele
% 
%
% The function fuzzy_an is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(fuzzy_system) || ~isfield(fuzzy_system,'zgf')
   pos=[];
   md=[];
   prz=[];
   return;
end;

[d_fuz,d_quali]=fuzz(d(:,fuzzy_system.indr_merkmal),fuzzy_system.zgf(:,1:max(fuzzy_system.par_kafka(5:end))));


if isempty(d_fuz)
   %anything wrong with the MBFs? 
   pos=[];
   md=[];
   prz=[];
   return;
end;


if fuzzy_system.qualitativ==1
   d_fuz=round(d_fuz+(1E-10*ones(size(d_fuz,1),1)*(0.5-rem(1:size(d_fuz,2),2))));
end;


[tmp,prz,pos]=finfer8(d_fuz,fuzzy_system.rulebase,fuzzy_system.par_kafka,fuzzy_system.zgf(size(fuzzy_system.zgf,1),1:fuzzy_system.par_kafka(4)),fuzzy_system.rulebase(size(fuzzy_system.rulebase,1),4),0,fuzzy_system.inferenz);
%konf=klass9([],code(ind_auswahl),pos(ind_auswahl),[],0);

md=zeros(size(prz));