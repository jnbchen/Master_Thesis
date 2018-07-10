  function [handle,handle_push]=poplist(text,choice,value,pos,hoehe,xlaenge_handle,handle,handle_push)
% function [handle,handle_push]=poplist(text,choice,value,pos,hoehe,xlaenge_handle,handle,handle_push)
%
% initialisiert Auswahllisten
% handle, handlepush optional vorinitatialiserte Fenster!!
%
% The function poplist is part of the MATLAB toolbox Gait-CAD. 
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

if nargin<5 
   hoehe=[];
end;

if nargin<6
   xlaenge_handle=150;
end;
if isempty(xlaenge_handle) 
   xlaenge_handle=150;
end;
if nargin<7 
   handle=0;
end;
%MATLAB 2014B compatibility
if isempty(handle) || (isnumeric(handle) && handle == 0)
   keyboard;
   handle=uicontrol('visible','off','style','listbox');   
end;
if nargin<8 
   handle_push=0;
end;
%MATLAB 2014B compatibility
if isempty(handle_push) || (isnumeric(handle_push) && handle_push == 0)
   handle_push=uicontrol('visible','off','style','pushbutton');
end;

if isempty(hoehe)
   hoehe=20;
end;

if ~isempty(pos) 
   set(handle_push,'Position',[20 pos+hoehe-20 250 20]);
   set(handle,'Position',[300 pos xlaenge_handle hoehe]);
end;
if ~isempty(text) 
   set(handle_push,'String',text);set(handle,'UserData',text);
end;

if isempty(value) 
   value=get(handle,'value');
end;
set(handle,'string',choice,'value',value,'max',2);

%Toter Code auskommentiert
% %damit das Fenster bei Fehlern nicht unsichtbar wird...
% if (value>size(get(handle,'string'),1)) 
%    value=1;
% end;



 
