  function [kkfs] = kreuzkorr_dt(d_orgs, dt_liste, zr_liste, params)
% function [kkfs] = kreuzkorr_dt(d_orgs, dt_liste, zr_liste, params)
%
% 
% 
%  Eingabe:
%  d_orgs: Matrix mit Daten der Dimension #Datentupel x #Abtastpunkte x #Zeitreihen
%  dt_liste: Liste mit Datentupeln, f�r die Korrelation berechnet werden soll
%  zr_liste: Liste mit Zeitreihen, f�r die Korrelation berechnet werden soll
%  params: Strukt mit:
%     .ausgabe: 1: KKF in Strukt zur�ckgeben, 0: KKF nicht zur�ckgeben (default: 1)
%     .plot: 0: nicht zeichnen, 1: zeichnen (default: 0)
%     .mean: 0: f�r jede Datentupel-Kombination einzeln ausgeben, 1: mitteln �ber die Kombinationen (default: 0)
%     .ta: Abtastzeit (default: 1)
% 
%  Die Funktion bestimmt f�r gleiche Zeitreihen die Korrelation dieser Zeitreihen f�r unterschiedliche
%  Datentupel. Die Datentupel stehen in dt_liste. Das erste Element in dt_liste stellt die Referenz dar.
%  F�r die Kombinationen der anderen Elemente mit der Referenz wird die Korrelation f�r jede Zeitreihe,
%  die in zr_liste steht, berechnet und optional angezeigt.
% 
%
% The function kreuzkorr_dt is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

if (nargin < 3)
   error('Too few parameters');
end;

% Default-Parameter festlegen, wenn undefiniert.
if (nargin < 4)
   params = [];
end;
if (~isfield(params, 'plot'))
   params.plot = 0;
end;
if (~isfield(params, 'mean'))
   params.mean = 0;
end;
if (~isfield(params, 'coeffs'))
   params.coeffs = 0;
end;
if (~isfield(params, 'tau'))
   params.tau = 0;
end;
if (~isfield(params, 'ta'))
   params.ta = 1;
end;
if (~isfield(params, 'ausgabe'))
   params.ausgabe = 1;
end;

kkfs = [];

if (all(size(dt_liste)~=1))
   dt_liste = dt_liste(:);
end;
if (size(dt_liste,1) == 1)
   dt_liste = dt_liste';
end;

% Bestimme die m�glichen Kombinationen
kombinationen = [dt_liste(1)*ones(length(dt_liste(2:end)),1) dt_liste(2:end)];
% Eintr�ge in den Kombinationen, bei denen die Spalten gleich sind, m�ssen entfernt werden.
%kombinationen(kombinationen(:,1) == kombinationen(:,2), :) = [];
if (isempty(kombinationen))
   return;
end;
nr_komb = size(kombinationen, 1);
% Bei sehr vielen Kombinationen und einzelner Ausgabe lieber noch mal nachfragen
zuviele = 10;
if  params.mean == 0 && (nr_komb * length(zr_liste) > zuviele)
   antwort = questdlg(sprintf('Compute CCF for %d data point combinations (%d per time series)?', ...
      nr_komb * length(zr_liste), nr_komb), 'Question', 'Yes', 'No', 'No');
   if (strcmp(antwort,'No'))
      return;
   end;
end;


count = 1;
mean_erg = [];
mean_count = 1;
% Gehe durch die gew�hlten Zeitreihen
for zr_c = 1:length(zr_liste)
   akt_zr = zr_liste(zr_c);
   % Und durch die einzelnen Kombinationen f�r Datentupel
   for k_c = 1:size(kombinationen,1)
      % Erzeuge die Datenmatrix
      data = [squeeze(d_orgs(kombinationen(k_c, 1), :, akt_zr))' squeeze(d_orgs(kombinationen(k_c, 2), :, akt_zr))'];
      % Wenn gezeichnet werden soll, muss die figure manuell ge�ffnet werden.
      if (params.plot && ~params.mean)
         h = figure;
      end;
      
      % Berechne die Kreuzkorrelation.
      [erg, zeit] = myxcorr(data, params.plot, [], [], [], params.ta,params.scaling_type);
      
      % Lege Titel usw. fest.
      if (params.plot && ~params.mean)
         if kombinationen(k_c, 1) == kombinationen(k_c, 2)
            set(gcf, 'NumberTitle', 'off', 'Name', sprintf('%d: Autocorrelation function  Time series %d, Data point %d', ...
               get_figure_number(h), akt_zr, kombinationen(k_c, 1)));
         else
            set(gcf, 'NumberTitle', 'off', 'Name', sprintf('%d: Cross Correlation Function time series %d, data point %d and %d', ...
               get_figure_number(h), akt_zr, kombinationen(k_c, 1), kombinationen(k_c, 2)));
         end;
      end;
      
      % Wenn gemittelt werden soll, dann addiere die einzelnen Ergebnisse.
      if (params.mean)
         if (isempty(mean_erg))
            mean_erg = erg;
         else
            mean_erg = mean_erg + erg;
            mean_count = mean_count + 1;
         end;
      end;
      
      % Sichere die Ausgabe, wenn der Parameter gesetzt ist. Au�erdem darf nicht der Mittelwert gebildet werden.
      % Daf�r gibt es weiter unten ein Extra-Block.
      if (params.ausgabe && ~params.mean)
         kkfs(count).zeitreihe   = akt_zr;
         kkfs(count).datentupel  = kombinationen(k_c, :);
         kkfs(count).kkf 			= erg;
         kkfs(count).zeit			= zeit;
         count = count + 1;
      end;
   end; % for(k_c = 1:size(kombinationen,1))
   
   % Die Ergebnisse f�r die aktuelle Zeitreihe mitteln, wenn gew�nscht.
   if params.mean
      mean_erg = mean_erg ./ mean_count;
      % Hier die Ausgabe vorbereiten.
      if (params.ausgabe)
         kkfs(count).zeitreihen = akt_zr;
         kkfs(count).datentupel = kombinationen;
         kkfs(count).kkf        = mean_erg;
         kkfs(count).zeit       = zeit;
      end; % if (params.ausgabe)
      % Und evtl. ausgeben.
      if params.plot
         figure;
         myxcorr([], 1, [], mean_erg, zeit, params.ta,params.scaling_type);
         set(gcf, 'NumberTitle', 'off', 'Name', sprintf('%d: CCF Time series %d, reference data point %d, mean for %d CCF', ...
            get_figure_number(gcf), dt_liste(1), length(dt_liste(2:end))));
      end;
   end; % if (params.mean)
end; % for(zr_c = 1:length(zr_liste))

