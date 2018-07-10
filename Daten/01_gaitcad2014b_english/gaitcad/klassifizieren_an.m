  function [pos,md,prz,svm_md] = klassifizieren_an(klass_single, d, kp)
% function [pos,md,prz,svm_md] = klassifizieren_an(klass_single, d, kp)
%
%  klass_single: Strukt aus Kafka (oder [])
%  kp: Parameter-Strukt mit Parametern für Klassifikatoren (Felder heißen wie klassifikator)
%  d (Daten)
%  svm_md: Strukt mit den SVM-Werten bei einem Mehrklassenproblem
% 
%
% The function klassifizieren_an is part of the MATLAB toolbox Gait-CAD. 
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

svm_md = [];

switch kp.klassifikator
    
    case 'bayes'	%Bayes-Klassifikator
        [pos,md,prz,s_return] = klf_an6(d,klass_single.bayes.kl,klass_single.bayes.su,klass_single.bayes.s,klass_single.bayes.s_invers,klass_single.bayes.log_s,kp.bayes.metrik, anzeige, kp.L, kp.bayes.apriori, klass_single.bayes.p_apriori,kp.decision);
        
    case 'ann'	%kuenstliches Neuronales Netz
        [pos, md, prz] = nn_an (d, klass_single.ann.net, klass_single.ann.net_param);
        
        if(isempty(prz))	%tritt bei Verwendung von nur einem Eingangsneuron auf
            prz =  zeros(length(pos),kp.anz_class);
            md  =  prz;
        end;
        
    case 'svm'	%Support-Vector-Machine
        svm_system = klass_single.svm_system;
        [pos,md,prz,svm_md] = svm_an(d,svm_system);
        
    case 'knn'	%k-nearest-neighbour-Klassifikator
        %keine Regression!!
        kp.knn.regression = 0;
        %Zwangsnormierung verhindern, so geht es nur nach dem Entwurf!
        kp.knn.normieren  = 0;
        [pos, md, prz] = knn_an(d, kp.knn, klass_single.knn);
        
    case 'knn_tool'	%k-nearest-neighbour-Klassifikator (Toolbox)
        [pos,md,prz] = knneighbour_an(d,klass_single.knn_tool);
        
    case 'fuzzy_system'	%Fuzzy-Klassifikator
        [pos,md,prz] = fuzzy_an(d,klass_single.fuzzy_system);
        
    case 'dec_tree'	%Entscheidungsbaum
        [pos,md,prz] = fuzzy_an(d,klass_single.dec_tree);
        
    case 'fitensemble'	%Boosted examples with weak classifiers/regressors
        [pos,md,prz] = fitensemble_an(d,klass_single.fitensemble_system);
        
end;


