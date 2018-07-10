  function [ydach] = regression_an(regr_single, d, kp)
% function [ydach] = regression_an(regr_single, d, kp)
%
% 
% 
% 
%
% The function regression_an is part of the MATLAB toolbox Gait-CAD. 
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

switch kp.regression.type
    case 'polynom'	%linear regression with a polynomial function
        ydach = poly_an(d,regr_single.polynom);
        
    case 'ann'	%kuenstliches neuronales netz
        regr_single.ann.neurperclass=-1;
        ydach = nn_an (d, regr_single.ann.net, regr_single.ann.net_param);
        
    case 'knn'	%k-nearest-neighbour-klassifikator
        kp.knn.regression = 1;
        ydach = knn_an(d, kp.knn, regr_single.knn);
        
    case 'fit'	%fit
        ydach =  fit_an(d,regr_single.fit);
        
    case 'fuzzy_system'	%fuzzy
        ydach =  fuzzy_an_regr(d,regr_single.fuzzy_system);
        
    case 'lolimot'	%Lolimot
        ydach =  regr_single.lolimot.calculateModelOutput(d);
        
        %---NEW start---------------------------------------------------------
    case 'arx' % autoregressives Modell (system identification toolbox)
        ydach = arx_an(d,regr_single);
        
    case 'vsa' % Virtual Storage A
        ydach = vsa_an(d,regr_single);
        
    case 'vsb' % Virtual Storage B
        ydach = vsb_an(d,regr_single);
        
    case 'vsc' % Virtual Storage C
        ydach = vsc_an(d,regr_single);
        
    case 'pea' % Price Elasticity A
        ydach = pea_an(d,regr_single);
        
    case 'peb' % Price Elasticity B
        ydach = peb_an(d,regr_single);
        %---NEW end-------------------------------------------------------
        
        
end;


