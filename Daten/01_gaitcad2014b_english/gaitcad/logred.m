  function plausall=logred(plausall,par,nicht_loeschen)
% function plausall=logred(plausall,par,nicht_loeschen)
%
% logische Reduktion der Regelbasis in plausall
% Regeln mit niedrigerer Relevanz, die Teilmenge von Regeln höherer Relevanz sind,
% werden gelöscht und Löschen von irrelevanten Regelen
%
% The function logred is part of the MATLAB toolbox Gait-CAD. 
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

if isempty(plausall) 
   return;
end;

%fehlende Teilpraämissen (Term ANY) expandieren
plausall=pla2plav(plausall,par);

%Sortieren nach Relevanz
[wert,pos]=sort(-plausall(:,1));
plausall=plausall(pos,:);

%Löschen
if (nargin==2) 
   plausall(find(plausall(:,1)==0),:)=[];
end;

fprintf('Logical reduction of rules\nbefore reduction:  %4d rules\n',size(plausall,1));

%noch Regeln da ?
if min(size(plausall))
   i=1;
   
   while 1
      %Protokoll
      if (rem(i,20)==0) 
         fprintf('%4d of %4d\n',i,size(plausall,1));
      end;
      %logisch gleiche Regeln ?
      %(gleiche Schlußfolgerung und Untermenge von Prämissen)
            
      if ismatlabversion(6,'max')
         ind=(i+find(((plausall(i+1:size(plausall,1),4)==plausall(i,4))')&(prod(((ones(size(plausall,1)-i,1)*plausall(i,5:size(plausall,2)))>=plausall(i+1:size(plausall,1),5:size(plausall,2)))'))))';  % Coderevision: &/| checked!
      else         
         ind=(i+find(((plausall(i+1:size(plausall,1),4)==plausall(i,4))')&(prod(cast(((ones(size(plausall,1)-i,1)*plausall(i,5:size(plausall,2)))>=plausall(i+1:size(plausall,1),5:size(plausall,2)))','double')))))'; % Coderevision: &/| checked!
      end;
      
      %Löschen !
      plausall(ind,:)=[];
      i=i+1;
      
      %Ende der Regelbasis ?
      if (i>=size(plausall,1)) 
         break;
      end;
   end;
end;

fprintf('After reduction: %4d rules\n',size(plausall,1));

anz_fuzzy=(size(plausall,2)-4)/par(2);
plausall=plav2pla(plausall,par,anz_fuzzy);