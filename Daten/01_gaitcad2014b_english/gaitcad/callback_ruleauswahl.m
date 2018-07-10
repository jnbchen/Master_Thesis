% Script callback_ruleauswahl
%
% Nummer der ausgewählten Regel(n) ermitteln
%
% The script callback_ruleauswahl is part of the MATLAB toolbox Gait-CAD. 
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

ind=get(figure_handle(2,1),'value');

switch mode
case 1
   %wird nicht mehr verwendet
   myerror('Obsolete and not more implemented version!');
   
case 2
   %mode=2 Gait-CAD Regel löschen
   if length(ind)<size(fuzzy_system.rulebase,1) 
      fuzzy_system.rulebase(ind,:)=[];
      fuzzy_system.masze=[];
   else 
      myerror('Rule base can not completely deleted!');
   end;   
   fprintf('A rulebase with %d rule(s) was saved.\n.',size(fuzzy_system.rulebase,1));
   
case 3
   %mode=3 Gait-CAD Regelgrafík
   if isfield(fuzzy_system,'aggregation') && fuzzy_system.aggregation == 1
      mywarning('Rules containing aggregated features cannot be displayed');
   else
      translap(fuzzy_system.rulebase(ind,:),fuzzy_system.par_kafka,d_org(ind_auswahl,fuzzy_system.indr_merkmal),code(ind_auswahl),fuzzy_system.zgf,get(uihd(11,18),'value'),get(uihd(11,26),'value'),fuzzy_system.dorgbez_rule,fuzzy_system.zgf_bez,get(uihd(11,9),'value'));
   end;
   
case 4
   %mode=4 KAFKA-Regelbasis manuell zusammenstellen
   %Regelbasis manuell zusammenstellen
   %in der aktuellen Regelbasis manuell auswählen, dann werden alle in Regelbasis übernommen 
   %(Modus 3 in  uihd(11,38) und je nach Einstellungen eine passende Default_Regel dazu gesucht
   %überflüssige Regeln dürfen keinesfalls gelöscht werden!!
   
   %wird z.Zt. nicht mehr verwendet
   myerror('Obsolete and not more implemented version!');
   
   %rulebase=rulebase(ind,:);
   %modetemp=get(uihd(11,38),'value');
   %set(uihd(11,38),'value',4);
   %set(uihd(11,42),'value',2);
   %eval(get(uihd(4,13),'callback'));
   %set(uihd(11,38),'value',modetemp);
   %clear modetemp;
   %savefuzzy_klasssingle;  
     
end;



