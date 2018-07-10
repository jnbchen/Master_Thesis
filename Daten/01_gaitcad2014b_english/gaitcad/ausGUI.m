% Script ausGUI
%
% Liest die Elemente der GUI ein und schreibt in das Parameterstrukt
%
% The script ausGUI is part of the MATLAB toolbox Gait-CAD. 
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

if (~exist('ausGUIIndx', 'var') || isempty(ausGUIIndx))
   ausGUIIndx_I = [1:length(parameter.gui.control_elements)];
else
   if (~iscell(ausGUIIndx))
      ausGUIIndx = {ausGUIIndx};
   end;
   tags = {parameter.gui.control_elements.tag};
   ausGUIIndx_I = [];
   for i = 1:length(ausGUIIndx)
      tmp = find(strcmp(ausGUIIndx{i}, tags));
      if ~isempty(tmp)
         ausGUIIndx_I = [ausGUIIndx_I tmp];
      end;
   end;
end;

for el_count_aus = 1:length(ausGUIIndx_I)
   el = ausGUIIndx_I(el_count_aus);
   % Einige Elemente haben keine Auslese-Variable...
   if (~isempty(parameter.gui.control_elements(el).variable))
      switch(parameter.gui.control_elements(el).style)
      case 'edit'
         tmp = get(parameter.gui.control_elements(el).handle, 'String');
         if ~isempty(tmp)
            tmpNum = str2num(tmp);
            %in some cases problems with protected conversions. Here, a
            %reset of the last errormessage is useful to avoid strange
            %warning and error messages
            set(0,'errormessage','');
            if any(isnan(tmpNum))
               tmpNum = [];
            end;
            if (parameter.gui.control_elements(el).ganzzahlig)
               tmpNum = round(tmpNum);
               set(parameter.gui.control_elements(el).handle, 'String', num2str(tmpNum));
            end;
         else
            tmpNum = [];
         end;
         % Gibt leer zurück, wenn die Konvertierung nicht funktioniert hat.
         if (~isempty(tmpNum))
            eval(sprintf('%s = tmpNum;', parameter.gui.control_elements(el).variable));
         else
            eval(sprintf('%s = tmp;', parameter.gui.control_elements(el).variable));
         end;
         % In Radiobuttons 
      case 'radiobutton'
         if (get(parameter.gui.control_elements(el).handle, 'value') == 1)
            eval(sprintf('%s = ''%s'';', parameter.gui.control_elements(el).variable, parameter.gui.control_elements(el).radioval));
         end;
      case {'listbox', 'popupmenu'}
         if ~isempty(parameter.gui.control_elements(el).save_as_string) && (parameter.gui.control_elements(el).save_as_string == 1)
            strs = get(parameter.gui.control_elements(el).handle, 'String');
            tmp = get(parameter.gui.control_elements(el).handle, 'value');
            eval(sprintf('%s = ''%s'';', parameter.gui.control_elements(el).variable, deblank(strs(tmp,:))));
         else
            eval(sprintf('%s = get(parameter.gui.control_elements(el).handle, ''value'');', parameter.gui.control_elements(el).variable));
         end;
      case 'text'
         eval(sprintf('%s = get(parameter.gui.control_elements(el).handle, ''string'');', parameter.gui.control_elements(el).variable));
      otherwise
         eval(sprintf('%s = get(parameter.gui.control_elements(el).handle, ''value'');', parameter.gui.control_elements(el).variable));
      end; % switch(get(elements(el).handle, 'style'))
   end; % if (~isempty(parameter.gui.control_elements(el).variable))
end; % for(el = 1:length(elements))

clear ausGUIIndx_I ausGUIIndx tags el_count_aus el tmpNum tmp strs;
