% Script callback_import
%
% 
%  Öffnet die GUI zum Importieren von Dateien und
%  legt den Callback zur ausführenden Datei an.
%
% The script callback_import is part of the MATLAB toolbox Gait-CAD. 
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

clear optionen import_gui;

%Zwischenstufe, um von außen Parameter übergeben zu können

%Existence of import options
if ~isfield(parameter.gui,'import')
   parameter.gui.import.quelle  = '';
end;

%Element 1: File or directory name
if ~isfield(parameter.gui.import,'quelle')
   parameter.gui.import.quelle = '';
end;

%Element 2: look for subdirectories: 1 yes, 0 no
if ~isfield(parameter.gui.import,'ordner_rekursiv')
   parameter.gui.import.ordner_rekursiv = 1;
end;

% trennzeichen =   1: None, 2:7: strvcatnew(' ', '_', '-', sprintf('\t'), ';', ',');
%Element 3: Number of separator for directories
if ~isfield(parameter.gui.import,'klassentrennzeichen') || ~isfield(parameter.gui.import.klassentrennzeichen,'ordner')
   parameter.gui.import.klassentrennzeichen.ordner = 1;
end;

%Element 4: Number of separator for files
% trennzeichen_d = 1: None, 2:7 strvcatnew(' ', '_', '-', ';', ',');
if ~isfield(parameter.gui.import,'klassentrennzeichen') || ~isfield(parameter.gui.import.klassentrennzeichen,'datei')
   parameter.gui.import.klassentrennzeichen.datei = 1;
end;

%Element 5: separator for decimal digits, 1: '.', 2: ','
if ~isfield(parameter.gui.import,'dezimaltrennzeichen')
   parameter.gui.import.dezimaltrennzeichen = 1;
end;

%Element 6: separator for columns in an ascii file
%'Leerzeichen|Unterstrich|Bindestrich|Tabulator|Semikolon|Komma'
if ~isfield(parameter.gui.import,'spaltentrennzeichen')
   parameter.gui.import.spaltentrennzeichen = 1;
end;

%Element 7: names in the first line of a file?
if ~isfield(parameter.gui.import,'firstline_bez')
   parameter.gui.import.firstline_bez = 1;
end;

%Element 8: ignore lines starting with the following character
if ~isfield(parameter.gui.import,'ignoriere_zeilen_mit')
   parameter.gui.import.ignoriere_zeilen_mit = '';
end;

%Element 9: ignore the first n lines (use a string with a number, e.g. '3')
if ~isfield(parameter.gui.import,'ignore_firstlines')
   parameter.gui.import.ignore_firstlines = '';
end;

%Element 10: Import time series: 1, Import single features: 2
if ~isfield(parameter.gui.import,'inhalt')
   parameter.gui.import.inhalt = 1;
end;

%Element 11: OK
%Element 12: Cancel

%Element 13: File extension
if ~isfield(parameter.gui.import,'dateiendung')
   parameter.gui.import.dateiendung = '.txt';
end;

%Element 14: Matching of time series lengths: 1:  'resampling', 2: 'zeros', 3: '(copy) last_value'
if ~isfield(parameter.gui.import,'gleiche_laenge')
   parameter.gui.import.gleiche_laenge = 1;
end;

%Element 15: Import style
% 'Read row by row|Write copy and read again|Normal mode|Standard ASCII'
if ~isfield(parameter.gui.import,'importfct')
   parameter.gui.import.importfct = 3;
end;

%Element 16: Write in separate projects (import of files from a directory)
if ~isfield(parameter.gui.import,'separate_projects')
   parameter.gui.import.separate_projects = 0 ;
end;

%Saves a project file automatically if 1
if ~isfield(parameter.gui.import,'auto_save_file')
   parameter.gui.import.auto_save_file = 0 ;
end;

%Ignore GUI warnings if 1
if ~isfield(parameter.gui.import,'ignore_warnings')
   parameter.gui.import.ignore_warnings = 0 ;
end;



x_size = 500;
y_size = 500;
bg_color = [.8 .8 .8];
screensize = get(0, 'ScreenSize');
% Zentrale Position berechnen.
x_pos = (screensize(3)-x_size)/2;
y_pos = (screensize(4)-y_size)/2;
import_gui.h = figure;
set(import_gui.h, 'NumberTitle', 'off', 'Name', 'Gait-CAD Import', ...
   'Position', [x_pos, y_pos, x_size, y_size], 'MenuBar', 'none', 'Resize', 'off', 'color', bg_color);
if (~exist('modus', 'var'))
   modus = 2;
end;
% Datei suchen
if (modus == 1)
   if isempty(parameter.gui.import.quelle)
      [parameter.gui.import.quelle, pfad] = uigetfile('*.*', 'Import file');
   else
      pfad = fileparts(parameter.gui.import.quelle);
      if isempty(pfad)
         parameter.gui.import.quelle = which(parameter.gui.import.quelle);
         pfad = fileparts(parameter.gui.import.quelle);
      end;
      
   end;
   
   %hat es geklappt
   if ischar(parameter.gui.import.quelle) && ischar(pfad) && isdir(pfad)
      cd(pfad);
   end;
   
   if ~ischar(parameter.gui.import.quelle) || ~exist(parameter.gui.import.quelle,'file')
      delete(import_gui.h);
      clear modus;
      if ischar(parameter.gui.import.quelle)
         myerror(sprintf('File % not found',parameter.gui.import.quelle));
      else 
         parameter.gui.import.quelle = '';
      end;
      return;
   end;
   
end;

import_gui.ce(1).bez.h = uicontrol(import_gui.h, 'style', 'text');
set(import_gui.ce(1).bez.h, 'HorizontalAlignment', 'right', 'Position', [20, 447, 100 20], 'BackgroundColor', bg_color);
if (modus == 1)
   import_gui.ce(1).h = uicontrol(import_gui.h, 'style', 'text', 'Position', [150 447 300 20], 'BackgroundColor', bg_color);
   set(import_gui.ce(1).bez.h, 'String', 'Source file');
   set(import_gui.ce(1).h, 'String', parameter.gui.import.quelle, 'HorizontalAlignment', 'left');
else
   import_gui.ce(1).h = uicontrol(import_gui.h, 'style', 'edit', 'string',parameter.gui.import.quelle, ...
      'Position', [150 450 300 20], 'HorizontalAlignment', 'left');
   set(import_gui.ce(1).bez.h, 'String', 'Source directory');
   import_gui.ce(2).h = uicontrol(import_gui.h, 'Style', 'checkbox', 'String', 'Searching in subdirectories', ...
      'Position', [150 420 300 20], 'BackgroundColor', bg_color, 'value', parameter.gui.import.ordner_rekursiv, ...
      'TooltipString', 'Looking for files with the defined extension in are sub-directories for import, if checkbox is active.');
   import_gui.ce(13).h = uicontrol(import_gui.h, 'style', 'edit', 'Position', [150 390 50 20], 'String', parameter.gui.import.dateiendung, ...
      'TooltipString', 'Defines the file extension for the import files.');
   import_gui.ce(13).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'File extension', 'Position', [20 387 100 20], 'BackgroundColor', bg_color);
   import_gui.ce(16).h = uicontrol(import_gui.h, 'Style', 'checkbox', 'String', 'Write in separate projects', ...
      'Position', [300 420 300 20], 'BackgroundColor', bg_color, 'value', parameter.gui.import.separate_projects,...
      'TooltipString', 'generation of separate project files for all input files or not.');
   
end;

%reset import variable
parameter.gui.import.quelle = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frame Klassentrennzeichen
import_gui.frame(1).h = uicontrol(import_gui.h, 'Style', 'frame', 'Position', [10 285 230 80], 'BackgroundColor', bg_color);
import_gui.frame(1).bez.h = uicontrol(import_gui.h, 'HorizontalAlignment', 'left', 'style', 'text', 'Position', [15 357 165 15], ...
   'String', 'Separator for output variables', 'BackgroundColor', bg_color);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trennzeichen Ordnernamen
tooltip = sprintf('Defines the separator symbol in the directory name for output variables.\nExample: A directory is called name_left_1 and the separator is  ');
tooltip = [tooltip sprintf('Underscore is chosen.\nWe extract the names name, left and 1.')];
import_gui.ce(3).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'for directories', 'TooltipString', tooltip);
set(import_gui.ce(3).bez.h, 'HorizontalAlignment', 'right', 'Position', [20 327 100 20], 'BackgroundColor', bg_color);
import_gui.ce(3).h = uicontrol(import_gui.h, 'style', 'popupmenu', 'String', 'None|Blank|Underscore|Hyphen|Semicolon|Comma', ...
   'Position', [150 330 85 20], 'TooltipString', tooltip,'value',parameter.gui.import.klassentrennzeichen.datei);
if (modus == 1)
   set(import_gui.ce(3).bez.h, 'enable', 'off');
   set(import_gui.ce(3).h, 'enable', 'off');
   set(import_gui.ce(2).h, 'enable', 'off');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trennzeichen Dateinamen
tooltip = sprintf('Defines the separator symbol in the file name for output variables.\nExample: A directory is called left_1.txt and the separator is ');
tooltip = [tooltip sprintf('Underscore is chosen.\nWe extract the names left and 1.')];
import_gui.ce(4).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'for file names', 'TooltipString', tooltip);
set(import_gui.ce(4).bez.h, 'HorizontalAlignment', 'right', 'Position', [20 297 100 20], 'BackgroundColor', bg_color);
import_gui.ce(4).h = uicontrol(import_gui.h, 'style', 'popupmenu', 'String', 'None|Blank|Underscore|Hyphen|Semicolon|Comma', ...
   'Position', [150 300 85 20], 'TooltipString', tooltip,'value',parameter.gui.import.klassentrennzeichen.ordner);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frame Dateitrennzeichen
import_gui.frame(2).h = uicontrol(import_gui.h, 'Style', 'frame', 'Position', [260 285 230 80], 'BackgroundColor', bg_color);
import_gui.frame(2).bez.h = uicontrol(import_gui.h, 'HorizontalAlignment', 'left', 'style', 'text', 'Position', [265 357 125 15], ...
   'String', 'Separator in the file', 'BackgroundColor', bg_color);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trennzeichen Dezimalzeichen
tooltip = 'Defines the separator for the decimal point.';
import_gui.ce(5).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'Decimal numbers', 'TooltipString', tooltip);
set(import_gui.ce(5).bez.h, 'HorizontalAlignment', 'right', 'Position', [270 327 100 20], 'BackgroundColor', bg_color);
import_gui.ce(5).h = uicontrol(import_gui.h, 'style', 'popupmenu', 'String', 'Point|Comma', ...
   'Position', [400 330 85 20], 'TooltipString', tooltip,'value',parameter.gui.import.dezimaltrennzeichen);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trennzeichen Spalten
tooltip = 'Defines the separator symbol for columns (and therefore for single features or time series).';
import_gui.ce(6).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'for columns', 'TooltipString', tooltip);
set(import_gui.ce(6).bez.h, 'HorizontalAlignment', 'right', 'Position', [270 297 100 20], 'BackgroundColor', bg_color);
import_gui.ce(6).h = uicontrol(import_gui.h, 'style', 'popupmenu', 'String', 'Blank|Underscore|Hyphen|Tabulator|Semicolon|Comma', ...
   'Position', [400 300 85 20], 'TooltipString', tooltip,'value',parameter.gui.import.spaltentrennzeichen);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frame Importoptionen
import_gui.frame(3).h = uicontrol(import_gui.h, 'Style', 'frame', 'Position', [10 85 480 180], 'BackgroundColor', bg_color);
import_gui.frame(3).bez.h = uicontrol(import_gui.h, 'HorizontalAlignment', 'left', 'style', 'text', 'Position', [15 257 55 15], ...
   'String', 'Import', 'BackgroundColor', bg_color);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Zeile Bezeichner
import_gui.ce(7).h = uicontrol(import_gui.h, 'style', 'checkbox', 'String', 'First row contains names', 'value',parameter.gui.import.firstline_bez,...
   'Position', [20 230 300 20], 'BackgroundColor', bg_color, ...
   'TooltipString', 'has to be activated if the first row contains variable names instead of data.');
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ignoriere Zeilen, die mit ... beginnen
tooltip = sprintf('Rows starting with this symbol will be ignored (Example: %%)');
import_gui.ce(8).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'Ignore rows starting with ', 'TooltipString', tooltip);
set(import_gui.ce(8).bez.h, 'HorizontalAlignment', 'right', 'Position', [20 197 150 20], 'BackgroundColor', bg_color);
import_gui.ce(8).h = uicontrol(import_gui.h, 'style', 'edit', 'Position', [180 200 50 20], 'TooltipString', tooltip, ...
   'string',parameter.gui.import.ignoriere_zeilen_mit);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Einlesen erst ab Zeile
tooltip = sprintf('The file will be read starting with this row.\n');
tooltip = [tooltip sprintf('Consequently, the header part at the beginning of a file will be ignored.')];
import_gui.ce(9).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'Read from row', 'TooltipString', tooltip);
set(import_gui.ce(9).bez.h, 'HorizontalAlignment', 'left', 'Position', [250 197 90 20], 'BackgroundColor', bg_color);
import_gui.ce(9).h = uicontrol(import_gui.h, 'style', 'edit', 'Position', [340 200 50 20], ...
   'String', parameter.gui.import.ignore_firstlines, 'TooltipString', tooltip);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Importieren als
tooltip = 'Import of single features or time series?';
import_gui.ce(10).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'Import as ', 'TooltipString', tooltip);
set(import_gui.ce(10).bez.h, 'HorizontalAlignment', 'right', 'Position', [20 167 150 20], 'BackgroundColor', bg_color);
import_gui.ce(10).h = uicontrol(import_gui.h, 'style', 'popupmenu', 'Position', [180 170 150 20], 'String', 'Time series (TS)|Single features', ...
   'TooltipString', tooltip,'value',parameter.gui.import.inhalt);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resampling
tooltip = sprintf('All time series must be the same length for Gait-CAD projects.\n');
tooltip = [tooltip sprintf('Time series with different lengths will be converted,\nto identical lengths.\n')];
tooltip = [tooltip sprintf('The used method can be chosen in this field')];
import_gui.ce(14).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'Normalize time series lengths', 'TooltipString', tooltip);
set(import_gui.ce(14).bez.h, 'HorizontalAlignment', 'left', 'Position', [20 137 170 20], 'BackgroundColor', bg_color);
import_gui.ce(14).h = uicontrol(import_gui.h, 'style', 'popupmenu', 'Position', [180 140 150 20], 'String', ...
   'Resampling|Fill with zeros|Extrapolate with last value|Fill with NaN', 'TooltipString', tooltip,'value',parameter.gui.import.gleiche_laenge);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Importieren mit
import_gui.ce(15).bez.h = uicontrol(import_gui.h, 'style', 'text', 'String', 'Import with ');
set(import_gui.ce(15).bez.h, 'HorizontalAlignment', 'right', 'Position', [20 107 150 20], 'BackgroundColor', bg_color);
import_gui.ce(15).h = uicontrol(import_gui.h, 'style', 'popupmenu', 'Position', [180 110 150 20], 'String', ...
   'Read row by row|Write copy and read again|Normal mode|Standard-ASCII|Structured (with strings)|Importdata (MATLAB)','value',parameter.gui.import.importfct);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import_gui.ce(11).h = uicontrol(import_gui.h, 'style', 'pushbutton', 'String', 'OK', 'callback', 'button = 1; callback_import_load;', ...
   'Position', [130 25 100 20]);
import_gui.ce(12).h = uicontrol(import_gui.h, 'style', 'pushbutton', 'String', 'Cancel', ...
   'callback', 'button = 0; callback_import_load;', ...
   'Position', [280 25 100 20]);

clear button;

drawnow;
