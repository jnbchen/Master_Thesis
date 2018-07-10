% Script callback_anzeige_zrmanova
%
% Welche Zeitreihen sind ausgewählt?
%
% The script callback_anzeige_zrmanova is part of the MATLAB toolbox Gait-CAD. 
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

tmp_zr_auswahl = parameter.gui.merkmale_und_klassen.ind_zr;

par_d_org=[length(ind_auswahl) length(tmp_zr_auswahl) 1 length(findd(code(ind_auswahl)))];
enmat = enable_menus(parameter, 'disable', {'MI_Anzeige_EM_Relevanzen', 'MI_Anzeige_EM_Relevanzen_un'});

merk_red = parameter.gui.klassifikation.merk_red;

if (mode == 1) % ANOVA
   gueteMerk = zeros(size(d_orgs,2),1);
else           %MANOVA
   gueteMerk = zeros(size(d_orgs,2),merk_red);
end;
alleMerk = zeros(size(d_orgs, 2), length(tmp_zr_auswahl));

%dient nur Anzeigezwecken
laengeDurch10 = round(size(d_orgs,2) / 10);

% Gehe über alle Abtastpunkte
for i = 1:size(d_orgs,2)
   
   %Merkmalsrelevanzen für i-ten Abtastpunkt berechnen
   tmp_d_org = squeeze(d_orgs(ind_auswahl, i, tmp_zr_auswahl));
   merkmal_auswahl_preselection = [];
   % Das Skript für die Generierung von Merkmalskarten kann bei der Verwendung von MANOVA
   % Merkmale vorauswählen. Die müssen dann als Preselection verwendet werden.
   if (mode ~= 1 && exist('rk', 'var') && isfield(rk, 'preselection') && ~isempty(rk.preselection))
      merkmal_auswahl_preselection = rk.preselection;
   end;
   % MANOVA,
   if (mode == 2)
      parameter_merkred.mode_bewertung = 4;
   else
      % ANOVA
      parameter_merkred.mode_bewertung = 3;
   end;
   parameter_merkred.par					 = par;
   parameter_merkred.par.par_d_org(1:4) = par_d_org;
   parameter_merkred.merkmal_vorauswahl = merkmal_auswahl_preselection;
   parameter_merkred.anzeige_details    = 0;
   parameter_merkred.merk_red				 = merk_red;
   
   %time series have never a priori relevances
   [merkmal_auswahl, merk, merk_archiv] = feature_selection (tmp_d_org, ...
      code(ind_auswahl,:), ...
      [], ...
      parameter_merkred);
   
   merk_red = length(merkmal_auswahl);
   
   clear parameter_merkred;
   guete = merk_archiv.merk_selection;
   
   %in Variablen schreiben
   if (~isempty(guete))
	   if (mode == 1)   
   	   gueteMerk(i,1) = guete(1);      
	   else
   	   gueteMerk(i,1:length(guete)) = guete;
      	gueteMerk(i,length(guete)+1:end) = guete(end);
	   end;
   
   	%alle Merkmale merken
      alleMerk(i,:) = merk';
   end;
   
   if (mod(i,laengeDurch10) == 0)
      fprintf(1, 'Sample point: %d of %d ready\n', i, size(d_orgs,2));
   end;
end;

% Ergebnis plotten?
if (plot_mode)
   figure;
   name_str = strtok(merk_archiv.verfahren,10);
   if (strcmp(name_str, 'Multivariate analysis') == 1)
      name_str = 'max. MANOVA value';
   elseif (strcmp(name_str,'Univariate analysis') == 1)
      name_str = 'max. ANOVA value';
   else
      name_str = ['max. value ' name_str];
   end;
   plot(gueteMerk); ylabel(name_str); 
   xlabel('Sample point');
   set(gcf, 'Name', sprintf('%d: %s',get_figure_number(gcf),name_str), 'NumberTitle', 'off'); 
   set(gca, 'XGrid', 'on', 'YGrid', 'on', 'XLim', [1 size(d_orgs,2)]);
   
   % Ist extrem unübersichtlich bei MANOVA. Plotten abschalten.
   if (mode == 1)
      % Alle ZR plotten
      figure;
      name_str = name_str(6:end);
      plot(alleMerk); 
      xlabel('Sample point');
      ylabel(name_str); 
      set(gcf, 'Name', [sprintf('%d: %s',get_figure_number(gcf),name_str) ' all selected time series'], 'NumberTitle', 'off'); 
      set(gca, 'XGrid', 'on', 'YGrid', 'on');
      legend_str = char( [myResizeMat('TS ', length(tmp_zr_auswahl), 1) num2str(tmp_zr_auswahl')] );
      [val, indx] = max(alleMerk, [], 1);
      text(indx, val, legend_str);
      xlim([1 size(d_orgs, 2)]);
   end;
else % if(plot_mode)
   % Wenigstens einen kurzen "Fertig"-Text anzeigen
   fprintf(1, 'Ready...\n');
end; % if (plot_mode)

%Gütewert in  die Oberfläche für ZR->EM Abtastpunkt schreiben
[temp,maxind]=max(gueteMerk(:,end));
set(uihd(11,65),'string',sprintf('%d',maxind));eval(get(uihd(11,65),'callback'));

% Speicher wieder aufräumen
clear name_str tmp_d_org par_d_org legend_str;