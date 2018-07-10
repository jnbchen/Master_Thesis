  function bezeichnermatrix = import_bezeichner(datei, anz_benoetigter_bezeichner)
% function bezeichnermatrix = import_bezeichner(datei, anz_benoetigter_bezeichner)
%
% 
%  function bezeichnermatrix = import_bezeichner(datei, anz_benoetigter_bezeichner)
% 
%  
%   Importiert Bezeichner aus einer Datei.
%  
%  
%   Initialisiere Rückgabewert
% 
%  Die Funktion import_bezeichner ist Teil der MATLAB-Toolbox Gait-CAD. 
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Markus Reischl]
% 
% 
%  Letztes Änderungsdatum: 10-May-2007 17:50:30
%  
%  Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU General Public License,
%  wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, 
%  entweder gemäß Version 2 der Lizenz oder jeder späteren Version.
%  
%  Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, dass es Ihnen von Nutzen sein wird,
%  aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder 
%  der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK.
%  Details finden Sie in der GNU General Public License.
%  
%  Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm erhalten haben.
%  Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
%  
%  Weitere Erläuterungen zu Gait-CAD finden Sie in der beiliegenden Dokumentation oder im folgenden Konferenzbeitrag:
%  
%  MIKUT, R.; BURMEISTER, O.; REISCHL, M.; LOOSE, T.:  Die MATLAB-Toolbox Gait-CAD. 
%  In:  Proc., 16. Workshop Computational Intelligence, S. 114-124, Universitätsverlag Karlsruhe, 2006
%  Online verfügbar unter: http://www.iai.fzk.de/projekte/biosignal/public_html/gaitcad.pdf
%  
%  Bitte zitieren Sie diesen Beitrag, wenn Sie Gait-CAD für Ihre wissenschaftliche Tätigkeit verwenden.
% 
%
% The function import_bezeichner is part of the MATLAB toolbox Gait-CAD. 
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

bezeichnermatrix = [];

% Öffne die Datei und lies den Inhalt ein
fid 	 = fopen(datei, 'rt');
inhalt = char(fread(fid, inf, 'uchar'));

% Wir möchten gern einen Zeilenvektor haben...
if (size(inhalt, 1) > 1)
   inhalt = inhalt';
end;

% Erlaubte Teiler sind Zeilenumbruch (Ascii-Zeichen 10 bzw. 13), Tabulator (Ascii-Zeichen 9)
% Komma und Semikolon
teiler = [];
moegliche_teiler = [10 13 9 ',', ';'];
ok = 0;
for i = 1:length(moegliche_teiler)
   anzahl = length(find(inhalt == moegliche_teiler(i)));
   % Die korrekte Anzahl an Trennzeichen gefunden?
   % Bei einem Zeilenumbruch kann auch am Ende noch ein Umbruch sein. Damit also eigentlich ein Trennzeichen zuviel
   if (anzahl == anz_benoetigter_bezeichner-1 || ( (moegliche_teiler(i) == 10 || moegliche_teiler(i) == 13) && anzahl == anz_benoetigter_bezeichner))
      teiler = moegliche_teiler;
      break;
   end;
end; % for(i = 1:length(moegliche_teiler))
if isempty(teiler)
   warning('No separator found or not enough names in file. Canceling...');
   return;
end;
% 10 und 13 kommen meist in Kombination vor
if (teiler == 10 || teiler == 13)
   teiler = [10 13];
end;

% Nun lies die einzelnen Bezeichner ein:
T = [];
R = inhalt;
while(~isempty(R))
   % Der Befehl teilt eine Zeichenkette in einzelne Teile (rekursiv). In T steht das aktuell erkannte Token, in R der Rest.
   [T, R] = strtok(R, teiler);
   if (~isempty(T))
      bezeichnermatrix = strvcatnew(bezeichnermatrix, T);
   end;
end; % while(~isempty(R))
