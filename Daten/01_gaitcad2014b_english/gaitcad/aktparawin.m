% Script aktparawin
%
% Aktualisierung von Bedienelementen und Variablen
%
% The script aktparawin is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:56
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

if (isfield(parameter.allgemein, 'no_aktparawin') && parameter.allgemein.no_aktparawin)
   return;
end;

if isempty(par)
   return;
end;


% Wenn gerade ein Makro aufgezeichnet wird, dann unterdrücke temporär die Ausgabe in die Makrodatei.
% Dazu sichern wir die file-Handles und setzen sie hier auf 1 (entsprich dem Bildschirm).
% Anschließend werden sie wieder auf die originalen Werte gesetzt.
% teach_modus muss es geben!
if ~isempty(teach_modus)
   makro_orig.f = teach_modus.f;
   makro_orig.forg = teach_modus.forg;
   teach_modus.f = 1;
   teach_modus.forg = 1;
else
   makro_orig = [];
end;


fprintf('Refresh parameters in main window...\n');
figure(1);

%Parametervektor aktualisieren
diff_par=[par.anz_merk par.anz_einzel_merk par.anz_ind_auswahl par.y_choice par.laenge_zeitreihe par.anz_dat]; %ursprünglich für Kategorie, Idee: schaue, ob Anzahl Merkmale sich ändert

%extern als ungültig markierter Wert, wichtig für Zwangsaktualisierung mit
%diff(par(4))
if par.y_choice==0 || size(code_alle,2)< par.y_choice || size(bez_code,1)< par.y_choice
   par.y_choice = 1;
   parameter.gui.merkmale_und_klassen.ausgangsgroesse = 1;
end;

klasse_alt = par.y_choice;

if exist('d_orgs','var') == 0
   mywarning('The global variable d_orgs was reconstructed!');
   global d_orgs
   d_orgs = zeros(size(d_org,1),0,0);   
end;

par.anz_dat=size(d_orgs,1);
par.laenge_zeitreihe=size(d_orgs,2);
par.anz_merk=size(d_orgs,3);
par.anz_y=size(code_alle,2);
par.anz_ling_y=max(code_alle,[],1);
par.anz_einzel_merk=size(d_org,2);
par.anz_ind_auswahl=length(ind_auswahl);

if max(parameter.gui.merkmale_und_klassen.ind_em)>par.anz_einzel_merk || par.anz_einzel_merk >0
   parameter.gui.merkmale_und_klassen.ind_em = 1;
   eval(gaitfindobj_callback('CE_EditAuswahl_EM'));
end;

%neu: KAFKA-Parameter gleich mitberechnen
par_kafka=[par.anz_dat par.anz_merk 1 par.anz_ling_y(par.y_choice)];

% Einige Projekte haben mehr Klassen als andere. Wenn eine Klassennr. ausgewählt
% ist, die es gar nicht mehr gibt, kann es zu Problemen kommen. Also lieber auf
% 1 setzen.
c = get(uihd(11,12), 'value');
if (c > size(code_alle,2))
   c = 1;
   set(uihd(11,12), 'value', c);
end;
par.y_choice = parameter.gui.merkmale_und_klassen.ausgangsgroesse; 
diff_par=diff_par-[par.anz_merk par.anz_einzel_merk par.anz_ind_auswahl par.y_choice par.laenge_zeitreihe par.anz_dat]; % Wenn diff_par=[0 0], dann gab's keine Änderung

parameter.par = par;

%Anzeigeoptionen bei Merkmalsgenerierung:    
%Tilde->Leerzeichen
if (get(uihd(11,47),'value')==1) 
   if ~isempty(dorgbez) 
      dorgbez(dorgbez==126)=32;
   end;
   if ~isempty(var_bez) 
      var_bez(var_bez==126)=32;
   end;
end;   
%Tilde->Unterstrich
if (get(uihd(11,47),'value')==2) 
   if ~isempty(dorgbez) 
      dorgbez(dorgbez==126)=95;
   end;
   if ~isempty(var_bez) 
      var_bez(var_bez==126)=95;
   end;
end;   

% Nummer der Klasse, den Bezeichner und die
% Bezeichner der Klassenausprägungen speichern (für die Anzeige des
% Klassifikationsergebnisses)
% Hat sich die Klasse verändert?
if (diff_par(4) ~= 0)
   % Dann lösche klass_single und lege es neu an.
   % Sonst besteht die Gefahr, dass der Klassifikator auf einer falschen
   % Ausgangsgröße angewendet wird.
   fprintf(1, 'Change output variable. Reset classifier.\n');
   klass_single=[];
   fuzzy_system=[];
end;

% changes in number of data points?
if (diff_par(6) ~= 0)
   fprintf(1, 'Number of data points changed. Resetting data for visualizations...\n');
   regr_plot=[];   
end;

%keine Anzahl-ZR Änderung, hier nur Deaktivierung, Aktiviert wird's bei "Kategorie berechnen ...   "
if diff_par(1)~=0 
   code_zr=[]; %zur Sicherheit
   % Die Referenzdaten sollte (leider) gelöscht werden, sonst kracht es bestimmt mal
   fprintf('Deleting normative data due to changed number of time series! \n');
   ref=[]; 
   my=[];
   subplot_parameter=[];
   cluster_ergebnis=[];
   categories.zr=[];
   merk_archiv_regr =[];
end; 

%keine Anzahl-EM Änderung, hier nur Deaktivierung, Aktiviert wird's bei "Kategorie berechnen ...   "
if diff_par(2)~=0 
   code_em=[]; %zur Sicherheit
   
   %hat das schon jemand korrigiert? Wenn nein, dann löschen 
   if size(interpret_merk_rett,1) ~= (par.anz_einzel_merk)
      interpret_merk=[];
      interpret_merk_rett=[];
      parameter.gui.merkmale_und_klassen.a_priori_relevanzen = 1;
   end;
   
   % Die Referenzdaten sollte (leider) gelöscht werden, sonst kracht es bestimmt mal
   fprintf('Delete SF reference data due to the changed number of single features! \n');
   if ~isempty(ref) % wenn ZR Normdaten noch vorhanden sind, dann lösche EM-Referenz
      ref.my_em=[]; 
      ref.mstd_em=[]; 
   else % wenn keine ZR-Ref vorhanden, dann erstelle auch keine leeren ref.my_em und ref.mstd_em
      ref=[]; 
   end
   my=[];    
   zgf=[];
   
   %bei Klassifikatoren und Fuzzy-Systemen usw. ist das auch zu riskant...
   klass_single=[];
   cluster_ergebnis=[];
   
   %Merkmalsbewertung
   merk=[];
   merk_archiv=[];
   merk_archiv_regr =[];
   
   %Suche Zusammenhänge
   ydach=[];
   
   if ~isempty(L) && isfield(L,'lcl')
      L.lcl = [];
      L.ind_merkmal = [];
   end;

   
   categories.em=[];
end; 

%Änderung Anzahl ausgewählter Datentupel
if (diff_par(3)~=0)
   my=[];
   mstd=[];
   my_em=[];
   mstd_em=[];
   fprintf('The mean values were deleted (i.e. due to changes of selected data points).\n');
end;

%Änderung Ausgangsklasse
if (diff_par(4)~=0)
   code=code_alle(:,par.y_choice);
   
   %Umstellung Entscheidungskosten
   if ~isempty(L)
      L.ld = L.ld_alle(par.y_choice).ld;
   end;
   
   
   merk=[];
   merk_archiv=[];
   my=[];
   mstd=[];
   pos=[];
   prz=[];   
   fprintf('The mean values were deleted (changed selected output variable).\n');
   
   %order of linguistic terms
   parameter.gui.allgemein.order_of_terms = 1:par.anz_ling_y(par.y_choice);
   callback_order_of_terms;
   
end;

%Änderung Länge Zeitreihe
if (diff_par(5)~=0)
   code_zr=[]; %zur Sicherheit
   % Die Referenzdaten sollte (leider) gelöscht werden, sonst kracht es bestimmt mal
   fprintf('Deleting normative data due to changed number of time series! \n');
   ref=[]; 
   my=[];
   subplot_parameter=[];
   cluster_ergebnis=[];
   categories.zr=[];
   merk_archiv_regr =[];
   eval(gaitfindobj_callback('CE_Zeitreihen_Segment_Komplett'));
end;




%Protokollnotizen
figure(1);
uihd(10,1)=datini('Number of data points','','',0,par.anz_dat,0,'',uihd(10,1));
tmp_string=sprintf('Number of selected features: %g  with ',length(ind_auswahl)); % hänge hier die ausgewählten zgf_y_bez dran! 
for i=1:size(code_alle,2)
   if length(findd(code_alle(ind_auswahl,i)))==par.anz_ling_y(i) % wenn hier ==1 dann sollte die Auswahl vollständig sein (Voraussetzung ist dass code_alle(:,i) von 1:n in Einserschritten ist)
      tmp_string=sprintf('%s %s: all; ',tmp_string,kill_lz(bez_code(i,:)));
   else
      tmp_string=sprintf('%s %s: %s; ',tmp_string,kill_lz(bez_code(i,:)),sprintf('%s ',zgf_y_bez(i,findd(code_alle(ind_auswahl,i))).name));
   end
end
uihd(10,2)=datini(tmp_string,'','',0,length(ind_auswahl),0,'',uihd(10,2));clear tmp_string;
uihd(10,3)=datini('Number of time series','','',0,par.anz_merk,0,'',uihd(10,3));
uihd(10,4)=datini('Number of single features','','',0,par.anz_einzel_merk,0,'',uihd(10,4));
uihd(10,5)=datini('Number of selected single features','','',0,length(ind_katem),0,'',uihd(10,5));
uihd(10,6)=datini('Number of output variables','','',0,par.anz_y,0,'',uihd(10,6));
uihd(10,7)=datini('Number of classes','','',0,par.anz_ling_y,0,'',uihd(10,7));
uihd(10,8)=datini('Length of time series','','',0,par.laenge_zeitreihe,0,'',uihd(10,8));
uihd(10,9)=datini('Length of the selected time segment','','',0,1+parameter.gui.zeitreihen.segment_ende-parameter.gui.zeitreihen.segment_start,0,'',uihd(10,9));

% Diese Zeile ist wichtig, damit beim Löschen von fremdem Fenstern nicht plötzlich der Handle ungültig ist.
% Da der Parent beim Erzeugen nicht gesetzt wird, wird es hier nachgeholt.
%Neuz: Tags setzen
for i=1:9
   %set(uihd(10,i), 'Tag', sprintf('IN_%d',i),'visible','off','parent',1);
   set(uihd(10,i), 'Tag', sprintf('IN_%d',i),'visible','off');
end;

%alle variablen Elemente in Listboxen usw. eintragen...
%Zeitreihe....
if par.anz_merk>0
   repair_popup(uihd(11,13),poplist_popini(var_bez(1:par.anz_merk,:)),get(uihd(11,13),'value'));
   temp=poplist_popini(var_bez(1:par.anz_merk,:));
   plugins.mgenerierung_plugins.string(1,:)=char(32);
   plugins.mgenerierung_plugins.string(1,1:length(temp))=temp;
   plugins.mgenerierung_plugins.string = char(plugins.mgenerierung_plugins.string);
   set(uihd(12,15),'string',sprintf('ALL %d',par.anz_merk),'callback','set(uihd(11,13),''value'',[1:size(d_orgs,3)]);eval(get(uihd(11,13),''callback'') )'); 
   eval(get(uihd(11,13),'callback') ); 
   %falls irgendein Plugin das y vernichtet hat...
   if size(var_bez,1)<(par.anz_merk+1)
      var_bez(par.anz_merk+1,1)='y';
   end; 
   
   % In Auswahlfenster für die Triggerzeitreihe eintragen:
   temp = get(uihd(11,134), 'value');
   popini('Trigger time series', ['Complete length|' poplist_popini(var_bez(1:par.anz_merk,:))],temp,440,[],uihd(11,134),uihd(12,134));
   
   if parameter.gui.zeitreihen.segment_ende>par.laenge_zeitreihe
      eval(gaitfindobj_callback('CE_Zeitreihen_Segment_Komplett'));   
   end;
   
else 
   set(uihd(11,13),'String', '');
   set(uihd(12,15),'string','NONE','callback','');    
   %Clustern über Einzelmerkmale
   parameter.gui.clustern.merkmalsklassen=2;
end;
aktualisiere_regressions_output;

%Einzelmerkmale
if (size(d_org,2) ~= 0)
   repair_popup(uihd(11,14),poplist_popini(dorgbez),get(uihd(11,14),'value'));
   set(uihd(12,16),'string',sprintf('ALL %d',par.anz_einzel_merk),'callback','set(uihd(11,14),''value'',[1:size(d_org,2)]);eval(get(uihd(11,14),''callback''));'); 
   eval(get(uihd(11,14),'callback') ); 
else
   set(uihd(11,14), 'String', '');
   set(uihd(12,16),'string','NONE','callback','');
   %Clustern über Zeitreihen
   parameter.gui.clustern.merkmalsklassen=1;
end;

%Ausgangsklasse...
repair_popup(gaitfindobj('CE_Auswahl_Ausgangsgroesse'),poplist_popini(bez_code),par.y_choice);
repair_popup(gaitfindobj('CE_Auswahl_CVOutputSelect'),poplist_popini(bez_code),...
    min(par.anz_y,parameter.gui.validierung.cvoutputselect));
repair_popup(gaitfindobj('CE_Anzeige_DifferentClass'),poplist_popini(bez_code),...
    min(par.anz_y,parameter.gui.validierung.cvoutputselect));

code=code_alle(:,par.y_choice);

% Normdaten vorhanden?
if ~exist('ref', 'var') || isempty(ref)
   parameter.gui.anzeige.anzeige_normdaten = 0;
   inGUIIndx = 'CE_Anzeige_Normdaten'; inGUI;
   parameter.gui.ganganalyse.normdaten_vordergrund = 0;
   inGUIIndx = 'CE_Normdaten_Vordergrund'; inGUI;
   enable_controls(parameter, 'disable', {'CE_Anzeige_Normdaten', 'CE_Normdaten_Vordergrund'});
else 
   enable_controls(parameter, 'enable', {'CE_Anzeige_Normdaten', 'CE_Normdaten_Vordergrund'});
end;

%Apriori-Merkmalsrelevanzen gibt es gar nicht      
if ~exist('interpret_merk_rett', 'var') || isempty(interpret_merk_rett)
   parameter.gui.merkmale_und_klassen.a_priori_relevanzen = 0;
   inGUIIndx = 'CE_A_Priori'; 
   inGUI;
   enable_controls(parameter, 'disable', {'CE_A_Priori','CE_A_Priori_Alpha','CE_A_Priori_Beta'});
else                               
   enable_controls(parameter, 'enable', 'CE_A_Priori');
   if size(interpret_merk_rett,2)>=1
      enable_controls(parameter, 'enable', 'CE_A_Priori_Alpha');
   end;
   if size(interpret_merk_rett,2)>=2
      enable_controls(parameter, 'enable', 'CE_A_Priori_Beta');
   end;   
end;

if ~isfield(parameter.projekt, 'timescale')
   enable_controls(parameter, 'disable', 'CE_ZRAnzeige_Projekt');
else                               
   enable_controls(parameter, 'enable', 'CE_ZRAnzeige_Projekt');
end;


%Warum hier?
set_anzeigeparameter_new(parameter, parameter.gui.gew_fenster);

if isempty(ind_auswahl)
   mywarning('No valid data selection!');
end; 

% Zur Sicherheit:
% (Fenster zum Merkmalslöschen wird auf den gewählten Wert im Hauptfenster gesetzt + "Keins" wird ausgewählt => unabsichtliches Löschen wird vermieden)
auswahl.loesch=[1;1]; 
auswahl.loesch(1,2:length(get(uihd(11,14),'value'))+1)=get(uihd(11,14),'value')+1; 
auswahl.loesch(2,2:length(get(uihd(11,13),'value'))+1)=get(uihd(11,13),'value')+1;

%Nachschauen, ob Merkmalsauswahl noch passt
eval(get(uihd(11,10),'callback'));

%update plugin selection
plug_hndl_list = {'CE_Auswahl_Plugins','CE_Edit_Auswahl_Plugins','CE_Plugins_Text','CE_Plugins_Anzeige','CE_PlugListAdd','CE_PlugListDel','CE_PlugListUp',...
      'CE_PlugListDown','CE_Auswahl_PluginsList','CE_Auswahl_PluginsCommandLine','CE_PlugListDelAll','CE_PlugListLoad','CE_PlugListSave','CE_Plugins_ParameterNumber',...
      'CE_PlugListExec','CE_PlugShowTxt','CE_Plugins_IgnoreIntermediates'};
if par.anz_image == 0 && par.anz_merk == 0
   enable_controls(parameter, 'disable',plug_hndl_list);   
   set(gaitfindobj('CE_Auswahl_Plugins') ,'string','');
else
   enable_controls(parameter, 'enable',plug_hndl_list); 
   if par.anz_image == 0
      set_textauswahl_listbox(gaitfindobj('CE_Plugins_IgnoreIntermediates'),{'Save final result'});
      enable_controls(parameter, 'disable','CE_Plugins_IgnoreIntermediates');   
   end;   
   mode_selection = 0;
   mode_anz = 1;
   callback_anzeige_plugins;
end;




aktparawin_appl;

% Die Projektübersicht aktualisieren. Dafür wird einfach in die zugewiesene Variable geschrieben und inGUI
% für das gewünschte Element aufgerufen.
aktualisiere_projektueber;

inGUI;

% Makroaufzeichnung wieder herstellen
if (~isempty(teach_modus)) && ~isempty(makro_orig)
   teach_modus.f = makro_orig.f;
   teach_modus.forg = makro_orig.forg;
end;



clear makro_orig;
clear tmpchoice handle diff_par tmp_en tmp_en_ch tmp_dis tmp_dis_ch temp muell;

menu_freischalten(parameter, parameter.gui.menu.freischalt);

   

fprintf('Complete!\n');

