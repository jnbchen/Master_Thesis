  function indmax=locmax(curve,zz)
% function indmax=locmax(curve,zz)
%
% findet Trendwechsel (Maxima) der Sequenz Kurve im Intervall curve(ind-zz):curve(ind):curve(ind+zz)
% bzw. Minima der Kurve -curve
%
% The function locmax is part of the MATLAB toolbox Gait-CAD. 
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

curve=squeeze(curve);
if (size(curve,1)<size(curve,2))
   curve=curve';
end;

j=1;
indmax=[];

curve=[(curve(1)-1E-10)*ones(zz,1);curve;(curve(end)-1E-10)*ones(zz,1)];
for i=1+zz:length(curve)-zz
   [posw,posind]=sort(curve(i-zz:i+zz));
   if (posind(length(posind))==(length(posind)+1)/2) 
      indmax(j)=i;j=j+1;
   end;
end;

indmax=indmax-zz;