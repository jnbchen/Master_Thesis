  function [a,n]=findd_unsort(b)
% function [a,n]=findd_unsort(b)
%
%  findet unterschiedliche Elemente in Vektor b
%  und gibt Elementewerte a (IN DER REIHENFOLGE, von b) und ihre Indices n zurueck
%
% The function findd_unsort is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(b) || any(isnan(b))
   a=[];
   n=[];
   return;
end;

if diff(size(b))<=0 
   b=b';
end;

[b_sort ind]=sort(b);
diff_vek=[1 diff(b_sort)]; %hier stehen alle Indizes mit allen verschieden vorkommenden Elementen

%zurücksortieren: 
[b_zur ind_zur]=sort(ind);

%raussuchen aller nichtsortierten Elemente: 
diff_zur=diff_vek(ind_zur);
n=find(diff_zur);

a=b(n);

% der Unterschied zu "findd" ist die Sortierung / Nicht-Sortierung, hier eine Abtestung: 
if ~min(findd(a)==findd(b)) 
   myerror('Error!'); 
end 
