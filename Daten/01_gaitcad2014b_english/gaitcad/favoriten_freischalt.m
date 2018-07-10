% Script favoriten_freischalt
%
% 
% function favoriten_freischalt(parameter)
%  Funktion zum Freischalten der Favoriten-Einträge.
% 
%  Suche nach den Menüeinträgen:
%
% The script favoriten_freischalt is part of the MATLAB toolbox Gait-CAD. 
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

indizes = findobj('type', 'uimenu', 'Tag', 'LdFuaMd');

if (isempty(indizes))
   return;
end;
% Falsche Reihenfolge. Also umdrehen.
indizes = indizes(end:-1:1);

% Zunächst die benutzerdefinierten Einträge:
enabled = [];
if (isfield(parameter.gui.menu.favoriten, 'manuell') && ~isempty(parameter.gui.menu.favoriten.manuell))
	enabled = get_freischalt(parameter.gui.menu.favoriten.manuell.tags, 0, parameter);
	% Die ersten length(enabled)-Elemente sind die benutzerdefinierten:
	an  = find(enabled == 1);
	aus = find(enabled == 0);
	set(indizes(an),  'enable', 'on');
   set(indizes(aus), 'enable', 'off');
end;

% Dann die Standard-Einträge:
if (isfield(parameter.gui.menu.favoriten, 'standard') && ~isempty(parameter.gui.menu.favoriten.standard))
	enabled_standard = get_freischalt(parameter.gui.menu.favoriten.standard.tags(parameter.gui.menu.favoriten.standard.element_indx,:), 0, parameter);
	an  = find(enabled_standard == 1);
	aus = find(enabled_standard == 0);
	standard_indizes = [length(enabled)+1:length(enabled)+length(enabled_standard)];
	set(indizes(standard_indizes(an)),  'enable', 'on');
   set(indizes(standard_indizes(aus)), 'enable', 'off');
end;

clear indizes enabled an aus enabled_standard standard_indizes;