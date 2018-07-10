  function plot_korrmatrix(values,c_krit,xcoord,ycoord) 
% function plot_korrmatrix(values,c_krit,xcoord,ycoord) 
%
% 
% 
% 
%
% The function plot_korrmatrix is part of the MATLAB toolbox Gait-CAD. 
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

checkfornewfigure;   

%auf -1 und 1 normieren
values(values<-1)=-1;
values(values>1)=1;

%Bild zeichnen - inkl. Legende
legende_text=[-1:0.1:1]';


%values(1:6,legendeind)=legende_text;

bild      =ones(size(values,1),size(values,2),3);
mycolormap=ones(length(legende_text),3);

sizebild=size(values,1)*size(values,2);

%positive Korrelationen eintragen (in grün durch Manipulation von rot und blau)
ind=find(values>c_krit);
bild(ind)=1-(values(ind)-c_krit)/(1-c_krit);
bild(ind+2*sizebild)=1-(values(ind)-c_krit)/(1-c_krit);

ind=find(legende_text>c_krit);
mycolormap(ind,1)=1-(legende_text(ind)-c_krit)/(1-c_krit);
mycolormap(ind,3)=1-(legende_text(ind)-c_krit)/(1-c_krit);


%negative Korrelationen eintragen (in rot durch Manipulation von grün und blau)
ind=find(values<-c_krit);
bild(ind+sizebild)=1+(values(ind)+c_krit)/(1-c_krit);
bild(ind+2*sizebild)=1+(values(ind)+c_krit)/(1-c_krit);

ind=find(legende_text<-c_krit);
mycolormap(ind,2)=1+(legende_text(ind)+c_krit)/(1-c_krit);
mycolormap(ind,3)=1+(legende_text(ind)+c_krit)/(1-c_krit);

colormap(mycolormap);

if nargin<3
   xcoord=1:size(bild,1);
end;
if nargin<4
   ycoord=1:size(bild,2);
end;

image(xcoord,squeeze(ycoord),bild);

%Legendentext eintragen
handle_colorbar=colorbar;
set(handle_colorbar, 'YTick',[1:length(legende_text)],'YTickLabel', legende_text);