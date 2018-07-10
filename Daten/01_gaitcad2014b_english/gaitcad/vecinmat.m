  function [mat,ind,x_unbes,y_unbes]=vecinmat(dat,xpos,ypos)
% function [mat,ind,x_unbes,y_unbes]=vecinmat(dat,xpos,ypos)
%
% schreibt Elemente von dat in Matrix: mat(xpos(i),ypos(i))=dat(i);
% ind: Matrix-Elementadressen
% x_unbes: Zeilen mit mindestens einem unbesetzen Element
% y_unbes: Spalten mit mindestens einem unbesetzten Element
% 
%
% The function vecinmat is part of the MATLAB toolbox Gait-CAD. 
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

xsize=max(xpos);
ysize=max(ypos);

mat=zeros(xsize,ysize);
ind=xpos+(ypos-1)*xsize;
mat(ind)=dat;

if (nargout>2)
   matind=zeros(size(mat));
   matind(ind)=1;
   x_unbes=find(~min(matind,[],2))';
   if ~isempty(x_unbes) 
      fprintf('%d unoccupied rows!\n',length(x_unbes));
   end;
   y_unbes=find(~min(matind,[],1));
end;