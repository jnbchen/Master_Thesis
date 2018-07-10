  function [hndl,first_handle] = gaitfindobj(mytag)
% function [hndl,first_handle] = gaitfindobj(mytag)
%
% 
% 
% return the GUI handle for the tag mytag
% 
%
% The function gaitfindobj is part of the MATLAB toolbox Gait-CAD. 
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

global object_list

if isempty(object_list) || ~isstruct(object_list) || ~isfield(object_list,'handles')
    refresh_object_list;
end;

ind = find(ismember(object_list.tags,mytag));

if isempty(ind) || ~isgraphics(object_list.handles(ind(1)))
    refresh_object_list;
    ind = find(ismember(object_list.tags,mytag));
end;

if ~isempty(ind) && (isobject(object_list.handles(ind(1))) || ...
        (~isempty(object_list.handles(ind(1))) && isgraphics(object_list.handles(ind(1)))))
    hndl = object_list.handles(ind);
else
    %second try
    hndl = findobj('tag',mytag);
    refresh_object_list;
end;

if isempty(hndl)
    mywarning(sprintf('Für %s konnte kein passendes Handle gefunden werden',mytag));
else
    first_handle = handle(1);
end;


