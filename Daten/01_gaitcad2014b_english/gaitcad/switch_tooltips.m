  function switch_tooltips(an, elements)
% function switch_tooltips(an, elements)
%
% 
% 
%  Schaltet die Tooltips in den Kontroll-Elementen an oder aus.
% 
%
% The function switch_tooltips is part of the MATLAB toolbox Gait-CAD. 
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

if (an)
   % Für jedes Element die Hilfetexte eintragen
   for i = 1:length(elements)
      % Aber nur, wenn es einen Text gibt
      if (~isempty(elements(i).tooltext) && ischar(elements(i).tooltext))
         set(elements(i).handle, 'TooltipString', elements(i).tooltext);
         % Und auch in den Bezeichner!
         if (~isempty(elements(i).bezeichner))
            set(elements(i).bezeichner.handle, 'TooltipString', elements(i).tooltext);
         end;
      end;
   end;
else
   % siehe oben, aber die Hilfetexte werden gelöscht.
   for i = 1:length(elements)
      set(elements(i).handle, 'TooltipString', '');
      if (~isempty(elements(i).bezeichner))
         set(elements(i).bezeichner.handle, 'TooltipString', '');
      end;
   end;
end;
