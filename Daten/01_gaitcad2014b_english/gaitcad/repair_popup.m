  function  value=repair_popup(handle,liste,value,ersatzvalue,name_handle_2)
% function  value=repair_popup(handle,liste,value,ersatzvalue,name_handle_2)
%
% default value=repair_popup(handle,liste,value,1,'')
% schreibt liste in popup-Fenster handle und probiert nacheinander die Gültigkeit der Werte value und ersatzvalue aus, zur Not dann 1
% wenn name_handle_2 gesetzt ist, wird der in handle(2) geschrieben
% 
%
% The function repair_popup is part of the MATLAB toolbox Gait-CAD. 
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
   ersatzvalue=1;
end;
if (nargin<5) 
   name_handle_2='';
end;

set(handle(1),'string',liste);
size_liste=size(get(handle(1),'string'),1); 

if isempty(value)
   value=1;
end;
if (value<1) 
   value=1;
end;

if (ersatzvalue<1) 
   ersatzvalue=1;
end;

if size_liste<max(value)    
   value=ersatzvalue;
   if size_liste<max(value) 
      value=1; 
   end;
end;
set(handle(1),'value',value);


if (length(handle)>1) && (~isempty(name_handle_2))
   set(handle(2),'string',name_handle_2);
end;

