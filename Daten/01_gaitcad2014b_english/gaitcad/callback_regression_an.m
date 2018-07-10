% Script callback_regression_an
%
% The script callback_regression_an is part of the MATLAB toolbox Gait-CAD. 
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

if ~isfield(regr_single, 'merkmalsextraktion')
   myerror('No information found for feature selection and aggregation. Please redesign regression');
   return;
end;
erzeuge_parameterstrukt;

%GANZ, GANZ wichtig: bei der Anwendung beziehen wir uns auf den entworfenen Regressor!!!!!!!
parameter.gui.regression.merkmalsklassen = regr_single.designed_regression.merkmalsklassen;
kp.regression.type=regr_single.designed_regression.type;

%Informationen für Gitterplot bei der Anwendung
kp.gitterplot = 1;

%hold on;plot(gitterplot.d1,gitterplot.ydach_regr)
%surf(gitterplot.d1,gitterplot.d2,reshape(gitterplot.ydach_regr,size(gitterplot.d1,1),size(gitterplot.d2,1)))

kp.multiplot = 1;
erzeuge_datensatz_regr_an;
clear kp.multiplot

ydach_regr = regression_an(regr_single, d, kp);

if kp.gitterplot == 1 
   gitterplot.ydach_regr =  ydach_regr(kp.gitter_start:end,:);
   
   ydach_regr(kp.gitter_start:end,:) =[];
   gitterplot.d = d(kp.gitter_start:end,:);
   gitterplot.d_without_norm_and_aggregation = regr_plot.d_without_norm_and_aggregation(kp.gitter_start:end,:);
   regr_plot.d  = d(1:kp.gitter_start-1,:);
   regr_plot.d_without_norm_and_aggregation = regr_plot.d_without_norm_and_aggregation(1:kp.gitter_start-1,:);
else
   regr_plot.d = d;   
end;



%Zuweisung...
switch parameter.gui.regression.merkmalsklassen
   case 'Time series (TS)'
      sample_points = (parameter.gui.zeitreihen.segment_start-min(regr_single.merkmalsextraktion.feature_generation.sample_points)):parameter.gui.zeitreihen.segment_ende;
      d_orgs(ind_auswahl,sample_points,end+1)=ydach_regr;
      var_bez = char(var_bez(1:par.anz_merk,:), strcat('Estimation regression',sprintf(' %s (%s)',regr_single.designed_regression.output_name, kp.regression.type)));
      ytrue_regr = squeeze(d_orgs(ind_auswahl,sample_points,regr_single.designed_regression.output))';
      regr_plot.ind_auswahl  = [];      
      
   case 'Single features'
      d_org(ind_auswahl,end+1) = ydach_regr;
      if ~isempty(interpret_merk_rett)
         interpret_merk_rett (end+1,:) = parameter.gui.merkmale_und_klassen.bestimmter_wert;
      end;
      if ~isempty(interpret_merk)
         interpret_merk(end+1) = parameter.gui.merkmale_und_klassen.bestimmter_wert;
      end;
      dorgbez = char(dorgbez(1:par.anz_einzel_merk,:), strcat('Estimation regression',sprintf(' %s (%s)',regr_single.designed_regression.output_name, kp.regression.type)));
      if regr_single.designed_regression.output~=0
         ytrue_regr = d_org(ind_auswahl,regr_single.designed_regression.output);
      end;
      regr_plot.ind_auswahl  = ind_auswahl;
end;

%Bewertung Regressionsergebnis 
if regr_single.designed_regression.output~=0
   
   regr_plot.ydach_regr = ydach_regr;
   regr_plot.ytrue_regr = ytrue_regr;
   if kp.gitterplot==1
      regr_plot.gitterplot = gitterplot;
   end;
   
   regr_plot.anzeige_erg = 1;
   [regr_single.fitness_corrcoeff,regr_single.mean_abs_error]= regression_statistics(regr_plot);

else
   regr_plot = [];
end;

clear sample_points temp ydach_regr ytrue_regr gitterplot;
aktparawin;
