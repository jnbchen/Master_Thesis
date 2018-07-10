% Script callback_mgenerierung_kombi
%
% The script callback_mgenerierung_kombi is part of the MATLAB toolbox Gait-CAD. 
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

ind_gen = plugins.mgenerierung_plugins.sequence.plugins;

kombi_merk_uihd = figure_handle(2:4,:);
kombi_figure_handle = figure_handle;
% Welche ZR wurden ausgewählt?
% Indizes der zu verwendenen Merkmale:
kombi_ind_merk=get(kombi_merk_uihd(1,1),'value');
kombi_ind_einzug = get(kombi_merk_uihd(2,1),'value');

if ~isempty(ind_gen) &&  ~isempty(teach_modus)
   auswahl.ausgkombi = [];
   auswahl.ausgkombi(1,:) = kombi_ind_merk;
   auswahl.ausgkombi(2,:) = kombi_ind_einzug;
   callback_makro_ok_auswahl;
   teach_modus_save = teach_modus;
   teach_modus.f = 1;
   auswahl.ausgkombi = [];
end;

close(figure_handle(1,1));
if isempty(ind_gen)
   return;
end;

%if ~isempty(teach_modus)
%   teach_modus_save = teach_modus;
%   teach_modus.f = 1;
%end;

ind_merk_start = size(d_orgs, 3);
for i_seq = 1:length(ind_gen)
   
   ind_merk_tempstart = size(d_orgs,3);
   auswahl.gen=[];
   % Leider wird auswahl.gen beim Aufruf des Callbacks gelöscht. Daher
   % müssen hier direkt die Objekte beeinflusst werden:
   
   
   
   
   eval(gaitfindobj_callback('MI_Extraktion_ZRZR'));
   set(figure_handle(2,1), 'value', [kombi_ind_merk ]);
   set(figure_handle(3,1), 'value', [kombi_ind_einzug]);
   
   %identify the plugin number under the plugins for time series and single
   %features
   ind_uihd = find(plugins.mgenerierung_plugins.typ_beschreibung.show_now == ind_gen(i_seq));
   if isempty(ind_uihd)
      if ~isempty(teach_modus)
         teach_modus = teach_modus_save;
      end;
      
      myerror('Invalid plugin!');
   end;
   
   %Handling individual commandline
   nr_plugin = plugins.mgenerierung_plugins.typ_beschreibung.plugin(ind_gen(i_seq));
   %save thr old one
   temp_commandline = plugins.mgenerierung_plugins.info(nr_plugin).commandline;
   %use the commandline parameters of the sequence
   plugins.mgenerierung_plugins.info(nr_plugin).commandline = ...
      plugins.mgenerierung_plugins.sequence.command_line{i_seq};
   
   %set the selected plugin in the command window
   set(figure_handle(4,1), 'value', ind_uihd);
   eval(get(figure_handle(size(figure_handle,1),1),'callback'));
   
   %restore the old commandline
   plugins.mgenerierung_plugins.info(nr_plugin).commandline = temp_commandline;
   
   ind_merk_end = size(d_orgs,3);
   if ind_merk_end>ind_merk_tempstart
      %new time series were generated!
      kombi_ind_merk = [ind_merk_tempstart+1:ind_merk_end];
   end;
end;

% Nun sind zu viele Merkmale erzeugt worden.
% MAKRO AUSWAHLFENSTER Löschen: EM, ZR (manuell)...
loesch = [ind_merk_start+1:ind_merk_tempstart];
if (~isempty(loesch))
   parameter.gui.merkmale_und_klassen.ind_zr = loesch;
   %% Löschen,  Bearbeiten,  Ausgewählte Zeitreihen... 
   eval(gaitfindobj_callback('MI_Loesche_ZR'));
end;

% Auswahl Zeitreihe (ZR)
parameter.gui.merkmale_und_klassen.ind_zr = 1;
inGUIIndx = 'CE_Auswahl_ZR';
inGUI;

parameter.gui.merkmale_und_klassen.ind_em = 1;
inGUIIndx = 'CE_Auswahl_EM';
inGUI;

if ~isempty(teach_modus)
   teach_modus = teach_modus_save;
end;
clear kombi_merk_uihd kombi_ind_merk kombi_ind_einzug ind_gen ind_merk_start ind_merk_end loesch kombi_figure_handle;