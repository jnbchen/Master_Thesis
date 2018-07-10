% Script callback_aggregation
%
% evtl. vorhandene nachgeordnete Schritte werden gelöscht....
%
% The script callback_aggregation is part of the MATLAB toolbox Gait-CAD. 
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

klass_single(one_against_x_indx).merkmalsextraktion.norm_aggregation.type=0;
klass_single(one_against_x_indx).merkmalsextraktion.phi_aggregation=[];
d=erzeuge_datensatz_an(d_org,klass_single(one_against_x_indx).merkmalsextraktion);

%Anzahl ausgewählter Merkmale bestimmen und evtl. korrigieren
% Keine Korrektur! Das kann z.B. bei einer Crossvalidierung böse Effekte haben!
%parameter.gui.klassifikation.anz_hk=str2num(get(uihd(11,75),'string'));

par_kafka_aggr = [length(ind_auswahl) size(d,2) 1 length(unique(code))];

switch aggregation_mode
case 1	%Diskriminanzanalyse
   [phi_dis, phi_last, phi_dis_n, phi_last_n, phi_text] = diskri_en(d, code, ind_auswahl, parameter.gui.klassifikation.anz_hk, [], par_kafka_aggr);	
   phi_aggregation = phi_dis;
   phi_short = 'DA';   
case 2	%Diskriminanzanalyse mit Optimierung
   %Diskriminanzanalyse
   [phi_dis, phi_last, phi_dis_n, phi_last_n, phi_text] = diskri_en(d, code, ind_auswahl, parameter.gui.klassifikation.anz_hk, [], par_kafka_aggr);	
   art = parameter.gui.klassifikation.krit_opt_da;
   if(art == 2)	   %Anpassung von art fuer Funktion mod_diskri
      art = 3;
   end
   %ÄNDERUNG Sebastian (30.09.05): für guete_bestklass-Optimierung wird Distanzmaß benötigt
   optionen.metrik = parameter.gui.klassifikation.krit_opt_da;   
   phi_dis = mod_diskri (d(ind_auswahl,:), code(ind_auswahl,:), phi_dis, art, optionen);
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   phi_aggregation = phi_dis;
   phi_text=sprintf('Optimized Discriminant Analysis: from %d to %d aggregated features',size(phi_dis,1),parameter.gui.klassifikation.anz_hk);
   phi_short = 'Opt. DA';   
case 3	%Hauptkomponentenanalyse
   %Hauptkomponentenanalyse ohne Normieurng in hauptk_ber; Normierung erfolgt in erzeuge_datensatz
   if (size(d,2) < parameter.gui.klassifikation.anz_hk);
      anz_hk = size(d,2);
   else
      anz_hk = parameter.gui.klassifikation.anz_hk;
   end;
   [phi_hk,hkvp,sigma]=hauptk_ber(d(ind_auswahl,:),-1);
   phi_hk=phi_hk(:,1:anz_hk);
   phi_aggregation = phi_hk;
   phi_text=sprintf('Principal Component Analysis (PCA) from %d to %d aggregated features',size(phi_hk));
   phi_short = 'PCA';
case 4 % Independent Component Analysis
   merk_diskri = parameter.gui.klassifikation.anz_hk;
   hk_anzahl = parameter.gui.klassifikation.anz_hk;
   normieren = 0;
   [phi_ica, phi_last, phi_ica_n, phi_last_n, phi_text, d, d_ica] = fastica_en(d, ind_auswahl, merk_diskri, hk_anzahl, [], par_kafka_aggr, normieren);
   
   phi_aggregation = phi_ica;
   phi_short = 'ICA';
case 5 % Mittelwert
   phi_aggregation=ones(size(d,2),1)/size(d,2);
   phi_text = sprintf('Mean value from %d features',size(d,2));
   phi_short = 'MEAN';
case 6 % Summe
   phi_aggregation=ones(size(d,2),1);
   phi_text = sprintf('Sum of %d features',size(d,2));
   phi_short = 'SUM';
end
%Entwurfsergebnisse Aggregation speichern
if (aggregation_mode)
   tmp=[];
   for i=1:size(phi_aggregation,2)
      tmp=strvcatnew(tmp,sprintf('%d. Aggregated Feature (%s)',i,phi_short));
   end;
   
   %Leerzeichen! 
   klass_single(one_against_x_indx).merkmalsextraktion.var_bez = tmp;
   clear varbez_aggregation;
   
   klass_single(one_against_x_indx).merkmalsextraktion.phi_aggregation = phi_aggregation;
   klass_single(one_against_x_indx).merkmalsextraktion.phi_text = phi_text;
else 
   klass_single(one_against_x_indx).merkmalsextraktion.phi_aggregation=[];
end;

%zur Sicherheit alles noch mal neu erzeugen
d=erzeuge_datensatz_an(d_org,klass_single(one_against_x_indx).merkmalsextraktion);

clear aggregation_mode merkmalsextraktion par_kafka_aggr