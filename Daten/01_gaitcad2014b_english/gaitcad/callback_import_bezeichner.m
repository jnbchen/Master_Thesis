% Script callback_import_bezeichner
%
% 
%  Callback-Skript für das Importieren von Bezeichnern für Einzelmerkmale
%  oder Zeitreihen
% 
%  Falscher Menüaufruf?
%
% The script callback_import_bezeichner is part of the MATLAB toolbox Gait-CAD. 
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

if (mode == 1 && isempty(d_orgs))
   fprintf(1, 'No time series found. Canceling...\n');
end;
if (mode == 2 && isempty(d_org))
   fprintf(1, 'No single features found. Canceling...\n');
end;

% Frage nach der Datei, aus der die Bezeichner importiert werden sollen.
[bez_datei, bez_pfad] = uigetfile('*.*', 'Import names');
% Keine Datei gewählt?
if (bez_datei == 0)
   clear mode;
   return;
end; % if (datei == 0)

% Extrahiere die Bezeichner
if (mode == 1)
   anz_bezeichner = size(d_orgs,3);
else
   anz_bezeichner = size(d_org, 2);
end;
bezeichnermatrix = import_bezeichner([bez_pfad bez_datei], anz_bezeichner);

if (~isempty(bezeichnermatrix))
   if (mode == 1)
      % Hier noch einmal die Größe kontrollieren
      if (size(bezeichnermatrix,1) == size(d_orgs,3))
         % Aus historischen Gründen muss ein y unten an var_bez angehängt werden.
         var_bez = strvcatnew(bezeichnermatrix, 'y');
      end;
   else
      if (size(bezeichnermatrix,1) == size(d_org,2))
         dorgbez = bezeichnermatrix;
      end;
   end; % if (mode == 1)
end; % if (~isempty(bezeichnermatrix))
% Aktualisieren.
aktparawin;

clear bezeichnermatrix mode bez_pfad bez_datei anz_bezeichner;