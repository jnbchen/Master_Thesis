% Script set_empty_variables
%
% 
% String zur Beschreibung der durchgeführten Merkmalsauswahl und -aggregation initialisieren
%
% The script set_empty_variables is part of the MATLAB toolbox Gait-CAD. 
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

next_function_parameter = '';

interpret_merk=[]; 
interpret_merk_rett=[];

%Merkmalrelevanzen IST UNBEDINGT ZU ÄNDERN IN merk_einzel_relev
merk=[];
merk_zr = [];

%für evtl. Einheits-Bezeichner
einheit_bez='';


%Titelzeile für plots
titelzeile='';
datei='';

%Anzahl von Clusterzentren (Fuzzy-c-means)
cluster_ergebnis=[];

%Fuzzy-System
fuzzy_system=[];

%Klassifkator
klass_single=[];
klass_zr=[];
%Kostenbewertung
if ~exist('L','var')
L=[];
end;

%Regressionmodell
regr_single=[];


%für new_figure: letzt gewählte Auswählungen aktiviern und speichern
set_empty_auswahl;


%Vorbereitung von Gangübersichtsplots...
subplot_parameter=[];

%Kategorien vorinitialisieren 
code_zr=[];
code_em=[];

%braucht man die noch? 
merk = []; 
merk_archiv=[];
merk_archiv_regr=[];
ind_katem=[];
my=[];
mstd=[];
mstd_em=[];
zgf_bez=[];
%phi_text = [];	


%Klassifikator
pos=[];
prz=[];
md=[];

%Regression
ydach=[];
regr_plot = []; 

% Makroaufzeichnung.
teach_modus = [];
if ~exist('makro_datei','var')
   makro_datei=[]; 
end;
if ~exist('makro_lern','var')
   makro_lern=[];
end;
if ~exist('makro_test','var')
   makro_test=[];
end;
if ~exist('makro_auswertung','var')
   makro_auswertung=[];
end;

%Makros werden derzeit nicht ausgeführt
parameter.allgemein.makro_ausfuehren=0;
callback_read_gaitcad_search_path;

md_all = [];
fehl_proz = [];
klass_hierch_bayes = [];
mccoeff = [];
mcxcoeff = [];
morlet_plot_spect = [];
spect = [];
lastfft =[];
prz_all = [];
rueckstufung = []; 
ref = [];

%Kategorien
categories='';
categories.em='';
categories.zr='';
categories.category_description=[];

%alte Varieble für Menüaktivierungen, vorsichtshalber mal leer
%initialisieren
enmat=[];


%container for macro variables (will not be deleted during program loading)
gaitcad_extern=[];

%Modus zum Berechnen von Triggerzeitreihen, wird nur bei ZR-Klassifikation gezielt angeschaltet
mode_berechne_triggerzr = 0;

mydist = [];

global image_viewer;
image_viewer = struct();

parameter.projekt = [];