  function handle=new_menu_af(uihd,name,callbackstring,auswahl,tag,separator, manclose, debug_mode)
% function handle=new_menu_af(uihd,name,callbackstring,auswahl,tag,separator, manclose, debug_mode)
%
% Default: function handle=new_menu_af(uihd,name,callbackstring,auswahl,'','')
% bereitet Auswahlfenster vor
% Änderung Ole: manclose eingefügt. Auswahlfenster musste bereits manuell geschlossen werden, um ein anderes Fenster öffnen zu können.
% Um Fehler im Zugriff auf Handles zu vermeiden, per Option ausschalten
%
% The function new_menu_af is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<5) 
   tag='';
end;
if (nargin<6) 
   separator='';
end;
if (nargin<7 || isempty(manclose))
   manclose = 0; 
end;
handle=new_menu(uihd,name,sprintf('if ~isempty(findobj(''UserData'',''Configuration'')) warning(''Only one configuration window can be active!''); else %s figure_handle=new_figure(''%s'',callback,info,string,%s,[],''%s'', %d); clear callback info string; end;',callbackstring,name,auswahl,auswahl,manclose),0,tag,separator, debug_mode); 

set(handle,'userdata',auswahl);
