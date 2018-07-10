  function plot_lp_detection(daten_orig, klass_single, ausreisser, parameter, plot_params, anzeige_modus, farbig, aufloesung)
% function plot_lp_detection(daten_orig, klass_single, ausreisser, parameter, plot_params, anzeige_modus, farbig, aufloesung)
%
%  Funktion für das Zeichnen der Ausreißer-Detektion.
%  Wird eigentlich nur von callback_ausreisser_an verwendet.
%  Eingaben:
%  daten_orig: Daten, auf die die Ausreißerdetektion angewendet wurde
%  klass_single: klass_single-Strukt von Gait-CAD
%  ausreisser: Ergebnis-Strukt von ausreisser_detektion_an auf Lerndaten
%  parameter: Parameter-Strukt für die Klassifikation von Ausreißern (siehe ausreisser_detektion_en)
%  plot_params: default: [], enthält folgende Felder:
%  plot_params.min_1: Optional, Minimum der ersten Dimension
%  plot_params.min_2: Optional, Minimum der zweiten Dimension
%  plot_params.max_1: Optional, Maximum der ersten Dimension
%  plot_params.max_2: Optional, Maximum der zweiten Dimension
%  plot_params.nur_grenzen: Zeichnet nur die Klassengrenzen, ohne irgendwelche Ergebnisse einzutragen
%  anzeige_modus: 1 nur Ergebnis der Lerndaten anzeigen, 2: Höhenlinien der Entscheidungsfunktion anzeigen
%  3: nur die Klassengrenze (Höhenlinie des Schwellwertes), (default: 1)
%  farbig: 1: farbige Anzeige, 0: schwarz/weiß
%  aufloesung: wie viele Gitterpunkte sollen für die Anzeige verwendet werden (default: 40)
% 
%
% The function plot_lp_detection is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 5)
   plot_params = [];
end;
if (nargin < 6)
   anzeige_modus = 1;
end;
if (nargin < 7)
   farbig = 1;
end;
if (nargin < 8)
   aufloesung = 40;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nur vorhandene Daten oder Höhenlinien einzeichnen?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (anzeige_modus > 1)
   daten_post = daten_orig;
   % Nicht direkt bei Minimum und Maximum anfangen, sondern noch ein wenig links und rechts dazu packen
   if (isfield(plot_params, 'min'))
      min_1 = plot_params.min(1);
      min_2 = plot_params.min(2);
   else
      min_1 = min(daten_post(:,1));
      min_2 = min(daten_post(:,2)); 
   end;
   if (isfield(plot_params, 'max'))
      max_1 = plot_params.max(1);
      max_2 = plot_params.max(2);
   else
      max_1 = max(daten_post(:,1));
      max_2 = max(daten_post(:,2));
   end;
   min_1 = min_1 - sign(min_1)*0.2*min_1; max_1 = max_1 + sign(max_1)*0.2*max_1;
   min_2 = min_2 - sign(min_2)*0.2*min_2; max_2 = max_2 + sign(max_2)*0.2*max_2;
   % Nun erhöhe die Dichte des Rasters
   a= min_1:(max_1-min_1)/(aufloesung):max_1;	
   b= min_2:(max_2-min_2)/(aufloesung):max_2;
   ag= a'*ones(1,length(b)); ag=ag'; bg=b'*ones(1,length(a));
   daten_post=[ag(:) bg(:)]; 
   
   % Algorithmus auf die vielen Daten anwenden.
   %[h_ausreisser, h_f] = lp_ausreisser_detection_an(daten_post, lp_detect);
   [h_ausreisser] = ausreisser_detektion_an(daten_post, parameter, klass_single);
   f_loes = h_ausreisser.werte;
   if (~isempty(f_loes))
      % Höhenlinien zeichnen:
      % Die Daten liegen in einem Vektor vor, contour benötigt eine Matrix.
      % Also die Dimensionen etwas anpassen:
      contour_f_loes = zeros(length(a), length(a));
      count = 1;
      for i = 1:length(a)
         for j = 1:length(a)
            contour_f_loes(i, j) = f_loes(count);
            count = count + 1;
         end;
      end;
      % Sollen nur die reinen Klassengrenzen angezeigt werden? Dann nur die Höhenlinie für 0 zeichnen.
      % Die Parametrierung von contour ist dann ein wenig anders.
      if (abs(anzeige_modus) == 3)
         [c,h] = contour(a, b, contour_f_loes', [parameter.schwelle parameter.schwelle]); set(h, 'LineWidth', 1.5, 'EdgeColor', [0 0 0]);
      else
         if (~plot_params.diskret)
            [c,h] = contour(a, b, contour_f_loes', 'LineSpec', 'k-'); clabel(c,h);
         else
            temp = unique(f_loes);
            % Nicht alle, sondern erst ab dem Schwellwert verwenden:
            temp = temp(temp <= parameter.schwelle);
            % Nur ein Wert ist nicht erlaubt:
            if (length(temp) == 1)
               temp = [temp temp];
            end;
            [c,h] = contour(a, b, contour_f_loes', temp); 
            set(h, 'LineWidth', 1, 'EdgeColor', [0 0 0]); 
            if ~isempty(c) 
               clabel(c,h);
            end;
            
         end; % if (~plot_params.diskret)
      end; % if (abs(anzeige_modus) == 3)
   end;
   hold on;
end;
if (~isfield(plot_params, 'nur_grenzen') || ~plot_params.nur_grenzen)
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Hier die eigentlich zu prüfenden Daten in die Abbildung eintragen.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Angewendete Daten eintragen:
   % Zunächst die, die nicht als Ausreißer erkannt wurden (bekommen Farbe grün)
   [col,sty] = color_style;
   rest = setxor(ausreisser.indx, [1:size(daten_orig,1)]);
   if (farbig)
      r = plot(daten_orig(rest, 1), daten_orig(rest,2), '*', 'Color', col(1,:));
   else
      r = plot(daten_orig(rest, 1), daten_orig(rest,2), 'k.', 'Marker', sty(1,:));
   end;
   if (~isempty(r))
      hndls = r; leg_str = 'Class';
   else
      hndls = []; leg_str = [];
   end;
   % Anschließend die Ausreißer mit Rot.
   if (~isempty(ausreisser))
      hold on;
      if (farbig)
         r = plot(daten_orig(ausreisser.indx,1), daten_orig(ausreisser.indx,2), '*', 'Color', col(2,:));
      else
         r = plot(daten_orig(ausreisser.indx,1), daten_orig(ausreisser.indx,2), 'k.', 'Marker', sty(2,:));
      end;
      if (~isempty(r))
         hndls = [hndls r]; leg_str = strvcatnew(leg_str, 'Outlier');
      end;
   end;
   % Zum Schluß noch die Legende anzeigen.
   legend(hndls, leg_str);
   
   xlabel(deblank(klass_single(1).merkmalsextraktion.var_bez(1,:)));
   ylabel(deblank(klass_single(1).merkmalsextraktion.var_bez(2,:)));
   switch(parameter.verfahren)
   case 1
      if (~isempty(parameter.one_class.lambda))
         title(sprintf('\\lambda: %d, \\sigma: %f', parameter.one_class.lambda, parameter.one_class.kernel_parameter));
      else
         title(sprintf('\\sigma: %f', parameter.one_class.kernel_parameter));
      end;
   end;
end;
