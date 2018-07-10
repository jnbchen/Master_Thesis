% Script callback_anzeige_plugins
%
% plugins must exist
%
% The script callback_anzeige_plugins is part of the MATLAB toolbox Gait-CAD. 
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

if ~isfield(plugins,'mgenerierung_plugins') || ~isfield(plugins.mgenerierung_plugins,'funktionsnamen')
   
   if mode_selection == 2
      %might be unloaded plugins, try again
      parameter.allgemein.no_update_reading = 0;
      callback_update_plugins;
   end;
   
   if ~isfield(plugins,'mgenerierung_plugins') || ~isfield(plugins.mgenerierung_plugins,'funktionsnamen')
      return;
   end;
end;


%automatic selection
if mode_selection == 0
   mode_selection = parameter.gui.merkmalsgenerierung.anzeige_plugins;
end;


%look for old state
if ~isfield(plugins,'old_selection')
   plugins.old_selection =1;
end;

switch mode_selection
   case 1
      %all plugins
      plugins.mgenerierung_plugins.typ_beschreibung.show_now = 1:length(plugins.mgenerierung_plugins.typ_beschreibung.plugin);
   case 2
      %only time series
      plugins.mgenerierung_plugins.typ_beschreibung.show_now = find(plugins.mgenerierung_plugins.typ_beschreibung.source(:,1)>0)';
   case 3
      %only images
      plugins.mgenerierung_plugins.typ_beschreibung.show_now = find(plugins.mgenerierung_plugins.typ_beschreibung.source(:,3)>0)';
   case 4
      %only XPIWIT
      plugins.mgenerierung_plugins.typ_beschreibung.show_now = find(ismember({plugins.mgenerierung_plugins.info.typ},'XPIWIT'))';
      plugins.mgenerierung_plugins.typ_beschreibung.show_now = find(ismember(plugins.mgenerierung_plugins.typ_beschreibung.plugin,plugins.mgenerierung_plugins.typ_beschreibung.show_now));
end;

%only activate the selection field if any image or image releated plugin exist
if isempty(find(plugins.mgenerierung_plugins.typ_beschreibung.source(:,3)>0)) || isempty(d_image.data)
   parameter.gui.merkmalsgenerierung.anzeige_plugins = 1;
   %all plugins
   plugins.mgenerierung_plugins.typ_beschreibung.show_now = find(plugins.mgenerierung_plugins.typ_beschreibung.source(:,1)>0)';
   set(findobj('tag','CE_Plugins_Anzeige'),'enable','off','value',parameter.gui.merkmalsgenerierung.anzeige_plugins);
else
   set(findobj('tag','CE_Plugins_Anzeige'),'enable','on');
end;

if par.anz_image == 0
   %exclude plugins requiring images
   plugins.mgenerierung_plugins.typ_beschreibung.show_now = setdiff(plugins.mgenerierung_plugins.typ_beschreibung.show_now,find(plugins.mgenerierung_plugins.typ_beschreibung.source(:,3)>0));
end;

if par.anz_merk == 0
   %exclude plugins requiring time series
   plugins.mgenerierung_plugins.typ_beschreibung.show_now = setdiff(plugins.mgenerierung_plugins.typ_beschreibung.show_now,find(plugins.mgenerierung_plugins.typ_beschreibung.source(:,1)>0));
end;


% get handles

switch mode_anz
   case 1
      %handles from GUI
      hndl_pop  = findobj('tag','CE_Auswahl_Plugins');
      hndl_edit = findobj('tag','CE_Edit_Auswahl_Plugins');
      if isempty(plugins.mgenerierung_plugins.typ_beschreibung.show_now)
         set(hndl_pop ,'string','');
         set(hndl_edit,'enable','off');
      else
         set(hndl_pop ,'enable','on');
         set(hndl_edit,'enable','on');
      end;
      
   case 2
      %handles from an _af menu handle for manual plugin selection
      hndl_pop = figure_handle(4,1);
      hndl_edit =[];
end;





%start updating GUI element for plugin batch
set(hndl_pop,'string',plugins.mgenerierung_plugins.full_string(plugins.mgenerierung_plugins.typ_beschreibung.show_now,:));

%in case of a change: select the first element
if mode_selection ~= plugins.old_selection
   set(hndl_pop,'value',1);
   if ~isempty(hndl_edit) && ~isempty(plugins.mgenerierung_plugins.typ_beschreibung.show_now)
      set(hndl_edit,'string',num2str(plugins.mgenerierung_plugins.typ_beschreibung.show_now(1)));
   end;
   
   %save old selection
   plugins.old_selection = mode_selection;
end;

%for a GUI update: synchronize the related GUI field for popup and edit
if mode_anz == 1
   mode_multi_plugin = 1;
   callback_auswahl_multi_plugins;
end;
