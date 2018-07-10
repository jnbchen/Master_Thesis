% Script ruleaut_callback
%
% mode = 1 Einzelregeln ermitteln
% mode = 2 Regelbasis aus Datei laden
% mode = 3 Regelbasis ermitteln
% 
% nur Gait-CAD spezifische Aufrufe und Nachbereitungen sortieren...
% 
% Name Ausgangsklasse anhängen - das gibt es in Gait-CAD so nicht...
%
% The script ruleaut_callback is part of the MATLAB toolbox Gait-CAD. 
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

dorgbez_rule = char(dorgbez,bez_code(par.y_choice,:));

%berücksichtigt Merkmalauswahl
merkmal_auswahl_rule=get(uihd(11,14),'value');

par_d_org=[length(ind_auswahl) size(d_org,2) 1 max(code)]; 

%design of the fuzzy system
fuzzy_system =ruleaut4(d_org,code,dorgbez_rule,bez_code(par.y_choice,:),zgf_y_bez(par.y_choice,1:par.anz_ling_y(par.y_choice)),par_d_org,ind_auswahl,merkmal_auswahl_rule,interpret_merk,mode,get(uihd(11,27),'value'),parameter.gui.klassifikation.fuzzy_system);
%save output variable name (switch to it if fuzzy system is loaded)
fuzzy_system.output = bez_code(par.y_choice,:);

%Aktivierung Gait-CAD-Menü    
if isfield(fuzzy_system,'rulebase') && ~isempty(fuzzy_system.rulebase)
   enmat = enable_menus(parameter, 'enable_children', {'MI_Fuzzy', 'MI_Ansicht_Fuzzy'});
   fprintf('\n\n%d rules was generated!\n',size(fuzzy_system.rulebase,1));	
   if isempty(find(fuzzy_system.rulebase(1,5:end)))
      fprintf('\n\nHowever, it is only a rule with premise one! \nPlease evaluate the %d selected feature(s) and the output variable (%s)!\n',length(merkmal_auswahl_rule),bez_code(par.y_choice,:));
   end;
else
   enmat = enable_menus(parameter, 'disable_children', {'MI_Fuzzy', 'MI_Ansicht_Fuzzy'}, 'enable', {'MI_Fuzzy_RUBImport', 'MI_Fuzzy_Basis', 'MI_Fuzzy_Einzelregel'});
   fprintf('\n\nNo relevant rule found!\nTake a look to the %d selected features and the selected output variable (%s)!\n',length(merkmal_auswahl_rule),bez_code(par.y_choice,:));
end;


clear par_d_org merkmal_auswahl_rule;

