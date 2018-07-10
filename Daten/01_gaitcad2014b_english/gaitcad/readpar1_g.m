% Script readpar1_g
%
% Aenderung Sebastian: Einer-Gegen-Alle fuer alle Klassifikatoren
%
% The script readpar1_g is part of the MATLAB toolbox Gait-CAD. 
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

set_empty_variables; 

%Parameter Statistik
parameter.gui.statistikoptionen.p_krit=0.05;
parameter.gui.statistikoptionen.c_krit=0.7;

%A-Priori-Relevanzen
parameter_kategorien.sagit=1;
parameter_kategorien.front=0.8;
parameter_kategorien.trans=0.8;
parameter_kategorien.stride=1;
parameter_kategorien.stsw=0.8;
parameter_kategorien.phase=0.6;
parameter_kategorien.vzr=0.8;
parameter_kategorien.azr=0.3;
parameter_kategorien.nzr=0.1;
parameter_kategorien.zrstd=0.3;
parameter_kategorien.mipomapo=0.1;
parameter_kategorien.korrhka=0.1;
parameter_kategorien.kritkombi=0.1;

%Regelsuche
parameter.gui.klassifikation.fuzzy_system.art_default=1;   %Auto-Default
parameter.gui.klassifikation.fuzzy_system.fixed_default=1; %duerfte nicht aktiviert sein..
parameter.gui.klassifikation.fuzzy_system.bewertung_regelbasis=2; %Prognosegüte/Einzelregeln
parameter.gui.klassifikation.fuzzy_system.schaetzung_einzelregel=1; %'Fuzzy p(C\P)
parameter.gui.klassifikation.fuzzy_system.kandidaten_regelbasis=1; %alle 
parameter.gui.klassifikation.fuzzy_system.schaetzung_wahrscheinlichkeiten=1; %JGM
parameter.gui.klassifikation.fuzzy_system.min_fitness_typ=1; %automatisch;;
parameter.gui.klassifikation.fuzzy_system.typ_regelmatrix=2; %Konkl.+Komp. offen
parameter.gui.klassifikation.fuzzy_system.ueberfluessige_regeln_loeschen=1; %ja.
parameter.gui.klassifikation.fuzzy_system.logred_pruning=1; %ja.
parameter.gui.klassifikation.fuzzy_system.typegen=1; %generalisieren
parameter.gui.klassifikation.fuzzy_system.anzeige=0; %keine Pruning-Zwischenresultate
parameter.gui.klassifikation.fuzzy_system.min_klarheit=70;
parameter.gui.klassifikation.fuzzy_system.texprotokoll=0;
parameter.gui.klassifikation.fuzzy_system.schaetzung_einzelregel=1;
parameter.gui.klassifikation.fuzzy_system.schaetzung_regelbasis=2;
parameter.gui.klassifikation.fuzzy_system.anzeige_details=1;
parameter.gui.klassifikation.fuzzy_system.evidenz=0;
%Unterordner Entscheiduingsbaum
parameter.gui.klassifikation.fuzzy_system.dectree.anz_baum=5;

parameter.gui.ganganalyse.einzug_links_rechts = []; % Achtung: wird unten noch mal verändert...
parameter.gui.ganganalyse.speicherschonend_einfuegen = []; % Achtung: wird unten noch mal verändert...
parameter.gui.anzeige.linienstaerke = 1;

% Das erste Feld aufrufen, um die Anzeige zu initialisieren
set_anzeigeparameter_new(parameter, 1);
% Die Variablen der Oberflächenelemente mit den Default-Werten vorinitialisieren
ausGUI;

%Vorbereitungs-Dummy
%uihd(11,64)=0;

%Dummy-Variablen
fuzzy_system=[];
merkmal_auswahl=[];

set(uihd(11,29), 'visible','off');