  function enabled = get_freischalt(tag, isindex, parameter)
% function enabled = get_freischalt(tag, isindex, parameter)
%
% 
%  
% 
% 
% 
%   function enabled = get_freischalt(tag, parameter)
%   Bestimmt, ob einzelne Menüelemente freigeschaltet werden.
%   Berechnet nicht so viele Menüelemente, wie menu_freischalten es per se tut,
%   ist aber auch nicht auf ein Hauptmenü beschränkt.
% 
%   Dabei wird die Freischaltung für jedes Element einzeln bestimmt.
%   Bei sehr vielen Elementen lohnt sich ein Zusammenfassen, um gleiche
%   Abfragen zu vermeiden. Bei wenigen ist es effizienter, direkte Abfragen
%   durchzuführen, da das Zusammenfassen ebenfalls Zeit kostet.
% 
%   tag entspricht den Tags der Menüelemente, oder, wenn isindex 1 ist,
%   dem Index in paramter.gui.menu.elements.
%   parameter ist das Gait-CAD Parameterstrukt.
% 
%   Wenn die Indizes gespeichert wurden, sorge für einen Spaltenvektor
% 
%  Die Funktion get_freischalt ist Teil der MATLAB-Toolbox Gait-CAD.
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Markus Reischl]
% 
% 
%  Letztes Änderungsdatum: 04-Jun-2007 09:28:11
% 
%  Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU General Public License,
%  wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren,
%  entweder gemäß Version 2 der Lizenz oder jeder späteren Version.
% 
%  Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, dass es Ihnen von Nutzen sein wird,
%  aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder
%  der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK.
%  Details finden Sie in der GNU General Public License.
% 
%  Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm erhalten haben.
%  Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
%  Weitere Erläuterungen zu Gait-CAD finden Sie in der beiliegenden Dokumentation oder im folgenden Konferenzbeitrag:
% 
%  MIKUT, R.; BURMEISTER, O.; REISCHL, M.; LOOSE, T.:  Die MATLAB-Toolbox Gait-CAD.
%  In:  Proc., 16. Workshop Computational Intelligence, S. 114-124, Universitätsverlag Karlsruhe, 2006
%  Online verfügbar unter: http://www.iai.fzk.de/projekte/biosignal/public_html/gaitcad.pdf
% 
%  Bitte zitieren Sie diesen Beitrag, wenn Sie Gait-CAD für Ihre wissenschaftliche Tätigkeit verwenden.
% 
%
% The function get_freischalt is part of the MATLAB toolbox Gait-CAD. 
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

if (isindex && size(tag,1) == 1)
    tag = tag';
end;

enabled = zeros(size(tag,1),1);
for i = 1:size(tag,1)
    indx = [];
    if (~isindex)
        indx = get_element_indx(parameter, deblank(tag(i,:)), 'MI');
    else
        indx = tag(i);
    end;
    if (~isempty(indx))
        freischalt_cell = parameter.gui.menu.elements(indx).freischalt;
        % Wenn keine Bedingungen für das Freischalten vorliegen, teste bei den Eltern nach
        % Hier nur auf Enabled abzufragen bringt nichts. Die Enabled-Werte werden erst bei einem
        % Klick auf das Hauptmenü aktualisiert, so dass ein nicht-aktueller Wert abgefragt werden kann.
        if (isempty(freischalt_cell))
            % Besorge einen Vektor mit allen Handles der Menüeinträge
            
            %MATLAB2014B compatibility
            %handles = cell2mat({parameter.gui.menu.elements.handle});
            handles = {parameter.gui.menu.elements.handle};
            %Wer ist der Elter?
            p = get(parameter.gui.menu.elements(indx).handle, 'Parent');
            %Wie heißt sein Index?
            parent_indx = get(p,'tag');
            while (strcmp(get(p, 'type'), 'uimenu') && isempty(freischalt_cell))
                % Es muss der Index des Parents festgestellt werden und darüber die entsprechende Variable erlangt werden.
                %pindex = find(ismember(handles, p));
                %MATLAB2014B compatibility
                pindex = find(ismember({parameter.gui.menu.elements.tag},parent_indx));
                if (~isempty(pindex))
                    freischalt_cell = parameter.gui.menu.elements(pindex).freischalt;
                    p = get(parameter.gui.menu.elements(pindex).handle, 'Parent');
                    parent_indx = get(p,'tag');
                end; % if (~isempty(pindxes))
            end; % while(strcmp(get(p, 'type'), 'uimenu') && isempty(freischalt_cell) & ok)
        end; % if (isempty(freischalt_cell))
        
        % Nun die einzelnen Bedingungen prüfen
        res = 1;
        for j = 1:length(freischalt_cell)
            str = ['mf_erg = 0; if(' freischalt_cell{j} ') mf_erg = 1; end;'];
            evalin('caller', str);
            erg = evalin('caller', 'mf_erg');
            res = res && erg;
            if ~res
                break;
            end;
        end; % for(j = 1:length(freischalt_cell))
        enabled(i) = res;
    end; % if (~isempty(indx))
end;

