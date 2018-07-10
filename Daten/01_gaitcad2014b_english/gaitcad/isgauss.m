  function [val,q,c] = isgauss(dat,alpha)
% function [val,q,c] = isgauss(dat,alpha)
%
% 
%  gibt boolschen Ausdruck zurück, ob dat Gauss-verteilt ist
%  val = isgauss(dat,alpha,anz_hist_container)
% 
%
% The function isgauss is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:59
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

if nargin < 2
   alpha = 0.95; 
end;

% Histogramm für die Daten berechnen, aufsummieren und mit Wahrscheinlichkeitsfunktion vergleichen
x = sort(dat); 
dens_exp=[1:length(dat)]./length(dat)';  
dens_formel=normcdf(x,mean(dat),std(dat)); 
[q, c] = kstest(dens_exp, x, dens_formel, x, alpha);

% Vergleichswert zurückgeben
if q<c 
   val = 1;
else 	
   val = 0;
end;
