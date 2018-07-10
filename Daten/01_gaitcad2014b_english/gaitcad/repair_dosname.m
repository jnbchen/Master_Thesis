  function dateiname = repair_dosname(dateiname)
% function dateiname = repair_dosname(dateiname)
%
% 
% 
%
% The function repair_dosname is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(dateiname)
   
   dateiname = strrep(dateiname,'ü','ue');
   dateiname = strrep(dateiname,'ä','ae');
   dateiname = strrep(dateiname,'ö','oe');
   dateiname = strrep(dateiname,'ß','ss');
   ind_not_ok = find( dateiname<45 | dateiname == 47 | (dateiname>57 & dateiname<65) | (dateiname>90 & dateiname<95) | dateiname == 96 | dateiname>122); % Coderevision: &/| checked!
   if ~isempty(ind_not_ok)
      dateiname(ind_not_ok) = 95;
      ind_delete = find(diff(ind_not_ok) == 1);
      if ~isempty(ind_delete)
          dateiname(ind_not_ok(ind_delete+1)) = [];
      end;
   end;  
end;









