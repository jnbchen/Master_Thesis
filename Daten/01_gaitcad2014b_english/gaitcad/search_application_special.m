  function [appl_specials, aktiv] = search_application_special(pfad, aktiv)
% function [appl_specials, aktiv] = search_application_special(pfad, aktiv)
%
% 
%  Sucht im angegeben Pfad im Unterverzeichnis application_specials
%  nach Unterverzeichnissen mit definierten Dateien.
%  Verwertbare Dateien sind control_elements_*, menu_elements_*, optionen_felder_* und aktparawin_*
% 
%  Formatbedingungen:
%  function elements = menu_elements_*
%  Gibt ein Strukt mit Menüpunkten zurück. Das Strukt hat das gleiche Format wie in
%  menu_elements festgelegt. Es wird davon ausgegangen, dass das erste Element
%  (also elements(1)), der Eintrag im Hauptmenü sein soll.
% 
%  function elements = control_elements_*
%  Gibt ein Strukt mit Kontroll-Elementen zurück. Das Strukt hat das gleiche Format wie
%  in control_elements festgelegt.
% 
%  function felder = optionen_felder_*
%  Gibt ein Strukt mit Optionen-Feldern zurück. Das Format der Felder ist das gleiche
%  wie in optionen_felder
% 
%  aktparawin_*
%  Skript mit einigen Aufrufen zum Aktualisieren des Fensters.
%  Dazu gehören z.B. Freigaben für Fenster oder Kontroll-Elemente.
%
% The function search_application_special is part of the MATLAB toolbox Gait-CAD. 
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

def_pfad = 'application_specials';
if (pfad(end) ~= filesep)
   pfad(end+1) = filesep;
end;

appl_specials.control_elements = {};
appl_specials.menu_elements = {};
appl_specials.optionen_felder = {};
appl_specials.aktparawin = {};
appl_specials.name ={};
appl_specials.help ={};

if (~isempty(aktiv))
   verz = {aktiv.name};
   gefunden = zeros(length(verz), 1);
else
   verz = {};
   gefunden = [];
end;

start_dir = [pfad def_pfad];
D = dir(start_dir);
for i = 1:length(D)
   if (D(i).isdir)
      if (strcmp(D(i).name, '.') == 0 && strcmp(D(i).name, '..') == 0)
         % Wurde dieses "Verzeichnis" ausgeschaltet?
         if (~isempty(aktiv))
            indx = find(strcmp(D(i).name, lower(verz)));
            % Wenn es diesen Namen in der Liste gibt, kontrolliere, ob dieses Special
            % ausgeschaltet ist
            if (~isempty(indx))
               an = aktiv(indx).an;
               gefunden(indx) = 1;
            else
               an = -1;
            end;
         else
            an = -1;
         end; % if (~isempty(aktiv))
         
         if (abs(an))
            akt_dir = [start_dir filesep D(i).name];
            
            DD = dir(akt_dir);
            eingefuegt = 0;
            % Suche nach Dateien die control_elements_, ... mit der Endung des Verzeichnisses haben.
            namen = {DD.name};
            name = sprintf('control_elements_%s.m', D(i).name);
            indx = find(strcmp(name, namen));
            if (~isempty(indx))
               if an>0
                  appl_specials.control_elements{end+1} = name(1:length(name)-2);
               end;
               eingefuegt = 1;
            end;
            name = sprintf('menu_elements_%s.m', D(i).name);
            indx = find(strcmp(name, namen));
            if (~isempty(indx))
               %hier werden zusätzlich die Namen gemerkt ...
               if an>0
                  appl_specials.name{end+1} = D(i).name;
                  appl_specials.menu_elements{end+1} = name(1:length(name)-2);
               end;
               eingefuegt = 1;
            end;
            name = sprintf('optionen_felder_%s.m', D(i).name);
            indx = find(strcmp(name, namen));
            if (~isempty(indx))
               if an>0
                  appl_specials.optionen_felder{end+1} = name(1:length(name)-2);
               end;
               eingefuegt = 1;
            end;
            name = sprintf('aktparawin_%s.m', D(i).name);
            indx = find(strcmp(name, namen));
            if (~isempty(indx))
               if an>0
                  appl_specials.aktparawin{end+1} = name(1:length(name)-2);
               end;
               eingefuegt = 1;
            end;
            if eingefuegt == 1 && an>0
               helpname = getsubdir(akt_dir,'*help.pdf',0);
               if (~isempty(helpname))
                  appl_specials.help{end+1} = helpname;
               else
                  appl_specials.help{end+1} = '';
               end;
               
            end;
            if eingefuegt && an>0
               path_1 = akt_dir;
               path_2 = [akt_dir filesep 'plugins' filesep 'einzuggenerierung'];
               if ~isdir(path_2)
                  path_2 = '';
               end;
               path_3 = [akt_dir filesep 'plugins' filesep 'mgenerierung'];
               if ~isdir(path_3)
                  path_3 = '';
               end;
               path_4 = [akt_dir filesep 'standardmakros'];
               if ~isdir(path_4)
                  path_4 = '';
               end;
               path_5 = [akt_dir filesep 'toolbox'];
               if ~isdir(path_5)
                  path_5 = '';
               end;
               addpath(path_1,path_2,path_3,path_4,path_5);
            end;
            % Dieses Verzeichnis stand nicht in der Liste. Also trage es ein:
            if eingefuegt && an<0
               aktiv(end+1).name = D(i).name;
               aktiv(end).an = 0;
               
            end; % if (eingefuegt)
         else
            % Ansonsten Pfad vorsichtshalber aus dem Matlab-Pfad entfernen.
            
            akt_dir = [start_dir filesep D(i).name];
            p = path;
            tmp=([akt_dir filesep 'plugins' filesep 'einzuggenerierung']);
            if ~isempty(strfind(tmp, p))
               %additional addpath to avoid error messages for pathes with partial names of other packages
               addpath(tmp);
               rmpath(tmp);
            end;
            tmp=([akt_dir filesep 'plugins' filesep 'mgenerierung']);
            if ~isempty(strfind(tmp, p))
               %additional addpath to avoid error messages for pathes with partial names of other packages
               addpath(tmp);
               rmpath(tmp);
               
            end;
            tmp=([akt_dir filesep 'plugins' filesep 'standardmakros']);
            if ~isempty(strfind(tmp, p))
               %additional addpath to avoid error messages for pathes with partial names of other packages
               addpath(tmp);
               rmpath(tmp);
               
            end;
            if ~isempty(strfind(akt_dir, p))
               %additional addpath to avoid error messages for pathes with partial names of other packages
               addpath(akt_dir);
               rmpath(akt_dir);
            end;
         end; % if (abs(an))
      end; % if (strcmp(D(i).name, '.') == 0 && strcmp(D(i).name, '..') == 0)
   end; % if (D(i).isdir)
end; % for(i = 1:length(D))

% In gefunden stehen alle Verzeichnisse, die im Strukt gespeichert sind.
% Wenn ein Verzeichnis beim Durchsuchen des Special-Ordners nicht gefunden wird,
% dann sollte es auch aus der Liste raus. Sonst wird es bei einem neuen Einbinden
% dieses Verzeichnisses nicht gleich angezeigt, sondern deaktiviert...
if ~isempty(gefunden)
   indx = find(gefunden==0);
   aktiv(indx) = [];
end;

