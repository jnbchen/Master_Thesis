  function d_orgs_neu = kuerze_zeitreihen(d_orgs, fensterbreite, verfahren)
% function d_orgs_neu = kuerze_zeitreihen(d_orgs, fensterbreite, verfahren)
%
% 
% 
%  verfahren bestimmt, wie die neuen Abtastpunkte berechnet werden
%  (z.B. 'min', 'max', 'mean', 'median'). Es können auch selbst geschriebene
%  Funktionen als Zeichenkette übergeben werden, da innerhalb dieser Funktion
%  der eval-Befehl zum Einsatz kommt.
% 
% 
%
% The function kuerze_zeitreihen is part of the MATLAB toolbox Gait-CAD. 
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

d_orgs_neu = [];
if (nargin < 2)
   fprintf(1, 'Error: missing option ''fensterbreite''\n');
   return;
end;
if (nargin < 3)
   verfahren = 'mean';
end;

if (~exist(verfahren, 'builtin') && ~exist(verfahren, 'file'))
   fprintf(1, 'Error: the selected function ''%s'' does not exist. Abort operation.\n', verfahren);
  	return;
end;

if (fensterbreite == 1)
   d_orgs_neu = d_orgs;
   return;
end;

% Bei einem Vektor die Dimension umdrehen:
if (size(d_orgs,1) ~= 1 && size(d_orgs,2) == 1)
   d_orgs = d_orgs';
end;

M = fensterbreite;
N = size(d_orgs,2) / fensterbreite;
indizes = [1:size(d_orgs,2)];
if (rem(N,1) ~= 0)
   fprintf(1, 'Warning: some samples are skipped due to the selected window size!\n');
   N = floor(N);
   indizes = [1:N*M];
end;

for zr = 1:size(d_orgs,3)
   % Mit diesem Befehl stehen die Indizes eines Fensters in den Spalten der Matrix indx.
   indx = reshape(indizes, M, N);
   for dt = 1:size(d_orgs,1)
      dat_vek = squeeze(d_orgs(dt, :, zr));
      % dat_vek(indx) gibt dann eine Matrix zurück, in denen jeweils die Werte eines Fensters
      % in den Spalten stehen. Diese können dann direkt verarbeitet werden.
      % Eine Möglichkeit ist die Verwendung von "eval", bei der die zu verwendende Funktion
      % in die Zeichenkette eingebaut wird.
      % Vorsichtshalber in einen try, ..., catch Block einbauen damit ein entstehender Fehler
      % gleich entdeckt wird.
      try
	      befehl  = sprintf('d_orgs_neu(dt, :, zr) = %s(dat_vek(indx));', verfahren);
         eval(befehl);
      catch
         fprintf(1, 'Error executing ''%s''!\n', verfahren);
         return;
      end;
   end; % for(dt = 1:size(d_orgs,1))
end; % for(zr = 1:size(d_orgs,2))

