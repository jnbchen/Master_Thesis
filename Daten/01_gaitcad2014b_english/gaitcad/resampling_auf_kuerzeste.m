  function d_orgs_neu = resampling_auf_kuerzeste(d_orgs, neue_laenge)
% function d_orgs_neu = resampling_auf_kuerzeste(d_orgs, neue_laenge)
%
% 
% 
% 
%
% The function resampling_auf_kuerzeste is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 2)
   neue_laenge = [];
end;

laengen = zeros(size(d_orgs, 1), 1);
% Bestimme für jeden Datentupel die Länge der Zeitreihen
for dt = 1:size(d_orgs, 1)
   if size(d_orgs,3) >1
      laengen(dt) = bestimme_laenge(squeeze(d_orgs(dt, :, :))');
   else
      laengen(dt) = bestimme_laenge(d_orgs(dt, :, 1));
   end;
   
   fprintf(1,'Data points %4d: Length of time series %d\n',dt,laengen(dt));
end;
% Wenn alle Zeitreihen so lang bleiben sollen wie bisher, breche ab.
if (~any(laengen - size(d_orgs,2)))
   d_orgs_neu = d_orgs;
else
   % Wenn eine feste neue Länge vorgeben wurde (z.B. Normierung der Länge auf 100 Abtastpunkte),
   % verwende diesen Wert, sonst die minimale Länge über die Datentupel.
   if (isempty(neue_laenge))
      P = min(laengen(find(laengen~=0)));
   else
      P = neue_laenge;
   end;
   % Neuen Speicher anlegen
   d_orgs_neu = zeros(size(d_orgs,1), P, size(d_orgs,3));
   % Datentupelweise Zeitreihen verkleinern.
   for dt = 1:size(d_orgs, 1)
	   % Alte Länge
   	Q = laengen(dt);
      if Q ~= 0 
         if size(d_orgs,3) >1
            d_orgs_neu(dt, 1:end, :) = interp1(1:Q,squeeze(d_orgs(dt, 1:Q, :)),1:(Q-1)/(P-1):Q);
         else
            d_orgs_neu(dt, 1:end, :) = interp1(1:Q,d_orgs(dt, 1:Q),1:(Q-1)/(P-1):Q);
         end;
         
      else
         %Datentupel hat nirgendwo Werte!
         d_orgs_neu(dt, :, :) = 0;
      end;      
   end;
end;


% Bestimme die kürzeste Zeitreihe in der Matrix
% Matrix hat das Format #zr x #samples
function neue_laenge = bestimme_laenge(matrix)

%look for the index of the largest sample point with a value except nan or 0 of a data point 
neue_laenge = max(find(max(matrix ~= 0 & ~isnan(matrix),[],1))); % Coderevision: &/| checked!
