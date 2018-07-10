% Script radiocheck
%
%   Dieses Skript kontrolliert für ein gegebenes Radioelement die
%   restlichen Gruppenmitglieder und stellt die anderen auf 0.
%   Anschließend wird ein inGUI aufgerufen, um die Werte in die GUI
%   zu schreiben
%
% The script radiocheck is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('radioIndx', 'var') || isempty(radioIndx))
   return;
end;

% Welche Elemente sind in der Gruppe?
tags = {parameter.gui.control_elements.tag};
radioIndx_I = getfindstr(tags, radioIndx, 'exact'); %radioIndx_I = strmatch(radioIndx, tags, 'exact');

if isempty(radioIndx_I)
   return;
end;
radioGroup = parameter.gui.control_elements(radioIndx_I).radiogroup;
% Das aktuelle Element schon mal auf 1 setzen:
set(parameter.gui.control_elements(radioIndx_I).handle, 'value', 1);
for i = 1:length(radioGroup)
   indx = getfindstr(tags, radioGroup{i}, 'exact'); %indx = strmatch(radioGroup{i}, tags, 'exact');
   if (~isempty(indx) && indx ~= radioIndx_I)
      set(parameter.gui.control_elements(indx).handle, 'value', 0);
   end;
end;
ausGUIIndx = radioIndx;
ausGUI;

clear radioIndx radioIndx_I tags;