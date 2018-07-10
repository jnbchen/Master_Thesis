% Script erzeuge_datensatz_regr
%
% collects the input features for a regression model with time series or single features
% (including extraction, normalization and aggregation)
% 
%
% The script erzeuge_datensatz_regr is part of the MATLAB toolbox Gait-CAD. 
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

regr_single.merkmalsextraktion=[];

switch kp.regression.merkmalsklassen
    case 'Time series (TS)'
        %all features, but not based on previous regression results
        new_input = find(~strcmp(string2cell(var_bez(1:par.anz_merk,1:min(size(var_bez,2),length('Estimation regression')))),'Estimation regression'));
        
        switch parameter.gui.regression.merkmalsauswahl
            
            case {1,3,5}
                %all features, but not based on previous regression results
                
            case {2,4,6}
                %selected features
                new_input=parameter.gui.merkmale_und_klassen.ind_zr(find(ismember(parameter.gui.merkmale_und_klassen.ind_zr,new_input)));
        end;
        
        if isempty(new_input)
            myerror(['No appropriate features found!' ' ' 'Please check the number of input and output variables!']);
        end;
        
        
        regr_single.merkmalsextraktion.feature_generation.input        =[];
        regr_single.merkmalsextraktion.feature_generation.sample_points =[];
        
        switch parameter.gui.regression.type
            case {'vsa','vsb','vsc','arx'}
                
                new_input = new_input(ismember(new_input,kp.regression.output)==0);
                if length(new_input) ~= 1
                    myerror('This method expects exactly one input variable!')
                end;    
                regr_single.merkmalsextraktion.feature_generation.input = new_input;
                regr_single.merkmalsextraktion.feature_generation.sample_points = 0;
                
            otherwise
                
                %collection via past sample points
                for i_input=1:length(kp.regression.sample_points)
                    regr_single.merkmalsextraktion.feature_generation.input        =  [regr_single.merkmalsextraktion.feature_generation.input new_input];
                    regr_single.merkmalsextraktion.feature_generation.sample_points = [regr_single.merkmalsextraktion.feature_generation.sample_points kp.regression.sample_points(i_input)*ones(1,length(new_input))];
                end;
                
                ind = find( (regr_single.merkmalsextraktion.feature_generation.input== parameter.gui.regression.output) & ...   % Coderevision: &/| checked!
                    regr_single.merkmalsextraktion.feature_generation.sample_points ==0 );
                if ~isempty(ind)
                    regr_single.merkmalsextraktion.feature_generation.input(ind) = [];
                    regr_single.merkmalsextraktion.feature_generation.sample_points(ind) =[];
                end;
        end
        
        
        %preselection via single features does not make sense
        kp.regression.preselection_merkmale = 0;
        
    case 'Single features'
        %all features, but not based on previous regression results
        ind_em = find(~strcmp(string2cell(dorgbez(1:par.anz_einzel_merk,1:min(size(dorgbez,2),length('Estimation regression')))),'Estimation regression'));
        
        switch kp.regression.merkmalsauswahl
            case {1,3,5}
                regr_single.merkmalsextraktion.feature_generation.input=setdiff(ind_em,kp.regression.output);
            case {2,4,6}
                %selected features
                regr_single.merkmalsextraktion.feature_generation.input=setdiff(parameter.gui.merkmale_und_klassen.ind_em,kp.regression.output);
                regr_single.merkmalsextraktion.feature_generation.input=ind_em(ismember(ind_em,regr_single.merkmalsextraktion.feature_generation.input));
        end;
end;

collect_regression_io;



switch kp.regression.merkmalsauswahl
    case {1,2}
        merkmal_auswahl=[1:size(d,2)];
        
    case {3,4}
        %univariate feature reduction by linear regression
        %coefficients
        
        kp.regression.max_number_of_raw_features = min(kp.regression.max_number_of_raw_features,size(d,2));
        [merk_archiv_regr,merkmal_auswahl,merk,merk_archiv]=poly_en(d,ykont,kp.regression.max_number_of_raw_features,1,[],...
            kp.interpret_merk,0,kp.regression.weight_vector);
        %[temp,merkmal_auswahl] = sort(-merk_archiv_regr.rele);
        %merkmal_auswahl=merkmal_auswahl(1:min(length(merkmal_auswahl),kp.regression.max_number_of_raw_features));
        if kp.regression.merkmalsauswahl==3
            merk_archiv_regr.verfahren='Linear regression coefficients (univariate, selected features)';
        else
            merk_archiv_regr.verfahren='Linear regression coefficients (univariate, all features)';
        end;
        merk_archiv_regr.output = kp.regression.output_name;
        merk_archiv_regr.input = regr_single.merkmalsextraktion.feature_generation.input;
        merk_archiv_regr.feature_bez = feature_bez;
        %merk = [];
        merk_zr = [];
        
    case {5,6}
        %multivariate feature reduction by linear regression
        %coefficients
        
        %correction for feature selection
        if mode_callback_regression_en>1
            kp.regression.max_number_of_raw_features = min(kp.regression.max_number_of_raw_features,size(d,2));
        end;
        
        if kp.regression.preselection_merkmale
            
            %correct the shift by the regression output
            ind_preselection = find(ismember(parameter.gui.merkmale_und_klassen.ind_em,regr_single.merkmalsextraktion.feature_generation.input));
            temp_vorauswahl = parameter.gui.merkmale_und_klassen.ind_em(ind_preselection);
            
            back_index(regr_single.merkmalsextraktion.feature_generation.input) = ...
                1:length(regr_single.merkmalsextraktion.feature_generation.input);
            
            kp.merkmal_vorauswahl = back_index(temp_vorauswahl);
            
        else
            kp.merkmal_vorauswahl=[];
        end;
        
        [merk_archiv_regr,merkmal_auswahl,merk,merk_archiv]=poly_en(d,ykont,kp.regression.max_number_of_raw_features,1,kp.merkmal_vorauswahl,...
            kp.interpret_merk,1,kp.regression.weight_vector);
        merkmal_auswahl=merk_archiv_regr.merkmal_auswahl;
        if kp.regression.merkmalsauswahl==5
            merk_archiv_regr.verfahren='Linear regression coefficients (multivariate, selected features)';
        else
            merk_archiv_regr.verfahren='Linear regression coefficients (multivariate, all features)';
        end;
        merk_archiv_regr.output = kp.regression.output_name;
        merk_archiv_regr.input = regr_single.merkmalsextraktion.feature_generation.input;
        merk_archiv_regr.feature_bez = feature_bez;
        %merk = [];
        merk_zr = [];
end;

%always ignore features without variance in the training data
merkmal_auswahl = merkmal_auswahl(find(min(d(:,merkmal_auswahl),[],1) ~= max(d(:,merkmal_auswahl),[],1)));

if isempty(merkmal_auswahl)
    myerror('No valid feature found for the regression model!');
end;

%alle Informationen für die spätere Anwendung merken
regr_single.merkmalsextraktion.var_bez = deblank(feature_bez(merkmal_auswahl,:));
d=d(:,merkmal_auswahl);

%update feature generation (only necessary after a reduction)
regr_single.merkmalsextraktion.feature_generation.input = regr_single.merkmalsextraktion.feature_generation.input(merkmal_auswahl);
if isfield(regr_single.merkmalsextraktion.feature_generation,'sample_points')
    regr_single.merkmalsextraktion.feature_generation.sample_points = regr_single.merkmalsextraktion.feature_generation.sample_points(merkmal_auswahl);
end;
regr_single.merkmalsextraktion.merkmal_auswahl=[1:size(d,2)];

%Normierung der ausgewaehlten Daten
normierung = parameter.gui.regression.normierung;
regr_single.merkmalsextraktion.var_bez_without_norm_and_aggregation = regr_single.merkmalsextraktion.var_bez;

%Anpassung von normierung fuer Funktion matrix_normieren
switch normierung
    case 1
        %keine Normierung
        regr_single.merkmalsextraktion.norm_merkmale.type=0;
    case 2
        %[0 - 1 Normierung]
        regr_single.merkmalsextraktion.norm_merkmale.type=2;
        regr_single.merkmalsextraktion.var_bez = strcat(regr_single.merkmalsextraktion.var_bez,' Norm [0,1] ');
    case 3
        %MW0 - STD 1
        regr_single.merkmalsextraktion.norm_merkmale.type=1;
        regr_single.merkmalsextraktion.var_bez = strcat(regr_single.merkmalsextraktion.var_bez,' Norm [MEAN 0,STD 1] ');
    case 4
        %MW0 - STD unchanged
        regr_single.merkmalsextraktion.norm_merkmale.type=5;
        regr_single.merkmalsextraktion.var_bez = strcat(regr_single.merkmalsextraktion.var_bez,' Norm [Mean 0,STD unchanged] ');
end
%Normierung berechnen
[temp,regr_single.merkmalsextraktion.norm_merkmale.par1,regr_single.merkmalsextraktion.norm_merkmale.par2]=matrix_normieren(d,regr_single.merkmalsextraktion.norm_merkmale.type);
%Anwenden macht dann später callback_aggregation

%Merkmalsaggregation (enthält Anwendung!)
aggregation_mode = parameter.gui.regression.merkmalsaggregation-1;
callback_aggregation_regr;

if ~isempty(regr_single.merkmalsextraktion.phi_aggregation)
    d = d*regr_single.merkmalsextraktion.phi_aggregation;
end;

%Normierung	der aggregierten Daten
normierung = parameter.gui.regression.normierung_aggregierte_merkmale;
%Anpassung von normierung fuer Funktion matrix_normieren
switch normierung
    case 1
        %keine Normierung
        regr_single.merkmalsextraktion.norm_aggregation.type=0;
    case 2
        %[0 - 1 Normierung]
        regr_single.merkmalsextraktion.norm_aggregation.type=2;
    case 3
        %MW0 - STD 1
        regr_single.merkmalsextraktion.norm_aggregation.type=1;
    case 4
        %MW0 - STD unchanged
        regr_single.merkmalsextraktion.norm_aggregation.type=5;
end
%Normierung berechnen
[temp,regr_single.merkmalsextraktion.norm_aggregation.par1,regr_single.merkmalsextraktion.norm_aggregation.par2]=matrix_normieren(d,regr_single.merkmalsextraktion.norm_aggregation.type);
%Anwenden...
erzeuge_datensatz_regr_an;

%aggregation_mode wird in callback_aggregation gekillt
clear mode merkmal_mode normierung one_against_x_indx
