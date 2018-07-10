  function my_ellip(A,mw,c,color)
% function my_ellip(A,mw,c,color)
%
% zeichnet Streu-Ellipse einer Datenmenge mit Kovarianzmatrix
% A und Mittelwert mw im zweidimensionalen Raum. c ist ein zusätzlicher
% Parameter, der den Radius
% 
% keine eindimensionalen Eliipsen!!!
%
% The function my_ellip is part of the MATLAB toolbox Gait-CAD. 
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

if length(A)==1
   return;
end;


%Ellipse berechnen
x=-1:.01:1;
y=[x fliplr(x);sqrt(1-x.^2) -sqrt(1-x.^2)];
[u,d]=eig(A);
d=sqrt(d);
tr=c*u*d*y+mw'*ones(1,length(y));

%Hauptachsen einzeichnen
far=plot(tr(1,:),tr(2,:));
set(far,'color',color); 
hold on;

%erste Hälfte Ellipse
far=plot(mw(1)+u(1,1)*d(1,1)*c*[-1 1],mw(2)+u(2,1)*d(1,1)*c*[-1 1]);
set(far,'color',color); 

%zweite Hälfte Ellipse
far=plot(mw(1)+u(1,2)*d(2,2)*c*[-1 1],mw(2)+u(2,2)*d(2,2)*c*[-1 1]);
set(far,'color',color); 

figure(gcf);
