% Script fuzdiscr_for_plugin
%
% sollen die HKs neu berechnet werden?
%
% The script fuzdiscr_for_plugin is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:06
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

switch paras.parameter.gui.zeitreihen.plugin_features_design
case{1,2} %Berechnen
   %design of membership functions (using all GUI parameters of fuzzy systems)
   zgf = zgf_en(datenIn.dat(:),paras.parameter.gui.klassifikation.fuzzy_system);
   
   if paras.parameter.gui.zeitreihen.plugin_features_design == 2
      %Berechnen und Speichern
      update_plugin_features(paras,zgf,info,'save_parameter');
   end;
case 3
   %Laden
   paras.ignore_segments = 1;
   [zgf,info] = update_plugin_features(paras,[],info,'load_parameter');
end;



%prepare matrix for fuzzy and qualitative values
d_fuz   = zeros(size(datenIn.dat,1),size(datenIn.dat,2),length(zgf));
d_quali = zeros(size(datenIn.dat,1),size(datenIn.dat,2));

%fuzzify time series
for i_dat = 1:size(datenIn.dat,1)
   [temp1,temp2]= fuzz(datenIn.dat(i_dat,:)',zgf);
   d_fuz(i_dat,:,:) = temp1;
   d_quali(i_dat,:) = temp2';
end;



%find alpha cuts 0.5 limits for MBFs
zgf_krit = mean([zgf(1:end-1);zgf(2:end)]);

%term names
switch mode_fuzzy_plugin_em
case 'SF'
   %extract 
   bezeichner = sprintf(' TERM 1 (< %g)', zgf_krit(1));
   for i=2:length(zgf)-1
      bezeichner = strvcatnew(bezeichner,sprintf(' TERM %d (%g ... %g)', i,zgf_krit(i-1:i)));
   end;
   bezeichner = strvcatnew(bezeichner,sprintf(' TERM %d (> %g)', length(zgf),zgf_krit(end)));
   
   bezeichner = strcat(mode_fuzzy_plugin_em_aggr,bezeichner);
   switch mode_fuzzy_plugin_em_aggr
   case 'MEAN'
      datenOut.dat_em = squeeze(mean(d_fuz,2));
   case 'MEAN SEQ2'
      datenOut.dat_em = zeros(size(d_fuz,1),anz_em^2);
      k=0;
      for i_em1=1:anz_em
         for i_em2 = 1:anz_em
            k=k+1;
            temp = squeeze(d_fuz(:,1:end-1,i_em1) .* d_fuz(:,2:end,i_em2));
            datenOut.dat_em(:,k) = mean(temp,2);
         end;
      end;
      
   case 'MEAN DISCR'
      datenOut.dat_em = hist(d_quali',1:length(zgf))'/size(d_quali,2);
   case 'MEAN DISCR TS'
      datenOut.dat_zr = d_quali;
   end;  
end;

