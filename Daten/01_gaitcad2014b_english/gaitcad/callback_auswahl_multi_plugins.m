% Script callback_auswahl_multi_plugins
%
% plugins must exist
%
% The script callback_auswahl_multi_plugins is part of the MATLAB toolbox Gait-CAD. 
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
   return;
end;

%get handles for edit and popup field from GUI
hndl_pop         = gaitfindobj('CE_Auswahl_Plugins');
hndl_edit        = gaitfindobj('CE_Edit_Auswahl_Plugins');
hndl_sequence    = gaitfindobj('CE_Auswahl_PluginsList');
hndl_commandline = gaitfindobj('CE_Auswahl_PluginsCommandLine');
hndl_exec        = gaitfindobj('CE_PlugListExec');



plugins.mgenerierung_plugins.sequence.pos = get(hndl_sequence,'value');

%initialization if necessary
if ~isfield(plugins.mgenerierung_plugins,'sequence') || isempty(plugins.mgenerierung_plugins.sequence) ...
      || ~isfield(plugins.mgenerierung_plugins.sequence,'plugins')
   plugins.mgenerierung_plugins.sequence.plugins =[];
   plugins.mgenerierung_plugins.sequence.pos = 0;
   plugins.mgenerierung_plugins.sequence.command_line = {};
end;



if isempty(plugins.mgenerierung_plugins.typ_beschreibung.show_now)
   return;
end;



%entry from edit field
ind_listbox=round(str2num(get(hndl_edit,'string')));

switch mode_multi_plugin
   case 1
      %selection in the GUI
      if ~isempty(plugins.mgenerierung_plugins.typ_beschreibung.show_now)
         try
            tmp=plugins.mgenerierung_plugins.typ_beschreibung.show_now(get(hndl_pop,'value'));
         catch
            %sometimes problems for loading ...
            tmp = [];
         end;
         
      else
         tmp =[];
      end;
      
      
      %add a new entry
      add_sel = setdiff(tmp,ind_listbox);
      if ~isempty(add_sel)
         ind_listbox = [ind_listbox add_sel];
      end;
      
      %delete an existing entry from a list
      [tmp,del_sel] = setdiff(ind_listbox,tmp);
      if ~isempty(del_sel)
         ind_listbox(del_sel) = [];
      end;
      
      %try to guarantee at least one entry
      if isempty(ind_listbox)
         if isempty(plugins.mgenerierung_plugins.typ_beschreibung.show_now)
            ind_listbox = [];
         else
            ind_listbox=plugins.mgenerierung_plugins.typ_beschreibung.show_now(1);
         end;
      end;
      
      %update for command lines of plugin list
      plugins.sequence_field = 0;
      if ~isempty(ind_listbox)
         plugins.ind_listbox = plugins.mgenerierung_plugins.typ_beschreibung.plugin(ind_listbox);
      else
         plugins.ind_listbox = [];
      end;
      
      
   case 2
      %selection in the edit field
      [tmp,ind_del] = setdiff(ind_listbox,plugins.mgenerierung_plugins.typ_beschreibung.show_now);
      ind_listbox(ind_del) = [];
      if isempty(ind_listbox)
         ind_listbox = plugins.mgenerierung_plugins.typ_beschreibung.show_now(1);
      end;
      
      %update for command lines of plugin list
      plugins.sequence_field = 0;
      plugins.ind_listbox = plugins.mgenerierung_plugins.typ_beschreibung.plugin(ind_listbox);
      
   case 3
      
      %use only non-empty plugins
      ind_listbox = ind_listbox(find(plugins.mgenerierung_plugins.typ_beschreibung.plugin(ind_listbox)));
      if isempty(ind_listbox)
         return;
      end;
      
      %find adding position
      plugins.mgenerierung_plugins.sequence.pos = plugins.mgenerierung_plugins.sequence.pos(1);
      
      if ~isempty(plugins.mgenerierung_plugins.sequence.plugins)
         %new ranking
         ind_new = [1:plugins.mgenerierung_plugins.sequence.pos (plugins.mgenerierung_plugins.sequence.pos+1:length(plugins.mgenerierung_plugins.sequence.plugins))+length(ind_listbox)];
         plugins.mgenerierung_plugins.sequence.plugins(ind_new) = plugins.mgenerierung_plugins.sequence.plugins;
         plugins.mgenerierung_plugins.sequence.command_line(ind_new) = plugins.mgenerierung_plugins.sequence.command_line;
      else
         plugins.mgenerierung_plugins.sequence.pos = 0;
      end;
      %add in the middle
      plugins.mgenerierung_plugins.sequence.plugins(plugins.mgenerierung_plugins.sequence.pos+[1:length(ind_listbox)]) = ind_listbox;
      %not a nice style, some problems with cell assignments
      for i_listbox = [1:length(ind_listbox)]
         plugins.mgenerierung_plugins.sequence.command_line {plugins.mgenerierung_plugins.sequence.pos+i_listbox} = plugins.mgenerierung_plugins.info(plugins.mgenerierung_plugins.typ_beschreibung.plugin(ind_listbox(i_listbox))).commandline;
         if strcmp(plugins.mgenerierung_plugins.info(plugins.mgenerierung_plugins.typ_beschreibung.plugin(ind_listbox(i_listbox))).typ,'XPIWIT')
            
            %automatic ID setting
            %get list of all existing ids
            myidlist={};
            for i_cl = 1:length(plugins.mgenerierung_plugins.sequence.command_line)
               myidlist{i_cl} = plugins.mgenerierung_plugins.sequence.command_line{i_cl}.parameter_commandline{1};
            end;
            
            %first numbers of short name ('beschreibung') and two numbers (but
            %a new combination not yet in the list)
            dummyid_letters = plugins.mgenerierung_plugins.info(plugins.mgenerierung_plugins.typ_beschreibung.plugin(ind_listbox(i_listbox))).bezeichner(1:2);
            
            for i_id=1:99
               dummyid = sprintf('%s%02d',dummyid_letters,i_id);
               if isempty(find(ismember(myidlist,dummyid)))
                  break;
               end;
               if i_id == 99
                  myerror('Error in filter ID definition');
               end;
            end;
            plugins.mgenerierung_plugins.sequence.command_line {plugins.mgenerierung_plugins.sequence.pos+i_listbox}.parameter_commandline{1} = dummyid;
         end;
      end;
      
      %update position
      plugins.mgenerierung_plugins.sequence.pos = plugins.mgenerierung_plugins.sequence.pos + length(ind_listbox);
      
      plugins.sequence_field = 1;
   case 4
      %delete
      if ~isempty(plugins.mgenerierung_plugins.sequence.plugins)
         plugins.mgenerierung_plugins.sequence.plugins(plugins.mgenerierung_plugins.sequence.pos) = [];
         plugins.mgenerierung_plugins.sequence.command_line(plugins.mgenerierung_plugins.sequence.pos) = [];
         plugins.mgenerierung_plugins.sequence.pos = max(1,plugins.mgenerierung_plugins.sequence.pos -length(plugins.mgenerierung_plugins.sequence.pos));
      end;
      if isempty(plugins.mgenerierung_plugins.sequence.plugins)
         plugins.mgenerierung_plugins.sequence.pos = 0;
      end;
      plugins.sequence_field = 1;
      
   case 5
      %up
      %but not the first element ...
      if isempty(plugins.mgenerierung_plugins.sequence.pos) || plugins.mgenerierung_plugins.sequence.pos(1) < 2
         return;
      end;
      %... and only sequences of length one
      if length(plugins.mgenerierung_plugins.sequence.pos) >= 1
         plugins.mgenerierung_plugins.sequence.pos = plugins.mgenerierung_plugins.sequence.pos(1);
      end;
      
      %new ranking
      ind_new = [1:plugins.mgenerierung_plugins.sequence.pos-2 plugins.mgenerierung_plugins.sequence.pos plugins.mgenerierung_plugins.sequence.pos-1 plugins.mgenerierung_plugins.sequence.pos+1:length(plugins.mgenerierung_plugins.sequence.plugins)];
      %assign new ranking
      if ~isempty(plugins.mgenerierung_plugins.sequence.plugins)
         plugins.mgenerierung_plugins.sequence.plugins(ind_new) =plugins.mgenerierung_plugins.sequence.plugins;
         plugins.mgenerierung_plugins.sequence.command_line(ind_new) = plugins.mgenerierung_plugins.sequence.command_line;
         plugins.mgenerierung_plugins.sequence.pos = plugins.mgenerierung_plugins.sequence.pos-1;
      end;
      
      plugins.sequence_field = 1;
      
      
   case 6
      %down
      %but not the last element ...
      
      if isempty(plugins.mgenerierung_plugins.sequence.pos) || plugins.mgenerierung_plugins.sequence.pos(1) == length(plugins.mgenerierung_plugins.sequence.plugins)
         return;
      end;
      %... and only sequences of length one
      if length(plugins.mgenerierung_plugins.sequence.pos) >= 1
         plugins.mgenerierung_plugins.sequence.pos = plugins.mgenerierung_plugins.sequence.pos(1);
      end;
      %new ranking
      
      ind_new = [1:plugins.mgenerierung_plugins.sequence.pos-1 plugins.mgenerierung_plugins.sequence.pos+1 plugins.mgenerierung_plugins.sequence.pos plugins.mgenerierung_plugins.sequence.pos+2:length(plugins.mgenerierung_plugins.sequence.plugins)];
      %assign new ranking
      if ~isempty(plugins.mgenerierung_plugins.sequence.plugins)
         plugins.mgenerierung_plugins.sequence.plugins(ind_new) =plugins.mgenerierung_plugins.sequence.plugins;
         plugins.mgenerierung_plugins.sequence.command_line(ind_new) = plugins.mgenerierung_plugins.sequence.command_line;
         plugins.mgenerierung_plugins.sequence.pos = plugins.mgenerierung_plugins.sequence.pos+1;
      end;
      
      plugins.sequence_field = 1;
      
      
   case 7
      %delete all
      plugins.mgenerierung_plugins.sequence.plugins = [];
      plugins.mgenerierung_plugins.sequence.pos = 0;
      plugins.mgenerierung_plugins.sequence.command_line = {};
      
      plugins.sequence_field = 1;
      
      
   case 8
      %load plugin list
      if ~exist('datei_load_plugin','var')
         datei_load_plugin = '';
      end;
      plugins.mgenerierung_plugins.sequence=load_gaitcad_struct(parameter,plugins.mgenerierung_plugins.typ_beschreibung.funktionsnamen,par,...
         'Load plugin sequence','plugin_sequence',datei_load_plugin);
      datei_load_plugin = '';
      
      if isempty(plugins.mgenerierung_plugins.sequence)
         plugins.mgenerierung_plugins.sequence.plugins = [];
         plugins.mgenerierung_plugins.sequence.pos = 0;
         plugins.mgenerierung_plugins.sequence.command_line = {};
         
      end;
      plugins.sequence_field = 1;
      
   case 9
      %save plugin list
      if ~exist('datei_save_plugin','var')
         datei_save_plugin = '';
      end;
      save_gaitcad_struct(plugins.mgenerierung_plugins.sequence,parameter,plugins.mgenerierung_plugins.typ_beschreibung.funktionsnamen,...
         'Save plugin sequence','plugin_sequence', datei_save_plugin);
      datei_save_plugin = '';
end;

set(uihd(12,90),'string',sprintf('Selection of plugins, number: %d',length(ind_listbox)));

set(hndl_sequence,'string',plugins.mgenerierung_plugins.full_string(plugins.mgenerierung_plugins.sequence.plugins,:),'value',plugins.mgenerierung_plugins.sequence.pos);

decode_list = [];
[tmp,ind_decode_list]=sort(plugins.mgenerierung_plugins.typ_beschreibung.show_now);
decode_list(plugins.mgenerierung_plugins.typ_beschreibung.show_now)=ind_decode_list;
parameter.gui.merkmalsgenerierung.plugins = decode_list(ind_listbox);
set(hndl_pop,'value',parameter.gui.merkmalsgenerierung.plugins);
set(hndl_edit,'string',kill_lz(num2str(ind_listbox)) );


if isempty(plugins.mgenerierung_plugins.sequence.plugins)
   set(hndl_exec,'Enable','off');
else
   set(hndl_exec,'Enable','on');
end;


callback_check_commandline;