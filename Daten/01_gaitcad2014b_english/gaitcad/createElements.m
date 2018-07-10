  function [elements, uihd] = createElements(elements, uihd, subfeldbedingung, fig_handle)
% function [elements, uihd] = createElements(elements, uihd, subfeldbedingung, fig_handle)
%
% 
%  function [elements, uihd] = createElements(elements, uihd, fig_handle)
% 
%   function [elements, uihd] = createElements(elements, uihd)
%   Diese Funktion erzeugt die uicontrol-Element der Gaitcad-GUI.
%   Dafür werden die Elemente in Form eines Strukts übergeben sowie
%   die aktuelle uihd-Matrix. Beide Parameter werden in verändert Form
%   an den Aufrufer zurückgegeben.
%   Zusätzlich kann das Handle der Gaitcad-Figure übergeben werden (default: 1)
% 
%
% The function createElements is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 4)
    fig_handle = 1;
end;
figure(fig_handle);
bg_color = get(fig_handle, 'Color');
for el = 1:length(elements)
    style = elements(el).style;
    pos   = [0 0 elements(el).breite elements(el).hoehe];
    name  = elements(el).name;
    tag = elements(el).tag;
    
    elements(el).handle = uicontrol(fig_handle, 'style', style, 'visible', 'off', 'Position', pos, 'Tag', tag);
    % Bei Text, Checkbox und Radiobox den Hintergrund auf den gleichen setzen wie die Figure:
    switch(style)
        case {'text', 'checkbox', 'radiobutton', 'frame'}
            set(elements(el).handle, 'BackgroundColor', bg_color);
    end;
    if (~isempty(elements(el).uihd_code))
        uihd(elements(el).uihd_code(1), elements(el).uihd_code(2)) = elements(el).handle;
    end;
    if (~isempty(elements(el).bezeichner))
        if ~isfield(elements(el).bezeichner,'tag') || isempty(elements(el).bezeichner.tag)
            elements(el).bezeichner.tag = strcat('HNDL_BEZ_',elements(el).tag);
        end;
        elements(el).bezeichner.handle = uicontrol(fig_handle, 'style', 'text', 'String', [name ' '], ...
            'Position', [0 0 elements(el).bezeichner.breite, elements(el).bezeichner.hoehe], ...
            'BackgroundColor', bg_color, 'HorizontalAlignment', 'right','tag',elements(el).bezeichner.tag);
        uihd(elements(el).bezeichner.uihd_code(1), elements(el).bezeichner.uihd_code(2)) = elements(el).bezeichner.handle;
    else
        set(elements(el).handle, 'String', name);
    end;
    
    % Ist ein userdata-Feld angegeben?
    if (isfield(elements(el), 'userdata') && ~isempty(elements(el).userdata))
        set(elements(el).handle, 'UserData', elements(el).userdata);
    else
        set(elements(el).handle, 'UserData', name);
    end;
    if (~isfield(elements(el), 'ganzzahlig') || isempty(elements(el).ganzzahlig))
        elements(el).ganzzahlig = 0;
    end;
    if (~isempty(elements(el).tooltext))
        set(elements(el).handle, 'TooltipString', elements(el).tooltext);
        if (~isempty(elements(el).bezeichner))
            set(elements(el).bezeichner.handle, 'TooltipString', elements(el).tooltext);
        end;
    end;
    if ((strcmp(elements(el).style, 'listbox') || strcmp(elements(el).style, 'popupmenu')))
        if (~isempty(elements(el).multilistbox) && elements(el).multilistbox)
            set(elements(el).handle, 'max', 2, 'min', 0);
        end;
        if (~isempty(elements(el).listen_werte))
            set(elements(el).handle, 'String', elements(el).listen_werte);
        end;
        if (elements(el).default > size(get(elements(el).handle, 'String'), 1))
            elements(el).default = size(get(elements(el).handle, 'String'), 1);
        end;
    end;
    if (~isfield(elements(el), 'nicht_speichern') || isempty(elements(el).nicht_speichern))
        elements(el).nicht_speichern = 0;
    end;
    
    % Den Default-Wert noch setzen:
    switch(style)
        % Im Edit-Feld muss der Default-Wert in das String-Feld eingetragen werden
        case 'edit'
            set(elements(el).handle, 'String', elements(el).default);
            % Bei allen anderen kommt es in das value-Feld
        otherwise
            if (~isempty(elements(el).default))
                set(elements(el).handle, 'Value', elements(el).default);
            end;
    end;
    
    % Der callback setzt sich wie folgt zusammen. Für edit-Felder wird zunächst ein
    % Bereichscheck durchgeführt. Für Radioelemente werden die restlichen Mitglieder der
    % Gruppe auf 0 gesetzt. Dann wird der Wert des GUI-Elements in die korrekte Variable
    % geschrieben und zum Schluss ein eventuell vorhandener Benutzercallback ausgeführt.
    callback_str = [];
    if (strcmp(elements(el).style, 'edit'))
        callback_str = sprintf('bCheckIndx = ''%s''; bereichs_check;', elements(el).tag);
    end;
    if (strcmp(elements(el).style, 'radiobutton'))
        callback_str = sprintf('radioIndx=''%s''; radiocheck;', elements(el).tag);
    end;
    % Nun das Kopieren des Elements in das Strukt aufrufen
    callback_str = [callback_str sprintf(' ausGUIIndx = ''%s''; ausGUI;', elements(el).tag)];
    % Wenn dieses Element für das Umschalten zwischen Subfeldern zuständig ist, automatisch die
    % set_anzeigeparameter_new aufrufen lassen
    if ~isempty(getfindstr(subfeldbedingung,elements(el).tag)) %if ~isempty(strmatch(elements(el).tag, subfeldbedingung))
        callback_str = [callback_str sprintf(' set_anzeigeparameter_new(parameter, parameter.gui.gew_fenster);')];
    end;
    
    if ~isempty(elements(el).callback)
        % Hinten wird einfach noch ein Semikolon angehängt. Falls es jemand bei der Definition
        % des Callbacks vergisst...
        callback_str = [callback_str ' ' elements(el).callback ';'];
    end;
    set(elements(el).handle, 'Callback', callback_str);
end; % for(i = 1:length(elements))

% Teste noch mal die uihd-Codes
uihds = zeros(length(elements),2);
for el = 1:length(elements)
    if ~isempty(elements(el).uihd_code)
        if ~isempty(uihds) && ismember(elements(el).uihd_code, uihds, 'rows')
            fprintf(1, 'uihd-Code %s wird mehrfach verwendet.\n', num2str(elements(el).uihd_code));
        end;
        uihds(el,:) = elements(el).uihd_code;
    end;
end;
