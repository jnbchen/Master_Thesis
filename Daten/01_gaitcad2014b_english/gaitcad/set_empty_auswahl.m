% Script set_empty_auswahl
%
% The script set_empty_auswahl is part of the MATLAB toolbox Gait-CAD. 
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

auswahl.dat=[]; % Zur Datenauswahl
auswahl.gen=[]; %Für Generierung neuer Merkmale
auswahl.em_gen=[]; %Für Generierung EM aus EM (z.B. Differenz)
auswahl.loesch=[]; %für merkmalslöschen
auswahl.ausgloesch=[]; %für Ausgangsgrößen löschen
auswahl.flip_norm=[13:24 37]; %für Phasenverschiebung bei Normdaten
auswahl.einzel_merk=[]; % für Einzelmerkmal-plot
auswahl.farb_anz=[]; % für plot Einzelmerkmal gegen Ausgangsklasse zur Farb-Auswahl 
auswahl.mclust=[];
auswahl.zsh=[];
auswahl.metrik=[]; %Analog zur Datenauswahl, allerdings zur Metrik-Bestimmung, z.B. zum Clustern
auswahl.katzr=[]; % für Kategorie-Auswahl, ZR
auswahl.katem=[]; % für Kategorie-Auswahl, EM
auswahl.dsloesch=[]; %für Datentupel löschen
auswahl.ausgkombi=[];
auswahl.umbenennen=[]; %umbenennen diverser Objekte
auswahl.kreuzkorr=[]; % für Auswahl zu "kreuzkorrelierender" ZR.
auswahl.rule=1;
auswahl.ind_auswahl=[];
auswahl.roc=[];
auswahl.kreuzkorr_dt = [];
auswahl.output2d=[];
auswahl.ausgtermstat = 1; %ouput variable for the term statistics

auswahl_speicher=[]; % zum speichern ALLER auswahl. Variablen
