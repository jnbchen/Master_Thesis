  function zgf=fuzround(zgf,anzeige)
% function zgf=fuzround(zgf,anzeige)
%
% rundet ZGF-Parameter in zgf entsprechend der Strategie in [Mikut05]
%
% The function fuzround is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<2) 
   anzeige=0; 
end; 

if (anzeige) 
   fprintf('%g \t',zgf);
   fprintf('\n'); 
end;

skal=floor(log10(max(zgf)-min(zgf)));
zgfmod=round(zgf/10^skal)*10^skal;

%irgendwas doppelt ? 
feinskal=1;
while 1
   if (anzeige) 
      fprintf('%g \t',zgfmod);
      fprintf('\n'); 
   end;
   
   %den der Null nächsten Wert auf Null setzen, wenn positive und negative Werte enthalten
   if (zgfmod(1)*zgfmod(length(zgfmod))<0) 
      [tmp,ind]=min(abs(zgfmod));
      zgfmod(ind)=0;
   end;   %doppelt? 
   
   diffind=find(~diff(zgfmod));
   %nichts mehr doppelt oder x-mal verfeinert ? -  dann raus
   if isempty(diffind) || (feinskal>1000) 
      break;
   end;
   diffind=findd([diffind diffind+1]);  
   
   %nichts vernünftiges zu finden - also feinere ZGF-Stützpunkte in der nächsten Runde    
   feinskal=10*feinskal;    
   
   %wenn doppelt, dann feinere Auslösung       
   zgfmod(diffind)=round(feinskal*zgf(diffind)/10^skal)/feinskal*10^skal;   
      
end;

%übernehmen
zgf=sort(zgfmod);

