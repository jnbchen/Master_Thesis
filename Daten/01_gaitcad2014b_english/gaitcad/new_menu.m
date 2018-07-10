  function handle=new_menu(parent,name,callback,delete_pointerstatus,tag,separator,debug_mode)
% function handle=new_menu(parent,name,callback,delete_pointerstatus,tag,separator,debug_mode)
%
% 
%  Defaultwerte: function handle=new_menu(parent,name,callback,0,'','')
%
% The function new_menu is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin<4) 
   delete_pointerstatus=0;
end;
if (nargin<5) 
   tag='';
end;
if (nargin<6) 
   separator='';
end;
if (nargin<7) 
   debug_mode = 1;
end;


% MS: Bei direkter Verwendung von uimenu() für die Erzeugung des Menus wird die
% Abfrage von parent ~= 0 hinfällig
if ~isempty(parent) && (isobject(parent) || (isnumeric(parent) && parent~=0))  %MATLAB 2014b Kompatibilität 
   handle = uimenu('Parent', parent, 'label', name);
   name=sprintf('%s - %s',get(parent,'label'),name);
else     
   handle=uimenu;set(handle,'label',name);
end; 

if ~exist('delete_pointerstatus','var') && (delete_pointerstatus == 0 ) && ~isempty(callback) 
   % Erste Zeile: Mauszeiger wird bei einem Fehler im Callback wieder auf den normalen Zeiger
   % zurückgesetzt. Der entstandene Fehler wird ausgegeben, aber nicht in welcher Datei und Zeile
   % außerdem wird jetzt vorher noch die Freigabe doppelt überprüft 
   % (hilft bei Makros und Favoriten)
 
   if isempty(debug_mode) || ~debug_mode
      callback = sprintf('try, pointer(2,''%s'');if strcmp(get(%.25f,''enable''),''off'') menu_freischalten(parameter, parameter.gui.menu.freischalt);end;if strcmp(get(%.25f,''enable''),''on'') %s; else warning(''Try to use disabled menu entry (%s)!''); figure_handle=[]; end;pointer(1);catch, pointer(3); end;',name,handle,handle,callback,tag);
   else
      % Diese Zeile: Matlab schmiert einfach ab...
      callback = sprintf('pointer(2,''%s'');if strcmp(get(%.25f,''enable''),''off'') menu_freischalten(parameter, parameter.gui.menu.freischalt);end;if strcmp(get(%.25f,''enable''),''on'') %s; else warning(''Try to use disabled menu entry (%s)!''); figure_handle=[]; end;pointer(1);',name,handle,handle,callback,tag);
   end;
   callback = [callback 'next_function_parameter = '''';'];
end;

set(handle,'Callback',callback);
if ~isempty(tag) 
   set(handle,'tag',tag);
end;   
if ~isempty(separator) 
   set(handle,'separator',separator);
end;   

