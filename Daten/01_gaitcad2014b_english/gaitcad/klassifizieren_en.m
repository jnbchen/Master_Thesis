  function klass_single = klassifizieren_en(klass_single, kp, d, code)
% function klass_single = klassifizieren_en(klass_single, kp, d, code)
%
%  klass_single: z.T. gefülltes Strukt aus Kafka (oder [])
%  kp: Parameter-Strukt mit Parametern für Klassifikatoren (Felder heißen wie klassifikator)
%  d (Daten)
%  code (Klassenzug.)
%  Rückgaben:
%  klass_single: siehe oben
% 
%
% The function klassifizieren_en is part of the MATLAB toolbox Gait-CAD. 
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

global global_plot_off;
if (isempty(global_plot_off))
   anzeige = 1;
else
   anzeige = ~global_plot_off;
end;

%alle anderen Klassifikatoren wegwerfen....
if ~isempty(klass_single) 
   temp=klass_single;
   klass_single=[];
   if isfield(temp,'klasse') 
      klass_single.klasse=temp.klasse;
   end;
   if isfield(temp,'merkmalsextraktion') 
      klass_single.merkmalsextraktion=temp.merkmalsextraktion;
   end; 
   clear temp;
end;


switch kp.klassifikator
case 'bayes'	%Bayes-Klassifikator
   [klass_single.bayes.kl,klass_single.bayes.su,klass_single.bayes.s,klass_single.bayes.s_invers,klass_single.bayes.log_s,klass_single.bayes.p_apriori] = klf_en6(d,code,anzeige);
   if isempty(klass_single.bayes)
      klass_single=[];
   end;   
   
case 'ann'	%kuenstliches Neuronales Netz
    kp.ann.mlp.mlp_zeichnen_details = 0;
   [klass_single.ann.net, klass_single.ann.net_param] = nn_en(d, code, kp.ann);
   if isempty(klass_single.ann)
      klass_single=[];
   end;   
   
   
case 'svm'	%Support-Vector-Machine
   klass_single.svm_system = svm_en(d,code,kp.svm.svm_options);
   if isempty(klass_single.svm_system)
      klass_single=[];
   end;   
   
   
case 'knn'	%k-nearest-neighbour-Klassifikator
   kp.knn.normieren = 0;
   [klass_single.knn] = knn_en(d, code, kp.knn);
   if isempty(klass_single.knn)
      klass_single=[];
   end;   
   
   
case 'knn_tool'	%k-nearest-neighbour-Klassifikator (Toolbox)
   kp.knn_tool.normierung=0;
   klass_single.knn_tool = knneighbour_en(d, code, 1:size(d,1), kp.knn_tool.normierung, kp.knn_tool.k);
   if isempty(klass_single.knn_tool)
      klass_single=[];
   end; 
   
case 'fuzzy_system'	%Fuzzy-Klassifikator
   klass_single.fuzzy_system = fuzzy_en(d,code,klass_single.klasse,'fuzzy_system',klass_single.merkmalsextraktion.var_bez,kp.fuzzy_system);   
   if isempty(klass_single.fuzzy_system)
      klass_single=[];
   end; 
   
   
case 'dec_tree'	%Entscheidungsbaum   
   klass_single.dec_tree = fuzzy_en(d,code,klass_single.klasse,'dec_tree',klass_single.merkmalsextraktion.var_bez,kp.fuzzy_system);   
   if isempty(klass_single.dec_tree)
      klass_single=[];
   end; 
   
case 'fitensemble'	%Entscheidungsbaum   
   klass_single.fitensemble_system = fitensemble_en(d,code,kp.fitensemble);   
   if isempty(klass_single.fitensemble_system)
      klass_single=[];
   end; 

   
end

if isempty(klass_single)
   mywarning('No classifier found');
   return;
end;


% Klassen, für die angelernt wurde merken:
klass_single.klasse.angelernt = unique(code)';