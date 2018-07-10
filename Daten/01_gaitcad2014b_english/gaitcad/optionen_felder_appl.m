% Script optionen_felder_appl
%
% 
%  Ruft die einzelnen speziellen Funktionen für die Definition von Kontroll-Elementen auf
%
% The script optionen_felder_appl is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(parameter.allgemein.appl_specials)
    for i = 1:length(parameter.allgemein.appl_specials.optionen_felder)
        els = eval(parameter.allgemein.appl_specials.optionen_felder{i});
        % Siehe control_elements_appl für einen Kommentar:
        for j = 1:length(els)
            fields = fieldnames(els(j));
            indx = length(parameter.gui.optionen_felder) + 1;
            parameter.gui.optionen_felder(indx).tag = [];
            for f = 1:length(fields)
                parameter.gui.optionen_felder(indx) = setfield(parameter.gui.optionen_felder(indx), fields{f}, getfield(els(j), fields{f}));
            end;
        end;
    end;
end;

parameter.gui.waehlbare_felder = find(myCellArray2Matrix({parameter.gui.optionen_felder.in_auswahl}));
str = '';
for  i = 1:length(parameter.gui.waehlbare_felder)
    str = [str parameter.gui.optionen_felder(parameter.gui.waehlbare_felder(i)).name '|'];
end;
str(end) = [];
tags = {parameter.gui.control_elements.tag};
indx = getfindstr( tags, 'CE_Auswahl_Optionen', 'exact'); %indx = strmatch('CE_Auswahl_Optionen', tags, 'exact');
if (~isempty(indx))
    parameter.gui.control_elements(indx).listen_werte = str;
end;