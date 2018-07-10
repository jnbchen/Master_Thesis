% Script collect_regression_io
%
% collects the input data, output data, and feature names for the regression
% (for time series and single features)
% 
%
% The script collect_regression_io is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

switch kp.regression.merkmalsklassen
    case 'Time series (TS)'
        %feature names
        feature_bez=[];
        %only for exactly one data point!!
        if (length(ind_auswahl) == 1)
            
            %sample points
            sample_points = (parameter.gui.zeitreihen.segment_start-min(regr_single.merkmalsextraktion.feature_generation.sample_points)):parameter.gui.zeitreihen.segment_ende;
            
            if length(sample_points)<5
                error_string = strcat('The time series is too short for the selected regression estimation:', ...
                    sprintf(' %d available sample points, Estimation from  [k%d]',length(sample_points),min(regr_single.merkmalsextraktion.feature_generation.sample_points)));
                myerror(error_string);
            end;
            
            
            %prepare empty input data matrix
            d=zeros(length(sample_points),length(regr_single.merkmalsextraktion.feature_generation.input));
            %fill input data matrix row by row (sample points -> data points!)
            for i_input=1:length(regr_single.merkmalsextraktion.feature_generation.input)
                d(:,i_input)=squeeze(d_orgs(ind_auswahl,sample_points+regr_single.merkmalsextraktion.feature_generation.sample_points(i_input),regr_single.merkmalsextraktion.feature_generation.input(i_input)))';
                feature_bez = strvcatnew(feature_bez,[deblank(var_bez(regr_single.merkmalsextraktion.feature_generation.input(i_input),:)) '[k-' num2str(-regr_single.merkmalsextraktion.feature_generation.sample_points(i_input)) ']' ]);
            end;
            %output data
            ykont=d_orgs(ind_auswahl,sample_points,kp.regression.output)';
        else
            myerror('The prognosis of time series is only possible with one selected data point!');
        end;
        kp.regression.output_name = var_bez(kp.regression.output,:);
        kp.interpret_merk =[];
        
        kp.regression.weight_vector = [];
        
        
        
    case 'Single features'
        %input data matrix row by row
        d= d_org(ind_auswahl,regr_single.merkmalsextraktion.feature_generation.input);
        %output data
        ykont= d_org(ind_auswahl,kp.regression.output);
        %feature names
        feature_bez = dorgbez(regr_single.merkmalsextraktion.feature_generation.input,:);
        kp.regression.output_name=dorgbez(kp.regression.output,:);
        if ~isempty(interpret_merk)
            kp.interpret_merk = interpret_merk(regr_single.merkmalsextraktion.feature_generation.input)';
        else
            kp.interpret_merk = [];
        end;
        
        switch parameter.gui.regression.poly_weighting
            case 1
                %keine Gewichtung gewünscht
                kp.regression.weight_vector = [];
            case 2
                %Wichtung nach der inversen Häufigkeit der Ausgangsklassen, seltene Klassen werden bevorzugt
                [temp_hist]   = hist(code(ind_auswahl),1:max(code(ind_auswahl)));
                kp.regression.weight_table  = max(temp_hist+1)./(temp_hist+1);
                kp.regression.weight_vector = kp.regression.weight_table(code(ind_auswahl));
            case 3
                %manuell aus Projekt
                if isfield(parameter.projekt,'weight_vector') && length(parameter.projekt.weight_vector) == par.anz_dat
                    kp.regression.weight_vector = parameter.projekt.weight_vector(ind_auswahl);
                else
                    myerror('No related weighting vector for regression found  (parameter.projekt)!');
                end;
        end;
        
end;

if size(d,2) > 2
    kp.gitterplot =0;
end;

%zusätzliche Punkte für Gitterplot anhängen
if kp.gitterplot == 1 && (~isfield(kp,'check_eingabe_multi_d') || kp.check_eingabe_multi_d == 0)
    
    %wo ist das 1. Datentupel für den Funktionsplot ?
    kp.gitter_start = size(d,1)+1;
    gitterdimension = 1:min(size(d,2),2);
    d_gitter={};
    for i_gitter = 1:length(gitterdimension)
        min_temp = min(d(:,gitterdimension(i_gitter)));
        max_temp = max(d(:,gitterdimension(i_gitter)));
        rom_temp = max_temp - min_temp;
        d_gitter{i_gitter} = [min_temp - 0.5*rom_temp : 2*rom_temp/parameter.gui.anzeige.anz_gitterpunkte :  max_temp+0.5*rom_temp];
    end;
    
    %compute data points for gitterplot
    switch length(gitterdimension)
        case 1
            d1 = d_gitter{1}';
            d_temp = d1;
        case 2
            [d1,d2] = meshgrid(d_gitter{1},d_gitter{2});
            d_temp = [d1(:) d2(:)];
    end;
    
    %add data points for gitterplot to the regular data points for
    %application of the regression model
    d = [d ; ones(size(d_temp,1),1)*mean(d)];
    d(kp.gitter_start:end,gitterdimension) = d_temp;
    gitterplot.gitterdimension = gitterdimension;
    gitterplot.anz_gitterpunkte = parameter.gui.anzeige.anz_gitterpunkte+1;
    clear d1 d2 d_temp
end;

%only for multidimensional inputs!
if isfield(kp,'check_eingabe_multi_d') && kp.check_eingabe_multi_d == 1&& isfield(kp,'multiplot') && exist('eingabe','var') && isfield(eingabe,'var1_ind') && isfield(eingabe,'var2_ind')
    
    kp.check_eingabe_multi_d = 0;
    kp.gitter_start = size(d,1)+1;
    gitterdimension = 1:size(d,2);
    d_gitter={};
    %     for i_gitter = 1:length(gitterdimension)
    %         min_temp = min(d(:,gitterdimension(i_gitter)));
    %         max_temp = max(d(:,gitterdimension(i_gitter)));
    %         rom_temp = max_temp - min_temp;
    %         d_gitter{i_gitter} = [min_temp - 0.5*rom_temp : 2*rom_temp/parameter.gui.anzeige.anz_gitterpunkte :  max_temp+0.5*rom_temp];
    %     end;
    %
    %compute data points for gitterplot
    d1 = eingabe.range(eingabe.var1_ind,1):diff(eingabe.range(eingabe.var1_ind,:))/parameter.gui.anzeige.anz_gitterpunkte:eingabe.range(eingabe.var1_ind,2);
    d2 = eingabe.range(eingabe.var2_ind,1):diff(eingabe.range(eingabe.var2_ind,:))/parameter.gui.anzeige.anz_gitterpunkte:eingabe.range(eingabe.var2_ind,2);
    
    clear d_temp;
    if ~isempty(eingabe.var2_ind)
        [d1,d2] = meshgrid(d1,d2);
        d_temp(:,[eingabe.var1_ind eingabe.var2_ind]) = [d1(:) d2(:)];
    else
        d_temp(:,eingabe.var1_ind) = d1;
    end;
    
    for i_konst = 1:length(eingabe.konst_ind)
        d_temp(:,eingabe.konst_ind(i_konst)) = eingabe.konst_val(i_konst);
    end;
    
    %add data points for gitterplot to the regular data points for
    %application of the regression model
    d = [d ; ones(size(d_temp,1),1)*mean(d)];
    d(kp.gitter_start:end,gitterdimension) = d_temp;
    gitterplot.gitterdimension = gitterdimension;
    gitterplot.anz_gitterpunkte = parameter.gui.anzeige.anz_gitterpunkte+1;
    clear d1 d2 d_temp
    kp.gitterplot = 1;
end;


if isempty(d)
    myerror(['No appropriate features found!' ' ' 'Please check the number of input and output variables!']);
end;
