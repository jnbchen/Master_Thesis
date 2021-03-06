% Script deselect_missing_dp
%
% deselects data points with inf or nans in the selected time series or single features
% 
%
% The script deselect_missing_dp is part of the MATLAB toolbox Gait-CAD. 
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

switch mode_nan_inf 
case 'SF'
   %isnan or inf for the selected data point and single features
   ind_missing = find(any(isinf(d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em)) | isnan(d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em)) ,2)); % Coderevision: &/| checked!
   
   case 'TS'
   %isnan or inf for the selected data point and time series
   ind_missing = find(max(any(isinf(d_orgs(ind_auswahl,:,parameter.gui.merkmale_und_klassen.ind_zr)) | isnan(d_orgs(ind_auswahl,:,parameter.gui.merkmale_und_klassen.ind_zr)) ,2),[],3)); % Coderevision: &/| checked!
  
end;   

%deselect from selected data points
if ~isempty(ind_missing) 
   ind_auswahl(ind_missing) = [];
end;

%clean up and update project
clear ind_missing mode_nan_inf
aktparawin;
