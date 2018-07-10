  function [rk,ret]=regrred2(y,d,j,anz)
% function [rk,ret]=regrred2(y,d,j,anz)
%
% The function regrred2 is part of the MATLAB toolbox Gait-CAD. 
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

y=y-mean(y);
n0=[];
for anz1=1:anz 
   dims=[2:anz1+1];
   clear rk;
   p=1;
   for n=j 
      x=d([n0 n],:);
      s=[y;x]*[y' x'];
      rk(p)=s(1,dims)*inv(s(dims,dims))*s(dims,1)/s(1,1);
      p=p+1;
   end;
   [m,ind]=max(rk);
   n0=[n0 j(ind)]; 
   ret(anz1,:)=[j(ind) sqrt(m)];
   j(ind)=[];
end;

rk=sqrt(rk);