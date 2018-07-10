  function [datenOut, ret, info] = plugin_wavedec(paras, datenIn)
% function [datenOut, ret, info] = plugin_wavedec(paras, datenIn)
%
% Berechnet eine Dekomposition mittels Wavelets
%
% The function plugin_wavedec is part of the MATLAB toolbox Gait-CAD. 
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

if exist('wavedec','file') == 0
   fprintf('The plugin wavedec can not be executed. The Wavelet toolbox was not found.\n');
   ret.ungueltig = 1;
   info=[];
   datenOut=[];
   return;
end;

info = struct('beschreibung', 'Wavedec',  'anz_em', 0, 'laenge_zr', paras.par.laenge_zeitreihe, 'typ', 'TS');
info.einzug_OK = 0; info.richtung_entfernen = 0;
info.anz_benoetigt_zr = 1;

info.commandline.description{1} = 'Wavelet';
info.commandline.parameter_commandline{1} = 1;
info.commandline.popup_string{1} = 'db1|db2|db3|db4|db5|db6|db7|db8|db9|db10|sym1|sym2|sym3|sym4|sym5|sym6|sym7|sym8|sym9|sym10|coif1|coif2|coif3|coif4|coif5';
info.commandline.tooltext{1} = 'defines the wavelet type.';

info.commandline.description{2} = 'Wavelets: number of levels';
info.commandline.parameter_commandline{2} = 4;
info.commandline.tooltext{2} = 'defines the number of levels.';
info.commandline.wertebereich{2} =  {1 Inf};

info.commandline.description{3} = 'Matlab wavelet decomposition';
info.commandline.parameter_commandline{3} = 1;
info.commandline.popup_string{3} = 'Matlab wavelet decomposition|customized implementation';
info.commandline.tooltext{3} = 'defines the used implementation.';

if isfield(paras,'parameter_commandline')
   temp = ['|' info.commandline.popup_string{1} '|'];
   ind_trenn = find(temp=='|');
   paras.parameter.gui.zeitreihen.wavelets.typ = temp(ind_trenn(paras.parameter_commandline{1})+1:ind_trenn(paras.parameter_commandline{1}+1)-1);
   paras.parameter.gui.zeitreihen.wavelets.max_level = paras.parameter_commandline{2};
   paras.parameter.gui.zeitreihen.wavelets.matlab_wavedec = 2-paras.parameter_commandline{3};
end;


if (paras.parameter.gui.zeitreihen.wavelets.matlab_wavedec)
   anz_zr = paras.parameter.gui.zeitreihen.wavelets.max_level + 1;
   ret.bezeichner = sprintf('%s, Low %d', paras.parameter.gui.zeitreihen.wavelets.typ, paras.parameter.gui.zeitreihen.wavelets.max_level);
   for i = 1:anz_zr-1
      ret.bezeichner = strvcatnew(ret.bezeichner, sprintf('%s, High %d', paras.parameter.gui.zeitreihen.wavelets.typ, i));
   end;
else
   anz_zr = paras.parameter.gui.zeitreihen.wavelets.max_level*2;
   ret.bezeichner = [];
   for i = 1:anz_zr/2
      ret.bezeichner = strvcatnew(ret.bezeichner, sprintf('%s, High %d', paras.parameter.gui.zeitreihen.wavelets.typ, i));
   end;
   for i = 1:anz_zr/2
      ret.bezeichner = strvcatnew(ret.bezeichner, sprintf('%s, Low %d', paras.parameter.gui.zeitreihen.wavelets.typ, i));
   end;
end;

info.bezeichner = ret.bezeichner;
info.anz_zr = anz_zr;

if (nargin < 2 || isempty(datenIn))
   datenOut = [];
   ret = [];
   return;
end;

fA = paras.parameter.gui.zeitreihen.abtastfrequenz;
datenOut.dat_zr = zeros(size(datenIn.dat,1), size(datenIn.dat,2), anz_zr);

params.einheit = paras.parameter.gui.zeitreihen.einheit_abtastfrequenz_liste{paras.parameter.gui.zeitreihen.einheit_abtastfrequenz};

if (paras.parameter.gui.zeitreihen.wavelets.matlab_wavedec)
   params.fA = fA;
   
   
   for i = 1:size(datenIn.dat,1)
      [waves, bez] = matlab_wavedec(datenIn.dat(i,:)', paras.parameter.gui.zeitreihen.wavelets.typ, paras.parameter.gui.zeitreihen.wavelets.max_level, params);
      datenOut.dat_zr(i, :, :) = waves;
   end;
   % Passe die Bezeichner an:
   % Da es nur einen Kanal gibt (es ist nur eine Zeitreihe als Übergabe erlaubt),
   % einfach die ersten vier Zeichen entfernen (da steht "Ch1 ")
   ret.bezeichner = bez(:,6:end);
else
   for i = 1:size(datenIn.dat,1)
      [coeff, app] = dft_timesample (datenIn.dat(i, :), paras.parameter.gui.zeitreihen.wavelets.typ, paras.parameter.gui.zeitreihen.wavelets.max_level);
      % Kopiere die Ergebnisse in die Ausgabe
      datenOut.dat_zr(i, :, 1:paras.parameter.gui.zeitreihen.wavelets.max_level)      = coeff(:, 2:end);
      datenOut.dat_zr(i, :, paras.parameter.gui.zeitreihen.wavelets.max_level+1:end)  = app  (:, 2:end);
   end;
   
   % Passe die Bezeichner noch mal an:
   ret.bezeichner = [];
   for i = 1:anz_zr/2
      bounds = [fA/(2^(i+1))  fA/(2^i)];
      ret.bezeichner = strvcatnew(ret.bezeichner, sprintf('%s, Level %d (%3.1f - %3.1f %s)', paras.parameter.gui.zeitreihen.wavelets.typ, i, bounds(1), bounds(2),params.einheit));
   end;
   for i = 1:anz_zr/2
      bounds = [0  fA/(2^(i+1))];
      ret.bezeichner = strvcatnew(ret.bezeichner, sprintf('%s, Level %d (%3.1f - %3.1f %s)', paras.parameter.gui.zeitreihen.wavelets.typ, i, bounds(1), bounds(2),params.einheit));
   end;
end;

% Signalisiere, dass alle ok.
ret.ungueltig = 0;