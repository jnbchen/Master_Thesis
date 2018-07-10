% Script inGUI
%
% Liest die Elemente des Strukts ein und schreibt in die GUI
%
% The script inGUI is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('inGUIIndx', 'var') || isempty(inGUIIndx))
   inGUIIndx_I = 1:length(parameter.gui.control_elements);
   % Sollen alle Elemente in die GUI eingetragen werden, darf kein Callback
   % gerufen werden. Hier wirkt sich aus, dass die Datei als Skript arbeitet und
   % nicht als Funktion. Wird im Callback inGUI aufgerufen (auch indirekt!), wird
   % inGUIIndx überschrieben und neu gesetzt. Dadurch funktioniert die Schleife weiter unten
   % nicht mehr. Auch ein Umbenennen und zwischenspeichern der Variablen nützt nichts,
   % da diese ebenfalls überschrieben werden würde. Einziger sichtbarer Ausweg:
   % inGUIIndx nicht überschreiben, sondern als eine Art Stack behandeln.
   inGUICallback = 0;
else
   if (~iscell(inGUIIndx))
      inGUIIndx = {inGUIIndx};
   end;
   tags = {parameter.gui.control_elements.tag};
   inGUIIndx_I = [];
   for i = 1:length(inGUIIndx)
      tmp = find(strcmp(inGUIIndx{i}, tags));
      if ~isempty(tmp)
         inGUIIndx_I = [inGUIIndx_I tmp];
      end;
   end;
end;

% Folgende Variable steuert, ob der Callback der Elemente einmal aufgerufen
% werden soll. Wird per Default getan, es sei denn, im Callback wird inGUI aufgerufen.
% Um da Probleme mit einer Schleife zu vermeiden, wird der Callback nicht ausgeführt.
if ~exist('inGUICallback', 'var') || isempty(inGUICallback)
   inGUICallback = 1;
end;

tags = {parameter.gui.control_elements.tag};
for el_count_in = 1:length(inGUIIndx_I)
   el = inGUIIndx_I(el_count_in);
   if (~isempty(parameter.gui.control_elements(el).variable))
      eval(sprintf('tmp = %s;', parameter.gui.control_elements(el).variable));
      switch(parameter.gui.control_elements(el).style)
      case 'edit'
         if ~ischar(tmp)
            % tmp muss ein Zeilenvektor sein, sonst gibt es ein Problem beim Eintragen
            if (size(tmp,1) > 1 && size(tmp,2) == 1)
               tmp = tmp';
            end;
            if parameter.gui.control_elements(el).ganzzahlig
               tmp = round(tmp);
            end;
            set(parameter.gui.control_elements(el).handle, 'String', kill_lz(num2str(tmp)));
         else
            set(parameter.gui.control_elements(el).handle, 'String', tmp);
         end;
      case {'listbox', 'popupmenu'}
         % Bei einer Listbox kann in der Variable eine Zeichenkette gespeichert sein.
         % Für diese muss dann erst einmal der korrekte Wert gesucht werden
         if ~isempty(parameter.gui.control_elements(el).save_as_string) && parameter.gui.control_elements(el).save_as_string && ischar(tmp)
            strs = deblank(string2cell(get(parameter.gui.control_elements(el).handle, 'String')));
            indx = find(strcmp(tmp, strs));
                    
            
            % Nur einen Wert eintragen, wenn der kleiner als die Anzahl an vorhandenen Werten ist.
            if ~isempty(indx) && indx <= length(strs)
               set(parameter.gui.control_elements(el).handle, 'value', indx);
            else
               %ÄNDERUNG RALF: leer setzen ist sinnlos, da gibt es u.U. Probleme mit umbenannten Auswahlfeldern
               %besser lassen wie es ist und Variable neu auslesen
               %fprintf('The element %s could not be reconstructed.\n',parameter.gui.control_elements(el).name);
               el_save = el;
               ausGUIIndx=parameter.gui.control_elements(el).tag;
               ausGUI;
               el = el_save;
            end;
         else
            % Die Werte rausschmeißen, die zu groß sind
            tmp(tmp > size(get(parameter.gui.control_elements(el).handle, 'String'), 1)) = [];
            % Anschließend setzen:
            if isempty(tmp)
               %ÄNDERUNG RALF: leer setzen ist sinnlos, da gibt es u.U. Probleme mit umbenannten Auswahlfeldern
               %besser lassen wie es ist und Variable neu auslesen
               %fprintf('The element %s could not be reconstructed.\n',parameter.gui.control_elements(el).name);
               el_save = el;
               ausGUIIndx=parameter.gui.control_elements(el).tag;
               ausGUI;
               el = el_save;
            else
               set(parameter.gui.control_elements(el).handle, 'value', tmp);
               % Einige Projekte haben vielleicht zahlwerte gespeichert, auch wenn eigentlich
               % Zeichenketten erwünscht sind. Dann ändere den Wert hier einfach auf die Zeichenkette:
               if (~isempty(parameter.gui.control_elements(el).save_as_string) && parameter.gui.control_elements(el).save_as_string == 1 && ~ischar(tmp))
                  strs = get(parameter.gui.control_elements(el).handle, 'String');
                  eval(sprintf('%s = ''%s'';', parameter.gui.control_elements(el).variable, deblank(strs(tmp,:))));
               end;
            end;
         end;
         % Gibt es eine Auswahlmöglichkeit und wurde nichts ausgewählt?
         if (~isempty(get(parameter.gui.control_elements(el).handle, 'String')) && isempty(get(parameter.gui.control_elements(el).handle, 'value')))
            % Ist das erlaubt?
            if isfield(parameter.gui.control_elements(el), 'immer_auswahl') && ~isempty(parameter.gui.control_elements(el).immer_auswahl) && parameter.gui.control_elements(el).immer_auswahl == 1
               set(parameter.gui.control_elements(el).handle, 'value', 1);
               % Trage den Wert dann auch in die richtige Variable ein.
               ausGUIIndx = parameter.gui.control_elements(el).tag; ausGUI;
            end;
         end;
      case 'radiobutton'
         tags = {parameter.gui.control_elements.tag};
         % Die Radiobuttons haben eine gemeinsame Variable. In der steht aber eine Zeichenkette
         % oder etwas anderes, was nichts mit dem value zu tun hat. Also rausfinden, um welches
         % Element es sich handelt und da den Wert setzen.
         radiogroup = parameter.gui.control_elements(el).radiogroup;
         for i = 1:length(radiogroup)
            elIndx = find(strcmp(radiogroup{i}, tags));
            if (~isempty(elIndx))
               if (strcmp(parameter.gui.control_elements(elIndx).radioval, tmp))
                  set(parameter.gui.control_elements(elIndx).handle, 'value', 1);
               else
                  set(parameter.gui.control_elements(elIndx).handle, 'value', 0);
               end;
            end;
         end;
      case 'text'
         set(parameter.gui.control_elements(el).handle, 'String', tmp);
      otherwise
         set(parameter.gui.control_elements(el).handle, 'value', tmp);
      end; % switch(get(elements(el).handle, 'style'))
      
      % Nur den Callback ausführen, wenn auch eine Variable vorhanden ist, die geschrieben werden kann.
      if inGUICallback
         % Einmal prüfen, ob im Callback inGUI enthalten ist. Um eine Endlosschleife zu vermeiden, wird
         % der Callback dann nicht ausgeführt!
         str = get(parameter.gui.control_elements(el).handle, 'Callback');
         
         
         if isempty(strfind(str, 'inGUI')) && ~strcmp(parameter.gui.control_elements(el).tag,'CE_Projektuebersicht') && isempty(strfind(str, 'bereichs_check'))
            eval(str);
            
         end;
      end;
   end; % if (~isempty(parameter.gui.control_elements(el).variable))
end; % for(el = 1:length(elements))
clear inGUIIndx inGUIIndx_I tags inGUICallback el_count_in el tmp radiogroup str;