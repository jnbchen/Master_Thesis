  function enmat = enable_controls(parameter, varargin)
% function enmat = enable_controls(parameter, varargin)
%
% 
%  (De-)Aktiviert angegebene Men�punkte. parameter enth�lt
%  das Gait-CAD-Parameterstrukt.
%  Um Elemente zu aktivieren, muss das Schl�sselwert 'enable'
%  sowie ein Cell-Array mit zu aktivierenden Elementen angegeben werden.
%  Das Deaktiveren geschieht �ber 'disable' mit folgendem Cell-Array.
%  Nat�rlich kann auch beides gleichzeitig erfolgen.
%  Die Identifikation der Elemente geschieht �ber ihr Tag (siehe menu_elements.m)
%  Wird ein Men�punkt freigegeben, werden automatisch alle Parents ebenfalls freigegeben,
%  um die Erreichbarkeit des Men�punkts zu gew�hrleisten.
% 
%  enmat = enable_menus(parameter, 'disabe', 'all');
%  deaktivert bzw. aktiviert (mit 'enable', 'all') alle Elemente.
% 
%  enmat = enable_menus(parameter, 'disable', 'all', 'enable', el);
%  Deaktiviert alle Elemente mit Ausnahme von denen, die in el enthalten sind.
%  Andersherum, also
%  enmat = enable_menus(parameter, 'enable', 'all', 'disable', el)
%  geht nat�rlich auch.
%  Bei diesem Aufruf ist die Reihenfolge wichtig! Wird zuerst enable ... gerufen,
%  wird durch das folgende disable alles deaktivert.
% 
%  Um alle Unterpunkte eines Men�s zu aktiveren oder deaktiveren:
%  enmat = enable_menus(parameter, 'enable_children', el) bzw. 'disable_children'.
%  In el stehen die Tags der Men�punkte, deren Untermen�s ver�ndert werden sollen.
%  Die Suche geschieht rekursiv, d.h. enth�lt ein Untermen� wieder Untermen�s werden diese
%  ebenfalls (de-)aktiviert.
% 
%  strukt = enable_menus(parameter)
%  gibt ein Strukt zur�ck, das einen Vektor mit den Freischalt-Daten der Men�punkte enth�lt.
% 
%  enmat = enable_menus(parameter, strukt)
%  schreibt die gespeicherten Freischalt-Daten in die Elemente zur�ck.
% 
%  Die R�ckgabe enmat erfolgt aus Kompatibilt�tsgr�nden zur alten
%  Men�freigabe-Funktion enchk, die diesen Parameter zwingend braucht.
%  Das alte enmat muss hier nicht �bergeben werden, da es immer komplett neu
%  ausgelesen wird.
% 
% 
%
% The function enable_controls is part of the MATLAB toolbox Gait-CAD. 
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

if (nargin < 1)
   error('Too few parameters.');
   return;
end;
% Wenn nur ein Argument �bergeben wurde, gebe den aktuellen
% Status der Freigaben zur�ck
if (nargin == 1)
   enmat = freischalt(parameter, 0);
   return;
end;
% Bei zwei Argumenten soll der gesicherte Stand wieder
% geschrieben werden.
if (nargin == 2)
   if (~isstruct(varargin{1}))
      error('No struct found. Cancel.');
      return;
   end;
   freischalt(parameter, 0, 0, varargin{1});
   enmat = freischalt(parameter, 1);
   return;
end;

if (rem(length(varargin), 2))
   error('Odd number of optional arguments!');
end;

on_off = {'off', 'on'};
% Gehe durch die Befehle durch. Es braucht nur jedes zweite Feld betrachtet werden,
% da in den ungeraden Variablen die Parameter stehen.
for i = 1:2:length(varargin)
   % Welcher Befehl soll ausgef�hrt werden?
   cmd = lower(varargin{i});
   en = ~isempty(strfind(cmd, 'enable'));
   % Wie sind die Parameter?
   liste = varargin{i+1};
   if (strcmp(liste, 'all'))
      indx = [1:length(parameter.gui.control_elements)];
   else
		% Sonst hole die Indizes der Men�eintr�ge
      [indx] = get_indx(parameter, liste);
   end; % if (strcmp(liste, 'all'))
   % Hier wird der neue Wert gesetzt. Das geht f�r alle handles gleichzeitig, zumindest solange
   % sie in einem Vektor stehen
   set(myCellArray2Matrix({parameter.gui.control_elements(indx).handle}), 'enable', on_off{en+1});
   % Evtl. auch einen Bezeichner freischalten - aber nur, wenn er existiert!!!
   for i_indx = indx
      if ~isempty(parameter.gui.control_elements(i_indx).bezeichner)
         set(parameter.gui.control_elements(i_indx).bezeichner.handle,'enable', on_off{en+1});
      end;      
   end;
   
  % bez = myCellArray2Matrix({parameter.gui.control_elements(indx).bezeichner});
  % if (~isempty(bez))
  %    set(myCellArray2Matrix({bez.handle}), 'enable', on_off{en+1});
  % end;
end; % for(i = 1:2:length(varargin))

% Zum Abschluss wird enmat berechnet:
enmat = freischalt(parameter, 1);


% Subfunktion zur Suche der zu �ndernden Indizes
function [indx] = get_indx(parameter, liste)
% Alle Tags der Men�eintr�ge
tags = {parameter.gui.control_elements.tag};
% Sicherstellen, dass liste ein cell-Array ist
if (~iscell(liste))
   liste = cellstr(liste);
end;
indx = [];
% F�r jedes zu behandelndes Element den Index suchen
for el = 1:length(liste)
   if liste{el} ~= -1
      i = find(strcmp(liste{el}, tags));
      if ~isempty(i)
         indx = [indx i(1)];
      else
         warning(sprintf('Element %s not found!', liste{el}));
      end;
   end;
end;

% function ret = freischalt(parameter, enmat, read)
% Unterfunktion.
% Liest die bisherigen Freischalt-Optionen aus und speichert
% sie. Entweder in einer enmat-Matrix der bisherigen Form (enmat==1)
% oder ein einem Strukt, in dem sp�ter auch die Kontroll-Elemente
% eingebunden werden (enmat == 0).
% Mit read kann zwischen lesen und schreiben umgeschaltet werden (nur bei
% enmat == 0).
function ret = freischalt(parameter, enmat, read, ret)

if (nargin < 2)
   enmat = 0;
end;
if (nargin < 3)
   read = 1;
end;
if (nargin < 4)
   ret = [];
end;
for i = 1:length(parameter.gui.control_elements)
   % Sp�ter wird es vielleicht kein uihd mehr geben.
   if (enmat)
      if (~isempty(parameter.gui.control_elements(i).uihd_code))
         % In indx und indy darf nicht null stehen!
         indx = parameter.gui.control_elements(i).uihd_code(1);
         indy = parameter.gui.control_elements(i).uihd_code(2);
         if indx > 0 && indy > 0
            en = strcmp(get(parameter.gui.control_elements(i).handle, 'enable'), 'on');
            ret(indx, indy) = en;
         end;
      end;
   else
      if (read)
         ret.control(i) = strcmp(get(parameter.gui.control_elements(i).handle, 'enable'), 'on');
      else
         en = ret.control(i);
         if (en)
            set(parameter.gui.control_elements(i).handle, 'enable', 'on');
            if ~isempty(parameter.gui.control_elements(i).bezeichner)
               set(parameter.gui.control_elements(i).bezeichner.handle, 'enable', 'on');
            end;
         else
            set(parameter.gui.control_elements(i).handle, 'enable', 'off');
            if ~isempty(parameter.gui.control_elements(i).bezeichner)
               set(parameter.gui.control_elements(i).bezeichner.handle, 'enable', 'off');
            end;
         end;
      end;
   end;
end;