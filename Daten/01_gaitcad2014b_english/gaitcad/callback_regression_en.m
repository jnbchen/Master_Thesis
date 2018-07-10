% Script callback_regression_en
%
% 
% recycle parameter struct for classification
% and add specific information for regression
%
% The script callback_regression_en is part of the MATLAB toolbox Gait-CAD. 
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

erzeuge_parameterstrukt;

%information for gitterplot not during design
kp.gitterplot = 0;

%show intermediate messages
kp.regression.anzeige = 1;

%only for the calculation of feature relevances
switch mode_callback_regression_en
case {2,4}
   kp.regression.merkmalsklassen = 'Time series (TS)';
case {3,5}
   kp.regression.merkmalsklassen = 'Single features';
   %forces that all feature relevances are shown are not skipped due to a unnecessary feature selection in poly_en.m
   %reduction of 2, because the output of the regression model is not included to the computation of regression coefficients
   kp.regression.max_number_of_raw_features = max(1,min(par.anz_einzel_merk-1,kp.regression.max_number_of_raw_features));
end;
switch mode_callback_regression_en
case {2,3}
   kp.regression.merkmalsauswahl = 3;   
case {4,5}
   kp.regression.merkmalsauswahl = 5;
end;

if strcmp(kp.regression.merkmalsklassen,'Single features') && length(ind_auswahl) < 2
   myerror('The design of a regression model is impossible with only one selected data point!');
end;  

%collect input features for regression 
erzeuge_datensatz_regr; 

if mode_callback_regression_en ==1
   
   %design regression function
   regr_single = regression_en(regr_single, kp, d, ykont);
   
   %save regressor type
   regr_single.designed_regression.type=kp.regression.type;
   regr_single.designed_regression.output=parameter.gui.regression.output;
   regr_single.designed_regression.merkmalsklassen = parameter.gui.regression.merkmalsklassen;
   regr_single.designed_regression.output_name=deblank(kp.regression.output_name);   
end;

if isfield(parameter.allgemein,'twodprojektion') &&  parameter.allgemein.twodprojektion>0 && ishandle(parameter.allgemein.twodprojektion) && ~isempty(strfind(get(2,'name'),'2D Projection'))
    close(parameter.allgemein.twodprojektion);
    parameter.allgemein.twodprojektion = 0;
end;

regr_plot = [];

clear d ydach mode_callback_regression_en;

%update GUI and variables
aktparawin;
