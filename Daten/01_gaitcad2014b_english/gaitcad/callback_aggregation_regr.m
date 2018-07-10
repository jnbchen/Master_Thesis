% Script callback_aggregation_regr
%
% The script callback_aggregation_regr is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

regr_single.merkmalsextraktion.norm_aggregation.type=0;
regr_single.merkmalsextraktion.phi_aggregation=[];
%erzeuge_datensatz_an(d_org,regr_single.merkmalsextraktion);

switch aggregation_mode
   case 1	%Hauptkomponentenanalyse
   %Hauptkomponentenanalyse ohne Normieurng in hauptk_ber; Normierung erfolgt in erzeuge_datensatz
   parameter.gui.regression.anz_hk=min(parameter.gui.regression.anz_hk,size(d,2));
   [phi_hk,hkvp,sigma]=hauptk_ber(d,-1);
   phi_hk=phi_hk(:,1:parameter.gui.regression.anz_hk);
   phi_aggregation = phi_hk;
   phi_text=sprintf('Principal Component Analysis (PCA) from %d to %d aggregated features',size(phi_hk));
   phi_short = 'PCA';
case 2 % Mittelwert
   phi_aggregation=ones(size(d,2),1)/size(d,2);
   phi_text = sprintf('Mean value from %d features',size(d,2));
   phi_short = 'MEAN';
case 3 % Summe
   phi_aggregation=ones(size(d,2),1);
   phi_text = sprintf('Sum of %d features',size(d,2));
   phi_short = 'SUM';
end
%Entwurfsergebnisse Aggregation speichern
if (aggregation_mode)
   tmp=[];
   for i=1:size(phi_aggregation,2)
      tmp=strvcatnew(tmp,sprintf('%d. Aggregated Feature (%s)',i,phi_short));
   end;
   
   %Leerzeichen! 
   regr_single.merkmalsextraktion.var_bez = tmp;
   clear varbez_aggregation;
   
   regr_single.merkmalsextraktion.phi_aggregation = phi_aggregation;
   regr_single.merkmalsextraktion.phi_text = phi_text;
else 
   regr_single.merkmalsextraktion.phi_aggregation=[];
end;


clear aggregation_mode