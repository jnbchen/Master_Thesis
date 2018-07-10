% Script callback_verwalte_specials
%
% The script callback_verwalte_specials is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

if (isempty(parameter.allgemein.aktiv))
   return;
end;

[applspec_gui] = verwalte_specials(parameter);
uiwait(applspec_gui.h);

if (applspec_gui.ok)
   alt = myCellArray2Matrix({applspec_gui.orig_aktiv.an});
   neu = myCellArray2Matrix({applspec_gui.kopie_aktiv.an});
   % Es hat sich etwas an den Einstellungen ver�ndert.
   % Also speichere die neuen Werte in der Datei ab.
   if (any(alt ~= neu))
      aktiv = applspec_gui.kopie_aktiv;
      save([parameter.allgemein.userpath filesep 'anaus.dat'], 'aktiv', '-mat');
      %msgbox('Changes will be activated after the next Gait-CAD start.','Changes of extension packages','warn','modal');
      warndlg('Changes will be activated after the next Gait-CAD start.','Changes of extension packages','modal');
   end;
end;
clear applspec_gui;