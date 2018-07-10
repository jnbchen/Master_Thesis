% Script callback_multiD_GUI
%
%  DiffImFigforGui(get(ui(3),''string''),get(ui(4),''value''),get(ui(5),''value''),get(ui(6),''value''),get(ui(7),''value''),get(ui(8),''string''),get(ui(9),''string''),get(ui(12),''string''));
% 
%  Geht bei korrekter eingabe
%  ToDo: Fehler bei Eingabe Abfangen! (zu viele variabel gesetzt oder)
%  (Fehler wenn nicht 'Zahl' '.' 'x')
% 
%
% The script callback_multiD_GUI is part of the MATLAB toolbox Gait-CAD. 
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

clear eingabe
start_ce = 5;       % Überschriften auslassen
for i_read = 1:size(local_regression_plot_d,2)
    eingabe.x{i_read} = get(ui(start_ce +1),'string'); % Einlesen der edit box für Variablen (x oder Zahl)
    % einlesen der min max Werte
    eingabe.range(i_read,:) =  [str2num(strrep(get(ui(start_ce + 2),'string'),',','.')) str2num(strrep(get(ui(start_ce + 3),'string'),',','.'))];
    start_ce = start_ce+5; % Eine Zeile weiter springen
end;

for i_num=1:size(local_regression_plot_d,2)
    if ~strcmp(eingabe.x{i_num},'x') && ~strcmp(eingabe.x{i_num},'y')
        eingabe.x{i_num} = str2num(strrep(eingabe.x{i_num},',','.'));
        
        if isempty(eingabe.x{i_num})
            myerror('In the GUI, 1-2 variables have to be selected with x, 0-1 variables with y. All other variables must be numeric!');
        end;
    end;
end;

eingabe.range_true = 1;

execute_multid_gui_eingabe;

