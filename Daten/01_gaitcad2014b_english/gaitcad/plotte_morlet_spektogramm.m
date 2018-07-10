  function plot_spect = plotte_morlet_spektogramm(daten, code, params)
% function plot_spect = plotte_morlet_spektogramm(daten, code, params)
%
%  Berechnet ein Spektogramm mit Hilfe von Morlet-Wavelets.
%  Wird mehr als ein Datentupel übergeben, wird automatisch der Klassenmittelwert
%  berechnet. Ansonsten wird das Spektogramm eines einzelnen Datentupels zurückgegeben.
%  Neben der Rückgabe wird das Spektogramm auch geplottet.
%  Eingaben:
%  daten: Datenmatrix, Dimension #Datentupel x #Abtastpunkte x #Zeitreihen
%  code: Vektor mit Klassencodes (Länge: #Datentupel)
%  params: Parameterstrukt mit folgenden Feldern:
%  - freqs: Frequenzen, die verwendet werden sollen (default: 1:20)
%  - omega0: Eigenfrequenz des Morlet-Wavelets (default: 6)
%  - relativ: Wenn 1, werden die Frequenzen relativ zu einer Baseline berechnet, sonst
%  bleiben die absoluten Werte erhalten (default: 0)
%  - baseline: Abtastpunkte der Baseline (default: [1:#Abtastpunkte])
%  - iir_param: Parameter für die IIR-Filterung des Morlet-Ergebnisses (default: 0.99)
%  - fA: Abtastfrequenz der Originaldaten (default: 100)
%  - red_sample: Reduktion der Abtastpunkte, um etwas kleinere Grafik zu erhalten (default: 1)
%  - var_bez: Bezeichner der Zeitreihen (default: [])
%  Ausgabe:
%  - plot_spect: Cell-Array mit Spektogrammen.
%  Dimension des Cell-Array: #Klassen (oder 1) x #Zeitreihen x #3
%  Das Cell-Array enthält Matrizen mit folgendem Inhalt:
%  plot_spect(:, :, 1): Matrix mit den berechneten Morlet-Koeffizienten
%  (Dimension #Frequenzen x #Abtastpunkte)
%  plot_spect(:, :, 2): Vektor mit übergebenen Frequenzen
%  plot_spect(:, :, 3): Vektor mit vorhandenen Zeitpunkten
%
% The function plotte_morlet_spektogramm is part of the MATLAB toolbox Gait-CAD. 
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

if ~isfield(params, 'freqs')
   params.freqs = [1:20];
end;
if ~isfield(params, 'omega0')
   params.omega0 = 6;
end;
if ~isfield(params, 'relativ')
   params.relativ = 0;
end;
if ~isfield(params, 'baseline')
   params.baseline = [1:size(daten,2)];
end;
if ~isfield(params, 'iir_param')
   params.iir_param = 0.99;
end;
if (~isfield(params, 'fA'))
   params.fA = 100;
   mywarning('Unknown sampling frequency, 100 Hz are assumed');
end;
if ~isfield(params, 'var_bez')
   params.var_bez = [];
end;
fA = params.fA;

% Reduziert die Anzahl der Abtastpunkte um die Grafik etwas kleiner zu machen (war 3):
if ~isfield(params, 'red_sample')
   params.red_sample = 1;
end;


kanaele = [1:size(daten,3)];

% Speicher für die Spektrogramme bereithalten:
cls = unique(code);
plot_spect = []; 
plot_spect = cell(length(cls), length(kanaele), 3);
% Für alle Kanäle die Waveletkoeffizienten berechnen und speichern.
glob_max = -Inf;
glob_min = Inf;
if (~params.plot_only)
   for k = 1:length(kanaele)
      org = squeeze(daten(1,:,kanaele(k)));
      morl_org = zeros(size(daten,1), size(daten,2), length(params.freqs));
      for fr = 1:length(params.freqs)
         for ds = 1:size(daten,1)
            sig = squeeze(daten(ds, :, k));
            fil = morlet_filterung(sig, fA, params.freqs(fr), params.omega0, 1);
            morl_org(ds, :, fr) = IIRFilter(fil, params.iir_param, fil(1));
         end;
      end;
      % Hier zunächst die Daten normieren! Darf nicht unten  bei der Berechnung der Klassenmittelwerte geschehen, da durch
      % unterschiedliche Normierungen einige Effekte zerstört werden können!
      % matrix_normieren kann keine 3D-Matrizen normieren (und haut mir den Speicher um die Ohren)
      %[dummy, par1, par2] = matrix_normieren(morl_org(:), 2); clear dummy;
      %morl_org = matrix_normieren(morl_org, 2, myResizeMat(par1, 1, size(morl_org, 2)), myResizeMat(par2, 1, size(morl_org,2)));
      par1 = min(morl_org(:)); par2 = max(morl_org(:));
      morl_org = (morl_org - par1) ./ (par2-par1);
      
      if (size(morl_org,1) > 1)
         % Bilde die Mittelwerte über die erste Dimension:
         for cl = 1:length(cls)
            indx = find(code==cls(cl));
            % Berechne die Mittelwerte
            morl_org_mean = squeeze(mean(morl_org(indx, :, :)));
            if (params.relativ)
               % Hier Verhältnisse zu einer Baseline bestimmen.
               % Probleme können Werte über 100% bereiten. Die werden hier einfach auf
               % 100% gerundet, ist aber ebenfalls nicht unproblematisch (vor allem bei ERS)
               for i = 1:size(morl_org_mean,2)
                  mean_bis_trigger = mean(morl_org_mean([params.baseline(1):params.baseline(end)], i));
                  morl_org_mean(:, i) = morl_org_mean(:, i) ./ mean_bis_trigger;
                  if (max(morl_org_mean(:, i)) > glob_max)
                     glob_max = max(morl_org_mean(:,i));
                  end;
                  if (min(morl_org_mean(:, i)) < glob_min)
                     glob_min = min(morl_org_mean(:, i));
                  end;
                  %morl_org_mean(morl_org_mean(:,i) > 1, i) = 1;
               end;
            end;
            %[dummy, par1, par2] = matrix_normieren(morl_org_mean(:), 2);
            %morl_org_mean = matrix_normieren(morl_org_mean, 2, myResizeMat(par1, 1, size(morl_org_mean, 2)), myResizeMat(par2, 1, size(morl_org_mean, 2)));
            % und speichere sie...
            plot_spect{cl, k, 1} = morl_org_mean(1:params.red_sample:end, :)';
            plot_spect{cl, k, 2} = params.freqs;
            plot_spect{cl, k, 3} = (params.start_time + [0:params.red_sample:size(morl_org_mean,1)-1])./fA;
         end;
      else
         if (params.relativ)
            mean_bis_trigger = mean(squeeze(morl_org(1, [params.baseline(1):params.baseline(end)], :)))';
            for i = 1:size(morl_org,2)
               morl_org(1, i, :) = squeeze(morl_org(1, i, :)) ./ mean_bis_trigger;
            end;
         end; % if (params.relativ)
         
         plot_spect{1, k, 1} = squeeze(morl_org(1, 1:params.red_sample:end, :))';
         plot_spect{1, k, 2} = params.freqs;
         plot_spect{1, k, 3} = (params.start_time + [0:params.red_sample:size(morl_org,2)-1])./fA;
         if (max(plot_spect{1, k, 1}(:)) > glob_max)
            glob_max = max(plot_spect{1, k, 1}(:));
         end;
         if (min(plot_spect{1, k, 1}(:)) < glob_min)
            glob_min = min(plot_spect{1, k, 1}(:));
         end;
      end;
      clear fil morl_org morl_org_mean freq_erg;
   end;
else
   plot_spect = params.morlet_plot_spect;
end; % if (~params.plot_only)

param = params.param;
if (isempty(param.caxis))
   % Das Minimum und Maximum liegt nicht vor. Es muss also neu berechnet werden:
   if isnan(glob_min) || isinf(glob_min)
      glob_min = Inf; glob_max = -Inf;
      % Für alle Klassen
      for cl = 1:size(plot_spect,1)
         % Für alle Zeitreihen
         for k = 1:size(plot_spect,2)
            min_ = min(plot_spect{cl, k, 1}(:));
            max_ = max(plot_spect{cl, k, 1}(:));
            if (min_ < glob_min)
               glob_min = min_;
            end;
            if (max_ > glob_max)
               glob_max = max_;
            end;
         end; % for(cl = 1:size(morlet_plot_spect,1))
      end; % for(k = 1:size(morlet_plot_spect,2))
   else
      color_axis_min = glob_min - 0.05*glob_min;
      color_axis_max = glob_max + 0.05*glob_max;
      param.caxis = [color_axis_min color_axis_max];
   end; % if (isnan(glob_min) || isinf(glob_min))
end; % if (isempty(param.caxis))
berechneSpektogramm([], param, -1, params.var_bez, num2str(cls), 0, plot_spect);
