% Script callback_dsdtem2zr
%
% Zeitreihenschnipsel untzerschiedlicher Läneg raussuchen
% ausgewählte Ausgangsgröße bestimmt die Datentupel (z.B. Patienten-ID, Sensor-ID usw.)
% 
% alte Zeitreihen werden gelöscht
%
% The script callback_dsdtem2zr is part of the MATLAB toolbox Gait-CAD. 
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

%welche Klassen (ind_code) gibt es und wie ist die Auslösung bezüglich der Datentupel (ind_k)
[ind_code,temp,ind_k]=unique(code); 

code_alle_zr=zeros(length(ind_code),size(code_alle,2));

%über alle neuen Datentupel...
for i_dt=1:length(ind_code)
   
   %welche alten Datentupel gehöre zur i_dt.Klasse [ ind_code(i_dt) ] ?
   i_k=find(ind_k==ind_code(i_dt));
   
   %die der Zeitreihe zuweisen
   d_orgs(i_dt, 1:length(i_k), :) = [d_org(i_k,:) code_alle(i_k,:)];
   
   %Anzahl gültige Abtastzeitpunkte pro Zeitreihe merken
   d_org_temp(i_dt,1)=length(i_k);
   
   %eine Klasse gibt es per Definition
   code_zr(i_dt)=ind_code(i_dt);
   %Versuch, alle anderen Klassen zu erhalten
   for i_ca=1:size(code_alle,2)
      %welche Klassen gibt es für die ausgewählte Klasse?
      dt_class=unique(code_alle(i_k,i_ca));
      if length(dt_class)==1
         %wenn identisch, dann übernehmen
         code_alle_zr(i_dt,i_ca)=dt_class;        
      end;
   end;   
end;

if size(d_orgs,2)<2
   d_orgs=[];
   myerror(['Too short time series generated!' ' ' 'Please check the selection of the output variable!']);
end;


%alter Einzelmerkmalsbezeichner ist neuer Zeitreihenbezeichner
var_bez = strvcatnew(dorgbez(1:par.anz_einzel_merk,:),bez_code);

%Codes...
code=code_zr;
code_alle=code_alle_zr;

%inkonsistente Klassen aufräumen...
ind_delete_class= find(any(code_alle==0,1));
ind_delete_time_series= setdiff(1:par.anz_y,ind_delete_class);
if ~isempty(ind_delete_class)
   bez_code(ind_delete_class,:)=[];
   zgf_y_bez(ind_delete_class,:)=[];
   code_alle(:,ind_delete_class)=[];
   par.anz_ling_y(ind_delete_class)=[];
   d_orgs(:,:,par.anz_einzel_merk+ind_delete_time_series)=[];
   var_bez(par.anz_einzel_merk+ind_delete_time_series,:)=[];
end;
par.y_choice=1;
parameter.gui.merkmale_und_klassen.ausgangsgroesse=1;
code=code_alle(:,1);

clear ind_delete_class code_zr code_alle_zr ind_k ind_dt i_k i_ca dt_class temp;

%Auswahl korrigieren
ind_auswahl=1:size(d_orgs,1);

%Einzelmerkmale löschen
d_org=d_org_temp;
dorgbez='Number of valid sample points';
clear d_org_temp;

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
