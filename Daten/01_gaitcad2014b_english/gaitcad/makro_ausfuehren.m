% Script makro_ausfuehren
%
% startet Makro
%
% The script makro_ausfuehren is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:56:00
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

org_path=pwd;
if ~exist('makro_datei','var')
    makro_datei=[];
end;

extension='*.makrog';

%delete macroo files performed as m file
if exist('makro_m_file.m','file')
    delete('makro_m_file.m');
end;

%Datei laden, wenn es noch keine gibt
if isempty(makro_datei)
    [makro_datei,pfad]=uigetfile(extension,'Load macro');
    if (makro_datei==0)
        makro_datei=[];
    end;
    if (pfad ~= 0)
        cd(pfad);
        
    end;
else
    pfad = fileparts(makro_datei);
    if ~isempty(pfad)
        cd(pfad);
    end;
end;


%Datei in makro_tmp_ausfuehren.m umbenennen und ausführen
if ~isempty(makro_datei)
    
    %um abzufangen, dass die Datei irgendwo rumhängt...
    clear functions;
    if exist(makro_datei,'file')
        full_path_makro=which(makro_datei);
    else
        full_path_makro='';
    end;
    
    if isempty(full_path_makro)
        myerror('Macro not found!The macro must be located anywhere in the current MATLAB path!');
    end;
    
    %Original-Pfad wiederherstellen
    cd(org_path);
    clear org_path;
    %Dateinamen ohne Pfad extrahieren
    [tmp,makro_m_datei]=fileparts(makro_datei);
    %max Filenamenlänge 30 - also abschneiden!
    makro_m_datei=['m' makro_m_datei(1:min(30,length(makro_m_datei)))   ];
    %makro als *.m Datei kopieren
    % Verwende statt dem !copy-Befehl den Matlab-Internen Befehl copyfile.
    % Der hat weniger Probleme mit Leerzeichen im Dateinamen.
    copy_s = copyfile(full_path_makro, [makro_m_datei '.m']);
    if (~copy_s)
        
        %try a second time with the option to overwrite
        %structure is useful to avoid version problems with copyfile
            try 
                copy_s = copyfile(full_path_makro, [makro_m_datei '.m'],'f');
            end;
        
        
        if (~copy_s)
            makro_datei = [];
            
            %be careful and reset the selection fields - a very typical error for
            %macros - it avoids problems for further selections
            auswahl.dat = [];
            auswahl.gen = [];
            
            myerror(sprintf('Error by executing a macro (%s)! The m file has not been generated.',[makro_m_datei '.m']));
            return;
        end;
    end;
    
    %Schalter zum Ausführen von Makros einschalten (beeinflusst u.a. perverse Auswahlmenü-Voreinstellungen)
    parameter.allgemein.makro_ausfuehren=1;
    
    %%%NEW: MAKRO Stack
    if ~isfield(gaitcad_extern,'makro') || isempty(gaitcad_extern.makro)
        gaitcad_extern.entry_pos = 1;
    else
        gaitcad_extern.entry_pos = length(gaitcad_extern.makro)+1;
    end;
    
    
    gaitcad_extern.makro(gaitcad_extern.entry_pos).makro_m_datei   = makro_m_datei;
    gaitcad_extern.makro(gaitcad_extern.entry_pos).full_path_makro_m_datei   = which(makro_m_datei);
    gaitcad_extern.makro(gaitcad_extern.entry_pos).makro_datei     = makro_datei;
    gaitcad_extern.makro(gaitcad_extern.entry_pos).full_path_makro = full_path_makro;
    
    if isfield(gaitcad_extern,'gaitdebug') && gaitcad_extern.gaitdebug == 1
        parameter.gui.anzeige.makro_stop_error = 1;
    end;
    
    %looking for plugin load requests in macros
    
    %if isfield(gaitcad_extern,'batch_processing') && gaitcad_extern.batch_processing == 1 && (~isfield(plugins,'mgenerierung_plugins') || ~isfield(plugins.mgenerierung_plugins,'callback') || isempty(plugins.mgenerierung_plugins.callback))
    if (~isfield(plugins,'mgenerierung_plugins') || ~isfield(plugins.mgenerierung_plugins,'callback') || isempty(plugins.mgenerierung_plugins.callback))
        f_plugmac = fopen(which(gaitcad_extern.makro(gaitcad_extern.entry_pos).makro_m_datei),'rt');
        if f_plugmac>1
            macro_content = fscanf(f_plugmac,'%c');
            fclose(f_plugmac);
            if ~isempty(strfind(macro_content,'Plugin')) || ~isempty(strfind(macro_content,'Extraktion_ZR')) || ~isempty(strfind(macro_content,'_PlugList')) || ...
                    ~isempty(strfind(macro_content,'HAutomatic')) || ~isempty(strfind(macro_content,'Peptides_H8')) || ~isempty(strfind(macro_content,'Peptides_H9')) || ...
                    ~isempty(strfind(macro_content,'DetectSteps')) || ~isempty(strfind(macro_content,'PlugImg'))
                
                
                parameter.allgemein.no_update_reading = 0;
                % Update plugins
                eval(gaitfindobj_callback('CE_PlugListUpdate'));
                
            end;
        end;
    end;
    
    %Hier wird das eigentliche Makro ausgeführt....
    if parameter.gui.anzeige.makro_stop_error == 0
        try
            
            
            
            
            eval(sprintf('%s',gaitcad_extern.makro(gaitcad_extern.entry_pos).makro_m_datei));
            
        catch
            
            %be careful and reset the selection fields - a very typical error for
            %macros - it avoids problems for further selections
            auswahl.dat = [];
            auswahl.gen = [];
            
            delete(gaitcad_extern.makro(gaitcad_extern.entry_pos).full_path_makro_m_datei);
            gaitcad_extern.makro(end) = [];
            myerror([sprintf('Error by executing a macro (%s)! The m file could not be executed.',...
               gaitcad_extern.makro(gaitcad_extern.entry_pos).makro_m_datei) get(0,'errormessage')]);
        end;
    else
        eval(sprintf('%s',gaitcad_extern.makro(gaitcad_extern.entry_pos).makro_m_datei));
    end;
    
    
    %Schalter zum Ausführen von Makros auschalten (beeinflusst u.a. perverse Auswahlmenü-Voreinstellungen)
    parameter.allgemein.makro_ausfuehren=0;
    
    %delete the executable of the macro
    try
        delete(gaitcad_extern.makro(gaitcad_extern.entry_pos).full_path_makro_m_datei);
    end;
    
    % Trage das Makro in die Liste der Favoriten ein.
    param = parameter.gui.menu.favoriten.param;
    param.name_eintrag = sprintf('Macro: %s', gaitcad_extern.makro(end).makro_datei);
    parameter.gui.menu.favoriten = aktualisiere_favoriten(parameter.gui.menu.favoriten, ...
        sprintf('makro_datei=''%s''; makro_ausfuehren;', gaitcad_extern.makro(end).full_path_makro), ...
        parameter, 'ADD USERCALLBACK', param);
    callback_update_favoriten;
    gaitcad_extern.makro(end) = [];
    
    makro_datei = [];
    
    clear extension ;
end;

