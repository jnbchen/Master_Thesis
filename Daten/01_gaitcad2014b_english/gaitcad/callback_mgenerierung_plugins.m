% Script callback_mgenerierung_plugins
%
% The script callback_mgenerierung_plugins is part of the MATLAB toolbox Gait-CAD. 
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

merk_red = parameter.gui.klassifikation.merk_red;
if (parameter.gui.ganganalyse.einzug_links_rechts)
	% Folgendes ist nur für Ganganalyse nötig!
   if isempty(code_zr) || isempty(zgf_zr_bez)
      %myerror('Can not find categories! Please start a new computation!');
      % Kategorie,ZR berechnen 
      eval(get(uihd(6,5),'callback'));
   end;
   % Besorge die linken und rechten Seiten.
   [leftright,subplotid,variante]=aufloesung_gait_kategorien(code_zr,zgf_zr_bez);
   
   merk_uihd = figure_handle(2:4,:);
   % Indizes der zu verwendenen Merkmale:
   ind_merkmale=get(merk_uihd(1,1),'value');
   
   % Suche die linken Zeitreihen heraus:
   indxLeft = find(leftright(ind_merkmale) == 2);
   if (~isempty(indxLeft))
      ind_merkmale_left = ind_merkmale(indxLeft);
      % Auswahl des Listenfeldes verändern:
      set(merk_uihd(1,1), 'value', ind_merkmale_left);
      % Nur die linken Einzüge übergeben
      u_einzuege_plugins = plugins.einzuege_plugins.links;
      [d_org,var_bez,dorgbez,par,merk,ref,categories]=merkmalsgenerierung_plugins(merk_uihd, plugins.mgenerierung_plugins, u_einzuege_plugins, d_org,var_bez,dorgbez,par,merk,ref,bez_code(par.y_choice,:),code, code_alle, merk_red, ind_auswahl, parameter,categories);
   end;
   
   
   % Suche die rechten Zeitreihen heraus:
   indxRight = find(leftright(ind_merkmale) == 1);
   if (~isempty(indxRight))
      ind_merkmale_right = ind_merkmale(indxRight);
      % Auswahl des Listenfeldes verändern:
      set(merk_uihd(1,1), 'value', ind_merkmale_right);
      % Nur die linken Einzüge übergeben
      u_einzuege_plugins = plugins.einzuege_plugins.rechts;
      [d_org,var_bez,dorgbez,par,merk,ref,categories]=merkmalsgenerierung_plugins(merk_uihd, plugins.mgenerierung_plugins, u_einzuege_plugins, d_org,var_bez,dorgbez,par,merk,ref,bez_code(par.y_choice,:),code, code_alle, merk_red, ind_auswahl, parameter,categories);
   end;
   
   % Wieder auf komplette Auswahl setzen.
   set(merk_uihd(1,1), 'value', ind_merkmale);
   
   % Warne vor unbekannten Zeitreihen:
   indxUnb = find(leftright == 0);
   if (~isempty(indxUnb))
      mywarning('Could not handle time series with unknown side!');
   end;
else
   merk_uihd = figure_handle(2:4,:);
   [d_org,var_bez,dorgbez,par,merk,ref,categories]=merkmalsgenerierung_plugins(merk_uihd, plugins.mgenerierung_plugins, plugins.einzuege_plugins, d_org,var_bez,dorgbez,par,merk,ref,bez_code(par.y_choice,:),code, code_alle, merk_red, ind_auswahl, parameter,categories);
end;

clear merk_red;