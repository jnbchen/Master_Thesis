% Script callback_zr2dt
%
% converts time series to data points
% if single features have the same number as time series, they will we saved
% as well
% it works only for one data point
%
% The script callback_zr2dt is part of the MATLAB toolbox Gait-CAD. 
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

if par.anz_dat == 1 && (par.anz_einzel_merk == 0 || par.anz_einzel_merk == par.anz_merk) 
    d_orgs_old = d_orgs;
    zgf_y_bez  = [];
    
   
    d_orgs = zeros(size(d_orgs_old,3),size(d_orgs_old,2),1);
    
    for i_data = 1:size(d_orgs_old,3)
        zgf_y_bez(1,i_data).name = deblank(var_bez(i_data,:));
        d_orgs(i_data,:,:) = d_orgs_old(:,:,i_data)';
    end;
   
    if par.anz_einzel_merk == 0
        d_org   = zeros(size(d_orgs_old,3),0);
        dorgbez = '';
    else
        d_org   = d_org';
        dorgbez = 'Single feature';
    end;
    
    code    = [1:size(d_orgs_old,3)]';
    code_alle = code;
    var_bez = 'Time series';
    ind_auswahl = code;
    aktparawin;
else
    myerror('A conversion is impossible!')
end;
