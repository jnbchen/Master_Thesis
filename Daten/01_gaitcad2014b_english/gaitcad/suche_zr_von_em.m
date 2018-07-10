  function ind_zr = suche_zr_von_em(var_bez, dorgbez, ind_em, exact)
% function ind_zr = suche_zr_von_em(var_bez, dorgbez, ind_em, exact)
%
%  Sucht anhand der gegebenen Einzelmerkmale die zugehörigen ZR heraus
%  Eingaben:
%     - var_bez: Alle ZR-Bezeichner
%     - dorgbez: Alle EM-Bezeichner
%     - ind_em: ausgewählte EM
%     - exact: wenn 1, wird versucht die ZR sehr exakt zu bestimmen, bei 0 kann es passieren, dass
%             Geschwindigkeitszeitreihen o.ä. mitgefunden werden
% 
%  Rückgaben:
%     - ind_zr: zugehörige Zeitreihen
%
% The function suche_zr_von_em is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 4)
   exact = 0;
end;

if (size(ind_em,2) == 1)
   ind_em = ind_em';
end;


ind_zr = [];
for em = ind_em
   str = deblank(dorgbez(em,:));
   temp = [];
   for i=1:size(var_bez,1)
      indx=strfind(deblank(var_bez(i,:)),str);
      if (isempty(indx))
         temp(i) = 0;
      else
         temp(i) = indx;
      end;
   end;
   % Es gibt eine Übereinstimmung, aber ist die auch genau?
   if (exact)
      gef = find(temp);
      for i=gef
         tmp = str(temp(i):end);
         if ~strcmp(tmp, deblank(var_bez(i,:)))
            gef(gef==i) = [];
         end;
      end;
   else
      gef = find(temp);
   end;
   ind_zr = union(ind_zr, gef);
end;
if ~isempty(ind_zr)
   ind_zr(ind_zr == size(var_bez,1)) = [];
end;

