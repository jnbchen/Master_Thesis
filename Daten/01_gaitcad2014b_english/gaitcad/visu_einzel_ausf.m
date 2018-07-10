% Script visu_einzel_ausf
%
% zur Anzeige von Einzelmerkmalen
%
% The script visu_einzel_ausf is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

ind_em=parameter.gui.merkmale_und_klassen.ind_em; %Zeilenvektor mit allen ausgewählten Einzelmerkmalen
anz_em=length(ind_em); %Menge der aktivierten Einzelmerkmale
if (anz_em>100)
   mywarning('Please reduce the number of selected features!');
   return;
end;

%Makro mit neuen Bildern?
if parameter.gui.anzeige.aktuelle_figure
   %plot in recent figure for macro if desired
   %but not in the main Gait-CAD figure
   if gcf~=1
      fig_name=gcf;
   else
      fig_name=figure;
   end;
   newfigureintern=1;
else
   %make a new figure and guarantee the same for the next figures
   fig_name=figure;
   newfigureintern = 0;
end;

anz_f=max( floor((anz_em)/2), 1 ); %Anzahl der Koordinatensysteme, bei ungerader Anzahl gibt es ein 3D Bild

spalten=ceil(sqrt(anz_f));
zeilen=ceil(anz_f/spalten);
if ~newfigureintern
   subplot(zeilen,spalten,1);
end;

%mehrere Einzelmerkmale
for i=1:2:anz_em-1 % gehe durch die einzelnen Subplots
   if newfigureintern == 0
      subplot(zeilen,spalten,(i+1)/2);
   end; %Aktualisierung des Subplots
   akt_em=ind_em ([i i+1]);
   if i==anz_em-2
      akt_em=ind_em ([i i+1 i+2]);
   end % für die 3D Darstellung
   
   d_temp = d_org(ind_auswahl,akt_em);
   
   %Verrauschen:
   if parameter.gui.anzeige.visu_noise == 1
      em_scale = (max(d_temp)-min(d_temp)).*parameter.gui.anzeige.visu_noise_value;
      d_temp = d_temp + (rand(size(d_temp))-0.5)*diag(em_scale);
   end;
   pl_2d(d_temp,code(ind_auswahl),1,parameter.gui.anzeige,0,dorgbez(akt_em,:),zgf_y_bez(par.y_choice,:),0,0,0,ind_auswahl);
end

%nur ein Einzelmerkmal
if anz_em==1
   akt_em=ind_em;
   pl_2d([ind_auswahl d_org(ind_auswahl,akt_em)],code(ind_auswahl),1,parameter.gui.anzeige,0,char('Number of data point',dorgbez(akt_em,:)),zgf_y_bez(par.y_choice,:),0,0,0,ind_auswahl);
end

%schreibt Korr Koef in titel
tmp_dat=d_org(ind_auswahl,parameter.gui.merkmale_und_klassen.ind_em);

ko=zeros(2,2);
spe=ko;
if length(ind_em)>1
   ko=mycorrcoef(tmp_dat);
   spe=spearm(tmp_dat);
end
if (length(ko)>1)
   title(sprintf('Correlation coefficient: %1.3f   Spearman Correlation-Coefficient: %1.3f',ko(1,2),spe(1,2)));
end;

%MATLAB 2014B compatibility
set(fig_name,'numbertitle','off','name',sprintf('%d: %s',get_figure_number(gcf),get(get(gca,'ylabel'),'string')));

clear ind_pers ind_em ko spe tmp_dat akt_em anz_em anz_f ind_merk r i fig_name;
