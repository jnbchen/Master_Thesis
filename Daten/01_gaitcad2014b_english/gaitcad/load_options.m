  function plugins = load_options(elements, options, filename,plugins)
% function plugins = load_options(elements, options, filename,plugins)
%
% 
%   Der folgende Befehl lädt gespeicherte Optionen, entweder aus
%   einer Datei, oder aus einem gegebenem Optionenstrukt.
%   Für den ersten Fall muss options == [] und filename gesetzt sein.
%   Für den zweiten Fall muss options gesetzt und filename == [] sein.
%   Ist sowohl options als auch filename leer, wird nach einer Datei gefragt
%   In extension steht die Endung der Datei (default: uihdg)
%   Parameter enthält das Oberflächenstrukt aus Gaitcad.
%
% The function load_options is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 2)
    options = [];
end;
if (nargin < 3)
    filename = [];
end;
extension = '.uihdg';

datei = [];
% Wenn eine Datei übergeben wurde, lese Dateiname und Pfad aus.
if (~isempty(filename))
    %wichtig um Makros laden zu können: filename kann durch ein anderes Skript übergeben werden!!!
    if ~exist(filename,'file')
        filename=which(filename);
        if isempty(filename)
            myerror(sprintf('File %s not found!',filename));
        end;
    end;
    [pfad,datei,extension] = fileparts(filename);
    if isempty(pfad)
        filename=which(filename);
        [pfad,datei,extension] = fileparts(filename);
        
    end;
    
    datei = [datei extension];
    % Wenn keine optionen und auch kein Dateiname angegen wurde,
    % frage nach einer Datei
elseif (isempty(options) && isempty(filename))
    [datei,pfad]=uigetfile(['*' extension],'Load options');
    if (datei == 0)
        return;
    end;
end;
% Wenn eine Datei angegeben wurde, diese nun laden:
if (~isempty(datei))
    options = [];
    if (pfad(end) ~= '\')
        pfad(end+1) = '\';
    end;
    tmpload = load([pfad datei], '-mat');
    
    % Die "alten" uihdg-Dateien haben eine andere Dateitruktur verwendet.
    % Prüfe, ob es ein Feld "options" in tmpload gibt. Das deutet auf
    % eine neue Optionendatei hin
    if (~isfield(tmpload, 'options'))
        %error('Invalid version of an option file (uihdg)');
        fprintf(1, 'Warning! An option file was loaded with an obsolete format. Converting into new format...\n');
        options = konvertiere_uihdg(elements, tmpload);
    else
        options = tmpload.options;
    end;
end;
% Jetzt sollte eigentlich spätestens eine options-Variable existieren
if (~isempty(options))
    % Gehe die einzelnen Variablen durch und prüfe zunächst, ob es ein
    % Oberflächenelement mit dieser Variable gibt. Wenn nicht,
    % dann gib einen Text aus, um es kenntlich zu machen.
    alleNamen = char({elements.variable});
    
    %Ausschlussliste
    alleNamen = setdiff(alleNamen,{'parameter.gui.merkmalsgenerierung.plug_commandline','parameter.gui.merkmalsgenerierung.plug_par_number'});
    
    
    for i = 1:length(options.var_name)
        var_name = options.var_name{i};
        var_val  = options.var_val{i};
        if ~isempty(var_name)
            % Prüfen, ob es ein Element mit dieser Variablen gibt
            if ~isempty(find(strcmp(var_name, alleNamen)))               
                % Es existiert ein Element, also Variable mit dem gespeicherten Wert aktualisieren
                try
                    if ischar(var_val)
                        evalin('base', sprintf('%s = ''%s'';', var_name, var_val));
                    else
                        % Der Befehl mat2str ist wichtig! Dadurch wird gewährleistet, dass auch Vektorwerte vernünftig
                        % in die Variable geschrieben werden.
                        evalin('base', sprintf('%s = %s;', var_name, mat2str(var_val)));
                    end;
                catch 
                    mywarning(sprintf('Error by reconstructing options (Element: %s)\n',var_name));
                end;
            end; 
        end;
    end;
end;


%Update plugin command lines
if exist('tmpload','var') && isfield(tmpload,'plugin_save') && isfield(tmpload.plugin_save,'mgenerierung_plugins')
    plugin_save = tmpload.plugin_save;
    restore_plugin_commandlines;
end;


