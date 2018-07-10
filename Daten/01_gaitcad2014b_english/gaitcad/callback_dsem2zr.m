% Script callback_dsem2zr
%
% alle Einzelmerkmale werden in Zeitreihe geschrieben
%
% The script callback_dsem2zr is part of the MATLAB toolbox Gait-CAD. 
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

d_orgs=[];
d_orgs(1, :, :) = [d_org code_alle];
var_bez = strvcatnew(dorgbez,bez_code);

%Codes löschen
code=1;
code_alle=1;
bez_code='y';
zgf_y_bez=[];
zgf_y_bez(1,1).name='1';

%Auswahl korrigieren
ind_auswahl=1;

%Einzelmerkmale löschen
d_org=zeros(1,0);
dorgbez='';

%Zeitreihen-Segmente definieren
parameter.gui.zeitreihen.segment_start=1;
parameter.gui.zeitreihen.segment_ende=size(d_orgs,2);

% Plugins aktualisieren
eval(gaitfindobj_callback('CE_PlugListUpdate'));

%alles aktualisieren
aktparawin;



 [plugins.mgenerierung_plugins, plugins.einzuege_plugins, ...
            plugins.mgenerierung_plugins.string, plugins.mgenerierung_plugins.info_auswahlfenster, ...
            plugins.mgenerierung_plugins.callback] = liesMGenerierungPlugins(var_bez, par, parameter);

