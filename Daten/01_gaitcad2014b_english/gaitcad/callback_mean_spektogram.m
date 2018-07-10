% Script callback_mean_spektogram
%
% Berechnet und plottet das Spektogramm für die ausgewählten Zeitreihen.
% Dabei wird über die gewählte Klasse oder die gewählten Datentupel gemittelt
% Das Ergebnis wird in mspect gespeichert. Größe: #Frequenzen x #Zeitpunkte x #ZR x #Klassen (==1, wenn ds_mitteln = 1)
% ind_zr ist für die ausgewählten Zeitreihen.
%
% The script callback_mean_spektogram is part of the MATLAB toolbox Gait-CAD. 
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

ind_zr = parameter.gui.merkmale_und_klassen.ind_zr;

param.fA 						= parameter.gui.zeitreihen.abtastfrequenz;
param.fensterLaenge 			= parameter.gui.zeitreihen.fenstergroesse;
param.colormap					= parameter.gui.zeitreihen.colormap;
param.kennlinie_art 			= parameter.gui.zeitreihen.kennlinie;
if (param.kennlinie_art == 2)
   param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_wurzel;
elseif (param.kennlinie_art == 3)
   param.kennlinie_parameter	= parameter.gui.zeitreihen.exponent_exp;
end;
param.kennlinie_name 		= deblank(parameter.gui.zeitreihen.kennlinie_name(param.kennlinie_art,:));
param.colorbar_anzeigen		= parameter.gui.zeitreihen.plot_colorbar;
param.zeitverschiebung     = (parameter.gui.zeitreihen.segment_start-1)/parameter.gui.zeitreihen.abtastfrequenz;
param.x_beschrift          = ['Time [' char(parameter.gui.zeitreihen.einheit_abtastzeit_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];
param.y_beschrift          = ['Frequency [' char(parameter.gui.zeitreihen.einheit_abtastfrequenz_liste(parameter.gui.zeitreihen.einheit_abtastfrequenz)) ']'];




% Soll über alle Datentupel gemittelt werden?
if (ds_mitteln)
   mspect_cell = berechneSpektogramm(d_orgs(ind_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind_zr), param);
   % Nun rächt sich, dass ich damals Cell-Arrays benutzt habe.
   % Da kann man nämlich nicht so ohne weiteres Mitteln. Aber egal...
   % Bisher haben alle ZR die gleiche Dimension. Daher kann die Dimension
   % des Mittels mit dem ersten Cell-Array bestimmt werden
   mspect = zeros(size(mspect_cell{1,1,1},1), size(mspect_cell{1,1,1}, 2), length(ind_zr));
   for i = 1:size(mspect_cell,1)
      for j = 1:length(ind_zr)
         %vorsichtshalber NaNs entsorgen...
         mspect_cell{i, j, 1} (isnan(mspect_cell{i, j, 1})) = 0;
         
         mspect(:, :, j) = mspect(:, :, j) + mspect_cell{i, j, 1};
      end;
   end;
   mspect = mspect ./ length(ind_auswahl);
   
   % Das muss nun angezeigt werden. Auch hier wird wieder von einem Cell-Array ausgegangen
   plot_spect = cell(1, length(ind_zr), 3);
   for i = 1:length(ind_zr)
      plot_spect{1, i, 1} = mspect(:, :, i);
      plot_spect{1, i, 2} = mspect_cell{1, i, 2};
      plot_spect{1, i, 3} = mspect_cell{1, i, 3};
   end;
   clear mspect_cell;
   % Nun anzeigen
   berechneSpektogramm([], param, -1, [myResizeMat('Mean value ', length(ind_zr), 1) deblank(var_bez(ind_zr,:))], [], 0, plot_spect);
else % if (ds_mitteln)
   % Sonst suche die verschiedenen Klassen und berechne einzeln für die die Spektogramme:
   klassen = unique(code, 'rows');
   mspect = [];
   plot_spect = [];
   for k = 1:length(klassen)
      tmp_auswahl = find(code(ind_auswahl) == klassen(k));
      % Leere Klassen sollen abgefangen werden.
      if (~isempty(tmp_auswahl))
         mspect_cell = berechneSpektogramm(d_orgs(tmp_auswahl, parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende, ind_zr), param);
         if (isempty(mspect))
            mspect = zeros(size(mspect_cell{1,1,1},1), size(mspect_cell{1,1,1}, 2), length(ind_zr), length(klassen));
         end;
         for i = 1:size(mspect_cell,1)
            for j = 1:length(ind_zr)
               mspect(:, :, j, k) = mspect(:, :, j,k) + mspect_cell{i, j, 1};
            end;
         end;
         mspect(:, :, :, k) = mspect(:, :, :, k) ./ length(tmp_auswahl);
         
         % Das muss nun angezeigt werden. Auch hier wird wieder von einem Cell-Array ausgegangen
         if (isempty(plot_spect))
            plot_spect = cell(length(klassen), length(ind_zr), 3);
         end;
         
         for i = 1:length(ind_zr)
            plot_spect{k, i, 1} = mspect(:, :, i, k);
            plot_spect{k, i, 2} = mspect_cell{1, i, 2};
            plot_spect{k, i, 3} = mspect_cell{1, i, 3};
         end;
      end; % if (~isempty(tmp_auswahl))
   end; % for(k = 1:length(klassen))
   
   % Alle Klassen, die nicht vorhanden waren, wieder entfernen:
   plot_temp = plot_spect;
   plot_spect = []; plot_spect = cell(1,size(plot_temp,2),size(plot_temp,3));
   bez = [];
   count = 1;
   for k = 1:size(plot_temp,1)
      if (~isempty(plot_temp{k, 1, 1}))
         plot_spect(count, :, :) = plot_temp(k, :, :);
         bez = strvcatnew(bez, deblank(zgf_y_bez(par.y_choice, k).name));
         count = count + 1;
      end;
   end;
   % Nun den Befehl zum plotten geben. Als Bezeichner werden die Klassenbezeichner verwendet.
   berechneSpektogramm([], param, -1, [myResizeMat('Mean value ', length(ind_zr), 1) deblank(var_bez(ind_zr,:))], bez, 0, plot_spect);
   
   clear mspect_cell;
end; % if (ds_mitteln)

fprintf(1, 'Complete!\n');

% Anzeige-Menüpunkt freigeben
enmat = enable_menus(parameter, 'enable', 'MI_Spektrogramm_Anz');

clear ind_zr param;