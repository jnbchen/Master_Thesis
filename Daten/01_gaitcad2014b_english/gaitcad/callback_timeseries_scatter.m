% Script callback_timeseries_scatter
%
% The script callback_timeseries_scatter is part of the MATLAB toolbox Gait-CAD. 
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

ind_em=parameter.gui.merkmale_und_klassen.ind_zr; %Zeilenvektor mit allen ausgewählten Einzelmerkmalen
anz_em=length(ind_em); %Menge der aktivierten Einzelmerkmale
if (anz_em>20) || (anz_em<2) || rem(anz_em,2) == 1
   mywarning('Please select a paired number of time series (between 2 and 20)!');
   return;   
end;

%Makro mit neuen Bildern?
if parameter.gui.anzeige.aktuelle_figure
   if gcf~=1 
      fig_name=gcf; 
   else
      fig_name=figure;
   end;
   newfigureintern=1;   
else 
   fig_name=figure;
end;
if (~exist('newfigureintern', 'var'))
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
   if ~newfigureintern 
      subplot(zeilen,spalten,(i+1)/2); 
   end; %Aktualisierung des Subplots
   akt_em=ind_em ([i i+1]);
   
   laenge_zeitreihe=1+parameter.gui.zeitreihen.segment_ende-parameter.gui.zeitreihen.segment_start;
   
   dat=zeros(length(ind_auswahl)*laenge_zeitreihe,2);
   code_dat=zeros(length(ind_auswahl)*laenge_zeitreihe,1);

   i_position=0;
   for ind_datapoint=ind_auswahl'
      dat(i_position+[1:laenge_zeitreihe],1:2)=squeeze(d_orgs(ind_datapoint,parameter.gui.zeitreihen.segment_start:parameter.gui.zeitreihen.segment_ende,akt_em));
      code_dat(i_position+[1:laenge_zeitreihe])=code(ind_datapoint);
      i_position=i_position+laenge_zeitreihe;
   end;
   
   pl_2d(dat,code_dat,1,parameter.gui.anzeige,[],var_bez(akt_em,:),zgf_y_bez(par.y_choice,:),0,0,[],ind_auswahl,[], 0, []);
end

set(fig_name,'numbertitle','off','name',sprintf('%d: Scatterplot %s - %s',get_figure_number(gcf),get(get(gca,'xlabel'),'string'),get(get(gca,'ylabel'),'string')));


clear ind_pers ind_em ko spe tmp_dat akt_em anz_em anz_f ind_merk r i fig_name;
