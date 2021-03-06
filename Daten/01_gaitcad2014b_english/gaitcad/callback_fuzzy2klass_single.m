% Script callback_fuzzy2klass_single
%
% The script callback_fuzzy2klass_single is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(fuzzy_system)
   if isfield(fuzzy_system,'aggregation') && fuzzy_system.aggregation==1
      mywarning('Fuzzy systems with aggregated features can not be reexported to the classifier!');
      return;
   end;
   
   if length(klass_single)>1
      mywarning('Fuzzy systems can only be copied in to classifiers if multi-class problem classifiers have been designed!');
      return;
   end;
   
   klass_single.fuzzy_system=fuzzy_system;
   
   %Merkmalsextraktion: alle ausgewählten Merkmale
   klass_single.merkmalsextraktion.merkmal_auswahl=[1:par.anz_einzel_merk]';
   klass_single.merkmalsextraktion.var_bez=dorgbez(1:par.anz_einzel_merk,:);
   
   %keine Normierung
   klass_single.merkmalsextraktion.norm_merkmale.type=0;
   klass_single.merkmalsextraktion.norm_merkmale.par1=[];
   klass_single.merkmalsextraktion.norm_merkmale.par2=[];
   
   %keine Normierung aggregierte Merkmale
   klass_single.merkmalsextraktion.norm_aggregation.type=0;
   klass_single.merkmalsextraktion.norm_aggregation.par1=[];
   klass_single.merkmalsextraktion.norm_aggregation.par2=[];
   
   %keine Aggregation
   klass_single.merkmalsextraktion.phi_aggregation=[];
   klass_single.merkmalsextraktion.phi_text ='None';
   
   %Fuzzy-System
   klass_single.entworfener_klassifikator.typ='fuzzy_system';
   klass_single.entworfener_klassifikator.nummer=6;
   %Mehrklassenfall
   klass_single.entworfener_klassifikator.mehrklassen=1;
   
   
   %Bezeichner ling. Terme Ausgangsgröße
   klass_single.klasse.zgf_bez=fuzzy_system.zgf_bez(end,:);
   %Bezeichner Ausgangsgröße
   klass_single.klasse.bez=fuzzy_system.dorgbez_rule(end,:);
   %angelernte Klassen: alles, was in Regelkonklusionen vorkommt
   klass_single.klasse.angelernt=unique(fuzzy_system.rulebase(:,4));
end;