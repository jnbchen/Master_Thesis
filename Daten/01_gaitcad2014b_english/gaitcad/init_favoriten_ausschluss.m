% Script init_favoriten_ausschluss
%
%  Skript init_favoriten_ausschluss
% 
%  
%  
% 
%  Das Script init_favoriten_ausschluss ist Teil der MATLAB-Toolbox Gait-CAD. 
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
% The script init_favoriten_ausschluss is part of the MATLAB toolbox Gait-CAD. 
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

parameter.gui.menu.favoriten.param.ausschlussliste = [];
% Zunächst alle Einträge in die Ausschlussliste eintragen, die Kinder haben.
% Es dürfen nur Menüeinträge eingefügt werden, die eine Funktion ausführen.
for i = 1:length(parameter.gui.menu.elements)
   if (~isempty(parameter.gui.menu.elements(i).menu_items))
      parameter.gui.menu.favoriten.param.ausschlussliste = strvcatnew(parameter.gui.menu.favoriten.param.ausschlussliste, parameter.gui.menu.elements(i).tag);
   end;
end;

% Weitere Elemente einfügen
weitere_elemente = char('MI_Laden', 'MI_Speichern', 'MI_SpeichernUnter', 'MI_Export_ASCII', 'MI_Import_ASCII', ...
   'MI_Datei_Norm', 'MI_Datei_DataMining', 'MI_Datei_Einstellungen', 'MI_Beenden', ...
   'MI_Fuzzy_RUBImport',  'MI_Fuzzy_RUBExport', 'MI_Classifier_Import',  'MI_Classifier_Export', ...
   'MI_Makro_Ausfuehren', 'MI_Makro_Simultan', 'MI_Makro_Aufzeichnen', 'MI_Makro_Beenden', 'MI_Makro_Bearb','MI_Makro_Loeschen', ...
   'MI_Loesche_Favoriten', 'MI_Manuelle_Favoriten');
parameter.gui.menu.favoriten.param.ausschlussliste = strvcatnew(parameter.gui.menu.favoriten.param.ausschlussliste, weitere_elemente);
clear weitere_elemente i;   