  function erfolgreich = aktualisiereOpprj(dateiname, eintrag, aktion, max_eintraege)
% function erfolgreich = aktualisiereOpprj(dateiname, eintrag, aktion, max_eintraege)
%
% 
% 
%  function erfolgreich = aktualisiereOpprj(dateiname, eintrag, aktion)
%  Aktualisiert die Liste mit den zuletzt geladenen Dateien.
%  Dateiname ist dabei der Name der Datei, in der die Liste gespeichert ist.
%  Diese Datei wird angelegt, wenn sie nicht existiert.
%  eintrag ist der zu bearbeitende Eintrag.
%  Dieser wird bei
%  aktion == 'add' eingefügt und bei
%  aktion == 'del' gelöscht.
%  Existiert ein Eintrag bereits, wird dieser bei aktion=='add' an das Ende verschoben.
%  max_eintraege gibt an, wie viele Einträge maximal in der Liste existieren dürfen. Bei
%  zu vielen Einträgen wird die Liste gekürzt (die ältesten werden entfernt).
% 
%
% The function aktualisiereOpprj is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 4)
   error('Too few parameters!');
end;
if isempty(eintrag)
   error('None new or changed entries found!');
end;
if isempty(aktion)
   aktion = 'add';
end;

% Wenn die Datei nicht existiert, dann lege die Daten neu an
[pfad, name, endung] = fileparts(eintrag);
if exist(dateiname, 'file')
   load(dateiname, '-mat');
   
   % Welche Einträge gibt es bisher?
   namen = {opprj.name};
   pfade = {opprj.pfad};
   ext   = {opprj.ext};
   % Gibt es den Eintrag schon?
   i_match = getfindstr(namen, name,'exact');
else
   opprj = [];
   i_match = [];
end; % if exist(dateiname, 'file')

einfuegen = 0;
% Der Name wurde gefunden
if ~isempty(i_match)
   for i=i_match'
      % Noch pfad und extension vergleichen
      if (strcmp(pfade{i}, pfad) && strcmp(ext{i}, endung))
         % Stimmt überein. Also erst einmal entfernen.
         opprj(i) = [];
         if (strcmp(aktion, 'add'))
            einfuegen = 1;
         end;
      end; % if (strcmp(pfade{i}, pfad) && strcmp(ext{i}, endung))
   end; %for i=i_match
   
else
   % Wenn der Eintrag eingefügt werden soll, dann setze das Flag.
   if (strcmp(aktion, 'add'))
      einfuegen = 1;
   end;
end; % if (~isempty(i))

if (einfuegen)
   opprj(end+1).name = name;
   opprj(end).pfad   = pfad;
   opprj(end).ext    = endung;
end;
% Zu viele Einträge vorhanden?
if (size(opprj, 2) > max_eintraege)
   start = size(opprj,2)-max_eintraege+1;
   ende  = start + max_eintraege - 1;
   opprj = opprj(start:ende);
end;
save(dateiname, 'opprj', '-mat');