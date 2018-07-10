  function [datenOut, ret, info] = plugin_zrhkem(paras, datenIn)
% function [datenOut, ret, info] = plugin_zrhkem(paras, datenIn)
%
% Berechne einige Hauptkomponenten der übergebenen Zeitreihe
% Plugin-Fkt für Gait-CAD.
%
% The function plugin_zrhkem is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:07
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

if isfield(paras,'parameter_commandline')
   anz_em = paras.parameter_commandline{1};   
else
   anz_em = 2;
end;


if (anz_em > paras.par.laenge_zeitreihe)
   fprintf(1,'Reducing number of principal components due to few sample points.\n');
   anz_em = paras.par.laenge_zeitreihe;
end;
bezeichner = strcat('PC', num2str([1:anz_em]'));
info = struct('beschreibung', 'TS->PC SF', 'bezeichner', bezeichner, 'anz_zr', 0, 'anz_em', anz_em, 'laenge_zr', 0, 'typ', 'SF');
info.einzug_OK = 1; 
info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;
info.anz_benoetigt_em = 0;
info.anz_im = 0;
info.anz_benoetigt_im = 0;
info.callback = '';

info.explanation = 'computes new single features using a Principal Component Analysis of a time series or a time series segment (K -> $s_d$).';

info.commandline.description{1} = 'Number of aggregated PCA features';
info.commandline.parameter_commandline{1} = 2;
info.commandline.tooltext{1} = 'Number s_d of principal components from a time series (Transformation number of sample points K -> s_d)';
info.commandline.wertebereich{1} =  {1 Inf };

info.commandline.description{2} = 'Normalize standard deviations';
info.commandline.parameter_commandline{2} = 2;
info.commandline.popup_string{2} = 'yes|none';
info.commandline.tooltext{2} = 'defines the normalization for the variances of the sample points';



if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

normierung = 2-paras.parameter_commandline{2};

%sollen die HKs neu berechnet werden?
switch paras.parameter.gui.zeitreihen.plugin_features_design
   case{1,2} %Berechnen
      [phi_hkm,hkvp,sigma]=hauptk_ber(datenIn.dat(paras.ind_auswahl,:), normierung);
      if (anz_em > size(phi_hkm,2))
         mywarning(sprintf('Error! Not enough principal components computed.\nA possible reason are segments with different lengths.\nPlease try only one segment definition in *.einzug.'));
         datenOut.dat_em = zeros(size(datenIn.dat,1), anz_em);
         ret.ungueltig = 1;
         return;
      end;
      phi_hk=phi_hkm(:,1:anz_em);
      if paras.parameter.gui.zeitreihen.plugin_features_design == 2
         %Berechnen und Speichern
         update_plugin_features(paras,phi_hk,info,'save_parameter');
      end;
   case 3
      %Laden
      [phi_hk,info] = update_plugin_features(paras,[],info,'load_parameter');
end;

datenOut.dat_em = datenIn.dat*phi_hk;

%correct number of features, if necessary
info.anz_em = size(phi_hk,2);
ret.bezeichner = info.bezeichner(1:info.anz_em,:);
ret.ungueltig = 0;
