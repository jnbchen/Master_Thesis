  function [elements, uihd] = createMenuElements(main_menu, elements, uihd, fig_handle, debug_mode)
% function [elements, uihd] = createMenuElements(main_menu, elements, uihd, fig_handle, debug_mode)
%
% 
%  Diese Funktion erzeugt die Menüelemente anhand vordefinierter Strukturen.
%  Der Vektor main_menu enthält die Elemente des Hauptmenüs.
%  Das Strukt elements enthält alle Menüelemente (inklusive der für das Hauptmenü).
%  uihd ist die Gait-CAD uihd-Matrix und kann leer sein.
%  fig_handle ist ein optionaler Übergabeparameter, der die figure angibt,
%  in der das Menü erzeugt wird.
% 
%  Zurückgegeben werden die Menüelemente, bei denen der Wert des Handles aktualisiert wurde.
%  Außerdem wird eine ebenfalls mit den Handles gefüllte uihd-Matrix zurückgegeben.
% 
%  Die Funktion verwendet zum Erzeugen der Elemente new_menu bzw. new_menu_af. Für die
%  Definition der Menüelemente siehe menu_elements.m
% 
% 
% 
%
% The function createMenuElements is part of the MATLAB toolbox Gait-CAD. 
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
if (nargin < 5)
    debug_mode = 1;
end;

used = [];
tags = {elements.tag};

% Gehe nun alle Elemente auf der Menüleiste durch und fülle sie nach und nach
for nc = 1:length(main_menu)
    el = find(strcmp(main_menu{nc}, tags));
    if (isempty(el))
        warning(sprintf('No element with tag %s found!\n', main_menu{nc}));
    else
        if (length(el) > 1)
            warning(sprintf('Tag %s is multiple used!', main_menu{nc}));
        end;
        el = el(1);
        
        tag = elements(el).tag;
        if (isempty(tag))
            tag = '';
        end;
        elements(el).handle = uimenu(fig_handle, 'Label', elements(el).name, 'Tag', tag);
        if (isempty(elements(el).freischalt_c))
            elements(el).freischalt_c = 0;
        end;
        % Die Hauptmenüeinträge sollen sich selbst untersuchen:
        callback = sprintf('menu_freischalten(parameter, parameter.gui.menu.hm_freischalt.%s); ', tag);
        if (~isempty(elements(el).callback))
            help_callback = sprintf('act_help_tag = %d;manage_help_tag;',el);
            callback = strcat(help_callback, callback, elements(el).callback);
        end;
        set(elements(el).handle, 'Callback', callback);
        if (~isempty(elements(el).uihd_code))
            uihd(elements(el).uihd_code(1), elements(el).uihd_code(2)) = elements(el).handle;
        end;
        used = [used el];
        % Menüpunkt mit einzelnen Elementen füllen
        if isfield(elements(el), 'menu_items') && ~isempty(elements(el).menu_items)
            [elements, uihd, used] = subCreateMenuElement(elements, uihd, elements(el).menu_items, elements(el).handle, used, debug_mode);
        end; % if (isfield(elements(el), 'menu_items') && ~isempty(elements(el).menu_items))
    end;
end;

% Die restlichen Elemente werden versteckt, um die Funktionalität zu erhalten.
% Einige Funktionen greifen evtl. über den uihd-Index darauf zu.
ausgabe = 0;
rest = setxor(used, [1:length(elements)]);
for nc = 1:length(rest)
    el = rest(nc);
    tag = elements(el).tag;
    if (isempty(tag))
        tag = '';
    end;
    callback = elements(el).callback;
    if (isempty(callback))
        callback = '';
    end;
    elements(el).handle = uimenu(fig_handle, 'Label', elements(el).name, 'Tag', tag, 'Callback', callback, 'visible', 'off');
    if (isempty(elements(el).freischalt_c))
        elements(el).freischalt_c = 0;
    end;
    if (ausgabe)
        fprintf(1, 'Element %s (Tag: %s) is unused!\n', elements(el).name, elements(el).tag);
    end;
    uihd(elements(el).uihd_code(1), elements(el).uihd_code(2)) = elements(el).handle;
end;

% Teste noch mal die uihd-Codes.
% Eigentlich sind die Dinger nicht mehr nötig, aber autodoku braucht sie und mag es nicht, wenn
% sie doppelt vorkommen...
uihds =[];
for el = 1:length(elements)
    if (~isempty(elements(el).uihd_code))
        if (~isempty(uihds) && ismember(elements(el).uihd_code, uihds, 'rows'))
            fprintf(1, 'uihd-Code %s wird mehrfach verwendet.\n', num2str(elements(el).uihd_code));
        end;
        uihds = [uihds;elements(el).uihd_code];
    end;
end;


function [elements, uihd, used] = subCreateMenuElement(elements, uihd, items, parent, used, debug_mode)
separator_on = 0;
tags = {elements.tag};
if (~iscell(items))
    items = {items};
end;
for c = 1:length(items)
    % Ist das Element das Trennzeichen?
    if (~ischar(items{c}) && items{c} == -1)
        separator_on = 1;
    else
        el = find(strcmp(items{c}, tags));
        if isempty(el)
            warning(sprintf('No element with tag %s found!\n', items{c}));
        else
            if (length(el) > 1)
                warning(sprintf('Tag %s is multiple used!', items{c}));
            end;
            el = el(1);
            if (separator_on)
                separator = 'on';
                separator_on = 0;
            else
                separator = 'off';
            end;
            % Initialisiere die endgültigen Werte vor. [] wird bei Zeichenketten nicht gerne gesehen...
            if (isfield(elements(el), 'callback') && ~isempty(elements(el).callback))
                callback = elements(el).callback;
                help_callback = sprintf('act_help_tag = %d;manage_help_tag;',el);
                % Hänge hinten einen Callback für das Einfügen der Funktion in die Favoriten an.
                fav_callback = sprintf('parameter.gui.menu.favoriten=aktualisiere_favoriten(parameter.gui.menu.favoriten, ''%s'', parameter, ''ADD'', parameter.gui.menu.favoriten.param); callback_update_favoriten;', ...
                    items{c});
                callback = [help_callback callback ' ' fav_callback];
            else
                callback = '';
            end;
            if isfield(elements(el), 'tag') && ~isempty(elements(el).tag)
                tag = elements(el).tag;
            else
                tag = '';
            end;
            
            % Handelt es sich um einen Menüpunkt, bei dem ein Auswahlfenster gezeigt werden soll oder nicht?
            if ~isfield(elements(el), 'menu_af') || isempty(elements(el).menu_af)
                handle = new_menu(parent, elements(el).name, callback, elements(el).delete_pointerstatus, tag, separator, debug_mode);
            else
                if isfield(elements(el), 'callback_af') && ~isempty(elements(el).callback_af)
                    callback_af = elements(el).callback_af;
                else
                    callback_af = '';
                end;
                if (isfield(elements(el), 'menu_af_manu') && ~isempty(elements(el).menu_af_manu))
                    handle = new_menu_af(parent, elements(el).name, callback_af, elements(el).menu_af, tag, separator, elements(el).menu_af_manu, debug_mode);
                else
                    handle = new_menu_af(parent, elements(el).name, callback_af, elements(el).menu_af, tag, separator, [], debug_mode);
                end;
                help_callback = sprintf('act_help_tag = %d;manage_help_tag;',el);
                
                % Callback für die Favoriten anhängen.
                fav_callback = sprintf('parameter.gui.menu.favoriten=aktualisiere_favoriten(parameter.gui.menu.favoriten, ''%s'', parameter, ''ADD'', parameter.gui.menu.favoriten.param); callback_update_favoriten;', ...
                    items{c});
                set(handle, 'Callback', [get(handle, 'Callback') '; ' help_callback ' ' fav_callback]);
                % Falls es einen weiteren Callback gibt, hinten anhängen
                if (isfield(elements(el), 'callback') && ~isempty(elements(el).callback))
                    set(handle, 'Callback', [get(handle, 'Callback') '; ' elements(el).callback]);
                end;
            end; % if (~isfield(elements(el), 'menu_af') || isempty(elements(el).menu_af))
            elements(el).handle = handle;
            if (~isempty(elements(el).uihd_code))
                uihd(elements(el).uihd_code(1), elements(el).uihd_code(2)) = handle;
            end;
            if (isempty(elements(el).freischalt_c))
                elements(el).freischalt_c = 0;
            end;
            used = [used el];
            % Gibt es Unter-Elemente?
            if (isfield(elements(el), 'menu_items') && ~isempty(elements(el).menu_items))
                % Ja, gibt es. Also rekursiv diese Funktion aufrufen, aber warnen, wenn es auch einen Callback gibt...
                if (~isempty(elements(el).callback))
                    warning(sprintf('The menu element %d (%s) contains sub elements and a callback!', el, elements(el).name));
                end;
                [elements, uihd, used] = subCreateMenuElement(elements, uihd, elements(el).menu_items, elements(el).handle, used, debug_mode);
            end;
        end; % if (isempty(el))
    end; % if (el == -1)
end; % for(c = 1:length(items))
