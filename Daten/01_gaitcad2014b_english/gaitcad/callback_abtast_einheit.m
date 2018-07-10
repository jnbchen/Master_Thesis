% Script callback_abtast_einheit
%
% 
%  Ändert die Anzeige des Elements, das die Filterfrequenzen definiert.
%  Hier muss ebenfalls die gewählte Einheit angezeigt werden, um Missverständnisse
%  zu vermeiden.
% 
%
% The script callback_abtast_einheit is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

indx = get_element_indx(parameter, 'CE_ZR_Filterfreq', 'CE');
if (~isempty(indx))
   set(parameter.gui.control_elements(indx).bezeichner.handle, 'String', ...
      sprintf('%s [%s]', parameter.gui.control_elements(indx).name, ...
      parameter.gui.zeitreihen.einheit_abtastfrequenz_liste{parameter.gui.zeitreihen.einheit_abtastfrequenz}));
end; % if (~isempty(indx))
