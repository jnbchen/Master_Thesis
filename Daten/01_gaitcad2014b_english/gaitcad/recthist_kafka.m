  function histval=recthist_kafka(x,y,z,colorvect,var_bez,not_figure,handskalierung,zgf_y_bez)
% function histval=recthist_kafka(x,y,z,colorvect,var_bez,not_figure,handskalierung,zgf_y_bez)
%
% visualisiert quantitative x1- und x2-Daten mit Klassen y
% durch farbige Rechtecke (Höhe proportional zu Häufigkeit)
% colorvect gibt Farben an
% var_bez (optional, sonst=[]):     Merkmalsbezeichnungen
% not_figure=1 (optional, sonst=0): verhindert neues Bild
% 
%
% The function recthist_kafka is part of the MATLAB toolbox Gait-CAD. 
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

ix=unique(x)';
iy=unique(y)';
if (length(ix)>20) || (length(iy)>20) 
   mywarning('Possibly no qualitative features');
   %   return;
end;

if nargin<5 
   var_bez=[];
end;
if nargin<6 
   not_figure=0;
end;
if nargin<7 
   handskalierung(1)=1;
   handskalierung(2)=1;
end;
if nargin<8
   zgf_y_bez = [];
end;


if ~not_figure 
   f=figure;
else
   f=gcf;  
end;


[iz,izb,izc]=unique(z);
iz=iz';

%erstmal durchzählen, um die Höhe zu bestimmen
for i=1:length(ix)
   for j=1:length(iy)
      for k=1:length(iz)
         histval(i,j,k)=1E-12+sum((x==ix(i)).*(y==iy(j)).*(z==iz(k)));
      end;
   end;
end;

%Breiten- und Höhenskalierung
%Mindestbreite vereinbaren
ax=axis;
if ~isempty(diff(iy)) 
   high=max(0.1*(ax(4)-ax(3)),0.75*min(diff(iy)))/max(max(max(histval)));
else 
   high=.25*(ax(4)-ax(3));
end;
if ~isempty(diff(ix)) 
   breite=max(0.1*(ax(2)-ax(1)),min(diff(ix)));
else 
   breite=.25*(ax(2)-ax(1));
end;
disp=0.6*breite/length(iz);

axis([min(x)-max(iz)*disp max(x)+max(iz)*disp min(y)-high*max(max(max(histval))) max(y)+high*max(max(max(histval)))]);
set(get(f,'currentaxes'),'xTick',ix);
set(get(f,'currentaxes'),'yTick',iy);

disp=handskalierung(1)*disp;
high=handskalierung(2)*high;

hold on;
r=1;
for i=1:length(ix)
   for j=1:length(iy)
      for k=1:length(iz)
         rectangle('position',[ix(i)+(disp)*(iz(k)-1-(max(z)/2)) iy(j) disp high*histval(i,j,k)],'facecolor',colorvect(1+rem(iz(k)-1,size(colorvect,1)),:,:));
      end;
   end;
end;

if ~isempty(var_bez)
   xlabel(kill_lz(var_bez(1,:)));
   ylabel(kill_lz(var_bez(2,:)));
end;

%Legende ergänzen
if ~isempty(zgf_y_bez) && length(iz)>1 && length(iz)<50
   
   %Dummy-Punkte für die Legenede (mit Rechteck geht es nicht)
   for k=1:length(iz)
      %ha_leg(k) = plot(ix(1)+(disp)*(iz(k)-1-(max(z)/2)),iy(1),'.');
      ha_leg(k) = plot(ix(1)-1+(disp)*(iz(k)-1-(max(z)/2))-max(x),iy(1)-max(y),'.');
      set(ha_leg(k),'color',colorvect(1+rem(iz(k)-1,size(colorvect,1)),:,:));
   end;
   
   
   %Aufbau Legende mit zgf_bez (wenn vorhanden und belegt)
   %nur die aktiven Klassen far(find(far)) werden in die Legende eingetragen
   tmp=sprintf('''%s'',',zgf_y_bez(1,iz).name);
   eval(sprintf('legend(ha_leg,%s,0);',tmp(1:length(tmp)-1)));
end;

grid on;
