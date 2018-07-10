% Script callback_export
%
% 
%  Öffnet die GUI zum Importieren von Dateien und
%  legt den Callback zur ausführenden Datei an.
%
% The script callback_export is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:57
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

clear optionen export_gui;

x_size = 500;
y_size = 500;
bg_color = [.8 .8 .8];
screensize = get(0, 'ScreenSize');
% Zentrale Position berechnen.
x_pos = (screensize(3)-x_size)/2;
y_pos = (screensize(4)-y_size)/2;
export_gui.h = figure;
set(export_gui.h, 'NumberTitle', 'off', 'Name', 'Gait-CAD Export', 'Position', [x_pos, y_pos, x_size, y_size], 'MenuBar', 'none', 'Resize', 'off', 'color', bg_color);

if ~isempty(next_function_parameter)
    datei_save_export = next_function_parameter;
end;

if ~exist('modus', 'var')
    modus = 2;
end;

% Datei suchen
if modus == 1 && ~exist('datei_save_export','var')
    [datei, pfad] = uiputfile('*.*', 'Export data in a file');
    if (datei == 0)
        delete(export_gui.h);
        clear modus;
        return;
    end;
    % Wenn eine Dateiendung fehlt, hänge einfach .txt an.
    [dummy, dummy, ext] = fileparts(datei);
    if (isempty(ext))
        datei = [datei '.txt'];
    end;
end;
clear datei_save_export;

export_gui.ce(1).bez.h = uicontrol(export_gui.h, 'style', 'text');
set(export_gui.ce(1).bez.h, 'HorizontalAlignment', 'right', 'Position', [20, 447, 100 20], 'BackgroundColor', bg_color);
if (modus == 1)
    export_gui.ce(1).h = uicontrol(export_gui.h, 'style', 'text', 'Position', [150 447 300 20], 'BackgroundColor', bg_color);
    set(export_gui.ce(1).bez.h, 'String', 'Target file');
    set(export_gui.ce(1).h, 'String', [pfad datei], 'HorizontalAlignment', 'left');
else
    export_gui.ce(1).h = uicontrol(export_gui.h, 'style', 'edit', 'Position', [150 450 300 20], 'HorizontalAlignment', 'left');
    set(export_gui.ce(1).bez.h, 'String', 'Target directory');
    toolstring = sprintf('Exporting data for different output variables in separate directories, if checkbox is active.\n');
    toolstring = [toolstring sprintf('Die Daten sind dann Hierarchisch in den ihrer Ausgangsgrößen entsprechenden Ordner einsortiert.\n')];
    toolstring = [toolstring sprintf('Example: The data points with the following output variables will be written in the following files:\n')];
    toolstring = [toolstring sprintf('(left, 1, 1): <Target>\\left\\1\\1.txt\n')];
    toolstring = [toolstring sprintf('(left, 2, 1): <Target>\\left\\2\\1.txt\n')];
    toolstring = [toolstring sprintf('(left, 2, 2): <Target>\\left\\2\\2.txt\n')];
    toolstring = [toolstring sprintf('(right, 1, 1): <Target>\\right\\1\\1.txt\n')];
    toolstring = [toolstring sprintf('All output variables are coded in the file name if this option is chosen.\n')];
    toolstring = [toolstring sprintf('In this example  <Target>\\left_1_1.txt, <Target>\\left_2_1.txt, ...\n')];
    toolstring = [toolstring sprintf('The separator for output variables can be modified.\n')];
    export_gui.ce(2).h = uicontrol(export_gui.h, 'Style', 'checkbox', 'String', 'Write output variables in subdirectories', ...
        'Position', [150 420 300 20], 'BackgroundColor', bg_color, 'value', 1, 'TooltipString', toolstring);
    export_gui.ce(13).h = uicontrol(export_gui.h, 'style', 'edit', 'Position', [150 390 50 20], 'String', '.txt', ...
        'TooltipString', 'Defines the file extension.');
    export_gui.ce(13).bez.h = uicontrol(export_gui.h, 'style', 'text', 'String', 'File extension', 'Position', [20 387 100 20], 'BackgroundColor', bg_color, ...
        'HorizontalAlignment', 'right');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frame Klassentrennzeichen
export_gui.frame(1).h = uicontrol(export_gui.h, 'Style', 'frame', 'Position', [10 285 230 80], 'BackgroundColor', bg_color);
export_gui.frame(1).bez.h = uicontrol(export_gui.h, 'HorizontalAlignment', 'left', 'style', 'text', 'Position', [15 357 165 15], ...
    'String', 'Separator for output variables', 'BackgroundColor', bg_color);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trennzeichen Dateinamen
tooltip = sprintf('Defines the separator symbol in the file name for output variables.\nExample: A data point has the output variables left and  1.\n');
tooltip = [tooltip sprintf('The underscore is chosen as separator and the output variable is not coded in subdirectories.\nThe resulting file name is left_1.txt.')];
export_gui.ce(4).bez.h = uicontrol(export_gui.h, 'style', 'text', 'String', 'for file names', 'TooltipString', tooltip);
set(export_gui.ce(4).bez.h, 'HorizontalAlignment', 'right', 'Position', [20 327 100 20], 'BackgroundColor', bg_color);
export_gui.ce(4).h = uicontrol(export_gui.h, 'style', 'popupmenu', 'String', 'None|Blank|Underscore|Hyphen|Semicolon|Comma', ...
    'Position', [150 330 85 20], 'TooltipString', tooltip);
if (modus == 1)
    set(export_gui.ce(4).h, 'enable', 'off');
    set(export_gui.ce(4).bez.h, 'enable', 'off');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frame Dateitrennzeichen
export_gui.frame(2).h = uicontrol(export_gui.h, 'Style', 'frame', 'Position', [260 285 230 80], 'BackgroundColor', bg_color);
export_gui.frame(2).bez.h = uicontrol(export_gui.h, 'HorizontalAlignment', 'left', 'style', 'text', 'Position', [265 357 125 15], ...
    'String', 'Separator in the file', 'BackgroundColor', bg_color);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trennzeichen Dezimalzeichen
tooltip = 'Defines the separator for the decimal point.';
export_gui.ce(5).bez.h = uicontrol(export_gui.h, 'style', 'text', 'String', 'Decimal numbers', 'TooltipString', tooltip);
set(export_gui.ce(5).bez.h, 'HorizontalAlignment', 'right', 'Position', [270 327 100 20], 'BackgroundColor', bg_color);
export_gui.ce(5).h = uicontrol(export_gui.h, 'style', 'popupmenu', 'String', 'Point|Comma', ...
    'Position', [400 330 85 20], 'TooltipString', tooltip);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trennzeichen Spalten
tooltip = 'Defines the separator symbol for columns (and therefore for single features or time series).';
export_gui.ce(6).bez.h = uicontrol(export_gui.h, 'style', 'text', 'String', 'for columns', 'TooltipString', tooltip);
set(export_gui.ce(6).bez.h, 'HorizontalAlignment', 'right', 'Position', [270 297 100 20], 'BackgroundColor', bg_color);
export_gui.ce(6).h = uicontrol(export_gui.h, 'style', 'popupmenu', 'String', 'Blank|Underscore|Hyphen|Tabulator|Semicolon|Comma', ...
    'Position', [400 300 85 20], 'TooltipString', tooltip);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frame Importoptionen
export_gui.frame(3).h = uicontrol(export_gui.h, 'Style', 'frame', 'Position', [10 85 480 180], 'BackgroundColor', bg_color);
export_gui.frame(3).bez.h = uicontrol(export_gui.h, 'HorizontalAlignment', 'left', 'style', 'text', 'Position', [15 257 55 15], ...
    'String', 'Export', 'BackgroundColor', bg_color);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Zeile Bezeichner
export_gui.ce(7).h = uicontrol(export_gui.h, 'style', 'checkbox', 'String', 'Write names in first row', ...
    'Position', [20 230 200 20], 'BackgroundColor', bg_color, 'TooltipString', 'Writing variable names in first row of the file, if checkbox is active.');
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nur ausgewählte Datentupel und Merkmale exportieren
export_gui.ce(8).h = uicontrol(export_gui.h, 'style', 'checkbox', 'String', 'Export only selected data points and features', ...
    'Position', [20 200 300 20], 'BackgroundColor', bg_color, 'TooltipString', 'If this option is active, only selected data points and single features resp. time series will be exported.');
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exportieren von Ausgangsgrößen
% Gibt beim Export von Einzelmerkmalen an, ob die Ausgangsgrößen in Form von Einzelmerkmalen exportiert werden sollen.
tooltip = 'Export of all output variables as additional single features?';
export_gui.ce(10).h = uicontrol(export_gui.h, 'style', 'Checkbox', 'Position', [20 170 300 20], ...
    'String', 'Export output variables as single features', 'value', 1, 'TooltipString', tooltip, ...
    'BackgroundColor', bg_color);
if (modus == 2)
    set(export_gui.ce(10).h, 'Visible', 'off');
end;


export_gui.ce(11).h = uicontrol(export_gui.h, 'style', 'pushbutton', 'String', 'OK', 'callback', 'button = 1; set(export_gui.h, ''visible'', ''off'');', ...
    'Position', [130 25 100 20]);
export_gui.ce(12).h = uicontrol(export_gui.h, 'style', 'pushbutton', 'String', 'Cancel', 'callback', 'button = 0; set(export_gui.h, ''visible'', ''off'');', ...
    'Position', [280 25 100 20]);

clear button;
% Die Buttons führen dazu, dass die eingeblendete Figure auf unsichtbar gesetzt wird.
% Das folgende Kommando wartet auf genau diesen Zustand. Der wird ebenfalls erreicht, wenn die Figure gelöscht wird.
figure(export_gui.h);
drawnow;
waitfor(export_gui.h, 'Visible', 'off');

if (~exist('button', 'var'))
    button = 0;
end;
if (~button)
    fprintf(1, 'Canceled by the user\n');
else
    % Bereite die Optionen vor.
    ziel = get(export_gui.ce(1).h, 'String');
    trennzeichen = char(' ', '_', '-', sprintf('\t'), ';', ',');
    trennzeichen_d = char(' ', '_', '-', ';', ',');
    
    indx = get(export_gui.ce(4).h, 'value');
    if (indx > 1)
        optionen.klassentrennzeichen.datei = trennzeichen_d(indx-1);
    end;
    if (get(export_gui.ce(5).h, 'value') == 1)
        optionen.dezimaltrennzeichen = '.';
    else
        optionen.dezimaltrennzeichen = ',';
    end;
    indx = get(export_gui.ce(6).h, 'value');
    optionen.spaltentrennzeichen = trennzeichen(indx);
    if (optionen.spaltentrennzeichen == optionen.dezimaltrennzeichen)
        myerror('Error! Separators for columns and decimal points are identical.');
        return;
    end;
    optionen.firstline_bez = get(export_gui.ce(7).h, 'value');
    optionen.ordner_rekursiv = get(export_gui.ce(2).h, 'value');
    nur_auswahl = get(export_gui.ce(8).h, 'value');
    if (modus == 2)
        optionen.dateiendung = get(export_gui.ce(13).h, 'String');
        % Bei der Dateiendung muss ein Punkt vorne sein.
        if (optionen.dateiendung(1) ~= '.')
            optionen.dateiendung = ['.' optionen.dateiendung];
        end;
    end;
    exp_klassen = get(export_gui.ce(10).h, 'value');
    
    if (nur_auswahl)
        ausgangsgroessen.code = code_alle(ind_auswahl, :);
        ausgangsgroessen.zgf_y_bez = zgf_y_bez;
    else
        ausgangsgroessen.code = code_alle;
        ausgangsgroessen.zgf_y_bez = zgf_y_bez;
    end;
    
    %repair names to avoid invalid filenames for export
    for i_output1 = 1:par.y_choice
        for i_output2 = 1:par.anz_ling_y(i_output1)
            ausgangsgroessen.zgf_y_bez(i_output1,i_output2).name = repair_dosname(ausgangsgroessen.zgf_y_bez(i_output1,i_output2).name);
        end;
    end;
    
    
    
    
    try
        delete(export_gui.h);
    catch
    end;
    if (modus == 2)
        optionen.ziel_ist_datei = 0;
        optionen.inhalt = 1;
        %%%%%%
        % Beim Exportieren in mehrere Dateien muss sichergestellt sein,
        % das Eindeutige Ausgangsgrößen vorhanden sind. Ansonsten werden Dateien mehrfach angelegt
        % und überschrieben, so dass nicht alle Daten exportiert werden können.
        % Dazu wird code_alle untersucht.
        [B, I, J] = unique(ausgangsgroessen.code, 'rows');
        if (  ( nur_auswahl && size(B,1) ~= length(ind_auswahl)) || ...
                (~nur_auswahl && size(B,1) ~= size(d_orgs,1)) )
            % Die Ausgangsgrößen sind nicht eindeutig. Frage nach, ob die Ausgangsgrößen angepasst werden sollen,
            % oder ob das Exportieren abgebrochen wird:
            ButtonName=questdlg('The output variables are non unique. As a consequence, some data points can not be exported. Should Gait-CAD add a output variable to generate a unique solution?','Export error', 'Yes', 'No', 'Cancel', 'Yes');
            if (strcmp(ButtonName, 'Yes'))
                fprintf(1, 'Add new output variable...');
                if (nur_auswahl)
                    daten_vek = ind_auswahl;
                else
                    daten_vek = [1:size(d_orgs,1)]';
                end;
                if (size(daten_vek,2) ~= 1)
                    daten_vek = daten_vek';
                end;
                ausgangsgroessen.code = [ausgangsgroessen.code daten_vek];
                last_code = size(ausgangsgroessen.code,2);
                for i = 1:length(daten_vek)
                    ausgangsgroessen.zgf_y_bez(last_code, i).name = sprintf('%d', daten_vek(i));
                end;
                fprintf(1, 'ready.\n');
            else
                fprintf(1, 'Cancel export.\n');
                return;
            end;
        end;
        %%%%%%
        if (nur_auswahl)
            if (isempty(parameter.gui.merkmale_und_klassen.ind_zr))
                myerror('No time series selected. Cancel.');
                return;
            end;
            exportiere_daten(d_orgs(ind_auswahl, :, parameter.gui.merkmale_und_klassen.ind_zr), ziel, ausgangsgroessen, ...
                deblank(var_bez(parameter.gui.merkmale_und_klassen.ind_zr,:)), optionen);
        else
            exportiere_daten(d_orgs, ziel, ausgangsgroessen, var_bez(1:size(var_bez,1)-1,:), optionen);
        end;
    else
        optionen.ziel_ist_datei = 1;
        optionen.inhalt = 2;
        if (nur_auswahl)
            if (isempty(parameter.gui.merkmale_und_klassen.ind_em))
                myerror('No single features selected. Cancel.');
                return;
            end;
            daten_ex = d_org(ind_auswahl, parameter.gui.merkmale_und_klassen.ind_em);
            daten_bez = deblank(dorgbez(parameter.gui.merkmale_und_klassen.ind_em,:));
            code_ex   = code_alle(ind_auswahl,:);
        else
            daten_ex = d_org;
            daten_bez = dorgbez;
            code_ex   = code_alle;
        end;
        % Sollen die Ausgangsgrößen als Einzelmerkmale gespeichert werden?
        if (exp_klassen)
            daten_ex = [daten_ex code_ex];
            daten_bez = char(daten_bez, bez_code);
        end;
        exportiere_daten(daten_ex, ziel, ausgangsgroessen, daten_bez, optionen);
        clear daten_ex daten_bez code_ex;
    end;
end;

try
    delete(export_gui.h);
catch
end;

clear x_size y_size screensize x_pos y_pos export_gui pfad button str val indx modus ausgangsgroessen ziel optionen last_code daten_vek;