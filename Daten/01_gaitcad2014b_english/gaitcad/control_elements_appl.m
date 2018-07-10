% Script control_elements_appl
%
% 
%  Ruft die einzelnen speziellen Funktionen für die Definition von Kontroll-Elementen auf
%
% The script control_elements_appl is part of the MATLAB toolbox Gait-CAD. 
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

if ~isempty(parameter.allgemein.appl_specials)
    for i = 1:length(parameter.allgemein.appl_specials.control_elements)
        parameter.allgemein.uihd_column=12+3*i+1;
        eval(['els = ' parameter.allgemein.appl_specials.control_elements{i} '(parameter);']);

        % Das Kopieren von Strukts in Strukts ist bei Matlab manchmal etwas nervig...
        % Beim einfachen anhängen trat ein Fehler auf, weil die Strukturen unterschiedlich
        % waren. Allerdings waren die Felder gleich. Nur die Reihenfolge war eine andere...
        % Also sicherheitshalber die Felder einzeln kopieren:
        for j = 1:length(els)
            fields = fieldnames(els(j));
            indx = length(parameter.gui.control_elements) + 1;
            parameter.gui.control_elements(indx).tag = [];
            for f = 1:length(fields)
                parameter.gui.control_elements(indx) = setfield(parameter.gui.control_elements(indx), fields{f}, getfield(els(j), fields{f}));
            end;
        end;
    end;
end;
