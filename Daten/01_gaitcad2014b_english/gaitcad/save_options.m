  function options = save_options(elements, filename,plugins)
% function options = save_options(elements, filename,plugins)
%
% The function save_options is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:01
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

if nargin<2 
   filename=[];
end;

extension='.uihdg';

% Hier werden nun alle Variablen der GUI-Elemente durchgegangen.
% Deren Variablen sind in elements(:).variable
% gespeichert. Die Variablen werden zunächst in ein Strukt
% Zwischengespeichert.
% Das Setzen der entsprechenden Werte kann dann beim Laden durch inGUI
% übernommen werden. Diese Funktion kann auch mit speziellen Elementen
% wie radiobuttons usw. umgehen.
options = [];
count = 1;
for el = 1:length(elements)
   if (~isempty(elements(el).variable) && (isfield(elements(el), 'nicht_speichern') && (isempty(elements(el).nicht_speichern) || elements(el).nicht_speichern ~= 1)))
      % Der folgende Befehl liest den aktuell gespeicherten Wert:
      % Hier wird try verwendet, falls es die Variable im Workspace nicht gibt.
      % Das kann bei alten Projekten durchaus der Fall sein. Sollte auf diese
      % Weise aber kein Problem darstellen. Beim Laden werden anschließend nur
      % die vorhandenen Werte überschrieben.
      try
         tmp = evalin('base', elements(el).variable);
         options.var_name{count} = elements(el).variable;
         options.var_val{count} = tmp;
         count = count + 1;
      catch
      end;
   end; % if (~isempty(elements(el).variable))
end; % for(el_count = 1:length(elements))
% Einige Elemente, die keine Variable enthalten, sind hier leer.
% Das ist aber nicht weitere dramatisch, da sie kaum Speicher belegen.

% Über filename == -1 kann das Speichern ausgeschaltet werden. Dann wird nur das Options-Strukt
% zurückgegeben.
%Dateiname schon gegeben? 
datei = [];
if (~isempty(filename) && all(filename ~= -1))
   [pfad,datei,extension] = fileparts(filename);
   if isempty(pfad)
      pfad = pwd;
   end;
   datei = [datei extension];
   % Wenn keine optionen und auch kein Dateiname angegen wurde,
   % frage nach einer Datei
elseif (isempty(filename))
   [datei,pfad]=uiputfile(['options' extension],'Save options');
   if (datei == 0)
      return;
   end;
   [muell,datei,extension] = fileparts(datei);
   datei = [datei extension];
end;


save_plugin_commandlines;



if (datei)
   if (pfad(end) ~= '\')
      pfad(end+1) = '\';
   end;
   save_version = evalin('base','char(parameter.gui.allgemein.liste_save_mode_matlab_version(parameter.gui.allgemein.save_mode_matlab_version))');
   save([pfad datei], 'options', 'plugin_save','-mat',save_version);
end;
