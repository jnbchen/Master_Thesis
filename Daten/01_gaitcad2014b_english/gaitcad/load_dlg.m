  function modal_dlg = load_dlg(text)
% function modal_dlg = load_dlg(text)
%
% 
% 
%
% The function load_dlg is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 1)
   text = 'Load project';
end;

% Die figure anlegen.
x_size = 240;
y_size = 80;
bg_color = [.8 .8 .8];
screensize = get(0, 'ScreenSize');
% Zentrale Position berechnen.
x_pos = (screensize(3)-x_size)/2;
y_pos = (screensize(4)-y_size)/2;
modal_dlg = dialog('Position', [x_pos y_pos x_size y_size], 'DeleteFcn', 'clear modal_dlg;', ...
   'Name', 'Load project...');
uicontrol(modal_dlg, 'Style', 'Text', 'String', text, 'Position', ...
   [0 30 240 20], 'HorizontalAlignment', 'Center');
