% Script ldprj_g
%
% structs retten, falls neue dazu kamen:
%
% The script ldprj_g is part of the MATLAB toolbox Gait-CAD. 
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

if exist('teach_modus','var')  && ~isempty(teach_modus) && isfield(teach_modus,'makro_name') && ~isempty(teach_modus.makro_name) && isfield(teach_modus,'forg') && ~isempty(teach_modus.forg)
    mywarning('The macro recording must be terminated before Gait-CAD can load a new project!');
    teach_modus.f = teach_modus.forg(1);
    
    %stop macro recording
    mode=2;
    callback_teachmodus;
end;

program_name_old=program_name; %Programmname retten, sonst steht dort (durch abgespeicherte Projekte) irgend ein Uralt-Name

%Nachfragen beim Umnummerieren von Ausgangsklassen?
%im Makro-Modus ausschalten!!
if parameter.allgemein.makro_ausfuehren == 0
    gaitcad_extern.umkodieren = 1;
else
    gaitcad_extern.umkodieren = 0;
end;

if exist('next_function_parameter','var') && ~isempty(next_function_parameter)
    datei_load = next_function_parameter;
end;
next_function_parameter = '';

if ~exist('datei_load','var')
    [datei,pfad]=uigetfile('*.prjz','Load project');
else
    %wichtig um Makros laden zu können: datei_load kann durch ein anderes Skript übergeben werden!!!
    [pfad,datei,extension] = fileparts(datei_load);
    try
        if ~isempty(pfad)
            cd(pfad);
        end;
        tmp=which(datei_load);
        if isempty(tmp)
            tmp = datei_load;
            myerror(sprintf('The file %s was not found',tmp));
        end;
        
        [pfad,datei,extension] = fileparts(tmp);
        datei=[datei extension];
        clear datei_load;
    catch
        
        tmp=sprintf('File %s not found',datei_load);
        % Entferne die Datei aus der Liste.
        aktualisiereOpprj(sprintf('%s%sgaitcad.dat',parameter.allgemein.userpath,filesep), datei_load, 'del', 10);
        callback_lastopened;
        clear datei_load;
        datei='';
        myerror(tmp);
    end;
end;

if (datei)
    if ~isempty(pfad)
        cd(pfad);
    end;
    
    try
        %Bestimmte Auswahlparameter retten
        parameter_allgemein_save = parameter.allgemein;
        save([parameter.allgemein.userpath filesep 'temp.dat'],'-mat','datei','pfad','program_name_old','gaitcad_extern');
        gaitcad_userpath = parameter.allgemein.userpath;
        name_internfile  = parameter.allgemein.name_internfile;
        save([parameter.allgemein.userpath filesep 'pfad.dat'],'-mat','gaitcad_userpath','pfad','name_internfile','parameter_allgemein_save');
    catch
        err = lasterr;
        if ~isempty(strfind(lasterr, 'permission denied'))
            myerror('Error by temporary saving of options. Please check your rights to write in this directory.');
            return;
        else
            myerror('Unknown error by saving of a temporary option file. Please try to copy the project in a different directory with write permission.');
            return;
        end;
    end;
    
    %Fenster schließen
    % Nicht mehr den Callback des Menüelements verwenden. Erhöht sonst den Favoritenstatus.
    callback_close_windows;
    cd(parameter.allgemein.userpath);
    
    %hier wird aufgeräumt!!
    clear all;
    % Ein paar Variablen leer initialisieren.
    set_empty_variables;
    modal_dlg = load_dlg;
    drawnow;
    %Bestimmte Auswahlparameter wieder laden
    load(['pfad.dat'],'-mat');
    cd(pfad);
    try
        delete([gaitcad_userpath filesep 'pfad.dat']);
    end;
    
    % In einstellungen_intern.dat wird z.B. die komplette Oberfläche und die nötigen
    % Parameter gespeichert. Das ist zwingend nötig, damit diese das clear all überleben.
    % Nach dem Laden in der folgende Zeile stehen diese Variablen wieder zur Verfügung.
    eval(sprintf('load(''%s%s%s'', ''-mat'')', gaitcad_userpath,filesep,name_internfile));
    load([gaitcad_userpath filesep 'temp.dat'],'-mat');
    parameter.allgemein = parameter_allgemein_save;
    clear parameter_allgemein_save;
    try
        delete([gaitcad_userpath filesep 'temp.dat']);
    end;
    
    %check for handle consistency (can be result in trouble for multiple
    %instances of Gait-CAD
    %Update to better 2014b functionality
    [parameter,uihd] = repair_handles(parameter,uihd);
    
    
    
    profile on;
    
    global d_orgs
    
    %**** MS: Info VOR Beginn des Ladevorgangs einblenden...
    fprintf('Load project %s  ...\n',datei);
    %RALF: Datei soll ohne .prjz Extension sein
    [muell,datei,extension] = fileparts(which(datei));
    
    %reset data point selection
    ind_auswahl = [];
    
    try
        geladen = load([datei '.prjz'],'-mat');
    catch
        myerror(sprintf('Error by reading from file  %s',[datei '.prjz']));
    end;
    
    
    if isempty(extension)		% Wenn zu öffnenendes Projekt aus der Liste der zuletzt aufgerufenen Projekte geladen wird, fehlt die Extension
        extension='.prjz';
    end;
    
    % Um zuletzt geladene File-Liste zu aktualisieren...
    try
        aktualisiereOpprj(sprintf('%s%sgaitcad.dat',parameter.allgemein.userpath,filesep), [pwd filesep datei extension], 'add', 10);
    catch
        delete(sprintf('%s%sgaitcad.dat',parameter.allgemein.userpath,filesep));
    end;
    callback_lastopened;
    
    %Pfad für Bilder auf Projekt initialisiern, sonst Riesenchaos
    %kann später durch abgespeicherte Einstellungen im Projekt oder durch Optionsdatei überschrieben werden
    %Einstellungen aus den Standardoptionen werden aber ignoriert
    if isfield(parameter.gui,'image')
        parameter.gui.image.destination_path = pwd;
    end;
    
    % Alte Projekte können sehr viele Variablen enthalten, da immer der komplette Workspace gesichert wurde.
    % Die neuen Projekte speichern ausschließlich die Projektdaten und die letzten Einstellungen der Oberfläche.
    % Die gesicherten Variablen sind in folgender String-Matrix enthalten:
    erlaubte_vars = cellstr(char('d_org', 'd_orgs', 'd_image','code', 'code_alle', 'dorgbez', 'var_bez', 'zgf_y_bez', 'bez_code', 'optionen', ...
        'projekt','interpret_merk','interpret_merk_rett','L','ind_auswahl'));
    % Lese die Namen der Variablen, die im aktuell geladenen Projekt enthalten sind ein:
    names = fieldnames(geladen);
    for i = 1:length(names)
        % Nur die Variablen übernehmen, die in erlaubte_vars enthalten sind
        akt_name = names{i};
        % Und auch nur diejenigen, die nicht leer sind. Viele Abfragen weiter unten schauen nur auf die Existenz...
        if (ismember(akt_name, erlaubte_vars) && ~isempty(getfield(geladen, akt_name)))
            % Die Variable darf also geladen werden
            eval(sprintf('%s = geladen.%s;', akt_name, akt_name));
        end; % if (ismember(akt_name, erlaubte_vars))
    end;
    % Die projektspezifischen Variablen sollen in den Bereich parameter.projekt:
    if (exist('projekt', 'var'))
        parameter.projekt = projekt;
    else
        parameter.projekt = [];
    end;
    parameter.projekt.datei=datei;
    parameter.projekt.pfad = pwd;
    parameter.projekt.existzebrafishparameters = 0;
    
    
    %*** MS: Struktur des geladenen Projektes überprüfen
    %=====================================================
    
    %RM: sonst fliegt MS-Aenderung ab...
    if ~exist('d_org', 'var')
        d_org=[];
    end;
    if ~exist('d_image', 'var')
        d_image = [];
    end;
    
    if (isempty(d_orgs) && isempty(d_org) && isempty(d_image))
        myerror('The project contain neither time series nor single features!');
        clear datei_load;
    end;
    
    % MS: Daten-Matrizen überprüfen
    % Ist entweder EM oder ZR-Matrix oder Image-Matrix leer?
    if isempty(d_org) || isempty(d_orgs) || isempty(d_image)
        
        if isempty(d_org)
            disp('No single features - set SF-matrix to zero.');
            if ~isempty(d_orgs)
                d_org=zeros(size(d_orgs,1),0);
            else
                if ~isempty(d_image)
                    d_org=zeros(size(d_image.data,1),0);
                end;
            end;
        end;
        
        
        if isempty(d_image)
            reset_image_struct;
        end;
        
        if isempty(d_orgs)
            disp('No time series found - matrix is empty!');
            d_orgs=zeros(size(d_org,1),0,0);
            
            %using of projects with images
            if size(d_image.data,4)>1
                d_orgs=zeros(size(d_org,1),size(d_image.data,4),0);
            end;
        end;
        
    end;
    
    
    % MS: code Matrizen überprüfen
    if ~exist('code', 'var')
        if exist('code_alle', 'var')
            code = code_alle(:,1);
        else
            mywarning('Invalid project (no output variable code)! Generating a dummy output variable with values of 1.');
            code=ones(max(size(d_orgs,1),size(d_org,1)),1);
        end;
    end;
    
    % Wenn der Code-Vektor falsch herum ist, hier ändern, nicht abstürzen :)
    if (size(code,1) == 1)
        code = code';
    end;
    if min(code)<1
        myerror('Invalid project (Class code <1)!');
    end;
    
    
    
    if ~exist('code_alle', 'var')
        code_alle=code;
    end;
    if size(code,2)>1
        code=code_alle(:,1);
    end % um bei frischen Projekten Fehler zu vermeiden (diese haben noch mehr-spaltige code-Matrizen!)
    tmp=findd(code);
    if length(tmp)==1
        disp('The project has only one output class!');
    end;
    if max(tmp~=round(tmp))
        myerror('Invalid project (invalid non-integer values for output classes!)');
    end;
    
    if (size(d_orgs,1)~=size(code,1))
        myerror('Invalid project (Incompatible number of input and output data points (d\_org vs. code,ykont))!');
    end;
    
    fprintf('Repair parameter vector\n');
    if ~exist('code_alle', 'var')
        code_alle=code;
    end;
    if ~exist('par', 'var')
        par.y_choice=1;
    end;
    if ~exist('ref', 'var')
        par.ref_id=[];
        ref=[];
    end;
    if ~exist('my', 'var')
        my=[];
        mstd=[];
    end;
    
    par.anz_dat=size(d_orgs,1);
    par.laenge_zeitreihe=size(d_orgs,2);
    par.anz_image = size(d_image.data,2);
    par.anz_merk=size(d_orgs,3);
    par.anz_y=size(code_alle,2);
    % Lieber die Dimension beim Maximum mit angeben. Kann sonst Probleme geben, wenn nur ein Datentupel
    % aber mehrere Ausgangsgrößen existieren.
    par.anz_ling_y=max(code_alle, [], 1);
    par.anz_einzel_merk=size(d_org,2);
    
    if ~exist('zgf_y_bez', 'var')
        zgf_y_bez='';
    else
        %bei der Existenz von Termbezeichnern wird keinesfalls umkodiert!!
        gaitcad_extern.umkodieren = 0;
    end;
    
    
    unbesetzte_ling_y=0;
    for i=1:par.anz_y
        if length(findd(code_alle(:,i)))~=par.anz_ling_y(i)
            unbesetzte_ling_y=1;
            if gaitcad_extern.umkodieren == 1
                answer = questdlg('The classes of the output variables are not continuously numbered. Renumbering between 1-C?','Load project','Yes','No','Yes');
                if strcmp(answer,'No')
                    gaitcad_extern.umkodieren = 0;
                end;
                break;
            end;
        end;
    end;
    
    if isempty(zgf_y_bez) || ( gaitcad_extern.umkodieren == 1 && unbesetzte_ling_y == 1 )
        disp('Empty output classes - resorting of classes!');
        %Umkodieren
        
        f=fopen('dekod.prot','wt');
        if f<2
            f=1;
            mywarning(sprintf('%s %s?\n','The coding table could not be saved. Permission problem in  ',pwd));
        end;
        
        
        fprintf(f,'Recoding table: \n');
        
        for j=1:par.anz_y
            tmp=code_alle(:,j);
            if gaitcad_extern.umkodieren==1
                codevalue=findd(tmp);
            else
                codevalue=1:max(code_alle(:,j));
            end;
            classcode(j).value=codevalue;
            fprintf(f,'\nVariable %d \n',j);
            if gaitcad_extern.umkodieren==1
                for i=1:length(codevalue)
                    tmp(find(code_alle(:,j)==codevalue(i)))=i*ones(size(find(code_alle(:,j)==codevalue(i))));
                    fprintf(f,'New: %5d   Old: %5d\n',i,codevalue(i));
                end;
            end;
            code_alle(:,j)=tmp;
        end;
        
        if (~isempty(zgf_y_bez))
            %alten Bezeichner retten
            temp=zgf_y_bez;
            clear zgf_y_bez;
            %neue Klassenbezeichner entsprechend Umkodierungstabelle übernehmen
            for j=1:par.anz_y
                zgf_y_bez(j,1:length(classcode(j).value))=temp(j,classcode(j).value);
            end; %j
        end; %if exist
        %Ende Änderung Ralf%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if f>1
            fclose(f);
        end;
        par.anz_ling_y=max(code_alle);
        parameter.projekt.umkodierung = 1;
    else
        parameter.projekt.umkodierung = 0;
    end;
    
    
    clear unbesetzte_ling_y;
    
    if ~exist('var_bez', 'var')
        var_bez='';
    end;
    if ~exist('dorgbez', 'var')
        dorgbez='';
    end;
    
    repair_outputterms;
    
    %Dummy-Variablenbezeichnungen, wenn nötig
    if size(var_bez,1)<par.anz_merk
        %Variablennamen
        var_bez=char(32*ones(par.anz_merk,5));
        for i=1:par.anz_merk
            tmp=sprintf('x%d',i);
            var_bez(i,1:length(tmp))=tmp;
        end;
    end;
    %Dummy-Variablenbezeichnungen, wenn nötig
    if size(dorgbez,1)<par.anz_einzel_merk
        %Variablennamen
        dorgbez=char(32*ones(par.anz_einzel_merk,5));
        for i=1:par.anz_einzel_merk
            tmp=sprintf('x%d',i);
            dorgbez(i,1:length(tmp))=tmp;
        end;
    end;
    %Dummy-Variablenbezeichnungen, wenn nötig
    if size(d_image.names,1)<par.anz_image
        %Variablennamen
        d_image.names = char(32*ones(par.anz_image,5));
        for i=1:par.anz_image
            tmp=sprintf('x%d',i);
            d_image.names(i,1:length(tmp))=tmp;
        end;
    end;
    
    if size(var_bez,1)<(par.anz_merk+1)
        var_bez(par.anz_merk+1,1)='y';
    end;
    var_bez(find(var_bez==0))=32;
    
    if isempty(zgf_y_bez)
        for j=1:size(code_alle,2)
            for i=1:length(classcode(j).value)
                zgf_y_bez(j,i).name=sprintf('%d',classcode(j).value(i));
            end;
        end;
    end;
    clear classcode codevalue  figure_handle;
    
    
    %es gibt nur interpret_merk, auf interpret_merk_rett rüberspielen
    if isempty(interpret_merk_rett)
        interpret_merk_rett=interpret_merk;
    end;
    
    
    %Fenster aktualisieren
    set(1,'name',sprintf('%s, Project %s',program_name,datei));
    
    %Protokollnotizen
    %if uihd(10,1)==0
    %   uihd(10,1)=datini('Number of data points','','',0,par.anz_dat);
    %   uihd(10,2)=datini('Number of features','','',0,par.anz_merk);
    %   uihd(10,3)=datini('Number of output variables','','',0,par.anz_y);
    %   uihd(10,4)=datini('Number of output classes','','',0,par.anz_ling_y);
    %   set([uihd(10,1:4)], 'Parent', 1);
    %end;
    
    
    %Klassenauswahl auf Code zuschneiden
    if ~exist('bez_code', 'var')
        for i=1:par.anz_y
            tmp=sprintf('y%d',i);
            bez_code(i,1:length(tmp))=tmp;
        end;
        bez_code(bez_code==0)=32;
    end;
    if (size(code_alle,2)~=size(bez_code,1))
        myerror('Invalid project (Incompatible number of output variable names)!');
    end;
    
    if ~exist('dorgbez', 'var')
        dorgbez='';
        d_org=zeros(par.anz_dat,0);
    end;
    
    
    %Welche Zeitreihen werden ausgewählt?
    if isempty(ind_auswahl) || length(ind_auswahl) > par.anz_dat || max(ind_auswahl) > par.anz_dat
        ind_auswahl=[1:par.anz_dat]';
        disp('The data selection was reset! ');
    else
        disp('The data point selection (ind_auswahl) was restored from the saved project! ');
    end;
    par.anz_ind_auswahl=length(ind_auswahl);
    
    if exist('gaitcad_extern','var') && isfield(gaitcad_extern,'no_plugin_update') && gaitcad_extern.no_plugin_update == 1
        callback_savemode;
        %zur Vorsicht abtesten, ob es das Fenster noch gibt, erschwert manchmal das debuggen
        if exist('modal_dlg','var')
            delete(modal_dlg);
            clear modal_dlg;
        end;
        
        return;
    end;
    
    
    %Welche Merkmale werden in Kategorie ausgewählt?
    ind_katem=1:par.anz_einzel_merk;
    
    %Ausgangsklasse...
    repair_popup(gaitfindobj('CE_Auswahl_Ausgangsgroesse'),poplist_popini(bez_code),par.y_choice);
    
    clear aufruf_liste;
    
    %schreibt Fenster, aktualisiert Parametervektor
    aktparawin;
    
    %erstmal immer komplette Zeitreihe auswählen
    parameter.gui.zeitreihen.segment_start=1;
    parameter.gui.zeitreihen.segment_ende=par.laenge_zeitreihe;
    disp('Reset time series segments.');
    
    %erstmal immer alle Slices auswählen
    if size(d_image.data,3)>1
        parameter.gui.image.slice_start=1;
        parameter.gui.image.slice_end=par.anz_slices;
        disp('Slice selection was reset!');
    end;
    
    
    
    % Starte immer mit dem 1. Fenster (Projektübersicht)
    parameter.gui.gew_fenster = 1;
    %aufruf_liste = [10 11 18 148];
    % Suche nach Elementen, die einen individuellen Callback enthalten. Diese Elemente werden einmal gesondert gerufen.
    aufruf_liste = cell(0);
    % Welche sollen trotz individuellem Callback nicht gerufen werden?
    ausnahmen = [];
    for i = 1:length(parameter.gui.control_elements)
        if (~isempty(parameter.gui.control_elements(i).callback))
            if (~ismember(i, ausnahmen))
                aufruf_liste{end+1,1} = parameter.gui.control_elements(i).tag;
            end;
        end;
    end;
    clear ausnahmen;
    % Durch diese Art Aufruf wird auch immer der Callback der Elemente ausgelöst.
    % Bei einem allgemeinen Aufruf ohne Angabe des Elements nicht (siehe Kommentar
    % in inGUI).
    % Der Sinn ist, dass die eingestellten Werte überprüft werden. Sowohl bei Edit-Feldern
    % als auch bei Listboxen.
    
    %abweichende Bezeichnung in alten Projekten, evtl. auch Quelle von Sprachproblemen
    if ~strcmp(parameter.gui.zeitreihen.anzeige,'Sample points') && ~strcmp(parameter.gui.zeitreihen.anzeige,'Percental') ...
            && ~strcmp(parameter.gui.zeitreihen.anzeige,'Time') && ~strcmp(parameter.gui.zeitreihen.anzeige,'Project')
        parameter.gui.zeitreihen.anzeige='Sample points';
    end;
    
    
    % Die gesicherten Optionen sollen ebenfalls wiederhergestellt werden:
    % Funktioniert nur bei neuen Projekten. Sollte aber kein Problem sein, die
    % Optionen einmal neu einzustellen...
    parameter.allgemein.no_update_reading = isfield(gaitcad_extern,'batch_processing') && gaitcad_extern.batch_processing == 1;
    
    if exist('optionen', 'var')
        plugins = load_options(parameter.gui.control_elements, geladen.optionen,[],plugins);
        inGUI;
    else
        if exist([parameter.allgemein.userpath filesep parameter.allgemein.name_optionfile],'file')
            fprintf('Load standard options\n');
            gaitcad_extern.uihdg_filename = [parameter.allgemein.userpath filesep parameter.allgemein.name_optionfile];
            callback_load_options;
            fprintf('Complete!\n');
        end;
        
        % not defined in options - select complete time series
        eval(gaitfindobj_callback('CE_Zeitreihen_Segment_Komplett'));
        
        %select all data points
        eval(gaitfindobj_callback('MI_Datenauswahl_Alle'));
        
        
    end;
    
    %handling of search path in gaitcad_extern
    if exist('gaitcad_extern','var') && isfield(gaitcad_extern,'user') && isfield(gaitcad_extern.user,'macro_directory') && ~isempty(gaitcad_extern.user.macro_directory)
        parameter.allgemein.macro_searchpath = gaitcad_extern.user.macro_directory;
        addpath(gaitcad_extern.user.macro_directory);
    end;
    
    
    %OLE: Plugins für neue Merkmalsgenerierung
    if (~isfield(plugins, 'mgenerierung_plugins') || isempty(plugins.mgenerierung_plugins) ...
            || ~isfield(plugins.mgenerierung_plugins, 'funktionsnamen') || isempty(plugins.mgenerierung_plugins.funktionsnamen))
        if parameter.gui.allgemein.autoload_plugins == 1 || ...
                (parameter.gui.allgemein.autoload_plugins == 2 && (~isempty(d_orgs) || ~isempty(d_image.data) ))
            callback_update_plugins;
        end;
    end;
    
    for i_aufrufliste = 1:length(aufruf_liste)
        inGUIIndx = aufruf_liste{i_aufrufliste};
        inGUI;
    end;
    
    % Es gibt ein Problem mit dem TSK-Fuzzy-Editfeld (uihd(11,136)): eine Zeichenkette wird
    % in das Feld geschrieben, die Zeilenumbrüche enthält. Der Fehler war schon mal weg, durch Vermeiden der Initialisierung
    % mit datini. Diese Funktion wird aber aus Kompatibilitätsgründen zwingend benötigt. Also hier den falschen Eintrag explizit
    % verbessern:
    
    
    set(gaitfindobj('CE_ZRKlassi_TSK_Anz'), 'String', num2str(parameter.gui.zr_klassifikation.anz_cluster));
    
    %zur Vorsicht abtesten, ob es das Fenster noch gibt, erschwert manchmal das debuggen
    if exist('modal_dlg','var')
        delete(modal_dlg);
        clear modal_dlg;
    end;
    
    clear muell;
    
    % Setze die Filterfrequenzen auf 1...10Hz. Tue das über die inGUI-Funktion, da dann automatisch kontrolliert wird,
    % ob die halbe Abtastfrequenz nicht überschritten ist.
    parameter.gui.zeitreihen.filterfreq = [1 10];
    inGUIIndx = 'CE_ZR_Filterfreq'; inGUI;
    
    % Favoriten laden
    tmp_param = parameter.gui.menu.favoriten.param;
    try
        if (exist([parameter.allgemein.userpath filesep parameter.allgemein.name_favoritefile], 'file'))
            parameter.gui.menu.favoriten = load([parameter.allgemein.userpath filesep parameter.allgemein.name_favoritefile], '-mat');
        end;
    end;
    parameter.gui.menu.favoriten.param = tmp_param;
    clear tmp_param;
    callback_update_favoriten;
    %init_favoriten_ausschluss;
    
    %check external sampling time in project file
    if isfield(parameter.projekt,'abtastfrequenz')
        parameter.gui.zeitreihen.abtastfrequenz = parameter.projekt.abtastfrequenz;
        inGUIIndx = 'CE_Zeitreihen_Abtastfreq'; inGUI;
    end;
    if isfield(parameter.projekt,'samplingfrequency')
        parameter.gui.zeitreihen.abtastfrequenz = parameter.projekt.samplingfrequency;
        inGUIIndx = 'CE_Zeitreihen_Abtastfreq'; inGUI;
    end;
    
    
    clear erlaubte_vars geladen projekt optionen;
    
    callback_savemode;
    fprintf('Ready: load project.\n');
    
end; % ich glaube von if(datei)
menu_freischalten(parameter, parameter.gui.menu.freischalt);
aktparawin;

%looking for parallel state
try
    mode = 2;callback_matlab_parallel;
catch
    parameter.allgemein.parallel = 0;
end;



%look if a file indicating a secondary Gait-CAD path exist, can be used for
%different evaluation files etc.
parameter.allgemein.secondary_gaitcad_path = parameter.allgemein.pfad_gaitcad;
try
    if exist([parameter.allgemein.userpath filesep 'secondary_gaitcad_path.mat'],'file')
        load([parameter.allgemein.userpath filesep 'secondary_gaitcad_path.mat'],'');
        parameter.allgemein.secondary_gaitcad_path = secondary_gaitcad_path;
    end;
end;

