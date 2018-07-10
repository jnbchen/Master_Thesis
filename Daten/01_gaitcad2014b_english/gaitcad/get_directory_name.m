  function import_directory = get_directory_name(gui_name)
% function import_directory = get_directory_name(gui_name)
%
% 
%  function import_directory = get_directory_name(gui_name)
% 
% 
% 
%  Example GCD: parameter.gui.ganganalyse.import_directory = get_directory_name('Gait-CAD Import Directory for GCD files');
% 
% 
%  The function get_directory_name is part of the MATLAB toolbox Gait-CAD.
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister]
% 
% 
%  Last file change: 22-Oct-2007 13:00:48
% 
%  This program is free software; you can redistribute it and/or modify,
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation; either version 2 of the License, or any later version.
% 
%  This program is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License along with this program;
%  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
%  You will find further information about Gait-CAD in the manual or in the following conference paper:
% 
%  MIKUT, R.; BURMEISTER, O.; REISCHL, M.; LOOSE, T.:  Die MATLAB-Toolbox Gait-CAD.
%  In:  Proc., 16. Workshop Computational Intelligence, pp. 114-124, Universitätsverlag Karlsruhe, 2006
%  Online available: http://www.iai.fzk.de/projekte/biosignal/public_html/gaitcad.pdf
% 
%  Please refer to this paper, if you use Gait-CAD for your scientific work.
% 
%
% The function get_directory_name is part of the MATLAB toolbox Gait-CAD. 
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

import_directory=uigetdir(pwd,gui_name);

if import_directory == 0
    import_directory ='';
end;



