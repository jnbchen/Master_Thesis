  function [handle,handle_push]=datini(text,variable,handle_name,pos,value,floatstyle,zusatz_callback,handle,handle_push)
% function [handle,handle_push]=datini(text,variable,handle_name,pos,value,floatstyle,zusatz_callback,handle,handle_push)
%
% initialisiert Eingabe-Fenster für Zahlen variable (Startwert value) mit Erklärungstext text an
% x-Position pos ins aktuelle Fenster und gibt operiert im Objekt handle_name
% bei floatstyle (optional, ausgeschaltet) ist Parameter Fließkommazahl
%
% The function datini is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<6 
   floatstyle=0;
end;
if nargin<7 
   zusatz_callback='';
end;

if nargin<8 
   handle=[];
end;

%MATLAB 2014B compatibility
%if ~handle 
if isempty(handle) || ( isnumeric(handle) && (handle==0))
   keyboard;
    handle=uicontrol('visible','off');
end;

if nargin<9 
   handle_push = [];
end;
%MATLAB 2014B compatibility
%if ~handle_push && (nargout>1) 
if ~isempty(handle_push) || ( isnumeric(handle_push) && (handle==0)) && (nargout>1) 
   handle_push=uicontrol('visible','off');
end;
%MATLAB 2014B compatibility
if ~isempty(handle_push) || ( isnumeric(handle_push) && (handle==-1))
   handle_push=[];
end;

callback_string=''; 

%MATLAB 2014B compatibility
%if (handle_push~=-1) && (handle_push) 
if ~isempty(handle_push) 
   set(handle_push,'Style','Pushbutton','Position',[20 pos 250 20],'String',text);
end;
if ~floatstyle 
   set(handle,'Style','edit','Position',[300 pos 50 20],'string',sprintf('%d ',value));
   if ~isempty(variable) 
      callback_string=sprintf('tmpchange=1;tmp=sscanf(get(%s,''String''),''%%d'');if isnumeric(tmp) if exist(''%s'',''var'') tmpchange=(%s~=tmp);end; %s=tmp;end;',handle_name,variable,variable,variable);
   end;
else 
   set(handle,'Style','edit','Position',[300 pos 50 20],'string',sprintf('%5.3f',value));
   if ~isempty(variable) 
      callback_string=sprintf('tmpchange=1;tmp=sscanf(get(%s,''String''),''%%f'');if isnumeric(tmp) if exist(''%s'',''var'') tmpchange=(%s~=tmp);end;%s=tmp;end;',handle_name,variable,variable,variable);
   end;
end;
set(handle,'UserData',text);

if ~isempty(zusatz_callback)
   callback_string=sprintf('%s;%s;clear tmpchange;set(%s,''String'',num2str(%s));',callback_string,zusatz_callback,handle_name,variable);
end;
set(handle,'Callback',callback_string);
set(handle,'Tag',variable);


