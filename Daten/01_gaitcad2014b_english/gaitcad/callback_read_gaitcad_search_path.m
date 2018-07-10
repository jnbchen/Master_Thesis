% Script callback_read_gaitcad_search_path
%
% The script callback_read_gaitcad_search_path is part of the MATLAB toolbox Gait-CAD. 
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

parameter.allgemein.gaitcad_searchpath = {};
parameter.allgemein.oldpath_search = pwd;
clear fun;
pause(1);
try
    if isfield(parameter.allgemein,'userpath')
        cd(parameter.allgemein.userpath);
        %read the list of permanent directories to be added
        if exist('read_gaitcad_searchpath.m','file')
            read_gaitcad_searchpath;
        end;
        if isfield(parameter.allgemein,'gaitcad_searchpath')
            parameter.allgemein.gaitcad_searchpath = unique(parameter.allgemein.gaitcad_searchpath);
            
            %append to MATLABPATH
            for i_path=1:length(parameter.allgemein.gaitcad_searchpath)
                addpath(parameter.allgemein.gaitcad_searchpath{i_path});
            end;
        end;
    end;
end;
cd(parameter.allgemein.oldpath_search);

%delete last temporary search path
mode_searchpath = 5;
callback_add_gaitcad_search_path;

clear i_path mode_searchpath;
