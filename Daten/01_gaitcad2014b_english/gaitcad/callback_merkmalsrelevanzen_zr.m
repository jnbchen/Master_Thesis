% Script callback_merkmalsrelevanzen_zr
%
% The script callback_merkmalsrelevanzen_zr is part of the MATLAB toolbox Gait-CAD. 
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

par_d_org=[length(ind_auswahl) size(d_orgs,3) 1 length(findd(code(ind_auswahl)))];
enmat = enable_menus(parameter, 'disable', {'MI_Anzeige_EM_Relevanzen', 'MI_Anzeige_EM_Relevanzen_un'});

tmp_d_org = squeeze(d_orgs(ind_auswahl, parameter.gui.zeitreihen.samplepunkt, :));

% MANOVA,
if (mode == 2)
   parameter_merkred.mode_bewertung = 4;
else
   % ANOVA
   parameter_merkred.mode_bewertung = 3;
end;
parameter_merkred.par					 = par;
parameter_merkred.par.par_d_org(1:4) = par_d_org;
parameter_merkred.merkmal_vorauswahl = [];
parameter_merkred.anzeige_details    = 0;
parameter_merkred.merk_red				 = parameter.gui.klassifikation.merk_red;

[merkmal_auswahl_zr, merk, merk_archiv] = feature_selection (tmp_d_org, ...
   code(ind_auswahl,:), ...
   [], ...
   parameter_merkred);

%Merkmalsauswahl in entsprechendes Auswahlfenster schreiben
set(uihd(11,13),'value',merkmal_auswahl_zr);
eval(get(uihd(11,13),'callback'));

% Anzeige freischalten
enmat = enable_menus(parameter, 'enable', {'MI_Anzeige_ZRRelevanz', 'MI_Anzeige_ZRRelevanz_un'});

clear tmp_d_org par_d_org;