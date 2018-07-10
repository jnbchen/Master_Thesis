  function regr_single = regression_en(regr_single, kp, d, ykont)
% function regr_single = regression_en(regr_single, kp, d, ykont)
%
% 
% compute a regression model for input data d and output data ykont
% using a parameter struct kp
% The results are written into a struct regr_single incl. information about feature extraction
% before this call
% 
% 
% 
% remove all pre-existing regression models....
%
% The function regression_en is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(regr_single)
    temp=regr_single;
    regr_single=[];
    if isfield(temp,'output')
        regr_single.output=temp.output;
    end;
    if isfield(temp,'merkmalsextraktion')
        regr_single.merkmalsextraktion=temp.merkmalsextraktion;
    end;
    clear temp;
end;

%design regression model depending on type
switch kp.regression.type
    case 'polynom'	%Linear Regression by a polynom
        
        %for safety reasons: check for existence of option for intermediate
        %messages
        if ~isfield(kp.regression,'anzeige')
            kp.regression.anzeige = 1;
        end;
        
        [regr_single.polynom,temp,temp,regr_single.merk_archiv]=poly_en(d,ykont,kp.regression.max_number_of_poly_features,kp.regression.poly_degree,[],[],1,kp.regression.weight_vector,...
            kp.regression.anzeige);
        
        if isempty(regr_single.polynom)
            regr_single=[];
        end;
        
        %Polynomial model are abel to perform an internal feature
        %reduction!! Consequently, an update of the feature extraction might
        %be necessary
        %normalization and transformation matrixes
        if isfield(regr_single,'merkmalsextraktion')
            if isempty(regr_single.merkmalsextraktion.phi_aggregation)
                %update struct for feature reduction in the regression
                regr_single.merkmalsextraktion.merkmal_auswahl=regr_single.merkmalsextraktion.merkmal_auswahl(regr_single.polynom.merkmal_auswahl);
                %variable names
                regr_single.merkmalsextraktion.var_bez = regr_single.merkmalsextraktion.var_bez (regr_single.polynom.merkmal_auswahl,:);
                
                %only use selected (and optionally resorted !!) features for the
                %normalization of features
                if regr_single.merkmalsextraktion.norm_merkmale.type~=0
                    regr_single.merkmalsextraktion.norm_merkmale.par1=regr_single.merkmalsextraktion.norm_merkmale.par1(regr_single.polynom.merkmal_auswahl);
                    regr_single.merkmalsextraktion.norm_merkmale.par2=regr_single.merkmalsextraktion.norm_merkmale.par2(regr_single.polynom.merkmal_auswahl);
                end;
            else
                %only use selected (and optionally resorted !!) aggregated features for the
                %transfromation
                regr_single.merkmalsextraktion.phi_aggregation = ...
                    regr_single.merkmalsextraktion.phi_aggregation(:,regr_single.polynom.merkmal_auswahl);
                %only use selected (and optionally resorted !!) aggregated features for the
                %normalization of aggregated features
                if regr_single.merkmalsextraktion.norm_aggregation.type~=0
                    regr_single.merkmalsextraktion.norm_aggregation.par1=regr_single.merkmalsextraktion.norm_aggregation.par1(regr_single.polynom.merkmal_auswahl);
                    regr_single.merkmalsextraktion.norm_aggregation.par2=regr_single.merkmalsextraktion.norm_aggregation.par2(regr_single.polynom.merkmal_auswahl);
                end;
            end;
            
            regr_single.merkmalsextraktion.feature_generation.input = regr_single.merkmalsextraktion.feature_generation.input(regr_single.merkmalsextraktion.merkmal_auswahl);
            if isfield(regr_single.merkmalsextraktion.feature_generation,'sample_points')
                regr_single.merkmalsextraktion.feature_generation.sample_points = regr_single.merkmalsextraktion.feature_generation.sample_points(regr_single.merkmalsextraktion.merkmal_auswahl);
            end;
        end;
    case 'ann'	%kuenstliches Neuronales Netz
        kp.ann.neurperclass     =-1;
        kp.ann.mlp.mlp_zeichnen_details = 1;
        [regr_single.ann.net, regr_single.ann.net_param] = nn_en(d, ykont, kp.ann);
        if isempty(regr_single.ann)
            regr_single=[];
        end;
        
        
        % case 'svm'	%Support-Vector-Machine
        %    regr_single.svm_system = svm_en(d,ykont,kp.svm.svm_options);
        %    if isempty(regr_single.svm_system)
        %       regr_single=[];
        %    end;
        
    case 'knn'	%k-nearest-neighbour-Klassifikator
        [regr_single.knn] = knn_en(d, ykont, kp.knn);
        if isempty(regr_single.knn)
            regr_single=[];
        end;
        
        
    case 'fit'  % function of the curve fitting toolbox to fit curves
        regr_single.fit=fit_en(d,ykont,kp);
        if isempty(regr_single.fit)
            regr_single=[];
        end;
        
    case 'fuzzy_system'	%Fuzzy-Regression (Mamdani)
        regr_single.fuzzy_system = fuzzy_en_regr(d,ykont,kp.regression.output_name,'fuzzy_system',regr_single.merkmalsextraktion.var_bez,kp.fuzzy_system);
        if isempty(regr_single.fuzzy_system)
            regr_single=[];
        end;
        
    case 'lolimot'	%Lolimot (Uni Siegen)
        if exist('LMNTrain.m','file')
            regr_single.lolimot = LMNTrain([d ykont]);
        else
            regr_single.lolimot = [];
            myerror('Please install LMNToolbox (Nelles group, University of Siegen, Germany)!');
        end;
        if isempty(regr_single.lolimot)
            regr_single=[];
        end;
        
    case 'arx' % autoregressives Modell (system identification toolbox)
        if exist('arx_en.m','file') && exist('arx_an.m','file')
            regr_single.arx = kp.regression.arx;
            regr_single     = arx_en(d,ykont,regr_single);
        else
            regr_single.arx = [];
            myerror('Bitte erst ARX-Funktion (system identification toolbox) implementieren bzw. installieren!');
        end;
        
    case 'vsa' % Virtual Storage A
        if exist('vsa_en.m','file') && exist('vsa_an.m','file')
            regr_single.vsa = kp.regression.vsa;
            regr_single     = vsa_en(d,ykont,regr_single);
        else
            regr_single.vsa = [];
            myerror('Bitte erst Virtueller Speicher A Modell implementieren bzw. installieren!');
        end;
        
    case 'vsb' % Virtual Storage B
        if exist('vsb_en.m','file') && exist('vsb_an.m','file')
            regr_single.vsb = kp.regression.vsb;
            regr_single     = vsb_en(d,ykont,regr_single);
        else
            regr_single.vsb = [];
            myerror('Bitte erst Virtueller Speicher B Modell implementieren bzw. installieren!');
        end;
        
    case 'vsc' % Virtual Storage C
        if exist('vsc_en.m','file') && exist('vsc_an.m','file')
            regr_single.vsc = kp.regression.vsc;
            regr_single     = vsc_en(d,ykont,regr_single);
        else
            regr_single.vsc = [];
            myerror('Bitte erst Virtueller Speicher C Modell implementieren bzw. installieren!');
        end;
        
        %     case 'pea' % Price Elasticity A
        %         if exist('pea_en.m','file') && exist('pea_an.m','file')
        %             regr_single.pea = kp.regression.pea;
        %             regr_single     = pea_en(d,ykont,regr_single);
        %         else
        %             regr_single.pea = [];
        %             myerror('Bitte erst Preiselastizitaet A Modell implementieren bzw. installieren!');
        %         end;
        %
        %     case 'peb' % Price Elasticity B
        %         if exist('peb_en.m','file') && exist('peb_an.m','file')
        %             regr_single.peb = kp.regression.peb;
        %             regr_single     = peb_en(d,ykont,regr_single);
        %         else
        %             regr_single.peb = [];
        %             myerror('Bitte erst "Preiselastizitaet B" Modell implementieren bzw. installieren!');
        %         end;
        %         %---NEW end-------------------------------------------------------
        
        
    otherwise
        myerror(sprintf('Unknown regression model %s',kp.regression.type));
end;