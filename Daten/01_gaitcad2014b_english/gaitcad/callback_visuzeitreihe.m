% Script callback_visuzeitreihe
%
% The script callback_visuzeitreihe is part of the MATLAB toolbox Gait-CAD. 
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

if (mode>1 ) && isempty(my)
   % Merkmale,Berechnung Mittelwertskurve (EM+ZR) 
   merk_figure=gcf;
   [my,mstd,tmp,my_em,mstd_em]=plotmeanstd(d_orgs(ind_auswahl,:,:),code(ind_auswahl),d_org(ind_auswahl,:));
   figure(merk_figure);
end;

%Makro mit neuen Bildern?
%RALF: TRICK für Aufruf visu_zeitreihe, um mit Tobis komischen vorbereiteten Optionen und Bilder-Ausschalten bei Makros umgehen zu können:
%newfigureintern==0: Normalmodus: draußen nichts vorbereitet, neues Bild
%newfigureintern==1: alle Merkmale draußen vorbereitet, keine Bilder
%newfigureintern==2: draußen nichtts vorbereitet, keine Bilder
newfigureintern=2*parameter.gui.anzeige.aktuelle_figure;

nosubplots = 1-parameter.gui.anzeige.zr_in_subplots;
% Stelle den Parameter intern um, wenn nur eine Zeitreihe angezeigt werden soll.
if (length(parameter.gui.merkmale_und_klassen.ind_zr) == 1)
   nosubplots = 0;
end;
% d_orgs, code und zgf_y_bez müssen umgebaut werden
if (nosubplots)
   
   if (length(ind_auswahl)>1) && (parameter.gui.zeitreihen.image_plot >0) 
      myerror('Only one data point can be shown for image plots without subplots!');
   end;
   
   
   merk_auswahl_tmp = parameter.gui.merkmale_und_klassen.ind_zr;
   nosubplots = ind_auswahl;
   
   % d_orgs wird so umgebastelt, dass nicht mehr die Realisierungen in der ersten Dimension stehen,
   % sondern die ausgewählten Zeitreihen. In der zweiten Dimension stehen dann die Realisierungen.
   % In code wird die Auswahl der Merkmale geschrieben, zgf_y_bez muss ebenfalls angepasst werden.
   d_orgs_nosubplot = zeros(length(merk_auswahl_tmp), size(d_orgs,2), size(d_orgs,1));
   % Keine Ahnung, mit welchem Befehl man die Dimensionen vertauschen kann. rot90, flipdim, reshape schienen nicht
   % das zu tun, was ich will...
   for i = 1:size(d_orgs_nosubplot,1)
      d_orgs_nosubplot(i, :, :) = squeeze(d_orgs(:, :, merk_auswahl_tmp(i)))';
   end;
   % Der code-Vektor ist nun einfach [1:size(d_orgs,1)].
   code_nosubplot = [1:size(d_orgs_nosubplot,1)];
   % zgf_y_bez muss ebenfalls verändert werden. An die Stelle der ausgewählten Klasse müssen die
   % verschiedenen Bezeichner aus var_bez:
   nr_ausgangsgroesse = parameter.gui.merkmale_und_klassen.ausgangsgroesse;
   % Bezeichner aus var_bez extrahieren
   g = var_bez(merk_auswahl_tmp, :);
   g_c = cellstr(g);
   [zgf_y_bez_nosubplot(nr_ausgangsgroesse, 1:length(code_nosubplot)).name] = deal(g_c{:});
   
   % ind_auswahl muss auch umgebogen werden:
   ind_auswahl_nosubplot = [1:size(d_orgs_nosubplot,1)];
   
   if (mode>1) 
      mywarning ('WARNING! Option works only for original data');
      %my_save=my;
      %myst_save=mstd;
      %my=mean(); ???
      %mstd=std(); ???
   end;
   mode=1;
   
else
   nosubplots = [];
end;



linienstaerke = parameter.gui.anzeige.linienstaerke;
switch mode
case 1
   %Originaldaten
   if isempty(nosubplots)
      visu_zeitreihe(d_orgs(ind_auswahl,:,:),code(ind_auswahl),var_bez,zgf_y_bez,parameter,par,'Original time series',titelzeile,ref,parameter.gui.anzeige.anzeige_normdaten,ind_auswahl,0,newfigureintern,'',parameter.gui.anzeige.anzeige_grafiken, linienstaerke, [], nosubplots );
   else
      visu_zeitreihe(d_orgs_nosubplot(ind_auswahl_nosubplot,:,:),code_nosubplot(ind_auswahl_nosubplot),var_bez,zgf_y_bez_nosubplot,parameter,par,'Original time series',titelzeile,ref,parameter.gui.anzeige.anzeige_normdaten,ind_auswahl_nosubplot,0,newfigureintern,'',parameter.gui.anzeige.anzeige_grafiken, linienstaerke, [], nosubplots );
   end;
case 2
   %Mittelwerte
   visu_zeitreihe(my,findd(code(ind_auswahl)),var_bez,zgf_y_bez,parameter,par,'Mean',titelzeile,ref,parameter.gui.anzeige.anzeige_normdaten, 0, 0, newfigureintern, '', parameter.gui.anzeige.anzeige_grafiken, linienstaerke, [], nosubplots);
case 3
   %Streuungen
   %bei Streuungen irritiert die Norm nur, daher immer Null
   visu_zeitreihe(mstd,findd(code(ind_auswahl)),var_bez,zgf_y_bez,parameter,par,'STD',titelzeile,ref,parameter.gui.anzeige.anzeige_normdaten,0, 0, newfigureintern, '', [], linienstaerke, [], nosubplots);
case 4
   %Mittelwerte und Streuungen
   visu_zeitreihe([my;my+mstd;my-mstd],[findd(code(ind_auswahl)) findd(code(ind_auswahl)) findd(code(ind_auswahl))],var_bez,zgf_y_bez,parameter,par,'Mean values and standard deviations',titelzeile,ref,parameter.gui.anzeige.anzeige_normdaten,0,1, newfigureintern, '', [], linienstaerke, [], nosubplots);
end;

% Originalzustand wieder herstellen.
if (~isempty(nosubplots))
  
   % Speicher wieder frei machen
   clear d_orgs_nosubplot code_nosubplot zgf_y_bez_nosubplot ind_auswahl_nosubplot;
   
end;


