% Script callback_zeitreihe_kuerzen
%
% The script callback_zeitreihe_kuerzen is part of the MATLAB toolbox Gait-CAD. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 26-Nov-2014 11:55:58
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

if parameter.allgemein.makro_ausfuehren == 0
   antwort = questdlg('Warning: The original time series will be overwritten! Continue?', 'Question', 'Yes', 'No', 'No');
   if (strcmp(antwort,'No'))
      return;
   end;
end;


% In Fenster das Verfahren anwenden (verwendet Funktion kuerze_zeitreihen)
if (mode == 1)
   switch(parameter.gui.zeitreihen.kuerzen_verfahren)
   case 1
      verfahren = 'mean';
   case 2
      verfahren = 'min';
   case 3
      verfahren = 'max';
   case 4
      verfahren = 'median';
   end;
   d_orgs = kuerze_zeitreihen(d_orgs, parameter.gui.zeitreihen.kuerzen_fensterbreite, verfahren);
end;
% Einfach jeden x.ten Abtastpunkte verwenden
if (mode == 2)
   d_orgs = d_orgs(:, 1:parameter.gui.zeitreihen.kuerzen_fensterbreite:end, :);
end;

% Länge auf die kürzeste Zeitreihe anpassen
if (mode == 3)
   neue_laenge = [];
   switch parameter.gui.zeitreihen.kuerzen_normiertelaenge
   case 2
      %Prozent
      neue_laenge = 100;
   case 3
      %Promille
      neue_laenge = 1000;
   end;
   d_orgs = resampling_auf_kuerzeste(d_orgs(:, :, parameter.gui.merkmale_und_klassen.ind_zr), neue_laenge);
end;


aktparawin;

%max.Länge Zeitreihe anpassen
parameter.gui.zeitreihen.segment_ende = par.laenge_zeitreihe;
inGUIIndx='CE_Zeitreihen_Segment_Ende';
inGUI;