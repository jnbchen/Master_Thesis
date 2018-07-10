  function liste = aktualisiere_favoriten(liste, aktueller_befehl, gaitcad_parameter, aktion, param)
% function liste = aktualisiere_favoriten(liste, aktueller_befehl, gaitcad_parameter, aktion, param)
%
% 
% 
% 
%  liste ist sowohl Ein- als auch Ausgang. Der Eingang enthält die aktuelle
%  Liste, die aktualisierte Liste wird zurückgegegen.
%  aktueller_befehl ist der aktuelle Befehl (als Tag),
%  gaitcad_parameter enthält das Gait-CAD Parameterstrukt.
%  aktion ist eine Zeichenkette mit folgenden Möglichkeiten:
%  'ADD USER': Befehl wird als benutzerdefinierter Favorit eingeführt. Diese Einträge bleiben unabhängig
%  von der Nutzung dieser Funktionen eingetragen. So können nur Standard-Menübefehle hinzugefügt werden.
%  Makros sind vom Einfügen in diese Liste ausgeschlossen.
%  'DEL USER': Benutzerdefinierter Favorit wird entfernt.
%  'ADD': Der aktuelle Befehl wird in der Liste aktualisiert oder neu eingetragen
%  'ADD USERCALLBACK': Füge ein oder aktualisiere einen Eintrag, der aber einen eigenen Callback enthält.
%  Der Callback wird dann ebenfalls in aktueller_befehl definiert, zusätzliche Informationen, wie z.B. der
%  Name des Eintrags muss in param.name_eintrag übergeben werden.
%  Für die anderen Elemente wird aus gaitcad_parameter der korrekte Callback ausgelesen.
%  param.ausschlussliste enthält diejenigen Elemente, die nicht in die Favoriten übernommen werden dürfen.
% 
%  Nicht innerhalb eines Makros ausführen
%
% The function aktualisiere_favoriten is part of the MATLAB toolbox Gait-CAD. 
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

if (isfield(gaitcad_parameter.allgemein, 'makro_ausfuehren') && ~isempty(gaitcad_parameter.allgemein.makro_ausfuehren) && gaitcad_parameter.allgemein.makro_ausfuehren)
   return;
end;

% Diese Parameter werden fest in der Funktion verankert. 
anz_standard_befehle    = 10;
anz_nonstandard_befehle = 5;
iir_param   = 0.9;

if (nargin < 5)
   param = [];
end;
% Die Funktion nur dann ausführen, wenn es eine erlaubte Funktion ist.
if (~isempty(param) && isfield(param, 'ausschlussliste') && ~isempty(param.ausschlussliste))
   indx = getfindstr(param.ausschlussliste, aktueller_befehl,'exact');    %indx = strmatch(aktueller_befehl, param.ausschlussliste, 'exact');
   if ~isempty(indx)
      return;
   end;
end;

% Hier wird die Aktion unterschieden. ADD USER und DEL USER bearbeiten eine gemeinsame Liste, ansonsten
% unterscheiden sich die Listen.
% Der Grund ist, dass in ADD alle Einträge bearbeitet werden, bei denen die Übergabe des Tags reicht.
% Bei ADD USERCALLBACK können z.B. Makros eingetragen werden, die einen eigenen Callback benötigen, da
% die Makro-Datei gesichert werden muss.
% Das Suchen des aktuellen Befehls in den gespeicherten Befehlen würde sehr lange dauern, wenn man ständig den
% kompletten Callback vergleicht. Daher wird hier unterschieden und die Befehle mit Nicht-Standard-Callbacks
% extra gespeichert und verarbeitet. 
switch(aktion)
case 'ADD USER'
   if (isempty(liste) || ~isfield(liste, 'manuell') || isempty(liste.manuell))
      indx = [];
      liste.manuell.elements = [];
      liste.manuell.tags     = [];
   else
      indx = getfindstr(liste.manuell.tags, aktueller_befehl, 'exact'); %indx = strmatch(aktueller_befehl, liste.manuell.tags, 'exact');
   end;
   % Nur neu in die Liste einfügen, wenn das Element noch nicht existiert.
   if (isempty(indx))
      % Frage das Handle ab.
      [h, I] = get_element_handle(gaitcad_parameter, aktueller_befehl, 'MI');
      if ~isempty(h)
         % Der Callback darf nicht der aktuelle sein. Da steht ein absoluter Handle drin!
    	   % Verweis also auf das eigentlich gemeinte Menüelement per tag-Abfrage.
          if ~isempty(get(h,'callback'))
            liste.manuell.elements(end+1).name    = get_name(h);
            liste.manuell.elements(end).callback  = sprintf('hndl = findobj(''tag'',''%s''); eval(get(hndl, ''callback''));', ...
                gaitcad_parameter.gui.menu.elements(I).tag);
	         
   	      liste.manuell.elements(end).separator = 0; % Nur aus Kompatibilitätsgründen zu den anderen Einträgen
            liste.manuell.tags = char(liste.manuell.tags, aktueller_befehl);
         end;
      end; % if (~isempty(h))
   end; % if (isempty(indx))
   
case 'DEL USER'
   if (isempty(liste) || ~isfield(liste, 'manuell') || isempty(liste.manuell))
      indx = [];
   else
      indx = getfindstr(liste.manuell.tags, aktueller_befehl, 'exact'); %indx = strmatch(aktueller_befehl, liste.manuell.tags, 'exact');
   end;
      
   if ~isempty(indx)
      liste.manuell.tags(indx, :) = [];
      liste.manuell.elements(indx) = [];
   end;
   
case 'ADD'
   if (isempty(liste) || ~isfield(liste, 'standard') || isempty(liste.standard))
      liste.standard = [];
      liste.standard.elements = [];
      liste.standard.gewichte = [];
      liste.standard.tags     = [];
   end;
   [liste.standard, geklickt] = aktualisiere_liste(gaitcad_parameter, liste.standard, aktueller_befehl);
   if ~isempty(geklickt)
      % In liste.tags sind die Befehle, die bereits einmal verwendet wurden mit den
      % Tags gespeichert.
      % IIR-Parameter für die Filterung der Funktionen. Es wird jeweils nur der alte
      % Wert gespeichert und die Funktion, die ausgeführt wurde, bekommt eine "gefilterte" 1
      % aufaddiert. Die anderen Werte eine "gefilterte" 0, da wird also einfach nur
      % der letzte Wert verringert.
      % geklickt ist nur an einer Stelle 1, nämlich bei der geklickten Funktion.
      % Alle anderen Werte sind null.
      liste.standard.gewichte = (iir_param .* liste.standard.gewichte) + (1-iir_param) .* geklickt;
   end;
   if ~isempty(liste.standard.gewichte)
      [temp_liste, liste.standard.element_indx] = sort(-liste.standard.gewichte);
      if (length(liste.standard.element_indx) > anz_standard_befehle)
         liste.standard.element_indx = liste.standard.element_indx(1:anz_standard_befehle);
      end;
   end;
case 'ADD USERCALLBACK'
   if (isempty(liste) || ~isfield(liste, 'nonstandard') || isempty(liste.nonstandard))
      liste.nonstandard = [];
      liste.nonstandard.elements = [];
      liste.nonstandard.gewichte = [];
      liste.nonstandard.tags     = [];
   end;
   [liste.nonstandard, geklickt] = aktualisiere_liste(gaitcad_parameter, liste.nonstandard, aktueller_befehl, param);
   if ~isempty(geklickt)
      liste.nonstandard.gewichte = (iir_param .* liste.nonstandard.gewichte) + (1-iir_param) .* geklickt;
   end;
   if ~isempty(liste.nonstandard.gewichte)
      [val, liste.nonstandard.element_indx] = sort(-liste.nonstandard.gewichte);
      if (length(liste.nonstandard.element_indx) > anz_nonstandard_befehle)
         liste.nonstandard.element_indx = liste.nonstandard.element_indx(1:anz_nonstandard_befehle);
      end;
   end;
end; % switch(aktion)


% Diese Unterfunktion kapselt eine relativ einfache Funktionalität, um doppelten
% Code zu vermeiden.
% In C könnte man sich das sparen und einfach Zeiger definieren. Das geht hier aber nicht, also der Umweg
% über eine Unterfunktion.
function [liste, geklickt] = aktualisiere_liste(gaitcad_parameter, liste, aktueller_befehl, param)
if (nargin < 4)
   param = [];
end;

error = 0;

% Suche nach dem Index des aktuellen Befehls in der übergebenen Liste.
indx = getfindstr(liste.tags, aktueller_befehl, 'exact'); %indx = strmatch(aktueller_befehl, liste.tags, 'exact');
% Ein neuer Eintrag?
if (isempty(indx))
   % Das element-Strukt für diesen Befehl vorbereiten
   % Ist es ein Standard-Eintrag?
   if (isempty(param) || ~isfield(param, 'name_eintrag') || isempty(param.name_eintrag))
      % Finden wir den Handle für diesen Menüeintrag?
      [h, I] = get_element_handle(gaitcad_parameter, aktueller_befehl, 'MI');
      if ~isempty(h)
         % Siehe oben, tag wird benötigt, um allgemein verwendbaren Callback zu sichern
         if ~isempty(get(h,'callback'))
            liste.elements(end+1).name    = get_name(h);
            liste.elements(end).callback  = sprintf('hndl = findobj(''tag'',''%s''); eval(get(hndl, ''callback''));', ...
                gaitcad_parameter.gui.menu.elements(I).tag);
            liste.elements(end).separator = 0; % Nur aus Kompatibilitätsgründen zu den anderen Einträgen
         else
            error = 1;
         end;
      else
         % Nein, dann stimmt etwas nicht!
         error = 1;
      end;
   else
      % Benutzerdefiniertes Objekt. Der Name steht in param.name_eintrag, der Callback direkt in aktueller_befehl
      liste.elements(end+1).name    = param.name_eintrag;
      liste.elements(end).callback  = aktueller_befehl;
      liste.elements(end).separator = 0; % Nur aus Kompatibilitätsgründen zu den anderen Einträgen
   end; % if (isempty(param))
   % Wenn kein Fehler aufgetreten ist, dann füllen wir die restlichen Dinge noch aus.
   if error == 0
	   % Neuen Tag unten anhängen
   	liste.tags = strvcatnew(liste.tags, aktueller_befehl);
	   % Neuen "alten" Wert festlegen
   	liste.gewichte = [liste.gewichte 0];
   
	   geklickt = zeros(size(liste.gewichte));
      geklickt(end) = 1;
   else
      % Ansonsten wird eine leere Matrix zurückgegegen.
      geklickt = [];
   end;
else
   % Der Eintrag existiert. Also einfach nur geklickt anpassen, die Liste
   % bleibt unverändert.
   geklickt = zeros(size(liste.gewichte));
   geklickt(indx) = 1;
end; % if (isempty(indx))

function name = get_name(handle)
name = get(handle, 'Label');
p = get(handle, 'Parent');
while ~isempty(p) && strcmp(get(p, 'Type'), 'uimenu')
   name = [get(p, 'Label'), ' - ' name];
   p = get(p, 'Parent');
end;
