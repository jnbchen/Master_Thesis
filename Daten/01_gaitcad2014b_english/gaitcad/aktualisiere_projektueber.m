% Script aktualisiere_projektueber
%
% The script aktualisiere_projektueber is part of the MATLAB toolbox Gait-CAD. 
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

max_anzeige = 7;
max_zeilen = 27;
max_zeichen = 80;

ap.str = [];
ap.str = sprintf('Project ''%s''\n\n', parameter.projekt.datei);
% Wenn es keine Zeitreihen gibt, hier noch einmal die GUI aktualisieren. Dann sollte
% das Skript mitbekommen, dass keine Zeitreihe ausgewählt wurde.
if (par.anz_merk == 0)
    parameter.gui.merkmale_und_klassen.ind_zr = [];
    inGUIIndx = 'CE_Auswahl_ZR'; inGUICallback = 0;
    inGUI;
end;

%Bilddaten ergänzen, aber nur dann, wenn es überhaupt Bilder gibt
if ~isempty(d_image.data) && isfield(parameter.gui,'image')
    if size(d_image.data,3) == 1
        image_prj_string ='';
    end;
    if size(d_image.data,3) > 1
        image_prj_string = sprintf('\n      Images with %d slices (%d selected)',size(d_image.data,3),...
            parameter.gui.image.slice_end+1-parameter.gui.image.slice_start);
    end;
    ap.str = [ap.str sprintf('%5d Image(s),  %d Image(s) selected (Options ''Images'')%s\n\n', ...
        par.anz_image, length(parameter.gui.image.ind_image),image_prj_string)];
end;

ap.str = [ap.str sprintf('%5d Time series with %d sample points\n%5d Time series selected (Options: ''Time series: General options'')\n\n', ...
    par.anz_merk, par.laenge_zeitreihe, length(parameter.gui.merkmale_und_klassen.ind_zr))];
% Hier das gleiche wie oben für die Zeitreihen.
if (par.anz_einzel_merk == 0)
    parameter.gui.merkmale_und_klassen.ind_em = [];
    inGUIIndx = 'CE_Auswahl_EM'; inGUICallback = 0;
    inGUI;
end;
ap.str = [ap.str sprintf('%5d Single features\n%5d Single feature(s) selected (Options: ''Single features'')\n\n', ...
    par.anz_einzel_merk, length(parameter.gui.merkmale_und_klassen.ind_em))];
tmp_str = sprintf('%5d Output variables (Names: ', par.anz_y);
% Die Namen der Ausgangsgrößen aufzählen, aber nur die ersten paar (wenn es viele gibt)
if (par.anz_y > max_anzeige)
    ende = max_anzeige;
    ende_str = ', ...';
else
    ende = par.anz_y;
    ende_str = '';
end;
tmp_str = [tmp_str sprintf('''%s''', deblank(bez_code(1,:)))];
for i = 2:ende
    tmp_str = [tmp_str sprintf(', ''%s''', deblank(bez_code(i,:)))];
end;
tmp_str = [tmp_str ende_str sprintf(')\n')];
% Wenn tmp_str jetzt größer als max_zeichen ist, einfach ein paar Zeichen abschneiden:
while(length(tmp_str) > max_zeichen)
    % Aber möglich nach einem Komma abschneiden
    kommata = strfind(tmp_str, ',');
    %may be problems with extremely long output variable names?
    if isempty(kommata)
        break;
    end;
    tmp_str = [tmp_str(1:kommata(end)-1) '...)'];
end;
ap.str = [ap.str tmp_str sprintf('\n')];
ap.str = [ap.str sprintf('''%s'' selected\n\n', deblank(bez_code(par.y_choice,:)))];


ap.str = [ap.str sprintf('%5d Data points\n', par.anz_dat)];
ap.str = [ap.str sprintf('%5d Selected data points\n\n', length(ind_auswahl))];
% Die Datenauswahl der Klassen beschreiben:
if ((length(ind_auswahl) ~= par.anz_dat) && exist('auswahl', 'var') && isfield(auswahl, 'dat') && ~isempty(auswahl.dat))
    if (~iscell(auswahl.dat))
        zeilen = find(auswahl.dat(:,1)>1);
    else
        zeilen = [];
    end;
else
    zeilen = [];
end;
if ~isempty(zeilen)
    ap.str = [ap.str sprintf('Only data points of the following class(es) were selected:\n')];
    % In auswahl.dat nach Zeilen suchen, die Elemente > 1 enthalten
    % Nur bei denen findet eine Auswahl bezogen auf die Ausgangsgröße statt. Ansonsten
    % spielt diese Ausgangsgröße keine Rolle für die Datenauswahl
    temp_name ='';
    for i = 1:length(zeilen)
        if (i ~= 1)
            ap.str = [ap.str sprintf('\n');];
        end;
        temp_name = [temp_name sprintf('%s: ', deblank(bez_code(zeilen(i),:)))];
        gew_klassen = auswahl.dat(zeilen(i), find(auswahl.dat(zeilen(i),:) > 0))-1;
        if (length(gew_klassen) > 2*max_anzeige)
            ende = 2*max_anzeige; ende_str = ', ...';
        else
            ende = length(gew_klassen); ende_str = '';
        end;
        temp_name = [temp_name sprintf('''%s''', zgf_y_bez(zeilen(i), gew_klassen(1)).name)];
        for j = 2:ende
            temp_name = [temp_name sprintf(', ''%s''', zgf_y_bez(zeilen(i), gew_klassen(j)).name)];
        end;
        if length(temp_name)> max_zeichen-4
            temp_name = [temp_name(1:max_zeichen-4) ' ...'];
        end;
        ap.str = [ap.str temp_name ende_str];
    end;
end;

% Hier eine zusätzliche Abfrage auf die Größe von ind_auswahl.
% Einige Klassifikatoren verändern intern die Größe des Datensatzes und
% erzielen daher z.T. Auswahlen, die Größer als im originalen Datensatz sind.
% Dies ist nicht zu verhindern und wird daher hier abgefangen.
if (length(ind_auswahl) ~= par.anz_dat && length(ind_auswahl) <= size(code_alle,1))
    if ~isempty(zeilen)
        ap.str = [ap.str sprintf('\n\n')];
        [B, I, J] = unique(code_alle(ind_auswahl,zeilen), 'rows');
        I = generate_rowvector(I);
        J = generate_rowvector(J);
        
        % zgf_y_bez wird beim Laden automatisch generiert, wenn es nicht im Projekt vorhanden ist.
        if (size(B,1) > 2*max_anzeige)
            ende = 2*max_anzeige;
            ende_str = '...';
        else
            ende = size(B,1);
            ende_str = '';
        end; % if (size(B,1) > 2*max_anzeige)
        for i = 1:ende
            % Zunächst die Anzahl der Datentupel in einer Kombination bestimmen. Wird von unique schon fast mitgeliefert.
            temp_name = '';
            temp_name = [temp_name sprintf('%5d Data points with ', length(find(J == i)))];
            % Anschließend die einzelnen Klassen benennen:
            
            for j = 1:size(B,2)
                temp_name = [temp_name sprintf('%s: %s', deblank(bez_code(zeilen(j),:)), zgf_y_bez(zeilen(j), B(i,j)).name)];
                if (j ~= size(B,2))
                    temp_name = [temp_name sprintf(', ')];
                end;
            end;
            if length(temp_name)> max_zeichen-4
                temp_name = [temp_name(1:max_zeichen-4) ' ...'];
            end;
            if (i ~= ende)
                ap.str = [ap.str temp_name sprintf('\n')];
            else
                ap.str = [ap.str temp_name ' ' ende_str];
            end; % if (i ~= ende)
        end; % for(i = 1:ende)
    else
        ap.str = [ap.str sprintf('%d data points manually selected.', length(ind_auswahl))];
    end; % if (~isempty(zeilen))
else
    ap.str = [ap.str sprintf('All data points were selected\n(menu item Edit/Select/Data)...)')];
end; % if (length(ind_auswahl) ~= par.anz_dat)

% Nun auf max_zeilen beschränken. Es dürfen als maximal max_zeilen viele \n vorkommen:
umbrueche = strfind(ap.str, sprintf('\n'));
if (length(umbrueche) > (max_zeilen - 1))
    ap.str = ap.str(1:umbrueche(max_zeilen-1)-1);
    ap.str = [ap.str sprintf('\n...')];
end;

%tags = {parameter.gui.control_elements.tag};
myhandle  = gaitfindobj('CE_Projektuebersicht');
if ~isempty(myhandle)
    set(myhandle, 'HorizontalAlignment', 'Left', 'Max', 2, 'Min', 0, 'FontName', 'Courier New', 'FontSize', 9);
    parameter.gui.projektuebersicht.text = ap.str;
    inGUIIndx = 'CE_Projektuebersicht';
    inGUI;
end;
clear tmp_str kommata zeilen gew_klassen B I J max_anzeige ap ende ende_str umbrueche indx;
